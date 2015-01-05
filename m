Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbbAEDZ1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 4 Jan 2015 22:25:27 -0500
Date: Mon, 5 Jan 2015 11:25:20 +0800
From: Eryu Guan <eguan@redhat.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, fdmanana@gmail.com
Subject: Re: [PATCH v2] xfstests: btrfs: fix up 001.out
Message-ID: <20150105032520.GI16685@dhcp-13-216.nay.redhat.com>
References: <1420055304-4633-1-git-send-email-anand.jain@oracle.com>
 <1420203869-26085-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1420203869-26085-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 02, 2015 at 09:04:29PM +0800, Anand Jain wrote:
> The subvol delete output has changed with btrfs-progs

Better to point out that since which btrfs-progs version the output
changed.

>     -Delete subvolume 'SCRATCH_MNT/snap'
>     +Delete subvolume (no-commit): 'SCRATCH_MNT/snap'
> 
> so fix 001 failing.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> v2: Thanks Filipe for mentioning now we have _run_btrfs_util_prog. and
>     commit update

I think a better way to fix this is to update the
_filter_btrfs_subvol_delete filter

Right now the filter does delete message about transaction commit:

	sed -e "/Transaction commit: none (default)/d"

Just adding another -e to sed to delete the "(no-commit):" part is fine.

Thanks,
Eryu
> ---
>  tests/btrfs/001     | 2 +-
>  tests/btrfs/001.out | 1 -
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/tests/btrfs/001 b/tests/btrfs/001
> index 8258d06..a7747c8 100755
> --- a/tests/btrfs/001
> +++ b/tests/btrfs/001
> @@ -99,7 +99,7 @@ echo "Listing subvolumes"
>  $BTRFS_UTIL_PROG subvolume list $SCRATCH_MNT | awk '{ print $NF }'
>  
>  # Delete the snapshot
> -$BTRFS_UTIL_PROG subvolume delete $SCRATCH_MNT/snap | _filter_btrfs_subvol_delete
> +_run_btrfs_util_prog subvolume delete $SCRATCH_MNT/snap
>  echo "List root dir"
>  ls $SCRATCH_MNT
>  _scratch_remount
> diff --git a/tests/btrfs/001.out b/tests/btrfs/001.out
> index c782bde..43e8c56 100644
> --- a/tests/btrfs/001.out
> +++ b/tests/btrfs/001.out
> @@ -33,7 +33,6 @@ subvol
>  Listing subvolumes
>  snap
>  subvol
> -Delete subvolume 'SCRATCH_MNT/snap'
>  List root dir
>  subvol
>  List root dir
> -- 
> 2.0.0.153.g79dcccc
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
