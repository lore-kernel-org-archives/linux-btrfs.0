Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:33470 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab2GJP0e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Jul 2012 11:26:34 -0400
Received: by qadb17 with SMTP id b17so2437330qad.19
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2012 08:26:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341409108-13567-8-git-send-email-ablock84@googlemail.com>
References: <1341409108-13567-1-git-send-email-ablock84@googlemail.com>
	<1341409108-13567-8-git-send-email-ablock84@googlemail.com>
Date: Tue, 10 Jul 2012 18:26:33 +0300
Message-ID: <CAHf9xvbKfbSQNx_Bz39-NBk2QvPZLAgWc_7+HLDpj1s45R6C6g@mail.gmail.com>
Subject: Re: [RFC PATCH 7/7] Btrfs: introduce BTRFS_IOC_SEND for btrfs
 send/receive (part 2)
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Alexander Block <ablock84@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alexander,
this focuses on area of sending file extents:

> +static int is_extent_unchanged(struct send_ctx *sctx,
> +                              struct btrfs_path *left_path,
> +                              struct btrfs_key *ekey)
> +{
> +       int ret = 0;
> +       struct btrfs_key key;
> +       struct btrfs_path *path = NULL;
> +       struct extent_buffer *eb;
> +       int slot;
> +       struct btrfs_key found_key;
> +       struct btrfs_file_extent_item *ei;
> +       u64 left_disknr;
> +       u64 right_disknr;
> +       u64 left_offset;
> +       u64 right_offset;
> +       u64 left_len;
> +       u64 right_len;
> +       u8 left_type;
> +       u8 right_type;
> +
> +       path = alloc_path_for_send();
> +       if (!path)
> +               return -ENOMEM;
> +
> +       eb = left_path->nodes[0];
> +       slot = left_path->slots[0];
> +
> +       ei = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
> +       left_type = btrfs_file_extent_type(eb, ei);
> +       left_disknr = btrfs_file_extent_disk_bytenr(eb, ei);
> +       left_len = btrfs_file_extent_num_bytes(eb, ei);
> +       left_offset = btrfs_file_extent_offset(eb, ei);
> +
> +       if (left_type != BTRFS_FILE_EXTENT_REG) {
> +               ret = 0;
> +               goto out;
> +       }
> +
> +       key.objectid = ekey->objectid;
> +       key.type = BTRFS_EXTENT_DATA_KEY;
> +       key.offset = ekey->offset;
> +
> +       while (1) {
> +               ret = btrfs_search_slot_for_read(sctx->parent_root, &key, path,
> +                               0, 0);
> +               if (ret < 0)
> +                       goto out;
> +               if (ret) {
> +                       ret = 0;
> +                       goto out;
> +               }
> +               btrfs_item_key_to_cpu(path->nodes[0], &found_key,
> +                               path->slots[0]);
> +               if (found_key.objectid != key.objectid ||
> +                   found_key.type != key.type) {
> +                       ret = 0;
> +                       goto out;
> +               }
> +
> +               eb = path->nodes[0];
> +               slot = path->slots[0];
> +
> +               ei = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
> +               right_type = btrfs_file_extent_type(eb, ei);
> +               right_disknr = btrfs_file_extent_disk_bytenr(eb, ei);
> +               right_len = btrfs_file_extent_num_bytes(eb, ei);
> +               right_offset = btrfs_file_extent_offset(eb, ei);
> +               btrfs_release_path(path);
> +
> +               if (right_type != BTRFS_FILE_EXTENT_REG) {
> +                       ret = 0;
> +                       goto out;
> +               }
> +
> +               if (left_disknr != right_disknr) {
> +                       ret = 0;
> +                       goto out;
> +               }
> +
> +               key.offset = found_key.offset + right_len;
> +               if (key.offset >= ekey->offset + left_len) {
> +                       ret = 1;
> +                       goto out;
> +               }
> +       }
> +
> +out:
> +       btrfs_free_path(path);
> +       return ret;
> +}
> +

Should we always treat left extent with bytenr==0 as not changed?
Because right now, it simply reads and sends data of such extent,
while bytenr==0 means "no data allocated here". Since we always do
send_truncate() afterwards, file size will always be correct, so we
can just skip bytenr==0 extents.
Same is true for BTRFS_FILE_EXTENT_PREALLOC extents, I think. Those
also don't contain real data.
So something like:
if (left_disknr == 0 || left_type == BTRFS_FILE_EXTENT_REG) {
	ret = 1;
	goto out;
}
before we check for BTRFS_FILE_EXTENT_REG.

Now I have a question about the rest of the logic that decides that
extent is unchanged. I understand that if we see the same extent (same
disk_bytenr) shared between parent_root and send_root, then it must
contain the same data, even in nodatacow mode, because on a first
write to such shared extent, it is cow'ed even with nodatacow.

However, shouldn't we check btrfs_file_extent_offset(), to make sure
that both send_root and parent_root point at the same offset into
extent from the same file offset? Because if extent_offset values are
different, then the data of the file might different, even though we
are talking about the same extent.

So I am thinking about something like:

- ekey.offset points at data at logical address
left_disknr+left_offset (logical address within CHUNK_ITEM address
space) for left_len bytes
- found_key.offset points at data at logical address
right_disknr+right_offset for right_len
- we know that found_key.offset <= ekey.offset

So we need to ensure that left_disknr==right_disknr and also:
right_disknr+right_offset + (ekey.offset - found_key.offset) ==
left_disknr+left_offset
or does this while loop somehow ensures this equation?

However, I must admit I don't fully understand the logic behind
deciding that extent is unchanged. Can you pls explain what this tries
to accomplish, and why it decides that extent is unchanged here:
key.offset = found_key.offset + right_len;
if (key.offset >= ekey->offset + left_len) {
	ret = 1;
	goto out;
}

Also: when searching for the next extent, should we use
btrfs_file_extent_num_bytes() or btrfs_file_extent_disk_num_bytes()?
They are not equal sometimes...not sure at which offset the next
extent (if any) should be. What about holes in files? Then we will
have non-consecutive offsets.

Thanks,
Alex.
