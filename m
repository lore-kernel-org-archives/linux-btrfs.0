Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bird.oak.relay.mailchannels.net ([23.83.215.17]:2858 "EHLO
	gt-egress-002.mailchannels.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751826AbcFIMyK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jun 2016 08:54:10 -0400
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 80A7D12034A
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jun 2016 12:35:12 +0000 (UTC)
Received: from lnxwebr13.cpt.wa.co.za (ip-10-215-133-244.us-west-2.compute.internal [10.215.133.244])
	by relay.mailchannels.net (Postfix) with ESMTPA id 4C18C120E8B
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jun 2016 12:35:10 +0000 (UTC)
Received: from [41.74.182.178] (port=58370 helo=tricky-laptop.valid.co.za)
	by lnxwebr13.cpt.wa.co.za with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
	(Exim 4.87)
	(envelope-from <brendan@swiftspirit.co.za>)
	id 1bAzAx-0020xY-Mp
	for linux-btrfs@vger.kernel.org; Thu, 09 Jun 2016 14:35:07 +0200
To: linux-btrfs@vger.kernel.org
From: Brendan Hide <brendan@swiftspirit.co.za>
Subject: Allocator behaviour during device delete
Message-ID: <00ad8257-ba24-fe62-5c93-8db426afec69@swiftspirit.co.za>
Date: Thu, 9 Jun 2016 14:34:54 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey, all

I noticed this odd behaviour while migrating from a 1TB spindle to SSD 
(in this case on a LUKS-encrypted 200GB partition) - and am curious if 
this behaviour I've noted below is expected or known. I figure it is a 
bug. Depending on the situation, it *could* be severe. In my case it was 
simply annoying.

---
Steps

After having added the new device (btrfs dev add), I deleted the old 
device (btrfs dev del)

Then, whilst waiting for that to complete, I started a watch of "btrfs 
fi show /". Note that the below is very close to the output at the time 
- but is not actually copy/pasted from the output.

 > Label: 'tricky-root'  uuid: bcbe47a5-bd3f-497a-816b-decb4f822c42
 >         Total devices 2 FS bytes used 115.03GiB
 >         devid    1 size 0.00GiB used 298.06GiB path /dev/sda2
 >         devid    2 size 200.88GiB used 0.00GiB path /dev/mapper/cryptroot


devid1 is the old disk while devid2 is the new SSD

After a few minutes, I saw that the numbers have changed - but that the 
SSD still had no data:

 > Label: 'tricky-root'  uuid: bcbe47a5-bd3f-497a-816b-decb4f822c42
 >         Total devices 2 FS bytes used 115.03GiB
 >         devid    1 size 0.00GiB used 284.06GiB path /dev/sda2
 >         devid    2 size 200.88GiB used 0.00GiB path /dev/mapper/cryptroot

The "FS bytes used" amount was changing a lot - but mostly stayed near 
the original total, which is expected since there was very little 
happening other than the "migration".

I'm not certain of the exact point where it started using the new disk's 
space. I figure that may have been helpful to pinpoint. :-/

---
Educated guess as to what was happening:

Key: Though the available space on devid1 is displayed as 0 GiB, 
internally the allocator still sees most of the device's space as 
available. The allocator will continue writing to the old disk even 
though the intention is to remove it.

The dev delete operation goes through the chunks in sequence and does a 
"normal" balance operation on each, which the kernel simply sends to the 
"normal" single allocator. At the start of the operation, the allocator 
will see that the device of 1TB has more space available than the 200GB 
device, thus it writes the data to a new chunk on the 1TB spindle.

Only after the chunk is balanced away, does the operation mark *only* 
that "source" chunk as being unavailable. As each chunk is subsequently 
balanced away, eventually the allocator will see that there is more 
space available on the new device than on the old device (1:199/2:200), 
thus the next chunk gets allocated to the new device. The same occurs 
for the next chunk (1:198/2:199) and so on, until the device finally has 
zero usage and is removed completely.

---
Naive approach for a fix (assuming my assessment above is correct)

At the start:
1. "Balance away"/Mark-as-Unavailable empty space
2. Balance away the *current* chunks (data+metadata) that would 
otherwise be written to if the device was still available
3. As before, balance in whatever order is applicable.

---
Severity

I figure that, for my use-case, this isn't a severe issue. However, in 
the case where you want quickly to remove a potentially failing disk 
(common use case for dev delete), I'd much rather that btrfs does *not* 
write data to the disk I'm trying to remove, making this a potentially 
severe bug.


-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97
