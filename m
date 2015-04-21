Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33221 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbbDUKXw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Apr 2015 06:23:52 -0400
Received: by paboj16 with SMTP id oj16so236996556pab.0
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Apr 2015 03:23:52 -0700 (PDT)
Date: Tue, 21 Apr 2015 03:23:42 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: NeilBrown <neilb@suse.de>
cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: set FS_SUPPORTS_SEEK_HOLE flag.
In-Reply-To: <20150421084312.GA1088@infradead.org>
Message-ID: <alpine.LSU.2.11.1504210319440.1535@eggly.anvils>
References: <20150420193347.29378d69@notabene.brown> <20150420052752.26554.13596.stgit@notabene.brown> <20150420052558.26554.97143.stgit@notabene.brown> <30419.1429519662@warthog.procyon.org.uk> <31824.1429523209@warthog.procyon.org.uk> <20150420094855.GA21116@infradead.org>
 <20150420125835.GJ889@ZenIV.linux.org.uk> <20150421084312.GA1088@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 21 Apr 2015, Christoph Hellwig wrote:
> On Mon, Apr 20, 2015 at 01:58:35PM +0100, Al Viro wrote:
> > > > Do ext4 and xfs support this, do you know?
> > > 
> > > Yes.  As do f2fs, ocfs2, gfs2, ceph and NFSv4.2
> > 
> > Er...  Nominally, gfs2 supports it.  By treating all files as "there's a
> > hole starting at EOF".  Same as ext2 or even minix...
> 
> Yeah remove gfs2 from the list.

But please add tmpfs to the list -
though I doubt you're interested in caching its files.

Hugh
