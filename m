Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:43807 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751062AbaALUyd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jan 2014 15:54:33 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:56493 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W2S3E-003tW0-GQ
	for linux-btrfs@vger.kernel.org; Sun, 12 Jan 2014 13:54:32 -0700
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: RAID 1 with no data on it when accidentally switched HDD
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <7e169377e2a149281902ebbce55a9f7e@www.jitmail.de>
Date: Sun, 12 Jan 2014 13:54:32 -0700
Message-Id: <64FC3812-400C-4CF2-97D1-4529E7FB1C57@colorremedies.com>
References: <7e169377e2a149281902ebbce55a9f7e@www.jitmail.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 12, 2014, at 12:35 PM, Ingo Ebel <ingo.ebel@ingoebel.de> wrote:

> Hi,
> 
> I'm not sure whether it's a bug in btrfs or my distro but I discovered an odd behavior today.
> 
> My Setup:
> 
> * Btrfs v3.12+20131125
> * /dev/sda – Boot OS - opensuse 13.1
> * Btrfs RAID 1 on /dev/sdb1 and /dev/sdc1
> 
> I added an extra HDD with an other OS and Data on it witch accidentally became /dev/sdc.

I don't understand the exact sequence. How does a 3rd drive appear as sdc when the 2nd drive is sdc and sdc1 is part of a Btrfs file system already? Did you reboot and the 3rd drive became sdc? This needs to be explained better, including the exact commands you used.


Chris Murphy

