From: "Marco L. Crociani" <marco.crociani@gmail.com>
Subject: Re: Errors in rebalancing RAID1 array after disk failure.
Date: Wed, 2 May 2012 19:10:15 +0200
Message-ID: <CADy=jfUkRCiohXyVzT2V9Nb3mdwc_SONuiHD35dvkKWtq_SQjw@mail.gmail.com>
References: <CADy=jfVRz5UuKcFkDXC9hwZnP8Z=E9NuF9p3hE6b0ZC06k7DWg@mail.gmail.com>
 <CADy=jfWC1vJs_TWt-EmvAN2Ybqw8kjN2tFV_vgAb-OKeGMpotg@mail.gmail.com>
 <CADy=jfV9pKJurcormuMK7KW54-DKSvYns-Ow-T_FEELGmFQ18Q@mail.gmail.com>
 <20120416134643.GA20982@twin.jikos.cz> <CADy=jfVh8ZvyyJTdBBFTVRSnBHka8sNrVUQcEx_ciROdB=pYhQ@mail.gmail.com>
 <CADy=jfW6rrSwPV6WvKVhcRYd67GMvB57ynSZOjPuDUnnssgZYg@mail.gmail.com>
 <CADy=jfV93jMa7DpN_tmQLQ9gOCjqOLgyDxv8=5tCMxr-b-m1QA@mail.gmail.com>
 <20120502145408.GE6740@twin.jikos.cz> <CADy=jfUGKH+fTfhFM-TDWxiFc_eM_4qwaeTESf2NV6rKUG8pww@mail.gmail.com>
 <20120502152715.GG6740@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: dave@jikos.cz, "Marco L. Crociani" <marco.crociani@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120502152715.GG6740@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

> Is there anything I missed for steps to reproduce it?

All the story is in previous mails.
http://thread.gmane.org/gmane.comp.file-systems.btrfs/16829
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg15949.html
=46irst mail is missing from mail-archive...

Summary:
Some damaged sectors on one device. Seems to be ok after rewriteing so
I started a scrub.
During scrub (kernel 3.2.x) device completely broke down with A LOT of
dameged sectors ---> other device fills up --> out of space --->
unclean shotdown.
With 3.3 kernels I was able to mount it and add a new device.
I tried 3.4-rc4 but the patch wasn't there.
I had problem compiling from git, before I tried DKMS, then the whole
kernel, (set CONCURRENCY =3D 5 with quadcore is wrong? ) so I waited
rc5.
With the tar from kernel.org I have successfully compiled 3.4-rc5
(with CONCURRENCY =3D 4).
Errors with scrub.
Here we are.


On Wed, May 2, 2012 at 5:27 PM, David Sterba <dave@jikos.cz> wrote:
> On Wed, May 02, 2012 at 04:59:03PM +0200, Marco L. Crociani wrote:
>> > On Thu, Apr 19, 2012 at 05:42:05PM +0200, Marco L. Crociani wrote:
>> > > Apr 19 17:38:41 evo kernel: [ =C2=A0347.661964] =C2=A0[<ffffffff=
a00b76ac>] >
>> > > btrfs_ioctl_dev_info+0x15c/0x1a0 [btrfs]
> [...]
>> I was on 3.4-rc5!
>
> You really saw this crash with 3.4-rc5 ?

Yes.
I tell you now what I did before your response today.

=46rom this point:

btrfs fi sh
Label: 'RootFS'  uuid: c87975a0-a575-405e-9890-d3f7f25bbd96
    Total devices 3 FS bytes used 1015.83GB
    devid    3 size 1.75TB used 357.00GB path /dev/sdb3
    devid    1 size 1.75TB used 1.34TB path /dev/sda3
    *** Some devices missing

I reached:

btrfs fi show
Label: 'RootFS'  uuid: c87975a0-a575-405e-9890-d3f7f25bbd96
	Total devices 3 FS bytes used 1004.23GB
	devid    3 size 1.75TB used 1.25TB path /dev/sdb3
	devid    1 size 1.75TB used 1.33TB path /dev/sda3
	*** Some devices missing

using "btrfs balance start -dvrange=3D1..[group where it fails minus 1]
" a number of times (I started writing some notes on
http://btrfs.ipv5.de/index.php?title=3DUser:Tyrael ).

These should be all the errors (sorry for the confusion):

---------------------------------------------------

Apr 30 19:53:13 evo kernel: [ 3163.927548] btrfs csum failed ino 510
off 910946304 csum 432355644 private 175165154



