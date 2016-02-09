Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:35141 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093AbcBIPAn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Feb 2016 10:00:43 -0500
Received: by mail-io0-f182.google.com with SMTP id d63so19781838ioj.2
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Feb 2016 07:00:42 -0800 (PST)
Subject: Re: USB memory sticks wear & speed: btrfs vs f2fs?
To: Brendan Hide <brendan@swiftspirit.co.za>, Martin <m_btrfs@ml1.co.uk>,
        linux-btrfs@vger.kernel.org
References: <n9chle$q0h$1@ger.gmane.org> <56B9F2E2.8010808@swiftspirit.co.za>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56B9FEC0.8020603@gmail.com>
Date: Tue, 9 Feb 2016 09:59:12 -0500
MIME-Version: 1.0
In-Reply-To: <56B9F2E2.8010808@swiftspirit.co.za>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-02-09 09:08, Brendan Hide wrote:
> On 2/9/2016 1:13 PM, Martin wrote:
>> How does btrfs compare to f2fs for use on (128GByte) USB memory sticks?
>>
>> Particularly for wearing out certain storage blocks?
>>
>> Does btrfs heavily use particular storage blocks that will prematurely
>> "wear out"?
>>
>> (That is, could the whole 128GBytes be lost due to one 4kByte block
>> having been re-written excessively too many times due to a fixed
>> repeatedly used filesystem block?)
>>
>> Any other comparisons/thoughts for btrfs vs f2fs?
> Copy-on-write (CoW) designs tend naturally to work well with flash
> media. F2fs is *specifically* designed to work well with flash, whereas
> for btrfs it is a natural consequence of the copy-on-write design. With
> both filesystems, if you randomly generate a 1GB file and delete it 1000
> times, onto a 1TB flash, you are *very* likely to get exactly one write
> to *every* block on the flash (possibly two writes to <1% of the blocks)
> rather than, as would be the case with non-CoW filesystems, 1000 writes
> to a small chunk of blocks.
This goes double if you're using the 'ssd' mount option on BTRFS.  Also, 
the only blocks that are rewritten in place on BTRFS (unless you turn 
off COW) are the superblocks, but all filesystems rewrite those in-place.
>
> I haven't found much reference or comparison information online wrt wear
> leveling - mostly performance benchmarks that don't really address your
> request. Personally I will likely never bother with f2fs unless I
> somehow end up working on a project requiring relatively small storage
> in Flash (as that is what f2fs was designed for).
I would tend to agree, but that's largely because BTRFS is more of a 
known entity for me, and certain features (send/receive in particular) 
are important enough for my usage that I'm willing to take the 
performance hit.  IIRC, F2FS was developed for usage in stuff like 
Android devices and other compact embedded devices, where the FTL may 
not do a good job of wear leveling, so it should work equally well on 
USB flash drives (many of the cheap ones have no wear-leveling at all, 
and even some of the expensive ones have sub-par wear-leveling compared 
to good SSD's).
