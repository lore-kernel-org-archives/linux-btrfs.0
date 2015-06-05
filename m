Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:36569 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255AbbFEIqr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jun 2015 04:46:47 -0400
Received: by igbpi8 with SMTP id pi8so10611052igb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Jun 2015 01:46:46 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAJiZgcpsd+8wOTK5C8Q9usX52uRADfGo3FxyozWfowRwsoMj+A@mail.gmail.com>
References: <1433416690-19177-1-git-send-email-robbieko@synology.com>
	<1433416690-19177-2-git-send-email-robbieko@synology.com>
	<CAL3q7H4Vrw7q3pBLATSO03P=GYopYPHBiWyTG1rrO-E1vpTL3g@mail.gmail.com>
	<CAL3q7H4=EaDbAFRPoVYKBDntF-81PWQMc6h_7iidqUerHKB_jw@mail.gmail.com>
	<CAJiZgcpsd+8wOTK5C8Q9usX52uRADfGo3FxyozWfowRwsoMj+A@mail.gmail.com>
Date: Fri, 5 Jun 2015 09:46:46 +0100
Message-ID: <CAL3q7H49uCZmjRg8-Jd_v+=FzJHrk1yX=8pykG2fpYaT4so5aA@mail.gmail.com>
Subject: Re: [PATCH 1/5] Btrfs: incremental send, avoid circular waiting and
 descendant overwrite ancestor need to update path
From: Filipe David Manana <fdmanana@gmail.com>
To: Robbie Ko <robbieko@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 5, 2015 at 4:55 AM, Robbie Ko <robbieko@synology.com> wrote:
> Hi Filipe,
>
> There is another case for  2nd scenario where is_ancestor() can't be used.

So it's a 3rd case and not the 2nd one anymore. We must have an
xfstest for this case too.

