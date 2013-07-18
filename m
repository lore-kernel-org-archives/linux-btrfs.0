Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:50953 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427Ab3GRQdo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jul 2013 12:33:44 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 2FC639A06B3
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Jul 2013 10:33:44 -0600 (MDT)
Date: Thu, 18 Jul 2013 12:33:42 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Hugo Mills <hugo@carfax.org.uk>, Sandy McArthur <sandymac@gmail.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: bug: corrupt filesystem, cannot delete tmp files created just
 before crash.
Message-ID: <20130718163342.GB2322@localhost.localdomain>
References: <pan$8addd$a853ed60$657c1f02$89661ea8@cox.net>
 <CAPs0Bijykq=HQAz3fnmh053a7iqsC93cbKGjXc9dP4-Z-V3Tiw@mail.gmail.com>
 <CAPs0BihLvfdo2inUyM574tA-DQ2TH2SyvdUaGnuFu=V=SU+Kwg@mail.gmail.com>
 <20130718152128.GB20517@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130718152128.GB20517@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 18, 2013 at 04:21:28PM +0100, Hugo Mills wrote:
> On Thu, Jul 18, 2013 at 11:11:03AM -0400, Sandy McArthur wrote:
> > Should I interpret the different used amounts (902.01GB vs 902.03GB)
> > on my recovered RAID1 filesystem as that not all data is actually
> > mirrored and so I should run a balance? The devices in the filesystem
> > below are the same make/model drives.
> > 
> > # btrfs fi show
> > Label: 'mcmedia'  uuid: 92b3345e-2589-423c-a228-d569bf94ab58
> > Total devices 2 FS bytes used 905.33GB
> > devid    2 size 2.73TB used 902.01GB path /dev/sdc1
> > devid    1 size 2.73TB used 902.03GB path /dev/sdb1
> > 
> > Btrfs v0.20-rc1-358-g194aa4a
> > 
> > # btrfs fi df /mnt/media/
> > Data, RAID1: total=894.00GB, used=892.99GB
> > Data: total=12.01GB, used=11.56GB
> 
>               ^^^^^^^ This is unmirrored data.
> 
> # btrfs balance start -dconvert=raid1,soft /mountpoint
> 
> is the incantation you need: convert your data to RAID-1, and ignore
> anything which has already been converted.
> 

Build btrfs-next and boot into that first if you can before you do this as there
is a slight bug with balance that will corrupt data if you crash.  Thanks,

Josef
