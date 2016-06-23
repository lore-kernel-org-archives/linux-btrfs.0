Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbcFWKRT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 06:17:19 -0400
Date: Thu, 23 Jun 2016 18:17:17 +0800
From: Eryu Guan <eguan@redhat.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: btrfs: fix 006 adds _runnt_btrfs_util_prog()
Message-ID: <20160623101717.GI3226@eguan.usersys.redhat.com>
References: <1466676096-15125-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1466676096-15125-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 23, 2016 at 06:01:36PM +0800, Anand Jain wrote:
> btrfs fi sync /mnt, now does not output anything for success,
> so the 006.out should be updated.

btrfs-progs v4.4 still outputs "FSSync '<mnt>'", it'd be good to state
starting from which version or commit the behavior changes.

> 
> Further created helper function _runnt_btrfs_utils_progs()
> which won't call _fail upon command failure, instead it just
> echo to stdout. This was required so to continue with the
> test script and do the cleanups at the end.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  common/rc           | 11 +++++++++++
>  tests/btrfs/006     |  2 +-
>  tests/btrfs/006.out |  1 -
>  3 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index a44fb8750220..2a10fbb2d341 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3114,6 +3114,17 @@ _min_dio_alignment()
>      fi
>  }
>  
> +run_check_dontfail()
> +{
> +	echo "# $@" >> $seqres.full 2>&1
> +	"$@" >> $seqres.full 2>&1 || echo "failed: '$@'"
> +}
> +
> +_runnt_btrfs_util_prog()
> +{
> +	run_check_dontfail $BTRFS_UTIL_PROG $*
> +}
> +

I don't think these helpers are necessary, because

>  run_check()
>  {
>  	echo "# $@" >> $seqres.full 2>&1
> diff --git a/tests/btrfs/006 b/tests/btrfs/006
> index 715fd80fb6fc..9d1fe09e07de 100755
> --- a/tests/btrfs/006
> +++ b/tests/btrfs/006
> @@ -79,7 +79,7 @@ echo "== Show filesystem by UUID"
>  $BTRFS_UTIL_PROG filesystem show $UUID | _filter_btrfs_filesystem_show $TOTAL_DEVS $UUID
>  
>  echo "== Sync filesystem"
> -$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT | _filter_scratch
> +_runnt_btrfs_util_prog filesystem sync $SCRATCH_MNT

$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT >/dev/null

just works. Any failure message goes to stderr and will be caught by
golden output check.

Thanks,
Eryu

>  
>  echo "== Show device stats by mountpoint"
>  $BTRFS_UTIL_PROG device stats $SCRATCH_MNT | _filter_btrfs_device_stats $TOTAL_DEVS
> diff --git a/tests/btrfs/006.out b/tests/btrfs/006.out
> index 22bcb777076a..05b9ac020737 100644
> --- a/tests/btrfs/006.out
> +++ b/tests/btrfs/006.out
> @@ -14,7 +14,6 @@ Label: 'TestLabel.006'  uuid: <EXACTUUID>
>  	devid <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
>  
>  == Sync filesystem
> -FSSync 'SCRATCH_MNT'
>  == Show device stats by mountpoint
>  <NUMDEVS> [SCRATCH_DEV].corruption_errs <NUM>
>  <NUMDEVS> [SCRATCH_DEV].flush_io_errs   <NUM>
> -- 
> 2.7.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
