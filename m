From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH 3/3] Added test case 259 for the btrfs raid features
Date: Mon, 03 Oct 2011 16:55:59 +0530
Message-ID: <4E899BC7.6070607@oracle.com>
References: <4E3BA2F7.4080500@oracle.com> <4E44351D.4020202@oracle.com> <20110902084941.GB29054@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com, Chris Mason <chris.mason@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110902084941.GB29054@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>


Christoph,

  apologies for the delay I was on a long leave.


> Also is there a chance you could allow setting
> only SCRATCH_DEV_POOL for btrfs, and derive SCRATCH_DEV for that as an
> additional step?

  There is some challenge to set SCRATCH_DEV based on FSTYP since
  SCRATCH_DEV is used even before FSTYP is set.

  common.config uses SCRATCH_DEV and we set FSTYP in common.
  check calls these two script files in the following logic.
  --------------------------
  # we need common.config
  if ! . ./common.config
  then
     echo "$iam: failed to source common.config"
     exit 1
  fi

  # we need common
  . ./common
  ---------------------------

  to avoid major changes what we could do is to find-out FSTYP on our
  own in the file common.config and set SCRATCH_DEV based on
  SCRATCH_DEV_POOL, but thats a bit ugly way. I am open to any
  suggestions. thanks.



> Please use the sysfs interface instead of the deprecated /proc/scsi/scsi
> interface.  I would also suggest to split this routine into two for
> removing and adding, and move them to the common helper library, so it
> could be used for other tests.

yes. will get something like below code. in the common

-----
remove:
echo 1 > 
/sys/class/scsi_device/${host}:${channel}:${id}:${lun}/device/delete

add:
echo "$channel $id $lun" > /sys/class/scsi_host/host${host}/scan
-----


>> +# we need this to test removing a dev from the system
>> +_require_proc_scsi()
>> +{
>> +	[ -e /proc/scsi/scsi ]  || _notrun "/proc/scsi/scsi is not present"
>> +}
> 
> The _require need really is that the device you want to work on is a
> SCSI device.

will get this.

Thanks -Anand
