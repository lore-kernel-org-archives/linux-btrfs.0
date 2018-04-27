Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:50260 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752030AbeD0DXY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Apr 2018 23:23:24 -0400
Received: by mail-it0-f66.google.com with SMTP id p3-v6so296392itc.0
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Apr 2018 20:23:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180426180659.GX21272@twin.jikos.cz>
References: <1524706063-93210-1-git-send-email-bo.liu@linux.alibaba.com> <20180426180659.GX21272@twin.jikos.cz>
From: Liu Bo <obuil.liubo@gmail.com>
Date: Fri, 27 Apr 2018 11:23:23 +0800
Message-ID: <CANQeFDBF7RwCufPa7s782fPsw60JBRq70ue_Dq7O__M0XFxaew@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: set keep_lock when necessary in btrfs_defrag_leaves
To: David Sterba <dsterba@suse.cz>, Liu Bo <bo.liu@linux.alibaba.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 27, 2018 at 2:06 AM, David Sterba <dsterba@suse.cz> wrote:
> On Thu, Apr 26, 2018 at 09:27:43AM +0800, Liu Bo wrote:
>> path->keep_lock may force to lock tree root and higher nodes, and make
>> lock contention worse, thus it needs to be avoided as much as
>> possible.
>>
>> In btrfs_degrag_leaves, path->keep_lock is set but @path immediatley
>> gets released, which is not necessary at all.
>
> So what is the effect of this? The locks are held throughout
> btrfs_search_forward and released after that. Thi
>
>> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
>> ---
>> v2: update commit log with more details.
>>
>>  fs/btrfs/tree-defrag.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/tree-defrag.c b/fs/btrfs/tree-defrag.c
>> index 3c0987ab587d..c12747904d4c 100644
>> --- a/fs/btrfs/tree-defrag.c
>> +++ b/fs/btrfs/tree-defrag.c
>> @@ -65,8 +65,6 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
>>               memcpy(&key, &root->defrag_progress, sizeof(key));
>>       }
>>
>> -     path->keep_locks = 1;
>> -
>>       ret = btrfs_search_forward(root, &key, path, BTRFS_OLDEST_GENERATION);
>
> What does btrfs_search_forward do as the first statement:
>
> 5115 int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
> 5116                          struct btrfs_path *path,
> 5117                          u64 min_trans)
> 5118 {
> .... declarations
> 5128
> 5129         path->keep_locks = 1;
>
> So even if removed from above, there will be no change. The value of
> keep_locks is preserved after btrfs_path_release.
>

It will set it back,

out:
        path->keep_locks = keep_locks;


thanks,
liubo
>>       if (ret < 0)
>>               goto out;
>> @@ -81,6 +79,7 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
>>        * a deadlock (attempting to write lock an already write locked leaf).
>>        */
>>       path->lowest_level = 1;
>> +     path->keep_locks = 1;
>>       wret = btrfs_search_slot(trans, root, &key, path, 0, 1);
>>
>>       if (wret < 0) {
>> --
>> 1.8.3.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
