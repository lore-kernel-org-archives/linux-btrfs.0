Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:32809 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751834AbaHXC5k convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Aug 2014 22:57:40 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:51588 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XLNzw-003RLU-Eq
	for linux-btrfs@vger.kernel.org; Sat, 23 Aug 2014 20:57:40 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: superblock checksum mismatch after crash, cannot mount
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$101a9$d6ff1fb7$ae6d9b70$9c335a80@cox.net>
Date: Sat, 23 Aug 2014 20:57:39 -0600
Message-Id: <E349F41A-F000-4D65-B357-81E5243408BE@colorremedies.com>
References: <53F7BD8E.10308@floga.de> <pan$a4556$243aa48a$bd2898a8$c2006893@cox.net> <53F85317.8060900@floga.de> <pan$16219$d960b649$52ed1e6$33540704@cox.net> <20140823163803.GA9149@hungrycats.org> <pan$101a9$d6ff1fb7$ae6d9b70$9c335a80@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 23, 2014, at 6:56 PM, Duncan <1i5t5.duncan@cox.net> wrote:

> Zygo Blaxell posted on Sat, 23 Aug 2014 12:38:05 -0400 as excerpted:
> 
>> Consumer SD cards are /terrible/ storage devices.  Always back up all
>> data written to an SD card as soon as possible after writing it, and
>> develop a process to restore the backup to a new SD card conveniently
>> when--not if--the card fails.
>> 
>> Over the years I've burned my way through dozens of SD cards in Pis,
>> Beagles, x86 laptops, USB SD card readers, cameras and cell phones.
>> I have more bad or failed cards than good ones in my collection, but no
>> more than three of any specific model.  Brand, price, and specs don't
>> correlate to success or failure.  Even the good cards wear out after
>> heavy use.  The bad ones fail much faster, and are more likely to give
>> you garbage data instead of properly formed I/O errors as they fail.
> 
> I had read that it was bad, but I didn't know it was /that/ bad.  The 
> ones I've used have tended to be write-once, read for quite some time, 
> often lose (or throw away as obsolete due to tiny size) before I write 
> them again, or at least before I write them half a dozen times, and I've 
> generally not has problems with them doing that, but I wouldn't tend to 
> know about routine rewrite behavior.  Sounds like it's much worse than I 
> might have thought.

Their primary usage is photography and video. Specifically it means highly variable camera firmware doing only sequential writing with only FAT32 (SD/SDHC) or exFAT (SDXC) as the fs, and jpeg, raw and video for file formats. The computer's job is pretty much read-only. It's a really narrow use case and I think they have their hands full with the camera firmware as a variable. So I wouldn't be surprised if the use case discussed here doesn't get much attention.

It's so bad for years now with CF and SD Cards the card manufacturer's say basically to expect corruption or malfunctioning cameras if you move the card between cameras without reformatting. And the reformatting needs to be done in-camera. In amateur and esp. pro photography and video, it's long been suggests to not delete individual files in the camera UI. Take your shots. When full or convenient copy all of them off the card. Back them up. Open/process them to make sure they're not already corrupted. Then reformat the card in-camera. Do the editing, i.e. delete photos you don't want, on the computer.


Chris Murphy