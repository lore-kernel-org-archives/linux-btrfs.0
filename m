From: Chris Mason <chris.mason@oracle.com>
Subject: Re: replacing failed disks in RAID-1 (kernel BUG)?
Date: Tue, 14 Jul 2009 13:27:02 -0400
Message-ID: <20090714172702.GI3783@think>
References: <4A5B0C39.5030905@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A5B0C39.5030905@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 13, 2009 at 12:28:09PM +0200, Tomasz Chmielewski wrote:
> How do I replace failed disks in RAID-1 mode?
>
> I followed the http://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices, but it triggered a kernel BUG (using 2.6.30.1 kernel):
>
>
> # mount -o degraded /dev/sdb4 /mnt/btrfs/
>
> # btrfs-vol -r missing /mnt/btrfs/
> removing missing devices from /mnt/btrfs/
> ioctl returns -1
>
> # dmesg -c
> btrfs: unable to go below two devices on raid1
>
> # btrfs-vol -a /dev/sda4 /mnt/btrfs/
> Speicherzugriffsfehler

So, this should have worked.  I'll dig into why the btrfs-vol -a failed.

-chris
