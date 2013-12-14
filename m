Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:13570 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751568Ab3LNVfP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Dec 2013 16:35:15 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Blocket for more than 120 seconds
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAD_cGvFdrhwC2erqYTMjPRG7Y=69tsT2O+S-GHYK7+wpBwFSFQ@mail.gmail.com>
Date: Sat, 14 Dec 2013 14:35:11 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <46A0D70E-99DF-46FE-A4E8-71E9AC45129F@colorremedies.com>
References: <CAD_cGvFdrhwC2erqYTMjPRG7Y=69tsT2O+S-GHYK7+wpBwFSFQ@mail.gmail.com>
To: Hans-Kristian Bakke <hkbakke@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 14, 2013, at 1:30 PM, Hans-Kristian Bakke <hkbakke@gmail.com> wrote:
> 
> During high disk loads, like backups combinded with lot of writers,
> rsync at high speed locally or btrfs defrag I always get these
> messages, and everything grinds to a halt on the btrfs filesystem:
> 
> [ 3123.062229] INFO: task rtorrent:8431 blocked for more than 120 seconds
> [ 3123.062251]       Not tainted 3.12.4 #1

On blocks, if this is an unknown problem, often devs will want to see dmesg after you've issued dmesg -n7 and sysrq+w. More on sysrq triggering is here:
https://www.kernel.org/doc/Documentation/sysrq.txt

> The filesystem have used about 26TB of the available 29TB (real
> available data), and some of the files on it are heavily fragmented
> (around 100 000 extents at about 25GB)

Please include results from btrfs fi show, and btrfs fi df <mp>.


Chris Murphy