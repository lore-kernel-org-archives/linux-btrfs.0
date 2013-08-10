Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:41083 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933901Ab3HJOi1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Aug 2013 10:38:27 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:58750 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1V8AJE-002vjm-Fh
	for linux-btrfs@vger.kernel.org; Sat, 10 Aug 2013 08:38:24 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Error relating to /dev/sr0 when calling btrfs fi show /dev/sdxy
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130810095922.206170@gmx.com>
Date: Sat, 10 Aug 2013 08:38:26 -0600
Message-Id: <44CB3A36-5FC9-4E57-9D38-D8945761EED4@colorremedies.com>
References: <20130810095922.206170@gmx.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 10, 2013, at 3:59 AM, "Mike Audia" <mikey_a@gmx.com> wrote:

> Is the error relating to /dev/sr0 relevant to a call to /usr/bin/brtfs?  Why does it show the superfluous output?
> 
> % sudo btrfs fi show /dev/sda3
> failed to open /dev/sr0: No medium found

I get this on Virtual Box VMs, also with parted. I don't get it with parted or btrfs on baremetal.

Chris Murphy