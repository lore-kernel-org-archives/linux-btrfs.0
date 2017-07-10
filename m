Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48535 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753563AbdGJNMr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Jul 2017 09:12:47 -0400
Subject: Re: [PATCH] btrfs: resume qgroup rescan on rw remount
To: Aleksa Sarai <asarai@suse.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>
References: <20170704114906.8419-1-asarai@suse.de>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <725eb058-4fb4-a167-9ba4-a062de718555@suse.com>
Date: Mon, 10 Jul 2017 16:12:43 +0300
MIME-Version: 1.0
In-Reply-To: <20170704114906.8419-1-asarai@suse.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  4.07.2017 14:49, Aleksa Sarai wrote:
> Several distributions mount the "proper root" as ro during initrd and
> then remount it as rw before pivot_root(2). Thus, if a rescan had been
> aborted by a previous shutdown, the rescan would never be resumed.
> 
> This issue would manifest itself as several btrfs ioctl(2)s causing the
> entire machine to hang when btrfs_qgroup_wait_for_completion was hit
> (due to the fs_info->qgroup_rescan_running flag being set but the rescan
> itself not being resumed). Notably, Docker's btrfs storage driver makes
> regular use of BTRFS_QUOTA_CTL_DISABLE and BTRFS_IOC_QUOTA_RESCAN_WAIT
> (causing this problem to be manifested on boot for some machines).
> 
> Cc: <stable@vger.kernel.org> # v3.11+
> Cc: Jeff Mahoney <jeffm@suse.com>
> Fixes: b382a324b60f ("Btrfs: fix qgroup rescan resume on mount")
> Signed-off-by: Aleksa Sarai <asarai@suse.de>

Indeed, looking at the code it seems that b382a324b60f ("Btrfs: fix
qgroup rescan resume on mount") missed adding the qgroup_rescan_resume
in the remount path. One thing which I couldn't verify though is whether
reading fs_info->qgroup_flags without any locking is safe from remount
context.

During remount I don't see any locks taken that prevent operations which
can modify qgroup_flags.



> ---
>  fs/btrfs/super.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 6346876c97ea..ff6690389343 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1821,6 +1821,8 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
>  			goto restore;
>  		}
>  
> +		btrfs_qgroup_rescan_resume(fs_info);
> +
>  		if (!fs_info->uuid_root) {
>  			btrfs_info(fs_info, "creating UUID tree");
>  			ret = btrfs_create_uuid_tree(fs_info);
> 
