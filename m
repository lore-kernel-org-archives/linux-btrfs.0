Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40652 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932793AbcIEPWY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Sep 2016 11:22:24 -0400
Date: Mon, 5 Sep 2016 17:20:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: don't leak reloc root nodes on error
Message-ID: <20160905152053.GX16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1472844343-19086-1-git-send-email-jbacik@fb.com>
 <20160903010827.GA7758@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160903010827.GA7758@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 02, 2016 at 06:08:35PM -0700, Liu Bo wrote:
> On Fri, Sep 02, 2016 at 03:25:43PM -0400, Josef Bacik wrote:
> > We don't track the reloc roots in any sort of normal way, so the only way the
> > root/commit_root nodes get free'd is if the relocation finishes successfully and
> > the reloc root is deleted.  Fix this by free'ing them in free_reloc_roots.
> > Thanks,
> 
> Looks good.
> 
> > 
> > Signed-off-by: Josef Bacik <jbacik@fb.com>
> > ---
> >  fs/btrfs/relocation.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> > index 7fc6ea7..62dfc2c 100644
> > --- a/fs/btrfs/relocation.c
> > +++ b/fs/btrfs/relocation.c
> > @@ -2349,6 +2349,10 @@ void free_reloc_roots(struct list_head *list)
> >  	while (!list_empty(list)) {
> >  		reloc_root = list_entry(list->next, struct btrfs_root,
> >  					root_list);
> > +		free_extent_buffer(reloc_root->node);
> > +		free_extent_buffer(reloc_root->commit_root);
> > +		reloc_root->node = NULL;
> > +		reloc_root->commit_root = NULL;
> 
> What about reloc_root itself?

> >  		__del_reloc_root(reloc_root);

It's deleted at the end of __del_reloc_root
