Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709AbcCUMHJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 08:07:09 -0400
Date: Mon, 21 Mar 2016 20:07:06 +0800
From: Eryu Guan <eguan@redhat.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, chandan@mykolab.com
Subject: Re: [PATCH V2] _btrfs_stress_subvolume: Fix race condition by making
 'subvolume stress' task to exit gracefully
Message-ID: <20160321120706.GE11419@eguan.usersys.redhat.com>
References: <1458545992-32114-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458545992-32114-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 21, 2016 at 01:09:52PM +0530, Chandan Rajendra wrote:
> The following scenario can occur when running btrfs/066,
> 
>   Task A                                Task B                     Task C
> 
>   run_test()
>   - Execute _btrfs_stress_subvolume()
>     in a background shell.
>                                         _btrfs_stress_subvolme()
>                                           ...
>                                         - fork & exec "mount"
>                                                	      		   Mount subvolume on directory in $TEST_DIR
>   - Wait for fsstress to finish                                    do_mount()
>   - kill shell process executing                                   - btrfs_mount()
>     _btrfs_stress_subvolume()
>     i.e. Task B.
>   - Init process becomes the parent
>     of "subvolume mount" task
>     i.e. Task C.
>   - In case subvolume is mounted
>     (which is not the case),
>     unmount it.
>                                                                    - Complete mounting subvolume
> 
> Hence on the completion of one iteration of run_test(), the subvolume
> created inside the filesystem on $SCRATCH_DEV continues to be mounted on
> $TEST_DIR/$seq.mnt. Subsequent invocations of run_test() (called for
> remaining Btrfs profile configs) fail during _scratch_pool_mkfs.
> 
> Instead of killing the 'subvolume stress' task this commit makes
> _btrfs_stress_subvolume() to break out of the loop when a file exists
> on the filesystem. The commit also makes relevant changes to other
> users of _btrfs_stress_subvolume() i.e. btrfs/060, btrfs/065,
> btrfs/067 & btrfs/068.
> 
> Suggested-by: Eryu Guan <eguan@redhat.com>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
> Changelog:
> 
> V1->V2: Instead of named pipes, Use a file to let 'subvolume stress' task know
> that it should break from the while loop.
> 
>  common/rc       | 3 ++-
>  tests/btrfs/060 | 8 ++++++--
>  tests/btrfs/065 | 8 ++++++--
>  tests/btrfs/066 | 8 ++++++--
>  tests/btrfs/067 | 8 ++++++--
>  tests/btrfs/068 | 8 ++++++--
>  6 files changed, 32 insertions(+), 11 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 16f5a43..7d971ea 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3280,9 +3280,10 @@ _btrfs_stress_subvolume()
>  	local btrfs_mnt=$2
>  	local subvol_name=$3
>  	local subvol_mnt=$4
> +	local stop_file=$stop_file

This should be "local stop_file=$5"

Otherwise looks good to me, at least there's no regression, all affected
tests still pass for me and no other tests fail because of unclean exit
from previous test.

Reviewed-by: Eryu Guan <eguan@redhat.com>
