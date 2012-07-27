Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:52428 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab2G0Mat (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jul 2012 08:30:49 -0400
Date: Fri, 27 Jul 2012 14:29:57 +0200
From: David Sterba <dave@jikos.cz>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: miaox@cn.fujitsu.com, Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Btrfs: fix the snapshot that should not exist
Message-ID: <20120727122957.GL17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <5010EA3E.4040009@cn.fujitsu.com>
 <501248B5.8010408@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <501248B5.8010408@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 27, 2012 at 04:52:21PM +0900, Hidetoshi Seto wrote:
> (2012/07/26 15:57), Miao Xie wrote:
> >  	btrfs_abort_transaction(trans, root, ret);
> >  	goto fail;
> >  }
> > @@ -1386,13 +1408,13 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
> >  	 */
> >  	mutex_lock(&root->fs_info->reloc_mutex);
> >  
> > -	ret = btrfs_run_delayed_items(trans, root);
> > +	ret = create_pending_snapshots(trans, root->fs_info);
> >  	if (ret) {
> >  		mutex_unlock(&root->fs_info->reloc_mutex);
> >  		goto cleanup_transaction;
> >  	}
> >  
> > -	ret = create_pending_snapshots(trans, root->fs_info);
> > +	ret = btrfs_run_delayed_items(trans, root);
> >  	if (ret) {
> >  		mutex_unlock(&root->fs_info->reloc_mutex);
> >  		goto cleanup_transaction;
> 
> It would be nice to have a patch description to tell why you
> have to change the order here.

Not only nice but necessary, as this order will cause corruption under
certain conditions. I'd like to hear the reason behind.


david
