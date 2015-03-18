Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35891 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbbCRP76 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Mar 2015 11:59:58 -0400
Date: Wed, 18 Mar 2015 16:59:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs: Fix NO_SPACE bug caused by delayed-iput
Message-ID: <20150318155956.GC20767@suse.cz>
Reply-To: dsterba@suse.cz
References: <1424920823-12176-1-git-send-email-zhaolei@cn.fujitsu.com>
 <1424920823-12176-2-git-send-email-zhaolei@cn.fujitsu.com>
 <20150226222901.GB8720@twin.jikos.cz>
 <00d101d0522b$befc6df0$3cf549d0$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <00d101d0522b$befc6df0$3cf549d0$@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 27, 2015 at 09:21:43AM +0800, Zhao Lei wrote:
> Hi, David Sterba
> 
> * From: David Sterba [mailto:dsterba@suse.cz]
> > Sent: Friday, February 27, 2015 6:29 AM
> > To: Zhaolei
> > Cc: linux-btrfs@vger.kernel.org
> > Subject: Re: [PATCH 1/1] btrfs: Fix NO_SPACE bug caused by delayed-iput
> > 
> > On Thu, Feb 26, 2015 at 11:20:23AM +0800, Zhaolei wrote:
> > > --- a/fs/btrfs/transaction.c
> > > +++ b/fs/btrfs/transaction.c
> > > @@ -2068,8 +2068,12 @@ int btrfs_commit_transaction(struct
> > > btrfs_trans_handle *trans,
> > >
> > >  	kmem_cache_free(btrfs_trans_handle_cachep, trans);
> > >
> > > -	if (current != root->fs_info->transaction_kthread)
> > > +	if (current != root->fs_info->transaction_kthread) {
> > >  		btrfs_run_delayed_iputs(root);
> > 
> > Using a mutex for this kind of synchronization is not entirely correct though it
> > works.
> > 
> rw sem is best way I thought which was choosed from 
> mutex, rw_sem, and wait_queue, although the function name is not
> self documented...
> Do you have some suggestion for this kind of synchronization?

No better ideas at the moment, please proceed.
