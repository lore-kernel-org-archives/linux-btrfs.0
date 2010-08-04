From: Kyungmin Park <kmpark@infradead.org>
Subject: Re: [PATCH] btrfs: Add a new mount option to grow the FS to the limit
	of the device
Date: Wed, 4 Aug 2010 22:56:18 +0900
Message-ID: <AANLkTinCTLrz1cV9hutttvYe4K2VsNUjmD+tT4X2DFW5@mail.gmail.com>
References: <4C5684D8.4080702@samsung.com>
	<20100803114947.GO16630@think>
	<4C595053.5030305@samsung.com>
	<20100804133051.GF16630@think>
	<AANLkTimvk7EwpKvg4RicbhuuUnLXdf4bNZKUHS3aECUC@mail.gmail.com>
	<20100804134739.GG16630@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Kyungmin Park <kmpark@infradead.org>,
	Donggeun Kim <dg77.kim@samsung.com>,
	linux-btrfs@vger.kernel.org, kyungmin.park@samsung.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100804134739.GG16630@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 4, 2010 at 10:47 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
> On Wed, Aug 04, 2010 at 10:45:00PM +0900, Kyungmin Park wrote:
>> On Wed, Aug 4, 2010 at 10:30 PM, Chris Mason <chris.mason@oracle.com=
> wrote:
>> > On Wed, Aug 04, 2010 at 08:34:43PM +0900, Donggeun Kim wrote:
>> >> Chris Mason wrote:
>> >> > On Mon, Aug 02, 2010 at 05:42:00PM +0900, Donggeun Kim wrote:
>> >> >> In some cases, resizing a file system to the maximum device si=
ze is required.
>> >> >> When flashing a file system image to a block device,
>> >> >> the file system does not fit into the block device's size.
>> >> >> Currently, executing 'btrfsctl' application is the only way
>> >> >> to grow the file system to the limit of the device.
>> >> >> If the mount option which alters the device size of a file sys=
tem
>> >> >> to the limit of the device is supported,
>> >> >> it can be useful regardless of the existence of 'btrfsctl' pro=
gram.
>> >> >> This patch allows the file system to grow to the maximum size =
of the device
>> >> >> on mount time.
>> >> >> The new mount option name is 'maxsize'.
>> >> >
>> >> > I think this is a very useful feature, but could you please cha=
nge the
>> >> > patch to allow controlling which device is resized?
>> >> >
>> >> > The ioctl allows you to pass in a device number (where the numb=
er comes
>> >> > from btrfs-show)
>> >> >
>> >> > Thanks!
>> >> >
>> >> > -chris
>> >> >
>> >> I'm sorry not to fully understand your comment.
>> >> Do you mean that device file name for being resized is specified =
after 'maxsize' mount option?
>> >> e.g) #mount -o maxsize=3D/dev/sda1 ...
>> >
>> > In the resize ioctl you can pass a device number, something like 2=
:max,
>> > which allows you to say make device #2 the full size of the device=
=2E
>> >
>> > btrfs-show can be used to find the correct device number for a giv=
en
>> > disk. =A0We don't use the device name because the scan might have =
found a
>> > different device name to tie into the FS.
>> >
>> > Thanks,
>> > Chris
>>
>> Before comments this issues. I first explain why this feature implem=
ented.
>>
>> As you know, we implement the build image from some specific
>> directory. the size is maybe small than designed devices. e.g., buil=
d
>> image got the 400MiB but real device size has more the 8GiB.
>> after program the btrfs image, then it will be expanded at first boo=
t only.
>
> Yes, and this makes a lot of sense to me. =A0I can see how the patch =
fits
> your usage and that you don't need the extra flag to pick a device on
> mounting.
>
>>
>> Initial draft design is that add the some flag at build image. then =
it
>> checks it at first mount time. and expand to device size.
>> But after some study we know that btrfs supports resize feature. So =
we
>> implement it as patch.
>> Anyway that's our requirement.
>>
>> as you provided usage, can you use the ioctl to achieve this
>> requirement? if not, we need to another method.
>
> Yes, the ioctl can currently pick a device to resize. =A0In your case=
,
> there will only be one device and this isn't an issue. =A0But, I'd li=
ke to
> see parity between what the mount option can do and what the ioctl ca=
n
> do, just so we are a little more consistent.
>

Then when call the ioctl? in the phone. the boot script is almost
fixed. and not easy to check first boot.
Mr. Kim said the check real size happen every time at mount if apply
patch. but it don't take time if it's already expanded. I think ioctl
has also same problem. if we use this method.
I don't want to call ioctl at every boot time. does it just my hope?

Thank you,
Kyungmin Park

>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
