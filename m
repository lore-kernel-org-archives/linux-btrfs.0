From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs and /proc/self/mountinfo
Date: Mon, 13 Apr 2009 09:40:51 -0400
Message-ID: <1239630051.24841.12.camel@think.oraclecorp.com>
References: <7b13a0f80904120735r41736455hb7e226ab8ad30bd7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: David Zeuthen <zeuthen@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <7b13a0f80904120735r41736455hb7e226ab8ad30bd7@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2009-04-12 at 10:35 -0400, David Zeuthen wrote:
> Hi,
> 
> I have a question about how btrfs is supposed to work with
> /proc/self/mountinfo. It appears that the dev_t isn't matching what
> one would expect when mounting a btrfs filesystem - here's /dev/sdb2
> mounted at /media/usb-fedora
> 
>  # cat /proc/self/mountinfo |grep btrfs
>  17 19 0:19 / /media/usb-fedora rw,nosuid,nodev,relatime - btrfs /dev/sdb2 rw
> 

Yes, this is because I switched to an anonymous super to remove
restrictions about which devices could be removed from a mounted
filesystem. 

Today it is possible to do something like this:

mkfs.ext3 /dev/sdb
mkfs.ext3 /dev/sdc

mount /dev/sdb /mnt
mount /dev/sdc /mnt

Which gives me this in mountinfo:

29 14 8:16 / /mnt rw - ext3 /dev/sdb rw,errors=continue,data=ordered
31 29 8:32 / /mnt rw - ext3 /dev/sdc rw,errors=continue,data=ordered

So, applications can already see duplicate device entries for the same
mount point.  Do they deal with that today?  I'm not sure I'll be able
to get control over the dev_ts mountinfo spits out just for btrfs, but
we can always float a patch.

Otherwise, we'll have to use the sysfs goo Kay is working on.

-chris


