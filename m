Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from karen.lavabit.com ([72.249.41.33]:59455 "EHLO karen.lavabit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773Ab2HCULH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Aug 2012 16:11:07 -0400
Received: from a.earth.lavabit.com (a.earth.lavabit.com [192.168.111.10])
	by karen.lavabit.com (Postfix) with ESMTP id 1014611BB36
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Aug 2012 15:11:07 -0500 (CDT)
Received: from lavabit.com (70-88-36-65-miami-fl.hfc.comcastbusiness.net [70.88.36.65])
	by lavabit.com with ESMTP id OZ4U34ZBM1K9
	for <linux-btrfs@vger.kernel.org>; Fri, 03 Aug 2012 15:11:07 -0500
Message-ID: <47537.70.88.36.65.1344024666.squirrel@lavabit.com>
In-Reply-To: <jv9618$6nr$1@dough.gmane.org>
References: <36321.99.101.148.183.1343705202.squirrel@lavabit.com>
    <20120731113247.11aab72a@natsu> <jv9618$6nr$1@dough.gmane.org>
Date: Fri, 3 Aug 2012 16:11:06 -0400 (EDT)
Subject: Re: filesystem finder / fixer
From: serialhex@lavabit.com
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Alex Elsayed wrote:
>
> Just realized I messed up sending this to the list.
>
> Roman Mamedov wrote:
>
>> On Mon, 30 Jul 2012 23:26:42 -0400 (EDT)
>> serialhex@lavabit.com wrote:
>>
>>> 1) is there a tool to help me recover data from my fs? I don't have a
>>> backup of my partition table and so I have about 500GB of space where a
>>> few partitionns might reside... GPT partitions mind you
>>
>> If you only lost the partition table, there's a tool (strangely)named
>> TestDisk, which can find the actual partitions on disk and restore it.
>> Don't know if it supports GPT and BTRFS, though.
>>
>
> If TestDisk doesn't support it, then you may be able to do it manually
> with
> some trial and error.
>
> I just dumped the first 4 megabytes of my disk, and it looks like at
> offset
> 0x10040 (64K + 64 bytes) there's the string BHRfS (hex 5F 42 48 52 66 53
> 5f). That matches the documentation (the first superblock should be at
> 64K).

ok, so it's been a few days, because it took me a few days to get
everything back up and running, but here's what i did:

(tl;dr - i got my data back!)

i did as Alex suggested.  but i was getting a *lot* of false positives. 
the string _BHRfS_H is in the source code, some binaries, or something....
so the fact that bits are bits when reading the device as a file, i have
to ignore all of those.  then there were a handful of other ones that
looked to be the first superblock, but every time i tried it didn't
work...  so i read up on btrfs some more.  the _BHRfS_H string starts at
0x40 (64 bytes) and the first bytes are a checksum of everything after. 
so i started with that, and found a number of the _BHRfS_H strings to have
00's before it, so a checksum of zero... which is *HIGHLY* unlikely.  so i
looked for that, and the first one i found with a checksum >0 i tried, and
succeeded!!

Thanks for the help & advice!!  i've now got my stuff back (and need to do
an actual backup :P )

hex


