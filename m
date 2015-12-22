Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:32777 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932944AbbLVR0G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Dec 2015 12:26:06 -0500
Received: by mail-io0-f177.google.com with SMTP id 186so195740676iow.0
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 09:26:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151222045507.24886af5@jupiter.sol.kaishome.de>
References: <4082684905f25f921ae4564b1c8a892e@admin.virtall.com>
 <565EEC1F.7070600@gmail.com> <18fb40ae4411f31353e06bf99ee12c8a@admin.virtall.com>
 <565F04E1.6000003@gmail.com> <20151222045507.24886af5@jupiter.sol.kaishome.de>
From: james northrup <northrup.james@gmail.com>
Date: Tue, 22 Dec 2015 09:25:45 -0800
Message-ID: <CAPkEcwhE91b9DUyKH-Fi9FbM6-i+_qRQRL4tSMnZhvaUXUsgcQ@mail.gmail.com>
Subject: Re: compression disk space saving - what are your results?
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

if you have been waiting for a particular compressor to reach linux,
chances are it already has.

if you are slacking with btrfs and assuming someone will port your
favorite compression profile to a btrfs mount option someday, someone
has thought of that too, and that's already happened as well.



Add support for LZ4-compressed kernel [LWN.net]
https://lwn.net/Articles/541425/

bzip2/lzma kernel compression [LWN.net] https://lwn.net/Articles/314295/

Btrfs Picks Up Snappy Compression Support - Phoronix
http://www.phoronix.com/scan.php?page=news_item&px=MTA0MjQ

fusecompress - Transparent compression FUSE filesystem (0.9.x tree) -
Google Project Hosting https://code.google.com/p/fusecompress/

On Mon, Dec 21, 2015 at 7:55 PM, Kai Krakow <hurikhan77@gmail.com> wrote:
> Am Wed, 2 Dec 2015 09:49:05 -0500
> schrieb Austin S Hemmelgarn <ahferroin7@gmail.com>:
>
>> > So, 138 GB files use just 24 GB on disk - nice!
>> >
>> > However, I would still expect that compress=zlib has almost the same
>> > effect as compress-force=zlib, for 100% text files/logs.
>> >
>> That's better than 80% space savings (it works out to about 83.6%),
>> so I doubt that you'd manage to get anything better than that even
>> with only plain text files.  It's interesting that there's such a big
>> discrepancy though, that indicates that BTRFS really needs some work
>> WRT deciding what to compress.
>
> As far as I understood from reading here, btrfs fairly quickly opts out
> of compressing further extents if it stumbles across the first block
> with a bad compression ratio for file.
>
> So, what I do is compress-force=zlib for my backup drive which holds
> several months of snapshots, new backups go to a scratch area which is
> snapshotted after rsync finishes (important: use --no-whole-file and
> --inplace).
>
> On my system drive I use compress=lzo and hope the heuristics work.
> From time to time I use find and btrfs-defrag to selectively recompress
> files (using mtime and name filters) and defrag directory nodes (which
> according to docs should defrag metadata).
>
> A 3x TB btrfs mraid1 draid0 (1.6TB used) fits onto a 2TB backup drive
> with backlog worth around 4 months (daily backups). It looks pretty
> effective. Forcing zlib manages to compress file additions quite well
> although I didn't measure it lately. It was far from 80% but it was not
> far below 40-50%.
>
> I wish one could use per-subvolume compression option already.
>
> --
> Regards,
> Kai
>
> Replies to list-only preferred.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
