From: Daniel Kozlowski <dan.kozlowski@gmail.com>
Subject: Re: volume broken? btrfsck fails
Date: Wed, 7 Jul 2010 20:21:19 -0400
Message-ID: <AANLkTilfqxC8ds3F3ee53eJsigGWgksLbcSFVxVd4rRV@mail.gmail.com>
References: <569BCC7F-1920-4AC4-8069-369419029373@gmail.com>
	<loom.20100701T144515-658@post.gmane.org>
	<20100707001930.GI15984@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Daniel Kozlowski <dan.kozlowski@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100707001930.GI15984@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 6, 2010 at 8:19 PM, Chris Mason <chris.mason@oracle.com> wr=
ote:
>> I am also having the same problem with a slightly different setup. I=
n My case I
>> cannot mount the filesystem.
>
> What is your hardware setup here? =A0Including write cache settings. =
=A0Did
> you have craces with 2.6.35-rc1 or rc2?

My setup is

Eight hard Drive
four 1TB Drives
four 500GB Drives
All drives are connected through a 3ware Inc 9550SX SATA-II RAID PCI-X =
card
The card is configured to export all drives essentially acting as a
SATA port multiplier. (drives show up sdb - sdi)
Drives are configured in btrfs raid0
=46ilesystem is mounted using:
mount -t btrfs /dev/sdb /opt

I have been able to lock up the system on
2.6.33.5-124.fc13.x86_64
2.6.35-0.13.rc3.git2.fc14.x86_64
2.6.35-0.23.rc3.git6.fc14.x86_64
and
2.6.35-0.23.rc3.git6.fc14.x86_64 with a DKMS build of the btrfs module
(Btrfs v0.19-16-g075587c-dirty)

If you would like me to pull out another version of the kernel or roll
back specific commits from the kernel module I can

I have been able to get different responses form different version
2.6.33.* - This will mount the volume but will hang shortly after
mounting when reading data form the filesystem ( ls /opt) writes a
bunch of transid verify failed messages hangs on ls
2.6.34.* - Will not mount at all still gives the transid verify failed
 hands on mount

>
> Looks like we're looping on a single block. =A0What happens when you
> dmesg -n1 to cut down on the console traffic?
>
Nothing changes I still have endless repeats of

parent transid verify failed on 1682586464256 wanted 285114 found 11257

> If that doesn't help we can change it to spit a stack trace to figure
> out where the looping is happening. =A0We should be erroring out inst=
ead
> of hitting it over and over again.

In my kernel noviceness i tried attaching gdb to the btrfs-endio-met,
however apparently you can't attach gdb to a kernel thread like that
If you could assist me in obtaining a call trace I will gladly attempt
to resolve the matter.

Dan Kozlowski

--=20
S.D.G.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
