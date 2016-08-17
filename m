Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59900 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752152AbcHQCqn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Aug 2016 22:46:43 -0400
Subject: Re: [PATCH] btrfs: Fix leaking bytes_may_use after hitting EDQUOTA
To: <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.com>
References: <20160628015729.14624-1-quwenruo@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <3be89416-cb88-34aa-4dc0-34fc6f36ca04@cn.fujitsu.com>
Date: Wed, 17 Aug 2016 10:46:30 +0800
MIME-Version: 1.0
In-Reply-To: <20160628015729.14624-1-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

I think this patch is forgot for v4.8 merge windows.

Xfstest btrfs/022 is complaining about the problem if the patch is not 
applied.

Thanks,
Qu

At 06/28/2016 09:57 AM, Qu Wenruo wrote:
> If one mount btrfs with enospc_debug mount option and hit qgroup limits
> in btrfs_check_data_free_space(), then at unmount time, kernel warning
> will be triggered alone with a data space info dump.
> ------
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 3875 at fs/btrfs/extent-tree.c:9785
> btrfs_free_block_groups+0x2b8/0x460 [btrfs]
> Modules linked in: btrfs ext4 jbd2 mbcache xor zlib_deflate raid6_pq xfs
> [last unloaded: btrfs]
> CPU: 0 PID: 3875 Comm: umount Tainted: G        W       4.7.0-rc4+ #13
> Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox
> 12/01/2006
>  0000000000000000 ffff8800230a7d00 ffffffff813b89e5 0000000000000000
>  0000000000000000 ffff8800230a7d40 ffffffff810c9b8b 00002639230a7d50
>  ffff88003d523a78 ffff88003d523b80 ffff88000d1c0000 ffff88000d1c00c8
> Call Trace:
>  [<ffffffff813b89e5>] dump_stack+0x67/0x92
>  [<ffffffff810c9b8b>] __warn+0xcb/0xf0
>  [<ffffffff810c9c7d>] warn_slowpath_null+0x1d/0x20
>  [<ffffffffa0367508>] btrfs_free_block_groups+0x2b8/0x460 [btrfs]
>  [<ffffffffa03792e3>] close_ctree+0x173/0x350 [btrfs]
>  [<ffffffffa0348f39>] btrfs_put_super+0x19/0x20 [btrfs]
>  [<ffffffff812449aa>] generic_shutdown_super+0x6a/0xf0
>  [<ffffffff81244ca2>] kill_anon_super+0x12/0x20
>  [<ffffffffa0349728>] btrfs_kill_super+0x18/0x110 [btrfs]
>  [<ffffffff81244f1e>] deactivate_locked_super+0x3e/0x70
>  [<ffffffff8124536c>] deactivate_super+0x5c/0x60
>  [<ffffffff812667ef>] cleanup_mnt+0x3f/0x90
>  [<ffffffff81266882>] __cleanup_mnt+0x12/0x20
>  [<ffffffff810ecbd1>] task_work_run+0x81/0xc0
>  [<ffffffff810022f3>] exit_to_usermode_loop+0xb3/0xc0
>  [<ffffffff81002dc0>] syscall_return_slowpath+0xb0/0xc0
>  [<ffffffff81885f73>] entry_SYSCALL_64_fastpath+0xa6/0xa8
> ---[ end trace 99b9af8484495c66 ]---
> BTRFS: space_info 1 has 8044544 free, is not full
> BTRFS: space_info total=8388608, used=344064, pinned=0, reserved=0,
> may_use=409600, readonly=0
> ------
>
> The problem is in btrfs_check_data_free_space(), we reserve data space
> first and then reserve qgroup space.
> However if qgroup reserve failed, we didn't cleanup reserved data space,
> which leads to the kernel warning.
>
> Fix it by freeing reserved data space when qgroup_reserve_data() fails.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/extent-tree.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 29e5d00..e349da0 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4265,6 +4265,9 @@ int btrfs_check_data_free_space(struct inode *inode, u64 start, u64 len)
>  	 * range, but don't impact performance on quota disable case.
>  	 */
>  	ret = btrfs_qgroup_reserve_data(inode, start, len);
> +	if (ret < 0)
> +		/* Qgroup reserve failed, need to cleanup reserved data space */
> +		btrfs_free_reserved_data_space(inode, start, len);
>  	return ret;
>  }
>
>


