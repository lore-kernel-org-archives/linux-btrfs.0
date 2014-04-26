Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:37959 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaDZC4H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 22:56:07 -0400
Date: Fri, 25 Apr 2014 20:56:06 -0600 (MDT)
From: Steve Leung <sjleung@shaw.ca>
To: Chris Murphy <lists@colorremedies.com>
cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: safe/necessary to balance system chunks?
In-Reply-To: <7336D5A2-5CDD-45A4-9D43-E94F1C451137@colorremedies.com>
Message-ID: <alpine.DEB.2.10.1404252035150.4873@cubia.leung>
References: <alpine.DEB.2.10.1404250842350.2320@cubia.leung> <75D8579E-1284-4F12-A573-15D50EFC4614@colorremedies.com> <535AA581.1080301@gmail.com> <535AACC0.2000600@shaw.ca> <7336D5A2-5CDD-45A4-9D43-E94F1C451137@colorremedies.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 25 Apr 2014, Chris Murphy wrote:

> On Apr 25, 2014, at 12:43 PM, Steve Leung <sjleung@shaw.ca> wrote:
>> Once everything gets rebalanced though, I don't think I'd be missing out on any features, would I?

> The default nodesize/leafsize is 16KB since btrfs-progs v3.12. This 
> isn't changed with a balance. The difference between the previous 
> default 4KB, and 16KB is performance and small file efficiency.

Ah, now it's coming back to me.  The last major gyration I had on this 
filesystem (and the ultimate trigger for my original issue) was juggling 
everything around so that I could reformat for the 16kB node size.

Incidentally, is there a way for someone to tell what the node size 
currently is for a btrfs filesystem?  I never noticed that info printed 
anywhere from any of the btrfs utilities.

In case anyone's wondering, I did balance the system chunks on my 
filesystem and "btrfs fi df" now looks normal.  So thanks to all for the 
hints and advice.

Steve
