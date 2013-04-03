Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762162Ab3DCRMb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Apr 2013 13:12:31 -0400
Date: Wed, 3 Apr 2013 19:12:27 +0200
From: David Sterba <dsterba@suse.cz>
To: kreijack@inwind.it
Cc: Anand Jain <Anand.Jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [bug] btrfs fi df doesn't show raid type after balance
Message-ID: <20130403171227.GC18365@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <515BCAB5.30403@oracle.com>
 <515C5FB0.2060106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <515C5FB0.2060106@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 03, 2013 at 06:58:24PM +0200, Goffredo Baroncelli wrote:
> On 04/03/2013 08:22 AM, Anand Jain wrote:
> > Did something break.. ? we are not reporting raid type after balance.

fi df reports exactly what is on the filesystem.

> > -----------
> > # btrfs fi df /btrfs
> > Data, RAID0: total=2.00GB, used=2.03MB
> > Data: total=8.00MB, used=0.00
> > System, RAID0: total=16.00MB, used=4.00KB
> > System: total=4.00MB, used=0.00
> > Metadata, RAID0: total=2.00GB, used=216.00KB
> > Metadata: total=8.00MB, used=4.00KB
> > 
> > # btrfs bal /btrfs
> > Done, had to relocate 5 out of 5 chunks
> > 
> > # btrfs fi df /btrfs
> > Data: total=1.00GB, used=2.78MB
> > System: total=4.00MB, used=4.00KB
> > Metadata: total=1.00GB, used=276.00KB
> > #
> > -----------
> > 
> > btrfs-progs is at integration-20130321 and 3.8.0+
> 
> I already saw this. When the filesystem is empty a balance revert the
> RAID mode to the single one. If the filesystem is not empty I was not
> able to reproduce this.

Any unused raid profile is thrown away after full balance (except
system/single if it is there), because balance is currently implemented
that way. It does not check if there is a preferred allocation profile
to keep even if it is empty. The single profile is default and is
automatically picked after new data are being written.

I've seen this after creating a multi-device fs with raid0/1/10
profiles, filled with data, removed everyting, ran balance to unallocate
the blockgroups and found data group missing. I don't have an
explanation why the raid0 profiles got merged into the single profiles
in Anand's example.


david
