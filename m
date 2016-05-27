Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36983 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbcE0LPr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 May 2016 07:15:47 -0400
Date: Fri, 27 May 2016 13:15:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs-progs: make convert to allocate space from the
 desired type of block group
Message-ID: <20160527111511.GU29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1464312410-10999-1-git-send-email-bo.li.liu@oracle.com>
 <7cdcb731-ef9a-a967-0218-31476d40c8d3@cn.fujitsu.com>
 <20160527105502.GT29147@twin.jikos.cz>
 <357a411f-e4b5-0f1d-5ee9-6074acdd5b87@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <357a411f-e4b5-0f1d-5ee9-6074acdd5b87@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 27, 2016 at 07:04:42PM +0800, Qu Wenruo wrote:
> > The plan is to release 4.6 with this patchset, I'm still not decided
> > about the low-mem mode for checker.
> 
> For low memory mode, at least we're not that eager to see it merged into 
> 4.6.

I still need to test it on some large filesystems.

> Although if it could be merged, it would make us free from rebasing it 
> again and again.

As it's in devel now, it's on me to rebase and refresh it. It's going to
stay here, a release branch is usually a set of cherry-picked patches
from devel.
