Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41417 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750822AbbB0BVz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Feb 2015 20:21:55 -0500
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
References: <1424920823-12176-1-git-send-email-zhaolei@cn.fujitsu.com> <1424920823-12176-2-git-send-email-zhaolei@cn.fujitsu.com> <20150226222901.GB8720@twin.jikos.cz>
In-Reply-To: <20150226222901.GB8720@twin.jikos.cz>
Subject: RE: [PATCH 1/1] btrfs: Fix NO_SPACE bug caused by delayed-iput
Date: Fri, 27 Feb 2015 09:21:43 +0800
Message-ID: <00d101d0522b$befc6df0$3cf549d0$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, David Sterba

* From: David Sterba [mailto:dsterba@suse.cz]
> Sent: Friday, February 27, 2015 6:29 AM
> To: Zhaolei
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH 1/1] btrfs: Fix NO_SPACE bug caused by delayed-iput
> 
> On Thu, Feb 26, 2015 at 11:20:23AM +0800, Zhaolei wrote:
> > --- a/fs/btrfs/transaction.c
> > +++ b/fs/btrfs/transaction.c
> > @@ -2068,8 +2068,12 @@ int btrfs_commit_transaction(struct
> > btrfs_trans_handle *trans,
> >
> >  	kmem_cache_free(btrfs_trans_handle_cachep, trans);
> >
> > -	if (current != root->fs_info->transaction_kthread)
> > +	if (current != root->fs_info->transaction_kthread) {
> >  		btrfs_run_delayed_iputs(root);
> 
> Using a mutex for this kind of synchronization is not entirely correct though it
> works.
> 
rw sem is best way I thought which was choosed from 
mutex, rw_sem, and wait_queue, although the function name is not
self documented...
Do you have some suggestion for this kind of synchronization?

Thanks
Zhaolei

> > +		/* make sure that all running delayed iput are done */
> > +		down_write(&root->fs_info->delayed_iput_sem);
> > +		up_write(&root->fs_info->delayed_iput_sem);


