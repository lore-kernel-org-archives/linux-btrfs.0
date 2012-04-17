From: "Marco L. Crociani" <marco.crociani@gmail.com>
Subject: Re: Errors in rebalancing RAID1 array after disk failure.
Date: Tue, 17 Apr 2012 02:25:52 +0200
Message-ID: <CADy=jfW6rrSwPV6WvKVhcRYd67GMvB57ynSZOjPuDUnnssgZYg@mail.gmail.com>
References: <CADy=jfVRz5UuKcFkDXC9hwZnP8Z=E9NuF9p3hE6b0ZC06k7DWg@mail.gmail.com>
 <CADy=jfWC1vJs_TWt-EmvAN2Ybqw8kjN2tFV_vgAb-OKeGMpotg@mail.gmail.com>
 <CADy=jfV9pKJurcormuMK7KW54-DKSvYns-Ow-T_FEELGmFQ18Q@mail.gmail.com>
 <20120416134643.GA20982@twin.jikos.cz> <CADy=jfVh8ZvyyJTdBBFTVRSnBHka8sNrVUQcEx_ciROdB=pYhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: dave@jikos.cz, "Marco L. Crociani" <marco.crociani@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CADy=jfVh8ZvyyJTdBBFTVRSnBHka8sNrVUQcEx_ciROdB=pYhQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 17, 2012 at 12:56 AM, Marco L. Crociani
<marco.crociani@gmail.com> wrote:
> On Mon, Apr 16, 2012 at 3:46 PM, David Sterba <dave@jikos.cz> wrote:
>> On Sat, Apr 14, 2012 at 06:39:12PM +0200, Marco L. Crociani wrote:
>>> Apr 14 18:07:52 evo kernel: [=C2=A0 431.054709] btrfs: relocating b=
lock
>>> group 1401002393600 flags 17
>>> Apr 14 18:08:14 evo kernel: [=C2=A0 453.506541] btrfs csum failed i=
no 362
>>> off 910946304 csum 432355644 private 175165154
>>
>> The failed checksums prevent balance to relocate the blockgroup, whi=
ch
>> is a needed step during 'dev delete'. Unless the csum is fixable by
>> using another copy, I think the only option left is to delete the fi=
le
>> (not counting the unsafe way of resetting the block's cheksum).
>>
>
> I deleted the files.
> (" find /mnt/sda3 -inum 362 -ls " is correct to find them? )
>
> Now it gives me errors on inode 257
> I deleted a file but it still gives me errors on inode 257 but "find
> /mnt/sda3 -inum 257 -ls" gives me nothing now.
>
> Apr 17 00:41:49 evo kernel: [ =C2=A0156.530441] device label RootFS d=
evid 1
> transid 47037 /dev/sda3
> Apr 17 00:41:49 evo kernel: [ =C2=A0156.734993] device label RootFS d=
evid 3
> transid 47037 /dev/sdb3
> Apr 17 00:42:12 evo kernel: [ =C2=A0179.496155] device label RootFS d=
evid 1
> transid 47037 /dev/sda3
> Apr 17 00:42:12 evo kernel: [ =C2=A0179.496881] btrfs: allowing degra=
ded mounts
> Apr 17 00:42:12 evo kernel: [ =C2=A0179.496888] btrfs: disk space cac=
hing is enabled
> Apr 17 00:42:24 evo kernel: [ =C2=A0191.290093] btrfs: relocating blo=
ck
> group 1401002393600 flags 17
> Apr 17 00:42:53 evo kernel: [ =C2=A0220.417535] btrfs csum failed ino=
 257
> off 910946304 csum 432355644 private 175165154
> Apr 17 00:42:53 evo kernel: [ =C2=A0220.480570] btrfs csum failed ino=
 257
> off 910946304 csum 432355644 private 175165154
> Apr 17 00:42:53 evo kernel: [ =C2=A0220.480868] btrfs csum failed ino=
 257
> off 910946304 csum 432355644 private 175165154
> Apr 17 00:42:53 evo kernel: [ =C2=A0220.505168] btrfs csum failed ino=
 257
> off 910946304 csum 432355644 private 175165154
> Apr 17 00:42:53 evo kernel: [ =C2=A0220.528368] btrfs csum failed ino=
 257
> off 910946304 csum 432355644 private 175165154
>
>
> --
> Marco Lorenzo Crociani,

Running another time btrfs dev delete missing return a different error
(something like invalid argument), and no log activity.
Then umount completely freeze the system. Keyboard's leds start blinkin=
g.
Also alt gr + print screen + REISUB doesn't work.

--=20
Marco Lorenzo Crociani,
marco.crociani@gmail.com
Telefono: +39 02320622509
=46ax: +39 02700540121
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
