Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38347 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbbDTJs7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 05:48:59 -0400
Date: Mon, 20 Apr 2015 02:48:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: NeilBrown <neilb@suse.de>, Chris Mason <clm@fb.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: set FS_SUPPORTS_SEEK_HOLE flag.
Message-ID: <20150420094855.GA21116@infradead.org>
References: <20150420193347.29378d69@notabene.brown>
 <20150420052752.26554.13596.stgit@notabene.brown>
 <20150420052558.26554.97143.stgit@notabene.brown>
 <30419.1429519662@warthog.procyon.org.uk>
 <31824.1429523209@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <31824.1429523209@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 20, 2015 at 10:46:49AM +0100, David Howells wrote:
> NeilBrown <neilb@suse.de> wrote:
> 
> > Missing patch 2 of the 3-patch series?
> 
> Yes. :-)
> 
> Do ext4 and xfs support this, do you know?

Yes.  As do f2fs, ocfs2, gfs2, ceph and NFSv4.2

> 
> David
---end quoted text---
