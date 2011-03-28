From: Stephane Chazelas <stephane.chazelas@gmail.com>
Subject: Re: cloning single-device btrfs file system onto multi-device one
Date: Mon, 28 Mar 2011 14:17:48 +0100
Message-ID: <chaz20110328131748.GA18131@seebyte.com>
References: <chaz20110321162450.GB918@seebyte.com> <chaz20110322092259.GA4861@seebyte.com> <AANLkTin1++vPq904tkPOAf3ZxwWTZaQYL+=WJHetEr9h@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTin1++vPq904tkPOAf3ZxwWTZaQYL+=WJHetEr9h@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011-03-22 18:06:29 -0600, cwillu:
> > I can mount it back, but not if I reload the btrfs module, in which case I get:
> >
> > [ 1961.328280] Btrfs loaded
> > [ 1961.328695] device fsid df4e5454eb7b1c23-7a68fc421060b18b devid 1 transid 118 /dev/loop0
> > [ 1961.329007] btrfs: failed to read the system array on loop0
> > [ 1961.340084] btrfs: open_ctree failed
> 
> Did you rescan all the loop devices (btrfs dev scan /dev/loop*) after
> reloading the module, before trying to mount again?

Thanks. That probably was the issue, that and using too big
files on too small volumes I'd guess.

I've tried it in real life and it seemed to work to some extent.
So here is how I transferred a 6TB btrfs on one 6TB raid5 device
(on host src) over the network onto a btrfs on 3 3TB hard drives
(on host dst):

on src:

lvm snapshot -L100G -n snap /dev/VG/vol
nbd-server 12345 /dev/VG/snap

(if you're not lucky enough to have used lvm there, you can use
nbd-server's copy-on-write feature).

on dst:

nbd-client src 12345 /dev/nbd0
mount /dev/nbd0 /mnt
btrfs device add /dev/sdb /dev/sdc /dev/sdd /mnt
  # in reality it was /dev/sda4 (a little under 3TB), /dev/sdb,
  # /dev/sdc
btrfs device delete /dev/nbd0 /mnt

That was relatively fast (about 18 hours) but failed with an
error. Apparently, it managed to fill up the 3 3TB drives (as
shown by btrfs fi show). Usage for /dev/nbd0 was at 16MB though
(?!)

I then did a "btrfs fi balance /mnt". I could see usage on the
drives go down quickly. However, that was writing data onto
/dev/nbd0 so was threatening to fill up my LVM snapshot. I then
cancelled that by doing a hard reset on "dst" (couldn't find
any other way). And then:

Upon reboot, I mounted /dev/sdb instead of /dev/nbd0 in case
that made a difference and then ran the 

btrfs device delete /dev/nbd0 /mnt

again, which this time went through.

I then did a btrfs fi balance again and let it run through. However here is
what I get:

$ df -h /mnt
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdb              8.2T  3.5T  3.2T  53% /mnt

Only 3.2T left. How would I reclaim the missing space?

$ sudo btrfs fi show
Label: none  uuid: ...
        Total devices 3 FS bytes used 3.43TB
        devid    4 size 2.73TB used 1.17TB path /dev/sdc
        devid    3 size 2.73TB used 1.17TB path /dev/sdb
        devid    2 size 2.70TB used 1.14TB path /dev/sda4
$ sudo btrfs fi df /mnt
Data, RAID0: total=3.41TB, used=3.41TB
System, RAID1: total=16.00MB, used=232.00KB
Metadata, RAID1: total=35.25GB, used=20.55GB

So that kind of worked but that is of little use to me as 2TB
kind of disappeared under my feet in the process.

Any idea, anyone?

Thanks
Stephane
