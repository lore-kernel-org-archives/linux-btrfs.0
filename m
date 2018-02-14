Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38926 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031296AbeBNP1j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 10:27:39 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CEFA1AAEF
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Feb 2018 15:27:37 +0000 (UTC)
Date: Wed, 14 Feb 2018 16:25:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: Fix read beyond boundary bug in
 build_roots_info_cache()
Message-ID: <20180214152522.GG3003@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180214064325.21561-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180214064325.21561-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 14, 2018 at 02:43:25PM +0800, Qu Wenruo wrote:
> This bug is exposed by fsck-test with D=asan, hit by test case 020, with
> the following error report:
> 
> =================================================================
> ==10740==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x621000061580 at pc 0x56051f0db6cd bp 0x7ffe170f3e20 sp 0x7ffe170f3e10
> READ of size 1 at 0x621000061580 thread T0
>     #0 0x56051f0db6cc in btrfs_extent_inline_ref_type /home/adam/btrfs/btrfs-progs/ctree.h:1727
>     #1 0x56051f13b669 in build_roots_info_cache /home/adam/btrfs/btrfs-progs/cmds-check.c:14306
>     #2 0x56051f13c86a in repair_root_items /home/adam/btrfs/btrfs-progs/cmds-check.c:14450
>     #3 0x56051f13ea89 in cmd_check /home/adam/btrfs/btrfs-progs/cmds-check.c:14965
>     #4 0x56051efe75bb in main /home/adam/btrfs/btrfs-progs/btrfs.c:302
>     #5 0x7f04ddbb0f49 in __libc_start_main (/usr/lib/libc.so.6+0x20f49)
>     #6 0x56051efe68c9 in _start (/home/adam/btrfs/btrfs-progs/btrfs+0x5b8c9)
> 
> 0x621000061580 is located 0 bytes to the right of 4224-byte region [0x621000060500,0x621000061580)
> allocated by thread T0 here:
>     #0 0x7f04ded50ce1 in __interceptor_calloc /build/gcc/src/gcc/libsanitizer/asan/asan_malloc_linux.cc:70
>     #1 0x56051f04685e in __alloc_extent_buffer /home/adam/btrfs/btrfs-progs/extent_io.c:553
>     #2 0x56051f047563 in alloc_extent_buffer /home/adam/btrfs/btrfs-progs/extent_io.c:687
>     #3 0x56051efff1d1 in btrfs_find_create_tree_block /home/adam/btrfs/btrfs-progs/disk-io.c:187
>     #4 0x56051f000133 in read_tree_block /home/adam/btrfs/btrfs-progs/disk-io.c:327
>     #5 0x56051efeddb8 in read_node_slot /home/adam/btrfs/btrfs-progs/ctree.c:652
>     #6 0x56051effb0d9 in btrfs_next_leaf /home/adam/btrfs/btrfs-progs/ctree.c:2853
>     #7 0x56051f13b343 in build_roots_info_cache /home/adam/btrfs/btrfs-progs/cmds-check.c:14267
>     #8 0x56051f13c86a in repair_root_items /home/adam/btrfs/btrfs-progs/cmds-check.c:14450
>     #9 0x56051f13ea89 in cmd_check /home/adam/btrfs/btrfs-progs/cmds-check.c:14965
>     #10 0x56051efe75bb in main /home/adam/btrfs/btrfs-progs/btrfs.c:302
>     #11 0x7f04ddbb0f49 in __libc_start_main (/usr/lib/libc.so.6+0x20f49)
> 
> It's completely possible that one extent/metadata item has no inline
> reference, while build_roots_info_cache() doesn't have such check.
> 
> Fix it by checking @iref against item end to avoid such problem.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.

> I'm pretty sure this fix will cause conflict with original mode code
> split.
> Maybe it's better to merge original code split first?

The file cmds-check.c does not exist in devel so I have applied the
changes manually. I'd like to do a release soon, so I'm applying the
small fix(es) first before merging larger patchsets.

And because you quickly fixed the outstanding asan reports it can be the
first release that passes asan and ubsan, thanks again!
