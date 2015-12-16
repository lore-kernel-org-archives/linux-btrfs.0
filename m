Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57666 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752555AbbLPO2D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Dec 2015 09:28:03 -0500
Date: Wed, 16 Dec 2015 09:27:27 -0500
From: Chris Mason <clm@fb.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Martin Steigerwald <martin@lichtvoll.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Still not production ready
Message-ID: <20151216142727.GD6322@ret.masoncoding.com>
References: <8336788.myI8ELqtIK@merkaba>
 <566E2490.8080905@cn.fujitsu.com>
 <20151215215958.GC6322@ret.masoncoding.com>
 <5670BC6D.1010906@cn.fujitsu.com>
 <20151216015313.GB11024@localhost.localdomain>
 <5670CA14.9090908@cn.fujitsu.com>
 <20151216023057.GC11024@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20151216023057.GC11024@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 15, 2015 at 06:30:58PM -0800, Liu Bo wrote:
> On Wed, Dec 16, 2015 at 10:19:00AM +0800, Qu Wenruo wrote:
> > >max_stripe_size is fixed at 1GB and the chunk size is stripe_size * data_stripes,
> > >may I know how your partition gets a 10GB chunk?
> > 
> > Oh, it seems that I remembered the wrong size.
> > After checking the code, yes you're right.
> > A stripe won't be larger than 1G, so my assumption above is totally wrong.
> > 
> > And the problem is not in the 10% limit.
> > 
> > Please forget it.
> 
> No problem, glad to see people talking about the space issue again.

You can still end up with larger block groups if you have a lot of
drives.  We've had different problems with that in the past, but it is
limited now to 10G.

At any rate if things are still getting badly out of balance we need to
tweak the allocator some more.

It's hard to reproduce because you need a burst of allocations for
whatever type is full.  I'll give it another shot.

-chris

