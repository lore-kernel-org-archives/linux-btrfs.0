Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:39170 "EHLO
	blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbcHLDLr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Aug 2016 23:11:47 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bY2sR-0002xn-CA
	for linux-btrfs@vger.kernel.org; Fri, 12 Aug 2016 05:11:19 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: checksum error in metadata node - best way to move root fs to
 new drive?
Date: Fri, 12 Aug 2016 03:11:13 +0000 (UTC)
Message-ID: <pan$c3b41$2e67dfec$a7a1eb57$b9518b50@cox.net>
References: <CAGdWbB5k_HmN2b4zzrnYN+ExiqeP_9Eu9mVBCHEtgZNKHfTARA@mail.gmail.com>
	<pan$d9b53$c31dc60$985cf806$b833643c@cox.net>
	<CAJCQCtTHH=q9cE-BHDYuDpUASQx4Rnzx_b3VR=v-3s_THf1f4w@mail.gmail.com>
	<CAGdWbB72DLAkV3EwO-7Sakc4gPHRT=GmU5ftxo0YfR0wjBefNQ@mail.gmail.com>
	<CAJCQCtS3c5u6hDjHdU92AdQvSECNT99vOMxLiM4tchv4nrwPmA@mail.gmail.com>
	<CAGdWbB7qNFfKy1C3Ldb8aSCxvphZeYcmrXtdiB_ECGXNLZ-K5w@mail.gmail.com>
	<CAD=QJKjZP3V3HE_iXYcLJvq65mXKiXp_aYgZuoHmQFd7mJ7j0Q@mail.gmail.com>
	<pan$912d3$2d5e3dbf$b96ae0e6$53dad290@cox.net>
	<CAJCQCtTM_RdLHdLLsYjw3AVseHWP__7JLARO02ohYGkjzbnkmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Thu, 11 Aug 2016 14:43:56 -0600 as excerpted:

> On Thu, Aug 11, 2016 at 1:07 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>> The compression-related problem is this:  Btrfs is considerably less
>> tolerant of checksum-related errors on btrfs-compressed data,
> 
> Why? The data is the data. And why would it matter if it's application
> compressed data vs Btrfs compressed data? If there's an error, Btrfs is
> intolerant. I don't see how there's a checksum error that Btrfs
> tolerates.

Apparently, the code path for compressed data is sufficiently different, 
that when there's a burst of checksum errors, even on raid1 where it 
should (and does with scrub) get the correct second copy, it will crash 
the system.  This is my experience and that of others, and what I thought 
was standard btrfs behavior -- I didn't know it was a compression-
specific bug since I use compress on all my btrfs, until someone told me.

When the btrfs compression option hasn't been used on that filesystem, or 
presumably when none of that burst of checksum errors is from btrfs-
compressed files, it will grab the second copy and use it as it should, 
and there will be no crash.  This is as reported by others, including 
people who have tested both with and without btrfs-compressed files and 
found that it only crashed if the files were btrfs-compressed, whereas it 
worked as expected, fetching the valid second copy, if they weren't btrfs-
compressed.

I'd assume this is why this particular bug has remained unsquashed for so 
long.  The devs are likely testing compression, and bad checksum data 
repair from the second copy, but they probably aren't testing bad 
checksum repair on compressed data, so the problem isn't showing up in 
their tests.  Between that and relatively few people running raid1 with 
the compression option and seeing enough bad shutdowns to be aware of the 
problem, it has mostly flown under the radar.  For a long time I myself 
thought it was just the way btrfs behaved with bursts of checksum errors, 
until someone pointed out that it did /not/ behave that way on btrfs that 
didn't have any compressed files when the checksum errors occurred.

> But also I don't know if the checksum is predicated on compressed data
> or uncompressed data - does the scrub blindly read compressed data,
> checksums it, and compares to the previously recorded csum? Or does the
> scrub read compressed data, decompresses it, checksums it, then
> compares? And does compression compress metadata? I don't think it does
> from some of the squashfs testing of the same set of binary files on
> ext4 vs btrfs uncompressed vs btrfs compressed. The difference is
> explained by inline data being compressed (which it is), so I don't
> think the fs itself gets compressed.

As I'm not a coder I can't actually tell you from reading the code, but 
AFAIK, both the 128 KiB compression block size and the checksum are on 
the uncompressed data.  Compression takes place after checksumming.

And I don't believe metadata, whether metadata itself or inline data, is 
compressed by btrfs' transparent compression.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

