Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:58838 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaK1Eiy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Nov 2014 23:38:54 -0500
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Subject: Re: Balance and RAID-1
Date: Fri, 28 Nov 2014 15:38:48 +1100
Cc: linux-btrfs@vger.kernel.org
References: <201411280137.51086.russell@coker.com.au> <20141127151720.GW17395@hungrycats.org>
In-Reply-To: <20141127151720.GW17395@hungrycats.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201411281538.48565.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 28 Nov 2014, Zygo Blaxell <ce3g8jdj@umail.furryterror.org> wrote:
> On Fri, Nov 28, 2014 at 01:37:50AM +1100, Russell Coker wrote:
> > I had a RAID-1 filesystem with 2*3TB disks and 330G of disk space free 
> > according to df -h.  I replaced a 3TB disk with a 4TB disk and df
> > reported no  change in the free space (as expected).
> 
> Did you btrfs resize that 4TB disk?  If not, btrfs still thinks the 4TB
> disk is a 3TB disk, and the rest follows from that.

Thanks, you are correct I had missed that step.

It would be nice if the replace command would inform the user of the amount of 
space.  Something like "the new device is 1000GB larger than the old, you 
might want to resize".

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
