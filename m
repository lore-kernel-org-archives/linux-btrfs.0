Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:34137 "EHLO
	mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbbHTQoN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Aug 2015 12:44:13 -0400
Received: by vkm66 with SMTP id 66so19393924vkm.1
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Aug 2015 09:44:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201508201343.07618.russell@coker.com.au>
References: <D3CC3E72-929E-4ADF-826F-62DCB6BD827C@lime-technology.com>
	<CAJCQCtSVn7BSYY=Ofq6OsKfHyv_PTKGOg7uP=tUC4XTNQ42v0w@mail.gmail.com>
	<201508201343.07618.russell@coker.com.au>
Date: Thu, 20 Aug 2015 10:44:12 -0600
Message-ID: <CAJCQCtSf=ZK4Avu4nPeBWaDgbHv1xUzegvhfAGbLcBFGrLSM1g@mail.gmail.com>
Subject: Re: Questions on use of NOCOW impact to subvolumes and snapshots
From: Chris Murphy <lists@colorremedies.com>
To: Russell Coker <russell@coker.com.au>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 19, 2015 at 9:43 PM, Russell Coker <russell@coker.com.au> wrote:
> On Thu, 20 Aug 2015 11:55:43 AM Chris Murphy wrote:
>> > Question 1:  If I apply the NOCOW attribute to a file or directory, how
>> > does that affect my ability to run btrfs scrub?
>>
>> nodatacow includes nodatasum and no compression. So it means these
>> files are presently immune from scrub check and repair so long as it's
>> based on checksums. I don't know if raid56 scrub compares to parity
>> and recomputes parity (assumes data is correct), absent checksums,
>> which would be similar to how md raid 56 does it.
>
> Linux Software RAID could recreate a mismatched block from RAID-6 parity but
> doesn't do so.  It could be that a block was changed correctly but didn't get
> the parity data written so such "correction" would be reverting a change.  So
> Linux Software RAID only regenerates parity for a scrub and makes both disks
> have the same data for RAID-1.

https://www.kernel.org/pub/linux/kernel/people/hpa/raid6.pdf

Discussion starts in section 4 on page 7. The relevant part I'm
confused about is on page 8, " once the faulty drive has been
identified" doesn't clarify a mechanism to determine which data drive
is corrupt. Iti seems without that knowledge, it's not possible to
reconstruct. Further, should there be two corruptions, however
unlikely, reconstruction causes a third corruption. So it's a bit
risky.

In any case though, in normal operation, md raid6 isn't checking
parity. It always assumes the data chunks are valid unless the drive
itself returns a read error. For scrub repair, it assumes data is
correct and writes new parity, which is different than with a raid1
scrub repair where there's something of a random (?) assumption which
mirrored chunk is correct and the other(s) are overwritten. I don't
even know that with n-way mirroring this scrub assumes majority rules.



-- 
Chris Murphy
