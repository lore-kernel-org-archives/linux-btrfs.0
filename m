Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47480 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964843AbbI2M0W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 08:26:22 -0400
Date: Tue, 29 Sep 2015 14:25:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Ferry Toth <ftoth@exalondelft.nl>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Excessive slab use deteriorates performance
Message-ID: <20150929122522.GY11442@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <mu61ah$iaa$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <mu61ah$iaa$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 26, 2015 at 01:59:13PM +0200, Ferry Toth wrote:
> Could there be any relation to btrfs causing the mentioned slabs to not be 
> automatically freeed?
> 
> In the mean time we put:
> vfs_cache_pressure = 10000 
> 
> And this seems to be keeping slabs total at 2.5GB (with btrfs_inode at 
> 1.7GB).
> 
> Still, manually doing drop_caches, will reduce slabs total to 0.4GB, with 
> btrfs_inode at 0.01GB.
> 
> I'm not sure, but just having a RO operation scanning all files on the disk 
> causing kernel memory to be used to cache things that are almost not used 12 
> hours later, while keeping more useful file caches from growing, seems not 
> really optimal.
> 
> Has anybody else seen this behavior?

Yes, a friend showed me almost identical situtation some time ago. Slab
caches full, not reclaimed and dropping caches "fixed" that, likely
caused by overnight cron jobs. At that time I was interested whether it
was a leak but if the slab usage dropped and did not debug it further.

The sysctl vfs_cache_pressure should help to tune the system. The btrfs
allocates slabs with the "reclaimable" flag on so there should not be
any direct obstacle for that so there must be something else going on.
