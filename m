From: Calvin Walton <calvin.walton@gmail.com>
Subject: Re: can't mount RAID-1 btrfs after reboot
Date: Mon, 31 Aug 2009 01:21:44 -0400
Message-ID: <1251696114.5925.2.camel@ayu>
References: <4A852FB2.2030205@wpkg.org> <20090814104109.GO12579@kernel.dk>
	 <4A9B06BA.7060701@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-btrfs@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A9B06BA.7060701@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-08-31 at 01:09 +0200, Tomasz Chmielewski wrote:
> Jens Axboe wrote:
> 
> >> I'm able to mount the filesystem by using /dev/sdb4:
> >>
> >> # mount /dev/sdb4 /mnt/btrfs/
> >>
> >> After which I can unmount it, and use /dev/sda4 to mount the filesystem:
> >>
> >> # umount /dev/sdb4
> >> # mount /dev/sda4 /mnt/btrfs/
> > 
> > Try btrfsctl -a first.
> 
> It seems to do the trick.
> 
> I suppose longer term, doing "btrfsctl -a" before mounting a (RAID) 
> btrfs filesystem shouldn't be needed, or?

Shorter term, writing a udev rule along the lines of

ENV{ID_FS_TYPE}=="btrfs", RUN+="/sbin/btrfsctl -A %N"

(put it in /etc/udev/rules.d/64-btrfs-scan.rules or so) will cause your
btrfs to be scanned when found. Possibly something like this could be
distributed with btrfsprogs?

-- 
Calvin Walton <calvin.walton@gmail.com>

