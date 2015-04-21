Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40155 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbbDUInU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Apr 2015 04:43:20 -0400
Date: Tue, 21 Apr 2015 01:43:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>,
        NeilBrown <neilb@suse.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: set FS_SUPPORTS_SEEK_HOLE flag.
Message-ID: <20150421084312.GA1088@infradead.org>
References: <20150420193347.29378d69@notabene.brown>
 <20150420052752.26554.13596.stgit@notabene.brown>
 <20150420052558.26554.97143.stgit@notabene.brown>
 <30419.1429519662@warthog.procyon.org.uk>
 <31824.1429523209@warthog.procyon.org.uk>
 <20150420094855.GA21116@infradead.org>
 <20150420125835.GJ889@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150420125835.GJ889@ZenIV.linux.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 20, 2015 at 01:58:35PM +0100, Al Viro wrote:
> > > Do ext4 and xfs support this, do you know?
> > 
> > Yes.  As do f2fs, ocfs2, gfs2, ceph and NFSv4.2
> 
> Er...  Nominally, gfs2 supports it.  By treating all files as "there's a
> hole starting at EOF".  Same as ext2 or even minix...

Yeah remove gfs2 from the list.
