From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 2/3] btrfs: extended inode refs
Date: Fri, 4 May 2012 13:39:38 +0200
Message-ID: <20120504113937.GA19331@twin.jikos.cz>
References: <1333656543-4843-1-git-send-email-mfasheh@suse.de>
 <1333656543-4843-3-git-send-email-mfasheh@suse.de>
 <4F86D3D3.9030909@jan-o-sch.net>
 <20120503231221.GV17950@wotan.suse.de>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>,
	linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Mark Fasheh <mfasheh@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120503231221.GV17950@wotan.suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 03, 2012 at 04:12:21PM -0700, Mark Fasheh wrote:
> > > +
> > > +		ref_ptr = btrfs_item_ptr_offset(eb, slot);
> > > +
> > > +		/* So that we don't loop back looking for old style log refs. */
> > > +		ref_end = ref_ptr;
> > > +
> > > +		extref = (struct btrfs_inode_extref *) btrfs_item_ptr_offset(eb, slot);
> > > +		namelen = btrfs_inode_extref_name_len(eb, extref);
> > > +		name = kmalloc(namelen, GFP_NOFS);
> > 
> > kmalloc may fail.
> 
> Fixed both instances of this. I'm just testing for null return from kmalloc
> and bubbling the -ENOMEM back up. The callers of add_inode_ref() will wind
> up BUGing on us anyway but that's beyond the scope of this patch.

Yes, this is consistent with the rest of no-mem handling. Fixing all
caller paths is not always trivial and one does not want to do it during
a patch development.


david
