Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34353 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbbFYQt7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jun 2015 12:49:59 -0400
Date: Thu, 25 Jun 2015 18:49:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: dsterba@suse.cz, Robert Marklund <robbelibobban@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] check: check so offset is not bigger then the leaf
Message-ID: <20150625164958.GN726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1434585553-8697-1-git-send-email-robbelibobban@gmail.com>
 <20150618164443.GH6761@twin.jikos.cz>
 <5582FD06.2010004@fb.com>
 <20150625160613.GK726@twin.jikos.cz>
 <558C2B2A.1070002@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <558C2B2A.1070002@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 25, 2015 at 09:24:10AM -0700, Josef Bacik wrote:
> > +
> > +       for (i = 0; i < nritems; i++) {
> > +               void *tmp;
> > +
> > +               tmp = btrfs_item_ptr(buf, i, void);
> > +               if ((long)tmp >= BTRFS_LEAF_DATA_SIZE(root)) {
> > +                       ret = BTRFS_TREE_BLOCK_INVALID_OFFSETS;
> > +                       fprintf(stderr, "bad item pointer %lu\n",
> > +                               (long)tmp);
> > +                       goto fail;
> > +               }
> > +       }
> 
> I'd just do
> 
> if (btrfs_item_end_nr(buf, i) >= BTRFS_LEAF_DATA_SIZE(root))
> 
> that way you catch problems with offset and size.  Thanks,

Ah right, my check would not catch 'offset + size >= leaf data size'
if 'offset < leaf data size'. Patch welcome.
