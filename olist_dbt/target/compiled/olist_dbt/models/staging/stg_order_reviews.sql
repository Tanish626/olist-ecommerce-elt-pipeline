select
    review_id,
    order_id,
    review_score::int                       as review_score,
    review_comment_title                    as comment_title,
    review_comment_message                  as comment_message,
    review_creation_date::timestamp         as review_created_at,
    review_answer_timestamp::timestamp      as review_answered_at
from "olist"."raw"."order_reviews"