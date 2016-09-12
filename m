Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:55153 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755281AbcILVtr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 17:49:47 -0400
Date: Mon, 12 Sep 2016 21:49:40 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        yauhen.kharuzhy@zavadatar.com, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH 02/13] btrfs: Do per-chunk check for mount time check
Message-ID: <20160912214940.GG7138@carfax.org.uk>
References: <1462889372-5274-1-git-send-email-anand.jain@oracle.com>
 <1462889372-5274-4-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="maH1Gajj2nflutpK"
In-Reply-To: <1462889372-5274-4-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--maH1Gajj2nflutpK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   What happened to these patches? (Particularly the per-chunk
degraded checks). We've just had someone on IRC who could have used
the capability...

   Hugo.

On Tue, May 10, 2016 at 10:09:21PM +0800, Anand Jain wrote:
> From: Qu Wenruo <quwenruo@cn.fujitsu.com>
> 
> Now use the btrfs_check_degraded() to do mount time degraded check.
> 
> With this patch, now we can mount with the following case:
>  # mkfs.btrfs -f -m raid1 -d single /dev/sdb /dev/sdc
>  # wipefs -a /dev/sdc
>  # mount /dev/sdb /mnt/btrfs -o degraded
>  As the single data chunk is only in sdb, so it's OK to mount as degraded,
>  as missing one device is OK for RAID1.
> 
> But still fail with the following case as expected:
>  # mkfs.btrfs -f -m raid1 -d single /dev/sdb /dev/sdc
>  # wipefs -a /dev/sdb
>  # mount /dev/sdc /mnt/btrfs -o degraded
>  As the data chunk is only in sdb, so it's not OK to mount it as degraded.
> 
> Reported-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> Reported-by: Anand Jain <anand.jain@oracle.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> 
> [Btrfs: use btrfs_error instead of btrfs_err during mount]
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/disk-io.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index d01f89d130e0..4f91a049fbca 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2885,6 +2885,16 @@ int open_ctree(struct super_block *sb,
>  		goto fail_tree_roots;
>  	}
>  
> +	ret = btrfs_check_degradable(fs_info, fs_info->sb->s_flags);
> +	if (ret < 0) {
> +		btrfs_err(fs_info, "degraded writable mount failed %d", ret);
> +		goto fail_tree_roots;
> +	} else if (ret > 0 && !btrfs_test_opt(chunk_root, DEGRADED)) {
> +		btrfs_warn(fs_info,
> +			"Some device missing, but still degraded mountable, please mount with -o degraded option");
> +		ret = -EACCES;
> +		goto fail_tree_roots;
> +	}
>  	/*
>  	 * keep the device that is marked to be the target device for the
>  	 * dev_replace procedure
> @@ -2988,14 +2998,6 @@ retry_root_backup:
>  	}
>  	fs_info->num_tolerated_disk_barrier_failures =
>  		btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
> -	if (fs_info->fs_devices->missing_devices >
> -	     fs_info->num_tolerated_disk_barrier_failures &&
> -	    !(sb->s_flags & MS_RDONLY)) {
> -		pr_warn("BTRFS: missing devices(%llu) exceeds the limit(%d), writeable mount is not allowed\n",
> -			fs_info->fs_devices->missing_devices,
> -			fs_info->num_tolerated_disk_barrier_failures);
> -		goto fail_sysfs;
> -	}
>  
>  	fs_info->cleaner_kthread = kthread_run(cleaner_kthread, tree_root,
>  					       "btrfs-cleaner");
> -- 
> 2.7.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Hugo Mills             | Anyone who says their system is completely secure
hugo@... carfax.org.uk | understands neither systems nor security.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                        Bruce Schneier

--maH1Gajj2nflutpK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJX1yLzAAoJEFheFHXiqx3k6x8QAKTNdw3V+QZKzPkXVSJ4AGFn
yqLs4efoV1SYlUIzbFTqAB7u/cBc/WjkTYejUGu+aJrr3+G5EHCrNMic9F+d3Qz2
/6G2pDbCiUyt1+J+2Fd9nnAsjlUao+Aka4BjprW+eBeJnO2ipwN8XvBiWeD8wImN
hAsGIpApql6QmenR40kHPywTrPowDmiNQVA1HpMLS9RW7pHpdm25TqJbtIFNSArZ
q3kno11hXmNXltXTw/ltfyWZD/Wq1z/aRDMnGxcRQMk73StlB/ADmy7mKPBkShpD
lfe80CGv/mCqYgx9baNSC9H10bRgKr/tHDgUNe7FYPdyQYKsH97O2lIZb2TyVYCI
0tcuORsy5wCQJf2Zd6IeAbdKOCnugTU5yUV+H4cj1elsTwlnUf568ymiuDeeX4O1
Z+0gxSxLKPkezq3sNDUTeeUjQi0eDVNTDLEWWn0qDe7u4NRPQWxE3OjHhRJG3mRe
nc6gvIYm7ObeZpTXJKAjl1VBaAixEgulytabRWdaPTCMPBElbkxs8dEwaN9wB32k
ARacLr21oHcsThhVQZpIBUOK4tKp9M0kFP+Gnu1q4J+hD62fN11wdphALfw6ej6X
+8prmH+YBQw9VXWxWgtIVMuQq7qtcKXwVBPG2g1Ho5p7d6HQTJIoLgT9vS0AYfMx
1Qachl+X2BEH+HRN0OMA
=HQFt
-----END PGP SIGNATURE-----

--maH1Gajj2nflutpK--
