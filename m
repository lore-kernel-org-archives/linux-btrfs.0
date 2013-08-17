Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:53220 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab3HQMFj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 Aug 2013 08:05:39 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id AC2577C0680
	for <linux-btrfs@vger.kernel.org>; Sat, 17 Aug 2013 06:05:38 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Chris Mason <chris.mason@fusionio.com>
To: Craig Johnson <crajohns@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <CAPidFuhbjxYUqjLV_8tCCVX6aSNwZ1qJGCZvnSPx8cShGCrQvA@mail.gmail.com>
In-Reply-To: <CAPidFuhbjxYUqjLV_8tCCVX6aSNwZ1qJGCZvnSPx8cShGCrQvA@mail.gmail.com>
Message-ID: <20130817120534.17880.11982@localhost.localdomain>
Subject: Re: 4 vol raid5 segfault on device delete
Date: Sat, 17 Aug 2013 08:05:34 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Craig Johnson (2013-08-16 12:50:59)
> I have a 4 device volume with raid5 - trying to remove one of the
> devices (plenty of free space) and I get an almost immediate segfault.
>  Scrub shows no errors, repair show space cache invalid but nothing
> else (I remounted with clear cache to be safe).  Lots of corrupt on
> bdev (for 3 out of 4 drives), but I have no file access issues that I
> know of.  Thanks!
> 
> Output below:
> 
> http://pastebin.com/AnrmZrt2

Hi Craig,

Just double checking how you setup the device removal?  This is a 3.11
arch kernel?  Which rc was it based from?

-chris

