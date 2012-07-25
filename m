Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57126 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab2GYNhl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jul 2012 09:37:41 -0400
Received: by yhmm54 with SMTP id m54so687047yhm.19
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2012 06:37:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHf9xvbKfbSQNx_Bz39-NBk2QvPZLAgWc_7+HLDpj1s45R6C6g@mail.gmail.com>
References: <1341409108-13567-1-git-send-email-ablock84@googlemail.com>
	<1341409108-13567-8-git-send-email-ablock84@googlemail.com>
	<CAHf9xvbKfbSQNx_Bz39-NBk2QvPZLAgWc_7+HLDpj1s45R6C6g@mail.gmail.com>
Date: Wed, 25 Jul 2012 15:37:40 +0200
Message-ID: <CAB9VWqBEXs_EE=avjqXq4708HpGWeWYJGK8esshR4fTC4+G9Gg@mail.gmail.com>
Subject: Re: [RFC PATCH 7/7] Btrfs: introduce BTRFS_IOC_SEND for btrfs
 send/receive (part 2)
From: Alexander Block <ablock84@googlemail.com>
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 10, 2012 at 5:26 PM, Alex Lyakas
<alex.bolshoy.btrfs@gmail.com> wrote:
> Alexander,
> this focuses on area of sending file extents:
>
>> +static int is_extent_unchanged(struct send_ctx *sctx,
>> +                              struct btrfs_path *left_path,
>> +                              struct btrfs_key *ekey)
>> +{
>> +       int ret = 0;
>> +       struct btrfs_key key;
>> +       struct btrfs_path *path = NULL;
>> +       struct extent_buffer *eb;
>> +       int slot;
>> +       struct btrfs_key found_key;
>> +       struct btrfs_file_extent_item *ei;
>> +       u64 left_disknr;
>> +       u64 right_disknr;
>> +       u64 left_offset;
>> +       u64 right_offset;
>> +       u64 left_len;
>> +       u64 right_len;
>> +       u8 left_type;
>> +       u8 right_type;
>> +
>> +       path = alloc_path_for_send();
>> +       if (!path)
>> +               return -ENOMEM;
>> +
>> +       eb = left_path->nodes[0];
>> +       slot = left_path->slots[0];
>> +
>> +       ei = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
>> +       left_type = btrfs_file_extent_type(eb, ei);
>> +       left_disknr = btrfs_file_extent_disk_bytenr(eb, ei);
>> +       left_len = btrfs_file_extent_num_bytes(eb, ei);
>> +       left_offset = btrfs_file_extent_offset(eb, ei);
>> +
>> +       if (left_type != BTRFS_FILE_EXTENT_REG) {
>> +               ret = 0;
>> +               goto out;
>> +       }
>> +
>> +       key.objectid = ekey->objectid;
>> +       key.type = BTRFS_EXTENT_DATA_KEY;
>> +       key.offset = ekey->offset;
>> +
>> +       while (1) {
>> +               ret = btrfs_search_slot_for_read(sctx->parent_root, &key, path,
>> +                               0, 0);
>> +               if (ret < 0)
>> +                       goto out;
>> +               if (ret) {
>> +                       ret = 0;
>> +                       goto out;
>> +               }
>> +               btrfs_item_key_to_cpu(path->nodes[0], &found_key,
>> +                               path->slots[0]);
>> +               if (found_key.objectid != key.objectid ||
>> +                   found_key.type != key.type) {
>> +                       ret = 0;
>> +                       goto out;
>> +               }
>> +
>> +               eb = path->nodes[0];
>> +               slot = path->slots[0];
>> +
>> +               ei = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
>> +               right_type = btrfs_file_extent_type(eb, ei);
>> +               right_disknr = btrfs_file_extent_disk_bytenr(eb, ei);
>> +               right_len = btrfs_file_extent_num_bytes(eb, ei);
>> +               right_offset = btrfs_file_extent_offset(eb, ei);
>> +               btrfs_release_path(path);
>> +
>> +               if (right_type != BTRFS_FILE_EXTENT_REG) {
>> +                       ret = 0;
>> +                       goto out;
>> +               }
>> +
>> +               if (left_disknr != right_disknr) {
>> +                       ret = 0;
>> +                       goto out;
>> +               }
>> +
>> +               key.offset = found_key.offset + right_len;
>> +               if (key.offset >= ekey->offset + left_len) {
>> +                       ret = 1;
>> +                       goto out;
>> +               }
>> +       }
>> +
>> +out:
>> +       btrfs_free_path(path);
>> +       return ret;
>> +}
>> +
>
> Should we always treat left extent with bytenr==0 as not changed?
No, as we may have bytenr!=0 on the right side.
> Because right now, it simply reads and sends data of such extent,
> while bytenr==0 means "no data allocated here". Since we always do
> send_truncate() afterwards, file size will always be correct, so we
> can just skip bytenr==0 extents.
This is something that could be done for full sends only. Full sends
however do not call is_extent_unchanged, so the optimization is
something for process_extent.
In the incremental case, it may happen that left_disknr==0 and
right_disknr!=0 or vice versa, so we need to do the compare no matter
if one of them is ==0. process_extents could then again do some
optimization and send a special command to instruct a preallocated
zero block.
> Same is true for BTRFS_FILE_EXTENT_PREALLOC extents, I think. Those
> also don't contain real data.
> So something like:
> if (left_disknr == 0 || left_type == BTRFS_FILE_EXTENT_REG) {
>         ret = 1;
>         goto out;
> }
Do you mean "|| left_type == BTRFS_FILE_EXTENT_PREALLOC"?
> before we check for BTRFS_FILE_EXTENT_REG.
>
> Now I have a question about the rest of the logic that decides that
> extent is unchanged. I understand that if we see the same extent (same
> disk_bytenr) shared between parent_root and send_root, then it must
> contain the same data, even in nodatacow mode, because on a first
> write to such shared extent, it is cow'ed even with nodatacow.
>
> However, shouldn't we check btrfs_file_extent_offset(), to make sure
> that both send_root and parent_root point at the same offset into
> extent from the same file offset? Because if extent_offset values are
> different, then the data of the file might different, even though we
> are talking about the same extent.
>
> So I am thinking about something like:
>
> - ekey.offset points at data at logical address
> left_disknr+left_offset (logical address within CHUNK_ITEM address
> space) for left_len bytes
> - found_key.offset points at data at logical address
> right_disknr+right_offset for right_len
> - we know that found_key.offset <= ekey.offset
>
> So we need to ensure that left_disknr==right_disknr and also:
> right_disknr+right_offset + (ekey.offset - found_key.offset) ==
> left_disknr+left_offset
> or does this while loop somehow ensures this equation?
Ay...you're absolutely right :) Fixed that and pushing later today.
>
> However, I must admit I don't fully understand the logic behind
> deciding that extent is unchanged. Can you pls explain what this tries
> to accomplish, and why it decides that extent is unchanged here:
> key.offset = found_key.offset + right_len;
This line is to advance to the next extent on the right side.
> if (key.offset >= ekey->offset + left_len) {
>         ret = 1;
>         goto out;
> }
This if checks if the advancing would put us behind the left extent.
If that is true, we're done with the extent that we're checking now.
As we did not bail out before, we know that the extent is unchanged.
>
> Also: when searching for the next extent, should we use
> btrfs_file_extent_num_bytes() or btrfs_file_extent_disk_num_bytes()?
> They are not equal sometimes...not sure at which offset the next
> extent (if any) should be. What about holes in files? Then we will
> have non-consecutive offsets.
We have to use num_bytes, as it is the *uncompressed* number of bytes.
We're working on file extents, and their offsets are always
uncompressed. Also, num_bytes is the number of bytes after splitting,
while disk_num_bytes is always the size of the whole extent on disk.

I have changed the way I iterate the extents now. I use
btrfs_next_item instead of advancing key.offset now. Also, I have
added some ASCII graphics to illustrate what happens. I hope that
helps understanding this. Will push that later today.
>
> Thanks,
> Alex.
