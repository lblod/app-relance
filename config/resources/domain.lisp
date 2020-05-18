(in-package :mu-cl-resources)

;;;;
;; NOTE
;; docker-compose stop; docker-compose rm; docker-compose up
;; after altering this file.

;; Describe your resources here

;; The general structure could be described like this:
;;
;; (define-resource <name-used-in-this-file> ()
;;   :class <class-of-resource-in-triplestore>
;;   :properties `((<json-property-name-one> <type-one> ,<triplestore-relation-one>)
;;                 (<json-property-name-two> <type-two> ,<triplestore-relation-two>>))
;;   :has-many `((<name-of-an-object> :via ,<triplestore-relation-to-objects>
;;                                    :as "<json-relation-property>")
;;               (<name-of-an-object> :via ,<triplestore-relation-from-objects>
;;                                    :inverse t ; follow relation in other direction
;;                                    :as "<json-relation-property>"))
;;   :has-one `((<name-of-an-object :via ,<triplestore-relation-to-object>
;;                                  :as "<json-relation-property>")
;;              (<name-of-an-object :via ,<triplestore-relation-from-object>
;;                                  :as "<json-relation-property>"))
;;   :resource-base (s-url "<string-to-which-uuid-will-be-appended-for-uri-of-new-items-in-triplestore>")
;;   :on-path "<url-path-on-which-this-resource-is-available>")


;; An example setup with a catalog, dataset, themes would be:
;;
(define-resource local-business ()
  :class (s-prefix "schema:LocalBusiness")
  :properties `((:name :string ,(s-prefix "schema:name"))
                (:description :string ,(s-prefix "schema:description"))
                (:url :string ,(s-prefix "schema:url"))
                (:email :string ,(s-prefix "schema:email"))
                (:telephone :string ,(s-prefix "schema:telephone")))
  :has-one `((location :via ,(s-prefix "schema:location")
                       :as "location"))
  :has-many `((category :via ,(s-prefix "ext:category")
                        :as "categories")
              (opening-hours-specification :via ,(s-prefix "schema:openingHoursSpecification")
                                           :as "openingHoursSpecifications"))
  :resource-base (s-url "http://data.relance.lblod.info/id/local-businesses/")
  :on-path "local-businesses")

(define-resource location ()
  :class (s-prefix "schema:PostalAddress")
  :properties `((:street-address :string ,(s-prefix "schema:streetAddress"))
                (:postal-code :string ,(s-prefix "schema:postalCode"))
                (:city :string ,(s-prefix "schema:addressLocality"))
                (:country :string ,(s-prefix "schema:addressCountry")))
  :has-many `((local-business :via ,(s-prefix "schema:location")
                              :inverse t
                              :as "local-businesses"))
  :resource-base (s-url "http://data.relance.lblod.info/id/locations/")
  :on-path "locations")

(define-resource category ()
  :class (s-prefix "ext:Category")
  :properties `((:label :string ,(s-prefix "skos:prefLabel")))
  :resource-base (s-url "http://data.relance.lblod.info/id/categories/")
  :features '(include-uri)
  :on-path "categories")

(define-resource opening-hours-specification ()
  :class (s-prefix "schema:OpeningHoursSpecification")
  :properties `((:valid-from :date ,(s-prefix "schema:validFrom"))
                (:valid-through :date ,(s-prefix "schema:validThrough"))
                (:opens :string ,(s-prefix "schema:opens"))
                (:closes :string ,(s-prefix "schema:closes")))
  :has-one `((local-business :via ,(s-prefix "schema:openingHoursSpecification")
                             :inverse t
                             :as "local-business")
             (day-of-week :via ,(s-prefix "schema:dayOfWeek")
                          :as "day-of-week"))
  :resource-base (s-url "http://data.relance.lblod.info/id/opening-hours-specifications/")
  :on-path "opening-hours-specifications")

(define-resource day-of-week ()
  :class (s-prefix "schema:DayOfWeek")
  :properties `((:name :string ,(s-prefix "schema:name")))
  :resource-base (s-url "http://data.relance.lblod.info/id/day-of-weeks/")
  :features '(include-uri)
  :on-path "day-of-weeks")
