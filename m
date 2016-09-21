Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19155 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756496AbcIUWpm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 18:45:42 -0400
Date: Wed, 21 Sep 2016 15:45:19 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: don't leak reloc root nodes on errorg
Message-ID: <20160921224518.GA25517@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1472844343-19086-1-git-send-email-jbacik@fb.com>
 <20160903010827.GA7758@localhost.localdomain>
 <20160905152053.GX16983@twin.jikos.cz>
 <20160906192200.GA31641@localhost.localdomain>
 <20160921140005.GG16983@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160921140005.GG16983@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 21, 2016 at 04:00:05PM +0200, David Sterba wrote:
> On Tue, Sep 06, 2016 at 12:22:01PM -0700, Liu Bo wrote:
> > On Mon, Sep 05, 2016 at 05:20:53PM +0200, David Sterba wrote:
> > > On Fri, Sep 02, 2016 at 06:08:35PM -0700, Liu Bo wrote:
> > > > On Fri, Sep 02, 2016 at 03:25:43PM -0400, Josef Bacik wrote:
> > > > > We don't track the reloc roots in any sort of normal way, so the only way the
> > > > > root/commit_root nodes get free'd is if the relocation finishes successfully and
> > > > > the reloc root is deleted.  Fix this by free'ing them in free_reloc_roots.
> > > > > Thanks,
> > > > 
> > > > Looks good.
> > > > 
> > > > > 
> > > > > Signed-off-by: Josef Bacik <jbacik@fb.com>
> > > > > ---
> > > > >  fs/btrfs/relocation.c | 4 ++++
> > > > >  1 file changed, 4 insertions(+)
> > > > > 
> > > > > diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> > > > > index 7fc6ea7..62dfc2c 100644
> > > > > --- a/fs/btrfs/relocation.c
> > > > > +++ b/fs/btrfs/relocation.c
> > > > > @@ -2349,6 +2349,10 @@ void free_reloc_roots(struct list_head *list)
> > > > >  	while (!list_empty(list)) {
> > > > >  		reloc_root = list_entry(list->next, struct btrfs_root,
> > > > >  					root_list);
> > > > > +		free_extent_buffer(reloc_root->node);
> > > > > +		free_extent_buffer(reloc_root->commit_root);
> > > > > +		reloc_root->node = NULL;
> > > > > +		reloc_root->commit_root = NULL;
> > > > 
> > > > What about reloc_root itself?
> > > 
> > > > >  		__del_reloc_root(reloc_root);
> > > 
> > > It's deleted at the end of __del_reloc_root
> > 
> > __del_reloc_root() is dealing with the associated rb_node, not
> > reloc_root.
> > 
> > I posted a patch to free reloc_root while free'ing its corresponding fs
> > root, but it'd be good if we can free it here.
> 
> Can you please point me to the patch?

Btrfs: fix memory leak of reloc_root
https://patchwork.kernel.org/patch/9238383/

Thanks,

-liubo
