Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40952 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab3LJOR4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Dec 2013 09:17:56 -0500
Date: Tue, 10 Dec 2013 22:17:44 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: avoid building inode cache repeatly
Message-ID: <20131210141743.GA20665@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1386581671-4639-1-git-send-email-bo.li.liu@oracle.com>
 <20131209142005.20371.31891@ret.masoncoding.com>
 <20131210084733.GA8913@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131210084733.GA8913@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 10, 2013 at 04:51:41PM +0800, Liu Bo wrote:
> On Mon, Dec 09, 2013 at 09:20:05AM -0500, Chris Mason wrote:
> > Quoting Liu Bo (2013-12-09 04:34:31)
> > > Inode cache is similar to free space cache and in fact shares the same
> > > code, however, we don't load inode cache unless we're about to allocate
> > > inode id, then there is a case where we only commit the transaction during
> > > other operations, such as snapshot creation, we now update fs roots' generation
> > > to the new transaction id, after that when we want to load the inode cache,
> > > we'll find that it's not valid thanks to the mismatch of generation, and we
> > > have to push btrfs-ino-cache thread to build inode cache from disk, and
> > > this operation is sometimes time-costing.
> > > 
> > > So to fix the above, we load inode cache into memory during reading fs root.
> > 
> > Thanks Liu.  Have you tested this with orphan replay?  I'd like to make
> > sure the new ordering of starting caching isn't causing problems with
> > finding and processing the orphan items.
> 
> I hacked the code with the following change in order to test orphan
> replay with inode cache enabled, it's ok on my side on mounting and
> using, I'll make some tests to make sure xfstests is ok, too.

Oops, xfstests/btrfs/012 complains with a 'general protection", I need to look into that.

-liubo
