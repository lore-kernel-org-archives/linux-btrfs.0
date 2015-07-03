Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39855 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780AbbGCQvp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jul 2015 12:51:45 -0400
Date: Fri, 3 Jul 2015 18:51:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Sandino Araico =?iso-8859-1?Q?S=E1nchez?= <sandino@sandino.net>
Cc: linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com
Subject: Re: [PATCH] Integer underflow in ctree.c
Message-ID: <20150703165143.GS726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <558443D4.3050506@sandino.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <558443D4.3050506@sandino.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 19, 2015 at 11:31:16AM -0500, Sandino Araico Sánchez wrote:
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
>         tree block bytenr: 3535142346752, level: 0, node key:
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

Very useful, thanks.

The repair mode tries to remove the corrupted leaves, added in commit
1581d7e5db9278a3aef5ff88301a9866b57cd5ad, but seems that it needs more
sanity checking before it actuall tyres to call btrfs_del_ptr.

> After the patch btrfs check is not crashing anymore.
> --- btrfs-progs-v4.0.1.orig/ctree.c	2015-06-19 03:43:12.000000000 -0500
> +++ btrfs-progs-v4.0.1/ctree.c	2015-06-19 03:43:49.000000000 -0500
> @@ -2588,7 +2588,7 @@
>  	int ret = 0;
>  
>  	nritems = btrfs_header_nritems(parent);
> -	if (slot != nritems -1) {
> +	if (slot < nritems -1) {

Though this helped, I think that passing slot == nritems is wrong and
should be caught up the callstack. I've CCed Qu, maybe he has some
insights.

>  		memmove_extent_buffer(parent,
>  			      btrfs_node_key_ptr_offset(slot),
>  			      btrfs_node_key_ptr_offset(slot + 1),
> 

