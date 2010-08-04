From: Kyungmin Park <kmpark@infradead.org>
Subject: Re: [PATCH] btrfs: Add a new mount option to grow the FS to the limit
	of the device
Date: Wed, 4 Aug 2010 22:45:00 +0900
Message-ID: <AANLkTimvk7EwpKvg4RicbhuuUnLXdf4bNZKUHS3aECUC@mail.gmail.com>
References: <4C5684D8.4080702@samsung.com>
	<20100803114947.GO16630@think>
	<4C595053.5030305@samsung.com>
	<20100804133051.GF16630@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Donggeun Kim <dg77.kim@samsung.com>,
	linux-btrfs@vger.kernel.org, kyungmin.park@samsung.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100804133051.GF16630@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 4, 2010 at 10:30 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
> On Wed, Aug 04, 2010 at 08:34:43PM +0900, Donggeun Kim wrote:
>> Chris Mason wrote:
>> > On Mon, Aug 02, 2010 at 05:42:00PM +0900, Donggeun Kim wrote:
>> >> In some cases, resizing a file system to the maximum device size =
is required.
>> >> When flashing a file system image to a block device,
>> >> the file system does not fit into the block device's size.
>> >> Currently, executing 'btrfsctl' application is the only way
>> >> to grow the file system to the limit of the device.
>> >> If the mount option which alters the device size of a file system
>> >> to the limit of the device is supported,
>> >> it can be useful regardless of the existence of 'btrfsctl' progra=
m.
>> >> This patch allows the file system to grow to the maximum size of =
the device
>> >> on mount time.
>> >> The new mount option name is 'maxsize'.
>> >
>> > I think this is a very useful feature, but could you please change=
 the
>> > patch to allow controlling which device is resized?
>> >
>> > The ioctl allows you to pass in a device number (where the number =
comes
>> > from btrfs-show)
>> >
>> > Thanks!
>> >
>> > -chris
>> >
>> I'm sorry not to fully understand your comment.
>> Do you mean that device file name for being resized is specified aft=
er 'maxsize' mount option?
>> e.g) #mount -o maxsize=3D/dev/sda1 ...
>
> In the resize ioctl you can pass a device number, something like 2:ma=
x,
> which allows you to say make device #2 the full size of the device.
>
> btrfs-show can be used to find the correct device number for a given
> disk. =A0We don't use the device name because the scan might have fou=
nd a
> different device name to tie into the FS.
>
> Thanks,
> Chris

Before comments this issues. I first explain why this feature implement=
ed.

As you know, we implement the build image from some specific
directory. the size is maybe small than designed devices. e.g., build
image got the 400MiB but real device size has more the 8GiB.
after program the btrfs image, then it will be expanded at first boot o=
nly.

Initial draft design is that add the some flag at build image. then it
checks it at first mount time. and expand to device size.
But after some study we know that btrfs supports resize feature. So we
implement it as patch.
Anyway that's our requirement.

as you provided usage, can you use the ioctl to achieve this
requirement? if not, we need to another method.

Please give your ideas.

Thank you,
Kyungmin Park
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
