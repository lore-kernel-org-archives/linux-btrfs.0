Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42469 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756511AbbGGJO3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jul 2015 05:14:29 -0400
Subject: Re: [PATCH] Integer underflow in ctree.c
To: =?UTF-8?Q?Sandino_Araico_S=c3=a1nchez?= <sandino@sandino.net>,
        <linux-btrfs@vger.kernel.org>
References: <558443D4.3050506@sandino.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <559B9872.7070000@cn.fujitsu.com>
Date: Tue, 7 Jul 2015 17:14:26 +0800
MIME-Version: 1.0
In-Reply-To: <558443D4.3050506@sandino.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Sandino Araico Sánchez wrote on 2015/06/19 11:31 -0500:
> :btrfs check crashed while trying to fix my corrupted filesystem.
>
> btrfs check --repair /dev/sdd3
> enabling repair mode
> Checking filesystem on /dev/sdd3
> UUID: 58222ebc-79ca-4dc4-891f-129aae342313
> checking extents
> bad key ordering 0 1
> bad block 3535142326272
> Errors found in extent allocation tree or chunk allocation
> Fixed 0 roots.
> checking free space cache
> cache and super generation don't match, space cache will be invalidated
> checking fs roots
> bad key ordering 0 1
> bad key ordering 0 1
> The following tree block(s) is corrupted in tree 814:
>          tree block bytenr: 3535142346752, level: 0, node key:
> (1270098042880, 168, 4096)
> Try to repair the btree for root 814
> Segmentation fault
>
> What I found on the gdb backtrace:
>
> (gdb) bt
> #0Â  0x00006fc5cb578411 in ?? ()
> #1Â  0x000009d5fe028bab in memmove_extent_buffer (dst=0x9d76942cf30,
> dst_offset=1586, src_offset=1619, len=141733920735) at extent_io.c:880
> #2Â  0x000009d5fe002e1b in btrfs_del_ptr (trans=0x9d7669ec990,
> root=0x9d7648891c0, path=0x9d7669f69f0, level=0, slot=45) at ctree.c:2592
> #3Â  0x000009d5fdfd467a in repair_btree (root=0x9d7648891c0,
> corrupt_blocks=0x70f1b0905030) at cmds-check.c:3267
> #4Â  0x000009d5fdfd4e40 in check_fs_root (root=0x9d7648891c0,
> root_cache=0x70f1b0905380, wc=0x70f1b0905240) at cmds-check.c:3422
> #5Â  0x000009d5fdfd52e6 in check_fs_roots (root=0x9d5ffdf0d10,
> root_cache=0x70f1b0905380) at cmds-check.c:3523
> #6Â  0x000009d5fdfe4ce6 in cmd_check (argc=1, argv=0x70f1b0905560) at
> cmds-check.c:9470
> #7Â  0x000009d5fdfad8a1 in main (argc=3, argv=0x70f1b0905560) at btrfs.c:245
> (gdb) select-frame 2
> (gdb) info locals
> parent = 0x9d76942cf30
> nritems = 45
> ret = 0
> __func__ = "btrfs_del_ptr"
>
> function btrfs_del_ptr parameter is called with slot=45
> and in line 2590Â  btrfs_header_nritems(parent) returns 45 for variable
> nritems;
>
> in line 2596 the result of (nritems - slot - 1) equals to 0x00000000 - 1
> and memmove_extent_buffer gets called with a huge value for parameter len.
>
> After the patch btrfs check is not crashing anymore.
>

The root problem seems not here.
Would you please show the "level" variant in frame 3?

Or, btrfs-debug-tree with its error output please.
As for such problem we can't use btrfs-image do dump the metadata.


The problem here, is why btrfs_search_slot will return the pointer to
the last *non-exist* slot.
Normally, it means btrfs_search_slot can't find the exact item, and the 
result slot is where new key should be inserted into.

I'm afraid the level things is corrupted...

Thanks,
Qu
