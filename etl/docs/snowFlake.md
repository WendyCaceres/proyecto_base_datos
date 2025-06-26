```mermaid
erDiagram
    fact_transactions {
        INT id
        INT trainer_id
        INT city_id
        INT theme_id
        INT amount
    }

    dim_trainer {
        INT id
        TEXT name
    }

    dim_city {
        INT id
        TEXT city_name
        INT region_id
    }

    dim_region {
        INT id
        TEXT region_name
    }

    dim_theme {
        INT id
        TEXT theme
    }

    fact_transactions }o--|| dim_trainer : references
    fact_transactions }o--|| dim_city : references
    dim_city }o--|| dim_region : references
    fact_transactions }o--|| dim_theme : references

```