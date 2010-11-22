From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: setup blank root and fs_info for mount time
Date: Sun, 21 Nov 2010 20:51:45 -0500
Message-ID: <20101122015144.GA27951@dhcp231-156.rdu.redhat.com>
References: <1290196755-19607-1-git-send-email-josef@redhat.com> <4CE9C677.9050007@cn.fujitsu.com> <1290390573.2602.5.camel@perseus.themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Li Zefan <lizf@cn.fujitsu.com>, Josef Bacik <josef@redhat.com>,
	linux-btrfs@vger.kernel.org
To: Ian Kent <raven@themaw.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1290390573.2602.5.camel@perseus.themaw.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 22, 2010 at 09:49:33AM +0800, Ian Kent wrote:
> On Mon, 2010-11-22 at 09:25 +0800, Li Zefan wrote:
> > > +	/*
> > > +	 * Setup a dummy root and fs_info for test/set super.  This is because
> > > +	 * we don't actually fill this stuff out until open_ctree, but we need
> > > +	 * it for searching for existing supers, so this lets us do that and
> > > +	 * then open_ctree will properly initialize everything later.
> > > +	 */
> > > +	fs_info = kzalloc(sizeof(struct btrfs_fs_info), GFP_NOFS);
> > > +	tree_root = kzalloc(sizeof(struct btrfs_root), GFP_NOFS);
> > > +	if (!fs_info || !tree_root) {
> > > +		kfree(fs_info);
> > > +		kfree(tree_root);
> > 
> > The above 2 kfree() calls are redundant.
> 
> That's what I thought when I first looked at it but what happens when
> fs_info != NULL and tree_root == NULL.
>

When i do goto error_close_devices; i do the kfree's there too, my bad, I'll fix
it up.
 
> Although I do wonder if doing two successive allocation requests and
> then checking both is a good idea. If memory is low there may be a bunch
> of page scanning to try and free memory and if it eventually fails that
> same process probably would happen all over again on the second call.
> I'm not sure though.
>

Sure but how often is that going to happen :)
 
> > 
> > And error should be set to -ENOMEM.
> 
> Ah, yes .. I missed that.
>

Yup me too.  Thanks for the review guys,

Josef 
