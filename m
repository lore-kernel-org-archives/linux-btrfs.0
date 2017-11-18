Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:51209 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760560AbdKRDdi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 22:33:38 -0500
Date: Sat, 18 Nov 2017 04:33:35 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Chris Murphy <lists@colorremedies.com>
Cc: Nazar Mokrynskyi <nazar@mokrynskyi.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Unrecoverable scrub errors
Message-ID: <20171118033335.2ha45mvia5edu6p6@angband.pl>
References: <0d0062da-6310-7662-a7ec-edc6591b4542@mokrynskyi.com>
 <CAJCQCtSBxDP7ZyCnQuZZLQXXURrKLT+1Ja61pD_uR0oGH0piDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtSBxDP7ZyCnQuZZLQXXURrKLT+1Ja61pD_uR0oGH0piDA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 17, 2017 at 08:19:11PM -0700, Chris Murphy wrote:
> On Fri, Nov 17, 2017 at 8:41 AM, Nazar Mokrynskyi <nazar@mokrynskyi.com> wrote:
> 
> >> [551049.038718] BTRFS warning (device dm-2): checksum error at logical 470069460992 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 942238048: metadata leaf (level 0) in tree 985
> >> [551049.038720] BTRFS warning (device dm-2): checksum error at logical 470069460992 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 942238048: metadata leaf (level 0) in tree 985
> >> [551049.038723] BTRFS error (device dm-2): bdev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
> >> [551049.039634] BTRFS warning (device dm-2): checksum error at logical 470069526528 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 942238176: metadata leaf (level 0) in tree 985
> >> [551049.039635] BTRFS warning (device dm-2): checksum error at logical 470069526528 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 942238176: metadata leaf (level 0) in tree 985
> >> [551049.039637] BTRFS error (device dm-2): bdev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1 errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
> >> [551049.413114] BTRFS error (device dm-2): unable to fixup (regular) error at logical 470069460992 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1
> 
> These are metadata errors. Are there any other storage stack related
> errors in the previous 2-5 minutes, such as read errors (UNC) or SATA
> link reset messages?
> 
> >Maybe I can find snapshot that contains file with wrong checksum and
> > remove corresponding snapshot or something like that?
> 
> It's not a file. It's metadata leaf.

Just for the record: had this be a data block (ie, a non-inline file
extent), the dmesg message would include one of filenames that refer to that
extent.  To clear the error, you'd need to remove all such files.

> >> nazar-pc@nazar-pc ~> sudo btrfs filesystem df /media/Backup
> >> Data, single: total=879.01GiB, used=877.24GiB
> >> System, DUP: total=40.00MiB, used=128.00KiB
> >> Metadata, DUP: total=20.50GiB, used=18.96GiB
> >> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> Metadata is DUP, but both copies have corruption. Kinda strange. But I
> don't know how close the DUP copies are to each other, if possibly a
> big enough media defect can explain this.

The original post mentioned SSD (but was unclear if _this_ filesystem is
backed by one).  If so, DUP is nearly worthless as both copies will be
written to physical cells next to each other, no matter what positions the
FTL shows them at.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢰⠒⠀⣿⡁ Imagine there are bandits in your house, your kid is bleeding out,
⢿⡄⠘⠷⠚⠋⠀ the house is on fire, and seven big-ass trumpets are playing in the
⠈⠳⣄⠀⠀⠀⠀ sky.  Your cat demands food.  The priority should be obvious...
