Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f43.google.com ([209.85.213.43]:62064 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbbBPCms (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Feb 2015 21:42:48 -0500
Received: by mail-yh0-f43.google.com with SMTP id c41so12847577yho.2
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Feb 2015 18:42:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8597057901878301967@unknownmsgid>
References: <CAEr6y+XdwTMvg67CJmu8LgUgxCayoHLrBYm9En0vfB=BMqL_vg@mail.gmail.com>
	<CAJCQCtQgrzM_FT62+=NsprL1cTq1yYQMy4us4z73WGtOd82bsg@mail.gmail.com>
	<8597057901878301967@unknownmsgid>
Date: Sun, 15 Feb 2015 19:42:47 -0700
Message-ID: <CAJCQCtRAGnuyyzaO-4CNfr_fzAyR=-X3-2BpiovXpOisPnZKag@mail.gmail.com>
Subject: Re: init-scum-tree Assertion `ret` failed
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 15, 2015 at 7:07 PM, Tim DeNike <tim@denike.us> wrote:
> LSI hardware raid6.

Is metadata profile DUP or single?

 I could mount the volume and read/write to it but
> larger files (10+GB) would often Immediately have u correctable CRC
> errors if I did a scrub right after they were created.

Is this a new(ish) btrfs file system? Any crashes? I don't recall off
hand cases of individual file csums going badly this quickly with
otherwise functioning filesystem.

>I don't think
> it's a problem with hardware as I've went through every Disk in the
> array, sas cables, controller card (could be ram/cpu/motherboard I
> guess).

Run memtest86+ as long as possible. Days if you can. At least
overnight tonight into tomorrow, and if it has to wait until the next
weekend, start Friday let it go until Monday. It's the only way to be
sure.


> I figured something must be wrong with the crc tree and maybe
> recreating all crcs would resolve the issue.  After I initially ran
> init-csum I could still mount but all crcs were invalid (it wiped but
> never recreated them).

Generic corruption via memory, cable, drive, RAID, has no idea if it's
corrupting specifically the csum tree. It'd corrupt all sorts of
things. You'd have corrupt metadata, and the scrub and normal usage
should indicate occasionally that one copy is corrupt and that it had
to use the good copy and fix the bad one. Such an entry looks like
this:
[48466.824770] BTRFS: checksum error at logical 20971520 on dev
/dev/sdb, sector 57344: metadata leaf (level 0) in tree 3
[48466.829900] BTRFS: checksum error at logical 20971520 on dev
/dev/sdb, sector 57344: metadata leaf (level 0) in tree 3
[48466.834944] BTRFS: bdev /dev/sdb errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
[48466.853589] BTRFS: fixed up error at logical 20971520 on dev /dev/sdb

If you don't have anything like this, then something else is going on
that's rather specific.

Hopefully someone else has a more efficient idea at tracking this
down, but I'd suggest just creating a new btrfs filesystem on this
raid6 and seeing if the problem reproduces. If it does
quickly/easily.... well then I'd say you need a 2nd device. The more
separate it is the better: SSD, HDD, iSCSI, DRDB, and create new raid1
btrfs. So raid6 as one device, and something else as the other. Now
reproduce the corruption, and the scrubs/csum errors will tell you
which device has the problem. If both devices are fairly equally
corrupt, it has a different cause than if just the raid6 is corrupt.


-- 
Chris Murphy
