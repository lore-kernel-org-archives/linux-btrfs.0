Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:57337 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab3AHUL0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2013 15:11:26 -0500
Received: by mail-ie0-f176.google.com with SMTP id 13so1059844iea.7
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Jan 2013 12:11:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOcd+r2L-Pne=SuPGNeD0=0L-BV+dTi3Zb1ZbqMo5LY4e2vGZA@mail.gmail.com>
References: <1354158719-15615-1-git-send-email-chenyang.fnst@cn.fujitsu.com>
	<CAB9VWqASM9E4pwbJbgFC4ZQFSJxbpYMrV-Opn73CyuZk_FDXrg@mail.gmail.com>
	<CAOcd+r2L-Pne=SuPGNeD0=0L-BV+dTi3Zb1ZbqMo5LY4e2vGZA@mail.gmail.com>
Date: Tue, 8 Jan 2013 22:11:24 +0200
Message-ID: <CAOcd+r1frJugQ1U7ox63FhVJ4VdqnN4akusrhQYgyaLyjsgm1A@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: send - sparse file support for btrfs-send mechanism
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Alexander Block <ablock84@gmail.com>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>,
        Chen Yang <chenyang.fnst@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Arne Jansen <sensille@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I believe there are two more cases, where we can safely avoid shipping
disknr=0 extent. These are cases, in which the file grows between the
two snapshots, and some of the new extents are no-data extents. So the
whole patch becomes:


diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 5445454..0bd96fe 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3839,17 +3839,18 @@ static int is_extent_unchanged(struct send_ctx *sctx,
 	/*
 	 * Handle special case where the right side has no extents at all.
 	 */
 	eb = path->nodes[0];
 	slot = path->slots[0];
 	btrfs_item_key_to_cpu(eb, &found_key, slot);
 	if (found_key.objectid != key.objectid ||
 	    found_key.type != key.type) {
-		ret = 0;
+	    /* No need to send a no-data extent it in this case */
+		ret = (left_disknr == 0) ? 1 : 0;
 		goto out;
 	}

 	/*
 	 * We're now on 2a, 2b or 7.
 	 */
 	key = found_key;
 	while (key.offset < ekey->offset + left_len) {
@@ -3865,17 +3866,18 @@ static int is_extent_unchanged(struct send_ctx *sctx,
 			goto out;
 		}

 		/*
 		 * Are we at extent 8? If yes, we know the extent is changed.
 		 * This may only happen on the first iteration.
 		 */
 		if (found_key.offset + right_len <= ekey->offset) {
-			ret = 0;
+			/* No need to send a no-data extent it in this case */
+			ret = (left_disknr == 0) ? 1 : 0;
 			goto out;
 		}

 		left_offset_fixed = left_offset;
 		if (key.offset < ekey->offset) {
 			/* Fix the right offset for 2a and 7. */
 			right_offset += ekey->offset - key.offset;
 		} else {
@@ -3946,16 +3948,38 @@ static int process_extent(struct send_ctx *sctx,
 	if (sctx->parent_root && !sctx->cur_inode_new) {
 		ret = is_extent_unchanged(sctx, path, key);
 		if (ret < 0)
 			goto out;
 		if (ret) {
 			ret = 0;
 			goto out;
 		}
+	} else {
+		struct extent_buffer *eb;
+		struct btrfs_file_extent_item *ei;
+		u8 extent_type;
+		u64 extent_disknr;
+
+		eb = path->nodes[0];
+		ei = btrfs_item_ptr(eb, path->slots[0],
+				struct btrfs_file_extent_item);
+
+		extent_type = btrfs_file_extent_type(eb, ei);
+		extent_disknr = btrfs_file_extent_disk_bytenr(eb, ei);
+		if (extent_type == BTRFS_FILE_EXTENT_REG && extent_disknr == 0) {
+			/*
+			 * This is disknr=0 extent in a full-send or a new inode
+			 * in a diff-send. Since we will send truncate command
+			 * in finish_inode_if_needed anyways, the inode size will be
+			 * correct, and we don't have to send all-zero data.
+			 */
+			ret = 0;
+			goto out;
+		}
 	}

 	ret = find_extent_clone(sctx, path, key->objectid, key->offset,
 			sctx->cur_inode_size, &found_clone);
 	if (ret != -ENOENT && ret < 0)
 		goto out;

 	ret = send_write_or_clone(sctx, path, key, found_clone);


Alex.


On Tue, Jan 8, 2013 at 6:06 PM, Alex Lyakas <alex@zadarastorage.com> wrote:
> Hi Chen, Alexander, Jan,
> how about the following patch: it works for disknr==0 extents (to
> handle PREALLOC extents correctly, we need to add a new command, which
> will break existing btrfs-progs, because they are updated slower than
> the kernel side).
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 5445454..2b46d92 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -3946,16 +3946,38 @@ static int process_extent(struct send_ctx *sctx,
>         if (sctx->parent_root && !sctx->cur_inode_new) {
>                 ret = is_extent_unchanged(sctx, path, key);
>                 if (ret < 0)
>                         goto out;
>                 if (ret) {
>                         ret = 0;
>                         goto out;
>                 }
> +       } else {
> +               struct extent_buffer *eb;
> +               struct btrfs_file_extent_item *ei;
> +               u8 extent_type;
> +               u64 extent_disknr;
> +
> +               eb = path->nodes[0];
> +               ei = btrfs_item_ptr(eb, path->slots[0],
> +                               struct btrfs_file_extent_item);
> +
> +               extent_type = btrfs_file_extent_type(eb, ei);
> +               extent_disknr = btrfs_file_extent_disk_bytenr(eb, ei);
> +               if (extent_type == BTRFS_FILE_EXTENT_REG &&
> extent_disknr == 0) {
> +                       /*
> +                        * This is disknr=0 extent in a full-send or a new inode
> +                        * in a diff-send. Since we will send truncate command
> +                        * in finish_inode_if_needed anyways, the
> inode size will be
> +                        * correct, and we don't have to send all-zero data.
> +                        */
> +                       ret = 0;
> +                       goto out;
> +               }
>         }
>
>         ret = find_extent_clone(sctx, path, key->objectid, key->offset,
>                         sctx->cur_inode_size, &found_clone);
>         if (ret != -ENOENT && ret < 0)
>                 goto out;
>
>         ret = send_write_or_clone(sctx, path, key, found_clone);
>
> Thanks,
> Alex.
>
>
> On Thu, Nov 29, 2012 at 10:54 AM, Alexander Block <ablock84@gmail.com> wrote:
>> On Thu, Nov 29, 2012 at 4:11 AM, Chen Yang <chenyang.fnst@cn.fujitsu.com> wrote:
>>> when send/receive a sparse file, the holes of the original file
>>> will be filled with zero. The holes will be sent as ZERO streams,
>>> and it's unnecessary.
>>>
>>> So, I improved this by skipping the hole of file while sending.
>>>
>>> Signed-off-by: Cheng Yang <chenyang.fnst@cn.fujitsu.com>
>>> ---
>>>  fs/btrfs/send.c |    6 ++++++
>>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
>>> index e78b297..1e1d59a 100644
>>> --- a/fs/btrfs/send.c
>>> +++ b/fs/btrfs/send.c
>>> @@ -3718,6 +3718,7 @@ static int send_write_or_clone(struct send_ctx *sctx,
>>>         u64 pos = 0;
>>>         u64 len;
>>>         u32 l;
>>> +       u64 bytenr;
>>>         u8 type;
>>>
>>>         ei = btrfs_item_ptr(path->nodes[0], path->slots[0],
>>> @@ -3732,6 +3733,11 @@ static int send_write_or_clone(struct send_ctx *sctx,
>>>                  */
>>>                 len = PAGE_CACHE_ALIGN(len);
>>>         } else {
>>> +               bytenr = btrfs_file_extent_disk_bytenr(path->nodes[0], ei);
>>> +               if (bytenr == 0) {
>>> +                       ret = 0;
>>> +                       goto out;
>>> +               }
>>>                 len = btrfs_file_extent_num_bytes(path->nodes[0], ei);
>>>         }
>>>
>>> --
>>> 1.7.7.6
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> This won't work for incremental sends if I understand it correctly. If
>> the hole got punched into the file after the initial send, the data
>> will be unchanged on the receiving side when receiving incrementally.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
