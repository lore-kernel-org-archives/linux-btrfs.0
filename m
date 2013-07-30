Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756180Ab3G3XAS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jul 2013 19:00:18 -0400
Date: Tue, 30 Jul 2013 16:00:03 -0700
From: Zach Brown <zab@redhat.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add missing error check to find_parent_nodes
Message-ID: <20130730230003.GJ32145@lenny.home.zabbo.net>
References: <1375210462-17820-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375210462-17820-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 8bc5e8c..1ba87c5 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -935,6 +935,8 @@ again:
>  				}
>  				ret = find_extent_in_eb(eb, bytenr,
>  							*extent_item_pos, &eie);
> +				if (ret < 0)
> +					goto out;
>  				ref->inode_list = eie;
>  				free_extent_buffer(eb);
>  			}

The eb needs to be freed before the goto.

And that there's now *three* eb freeing paths in this block should be a
hint that it should be refactored into a function that frees the eb
before returning.

- z
