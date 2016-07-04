Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51407 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbcGDRHy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jul 2016 13:07:54 -0400
Date: Mon, 4 Jul 2016 19:08:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, Peter Becker <floyd.net@gmail.com>
Subject: Re: [PATCH] Btrfs: fix read_node_slot to return errors
Message-ID: <20160704170818.GK13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1467165348-9931-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1467165348-9931-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 28, 2016 at 06:55:48PM -0700, Liu Bo wrote:
> @@ -5238,6 +5256,10 @@ static void tree_move_down(struct btrfs_root *root,
>  					path->slots[*level]);
>  	path->slots[*level - 1] = 0;
>  	(*level)--;
> +
> +	if (IS_ERR(path->nodes[*level - 1]))
> +		return PTR_ERR(path->nodes[*level - 1]);

Is this right? *level changes since the call to read_node_slot so I
don't understand which value are we actually testing for error.

Otherwise looks good.

> +	return 0;
>  }
