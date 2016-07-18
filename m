Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52458 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbcGRDux (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jul 2016 23:50:53 -0400
Date: Sun, 17 Jul 2016 20:50:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mike Christie <mchristi@redhat.com>
Cc: Vincent Stehl?? <vincent.stehle@intel.com>, linux-btrfs@vger.kernel.org,
        linux-block@vger.kernel.org, Jens Axboe <axboe@fb.com>,
        dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH next] Btrfs: fix comparison in
 __btrfs_map_block()
Message-ID: <20160718035051.GA3304@infradead.org>
References: <1465155145-10812-14-git-send-email-mchristi@redhat.com>
 <1468595001-4270-1-git-send-email-vincent.stehle@intel.com>
 <578BEFB7.6060209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <578BEFB7.6060209@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 17, 2016 at 03:51:03PM -0500, Mike Christie wrote:
> > 
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index a69203a..6ee1e36 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -5533,7 +5533,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
> >  		}
> >  
> >  	} else if (map->type & BTRFS_BLOCK_GROUP_DUP) {
> > -		if (op == REQ_OP_WRITE || REQ_OP_DISCARD ||
> > +		if (op == REQ_OP_WRITE || op == REQ_OP_DISCARD ||
> >  		    op == REQ_GET_READ_MIRRORS) {
> >  			num_stripes = map->num_stripes;
> >  		} else if (mirror_num) {
> > 
> 
> 
> Shoot. Dumb mistake by me. It is of course correct.

Ad while we're at it we need to fix up that REQ_GET_READ_MIRRORS thing.
Overloading the op localally in a fs is going to create problems sooner
or later as no one touching the generic values and/or the code
mashalling it in different forms knows about it.
