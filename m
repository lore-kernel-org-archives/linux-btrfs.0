Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33235 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932103AbdJ3PED (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 11:04:03 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 345BDAAC8
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Oct 2017 15:04:02 +0000 (UTC)
Date: Mon, 30 Oct 2017 16:02:12 +0100
From: David Sterba <dsterba@suse.cz>
To: Edmund Nadolski <enadolski@suse.de>
Cc: Nikolay Borisov <nborisov@suse.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4] btrfs: Fix transaction abort during failure in
 btrfs_rm_dev_item
Message-ID: <20171030150212.GY3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1508481013-16074-1-git-send-email-nborisov@suse.com>
 <1508741926-27125-1-git-send-email-nborisov@suse.com>
 <7f2a3c59-818f-c7dd-de6a-7db8f9e8d818@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7f2a3c59-818f-c7dd-de6a-7db8f9e8d818@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 23, 2017 at 10:29:27AM -0600, Edmund Nadolski wrote:
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -1765,20 +1765,24 @@ static int btrfs_rm_dev_item(struct btrfs_fs_info *fs_info,
> >  	key.offset = device->devid;
> >  
> >  	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
> > -	if (ret < 0)
> > -		goto out;
> > -
> > -	if (ret > 0) {
> > -		ret = -ENOENT;
> > +	if (ret) {
> > +		if (ret > 0)
> > +			ret = -ENOENT;
> > +		btrfs_abort_transaction(trans, ret);
> > +		btrfs_end_transaction(trans);
> >  		goto out;
> >  	}
> >  
> >  	ret = btrfs_del_item(trans, root, path);
> > -	if (ret)
> > -		goto out;
> > +	if (ret) {
> > +		btrfs_abort_transaction(trans, ret);
> > +		btrfs_end_transaction(trans);
> > +	}
> > +
> >  out:
> >  	btrfs_free_path(path);
> > -	btrfs_commit_transaction(trans);
> > +	if (!ret)
> > +		ret = btrfs_commit_transaction(trans);
> >  	return ret;
> >  }
> >  
> > 
> 
> Perhaps slightly simpler (and the 'out:' label maybe goes away):
> 
> 	.....
> 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
> 	if (ret > 0)
> 		ret = -ENOENT;
> 	else if (!ret)
> 		ret = btrfs_del_item(trans, root, path);
> 
> 	if (ret) {
> 		btrfs_abort_transaction(trans, ret);
> 		btrfs_end_transaction(trans);

This would merge 2 abort sites into one, btrfs_search_slot and
btrfs_del_item, so it wouldn't be obvious which one failed just from the
stack trace and line number.

V4 is ok, as it only joins return values from btrfs_search_slot, where
the positive value means "search slot was not able to find the key, but
this is where you should insert it". This really translates to ENOENT so
we're not losing any information.
