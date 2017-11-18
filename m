Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.mokrynskyi.com ([46.4.12.50]:41832 "EHLO mx.mokrynskyi.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1946015AbdKRIPv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 18 Nov 2017 03:15:51 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.mokrynskyi.com (Postfix) with ESMTP id 059A71355
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Nov 2017 08:15:50 +0000 (UTC)
Received: from mx.mokrynskyi.com ([127.0.0.1])
        by localhost (mx.mokrynskyi.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ET2ub2UYxqCM for <linux-btrfs@vger.kernel.org>;
        Sat, 18 Nov 2017 08:15:49 +0000 (UTC)
Subject: Re: Unrecoverable scrub errors
To: Adam Borowski <kilobyte@angband.pl>,
        Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <0d0062da-6310-7662-a7ec-edc6591b4542@mokrynskyi.com>
 <CAJCQCtSBxDP7ZyCnQuZZLQXXURrKLT+1Ja61pD_uR0oGH0piDA@mail.gmail.com>
 <20171118033335.2ha45mvia5edu6p6@angband.pl>
From: Nazar Mokrynskyi <nazar@mokrynskyi.com>
Message-ID: <277c8155-8651-f593-0f3f-e36add09d943@mokrynskyi.com>
Date: Sat, 18 Nov 2017 10:15:48 +0200
MIME-Version: 1.0
In-Reply-To: <20171118033335.2ha45mvia5edu6p6@angband.pl>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I can assure you that drive (it is HDD) is perfectly functional with 0 SMART errors or warnings and doesn't have any problems. dmesg is clean in that regard too, HDD itself can be excluded from potential causes.

There were however some memory-related issues on my machine a few months ago, so there is a chance that data might have being written incorrectly to the drive back then (I didn't run scrub on backup drive for a long time).

How can I identify to which files these metadata belong to replace or just remove them (files)?

Sincerely, Nazar Mokrynskyi
github.com/nazar-pc

18.11.17 05:33, Adam Borowski пише:
> On Fri, Nov 17, 2017 at 08:19:11PM -0700, Chris Murphy wrote:
>> On Fri, Nov 17, 2017 at 8:41 AM, Nazar Mokrynskyi <nazar@mokrynskyi.com> wrote:
>>
>>>> [551049.038718] BTRFS warning (device dm-2): checksum error at logical 470069460992 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 942238048: metadata leaf (level 0) in tree 985
>>>> [551049.038720] BTRFS warning (device dm-2): checksum error at logical 470069460992 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 942238048: metadata leaf (level 0) in tree 985
>>>> [551049.038723] BTRFS error (device dm-2): bdev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
>>>> [551049.039634] BTRFS warning (device dm-2): checksum error at logical 470069526528 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 942238176: metadata leaf (level 0) in tree 985
>>>> [551049.039635] BTRFS warning (device dm-2): checksum error at logical 470069526528 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 942238176: metadata leaf (level 0) in tree 985
>>>> [551049.039637] BTRFS error (device dm-2): bdev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1 errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
>>>> [551049.413114] BTRFS error (device dm-2): unable to fixup (regular) error at logical 470069460992 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1
>> These are metadata errors. Are there any other storage stack related
>> errors in the previous 2-5 minutes, such as read errors (UNC) or SATA
>> link reset messages?
>>
>>> Maybe I can find snapshot that contains file with wrong checksum and
>>> remove corresponding snapshot or something like that?
>> It's not a file. It's metadata leaf.
> Just for the record: had this be a data block (ie, a non-inline file
> extent), the dmesg message would include one of filenames that refer to that
> extent.  To clear the error, you'd need to remove all such files.
>
>>>> nazar-pc@nazar-pc ~> sudo btrfs filesystem df /media/Backup
>>>> Data, single: total=879.01GiB, used=877.24GiB
>>>> System, DUP: total=40.00MiB, used=128.00KiB
>>>> Metadata, DUP: total=20.50GiB, used=18.96GiB
>>>> GlobalReserve, single: total=512.00MiB, used=0.00B
>> Metadata is DUP, but both copies have corruption. Kinda strange. But I
>> don't know how close the DUP copies are to each other, if possibly a
>> big enough media defect can explain this.
> The original post mentioned SSD (but was unclear if _this_ filesystem is
> backed by one).  If so, DUP is nearly worthless as both copies will be
> written to physical cells next to each other, no matter what positions the
> FTL shows them at.
>
>
> Meow!
