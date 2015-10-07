Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35784 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbbJGJ0J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Oct 2015 05:26:09 -0400
Date: Wed, 7 Oct 2015 11:25:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, fdmanana@gmail.com,
        chandan@mykolab.com
Subject: Re: [PATCH] Btrfs: Intialize btrfs_root->highest_objectid when
 loading tree root and subvolume roots
Message-ID: <20151007092503.GG7734@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1444063465-5641-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444063465-5641-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 05, 2015 at 10:14:24PM +0530, Chandan Rajendra wrote:
> +	if (unlikely(root->highest_objectid >= BTRFS_LAST_FREE_OBJECTID)) {
> +		mutex_unlock(&root->objectid_mutex);
> +		ret = -ENOSPC;

ENOSPC ... I don't think it's right as this could be with a normal
enospc during subvolume creation. The problem is that theh inode number
space is exhausted, the closest error code I see is EOVERFLOW. As this
is an ioctl we can afford to define the meaning of this return value as
such (unlike for eg. creat()/open()).

> +		goto free_root_dev;
> +	}
> +
> +	mutex_unlock(&root->objectid_mutex);
> +
>  	return 0;
