From: Alan Chandler <alan@chandlerfamily.org.uk>
Subject: Re: Filesystem creation in "degraded mode"
Date: Wed, 12 Jan 2011 20:38:58 +0000
Message-ID: <4D2E1162.1020005@chandlerfamily.org.uk>
References: <20110112140248.GA25816@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110112140248.GA25816@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On 12/01/11 14:02, Hugo Mills wrote:
>     I've had a go at determining exactly what happens when you create a
> filesystem without enough devices to meet the requested replication
> strategy:

Thanks - being new to this I haven't set up the infrastructure to try 
these tests - but am interested because (as I said before) its important 
for it to work if I want to migrate my mdmadm/lvm raid setup to btrfs.


>
> # mkfs.btrfs -m raid1 -d raid1 /dev/vdb
> # mount /dev/vdb /mnt
> # btrfs fi df /mnt
> Data: total=8.00MB, used=0.00
> System, DUP: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=153.56MB, used=24.00KB
> Metadata: total=8.00MB, used=0.00
>
>     The data section is single-copy-only; system and metadata are DUP.
> This is good. Let's add some data:
>
> # cp develop/linux-image-2.6.3* /mnt
> # btrfs fi df /mnt
> Data: total=315.19MB, used=250.58MB
> System, DUP: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=153.56MB, used=364.00KB
> Metadata: total=8.00MB, used=0.00
>
>     Again, much as expected. Now, add in a second device, and balance:
>
> # btrfs dev add /dev/vdc /mnt
> # btrfs fi bal /mnt
> # btrfs fi df /mnt
> Data, RAID0: total=1.20GB, used=250.58MB
> System, RAID1: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, RAID1: total=128.00MB, used=308.00KB
>
>     This is bad, though. Data has reverted to RAID-0.

Is it a bug? or intentional design?

>
>     Now, just to check, what happens when we create a filesystem with
> enough devices, fail one, and re-add it?
>
> # mkfs.btrfs -d raid1 -m raid1 /dev/vdb /dev/vdc
> # mount /dev/vdb /mnt
> # # Copy some data into it
> # btrfs fi df /mnt
> Data, RAID1: total=1.50GB, used=1.24GB
> Data: total=8.00MB, used=0.00
> System, RAID1: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, RAID1: total=307.19MB, used=1.80MB
> Metadata: total=8.00MB, used=0.00
> # umount /mnt
>
>     OK, so what happens if we fail one drive?
>
> # dd if=/dev/zero of=/dev/vdb bs=1M count=16
> # mount /dev/vdc /mnt -o degraded
> # btrfs dev add /dev/vdd /mnt
> # btrfs fi show
> failed to read /dev/sr0

Where does this /dev/sr0 come from?  I don't see it referenced elsewhere

> Label: none  uuid: 2495fe15-174f-4aaa-8317-c2cfb4dade1f
>         Total devices 3 FS bytes used 1.25GB
>         devid    2 size 3.00GB used 1.81GB path /dev/vdc
>         devid    3 size 3.00GB used 0.00 path /dev/vdd
>         *** Some devices missing
>
> Btrfs Btrfs v0.19
> # btrfs fi bal /mnt
> # btrfs fi df /mnt
> Data, RAID1: total=1.50GB, used=1.24GB
> System, RAID1: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, RAID1: total=128.00MB, used=1.41MB
>
>     This looks all well and good. So it looks like it's just the
> "create-in-degraded-mode" idea that doesn't work.

You don't appear to have copied any data on to it whilst in degraded 
mode, to see if it behaves like the initial case and reverts to RAID0 
when you copy data. You only copied data whilst both devices where 
operational.




