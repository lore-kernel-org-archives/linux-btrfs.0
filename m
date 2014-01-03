Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:60703 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753470AbaACXTb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 18:19:31 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:62125 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1VzE1a-002D7m-B1
	for linux-btrfs@vger.kernel.org; Fri, 03 Jan 2014 16:19:31 -0700
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52C7402A.7050605@jrs-s.net>
Date: Fri, 3 Jan 2014 16:19:28 -0700
Message-Id: <6B38F270-2030-4206-A61E-0EE14B5E5E81@colorremedies.com>
References: <52C73987.7000106@jrs-s.net> <52C73D1A.8060805@gmail.com> <52C7402A.7050605@jrs-s.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 3, 2014, at 3:56 PM, Jim Salter <jim@jrs-s.net> wrote:

> I actually read the wiki pretty obsessively before blasting the list - could not successfully find anything answering the question, by scanning the FAQ or by Googling.
> 
> You're right - mount -t btrfs -o degraded /dev/vdb /test worked fine.
> 
> HOWEVER - this won't allow a root filesystem to mount. How do you deal with this if you'd set up a btrfs-raid1 or btrfs-raid10 as your root filesystem? 

I'd say that it's not ready for unattended/auto degraded mounting, that this is intended to be a red flag show stopper to get the attention of the user. Before automatic degraded mounts, which md and LVM raid do now, there probably needs to be notification support in desktop's, .e.g. Gnome will report degraded state for at least md arrays (maybe LVM too, not sure). There's also a list of other multiple device stuff on the to do, some of which maybe should be done before auto degraded mount, for example the hot spare work.

https://btrfs.wiki.kernel.org/index.php/Project_ideas#Multiple_Devices


Chris Murphy