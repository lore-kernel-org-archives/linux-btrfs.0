Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:37179 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab3KYSbk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Nov 2013 13:31:40 -0500
Date: Mon, 25 Nov 2013 20:23:57 +0200
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Russell Coker <russell@coker.com.au>
Cc: linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: Triple parity and beyond
Message-ID: <20131125182357.GE2924@reaktio.net>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
 <528DCD36.1060808@hesbynett.no>
 <528DD86E.8040608@websitemanagers.com.au>
 <4544086.2UTvYHxkvM@russell.coker.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4544086.2UTvYHxkvM@russell.coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 22, 2013 at 07:12:39PM +1100, Russell Coker wrote:
> 
> On Thu, 21 Nov 2013 18:30:49 Stan Hoeppner wrote:
> > I suggest that anyone in the future needing fast random write IOPS is
> > going to move those workloads to SSD, which is steadily increasing in
> > capacity.  And I suggest anyone building arrays with 10-20TB drives
> > isn't in need of fast random write IOPS.
> 
> Traditionally SCSI/SAS disks have tended to be a lot smaller than IDE/SATA 
> disks.  Now Dell has just started offering 2TB SAS disks while the largest SATA 
> disks that they sell (In Australia on PowerEdge T110 servers at least) are 
> also 2TB.  Presumably RAID recovery time was one factor that made 
> manufacturers not bother with making larger SCSI/SAS disks in the past.
>

Dell has been selling 4TB SAS disks for a long time already.. one year, or something like that.

-- Pasi

