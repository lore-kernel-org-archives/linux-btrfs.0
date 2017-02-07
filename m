Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:59490 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751336AbdBGW57 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 17:57:59 -0500
Subject: Re: dup vs raid1 in single disk
To: Kai Krakow <hurikhan77@gmail.com>, linux-btrfs@vger.kernel.org
References: <CACNDjuzntG5Saq5HHNeDUmq-=28riKAerkO=CD=zAW-QofbKSg@mail.gmail.com>
 <CACNDjuw3GqkCggUqim==Y+xj=bnL93wwdx26denvQaD4tFf7yw@mail.gmail.com>
 <20170119232340.64327c09@natsu>
 <6f06bd6b-67c9-533b-9bf5-89cff8b892da@gmail.com>
 <20170207232818.35b6bfcb@jupiter.sol.kaishome.de>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <b9338528-c282-7510-7b09-666991b366ae@mendix.com>
Date: Tue, 7 Feb 2017 23:46:51 +0100
MIME-Version: 1.0
In-Reply-To: <20170207232818.35b6bfcb@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/07/2017 11:28 PM, Kai Krakow wrote:
> Am Thu, 19 Jan 2017 15:02:14 -0500
> schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:
> 
>> On 2017-01-19 13:23, Roman Mamedov wrote:
>>> On Thu, 19 Jan 2017 17:39:37 +0100
>>> [...]
>>> And the DUP mode is still useful on SSDs, for cases when one copy
>>> of the DUP gets corrupted in-flight due to a bad controller or RAM
>>> or cable, you could then restore that block from its good-CRC DUP
>>> copy.  
>> The only window of time during which bad RAM could result in only one 
>> copy of a block being bad is after the first copy is written but
>> before the second is, which is usually an insanely small amount of
>> time.  As far as the cabling, the window for errors resulting in a
>> single bad copy of a block is pretty much the same as for RAM, and if
>> they're persistently bad, you're more likely to lose data for other
>> reasons.
> 
> It depends on the design of the software. You're true if this memory
> block is simply a single block throughout its lifetime in RAM before
> written to storage. But if it is already handled as duplicate block in
> memory, odds are different. I hope btrfs is doing this right... ;-)

In memory, it's just one copy, happily sitting around, getting corrupted
by cosmic rays and other stuff done to it by aliens, after which a valid
checksum is calculated for the corrupt data, after which it goes on its
way to disk, twice. Yay.

>> That said, I do still feel that DUP mode has value on SSD's.  The 
>> primary arguments against it are:
>> 1. It wears out the SSD faster.
> 
> I don't think this is a huge factor, even more when looking at TBW
> capabilities of modern SSDs. And prices are low enough to better swap
> early than waiting for the disaster hitting you. Instead, you can still
> use the old SSD for archival storage (but this has drawbacks, don't
> leave them without power for months or years!) or as a shock resistent
> USB mobile drive on the go.
> 
>> 2. The blocks are likely to end up in the same erase block, and 
>> therefore there will be no benefit.
> 
> Oh, this is probably a point to really think about... Would ssd_spread
> help here?

I think there was another one, SSD firmware deduplicating writes,
converting the DUP into single again, giving a false idea of it being DUP.

This is one that can be solved by e.g. using disk encryption, which
causes same writes to show up as different data on disk.

-- 
Hans van Kranenburg
