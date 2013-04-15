Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47332 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996Ab3DOPNS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 11:13:18 -0400
Date: Mon, 15 Apr 2013 17:13:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2] Btrfs: allow file data clone within a file
Message-ID: <20130415151315.GD18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1365994545-19083-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1365994545-19083-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 15, 2013 at 10:55:45AM +0800, Liu Bo wrote:
> @@ -2563,6 +2568,12 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
>  	    !IS_ALIGNED(destoff, bs))
>  		goto out_unlock;
>  
> +	/* verify if ranges are overlapped within the same file */
> +	if (same_inode) {
> +		if (destoff + len > off && destoff < off + len)
> +			goto out_unlock;

Although I find the condition hard to read, it's correct.

Reviewed-by: David Sterba <dsterba@suse.cz>
