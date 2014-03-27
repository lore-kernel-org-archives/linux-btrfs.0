Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43630 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbaC0Q5F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Mar 2014 12:57:05 -0400
Date: Thu, 27 Mar 2014 17:57:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2 02/10] Btrfs: wake up the tasks that wait for the io
 earlier
Message-ID: <20140327165703.GZ29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1394085304-32589-1-git-send-email-miaox@cn.fujitsu.com>
 <1394085304-32589-2-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1394085304-32589-2-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 06, 2014 at 01:54:56PM +0800, Miao Xie wrote:
> @@ -349,10 +349,13 @@ int btrfs_dec_test_first_ordered_pending(struct inode *inode,
>  	if (!uptodate)
>  		set_bit(BTRFS_ORDERED_IOERR, &entry->flags);
>  
> -	if (entry->bytes_left == 0)
> +	if (entry->bytes_left == 0) {
>  		ret = test_and_set_bit(BTRFS_ORDERED_IO_DONE, &entry->flags);
> -	else

waitqueue_active() should be preceded by a barrier (either implicit or
explicit), which is missing here and below. Though this could lead to a
missed wakeup, I don't think it's required here, but for consistency I
suggest to add it or put a comment why it's not needed.

> +		if (waitqueue_active(&entry->wait))
> +			wake_up(&entry->wait);
> +	} else {
>  		ret = 1;
> +	}
>  out:
>  	if (!ret && cached && entry) {
>  		*cached = entry;
> @@ -410,10 +413,13 @@ have_entry:
>  	if (!uptodate)
>  		set_bit(BTRFS_ORDERED_IOERR, &entry->flags);
>  
> -	if (entry->bytes_left == 0)
> +	if (entry->bytes_left == 0) {
>  		ret = test_and_set_bit(BTRFS_ORDERED_IO_DONE, &entry->flags);
> -	else
> +		if (waitqueue_active(&entry->wait))

^^^

> +			wake_up(&entry->wait);
> +	} else {
>  		ret = 1;
> +	}
>  out:
>  	if (!ret && cached && entry) {
>  		*cached = entry;
