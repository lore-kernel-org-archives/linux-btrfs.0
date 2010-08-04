From: Donggeun Kim <dg77.kim@samsung.com>
Subject: Re: [PATCH] btrfs: Add a new mount option to grow the FS to the limit
 of the device
Date: Wed, 04 Aug 2010 20:34:43 +0900
Message-ID: <4C595053.5030305@samsung.com>
References: <4C5684D8.4080702@samsung.com> <20100803114947.GO16630@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, kyungmin.park@samsung.com
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20100803114947.GO16630@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Mon, Aug 02, 2010 at 05:42:00PM +0900, Donggeun Kim wrote:
>> In some cases, resizing a file system to the maximum device size is required.
>> When flashing a file system image to a block device,
>> the file system does not fit into the block device's size.
>> Currently, executing 'btrfsctl' application is the only way
>> to grow the file system to the limit of the device.
>> If the mount option which alters the device size of a file system
>> to the limit of the device is supported,
>> it can be useful regardless of the existence of 'btrfsctl' program.
>> This patch allows the file system to grow to the maximum size of the device
>> on mount time.
>> The new mount option name is 'maxsize'.
> 
> I think this is a very useful feature, but could you please change the
> patch to allow controlling which device is resized?
> 
> The ioctl allows you to pass in a device number (where the number comes
> from btrfs-show)
> 
> Thanks!
> 
> -chris
> 
I'm sorry not to fully understand your comment.
Do you mean that device file name for being resized is specified after 'maxsize' mount option?
e.g) #mount -o maxsize=/dev/sda1 ...

Thank you.
