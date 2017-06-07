Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:33789 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751742AbdFGLCn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 07:02:43 -0400
Received: by mail-qk0-f194.google.com with SMTP id 76so779489qkz.0
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Jun 2017 04:02:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL3q7H7m0XmLDYoox6QeuiwGw6sw-ftTp-TDgO+PdJBj-i39ig@mail.gmail.com>
References: <20170607005844.2078-1-nefelim4ag@gmail.com> <20170607005844.2078-7-nefelim4ag@gmail.com>
 <CAL3q7H7m0XmLDYoox6QeuiwGw6sw-ftTp-TDgO+PdJBj-i39ig@mail.gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Wed, 7 Jun 2017 14:01:46 +0300
Message-ID: <CAGqmi75iWukq=EVc7EnECywTwJz3wjyye==Hy3eMrY6SgcfmvQ@mail.gmail.com>
Subject: Re: [PATCH 6/7] Btrfs: __tree_mod_log_insert decrease max compare count
To: Filipe Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-06-07 12:45 GMT+03:00 Filipe Manana <fdmanana@gmail.com>:
> On Wed, Jun 7, 2017 at 1:58 AM, Timofey Titovets <nefelim4ag@gmail.com> wrote:
>> In worst case code do 4 comparison,
>> just add some new checks to switch check branch faster
>> now in worst case code do 3 comparison
>
> Some comments below.
>
>>
>> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
>> ---
>>  fs/btrfs/ctree.c | 20 +++++++++++---------
>>  1 file changed, 11 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>> index a3a75f1de..318379531 100644
>> --- a/fs/btrfs/ctree.c
>> +++ b/fs/btrfs/ctree.c
>> @@ -460,15 +460,17 @@ __tree_mod_log_insert(struct btrfs_fs_info *fs_info, struct tree_mod_elem *tm)
>>         while (*new) {
>>                 cur = rb_entry(*new, struct tree_mod_elem, node);
>>                 parent = *new;
>> -               if (cur->logical < tm->logical)
>> -                       new = &((*new)->rb_left);
>> -               else if (cur->logical > tm->logical)
>> -                       new = &((*new)->rb_right);
>> -               else if (cur->seq < tm->seq)
>> -                       new = &((*new)->rb_left);
>> -               else if (cur->seq > tm->seq)
>> -                       new = &((*new)->rb_right);
>> -               else
>> +               if (cur->logical != tm->logical) {
>> +                       if (cur->logical < tm->logical)
>> +                               new = &((*new)->rb_left);
>
> So now when cur->logical is less then tm->logical, we do 2 comparisons
> instead of 1.
> Is this case much less common always? If it were it could be a good change.
> What guarantees that this change will give better performance for
> common workloads? What guarantees you the example I just gave isn't
> typical for most/many common workloads?
>
> And most importantly, did you actually do some benchmarks that justify
> this change? Is this a hot code path that would benefit from such
> changes?
> (Since it's the tree mod log, seldom used, I really doubt it).
>
> Same comments apply to all the other similar patches you have sent.
>
> thanks
>

Nope, i just lack of expirience to do such benchmarks,
same for understand all btrfs code, it's difficult to say that path is hot/cold.

I just did reread all btrfs code, analize that i understand and trying
fix places that looks questionably.

In most cases i can explain why this can help (IMHO):
01 - __compare_inode_defrag - we compare inodes, by my expirience
in most distros and setups btrfs have 1-2 subvolumes (root_ids), so in
most time root_id1 == root_id2
02 - backref_comp - same
03 - ref_node_cmp - same
04 - ref_tree_add - just a cleanup, compiller do the same
https://godbolt.org/g/Ww93ws
05 - add_all_parents - just a cleanup, compiller do the same
https://godbolt.org/g/srSGeW
07 - end_workqueue_bio - if i understand correctly this code executed
on every write,
so by convertion to switch case will save several cpu cycles on every write

For that function (06 -  __tree_mod_log_insert):
i do the same as for 01-03 "by inertia" - as i just not know all code,
i just assume that as this fuction work with rb tree, values will be
equally distributed

Thanks
-- 
Have a nice day,
Timofey.
