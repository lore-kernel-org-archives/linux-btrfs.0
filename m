Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:39321 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758593Ab3KJExO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Nov 2013 23:53:14 -0500
Received: from c-68-35-30-169.hsd1.nm.comcast.net ([68.35.30.169]:47789 helo=[10.0.1.23])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VfN1N-000EX1-0H
	for linux-btrfs@vger.kernel.org; Sat, 09 Nov 2013 21:53:13 -0700
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Btrfs might be gradually slowing the boot process
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <72h1la-adf.ln1@hurikhan77.spdns.de>
Date: Sat, 9 Nov 2013 21:53:10 -0700
Message-Id: <04B39B7F-24A2-42E0-8C4A-31D710A844E6@colorremedies.com>
References: <527d2ee689e077.81319728@wp.pl> <72h1la-adf.ln1@hurikhan77.spdns.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What's leafsize was used when making the file system? The default is now (as of yesterday) 16KB to avoid metadata fragmentation.


Chris Murphy