Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49082 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbcCCKDB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Mar 2016 05:03:01 -0500
Date: Thu, 3 Mar 2016 11:02:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, sri <toyours_sridhar@yahoo.co.in>,
        linux-btrfs@vger.kernel.org
Subject: Re: how many chunk trees and extent trees present
Message-ID: <20160303100244.GE29310@suse.cz>
Reply-To: dsterba@suse.cz
References: <loom.20150417T081705-332@post.gmane.org>
 <20150417091911.GK22084@carfax.org.uk>
 <20150417172928.GT25622@twin.jikos.cz>
 <56CFAA79.9020706@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56CFAA79.9020706@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 26, 2016 at 09:29:29AM +0800, Qu Wenruo wrote:
> 
> 
> David Sterba wrote on 2015/04/17 19:29 +0200:
> > On Fri, Apr 17, 2015 at 09:19:11AM +0000, Hugo Mills wrote:
> >>> In, some article i read that future there will be more chunk tree/ extent
> >>> tree for single btrfs. Is this true.
> >>
> >>     I recall, many moons ago, Chris saying that there probably wouldn't
> >> be.
> >
> > More extent trees tied to a set of fs trees/subvolumes would be very
> > useful for certain usecases *cough*encryption*cough*.
> 
> BTW, will such design makes reflink between different set of extents 
> fallback to normal copy?

Yes, the actual reflink will not be possible.

> And I'm pretty sure that inband dedup will be affected too...

Yes.
