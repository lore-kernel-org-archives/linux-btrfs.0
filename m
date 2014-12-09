Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:43608 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbaLIQFK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Dec 2014 11:05:10 -0500
Received: by mail-qg0-f53.google.com with SMTP id l89so614246qgf.26
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Dec 2014 08:05:09 -0800 (PST)
Message-ID: <54871D7A.7080305@ubuntu.com>
Date: Tue, 09 Dec 2014 11:04:10 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Konstantin <newsbox1026@web.de>, MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their snapshots
References: <CAE8gLhm8Oma6kWdeJtdc1-U2e4+TJDzhmw2Vfr=CYwvJ78GRJQ@mail.gmail.com> <547CE175.6060409@web.de> <547E10BA.6000707@ubuntu.com> <5484F198.3070206@web.de> <5485BCED.1060705@ubuntu.com> <54862547.4040102@web.de>
In-Reply-To: <54862547.4040102@web.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/8/2014 5:25 PM, Konstantin wrote:
> 
> Phillip Susi schrieb am 08.12.2014 um 15:59:
>> The bios does not know or care about partitions.  All you need is
>> a
> That's only true for older BIOSs. With current EFI boards they not
> only care but some also mess around with GPT partition tables.

EFI is a whole other beast that we aren't talking about.

>> partition table in the MBR and you can install grub there and
>> have it boot the system from a mdadm 1.1 or 1.2 format array
>> housed in a partition on the rest of the disk.  The only time you
>> really *have* to
> I was thinking of this solution as well but as I'm not aware of
> any partitioning tool caring about mdadm metadata so I rejected it.
> It requires a non-standard layout leaving reserved empty spaces for
> mdadm metadata. It's possible but it isn't documented so far I know
> and before losing hours of trying I chose the obvious one.

What on earth are you talking about?  Partitioning tool that cares
about mdadm?  non-standard layout?  I am talking about the bog
standard layout where you create a partition, then use that partition
to build an mdadm array.  mdadm takes care of its own metadata.  There
isn't anything unusual, non obvious, or undocumented here.

>> use 0.9 or 1.0 ( and you really should be using 1.0 instead since
>> it handles larger arrays and can't be confused vis. whole disk
>> vs. partition components ) is if you are running a raid1 on the
>> raw disk, with no partition table and then partition inside the
>> array instead, and really, you just shouldn't be doing that.
> That's exactly what I want to do - running RAID1 on the whole disk
> as most hardware based RAID systems do. Before that I was running
> RAID on disk partitions for some years but this was quite a pain in
> comparison. Hot(un)plugging a drive brings you a lot of issues with
> failing mdadm commands as they don't like concurrent execution when
> the same physical device is affected. And rebuild of RAID
> partitions is done sequentially with no deterministic order. We
> could talk for hours about that but if interested maybe better in
> private as it is not BTRFS related.

So don't create more than one raid partition on the disk.

>> dmraid solves the problem by removing the partitions from the 
>> underlying physical device ( /dev/sda ), and only exposing them
>> on the array ( /dev/mapper/whatever ).  LVM only has the problem
>> when you take a snapshot.  User space tools face the same issue
>> and they resolve it by ignoring or deprioritizing the snapshot.
> I don't agree. dmraid and mdraid both remove the partitions. This
> is not a solution BTRFS will still crash the PC using
> /dev/mapper/whatever or whatever device appears in the system
> providing the BTRFS volume.

You just said btrfs will crash by accessing the *correct* volume after
the *incorrect* one has been removed.  You aren't making any sense.
The problem only arises when the same partition is visible on *both*
the raw disk, and the md device.

> Speaking of BTRFS tools, I am still somehow confused that the
> problem confusing or mixing devices happens at all. I don't know
> the metadata of a BTRFS RAID setup but I assume there must be
> something like a drive index in there, as the order of RAID5 drives
> does matter. So having a second device with identical metadata
> should be considered invalid for auto-adding anyway.

Again, the problem is when you first boot up and/or mount the volume.
 Which of the duplicate devices shows up first is indeterminate so
just saying ignore the second one doesn't help.  Even saying "well
error out if there are two" doesn't help since that leaves open a race
condition where the second volume has not appeared yet at the time you
do the check.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUhx16AAoJENRVrw2cjl5R+IYH/R+ftOiy444+W/K+C0cFKBdi
RlMa2Op9Q0322Rae1IiJvkX/TPUQEnr7sFXcOIhYL9/HKB8zGMr+CQq+9rq8lGdB
QurLcI0MpWbwZZCJCTzrJxRBqqPOXKJ1aU9vWLuuGhS9tCdkfxfy9qcXPnmC2Qta
PfN1Qlr4Invb3Kb/NuB2w7S4nhzYLgBa1KgBDm3EWdCzG03WHMAxwSiBgMvf3nzc
DJ/JMF5TP70760yrlWCvFIa1fgWbGVp7fT9yArDab8N53FYAuE8WIunn+g1hHyue
MTF5ZPhEjVKUVHY1Tl1dqdv0i35TXCbXiVwCwk02veV2+lf95zeNcynmB9kUiSc=
=gvB2
-----END PGP SIGNATURE-----
