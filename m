From: "krzf83@gmail.com " <krzf83@gmail.com>
Subject: Re: feature request: btrfs-image without zeroing data
Date: Mon, 11 Jul 2011 14:39:18 +0200
Message-ID: <CAJ1PRSnyU5G5_08UtGKvhTQUEOvK+KSYo7WQV06N5Qn8efPXgw@mail.gmail.com>
References: <CAJ1PRSn6TBnzXaSQSEffb15oH4+jncKE5ydCipcT6HHt1U=GLw@mail.gmail.com>
	<20110711093156.GB2537@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110711093156.GB2537@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

2011/7/11 Stephane Chazelas <stephane_chazelas@yahoo.fr>:
> 2011-07-11 02:00:51 +0200, krzf83@gmail.com :
>> Documentation says that btrfs-image zeros data. Feature request is for
>> disabling this. btrfs-image could be used to copy filesystem to
>> another drive (for example with snapshots, when copying it file by
>> file would take much longer time or acctualy was not possible
>> (snapshots)). btrfs-image in turn could be used to actualy shrink loop
>> devices/sparse file containing btrfs - by copying filesystem to new
>> loop device/sparse file.
>>
>> Also it would be nice if copying filesystem could occour without
>> intermediate dump to a file...
> [...]
>
> I second that.
>
> See also
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/9675/focus=9820
> for a way to transfer btrfs fs.
>
> (Add a layer of "copy-on-write" on the original devices (LVM
> snapshots, nbd/qemu-nbd cow...), "btrfs add" the new device(s)
> and then "btrfs del" of the cow'ed original devices.
>
> --
> Stephane
>

Copying on block level (dd, lvm) is old trick, however this takes same
ammount of time regardless of actual space used in filesystem. Hence
this feature request. Images inside filesystem can copy only actualy
used data and metadata, which dramaticly reduces copy times in large
volumes that are not filled up...
