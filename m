Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48514 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750805AbdEERiT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 May 2017 13:38:19 -0400
Date: Fri, 5 May 2017 19:38:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz
Subject: Re: [PATCH v3] btrfs: fiemap: Cache and merge fiemap extent before
 submit it to user
Message-ID: <20170505173811.GJ10575@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170407024315.30685-1-quwenruo@cn.fujitsu.com>
 <20170420012509.GB15096@lim.localdomain>
 <98ab28d8-7ab6-0d2d-92d6-38b78e572d39@cn.fujitsu.com>
 <20170420015844.GC15096@lim.localdomain>
 <bc1d9076-1dba-babf-1703-af88c000b5be@cn.fujitsu.com>
 <20170420195255.GA32370@lim.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170420195255.GA32370@lim.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 20, 2017 at 12:52:55PM -0700, Liu Bo wrote:
> On Thu, Apr 20, 2017 at 10:09:39AM +0800, Qu Wenruo wrote:
> > 
> > 
> > At 04/20/2017 09:58 AM, Liu Bo wrote:
> > > On Thu, Apr 20, 2017 at 09:52:00AM +0800, Qu Wenruo wrote:
> > > > 
> > > > 
> [...]
> > > > > 
> > > > > If I understand it correctly, what it's missing currently is 'merge', a
> > > > > straightfoward idea is to make use of the 'merge' ability of btrfs_get_extent. >
> > > > > Since btrfs_get_extent_fiemap is a wrapper of btrfs_get_extent, does it make
> > > > > sense if we make btrfs_get_extent_fiemap iterate all extent maps within the
> > > > > range passing to it or just one more extent map to check if btrfs_get_extent
> > > > > could return a merged extent map before returning?
> > > > 
> > > > So your idea to to do the merging inside btrfs_get_extent(), instead of
> > > > merging it in extent_fiemap()?
> > > > 
> > > 
> > > No, merge ems inside the wrapper, ie. btrfs_get_extent_fiemap().
> > 
> > Then llseek() with SEEK_HOLE/SEEK_DATA also get affected.
> > 
> > So limiting the extra time to merging extent maps in fiemap is still valid.
> >
> 
> Per my test, the v3 patch doesn't make big difference on the side of
> performance.

I think the point was not to improve performance, but to make the fiemap
output correct. But anyway it's good that the performance does not degrade.
