Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [50.115.112.57] ([50.115.112.57]:10309 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753264Ab3HPWcN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Aug 2013 18:32:13 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:51442 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VAQMn-003bsA-8p
	for linux-btrfs@vger.kernel.org; Fri, 16 Aug 2013 14:11:25 -0600
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: How btrfs resize should work ?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <F668151D-F261-4093-9E6F-A7F7A3F10EF4@colorremedies.com>
Date: Fri, 16 Aug 2013 14:11:23 -0600
Message-Id: <36466B86-DD77-48D2-8C37-CF9988D9088A@colorremedies.com>
References: <alpine.LFD.2.00.1308161011160.1968@localhost.localdomain> <20130816163039.GK12314@lenny.home.zabbo.net> <F668151D-F261-4093-9E6F-A7F7A3F10EF4@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 16, 2013, at 12:02 PM, Chris Murphy <lists@colorremedies.com> wrote:

> When a Btrfs multiple device volume is shrunk resized, it directly affects the partition size…

Oops, this obviously happens with single or multiple device.

I also think the command needs to return some information about exactly where the end of the file system is, maybe in file system blocks? resize2fs states the number of fs blocks in the fs, after a resize. From that I can figure out the exact ending LBA needed when changing the partition table. Btrfs leaves me totally guessing what this value should be.


Chris Murphy

