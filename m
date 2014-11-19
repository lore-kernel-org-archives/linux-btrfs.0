Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:56262 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753375AbaKSCkl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 21:40:41 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <546BB2EA.5080809@ubuntu.com>
Date: Tue, 18 Nov 2014 19:40:33 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <E47EA20E-375D-49A6-B4B0-C6594CE6A633@colorremedies.com>
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za> <546AF572.2020101@swiftspirit.co.za> <20141118153526.GS20972@merlins.org> <47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com> <546BB2EA.5080809@ubuntu.com>
To: Phillip Susi <psusi@ubuntu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 18, 2014, at 1:58 PM, Phillip Susi <psusi@ubuntu.com> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 11/18/2014 1:57 PM, Chris Murphy wrote:
>> So a.) use smartctl -l scterc to change the value below 30 seconds 
>> (300 deciseconds) with 70 deciseconds being reasonable. If the
>> drive doesn’t support SCT commands, then b.) change the linux scsi
>> command timer to be greater than 120 seconds.
>> 
>> Strictly speaking the command timer would be set to a value that 
>> ensures there are no link reset messages in dmesg, that it’s long 
>> enough that the drive itself times out and actually reports a read 
>> error. This could be much shorter than 120 seconds. I don’t know
>> if there are any consumer drives that try longer than 2 minutes to 
>> recover data from a marginally bad sector.
> 
> Are there really any that take longer than 30 seconds?  That's enough
> time for thousands of retries.  If it can't be read after a dozen
> tries, it ain't never gonna work.  It seems absurd that a drive would
> keep trying for so long.

It’s well known on linux-raid@ that consumer drives have well over 30 second "deep recoveries" when they lack SCT command support. The WDC and Seagate “green” drives are over 2 minutes apparently. This isn’t easy to test because it requires a sector with enough error that it requires the ECC to do something, and yet not so much error that it gives up in less than 30 seconds. So you have to track down a drive model spec document (one of those 100 pagers).

This makes sense, sorta, because the manufacturer use case is typically single drive only, and most proscribe raid5/6 with such products. So it’s a “recover data at all costs” behavior because it’s assumed to be the only (immediately) available copy.


> 
>> Ideally though, don’t use drives that lack SCT support in multiple 
>> device volume configurations. An up to 2 minute hang of the
>> storage stack isn’t production compatible for most workflows.
> 
> Wasn't there an early failure flag that md ( and therefore, btrfs when
> doing raid ) sets so the scsi stack doesn't bother with recovery
> attempts and just fails the request?  Thus if the drive takes longer
> than the scsi_timeout, the failure would be reported to btrfs, which
> then can recover using the other copy, write it back to the bad drive,
> and hopefully that fixes it?

I don’t see how that’s possible because anything other than the drive explicitly producing  a read error (which includes the affected LBA’s), it’s ambiguous what the actual problem is as far as the kernel is concerned. It has no way of knowing which of possibly dozens of ata commands queued up in the drive have actually hung up the drive. It has no idea why the drive is hung up as well.

The linux-raid@ list is chock full of users having these kinds of problems. It comes up pretty much every week. Someone has an e.g. raid5, and in dmesg all they get are a bunch of ata bus reset messages. So someone tells them to change the scsi command timer for all the block devices that are members of the array in question, and retry (reading file, or scrub or whatever) and low and behold no more ata bus reset messages. Instead they get explicit read errors with LBAs and now md can fix the problem.


> 
> In that case, you probably want to lower the timeout so that the
> recover kicks in sooner instead of hanging your IO stack for 30 seconds.

No I think 30 is pretty sane for servers using SATA drives because if the bus is reset all pending commands in the queue get obliterated which is worse than just waiting up to 30 seconds. With SAS drives maybe less time makes sense. But in either case you still need configurable SCT ERC, or it needs to be a sane fixed default like 70 deciseconds.


Chris Murphy