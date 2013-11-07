Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab3KGQlj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Nov 2013 11:41:39 -0500
Date: Thu, 7 Nov 2013 17:41:34 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 03/17] btrfs: Add high priority workqueue support for
 btrfs_workqueue_struct
Message-ID: <20131107164134.GJ16662@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1383803527-23736-4-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1383803527-23736-4-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 07, 2013 at 01:51:53PM +0800, Qu Wenruo wrote:
> @@ -753,6 +754,19 @@ struct btrfs_workqueue_struct *btrfs_alloc_workqueue(char *name,
>  		}
>  	}
>  
> +	if (high_name) {
> +		ret->high_wq = alloc_workqueue(high_name,
> +					       flags | WQ_HIGHPRI,
> +					       max_active);

I'd really like to add the btrfs- prefix of the workqueue. Quoting our
previous discussion:

> > * the thread names lost the btrfs- prefix, this makes it hard to
> >    identify the processes and we want this, either debugging or
> >    performance monitoring
> Yes, that's right.
> But the problem is, even I added "btrfs-" prefix to the wq,
> the real work executor is kernel workers without any prefix.
> Still hard to debugging due to the workqueue mechanism.

AFAICS the string passed down to alloc_workqueue ends up in the process
name, this is what I'm expecing and don't understand what do you mean.


david
