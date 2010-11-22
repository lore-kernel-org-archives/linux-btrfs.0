From: Ian Kent <raven@themaw.net>
Subject: Re: [PATCH] Btrfs: setup blank root and fs_info for mount time
Date: Mon, 22 Nov 2010 09:49:33 +0800
Message-ID: <1290390573.2602.5.camel@perseus.themaw.net>
References: <1290196755-19607-1-git-send-email-josef@redhat.com>
	 <4CE9C677.9050007@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CE9C677.9050007@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2010-11-22 at 09:25 +0800, Li Zefan wrote:
> > +	/*
> > +	 * Setup a dummy root and fs_info for test/set super.  This is because
> > +	 * we don't actually fill this stuff out until open_ctree, but we need
> > +	 * it for searching for existing supers, so this lets us do that and
> > +	 * then open_ctree will properly initialize everything later.
> > +	 */
> > +	fs_info = kzalloc(sizeof(struct btrfs_fs_info), GFP_NOFS);
> > +	tree_root = kzalloc(sizeof(struct btrfs_root), GFP_NOFS);
> > +	if (!fs_info || !tree_root) {
> > +		kfree(fs_info);
> > +		kfree(tree_root);
> 
> The above 2 kfree() calls are redundant.

That's what I thought when I first looked at it but what happens when
fs_info != NULL and tree_root == NULL.

Although I do wonder if doing two successive allocation requests and
then checking both is a good idea. If memory is low there may be a bunch
of page scanning to try and free memory and if it eventually fails that
same process probably would happen all over again on the second call.
I'm not sure though.

> 
> And error should be set to -ENOMEM.

Ah, yes .. I missed that.

> 
> > +		goto error_close_devices;
> > +	}
> > +	fs_info->tree_root = tree_root;
> > +	fs_info->fs_devices = fs_devices;
> > +	tree_root->fs_info = fs_info;
> > +
> >  	bdev = fs_devices->latest_bdev;
> > -	s = sget(fs_type, btrfs_test_super, set_anon_super, fs_devices);
> > +	s = sget(fs_type, btrfs_test_super, btrfs_set_super, tree_root);
> >  	if (IS_ERR(s))
> >  		goto error_s;
> >  
> > @@ -675,6 +702,8 @@ error_s:
> >  	error = PTR_ERR(s);
> >  error_close_devices:
> >  	btrfs_close_devices(fs_devices);
> > +	kfree(fs_info);
> > +	kfree(tree_root);
> >  error_free_subvol_name:
> >  	kfree(subvol_name);
> >  	return ERR_PTR(error);


