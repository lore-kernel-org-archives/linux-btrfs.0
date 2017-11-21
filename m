Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36016 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751290AbdKUWpa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 17:45:30 -0500
Date: Tue, 21 Nov 2017 14:45:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: hannes@cmpxchg.org, linux-mm@kvack.org, jack@suse.cz,
        linux-fsdevel@vger.kernel.org, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 01/10] remove mapping from balance_dirty_pages*()
Message-Id: <20171121144528.c44458f50738d73cab3aca4b@linux-foundation.org>
In-Reply-To: <1510696616-8489-1-git-send-email-josef@toxicpanda.com>
References: <1510696616-8489-1-git-send-email-josef@toxicpanda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 14 Nov 2017 16:56:47 -0500 Josef Bacik <josef@toxicpanda.com> wrote:

> From: Josef Bacik <jbacik@fb.com>
> 
> The only reason we pass in the mapping is to get the inode in order to see if
> writeback cgroups is enabled, and even then it only checks the bdi and a super
> block flag.  balance_dirty_pages() doesn't even use the mapping.  Since
> balance_dirty_pages*() works on a bdi level, just pass in the bdi and super
> block directly so we can avoid using mapping.  This will allow us to still use
> balance_dirty_pages for dirty metadata pages that are not backed by an
> address_mapping.
>
> ...
> 
> @@ -71,7 +72,8 @@ static int _block2mtd_erase(struct block2mtd_dev *dev, loff_t to, size_t len)
>  				memset(page_address(page), 0xff, PAGE_SIZE);
>  				set_page_dirty(page);
>  				unlock_page(page);
> -				balance_dirty_pages_ratelimited(mapping);
> +				balance_dirty_pages_ratelimited(inode_to_bdi(inode),
> +								inode->i_sb);
>  				break;
>  			}

So we do a bunch more work in each caller and we pass two args rather
than one.  That doesn't make things better!

I see that this is enablement for "dirty metadata pages that are not
backed by an address_mapping" (address_space) so I look into [7/10] and
the changelog doesn't tell me much.

So color me confused.  What is this patchset actually *for*?  Is there
some filesystem which has non-address_space-backed metadata?  Or will
there be so soon?  Or what.

I think we need a [0/n] email please.  One which fully describes the
intent of the patchset.

