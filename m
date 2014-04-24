Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:40951 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752202AbaDXDXC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 23:23:02 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:52986 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WdAFZ-003aMn-LI
	for linux-btrfs@vger.kernel.org; Wed, 23 Apr 2014 21:23:01 -0600
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or newer?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info>
Date: Wed, 23 Apr 2014 21:23:00 -0600
Message-Id: <1B72A2CD-1F52-459C-B9AE-639B6937AC0F@colorremedies.com>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It sounds like either a grub.cfg misconfiguration, or a failure to correctly build the initrd/initramfs. So I'd post the grub.cfg kernel command line for the boot entry that works and the entry that fails, for comparison.

And then also check and see if whatever utility builds your initrd has been upgraded along with your kernel, maybe there's a bug/regression.

Chris Murphy