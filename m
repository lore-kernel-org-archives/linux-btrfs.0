Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:51705 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756486AbaIOUy7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 16:54:59 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:51008 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XTdIY-003BM2-Oc
	for linux-btrfs@vger.kernel.org; Mon, 15 Sep 2014 14:54:58 -0600
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs balance enospc
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <541723EA.6010608@intellasoft.net>
Date: Mon, 15 Sep 2014 14:54:57 -0600
Message-Id: <657EBB8A-8957-4E07-829E-171A1FF702E8@colorremedies.com>
References: <541706ED.4010901@intellasoft.net> <20140915170722.GA9160@sune> <541723EA.6010608@intellasoft.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 15, 2014, at 11:37 AM, Mark Murawski <markm-lists@intellasoft.net> wrote:

> btrfs balance start -dusage=86 /
> Done, had to relocate 1 out of 13 chunks
> 
> cartman {~} root# btrfs fi df /
> Data, RAID1: total=7.03GiB, used=7.01GiB
> System, RAID1: total=32.00MiB, used=4.00KiB
> Metadata, RAID1: total=1.00GiB, used=438.88MiB
> unknown, single: total=148.00MiB, used=0.00
> 
> What's this 'unknown' section? Maybe this is the problem?  How do I get rid of it?

It's not a problem, it's cosmetic for now, something introduced in kernel 3.15 but progs doesn't yet give a label for.

> 
> I still get enospc after a balance with a filter, and then a regular balance:
> 
> cartman {~} root# btrfs balance start /
> ERROR: error during balancing '/' - No space left on device

Maybe try mount option enospc_debug and retry, see if you get more information in dmesg.

I'm not sure if a balance in this case wants to create a new data and metadata chunk (on each device), or if it can start without creating any chunks. If it wants to create new chunks, it's 1GiB for data, and 256MiB for metadata. That's 1.256GiB but you only have 1.25GiB unallocated on each device: size 9.31GiB minus used 8.06GiB.


Chris Murphy