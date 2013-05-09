Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:43910 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab3EIMck (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 May 2013 08:32:40 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 4EDEB7C0427
	for <linux-btrfs@vger.kernel.org>; Thu,  9 May 2013 06:32:39 -0600 (MDT)
Date: Thu, 9 May 2013 08:32:36 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs: cleanup destroy_marked_extents
Message-ID: <20130509123236.GV12414@localhost.localdomain>
References: <20130509122206.GA997@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130509122206.GA997@elgon.mountain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 09, 2013 at 06:22:06AM -0600, Dan Carpenter wrote:
> Hello Josef Bacik,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch fd8b2b611580: "Btrfs: cleanup destroy_marked_extents" from 
> Apr 24, 2013, leads to the following Smatch complaint:
> 
> fs/btrfs/disk-io.c:3814 btrfs_destroy_marked_extents()
> 	 warn: variable dereferenced before check 'eb' (see line 3813)
> 
> fs/btrfs/disk-io.c
>   3812							   root->leafsize);
>   3813				start += eb->len;
>                                          ^^^^^^^
> New dereference.
>   3814				if (!eb)
>                                     ^^^
> New check.  Maybe we should be adding "root->leafsize" here?  Just
> the check earlier would cause a forever loop.
> 
>   3815					continue;
>   3816				wait_on_extent_buffer_writeback(eb);
> 

Yeah I sent a patch for it yesterday, just me being an idiot, nothing to see
here,

Josef
