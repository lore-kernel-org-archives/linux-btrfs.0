Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43479 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2FRM5O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jun 2012 08:57:14 -0400
Received: by lbbgm6 with SMTP id gm6so4270364lbb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2012 05:57:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <E33B72079F3EBA4C91E325F2AE20429508F456@abn-exch1b.green.sophos>
References: <E33B72079F3EBA4C91E325F2AE20429508E837@abn-exch1b.green.sophos>
	<E33B72079F3EBA4C91E325F2AE20429508F456@abn-exch1b.green.sophos>
Date: Mon, 18 Jun 2012 07:57:13 -0500
Message-ID: <CAGJTRcgDjxoKUzMMj5Bfshi=V0vRkEQwr_n7eteGa=Et6cKZGg@mail.gmail.com>
Subject: Re: Is Btrfs stable in a big storage server?
From: Michael <mike@draftx.net>
To: David Pottage <David.Pottage@sophos.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

First: You are absolutely correct, BTRFS is still marked as unstable
and shouldn't be used on data that you will have problems if you lose.
In general, BTRFS is stable on stable workloads(IE no weird hardware
failure, power failure, and the like), but there have been instances
of corruption/data loss/failure.
RAID 5/6 was supposed to be committed to the next kernel, but it
didn't make it in. Here is a quote from the last Kernel commit from
Chris:
>RAID5/6 did miss the cut this time because I'm having trouble with
corruptions.  I'll nail it down next week and post as a beta testing
before 3.6
BTRFS SHOULD be stable under this load, but if you don't want to
transfer the data, it would be best to go with a more proven FS. Last
week we had a user who didn't have backups and had a small RAID
controller hickup, and he lost all of his data - so it does happen.
I joined this mailing list a while back because I plan on doing
something much like you, RAID 5(with hotspares) on my home built NAS
starting at about 5 3tb SATA drives with room for expansion to around
24. I will hopefully be doing this around Christmas(truly the only
thing I'm waiting on is RAID 5/6 and more stability). So I have a hard
time telling you to not do this but I will also have backups and such.
Hopefully I gave you some things to think about!

On Mon, Jun 18, 2012 at 4:29 AM, David Pottage <David.Pottage@sophos.com> wrote:
>
> I am looking for the opinions on how stable btrfs is when used with a big server with lots of discs, but no fancy file system usage.
>
> I have read the warnings about btrfs being experimental, and that I should have tested backups elsewhere.
>
> I am working on a project to set-up a backup server that will store approximately 100 Tb of files. The average file size is around 10 Mb, but there is a lot of variability. The files are compressible on average by 50%. The anticipated workload will see files written with transparent zlib compression, occasionally read, and never modified or deleted. I don't plan to create snapshots.
>
> I have purchased a big storage server (1) with 24 3Tb hard drives. I was considering creating a single btrfs volume spanning all the drives, with no raid, lvm or suchlike below btrfs. The server will run Ubuntu Precise, with the latest stable kernel (from kernel.org). (I don't plan to use btrfs for any system volumes)
>
> Do you think btrfs will be stable under this workload? The data will be backed up elsewhere, but considering the massive amount of data, it will take over a month to populate the server over Gigabit Ethernet, and I don't want to do it a second time if btrfs corrupts the data.
>
> Also, I would like to use Raid-5 on the file data, but I understand that those patches are not yet integrated. Is there an estimate of when they will be in? (realize that it would be just an estimate, but it would be nice to have an idea).
>
> Thank you.
>
> (1) http://www.supermicro.nl/products/system/4U/6047/SSG-6047R-E1R36N.cfm
>
> --
> David Pottage
> Sophos Labs, Abingdon
>
>
> ________________________________
>
> Sophos Limited, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
> Company Reg No 2096520. VAT Reg No GB 991 2418 08.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
