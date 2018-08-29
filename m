Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53846 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727562AbeH2TgR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Aug 2018 15:36:17 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6DAEEABC1
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Aug 2018 15:38:46 +0000 (UTC)
Subject: Re: [PATCH 6/6] btrfs-progs: rescue-super: Don't double free
 fs_devices
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180803055022.9816-1-wqu@suse.com>
 <20180803055022.9816-7-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <c357b98d-3d37-31fe-ad42-df8d7eff0d20@suse.com>
Date: Wed, 29 Aug 2018 18:38:44 +0300
MIME-Version: 1.0
In-Reply-To: <20180803055022.9816-7-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  3.08.2018 08:50, Qu Wenruo wrote:
> [BUG]
> During fuzz/007 we hit the following error:
> ------
> ====== RUN MAYFAIL /home/adam/btrfs/btrfs-progs/btrfs rescue super-recover -y -v /home/adam/btrfs/btrfs-progs/tests//fuzz-tests/images/bko-200409.raw.restored.scratch
> ERROR: tree_root block unaligned: 33554431
> ERROR: superblock checksum matches but it has invalid members
> ERROR: tree_root block unaligned: 33554431
> ERROR: superblock checksum matches but it has invalid members
> ERROR: tree_root block unaligned: 33554431
> ERROR: superblock checksum matches but it has invalid members
> ERROR: failed to add chunk map start=12582912 len=8454144: -17 (File exists)
> Couldn't read chunk tree
> failed (ignored, ret=139): /home/adam/btrfs/btrfs-progs/btrfs rescue super-recover -y -v /home/adam/btrfs/btrfs-progs/tests//fuzz-tests/images/bko-200409.raw.restored.scratch
> mayfail: returned code 139 (SEGFAULT), not ignored
> test failed for case 007-simple-super-recover
> ------
> 
> [CAUSE]
> In __open_ctree_fd(), if we have valid @open_ctree_flags and
> btrfs_scan_fs_devices() successes without problem, no matter what
> happens we will call btrfs_close_devices(), thus free all related
> devices.

Why do you think it's _always_ going to be called? Looking into that
function it seems this can happen if
btrfs_setup_chunk_tree_and_device_map fails.
> 
> In super-recover, before we call open_ctree(), we have called
> btrfs_scan_fs_devices() already, so btrfs_scan_fs_devices() should not
> fail in open_ctree(), fs_devices will always be freed in open_ctree() or
> close_ctree().

Isn't the actual issue just that we call close_ctree. So the actual life
time of fs_devices is :

1. Create in btrfs_scan_fs_devices called from btrfs_recover_superblocks
2. All other references to those fs_devices will just return the same
reference.
3. Calling close_ctree frees fs_devices.

> 
> [FIX]
> So in super-recover.c, we should not call btrfs_close_devices(), or we
> will find fs_devices->list get poisoned, and trigger segfault when
> exiting.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  super-recover.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/super-recover.c b/super-recover.c
> index 880fd7712546..86b3df9867dc 100644
> --- a/super-recover.c
> +++ b/super-recover.c
> @@ -292,9 +292,6 @@ int btrfs_recover_superblocks(const char *dname,
>  no_recover:
>  	recover_err_str(ret);
>  	free_recover_superblock(&recover);
> -	/* check if we have freed fs_devices in close_ctree() */
> -	if (!root)
> -		btrfs_close_devices(recover.fs_devices);
>  	return ret;
>  }
>  
> 
