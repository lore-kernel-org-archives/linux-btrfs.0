From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] Added test case 259 for the btrfs raid features
Date: Fri, 2 Sep 2011 04:49:41 -0400
Message-ID: <20110902084941.GB29054@infradead.org>
References: <4E3BA2F7.4080500@oracle.com>
 <4E44351D.4020202@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com, Chris Mason <chris.mason@oracle.com>
To: Anand Jain <Anand.Jain@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E44351D.4020202@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 12, 2011 at 04:01:33AM +0800, Anand Jain wrote:
> Added test case 259 for the btrfs raid features. SCRATCH_DEV_POOL must
> be set to 2 or more disks.

Any chance you can document how SCRATCH_DEV_POOL is supposed to be
used in the README file?  An addition patch is fine, no need to update
the existing ones.    Also is there a chance you could allow setting
only SCRATCH_DEV_POOL for btrfs, and derive SCRATCH_DEV for that as an
additional step?

> +# arg 1 remove/add
> +# arg 2 /dev/sdx or return of devmgt resply
> +_devmgt()
> +{
> +	local x
> +	local d
> +
> +	if [ $1 == "remove" ]; then
> +		d=`echo $2|cut -d"/" -f3`
> +		x=`ls -l /sys/class/block/${d} | cut -d "/" -f12 | sed 's/:/ /g'`
> +		echo "scsi remove-single-device ${x}" > /proc/scsi/scsi || _fail
> "Remove disk failed"
> +		DEVHTL=${x}
> +	else
> +		echo "scsi add-single-device ${2}" > /proc/scsi/scsi || _fail
> "Add disk failed"
> +	fi
> +}

Please use the sysfs interface instead of the deprecated /proc/scsi/scsi
interface.  I would also suggest to split this routine into two for
removing and adding, and move them to the common helper library, so it
could be used for other tests.

> +# we need this to test removing a dev from the system
> +_require_proc_scsi()
> +{
> +	[ -e /proc/scsi/scsi ]  || _notrun "/proc/scsi/scsi is not present"
> +}

The _require need really is that the device you want to work on is a
SCSI device.

