Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52691 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681Ab3IBNjL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Sep 2013 09:39:11 -0400
Date: Mon, 2 Sep 2013 15:39:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH v7] Btrfs: optimize key searches in btrfs_search_slot
Message-ID: <20130902133909.GX23113@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1377780253-17826-1-git-send-email-fdmanana@gmail.com>
 <1378031968-22062-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1378031968-22062-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 01, 2013 at 11:39:28AM +0100, Filipe David Borba Manana wrote:
> +#ifdef CONFIG_BTRFS_ASSERT
> +static int key_search_validate(struct extent_buffer *b,
> +			       struct btrfs_key *key,
> +			       int level)
> +{
...
> +}
> +#endif
> +
> +static int key_search(struct extent_buffer *b, struct btrfs_key *key,
> +		      int level, int *prev_cmp, int *slot)
> +{
> +	if (*prev_cmp != 0) {
> +		*prev_cmp = bin_search(b, key, level, slot);
> +		return *prev_cmp;
> +	}
> +
> +	ASSERT(key_search_validate(b, key, level));

But what if I want to use key_search_validate out of the context of an
ASSERT ? I don't see a reason why the function needs to be under #ifdef
BTRFS_ASSERT / #endif at all.

> +	*slot = 0;
> +
> +	return 0;
> +}
