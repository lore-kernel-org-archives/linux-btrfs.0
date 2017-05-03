Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57989 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752517AbdECOxp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 May 2017 10:53:45 -0400
Date: Wed, 3 May 2017 16:53:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/2] btrfs-progs: check: Avoid reading beyond item
 boundary for inode_ref
Message-ID: <20170503145338.GX23260@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170503084240.17499-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170503084240.17499-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 03, 2017 at 04:42:39PM +0800, Qu Wenruo wrote:
> When reading out name from inode_ref, it's possible that corrupted
> name_len can lead to read beyond boundary of item or even extent buffer.
> 
> This happens when checking fuzzed image /tmp/bko-161811.raw, for both
> lowmem mode and original mode.
> 
> ERROR: root 5 INODE REF[256 256] doesn't have related DIR_INDEX[256 504403158265495680] namelen 0 filename  filetype 0
> ERROR: root 5 INODE REF[256 256] doesn't have related DIR_ITEM[256 4294967294] namelen 0 filename  filetype 0
> WARNING: root 5 INODE_REF[256 256] name too long
> ==13022== Invalid read of size 8
> ==13022==    at 0x4C319BE: memmove (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
> ==13022==    by 0x431518: read_extent_buffer (extent_io.c:863)
> ==13022==    by 0x474730: check_inode_ref (cmds-check.c:4307)
> ==13022==    by 0x475D65: check_inode_item (cmds-check.c:4890)
> ==13022==    by 0x476200: check_fs_first_inode (cmds-check.c:5011)
> ==13022==    by 0x476276: check_fs_root_v2 (cmds-check.c:5044)
> ==13022==    by 0x4769FB: check_fs_roots_v2 (cmds-check.c:5242)
> ==13022==    by 0x488B5B: cmd_check (cmds-check.c:13033)
> ==13022==    by 0x40A8C5: main (btrfs.c:246)
> ==13022==  Address 0x5c96780 is 0 bytes after a block of size 4,224 alloc'd
> ==13022==    at 0x4C2CF35: calloc (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
> ==13022==    by 0x4307E0: __alloc_extent_buffer (extent_io.c:538)
> ==13022==    by 0x430C37: alloc_extent_buffer (extent_io.c:642)
> ==13022==    by 0x413DFE: btrfs_find_create_tree_block (disk-io.c:193)
> ==13022==    by 0x414370: read_tree_block_fs_info (disk-io.c:340)
> ==13022==    by 0x40B5D5: read_tree_block (disk-io.h:125)
> ==13022==    by 0x40CFD2: read_node_slot (ctree.c:652)
> ==13022==    by 0x40E5EB: btrfs_search_slot (ctree.c:1172)
> ==13022==    by 0x4761A8: check_fs_first_inode (cmds-check.c:5001)
> ==13022==    by 0x476276: check_fs_root_v2 (cmds-check.c:5044)
> ==13022==    by 0x4769FB: check_fs_roots_v2 (cmds-check.c:5242)
> ==13022==    by 0x488B5B: cmd_check (cmds-check.c:13033)
> =
> 
> Fix it by double checking inode_ref, name_len against item boundary
> before trying to read out name from extent buffer, for both original
> mode and lowmem mode.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
