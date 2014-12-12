Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:41047 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757702AbaLLBAj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 20:00:39 -0500
From: Russell Coker <russell@coker.com.au>
To: Robert White <rwhite@pobox.com>
Reply-To: russell@coker.com.au
Cc: "sys.syphus" <syssyphus@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Balance & scrub & defrag
Date: Fri, 12 Dec 2014 12:00:34 +1100
Message-ID: <44336672.dmUL7ANCyf@russell.coker.com.au>
In-Reply-To: <5488F0A8.7070503@pobox.com>
References: <CAAe=sHWSR=G0+hJCbLCQfgBB_b9VQxu2Q8JETMuRgz79fcBUbg@mail.gmail.com> <5488F0A8.7070503@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 10 Dec 2014 17:17:28 Robert White wrote:
> A _monthly_ scrub is maybe worth scheduling if you have a lot of churn 
> in your disk contents.

I do weekly scrubs.  I recently had 2 disks in a RAID-1 array develop read 
errors within a month of each other.  The first scrub after replacing sdb 
revealed an error on sdc!

> Defragging should be done after significant content additions/changes 
> (like replacing a lot of files via package management) and limited to 
> the directories most likely changed.

I have never run defrag.  Currently all my BTRFS filesystems that have any 
performance requirements are on SSD and I don't think that defragmenting a SSD 
does much good.

> Balancing is almost never necessary and can be anti-helpful if a 
> experiences random updates in batches (because the nicely packed file 
> may end up far, far away from the active data extent where its COW 
> events are taking place.

The problem with running out of metadata space requires a need for an 
occasional data balance.  If you set it to only balance chunks that are less 
than 10% used then it doesn't take much time.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

