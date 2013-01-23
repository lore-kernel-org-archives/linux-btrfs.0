Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail35.syd.optusnet.com.au ([211.29.133.51]:56016 "EHLO
	mail35.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752616Ab3AWUe5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 15:34:57 -0500
Date: Thu, 24 Jan 2013 07:34:00 +1100
From: Skender <skender@gmail.com>
To: David Sterba <dsterba@suse.cz>
Cc: Skender <skender@gmail.com>, linux-btrfs@vger.kernel.org,
        jbacik@fusionio.com
Subject: Re: BTRFS dmesg error
Message-ID: <20130123203359.GA14478@blackspider>
References: <20130121060136.GA11275@blackspider>
 <20130121110026.GE19967@twin.jikos.cz>
 <20130121202016.GA24179@blackspider>
 <20130122141702.GC28263@twin.jikos.cz>
 <20130122214125.GA15469@blackspider>
 <20130123163004.GL28263@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130123163004.GL28263@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here you go


sudo btrfs fi df /media/Storage/
Data, RAID0: total=1.48TB, used=980.54GB
System, RAID1: total=8.00MB, used=112.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=94.00GB, used=1.45GB


sudo btrfs fi df /
Data: total=353.45GB, used=263.93GB
System, DUP: total=40.00MB, used=48.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=7.44GB, used=2.17GB
Metadata: total=8.00MB, used=0.00

Cheers,
Skender.

On 23/01/13 17:30 +0100, David Sterba wrote:
> On Wed, Jan 23, 2013 at 08:41:25AM +1100, Skender wrote:
> > The only lines the have anythinf with btrfs are as follows:
> [...]
> 
> That lacks information to analyze the error, so let's try it the usual
> way. I'm not sure if you can grab the state of free space (via
> btrfs fi df) from the time it happened, but that would at least say if
> it was the ENOSPC case.
> 
> thanks,
> david
