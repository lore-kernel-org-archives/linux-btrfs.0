Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f53.google.com ([209.85.213.53]:60462 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbaLHFRl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Dec 2014 00:17:41 -0500
Received: by mail-yh0-f53.google.com with SMTP id i57so1982404yha.26
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Dec 2014 21:17:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141207183444.GA1442@carfax.org.uk>
References: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com>
	<44320137.fRRuR6EFMP@merkaba>
	<88937b9f24bc72160d80977c9edefba2.squirrel@webmail.wanet.net>
	<20141207183444.GA1442@carfax.org.uk>
Date: Sun, 7 Dec 2014 22:17:41 -0700
Message-ID: <CAJCQCtQ7hP-CqAVkjs-Bg+4Mb-tSzHkp9bKhC0pmV+3Rv-K2uA@mail.gmail.com>
Subject: Re: Why is the actual disk usage of btrfs considered unknowable?
From: Chris Murphy <lists@colorremedies.com>
To: Hugo Mills <hugo@carfax.org.uk>, ashford@whisperpc.com,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 7, 2014 at 11:34 AM, Hugo Mills <hugo@carfax.org.uk> wrote:

>    *Any* value shown here is going to be inaccurate, and whatever way
> round we show it, someone will complain.

Yeah I'd suggest that for regular df command, when multiple device
volumes exist, they're shown with ?? for Avail and Use% columns. Maybe
one day df can show more columns: AvailS/R0, AvailR1, AvailR5,
AvailR6.

Today:

# btrfs fi show
Label: 'test'  uuid: fb7df1f2-480d-4426-84f1-8aed197700e4
Total devices 2 FS bytes used 1.38GiB
devid    1 size 5.00GiB used 2.28GiB path /dev/loop0
devid    2 size 5.00GiB used 2.28GiB path /dev/loop1

# df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/loop0      5.0G  1.4G  4.0G  27% /mnt


# btrfs fi df /mnt
Data, RAID1: total=2.00GiB, used=1.38GiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=256.00MiB, used=1.61MiB
GlobalReserve, single: total=16.00MiB, used=0.00B

Perhaps something like this instead:

# btrfs fi df /mnt
Available Space Range: 5.4GiB - 7.2 GiB
RAID0
Available: ~5.1GiB
Data: allocated=1.0GiB, used=0.1GiB
System: allocated=32MiB, used=16KiB
Metadata:allocated=256MiB, used=KiB
RAID1
Available: ~2.7GiB
Data: allocated=2.00GiB, used=1.38GiB
System: allocated=32.00MiB, used=16.00KiB
Metadata: allocated=256.00MiB, used=1.61MiB
SINGLE
Available:
GlobalReserve: allocated=16.00MiB, used=0.00B

1. There's 10.0GiB of total space for two devices in the volume.
2. There's 1.3GiB raid0 chunks allocated, and 4.6GiB raid1 chunks
allocated, 5.6 GiB is allocated.
3. To show available space for any particular profile, we have to
subtract out all the allocated chunks, and then add back in the free
space only for that profile's chunks.
4. The resulting value needs to be multiplied by that profile's
"replication factor" e.g. 1 for single and raid0, 0.5 for raid1, and
for raid 5/6 it depends not just on the number of devices, but the mix
of chunks striped across n disks since Btrfs allows chunks to be
striped across any number of disks so long as it meets the minimum,
i.e. there can be a dozen raid5 chunks striped across 3 drives, and
another 1/2 dozen chunks striped across 4 drives. Only a balance would
redistribute such that each chunk has the same number of strips.

For above it's
raid0 available:
[10.00 total - 5.9 allocated + the free space in only raid0 chunks] * 1

raid1 available:
[10.00 total - 5.9 allocated + the free space in only raid1 chunks] * 0.5

-- 
Chris Murphy
