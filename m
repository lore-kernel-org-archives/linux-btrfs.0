Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44349 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab3CURp3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 13:45:29 -0400
Date: Thu, 21 Mar 2013 18:45:27 +0100
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Josef Bacik <jbacik@fusionio.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 10/10] Btrfs-progs: make restore deal with really broken
 file systems
Message-ID: <20130321174527.GL31559@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
 <1363109897-7931-11-git-send-email-jbacik@fusionio.com>
 <20130314233705.GA7229@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130314233705.GA7229@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 15, 2013 at 12:37:05AM +0100, David Sterba wrote:
> On Tue, Mar 12, 2013 at 01:38:17PM -0400, Josef Bacik wrote:
> > --- a/cmds-restore.c
> > +++ b/cmds-restore.c
> > +	if (list_roots) {
> > +		int ret = do_list_roots(fs_info->tree_root);
> > +		if (ret) {
> > +			close_ctree(fs_info->tree_root);
> >  			root = NULL;
> 
> Setting root to NULL here has no effect, I wonder if this should be
> 'return NULL' instead, or if it's really ok to return fs_info->fs_root
> even after close_ctree() which calls free_fs_roots and other cleanups.

It's no ok, close_tree does free(fs_info), so it's returning garbage,
the caller jumps to (another) close_ctree if it's in list_root mode (and
trying to free the fs_info again).

> 
> >  		}
> >  	}
> >  
> > -	return root;
> > +	return fs_info->fs_root;
