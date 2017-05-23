Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31346 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761484AbdEWLNx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2017 07:13:53 -0400
Date: Tue, 23 May 2017 19:13:50 +0800
From: Eryu Guan <eguan@redhat.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] fstests: common: Make _test_mount to include
 MOUNT_OPTIONS to allow consistent _test_cycle_mount
Message-ID: <20170523111350.GZ7250@eguan.usersys.redhat.com>
References: <20170523080205.12556-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170523080205.12556-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 23, 2017 at 04:02:05PM +0800, Qu Wenruo wrote:
> [BUG]
> If using MOUNT_OPTIONS="-o nodatasum" and btrfs to run genierc/142
> generic/143 and generic/154, it will cause false alert like:
> cp: failed to clone '/mnt/test/test-154/file2' from '/mnt/test/test-154/file1': Invalid argument

MOUNT_OPTIONS is for scratch mount, and TEST_FS_MOUNT_OPTS is for test
dev mount, so I think setting TEST_FS_MOUNT_OPTS to "-o nodatasum"
should fix your problem.

Yeah, MOUNT_OPTIONS and TEST_FS_MOUNT_OPTS (and almost all other global
variables) are not documented properly..

Thanks,
Eryu

> 
> [REASON]
> It is caused by _test_cycle_mount function, which unmount test device,
> but when trying to re-mount it again using _test_mount(), we don't pass
> $MOUNT_OPTIONS.
> 
> So this makes mount options differs between _test_cycle_mount().
> 
> And btrfs doesn't allow different csum flags between reflink source and
> destination inodes, so it returns -EINVAL for reflink operation.
> 
> [FIX]
> Fix it by passing $MOUNT_OPTIONS to _test_mount(), so that
> _test_cycle_mount() won't cause different mount options.
> So btrfs with "-o nodatasum" mount option can pass generic/14[23]
> and generic/154 without false alert.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  common/rc | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/common/rc b/common/rc
> index ba215961..a591907c 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -522,7 +522,8 @@ _test_mount()
>          return $?
>      fi
>      _test_options mount
> -    _mount -t $FSTYP $TEST_OPTIONS $TEST_FS_MOUNT_OPTS $SELINUX_MOUNT_OPTIONS $* $TEST_DEV $TEST_DIR
> +    _mount -t $FSTYP $TEST_OPTIONS $TEST_FS_MOUNT_OPTS $SELINUX_MOUNT_OPTIONS \
> +		$MOUNT_OPTIONS $* $TEST_DEV $TEST_DIR
>  }
>  
>  _test_unmount()
> -- 
> 2.13.0
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
