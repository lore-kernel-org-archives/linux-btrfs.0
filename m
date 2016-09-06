Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29641 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934560AbcIFTWM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Sep 2016 15:22:12 -0400
Date: Tue, 6 Sep 2016 12:22:01 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: don't leak reloc root nodes on error
Message-ID: <20160906192200.GA31641@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1472844343-19086-1-git-send-email-jbacik@fb.com>
 <20160903010827.GA7758@localhost.localdomain>
 <20160905152053.GX16983@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160905152053.GX16983@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 05, 2016 at 05:20:53PM +0200, David Sterba wrote:
> On Fri, Sep 02, 2016 at 06:08:35PM -0700, Liu Bo wrote:
> > On Fri, Sep 02, 2016 at 03:25:43PM -0400, Josef Bacik wrote:
> > > We don't track the reloc roots in any sort of normal way, so the only way the
> > > root/commit_root nodes get free'd is if the relocation finishes successfully and
> > > the reloc root is deleted.  Fix this by free'ing them in free_reloc_roots.
> > > Thanks,
> > 
> > Looks good.
> > 
> > > 
> > > Signed-off-by: Josef Bacik <jbacik@fb.com>
> > > ---
> > >  fs/btrfs/relocation.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> > > index 7fc6ea7..62dfc2c 100644
> > > --- a/fs/btrfs/relocation.c
> > > +++ b/fs/btrfs/relocation.c
> > > @@ -2349,6 +2349,10 @@ void free_reloc_roots(struct list_head *list)
> > >  	while (!list_empty(list)) {
> > >  		reloc_root = list_entry(list->next, struct btrfs_root,
> > >  					root_list);
> > > +		free_extent_buffer(reloc_root->node);
> > > +		free_extent_buffer(reloc_root->commit_root);
> > > +		reloc_root->node = NULL;
> > > +		reloc_root->commit_root = NULL;
> > 
> > What about reloc_root itself?
> 
> > >  		__del_reloc_root(reloc_root);
> 
> It's deleted at the end of __del_reloc_root

__del_reloc_root() is dealing with the associated rb_node, not
reloc_root.

I posted a patch to free reloc_root while free'ing its corresponding fs
root, but it'd be good if we can free it here.

Thanks,

-liubo
