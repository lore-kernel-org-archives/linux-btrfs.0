Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20640 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab3F0H0m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Jun 2013 03:26:42 -0400
Message-ID: <51CBEA31.1020302@oracle.com>
Date: Thu, 27 Jun 2013 15:30:57 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, sandeen@redhat.com,
        zab@redhat.com
Subject: Re: [PATCH] xfstests: fix SCRATCH_DEV_POOL mount/umount issues
References: <1372298261-16801-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1372298261-16801-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/27/2013 09:57 AM, Josef Bacik wrote:
> If you use the SCRATCH_DEV_POOL for btrfs you will end up with the command line
> like this
>
> mkfs.btrfs $SCRATCH_DEV_POOL $SCRATCH_DEV

> and btrfs does this thing where it makes the lowest valued device id show up in
> /proc/mounts no matter which device you specify at the mount command.  So in
> this case mount will show the first device in $SCRATCH_DEV_POOL instead of
> $SCRATCH_DEV,

  The first item in the SCRATCH_DEV_POOL is assigned to SCRATCH_DEV.
  The remaining will be used where more than one disk is needed.

> so anybody who wants to just use the scratch mnt with the scratch
> dev will fail to work because we never unmount the scratch mount.


>  Fix this by
> checking to see if the scratch dev pool is mounted at scratch mnt and unmount it
> so we can run our test.  Also fix scratch_unmount to call umount $SCRATCH_MNT
> instead of unmount $SCRATCH_DEV so it doesn't screw up with tests that use
> $SCRATCH_DEV_POOL.  This fixes the issue I was seeing by running
>
> ./check btrfs/307 generic/015
>
> Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>   common/rc |   19 ++++++++++++++++++-
>   1 files changed, 18 insertions(+), 1 deletions(-)
>
> diff --git a/common/rc b/common/rc
> index ad7cbc9..6e3ad65 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -280,7 +280,7 @@ _scratch_mount()
>
>   _scratch_unmount()
>   {
> -    $UMOUNT_PROG $SCRATCH_DEV
> +    $UMOUNT_PROG $SCRATCH_MNT
>   }

  This will fix the above problem for the reason mentioned.

>   _scratch_remount()
> @@ -938,6 +938,8 @@ _supported_os()
>   #
>   _require_scratch()
>   {
> +    local i
> +
>       case "$FSTYP" in
>   	nfs*)
>   		 echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
> @@ -978,6 +980,21 @@ _require_scratch()
>               exit 1
>           fi
>       fi
> +
> +    # we may have a scratch dev pool specified, so make sure it's been unmounted
> +    # from the scratch mount
> +    for i in $SCRATCH_DEV_POOL; do
> +        if _mount | grep -q $i; then
> +            if ! _mount | grep $i | grep -q $SCRATCH_MNT; then
> +                echo "\$SCRATCH_DEV_POOL is mounted but not on \$SCRATCH_MNT - aborting"
> +                exit 1
> +            fi
> +            if ! $UMOUNT_PROG $i; then
> +                echo "failed to umount $i - aborting"
> +                exit 1
> +            fi
> +        fi
> +    done
>   }

   This looks some additional checks beyond the fix for above problem.
   Or did I miss something ? Further _is_mounted() can be used here.



Thanks
Anand
