Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:46820 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928Ab3HGUSb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Aug 2013 16:18:31 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 824D97C068C
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Aug 2013 14:18:31 -0600 (MDT)
Date: Wed, 7 Aug 2013 16:18:29 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Zach Brown <zab@redhat.com>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: deal with enomem in the rewind path V2
Message-ID: <20130807201829.GD2397@localhost.localdomain>
References: <1375902376-13632-1-git-send-email-jbacik@fusionio.com>
 <20130807200230.GT12314@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130807200230.GT12314@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 07, 2013 at 01:02:30PM -0700, Zach Brown wrote:
> > --- a/fs/btrfs/ctree.c
> > +++ b/fs/btrfs/ctree.c
> > @@ -1211,7 +1211,8 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
> >  		BUG_ON(tm->slot != 0);
> >  		eb_rewin = alloc_dummy_extent_buffer(eb->start,
> >  						fs_info->tree_root->nodesize);
> > -		BUG_ON(!eb_rewin);
> > +		if (!eb_rewin)
> > +			return ERR_PTR(-ENOMEM);
> 
> Don't these error paths need to unlock and free eb...
> 
> > @@ -2772,6 +2774,10 @@ again:
> >  							  BTRFS_READ_LOCK);
> >  			}
> >  			b = tree_mod_log_rewind(root->fs_info, b, time_seq);
> > +			if (IS_ERR(b)) {
> > +				ret = PTR_ERR(b);
> > +				goto done;
> > +			}
> 
> ... because this b = doit(, b, ) will leak the b input eb if the b
> return is an error pointer?
> 

Ah yeah I completely missed that, thanks.

Josef
