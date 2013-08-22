Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:44934 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab3HVSrN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Aug 2013 14:47:13 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 6C6787C041B
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Aug 2013 12:47:12 -0600 (MDT)
Date: Thu, 22 Aug 2013 14:47:10 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: Samba strict allocate  = yes stops btrfs compression working
Message-ID: <20130822184710.GB29654@localhost.localdomain>
References: <loom.20130822T115349-248@post.gmane.org>
 <20130822140752.GO3990@localhost.localdomain>
 <6t1iea-qg7.ln1@hurikhan77.spdns.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <6t1iea-qg7.ln1@hurikhan77.spdns.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 22, 2013 at 08:29:26PM +0200, Kai Krakow wrote:
> Josef Bacik <jbacik@fusionio.com> schrieb:
> 
> > Not sure what strict allocate = yes does, but I assume it probably does
> > fallocate() in which case yeah we aren't going to compress, we'll just
> > write
> > into the preallocated space.  We don't support compressed writes into
> > preallocated space ATM, and I'm not sure we ever will.  Thanks,
> 
> Good to know, this renders btrfs as efficient storage backend for Windows 
> file shares pretty useless. Does this also happen with compress-force?
> 

Yeah the check is done in the same function, basically it goes

if (prealloc)
	do prealloc
else if (compress && (!inode->no_compress || compress_force))
	do compress
else
	do normal cow

> As a work-around one could write a cronjob that regularly defrags all files 
> changed since the last run with -c option...
> 

Yeah basically.  The other option is to just not do strict allocate = yes.  Now
if it's _not_ doing prealloc then there's probably a problem somewhere, but I
assume that is what its doing.  Thanks,

Josef
