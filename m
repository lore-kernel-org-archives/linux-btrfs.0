Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888AbcGED4T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jul 2016 23:56:19 -0400
Date: Tue, 5 Jul 2016 11:56:17 +0800
From: Eryu Guan <eguan@redhat.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH 19/20] xfs: run xfs_repair at the end of each test
Message-ID: <20160705035617.GD23649@eguan.usersys.redhat.com>
References: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
 <146612808160.25024.5986137574652014794.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <146612808160.25024.5986137574652014794.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 16, 2016 at 06:48:01PM -0700, Darrick J. Wong wrote:
> Run xfs_repair twice at the end of each test -- once to rebuild
> the btree indices, and again with -n to check the rebuild work.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/rc |    3 +++
>  1 file changed, 3 insertions(+)
> 
> 
> diff --git a/common/rc b/common/rc
> index 1225047..847191e 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2225,6 +2225,9 @@ _check_xfs_filesystem()
>          ok=0
>      fi
>  
> +    $XFS_REPAIR_PROG $extra_options $extra_log_options $extra_rt_options $device >$tmp.repair 2>&1
> +    cat $tmp.repair | _fix_malloc		>>$seqres.full
> +

Won't this hide fs corruptions? Did I miss anything?

Thanks,
Eryu

>      $XFS_REPAIR_PROG -n $extra_options $extra_log_options $extra_rt_options $device >$tmp.repair 2>&1
>      if [ $? -ne 0 ]
>      then
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
