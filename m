Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:19957 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab3CMPc5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Mar 2013 11:32:57 -0400
Message-ID: <51409C25.70403@giantdisaster.de>
Date: Wed, 13 Mar 2013 16:32:53 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfstests: btrfs tests for basic informational commands
References: <1363186623-1378-1-git-send-email-sandeen@redhat.com> <1363186623-1378-4-git-send-email-sandeen@redhat.com>
In-Reply-To: <1363186623-1378-4-git-send-email-sandeen@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 13 Mar 2013 09:57:03 -0500, Eric Sandeen wrote:
[...]
> +echo "== Show device stats by mountpoint"
> +$BTRFS_UTIL_PROG device stats $SCRATCH_MNT | _filter_btrfs_device_stats

Is the number of devices in SCRATCH_DEV_POOL fixed to 3? Otherwise you
should pipe the device-stats-by-mountpoint through "head -10" to avoid
failures if the number of devices is != 3.
Possible additional checks (but I am not sure that we really need this
additional level of detail in this check) would be:
1. The number of lines is 5 * number of devices.
2. The 5-line block that is printed for each device always looks the
same (after applying _filter_btrfs_device_stats).

> +echo "== Show device stats by first/scratch dev"
> +$BTRFS_UTIL_PROG device stats $SCRATCH_DEV | _filter_btrfs_device_stats
> +echo "== Show device stats by second dev"
> +$BTRFS_UTIL_PROG device stats $FIRST_POOL_DEV | sed -e "s,$FIRST_POOL_DEV,FIRST_POOL_DEV,g"
> +echo "== Show device stats by last dev"
> +$BTRFS_UTIL_PROG device stats $LAST_POOL_DEV | sed -e "s,$LAST_POOL_DEV,LAST_POOL_DEV,g"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/313.out b/313.out
> new file mode 100644
> index 0000000..1aa59a1
> --- /dev/null
> +++ b/313.out
> @@ -0,0 +1,51 @@
> +== QA output created by 313
> +== Set filesystem label to TestLabel.313
> +== Get filesystem label
> +TestLabel.313
> +== Mount.
> +== Show filesystem by label
> +Label: 'TestLabel.313'  uuid: <UUID>
> +	Total devices <EXACTNUM> FS bytes used <SIZE>
> +	devid     <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
> +
> +== Show filesystem by UUID
> +Label: 'TestLabel.313'  uuid: <EXACTUUID>
> +	Total devices <EXACTNUM> FS bytes used <SIZE>
> +	devid     <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
> +
> +== Sync filesystem
> +FSSync 'SCRATCH_MNT'
> +== Show device stats by mountpoint
> +[SCRATCH_DEV].write_io_errs   <NUM>
> +[SCRATCH_DEV].read_io_errs    <NUM>
> +[SCRATCH_DEV].flush_io_errs   <NUM>
> +[SCRATCH_DEV].corruption_errs <NUM>
> +[SCRATCH_DEV].generation_errs <NUM>
> +[SCRATCH_DEV].write_io_errs   <NUM>
> +[SCRATCH_DEV].read_io_errs    <NUM>
> +[SCRATCH_DEV].flush_io_errs   <NUM>
> +[SCRATCH_DEV].corruption_errs <NUM>
> +[SCRATCH_DEV].generation_errs <NUM>
> +[SCRATCH_DEV].write_io_errs   <NUM>
> +[SCRATCH_DEV].read_io_errs    <NUM>
> +[SCRATCH_DEV].flush_io_errs   <NUM>
> +[SCRATCH_DEV].corruption_errs <NUM>
> +[SCRATCH_DEV].generation_errs <NUM>

3 devices in this case.

> +== Show device stats by first/scratch dev
> +[SCRATCH_DEV].write_io_errs   <NUM>
> +[SCRATCH_DEV].read_io_errs    <NUM>
> +[SCRATCH_DEV].flush_io_errs   <NUM>
> +[SCRATCH_DEV].corruption_errs <NUM>
> +[SCRATCH_DEV].generation_errs <NUM>
> +== Show device stats by second dev
> +[FIRST_POOL_DEV].write_io_errs   0
> +[FIRST_POOL_DEV].read_io_errs    0
> +[FIRST_POOL_DEV].flush_io_errs   0
> +[FIRST_POOL_DEV].corruption_errs 0
> +[FIRST_POOL_DEV].generation_errs 0
> +== Show device stats by last dev
> +[LAST_POOL_DEV].write_io_errs   0
> +[LAST_POOL_DEV].read_io_errs    0
> +[LAST_POOL_DEV].flush_io_errs   0
> +[LAST_POOL_DEV].corruption_errs 0
> +[LAST_POOL_DEV].generation_errs 0
[...]

