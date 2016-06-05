Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bumble.birch.relay.mailchannels.net ([23.83.209.25]:43800 "EHLO
	gt-egress-001.mailchannels.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751342AbcFEA53 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 4 Jun 2016 20:57:29 -0400
Subject: Re: RAID1 vs RAID10 and best way to set up 6 disks
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Mitchell Fossen <msfossen@gmail.com>, linux-btrfs@vger.kernel.org
References: <1464977432.1571.20.camel@gmail.com>
 <1464977591.6679.13.camel@scientia.net> <1464979359.1571.25.camel@gmail.com>
 <1464980373.6679.28.camel@scientia.net>
From: Brendan Hide <brendan@swiftspirit.co.za>
Message-ID: <89aaee85-9ad5-9bde-b4fb-6c4758e8fd34@swiftspirit.co.za>
Date: Sun, 5 Jun 2016 02:41:00 +0200
MIME-Version: 1.0
In-Reply-To: <1464980373.6679.28.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/03/16 20:59, Christoph Anton Mitterer wrote:
> On Fri, 2016-06-03 at 13:42 -0500, Mitchell Fossen wrote:
>> Thanks for pointing that out, so if I'm thinking correctly, with
>> RAID1
>> it's just that there is a copy of the data somewhere on some other
>> drive.
>>
>> With RAID10, there's still only 1 other copy, but the entire
>> "original"
>> disk is mirrored to another one, right?
As Justin mentioned, btrfs doesn't raid whole disks/devices. Instead, it 
works with chunks.

>
> To be honest, I couldn't tell you for sure :-/ ... IMHO the btrfs
> documentation has some "issues".
>
> mkfs.btrfs(8) says: 2 copies for RAID10, so I'd assume it's just the
> striped version of what btrfs - for whichever questionable reason -
> calls "RAID1".

The "questionable reason" is simply the fact that it is, now as well as 
at the time the features were added, the closest existing terminology 
that best describes what it does. Even now, it would be difficult on the 
spot adequately to explain what it means for redundancy without also 
mentioning "RAID".

Btrfs does not raid disks/devices. It works with chunks that are 
allocated to devices when the previous chunk/chunk-set is full.

We're all very aware of the inherent problem of language - and have 
discussed various ways to address it. You will find that some on the 
list (but not everyone) are very careful to never call it "RAID" - but 
instead raid (very small difference, I know). Hugo Mills previously made 
headway in getting discussion and consensus of proper nomenclature. *

> Especially, when you have an odd number devices (or devices with
> different sizes), its not clear to me, personally, at all how far that
> redundancy actually goes respectively what btrfs actually does... could
> be that you have your 2 copies, but maybe on the same device then?

No, btrfs' raid1 naively guarantees that the two copies will *never* be 
on the same device. raid10 does the same thing - but in stripes on as 
many devices as possible.

The reason I say "naively" is that there is little to stop you from 
creating a 2-device "raid1" using two partitions on the same physical 
device. This is especially difficult to detect if you add abstraction 
layers (lvm, dm-crypt, etc). This same problem does apply to mdadm however.

Though it won't necessarily answer all questions about allocation, I 
strongly suggest checking out Hugo's btrfs calculator **

I hope this is helpful.

* http://comments.gmane.org/gmane.comp.file-systems.btrfs/34717 / 
https://www.spinics.net/lists/linux-btrfs/msg33742.html
* http://comments.gmane.org/gmane.comp.file-systems.btrfs/34792
** http://carfax.org.uk/btrfs-usage/

>
>
> Cheers,
> Chris.
>

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97
