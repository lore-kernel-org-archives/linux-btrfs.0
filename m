Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:42574 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751572AbaFVSbs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Jun 2014 14:31:48 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:62510 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WymYN-002WIn-Me
	for linux-btrfs@vger.kernel.org; Sun, 22 Jun 2014 12:31:48 -0600
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs on whole disk (no partitions)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAK5rZE6gfmQsZz3W_8t=pkKEk_rzqUn5hQVv0sbt8p7qbdhSdQ@mail.gmail.com>
Date: Sun, 22 Jun 2014 12:31:44 -0600
Message-Id: <DE35C679-30FE-44DB-9FD7-FD6DCD6FD615@colorremedies.com>
References: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com> <2316027.LZEnVG8laK@xev> <CAPLrYETdzeT_Yia-nnbZBMvGxU3x7tCFiJSv3rNJezMsjce3Zw@mail.gmail.com> <6CA8020B-EB92-4A44-8AA5-3F69709F81F2@colorremedies.com> <CAK5rZE6gfmQsZz3W_8t=pkKEk_rzqUn5hQVv0sbt8p7qbdhSdQ@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 22, 2014, at 1:49 AM, Imran Geriskovan <imran.geriskovan@gmail.com> wrote:

>> The 64KB Btrfs bootloader pad is 8 sector aligned, so for 512e AF disks
>> there's no problem formatting the whole drive. The alignment problem
>> actually happens when partitioning it, using old partition tools that don't
>> align on 8 sector boundaries. There are some such tools still floating
>> around.
> 
> A 'somewhat' related question:
> 
> So called Advanced Format drives has 4K physical sector size,
> however they report 512B logical sector size.
> 
> How does linux kernel access those drives?
> 512B or 4K at a time?

Does anyone know if blktrace will intercept the actual SCSI commands sent to the drive? Or is there a better utility to use for this? When I use it unfiltered, I'm not seeing SCSI write commands at all.

This is the blktrace/blkparse for dd if=/dev/zero of=/dev/sda seek=430234064 count=8 oflag=direct
https://docs.google.com/file/d/0B_2Asp8DGjJ9c3J0UXpzUEhNaGs/edit?pli=1

This is the blktrace/blkparse for dd if=/dev/zero of=/dev/sda bs=4096 seek=53779258 count=1
https://docs.google.com/file/d/0B_2Asp8DGjJ9MnEwU0hDNE45dHc/edit?pli=1

The dd command clearly shows a difference, but when I look at the ATA command set I'd expect the Linux SCSI layer to turn these dd commands into the same ATA command: basically a write start LBA and sector count. And the LBA and sector count can only be in 512 byte sector addresses because that's all a 512e type of AF disk understands.

Chris Murphy

