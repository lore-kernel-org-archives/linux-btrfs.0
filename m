Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48716 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbbIYRt2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 13:49:28 -0400
Date: Fri, 25 Sep 2015 19:48:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Show detail error message when write sb
 failed in write_dev_supers()
Message-ID: <20150925174830.GP11442@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <8277e478b7947c957be606f17b5137ae8d78ee66.1437996746.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8277e478b7947c957be606f17b5137ae8d78ee66.1437996746.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 27, 2015 at 07:32:37PM +0800, Zhaolei wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> fsck-tests.sh failed and show following message in my node:
>   # ./fsck-tests.sh
>      [TEST]   001-bad-file-extent-bytenr
>   disk-io.c:1444: write_dev_supers: Assertion `ret != BTRFS_SUPER_INFO_SIZE` failed.
>   /root/btrfsprogs/btrfs-image(write_all_supers+0x2d2)[0x41031c]
>   /root/btrfsprogs/btrfs-image(write_ctree_super+0xc5)[0x41042e]
>   /root/btrfsprogs/btrfs-image(btrfs_commit_transaction+0x208)[0x410976]
>   /root/btrfsprogs/btrfs-image[0x438780]
>   /root/btrfsprogs/btrfs-image(main+0x3d5)[0x438c5c]
>   /lib64/libc.so.6(__libc_start_main+0xfd)[0x335e01ecdd]
>   /root/btrfsprogs/btrfs-image[0x4074e9]
>   failed to restore image /root/btrfsprogs/tests/fsck-tests/001-bad-file-extent-bytenr/default_case.img
>   #
> 
>   # cat fsck-tests-results.txt
>   === Entering /root/btrfsprogs/tests/fsck-tests/001-bad-file-extent-bytenr
>   restoring image default_case.img
>   failed to restore image /root/btrfsprogs/tests/fsck-tests/001-bad-file-extent-bytenr/default_case.img
>   #
> 
> Reason:
>   I run above test in a NFS mountpoint, it don't have enouth space to write
>   all superblock to image file, and don't support sparse file.
>   So write_dev_supers() failed in writing sb and output above message.
> 
> It takes me quite of time to know what happened, we can save these time
> by output exact information in write-sb-fail case.
> 
> After patch:
>   # ./fsck-tests.sh
>     [TEST]   001-bad-file-extent-bytenr
>   WARNING: Write sb failed: File too large
>   disk-io.c:1492: write_all_supers: Assertion `ret` failed.
>   ...
>   #
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Applied, thans.
