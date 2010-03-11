From: Gordan Bobic <gordan@bobich.net>
Subject: Re: SSD Optimizations
Date: Thu, 11 Mar 2010 12:09:29 +0000
Message-ID: <7832455d62f27d8fb89a7c40ac3cd386@localhost>
References: <4B97F7CE.4030405@bobich.net> <4B9829B1.1020706@bobich.net> <20100311073853.GA26129@attic.humilis.net> <201003111159.58081.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201003111159.58081.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 11 Mar 2010 11:59:57 +0100, Hubert Kario <hka@qbs.com.pl> wrote:

> Still, I think that if you can prolong the life of hardware without
> noticable 
> performance degradation, you should do it. Just because it may help the
> drive 
> with some defects last those 3-5years between upgreades without any
> problems.

I couldn't agree more. Not only that but working with wear leveling in
mind (especially on devices without TRIM support) can increase performance,
too, by avoiding having to wait for the slow erase operation on writes.

>> > Also, for drives that don't support TRIM, is there a way to make the
>> > FS apply aggressive re-use of erased space (in order to help the
>> > drive's internal wear-leveling)?
>> 
>> TRIM has nothing to do with wear-leveling (although it helps reducing
>> wear).
>> TRIM lets the OS tell the disk which blocks are not in use anymore, and
>> thus don't have to be copied during a rewrite of the blocks.
>> Wear-leveling is the SSD making sure all blocks are more or less
equally
>> written to avoid continuous load on the same blocks.
> 
> Isn't this all about wear leveling? TRIM has no meaning for magnetic
> media.

I fully agree that it's important for wear leveling on flash media, but
from the security point of view, I think TRIM would be a useful feature on
all storage media. If the erased blocks were trimmed it would provide a
potentially useful feature of securely erasing the sectors that are no
longer used. It would be useful and much more transparent than the secure
erase features that only operate on the entire disk. Just MHO.

Gordan
