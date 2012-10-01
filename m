Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:57200 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276Ab2JAQrX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Oct 2012 12:47:23 -0400
Date: Mon, 1 Oct 2012 12:47:20 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Zach Brown <zab@zabbo.net>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: be smarter about dropping things from the tree log
Message-ID: <20121001164720.GB2370@localhost.localdomain>
References: <1348847914-2192-1-git-send-email-jbacik@fusionio.com>
 <20120928174521.GA9424@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120928174521.GA9424@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 28, 2012 at 11:45:21AM -0600, Zach Brown wrote:
> > When we truncate existing items in the tree log we've been searching for
> > each individual item and removing them.  This is unnecessary churn and
> > searching, just keep track of the slot we are on and how many items we need
> > to delete and delete them all at once.  Thanks,
> 
> (speaking of unnecessary churn :))
> 
> > +next_slot:
> >  		path->slots[0]--;
> > +
> >  		btrfs_item_key_to_cpu(path->nodes[0], &found_key,
> >  				      path->slots[0]);
> >  
> >  		if (found_key.objectid != objectid)
> >  			break;
> >  
> > -		ret = btrfs_del_item(trans, log, path);
> > +		start_slot = path->slots[0];
> > +		del_nr++;
> > +		if (start_slot)
> > +			goto next_slot;
> 
> A linear backwards scan?  Of potentially 64k leaves?
> 
> Can you use bin_search() to look for the first key >= [objectid,0,0] in
> the leaf?  And probably a single comparison of slot 0 to fast path the
> case where the whole leaf contains the object id?
> 

Yeah I can do that.

> > +		ret = btrfs_del_items(trans, log, path, start_slot, del_nr);
> >  		if (ret)
> >  			break;
> >  		btrfs_release_path(path);
> >  	}
> > +	if (!ret && del_nr)
> > +		ret = btrfs_del_items(trans, log, path, start_slot, del_nr);
> >  	btrfs_release_path(path);
> 
> You shouldn't have to duplicate deletion and releasing the path if you
> wrap the calculation of start_slot and nr in a helper.  Something like:
> 
> 	nr = find_nr_and_slot_doo_de_doo(, &start_slot);
> 	if (nr > 0)
> 		btrfs_del_items(, start_slot, nr);

K, I'll fix that up, thanks.

Josef
