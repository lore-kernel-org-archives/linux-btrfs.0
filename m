From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs: Add a new mount option to grow the FS to the
 limit of the device
Date: Wed, 4 Aug 2010 09:30:51 -0400
Message-ID: <20100804133051.GF16630@think>
References: <4C5684D8.4080702@samsung.com>
 <20100803114947.GO16630@think>
 <4C595053.5030305@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, kyungmin.park@samsung.com
To: Donggeun Kim <dg77.kim@samsung.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C595053.5030305@samsung.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 04, 2010 at 08:34:43PM +0900, Donggeun Kim wrote:
> Chris Mason wrote:
> > On Mon, Aug 02, 2010 at 05:42:00PM +0900, Donggeun Kim wrote:
> >> In some cases, resizing a file system to the maximum device size is required.
> >> When flashing a file system image to a block device,
> >> the file system does not fit into the block device's size.
> >> Currently, executing 'btrfsctl' application is the only way
> >> to grow the file system to the limit of the device.
> >> If the mount option which alters the device size of a file system
> >> to the limit of the device is supported,
> >> it can be useful regardless of the existence of 'btrfsctl' program.
> >> This patch allows the file system to grow to the maximum size of the device
> >> on mount time.
> >> The new mount option name is 'maxsize'.
> > 
> > I think this is a very useful feature, but could you please change the
> > patch to allow controlling which device is resized?
> > 
> > The ioctl allows you to pass in a device number (where the number comes
> > from btrfs-show)
> > 
> > Thanks!
> > 
> > -chris
> > 
> I'm sorry not to fully understand your comment.
> Do you mean that device file name for being resized is specified after 'maxsize' mount option?
> e.g) #mount -o maxsize=/dev/sda1 ...

In the resize ioctl you can pass a device number, something like 2:max,
which allows you to say make device #2 the full size of the device.

btrfs-show can be used to find the correct device number for a given
disk.  We don't use the device name because the scan might have found a
different device name to tie into the FS.

Thanks,
Chris
