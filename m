Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw10a-ines.wadns.net ([41.185.62.129]:29418 "EHLO
	fw10a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754358AbaKRNZL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 08:25:11 -0500
Message-ID: <546B48B1.2060505@swiftspirit.co.za>
Date: Tue, 18 Nov 2014 15:25:05 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za> <546AF572.2020101@swiftspirit.co.za> <546B36A4.2030101@gmail.com>
In-Reply-To: <546B36A4.2030101@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/11/18 14:08, Austin S Hemmelgarn wrote:
> [snip] there are some parts of the drive that aren't covered by SMART attributes on most disks, most notably the on-drive cache. There really isn't a way to disable the read cache on the drive, but you can disable write-caching.
Its an old and replaceable disk - but if the cable replacement doesn't 
work I'll try this for kicks. :)
> The other thing I would suggest trying is a different data cable to the drive itself, I've had issues with some SATA cables (the cheap red ones you get in the retail packaging for some hard disks in particular) having either bad connectors, or bad strain-reliefs, and failing after only a few hundred hours of use.
Thanks. I'll try this first. :)

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

