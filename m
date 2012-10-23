Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50186 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934038Ab2JWUWz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 16:22:55 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so626352lbo.19
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2012 13:22:54 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 23 Oct 2012 22:22:54 +0200
Message-ID: <CAOcd+r2wMdZcRTPPFLhbws8N=GBmg2kpFZ0ZcLujiCWPjATnyw@mail.gmail.com>
Subject: Questions about btrfs-convert code
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings all,
I am studying the conversion code, and maybe somebody can help me with
these questions:

# btrfs_make_block_groups()
I see that this function uses some heuristics to create block groups
for BTRFS_BLOCK_GROUP_METADATA and BTRFS_BLOCK_GROUP_DATA. Later, ext2
data blocks are mapped into EXTENT_ITEMs based on their original
locations in ext2, as reported by ext2fs_block_iterate2 function.
However, it is not ensured later that those EXTENT_ITEMs land into
BTRFS_BLOCK_GROUP_DATA only. Later there are some data relocations
happening, but still there are EXTENT_ITEMs that map file data and
still they live in the BTRFS_BLOCK_GROUP_METADATA block groups.
Is this a problem? Or perhaps I am wrong and somehow it is ensured
later that these EXTENT_ITEMs are moved into DATA block groups?

# create_ext2_image()
I see this comment:
/*
 * copy blocks covered by extent #0 to new positions. extent #0 is
 * special, we can't rely on relocate_extents_range to relocate it.
 */
Then relocation of blocks up to the end of the first superblock copy
happens, and these blocks will be mapped by the ext2 image files that
is created.
However, it may happen that this area contained some ext2 data block,
but relevant btrfs files are not updated at this step. Perhaps they
will be updated later in relocate_extents_range() as part of cleaning
the BTRFS_BLOCK_GROUP_SYSTEM group?
What is special about this "extent#0"?

Thanks,
Alex.
