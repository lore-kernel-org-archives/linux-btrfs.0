Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:50491 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbaHLC1Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 22:27:25 -0400
Received: by mail-qa0-f42.google.com with SMTP id j15so8438982qaq.15
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 19:27:25 -0700 (PDT)
Message-ID: <53E97B8A.4010304@gmail.com>
Date: Mon, 11 Aug 2014 22:27:22 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Ideas for a feature implementation
References: <1407698476.20187.YahooMailNeo@web192906.mail.sg3.yahoo.com> <53E83035.8010603@gmail.com> <678801E6-E1C8-42B5-8D50-C59B68549EC4@colorremedies.com>
In-Reply-To: <678801E6-E1C8-42B5-8D50-C59B68549EC4@colorremedies.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/11/2014 04:27 PM, Chris Murphy wrote:
> 
> On Aug 10, 2014, at 8:53 PM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
> 
>> 
>> Another thing that isn't listed there, that I would personally
>> love to see is support for secure file deletion.  To be truly
>> secure though, this would need to hook into the COW logic so that
>> files marked for secure deletion can't be reflinked (maybe make
>> the automatically NOCOW instead, and don't allow snapshots?), and
>> when they get written to, the blocks that get COW'ed have the old
>> block overwritten.
> 
> If the file is reflinked or snapshot, then it can it be secure
> deleted? Because what does it mean to secure delete a file when
> there's a completely independent file pointing to the same physical
> blocks? What if someone else owns that independent file? Does the
> reflink copy get rm'd as well? Or does the file remain, but its
> blocks are zero'd/corrupted?
The semantics that I would expect would be that the extents can't be
reflinked, and when snapshotted the whole file gets COW'ed, and then
inherits the secure deletion flag, possibly with another flag saying
that the user can't disable the secure deletion flag.
> 
> For SSDs, whether it's an overwrite or an FITRIM ioctl it's an open
> question when the data is actually irretrievable. It may be
> seconds, but could be much longer (hours?) so I'm not sure if it's
> useful. On HDD's using SMR it's not necessarily a given an
> overwrite will work there either.
By secure deletion, I don't mean make the data absolutely
unrecoverable by any means, I mean make it functionally impractical
for someone without low-level access to and/or extensive knowledge of
the hardware to recover the data; that is, more secure than simply
unlinking the file, but obviously less than (for example) the
application of thermite to the disk platters.  I'm talking the rough
equivalent of wiping the data from RAM.

Anyone who is truly security minded should be using whole disk
encryption anyway, but even then you have the data accessible from the
running OS.
