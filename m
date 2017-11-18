Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f178.google.com ([74.125.82.178]:41889 "EHLO
        mail-ot0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752852AbdKRDTN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 22:19:13 -0500
Received: by mail-ot0-f178.google.com with SMTP id b54so3638272otd.8
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Nov 2017 19:19:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0d0062da-6310-7662-a7ec-edc6591b4542@mokrynskyi.com>
References: <0d0062da-6310-7662-a7ec-edc6591b4542@mokrynskyi.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 17 Nov 2017 20:19:11 -0700
Message-ID: <CAJCQCtSBxDP7ZyCnQuZZLQXXURrKLT+1Ja61pD_uR0oGH0piDA@mail.gmail.com>
Subject: Re: Unrecoverable scrub errors
To: Nazar Mokrynskyi <nazar@mokrynskyi.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 17, 2017 at 8:41 AM, Nazar Mokrynskyi <nazar@mokrynskyi.com> wrote:

>> [551049.038718] BTRFS warning (device dm-2): checksum error at logical 470069460992 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 942238048: metadata leaf (level 0) in tree 985
>> [551049.038720] BTRFS warning (device dm-2): checksum error at logical 470069460992 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 942238048: metadata leaf (level 0) in tree 985
>> [551049.038723] BTRFS error (device dm-2): bdev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
>> [551049.039634] BTRFS warning (device dm-2): checksum error at logical 470069526528 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 942238176: metadata leaf (level 0) in tree 985
>> [551049.039635] BTRFS warning (device dm-2): checksum error at logical 470069526528 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 942238176: metadata leaf (level 0) in tree 985
>> [551049.039637] BTRFS error (device dm-2): bdev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1 errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
>> [551049.413114] BTRFS error (device dm-2): unable to fixup (regular) error at logical 470069460992 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1


These are metadata errors. Are there any other storage stack related
errors in the previous 2-5 minutes, such as read errors (UNC) or SATA
link reset messages?

> Are there any better options before resorting to `btrfsck --repair`?

I wouldn't try it just yet. What do you get for btrfs check without
repair? This will check the metadata and it should run into the same
problem, but if it craps out then chances are --repair will too.


>Maybe I can find snapshot that contains file with wrong checksum and remove corresponding snapshot or something like that?

It's not a file. It's metadata leaf.


>> nazar-pc@nazar-pc ~> sudo btrfs filesystem df /media/Backup
>> Data, single: total=879.01GiB, used=877.24GiB
>> System, DUP: total=40.00MiB, used=128.00KiB
>> Metadata, DUP: total=20.50GiB, used=18.96GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B

Metadata is DUP, but both copies have corruption. Kinda strange. But I
don't know how close the DUP copies are to each other, if possibly a
big enough media defect can explain this.

What do you get for smartctl -l scterc /dev/ (whole physical device,
not the dm device)

In the meantime, take the drive offline (umount it), and run smartctl
-t long, and after that finishes, smartctl -x. Attach that as a plain
text file, it should be small enough for the list to handle it, and
avoids reformatting problems.


-- 
Chris Murphy
