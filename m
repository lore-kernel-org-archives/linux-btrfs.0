Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56707 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab3IFODk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Sep 2013 10:03:40 -0400
Date: Fri, 6 Sep 2013 16:03:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests: fix device lookup in btrfs/003
Message-ID: <20130906140337.GK32382@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <52266055.9050004@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52266055.9050004@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 03, 2013 at 06:19:01PM -0400, Jeff Mahoney wrote:
> The DEVHTL lookup in btrfs/003 is broken. It can only handle full LUNs and
> not partitions on a disk.
>
> Rather than returning 2:0:0:0 for /dev/sdc7, it returns 'block' and we see:
> ./common/rc: line 2081: /sys/class/scsi_device/block/device/delete:
> No such file or directory
>
> If we look up the device by dev instead of by name, we can handle working
> with full disks and partitions more easily and get the ability to use
> any device name rather than just the ones that match sysfs.
> 
> @@ -137,9 +137,21 @@ _test_replace()
>  	#pick the 2nd last disk 
>  	ds=${devs[@]:$(($n-1)):1}
>  
> -	# retrive the HTL for this scsi disk
> -	d=`echo $ds|cut -d"/" -f3`
> -	DEVHTL=`ls -l /sys/class/block/${d} | rev | cut -d "/" -f 3 | rev`
> +	HEXMAJOR="$(stat -c "%t" "$ds")"
> +	HEXMINOR="$(stat -c "%T" "$ds")"
> +	if [ -z "$HEXMAJOR" -o -z "$HEXMINOR" ]; then
> +		_fail "tr: HEXMAJOR and/or HEXMINOR is unset for $ds"
> +	fi
> +
> +	DIR="/sys/dev/block/$(( 0x$HEXMAJOR )):$(( 0x$HEXMINOR ))"
> +
> +	if [ -L "$DIR/device" ]; then # whole disk
> +		DEVHTL="$(basename $(readlink "$DIR/device"))"
> +	elif [ -L "$DIR/../device" ]; then # partition
> +		DEVHTL="$(basename $(readlink "$DIR/../device"))"
> +	else
> +		_fail "tr: Can't locate device backing $ds"
> +	fi
>  
>  	#fail disk
>  	_devmgt_remove ${DEVHTL}

The test assumes tha SCRATCH_DEV_POOL consists of standalone devices
and more strongly that they can be removed from the system by

$ echo 1 > /sys/class/scsi_device/sdx/device/delete

via _devmgt_remove. Ordinary sdX devices are ok, but eg. MD devices are
not because they do not have a corresponding "2:0:0:0"-like entry (I
haven't checked device-mapper devices).

Looks like the tests have to do more fine grained checks of the devices
in SCRATCH_DEV_POOL because eg. the 'device replace' test btrfs/011 is
just fine with partitions.


david
