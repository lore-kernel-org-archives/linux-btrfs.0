Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:36557 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751054AbdILQft (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 12:35:49 -0400
Received: by mail-io0-f196.google.com with SMTP id n69so5643135ioi.3
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Sep 2017 09:35:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGqmi77dYD90ni9H_HMiqD8Tp+y+hfgRRnoKZRGa+QH_+CdFxg@mail.gmail.com>
References: <1505164356-13474-1-git-send-email-jbacik@fb.com>
 <1505164356-13474-9-git-send-email-jbacik@fb.com> <CAGqmi77dYD90ni9H_HMiqD8Tp+y+hfgRRnoKZRGa+QH_+CdFxg@mail.gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Tue, 12 Sep 2017 19:35:08 +0300
Message-ID: <CAGqmi75pFVkzJTVP0O1vY8-vrpq+Sx7T0OQsQ9ZuvBS7jegSTw@mail.gmail.com>
Subject: Re: [PATCH 08/10] btrfs: switch args for comp_*_refs
To: josef@toxicpanda.com
Cc: kernel-team@fb.com, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-09-12 19:21 GMT+03:00 Timofey Titovets <nefelim4ag@gmail.com>:
> 2017-09-12 0:12 GMT+03:00  <josef@toxicpanda.com>:
>> From: Josef Bacik <jbacik@fb.com>
>>
>> Because seriously?  ref2 and then ref1?
>>
>> Signed-off-by: Josef Bacik <jbacik@fb.com>
>> ---
>>  fs/btrfs/delayed-ref.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
>> index 7374710..c5de6c7 100644
>> --- a/fs/btrfs/delayed-ref.c
>> +++ b/fs/btrfs/delayed-ref.c
>> @@ -40,8 +40,8 @@ struct kmem_cache *btrfs_delayed_extent_op_cachep;
>>  /*
>>   * compare two delayed tree backrefs with same bytenr and type
>>   */
>> -static int comp_tree_refs(struct btrfs_delayed_tree_ref *ref2,
>> -                         struct btrfs_delayed_tree_ref *ref1)
>> +static int comp_tree_refs(struct btrfs_delayed_tree_ref *ref1,
>> +                         struct btrfs_delayed_tree_ref *ref2)
>>  {
>>         if (ref1->node.type == BTRFS_TREE_BLOCK_REF_KEY) {
>>                 if (ref1->root < ref2->root)
>> @@ -60,8 +60,8 @@ static int comp_tree_refs(struct btrfs_delayed_tree_ref *ref2,
>>  /*
>>   * compare two delayed data backrefs with same bytenr and type
>>   */
>> -static int comp_data_refs(struct btrfs_delayed_data_ref *ref2,
>> -                         struct btrfs_delayed_data_ref *ref1)
>> +static int comp_data_refs(struct btrfs_delayed_data_ref *ref1,
>> +                         struct btrfs_delayed_data_ref *ref2)
>>  {
>>         if (ref1->node.type == BTRFS_EXTENT_DATA_REF_KEY) {
>>                 if (ref1->root < ref2->root)
>> --
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Result of that function does not used anywhere (i.e. only as bool),
> may be let's rename that like:
>   compr_tree_refs_eq()
> and simplify to
>   if (ref1->root != ref2->root)
>        return 0;
>
> (same for comp_data_refs())
>
> This can made that more obvious and remove useless if. as that not
> used in any "sorting" code
>
> Thanks.
>
> Reviewed-by: Timofey Titovets <nefelim4ag@gmail.com>
>
> --
> Have a nice day,
> Timofey.

Oh, sorry, you want convert list to RB tree, so result will be used.
Just ignore my comment.

-- 
Have a nice day,
Timofey.
