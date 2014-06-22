Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:45349 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751358AbaFVBel convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Jun 2014 21:34:41 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:59481 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WyWfw-00303p-FK
	for linux-btrfs@vger.kernel.org; Sat, 21 Jun 2014 19:34:32 -0600
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs on whole disk (no partitions)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAPLrYETdzeT_Yia-nnbZBMvGxU3x7tCFiJSv3rNJezMsjce3Zw@mail.gmail.com>
Date: Sat, 21 Jun 2014 19:34:30 -0600
Message-Id: <6CA8020B-EB92-4A44-8AA5-3F69709F81F2@colorremedies.com>
References: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com> <2316027.LZEnVG8laK@xev> <CAPLrYETdzeT_Yia-nnbZBMvGxU3x7tCFiJSv3rNJezMsjce3Zw@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 21, 2014, at 1:12 PM, Daniel Cegiełka <daniel.cegielka@gmail.com> wrote:

> 2014-06-19 2:07 GMT+02:00 Russell Coker <russell@coker.com.au>:
> 
>> For boot disks I use the traditional partitioning system.  So far I don't run
>> any systems that have a boot disk larger than 2TB so I haven't needed to use
>> GPT.
>> 
>> I have a BTRFS RAID-1 on 2*3TB disks which have no partition tables, when the
>> filesystem is going to use the entire device and there's no boot loader there
>> is no reason to have a partition table.
> 
> ok, but what about alignment? This can have a significant impact on performance.

The 64KB Btrfs bootloader pad is 8 sector aligned, so for 512e AF disks there's no problem formatting the whole drive. The alignment problem actually happens when partitioning it, using old partition tools that don't align on 8 sector boundaries. There are some such tools still floating around.

Chris Murphy