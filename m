Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bl2nam02on0044.outbound.protection.outlook.com ([104.47.38.44]:52992
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755782AbeBOUbw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 15:31:52 -0500
Subject: Re: Metadata / Data on Heterogeneous Media
To: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1b2df382-0402-a806-9ebf-996fabf22ba4@panasas.com>
 <20180215191155.GP3807@carfax.org.uk>
From: "Ellis H. Wilson III" <ellisw@panasas.com>
Message-ID: <ee05142e-0923-18b7-a279-847496b7733a@panasas.com>
Date: Thu, 15 Feb 2018 15:31:46 -0500
MIME-Version: 1.0
In-Reply-To: <20180215191155.GP3807@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/15/2018 02:11 PM, Hugo Mills wrote:
> On Thu, Feb 15, 2018 at 12:15:49PM -0500, Ellis H. Wilson III wrote:
>> In discussing the performance of various metadata operations over
>> the past few days I've had this idea in the back of my head, and
>> wanted to see if anybody had already thought about it before
>> (likely, I would guess).
>>
>> It appears based on this page:
>> https://btrfs.wiki.kernel.org/index.php/Btrfs_design
>> that data and metadata in BTRFS are fairly well isolated from one
>> another, particularly in the case of large files.  This appears
>> reinforced by a recent comment from Qu ("...btrfs strictly
>> split metadata and data usage...").
>>
>> Yet, while there are plenty of options to RAID0/1/10/etc across
>> generally homogeneous media types, there doesn't appear to be any
>> functionality (at least that I can find) to segment different BTRFS
>> internals to different types of devices.  E.G., place metadata trees
>> and extent block groups on SSD, and data trees and extent block
>> groups on HDD(s).
>>
>> Is this something that has already been considered (and if so,
>> implemented, which would make me extremely happy)?  Is it feasible
>> it is hasn't been approached yet?  I admit my internal knowledge of
>> BTRFS is fleeting, though I'm trying to work on that daily at this
>> time, so forgive me if this is unapproachable for obvious
>> architectural reasons.
> 
>     Well, it's been discussed, and I wrote up a theoretical framework
> which should cover a wide range of use-cases:
> 
> https://www.spinics.net/lists/linux-btrfs/msg33916.html
> 
>     I never got round to implementing it, though -- I ran into issues
> over storing the properties/metadata needed to configure it.

Very interesting thread.  Thank you for sharing Hugo.  That nomenclature 
is rather expressive, and the design covers a much broader base than I 
was imagining.

Best,

ellis
