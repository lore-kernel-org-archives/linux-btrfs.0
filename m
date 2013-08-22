Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:41681 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab3HVOHy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Aug 2013 10:07:54 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 5F89F7C0693
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Aug 2013 08:07:54 -0600 (MDT)
Date: Thu, 22 Aug 2013 10:07:52 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Mark Ridley <mark@backupsystems.co.uk>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: Samba strict allocate  = yes stops btrfs compression working
Message-ID: <20130822140752.GO3990@localhost.localdomain>
References: <loom.20130822T115349-248@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <loom.20130822T115349-248@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 22, 2013 at 09:57:24AM +0000, Mark Ridley wrote:
> Hi,
> 
> If i set strict allocate = yes in samba to speed up the transfer
> of a mssql database dump,
> then btrfs does not compress the file. 
> I have tried it also by just copying a small file in Windows to the 
> samba share and the same.
> I have tried btrfs mount options autodefrag and then
>  btrfs fi defrag -c and the file still does not get compressed.
> 
> I have tried kernels 3.6.11, 3.8 and 3.10.7 on FC16 and FC18.
> 
> Any help, much appreciated. 
>

Not sure what strict allocate = yes does, but I assume it probably does
fallocate() in which case yeah we aren't going to compress, we'll just write
into the preallocated space.  We don't support compressed writes into
preallocated space ATM, and I'm not sure we ever will.  Thanks,

Josef 
