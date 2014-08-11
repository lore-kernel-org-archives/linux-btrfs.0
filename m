Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47314 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbaHKLXy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 07:23:54 -0400
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 62C923EE0ED
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 20:23:52 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 6A31CAC0345
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 20:23:51 +0900 (JST)
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 0F9781DB803B
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 20:23:51 +0900 (JST)
Message-ID: <53E8A7B4.6080304@jp.fujitsu.com>
Date: Mon, 11 Aug 2014 20:23:32 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Filipe Manana <fdmanana@suse.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: don't monopolize a core when evicting inode
References: <1407462426-6420-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1407462426-6420-1-git-send-email-fdmanana@suse.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/08/08 10:47), Filipe Manana wrote:
> If an inode has a very large number of extent maps, we can spend
> a lot of time freeing them, which triggers a soft lockup warning.
> Therefore reschedule if we need to when freeing the extent maps
> while evicting the inode.
> 
> I could trigger this all the time by running xfstests/generic/299 on
> a file system with the no-holes feature enabled. That test creates
> an inode with 11386677 extent maps.
> 
>      $ mkfs.btrfs -f -O no-holes $TEST_DEV
>      $ MKFS_OPTIONS="-O no-holes" ./check generic/299
>      generic/299 382s ...
>      Message from syslogd@debian-vm3 at Aug  7 10:44:29 ...
>       kernel:[85304.208017] BUG: soft lockup - CPU#0 stuck for 22s! [umount:25330]
>       384s
>      Ran: generic/299
>      Passed all 1 tests
> 
>      $ dmesg
>      (...)
>      [86304.300017] BUG: soft lockup - CPU#0 stuck for 23s! [umount:25330]
>      (...)
>      [86304.300036] Call Trace:
>      [86304.300036]  [<ffffffff81698ba9>] __slab_free+0x54/0x295
>      [86304.300036]  [<ffffffffa02ee9cc>] ? free_extent_map+0x5c/0xb0 [btrfs]
>      [86304.300036]  [<ffffffff811a6cd2>] kmem_cache_free+0x282/0x2a0
>      [86304.300036]  [<ffffffffa02ee9cc>] free_extent_map+0x5c/0xb0 [btrfs]
>      [86304.300036]  [<ffffffffa02e3775>] btrfs_evict_inode+0xd5/0x660 [btrfs]
>      [86304.300036]  [<ffffffff811e7c8d>] ? __inode_wait_for_writeback+0x6d/0xc0
>      [86304.300036]  [<ffffffff816a389b>] ? _raw_spin_unlock+0x2b/0x40
>      [86304.300036]  [<ffffffff811d8cbb>] evict+0xab/0x180
>      [86304.300036]  [<ffffffff811d8dce>] dispose_list+0x3e/0x60
>      [86304.300036]  [<ffffffff811d9b04>] evict_inodes+0xf4/0x110
>      [86304.300036]  [<ffffffff811bd953>] generic_shutdown_super+0x53/0x110
>      [86304.300036]  [<ffffffff811bdaa6>] kill_anon_super+0x16/0x30
>      [86304.300036]  [<ffffffffa02a78ba>] btrfs_kill_super+0x1a/0xa0 [btrfs]
>      [86304.300036]  [<ffffffff811bd3a9>] deactivate_locked_super+0x59/0x80
>      [86304.300036]  [<ffffffff811be44e>] deactivate_super+0x4e/0x70
>      [86304.300036]  [<ffffffff811dec14>] mntput_no_expire+0x174/0x1f0
>      [86304.300036]  [<ffffffff811deab7>] ? mntput_no_expire+0x17/0x1f0
>      [86304.300036]  [<ffffffff811e0517>] SyS_umount+0x97/0x100
>      (...)
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Tested-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

> ---
>   fs/btrfs/inode.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 8ad3ea9..00b4bd3 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4718,6 +4718,11 @@ static void evict_inode_truncate_pages(struct inode *inode)
>   		clear_bit(EXTENT_FLAG_LOGGING, &em->flags);
>   		remove_extent_mapping(map_tree, em);
>   		free_extent_map(em);
> +		if (need_resched()) {
> +			write_unlock(&map_tree->lock);
> +			cond_resched();
> +			write_lock(&map_tree->lock);
> +		}
>   	}
>   	write_unlock(&map_tree->lock);
>   
> @@ -4740,6 +4745,7 @@ static void evict_inode_truncate_pages(struct inode *inode)
>   				 &cached_state, GFP_NOFS);
>   		free_extent_state(state);
>   
> +		cond_resched();
>   		spin_lock(&io_tree->lock);
>   	}
>   	spin_unlock(&io_tree->lock);
> 

