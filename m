From: "Sebastian 'gonX' Jensen" <gonx@overclocked.net>
Subject: Changes in the RAID layout on the users side makes resizing
 impossible as of now
Date: Sat, 14 Aug 2010 13:20:53 +0200
Message-ID: <AANLkTimBcjsD+=dWufs24Ptw2Mi2Qd-RL2GsyWFcPXQX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hey guys,

I've changed the disk layout of my btrfs RAID array a couple of times,
yet still being a part of the same array, and my btrfs-show looks like
this:

> Label: none  uuid: 405f0d0b-ee4d-4426-9826-d2580d0c8d6c
>	Total devices 2 FS bytes used 80.50GB
>	devid    5 size 232.55GB used 101.88GB path /dev/sdf3
>	devid    7 size 189.82GB used 101.88GB path /dev/sda2

As you can see, there is no devid 1. This would seemingly be more of a
cosmetic issue than anything else, but

Unfortunately, I can not resize the array for some odd reason, no
matter what parameters I give it:

> # btrfs filesystem resize max /
> Resize '/' of 'max'
> ERROR: unable to resize '/'

> # btrfs filesystem resize max /dev/sdf3
> Resize '/dev/sdf3' of 'max'
> ERROR: unable to resize '/dev/sdf3'

> # btrfs filesystem resize max /dev/sda2
> Resize '/dev/sda2' of 'max'
> ERROR: unable to resize '/dev/sda2'

The drives are the right size, and so are the partitions. sda2 is
actually a 232.55GB partition just like sdf3, so it should work
without issues at all, right?
This is the dmesg output I get when I try to give it the first
command, stating the mount directory (in this case, / )
> resizer unable to find device 1

It looks like the resizer is looking for device 1, rather than the
RAID array itself. That's why it'd work on single-drive btrfs systems,
but not on RAID arrays that have had the originating drive (drive 1)
removed.

It's not an issue for me as I don't need the additional space, but I
can imagine somebody else having an issue with this. I know there's a
patch available that allows you to increase the max size of the drives
through mounting (-o maxsize I think it was), but that could have the
issue as well (I haven't tried), or alternatively people would like to
only increase the size of their array/drive partially, or even shrink
it, which AFAIK there are no mount options that support.

Regards,
Sebastian J.
