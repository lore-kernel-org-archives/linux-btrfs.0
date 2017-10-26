Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.197]:61877 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751921AbdJZCes (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Oct 2017 22:34:48 -0400
Date: Wed, 25 Oct 2017 22:34:46 -0400 (EDT)
From: Zak Kohler <y2k@y2kbugger.com>
Reply-To: Zak Kohler <y2k@y2kbugger.com>
To: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <1484297967.48018.1508985286675@email.1and1.com>
In-Reply-To: <CAKuJGC8omM8TMg7DqncuoM6e0jdUOdiwNLU6q29z__U=2NQHvg@mail.gmail.com>
References: <CAD8FQQ0tO3AZDDh89hczwZ1pL70uom5EBY2fbZWm_LDJAQE2UQ@mail.gmail.com>
 <CAD8FQQ3kBfy8kLFzSm-OVbsYsQ7-LzH0faD09__4S5_q0bM7pA@mail.gmail.com>
 <CAKuJGC-aRt_NKboYa9ZK6ApWDJ_knM-UazPxEUq7sHiNXEqA6w@mail.gmail.com>
 <CAD8FQQ20m3sgLKc_utf2xb-J6bhf1W58mAkEFc2jyJy7-bH3+w@mail.gmail.com>
 <CAD8FQQ3boTj97yu-F8CiFBvR-EfD+1chcSo=VzyAxwO7GpomEg@mail.gmail.com>
 <CAKuJGC8omM8TMg7DqncuoM6e0jdUOdiwNLU6q29z__U=2NQHvg@mail.gmail.com>
Subject: Re: btrfs send yields "ERROR: send ioctl failed with -5:
 Input/output error"
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I don't need to recover in this case. I can just remake the filesystem. I'm
just very concerned that this corruption was able to happen. Here is the entire
history of the filesystem:

2017.10.18 create btrfs from 3 drives aka OfflineJ and rsync
data from old madam raid5
---------------------------------------
# badblocks run on all three drives
$ badblocks -wsv /dev/disk/by-id/WD-XXX
Pass completed, 0 bad blocks found. (0/0/0 errors)

$ mkfs.btrfs -L OfflineJ /dev/disk/by-id/WD-XX1 /dev/disk/by-id/WD-XX2 /dev/disk/by-id/WD-XX3

$ mount -t btrfs UUID=88406942-e3e1-42c6-ad71-e23bb315caa7 /mnt/

$ btrfs subvolume create /mnt/dataroot

$ mkdir /media/OfflineJ

/etc/fstab
----------
UUID=XXX       /media/OfflineJ         btrfs   rw,relatime,subvol=/dataroot,noauto 0 0

$ mount /media/OfflineJ/

$ btrfs filesystem df /media/OfflineJ/
Data, RAID0: total=3.00GiB, used=1.00MiB
System, RAID1: total=8.00MiB, used=16.00KiB
Metadata, RAID1: total=1.00GiB, used=128.00KiB
GlobalReserve, single: total=16.00MiB, used=0.00B

$ btrfs filesystem usage /media/OfflineJ/
Overall:
   Device size:                   5.46TiB
   Device allocated:              5.02GiB
   Device unallocated:            5.45TiB
   Device missing:                5.46TiB
   Used:                          1.28MiB
   Free (estimated):              5.46TiB      (min: 2.73TiB)
   Data ratio:                       1.00
   Metadata ratio:                   2.00
   Global reserve:               16.00MiB      (used: 0.00B)

$ sudo mount -o noatime -o ro /media/oldmdadmraid5/

$ rsync -aAXh --progress --stats /media/oldmdadmraid5/ /media/OfflineJ


I will gladly repeat this process, but I am very concerned why this
corruption happened in the first place.

More tests:

scrub start --offline
    All devices had errors in differing amounts
    I will verify that these counts are repeatable.
    Csum error: 150
    Csum error: 238
    Csum error: 175

btrfs check
    found 2179745955840 bytes used, no error found

btrfs check --check-data-csum
    mirror 0 bytenr 13348855808 csum 2387937020 expected csum 562782116
    mirror 0 bytenr 23398821888 csum 3602081170 expected csum 1963854755
    ...

The only thing I could think of is that the btrfs version that I used to mkfs
was not up to date. Is there a way to determine which version was used to
create the filesystem?

Anything else I can do to help determine the cause?

> On October 24, 2017 at 11:43 PM "Lakshmipathi.G" <lakshmipathi.g@gmail.com> wrote:
> 
> 1.  I guess you should be able to dump tree details via
> 'btrfs-debug-tree' and then map the extent/data (from scrub
> offline output) and track it back to inode-object. Store output of
> both btrfs-debug-tree and scrub-offline in different files and then
> play around with grep to extract required data.
> 
> 2.  I think normal scrub(online) fails to detect these csum errors for
> some reason,I don't have much idea about online scrub.
> 
> 3.  I assume, the issue is not related to hardware. Since the offline
> scrub able to get available (corrupted) csum.
> 
> Yes, offline scrub will try to fix corruption whenever it is possible.
> And also you have quite lot of "all mirror(s) corrupted, can't be repaired",
> which will be hard to recovery.
> 
> I suggest running offline scrub on all devices. Then online scrub
> 
> and finally track those corrupted files with the help of extent info.
> 
> ----
> Cheers,
> Lakshmipathi.G
> http://www.giis.co.in http://www.webminal.org
> 
> On Wed, Oct 25, 2017 at 7:22 AM, Zak Kohler <y2k@y2kbugger.com> wrote:
> 
> > I apologize for the bad line wrapping on the last post...will be
> > setting up mutt soon.
> > 
> > This is the final result for the offline scrub:
> > Doing offline scrub [O] [681/683]
> > Scrub result:
> > Tree bytes scrubbed: 5234491392
> > Tree extents scrubbed: 638975
> > Data bytes scrubbed: 4353723572224
> > Data extents scrubbed: 374300
> > Data bytes without csum: 533200896
> > Read error: 0
> > Verify error: 0
> > Csum error: 175
> > 
> > The offline scrub apparently corrected some metadata extents while
> > scanning /dev/sdn
> > 
> > I also ran the online scrub directly on the /dev/sdn, "0 errors":
> > 
> > $ btrfs scrub status /dev/sdn
> > scrub status for 88406942-e3e1-42c6-ad71-e23bb315caa7
> >  scrub started at Tue Oct 24 06:55:12 2017 and finished after 01:52:44
> >  total bytes scrubbed: 677.35GiB with 0 errors
> > 
> > The csum mismatches are still missed by the online scrub when choosing
> > a single . Now I am doing offline scrub on the other devices
> > to see if they are clean.
> > 
> > $ lsblk -o +SERIAL
> > NAME MAJ:MIN RM SIZE RO TYPE MOUNTPOINT SERIAL
> > sdh 8:112 0 1.8T 0 disk WD-WMAZA370XXXX
> > sdi 8:128 0 1.8T 0 disk WD-WCAZA569XXXX
> > sdn 8:208 0 1.8T 0 disk WD-WCAZA580XXXX
> > 
> > $ btrfs scrub start --offline --progress /dev/sdh
> > ERROR: data at bytenr 5365456896 ...
> > ERROR: extent 5341712384 ...
> > ...
> > 
> > One thing to note is that a /dev/sdh is also having csum errors
> > detected despite it having never been mentioned dmesg. I understand
> > that you may have the ability to run two offline checks at once but
> > the error message I get is slightly misleading.
> > 
> > $ btrfs scrub start --offline --progress /dev/sdi
> > ERROR: cannot open device '/dev/sdn': Device or resource busy
> > ERROR: cannot open file system
> > 
> > I get an error about sdn when the device I am trying to scan is sdi,
> > and the device that is currently being scanned is sdh.
> > 
> > On Tue, Oct 24, 2017 at 2:00 AM, Zak Kohler <y2k@y2kbugger.com> wrote:
> > 
> > > Yes, it is finding much more than just one error.
> > > 
> > > From dmesg
> > > [89520.441354] BTRFS warning (device sdn): csum failed ino 4708 off
> > > 27529216 csum 2615801759 expected csum 874979996
> > > 
> > > $ sudo btrfs scrub start --offline --progress /dev/sdn
> > > ERROR: data at bytenr 68431499264 mirror 1 csum mismatch, have
> > > 0x5aa0d40f expect 0xd4a15873
> > > ERROR: extent 68431474688 len 14467072 CORRUPTED, all mirror(s)
> > > corrupted, can't be repaired
> > > ERROR: data at bytenr 83646357504 mirror 1 csum mismatch, have
> > > 0xfc0baabe expect 0x7f9cb681
> > > ERROR: extent 83519741952 len 134217728 CORRUPTED, all mirror(s)
> > > corrupted, can't be repaired
> > > ERROR: data at bytenr 121936633856 mirror 1 csum mismatch, have
> > > 0x507016a5 expect 0x50609afe
> > > ERROR: extent 121858334720 len 134217728 CORRUPTED, all mirror(s)
> > > corrupted, can't be repaired
> > > ERROR: data at bytenr 144872591360 mirror 1 csum mismatch, have
> > > 0x33964d73 expect 0xf9937032
> > > ERROR: extent 144822386688 len 61231104 CORRUPTED, all mirror(s)
> > > corrupted, can't be repaired
> > > ERROR: data at bytenr 167961075712 mirror 1 csum mismatch, have
> > > 0xf43bd0e3 expect 0x5be589bb
> > > ERROR: extent 167950999552 len 27537408 CORRUPTED, all mirror(s)
> > > corrupted, can't be repaired
> > > ERROR: data at bytenr 175643619328 mirror 1 csum mismatch, have
> > > 0x1e168ca1 expect 0xd413b1e0
> > > ERROR: data at bytenr 175643754496 mirror 1 csum mismatch, have
> > > 0x6cfdc8ae expect 0xa6f8f5ef
> > > ERROR: extent 175640539136 len 6381568 CORRUPTED, all mirror(s)
> > > corrupted, can't be repaired
> > > ERROR: data at bytenr 183316750336 mirror 1 csum mismatch, have
> > > 0x145bdf76 expect 0x7390565e
> > > .....
> > > and the list goes on.
> > > 
> > > Questions:
> > > 
> > > 1.  Using "find /mnt -inum 4708" I can link the dmesg to a specific
> > > file. Is there a
> > > way link the the --offline ERRORs above to the inode?
> > > 
> > > 2.  How could do "btrfs device stats /mnt" and normal full scrub fail
> > > to detect the csum errors?
> > > 
> > > 3.  Do these errors appear to be hardware failure (despite pristine
> > > SMART), user error on
> > > volume creation/mounting, or an actual btrfs issue? I feel that the
> > > need for question #1
> > > indicates a problem with btrfs regardless of whether there is a real
> > > hardware failure or not.
> > > 
> > > Next I will try an online scrub of only the sdn device, as before I
> > > was running the full filesystem scrub.
> > > 
> > > On Tue, Oct 24, 2017 at 12:52 AM, Lakshmipathi.G
> > > 
> > > <lakshmipathi.g@gmail.com> wrote:
> > > 
> > > > > Does anyone know why scrub did not catch these errors that show up in dmesg?
> > > > 
> > > > Can you try offline scrub from this repo
> > > > https://github.com/gujx2017/btrfs-progs/tree/offline_scrub and see
> > > > whether it
> > > > detects the issue? "btrfs scrub start --offline "
> > > > 
> > > > ----
> > > > Cheers,
> > > > Lakshmipathi.G
> > > > 
> > > > http://www.giis.co.in http://www.webminal.org
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at http://vger.kernel.org/majordomo-info.html