May  1 23:15:12 evo kernel: [101661.681997] btrfs: relocating block
group 1742452293632 flags 17
May  1 23:15:39 evo kernel: [101688.412777] btrfs: found 328 extents
May  1 23:15:47 evo kernel: [101696.543742] btrfs: found 328 extents
May  1 23:15:48 evo kernel: [101697.575754] btrfs: relocating block
group 1741378551808 flags 17
May  1 23:16:16 evo kernel: [101724.754908] btrfs: found 137 extents
May  1 23:16:24 evo kernel: [101732.915791] btrfs: found 137 extents
May  1 23:16:24 evo kernel: [101733.275939] btrfs: relocating block
group 1401002393600 flags 17
May  1 23:16:45 evo kernel: [101753.889479] btrfs csum failed ino 2876
off 910946304 csum 432355644 private 175165154

Apr 30 20:55:09 evo kernel: [ 6879.601004] btrfs: relocating block
group 1738157326336 flags 17
Apr 30 20:55:10 evo kernel: [ 6879.995377] btrfs: relocating block
group 1401002393600 flags 17
Apr 30 20:55:29 evo kernel: [ 6898.819546] btrfs csum failed ino 636
off 910946304 csum 432355644 private 175165154
Apr 30 20:55:29 evo kernel: [ 6898.849422] btrfs csum failed ino 636
off 910946304 csum 432355644 private 175165154
Apr 30 20:55:29 evo kernel: [ 6898.849689] btrfs csum failed ino 636
off 910946304 csum 432355644 private 175165154
Apr 30 20:55:29 evo kernel: [ 6898.878413] btrfs csum failed ino 636
off 910946304 csum 432355644 private 175165154
Apr 30 20:55:29 evo kernel: [ 6898.878668] btrfs csum failed ino 636
off 910946304 csum 432355644 private 175165154

May  1 15:26:26 evo kernel: [73542.827058] btrfs: relocating block
group 1394559942656 flags 17
May  1 15:26:38 evo kernel: [73555.038433] btrfs csum failed ino 1581
off 648593408 csum 283516648 private 3975454589

Apr 30 20:58:26 evo kernel: [ 7076.525087] btrfs: relocating block
group 1394559942656 flags 17
Apr 30 20:58:38 evo kernel: [ 7088.082493] btrfs csum failed ino 642
off 648593408 csum 283516648 private 3975454589
Apr 30 20:58:38 evo kernel: [ 7088.108851] btrfs csum failed ino 642
off 648593408 csum 283516648 private 3975454589

May  1 15:28:41 evo kernel: [73677.797363] btrfs: relocating block
group 1385970008064 flags 17
May  1 15:28:45 evo kernel: [73681.242643] btrfs csum failed ino 1582
off 229765120 csum 3096851068 private 993448323

Apr 30 21:30:46 evo kernel: [ 9016.216885] btrfs: found 223 extents
Apr 30 21:30:46 evo kernel: [ 9016.533470] btrfs: relocating block
group 1385970008064 flags 17
Apr 30 21:30:49 evo kernel: [ 9019.630665] btrfs csum failed ino 650
off 229765120 csum 3096851068 private 993448323

Apr 30 21:56:29 evo kernel: [10558.769597] btrfs: relocating block
group 1378453815296 flags 17
Apr 30 21:56:31 evo kernel: [10561.185029] btrfs csum failed ino 657
off 190976000 csum 3234929648 private 3669891009

May  1 14:07:30 evo kernel: [68808.355851] btrfs: relocating block
group 1283964534784 flags 17
May  1 14:07:32 evo kernel: [68809.636406] btrfs csum failed ino 1580
off 76992512 csum 2845512790 private 1793157788

May  1 14:07:30 evo kernel: [68808.355851] btrfs: relocating block
group 1283964534784 flags 17
May  1 14:07:32 evo kernel: [68809.636406] btrfs csum failed ino 1580
off 76992512 csum 2845512790 private 1793157788

Apr 30 21:58:01 evo kernel: [10650.588154] btrfs: relocating block
group 1283964534784 flags 17
Apr 30 21:58:02 evo kernel: [10651.659749] btrfs csum failed ino 660
off 76992512 csum 2845512790 private 1793157788

May  1 01:41:51 evo kernel: [24077.073607] btrfs: relocating block
group 755951992832 flags 17
May  1 01:42:01 evo kernel: [24087.429383] btrfs csum failed ino 1078
off 685268992 csum 397158032 private 511106431


----------------------------------------------

It's "normal" that ino changes from one balance run to the next?

before:
Apr 30 21:58:01 evo kernel: [10650.588154] btrfs: relocating block
group 1283964534784 flags 17
Apr 30 21:58:02 evo kernel: [10651.659749] btrfs csum failed ino 660
off 76992512 csum 2845512790 private 1793157788
after:
May  1 14:07:30 evo kernel: [68808.355851] btrfs: relocating block
group 1283964534784 flags 17
May  1 14:07:32 evo kernel: [68809.636406] btrfs csum failed ino 1580
off 76992512 csum 2845512790 private 1793157788


Sincerely, thanks for the help. It is much appreciated. I do not know
where to turn.

--=20
Marco Lorenzo Crociani,
marco.crociani@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
