Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34451 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbcE0Kzh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 May 2016 06:55:37 -0400
Date: Fri, 27 May 2016 12:55:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz
Subject: Re: [PATCH 1/2] Btrfs-progs: make convert to allocate space from the
 desired type of block group
Message-ID: <20160527105502.GT29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1464312410-10999-1-git-send-email-bo.li.liu@oracle.com>
 <7cdcb731-ef9a-a967-0218-31476d40c8d3@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7cdcb731-ef9a-a967-0218-31476d40c8d3@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 27, 2016 at 09:38:09AM +0800, Qu Wenruo wrote:
> Since btrfs-convert has been reworked to use a completely new method to 
> do such allocation, now it doesn't need any custom_alloc_extent() function.
> 
> And its new chunk lay out is designed to only put metadata chunk into 
> large enough unused space, and data chunks will cover all used space.
> 
> So there is no need for such patch AFAIK.

I agree, and I think that the motivation for the convert rewrite was the
same problem that these patches address.

> And the new convert is already in devel branch.

The plan is to release 4.6 with this patchset, I'm still not decided
about the low-mem mode for checker.
