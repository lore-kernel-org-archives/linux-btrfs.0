From: Anand Jain <Anand.Jain@oracle.com>
Subject: Re: device failure hangs the system
Date: Thu, 07 Jul 2011 17:35:51 +0800
Message-ID: <4E157DF7.4070404@oracle.com>
References: <4E0D929E.7030704@oracle.com> <4E0E2AAD.1020406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E0E2AAD.1020406@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>



Josef,


> Well that's a neat trick, do you have a way to undo that action too?
> Seems a rescan doesn't make it show back up.


hope the following helps..
-------------
  # fdisk -l /dev/sdg | egrep "Disk /"
  Disk /dev/sdg: 4294 MB, 4294967296 bytes

  # x=`ls -l /sys/class/block/sdg | cut -d "/" -f12 | sed 's/:/ /g'`
  # echo "scsi remove-single-device ${x}" > /proc/scsi/scsi

  # fdisk -l /dev/sdg | egrep "Disk /"

  # echo "scsi add-single-device ${x}" > /proc/scsi/scsi

  # fdisk -l /dev/sdg | egrep "Disk /"
  Disk /dev/sdg: 4294 MB, 4294967296 bytes
-------------


>  Please try the patch I just posted to the list to fix this problem.  Thanks,

  Facing some challenges to upgrade my machine to 3.0.0-rc6, so is
  the delay.

  Thanks for the patch.

Anand

> Josef
