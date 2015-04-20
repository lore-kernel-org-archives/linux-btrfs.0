Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:34105 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577AbbDTM6q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 08:58:46 -0400
Date: Mon, 20 Apr 2015 13:58:35 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: David Howells <dhowells@redhat.com>, NeilBrown <neilb@suse.de>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: set FS_SUPPORTS_SEEK_HOLE flag.
Message-ID: <20150420125835.GJ889@ZenIV.linux.org.uk>
References: <20150420193347.29378d69@notabene.brown>
 <20150420052752.26554.13596.stgit@notabene.brown>
 <20150420052558.26554.97143.stgit@notabene.brown>
 <30419.1429519662@warthog.procyon.org.uk>
 <31824.1429523209@warthog.procyon.org.uk>
 <20150420094855.GA21116@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150420094855.GA21116@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 20, 2015 at 02:48:55AM -0700, Christoph Hellwig wrote:
> On Mon, Apr 20, 2015 at 10:46:49AM +0100, David Howells wrote:
> > NeilBrown <neilb@suse.de> wrote:
> > 
> > > Missing patch 2 of the 3-patch series?
> > 
> > Yes. :-)
> > 
> > Do ext4 and xfs support this, do you know?
> 
> Yes.  As do f2fs, ocfs2, gfs2, ceph and NFSv4.2

Er...  Nominally, gfs2 supports it.  By treating all files as "there's a
hole starting at EOF".  Same as ext2 or even minix...
