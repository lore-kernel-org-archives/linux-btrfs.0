Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bl2nam02on0089.outbound.protection.outlook.com ([104.47.38.89]:58272
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755638AbeBOUaq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 15:30:46 -0500
Subject: Re: Metadata / Data on Heterogeneous Media
To: Adam Borowski <kilobyte@angband.pl>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1b2df382-0402-a806-9ebf-996fabf22ba4@panasas.com>
 <20180215190647.ato4mnvzzom36frc@angband.pl>
From: "Ellis H. Wilson III" <ellisw@panasas.com>
Message-ID: <94baea75-0601-f082-4406-5d76847b87fa@panasas.com>
Date: Thu, 15 Feb 2018 15:30:00 -0500
MIME-Version: 1.0
In-Reply-To: <20180215190647.ato4mnvzzom36frc@angband.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/15/2018 02:06 PM, Adam Borowski wrote:
> On Thu, Feb 15, 2018 at 12:15:49PM -0500, Ellis H. Wilson III wrote:
>> In discussing the performance of various metadata operations over the past
>> few days I've had this idea in the back of my head, and wanted to see if
>> anybody had already thought about it before (likely, I would guess).
>>
>> It appears based on this page:
>> https://btrfs.wiki.kernel.org/index.php/Btrfs_design
>> that data and metadata in BTRFS are fairly well isolated from one another,
>> particularly in the case of large files.  This appears reinforced by a
>> recent comment from Qu ("...btrfs strictly
>> split metadata and data usage...").
>>
>> Yet, while there are plenty of options to RAID0/1/10/etc across generally
>> homogeneous media types, there doesn't appear to be any functionality (at
>> least that I can find) to segment different BTRFS internals to different
>> types of devices.  E.G., place metadata trees and extent block groups on
>> SSD, and data trees and extent block groups on HDD(s).
>>
>> Is this something that has already been considered (and if so, implemented,
>> which would make me extremely happy)?  Is it feasible it is hasn't been
>> approached yet?  I admit my internal knowledge of BTRFS is fleeting, though
>> I'm trying to work on that daily at this time, so forgive me if this is
>> unapproachable for obvious architectural reasons.
> 
> Considered: many times.  It's an obvious improvement, and one that shouldn't
> even be that hard to implement.  What remains, it's SMoC then SMoR (Simple
> Matter of Coding then Simple Matter of Review), but both of those are in
> short supply.

Glad to hear it's been discussed, and I understand the issue of 
resources all too well with the project I'm working on.  Maybe if my 
nights and weekends open up...

> After the maximum size of inline extents has been lowered, there's no real
> point in putting different types of metadata or not-really-metadata on
> different media: thus, existing split of data -vs- metadata block groups is
> fine.

That was my thought.  Regarding inlined data, I'm actually quite ok with 
that being on SSD, as that would deliver fast access to tiny objects 
where if you went to HDD you'd spend the great majority of your time 
just seeking to the data in question compared to transfer.

Our existing COW filesystem this is replacing actually did exactly this, 
except it would store the first N KB of each and every object on SSD, so 
even for large files you could get the headers out quickly (as many 
indexing apps want to do).

Best,

ellis
