Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:44342 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751215AbaHJVBq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Aug 2014 17:01:46 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49247 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XGaFN-001mUh-DV
	for linux-btrfs@vger.kernel.org; Sun, 10 Aug 2014 15:01:45 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [BUG] btrfs send/receive, page allocation failure
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <2BBB0EBF-DD55-45B4-8BF5-F8DAA9398A4F@colorremedies.com>
Date: Sun, 10 Aug 2014 15:01:44 -0600
Message-Id: <CF539008-5930-447D-B26C-2A2BBE9337EA@colorremedies.com>
References: <2BBB0EBF-DD55-45B4-8BF5-F8DAA9398A4F@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 7, 2014, at 9:31 AM, Chris Murphy <lists@colorremedies.com> wrote:

> # btrfs send /mnt/320G/2012april_HDD_fullbackup.ro.0/ | btrfs receive /mnt/500G/
> At subvol /mnt/320G/2012april_HDD_fullbackup.ro.0/
> At subvol 2012april_HDD_fullbackup.ro.0
> ERROR: send ioctl failed with -12: Cannot allocate memory
> ERROR: unexpected EOF in stream.
> 
> 
> kernel-3.16.0-1.fc21.x86_64
> btrfs-progs-3.14.2-3.fc21.x86_64
> 
> 
> Both the source and destination were recently (< 24 hours) created with the above versions.
> 
> Bug report here:
> https://bugzilla.kernel.org/show_bug.cgi?id=81781
> 
> dmesg excerpt with debug kernel here:
> https://bugzilla.kernel.org/attachment.cgi?id=145331

This isn't reproducible by only changing kernels to 3.14.15-100.fc19.x86_64, so it's a regression in 3.16. What's also interesting is the performance is much worse with 3.14 compared to 3.16. I get ~8.3MB/s with 3.14, and ~21.8MB/s with 3.16; all other factors are identical.


Chris Murphy