>
> Parent snapshot:
> |---- a/ (ino 261)
>   |---- c (ino 267)
> |---- d/ (ino 259)
>   |---- ance/ (ino 266)
>     |---- waiting_dir/ (ino 262)
> |---- pre/ (ino 264)
>   |---- ance/ (ino 265)
>
> Send snapshot:
> |---- a/ (ino 261)
>   |---- ance/ (ino 266)
> |---- c (ino 267)
>   |---- waiting_dir/ (ino 262)
>     |---- pre/ (ino 264)
> |---- d/ (ino 259)
>   |---- ance/ (ino 265)
>
> First, 262 can't move to c/waiting_dir without the rename of inode 267.
> Second, 264 can move into dir 262. Although 262 is waiting, 264 is not
> parent of 262 in the parent root.
> (The second behavior will happen after applying "[PATCH] Btrfs:
> incremental send, don't delay directory renames unnecessarily")
> Finally, 265 will overwrite 266 and path for 265 should be updated
> since 266 is not the ancestor of 265.
> Here we need to check the current state of tree rather than parent
> root which  is_ancestor function does.

Right. But comparing full paths is not the way the go for the reasons
mentioned previously. So get_cur_path() gives us the full path of an
inode based on the current state (i.e. the state of directory
hierarchy on the receiving side after applying all operations issued
in the send stream so far). That means we can use that code (write a
new function similar to it) to determine if some inode is currently an
ancestor of some other inode by walking up hierarchy and comparing
inode numbers and generation numbers - that's the only correct way.

But we can make it more simple than writing such a new function that
would be similar to get_cur_path()... Just reset valid_path and
compute again after orphanizing a conflicting entry - i.e. don't
bother checking for ancestry.

So that the previous patch would be (also at
https://friendpaste.com/6jdXdYPdC6YFffwNL6V563):

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 3c38879..d34df19 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3629,16 +3629,6 @@ verbose_printk("btrfs: process_recorded_refs
%llu\n", sctx->cur_ino);
  if (ret) {
  struct name_cache_entry *nce;
  struct waiting_dir_move *wdm;
- bool cur_is_ancestor = false;
-
- /*
- * check is dset path is ancestor src path
- * if yes, need to update cur_ino path
- */
- if (strncmp(cur->full_path->start, valid_path->start,
fs_path_len(cur->full_path)) == 0 &&
- fs_path_len(valid_path) > fs_path_len(cur->full_path) &&
valid_path->start[fs_path_len(cur->full_path)] == '/') {
- cur_is_ancestor = true;
- }

  ret = orphanize_inode(sctx, ow_inode, ow_gen,
  cur->full_path);
@@ -3672,15 +3662,18 @@ verbose_printk("btrfs: process_recorded_refs
%llu\n", sctx->cur_ino);
  }

  /*
- * if ow_inode is ancestor cur_ino, need to update
- * update cur_ino path.
+ * ow_inode might currently be an ancestor of
+ * cur_ino, therefore compute valid_path (the
+ * current path of cur_ino) again because it
+ * might contain the pre-orphanization name of
+ * ow_inode, which is no longer valid.
  */
- if (cur_is_ancestor) {
- fs_path_reset(valid_path);
- ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, valid_path);
- if (ret < 0)
- goto out;
- }
+ fs_path_reset(valid_path);
+ ret = get_cur_path(sctx, sctx->cur_ino,
+   sctx->cur_inode_gen,
+   valid_path);
+ if (ret < 0)
+ goto out;
  } else {
  ret = send_unlink(sctx, cur->full_path);
  if (ret < 0)


>
> Thanks
> Robbie Ko
>
> 2015-06-05 3:19 GMT+08:00 Filipe David Manana <fdmanana@gmail.com>:
>> On Thu, Jun 4, 2015 at 2:50 PM, Filipe David Manana <fdmanana@gmail.com> wrote:
>>> On Thu, Jun 4, 2015 at 12:18 PM, Robbie Ko <robbieko@synology.com> wrote:
>>>> Base on [PATCH] Btrfs: incremental send, check if orphanized dir inode needs delayed rename
>>>>
>>>> Example1:
>>>> There's one case where we can't issue a rename operation for a directory
>>>> immediately when we process it.
>>>>
>>>> Parent snapshot:
>>>> |---- d/ (ino 257)
>>>>   |---- p1 (ino 258)
>>>> |---- p1/ (ino 259)
>>>>
>>>> Send snapshot:
>>>> |---- d/ (ino 257)
>>>>   |---- p1 (ino 259)
>>>>     |---- p1/ (ino 258)
>>>>
>>>> Here we can not rename 258 from d/p1 to p1/p1 without the rename of inode 259.
>>>> p1 258 is put into wait_parent_move. 259 can't be rename to d/p1, so it is put into
>>>> circular waiting happens.
>>>
>>> "... into circular waiting happens" -> so 259's rename is delayed to
>>> happen after 258's rename, which creates a circular dependency (258 ->
>>> 259 -> 258).
>>>
>>>> This is fix by rename destination directory and set
>>>> it as orphanized for this case.
>>>>
>>>> Example2:
>>>> There's one case where we can't issue a rename operation for a directory
>>>> immediately we process it.
>>>> After moving 262 outside, path of 265 is stored in the name_cache_entry.
>>>> When 263 try to overwrite 265, its ancestor, 265 is moved to orphanized. Path of 263
>>>> is still the original path, however. This causes error.
>>>
>>> For the sake of a more complete/informative change log, can you
>>> mention what's the error?
>>>
>>>>
>>>> Parent snapshot:
>>>> |---- a/ (ino 259)
>>>>   |---- c (ino 266)
>>>> |---- d/ (ino 260)
>>>>   |---- ance (ino 265)
>>>>     |---- e (ino 261)
>>>>     |---- f (ino 262)
>>>>     |---- ance (ino 263)
>>>>
>>>> Send snapshot:
>>>> |---- a/ (ino 259)
>>>> |---- c/ (ino 266)
>>>>   |---- ance (ino 265)
>>>> |---- d/ (ino 260)
>>>>   |---- ance (ino 263)
>>>> |---- f/ (ino 262)
>>>>   |---- e (ino 261)
>>>>
>>>> Signed-off-by: Robbie Ko <robbieko@synology.com>
>>>> ---
>>>>  fs/btrfs/send.c | 45 ++++++++++++++++++++++++++++++++++++++++-----
>>>>  1 file changed, 40 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
>>>> index 1c1f161..fbfbb8b 100644
>>>> --- a/fs/btrfs/send.c
>>>> +++ b/fs/btrfs/send.c
>>>> @@ -230,7 +230,6 @@ struct pending_dir_move {
>>>>         u64 parent_ino;
>>>>         u64 ino;
>>>>         u64 gen;
>>>> -       bool is_orphan;
>>>>         struct list_head update_refs;
>>>>  };
>>>>
>>>> @@ -1840,7 +1839,7 @@ static int will_overwrite_ref(struct send_ctx *sctx, u64 dir, u64 dir_gen,
>>>>          * was already unlinked/moved, so we can safely assume that we will not
>>>>          * overwrite anything at this point in time.
>>>>          */
>>>> -       if (other_inode > sctx->send_progress) {
>>>> +       if (other_inode > sctx->send_progress || is_waiting_for_move(sctx, other_inode)) {
>>>>                 ret = get_inode_info(sctx->parent_root, other_inode, NULL,
>>>>                                 who_gen, NULL, NULL, NULL, NULL);
>>>>                 if (ret < 0)
>>>> @@ -3014,7 +3013,6 @@ static int add_pending_dir_move(struct send_ctx *sctx,
>>>>         pm->parent_ino = parent_ino;
>>>>         pm->ino = ino;
>>>>         pm->gen = ino_gen;
>>>> -       pm->is_orphan = is_orphan;
>>>>         INIT_LIST_HEAD(&pm->list);
>>>>         INIT_LIST_HEAD(&pm->update_refs);
>>>>         RB_CLEAR_NODE(&pm->node);
>>>> @@ -3091,6 +3089,7 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
>>>>         struct waiting_dir_move *dm = NULL;
>>>>         u64 rmdir_ino = 0;
>>>>         int ret;
>>>> +       bool is_orphan;
>>>>
>>>>         name = fs_path_alloc();
>>>>         from_path = fs_path_alloc();
>>>> @@ -3102,9 +3101,10 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
>>>>         dm = get_waiting_dir_move(sctx, pm->ino);
>>>>         ASSERT(dm);
>>>>         rmdir_ino = dm->rmdir_ino;
>>>> +       is_orphan = dm->orphanized;
>>>>         free_waiting_dir_move(sctx, dm);
>>>>
>>>> -       if (pm->is_orphan) {
>>>> +       if (is_orphan) {
>>>>                 ret = gen_unique_name(sctx, pm->ino,
>>>>                                       pm->gen, from_path);
>>>>         } else {
>>>> @@ -3292,6 +3292,7 @@ static int wait_for_dest_dir_move(struct send_ctx *sctx,
>>>>         u64 left_gen;
>>>>         u64 right_gen;
>>>>         int ret = 0;
>>>> +       struct waiting_dir_move *wdm;
>>>>
>>>>         if (RB_EMPTY_ROOT(&sctx->waiting_dir_moves))
>>>>                 return 0;
>>>> @@ -3350,7 +3351,8 @@ static int wait_for_dest_dir_move(struct send_ctx *sctx,
>>>>                 goto out;
>>>>         }
>>>>
>>>> -       if (is_waiting_for_move(sctx, di_key.objectid)) {
>>>> +       wdm = get_waiting_dir_move(sctx, di_key.objectid);
>>>> +       if (wdm && !wdm->orphanized) {
>>>>                 ret = add_pending_dir_move(sctx,
>>>>                                            sctx->cur_ino,
>>>>                                            sctx->cur_inode_gen,
>>>> @@ -3610,11 +3612,33 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
>>>>                                 goto out;
>>>>                         if (ret) {
>>>>                                 struct name_cache_entry *nce;
>>>> +                               struct waiting_dir_move *wdm;
>>>> +                               bool cur_is_ancestor = false;
>>>> +
>>>> +                               /*
>>>> +                                * check is dset path is ancestor src path
>>>> +                                * if yes, need to update cur_ino path
>>>> +                                */
>>>
>>> Typos/confusing comment and doesn't explain why the following check is
>>> being done.
>>>
>>>> +                               if (strncmp(cur->full_path->start, valid_path->start, fs_path_len(cur->full_path)) == 0 &&
>>>> +                                                       fs_path_len(valid_path) > fs_path_len(cur->full_path) && valid_path->start[fs_path_len(cur->full_path)] == '/') {
>>>
>>> At a first glance it seems confusing why we are comparing substrings
>>> of an entire path instead of just the old and new names for the
>>> current and the conflicting (ow_inode) inodes and their parent inode
>>> numbers and generation. I think the comment should explain why.
>>
>> So you can determine if ow_inode is an ancestor of cur_ino in the
>> parent snapshot using is_ancestor(), which is less error prone than
>> comparing partial path strings and consistent with the existing code
>> base, as it takes into account inode and generation numbers for each
>> path component.
>>
>> E.g. the following patch on top of your patch makes at least the 2nd
>> scenario in the commit message work as well (I've fixed long lines and
>> the comment as well, also pasted at
>> https://friendpaste.com/KEIIBZ8H1F1t3trdjv0bH). What do you think?
>>
>> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
>> index 3c38879..d909892 100644
>> --- a/fs/btrfs/send.c
>> +++ b/fs/btrfs/send.c
>> @@ -3629,16 +3629,7 @@ verbose_printk("btrfs: process_recorded_refs
>> %llu\n", sctx->cur_ino);
>>                         if (ret) {
>>                                 struct name_cache_entry *nce;
>>                                 struct waiting_dir_move *wdm;
>> -                               bool cur_is_ancestor = false;
>> -
>> -                               /*
>> -                                * check is dset path is ancestor src path
>> -                                * if yes, need to update cur_ino path
>> -                                */
>> -                               if (strncmp(cur->full_path->start,
>> valid_path->start, fs_path_len(cur->full_path)) == 0 &&
>> -
>> fs_path_len(valid_path) > fs_path_len(cur->full_path) &&
>> valid_path->start[fs_path_len(cur->full_path)] == '/') {
>> -                                       cur_is_ancestor = true;
>> -                               }
>> +                               struct fs_path *tmp_path;
>>
>>                                 ret = orphanize_inode(sctx, ow_inode, ow_gen,
>>                                                 cur->full_path);
>> @@ -3672,12 +3663,27 @@ verbose_printk("btrfs: process_recorded_refs
>> %llu\n", sctx->cur_ino);
>>                                 }
>>
>>                                 /*
>> -                                * if ow_inode is ancestor cur_ino,
>> need to update
>> -                                * update cur_ino path.
>> +                                * If ow_inode is an ancestor of cur_ino in the
>> +                                * parent root, compute valid_path again because
>> +                                * it contains the pre-orphanization name of
>> +                                * ow_inode, which is no longer valid.
>>                                  */
>> -                               if (cur_is_ancestor) {
>> +                               tmp_path = fs_path_alloc();
>> +                               if (!tmp_path) {
>> +                                       ret = -ENOMEM;
>> +                                       goto out;
>> +                               }
>> +                               ret = is_ancestor(sctx->parent_root,
>> +                                                 ow_inode, ow_gen,
>> +                                                 sctx->cur_ino, tmp_path);
>> +                               fs_path_free(tmp_path);
>> +                               if (ret < 0)
>> +                                       goto out;
>> +                               if (ret == 1) {
>>                                         fs_path_reset(valid_path);
>> -                                       ret = get_cur_path(sctx,
>> sctx->cur_ino, sctx->cur_inode_gen, valid_path);
>> +                                       ret = get_cur_path(sctx, sctx->cur_ino,
>> +                                                          sctx->cur_inode_gen,
>> +                                                          valid_path);
>>                                         if (ret < 0)
>>                                                 goto out;
>>                                 }
>>
>>>
>>> Also please try to keep lines up to 80 characters (that line is 169
>>> characters long).
>>> You can run ./scripts/checkpatch.pl to validate your patch files and
>>> warn you if the code doesn't comply to the coding standard.
>>>
>>>> +                                       cur_is_ancestor = true;
>>>> +                               }
>>>>
>>>>                                 ret = orphanize_inode(sctx, ow_inode, ow_gen,
>>>>                                                 cur->full_path);
>>>>                                 if (ret < 0)
>>>>                                         goto out;
>>>> +
>>>> +                               /*
>>>> +                                * check is waiting dir, if yes change the ino
>>>> +                                * to orphanized in the waiting tree.
>>>> +                                */
>>>> +                               if (is_waiting_for_move(sctx, ow_inode)) {
>>>> +                                       wdm = get_waiting_dir_move(sctx, ow_inode);
>>>> +                                       ASSERT(wdm);
>>>> +                                       wdm->orphanized = true;
>>>> +                               }
>>>> +
>>>>                                 /*
>>>>                                  * Make sure we clear our orphanized inode's
>>>>                                  * name from the name cache. This is because the
>>>> @@ -3630,6 +3654,17 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
>>>>                                         name_cache_delete(sctx, nce);
>>>>                                         kfree(nce);
>>>>                                 }
>>>> +
>>>> +                               /*
>>>> +                                * if ow_inode is ancestor cur_ino, need to update
>>>> +                                * update cur_ino path.
>>>> +                                */
>>>
>>> "If ow_inode is an ancestor of cur_ino in the send snapshot, update
>>> valid_path because ow_inode was orphanized and valid_path contains its
>>> pre-orphanization name, which is not valid anymore".
>>>
>>>> +                               if (cur_is_ancestor) {
>>>> +                                       fs_path_reset(valid_path);
>>>> +                                       ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, valid_path);
>>>> +                                       if (ret < 0)
>>>> +                                               goto out;
>>>> +                               }
>>>>                         } else {
>>>>                                 ret = send_unlink(sctx, cur->full_path);
>>>>                                 if (ret < 0)
>>>> --
>>>> 1.9.1
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>>
>>> --
>>> Filipe David Manana,
>>>
>>> "Reasonable men adapt themselves to the world.
>>>  Unreasonable men adapt the world to themselves.
>>>  That's why all progress depends on unreasonable men."
>>
>>
>>
>> --
>> Filipe David Manana,
>>
>> "Reasonable men adapt themselves to the world.
>>  Unreasonable men adapt the world to themselves.
>>  That's why all progress depends on unreasonable men."



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
