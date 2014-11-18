Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:51329 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754928AbaKRS5a convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 13:57:30 -0500
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:51098 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:RC4-SHA:128)
	(Exim 4.84)
	(envelope-from <lists@colorremedies.com>)
	id 1Xqnxv-001iAd-SY
	for linux-btrfs@vger.kernel.org; Tue, 18 Nov 2014 11:57:29 -0700
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20141118153526.GS20972@merlins.org>
Date: Tue, 18 Nov 2014 11:57:27 -0700
Message-Id: <47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za> <546AF572.2020101@swiftspirit.co.za> <20141118153526.GS20972@merlins.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 18, 2014, at 8:35 AM, Marc MERLIN <marc@merlins.org> wrote:

> On Tue, Nov 18, 2014 at 09:29:54AM +0200, Brendan Hide wrote:
>> Hey, guys
>> 
>> See further below extracted output from a daily scrub showing csum 
>> errors on sdb, part of a raid1 btrfs. Looking back, it has been getting 
>> errors like this for a few days now.
>> 
>> The disk is patently unreliable but smartctl's output implies there are 
>> no issues. Is this somehow standard faire for S.M.A.R.T. output?
> 
> Try running hdrecover on your drive, it'll scan all your blocks and try to
> rewrite the ones that are failing, if any:
> http://hdrecover.sourceforge.net/

The only way it can know if there is a bad sector is if the drive returns a read error, which will include the LBA for the affected sector(s). This is the same thing that would be done with scrub, except any bad sectors that don’t contain data. A common problem getting a drive to issue the read error, however, is a mismatch between the scsi command timer setting (default 30 seconds) and the SCT error recover control setting for the drive. The drive SCT ERC value needs to be shorter than the scsi command timer value, otherwise some bad sector errors will cause the drive to go into a longer recovery attempt beyond the scsi command timer value. If that happens, the ata link is reset, and there’s no possibility of finding out what the affected sector is.

So a.) use smartctl -l scterc to change the value below 30 seconds (300 deciseconds) with 70 deciseconds being reasonable. If the drive doesn’t support SCT commands, then b.) change the linux scsi command timer to be greater than 120 seconds.

Strictly speaking the command timer would be set to a value that ensures there are no link reset messages in dmesg, that it’s long enough that the drive itself times out and actually reports a read error. This could be much shorter than 120 seconds. I don’t know if there are any consumer drives that try longer than 2 minutes to recover data from a marginally bad sector.

Ideally though, don’t use drives that lack SCT support in multiple device volume configurations. An up to 2 minute hang of the storage stack isn’t production compatible for most workflows.


Chris Murphy