Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57006 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbcEDJP6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 May 2016 05:15:58 -0400
Date: Wed, 4 May 2016 11:15:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/1] btrfs: fix lock dep warning move scratch super
 outside of chunk_mutex
Message-ID: <20160504091540.GP29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1460468176-534-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1460468176-534-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 12, 2016 at 09:36:16PM +0800, Anand Jain wrote:
> Move scratch super outside of the chunk lock to avoid below
> lockdep warning. The better place to scratch super is in
> the function btrfs_rm_dev_replace_free_srcdev() just before
> free_device, which is outside of the chunk lock as well.
> 
> To reproduce:
>   (fresh boot)
>   mkfs.btrfs -f -draid5 -mraid5 /dev/sdc /dev/sdd /dev/sde
>   mount /dev/sdc /btrfs
>   dd if=/dev/zero of=/btrfs/tf1 bs=4096 count=100
>   (get devmgt from https://github.com/asj/devmgt.git)
>   devmgt detach /dev/sde
>   dd if=/dev/zero of=/btrfs/tf1 bs=4096 count=100
>   sync
>   btrfs replace start -Brf 3 /dev/sdf /btrfs <--
>   devmgt attach host7
> 
> ======================================================
> [ INFO: possible circular locking dependency detected ]
> 4.6.0-rc2asj+ #1 Not tainted
> ---------------------------------------------------
> 
> btrfs/2174 is trying to acquire lock:
> (sb_writers){.+.+.+}, at:
> [<ffffffff812449b4>] __sb_start_write+0xb4/0xf0
> 
> but task is already holding lock:
> (&fs_info->chunk_mutex){+.+.+.}, at:
> [<ffffffffa05c5f55>] btrfs_dev_replace_finishing+0x145/0x980 [btrfs]
> 
> which lock already depends on the new lock.
> 
> Chain exists of:
> sb_writers --> &fs_devs->device_list_mutex --> &fs_info->chunk_mutex
> Possible unsafe locking scenario:
> CPU0				CPU1
> ----				----
> lock(&fs_info->chunk_mutex);
> 				lock(&fs_devs->device_list_mutex);
> 				lock(&fs_info->chunk_mutex);
> lock(sb_writers);
> 
> *** DEADLOCK ***
> 
> -> #0 (sb_writers){.+.+.+}:
> [<ffffffff810e6415>] __lock_acquire+0x1bc5/0x1ee0
> [<ffffffff810e707e>] lock_acquire+0xbe/0x210
> [<ffffffff810df49a>] percpu_down_read+0x4a/0xa0
> [<ffffffff812449b4>] __sb_start_write+0xb4/0xf0
> [<ffffffff81265534>] mnt_want_write+0x24/0x50
> [<ffffffff812508a2>] path_openat+0x952/0x1190
> [<ffffffff81252451>] do_filp_open+0x91/0x100
> [<ffffffff8123f5cc>] file_open_name+0xfc/0x140
> [<ffffffff8123f643>] filp_open+0x33/0x60
> [<ffffffffa0572bb6>] update_dev_time+0x16/0x40 [btrfs]
> [<ffffffffa057f60d>] btrfs_scratch_superblocks+0x5d/0xb0 [btrfs]
> [<ffffffffa057f70e>] btrfs_rm_dev_replace_remove_srcdev+0xae/0xd0 [btrfs]
> [<ffffffffa05c62c5>] btrfs_dev_replace_finishing+0x4b5/0x980 [btrfs]
> [<ffffffffa05c6ae8>] btrfs_dev_replace_start+0x358/0x530 [btrfs]
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Added to for-next.
