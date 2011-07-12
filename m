From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: after mounting with -o degraded: ioctl: LOOP_CLR_FD: Device or
 resource busy
Date: Tue, 12 Jul 2011 13:09:50 +0300
Message-ID: <20110712100950.GA2041@zambezi.lan>
References: <CAJ1PRS=uL3xyJi57xz1taqh1mOYLUJDSRzUs3LsGBx7UVBG=Dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: "krzf83@gmail.com " <krzf83@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJ1PRS=uL3xyJi57xz1taqh1mOYLUJDSRzUs3LsGBx7UVBG=Dg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 12, 2011 at 02:47:41AM +0200, krzf83@gmail.com  wrote:
> dd if=/dev/null of=img5 bs=1 seek=2G
> dd if=/dev/null of=img6 bs=1 seek=2G
> mkfs.btrfs -d raid1 -m raid1 img5 img6
> losetup /dev/loop4 img5
> losetup /dev/loop5 img6
> btrfs device scan
> mount -t btrfs /dev/loop4 dir
> umount dir
> losetup -d /dev/loop5
> mount -t btrfs -o degraded /dev/loop4 dir
> umount dir
> losetup -d /dev/loop4
> ioctl: LOOP_CLR_FD: Device or resource busy
> mkfs.ext3 /dev/loop4
> mke2fs 1.39 (29-May-2006)
> /dev/loop4 is apparently in use by the system; will not make a filesystem here!
> 
> this only happens after mouting with -o degraded. loopback device is
> unusable until next reboot

So mkfs.ext3 fails to open device with O_EXCL.

We are missing blk_put() call on error path.  At least once: if
btrfs_open_devices() fails (and it does if you e.g. zero out the
superblock on a raid1 fs while it's unmounted and then immediately
mount) it's caller never releases the other device(s).  If nobody else
steps up I can try to fix this in the next couple of days.

Thanks,

		Ilya

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
