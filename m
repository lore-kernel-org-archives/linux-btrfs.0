Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53132 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959AbbL3RUm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Dec 2015 12:20:42 -0500
Date: Wed, 30 Dec 2015 18:18:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Sanidhya Solanki <jpage.lkml@gmail.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Runs the xor function if a Block has failed
Message-ID: <20151230171826.GG4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1451456916-16520-1-git-send-email-jpage.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1451456916-16520-1-git-send-email-jpage.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 30, 2015 at 01:28:36AM -0500, Sanidhya Solanki wrote:
> The patch adds the xor function after the P stripe
> has failed, without bad data or the Q stripe.

That's just the comment copied, the changelog does not explain why it's
ok to do just the run_xor there. It does not seem trivial to me. Please
describe that the end result after the code change is expected.

> @@ -1864,8 +1864,8 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
>  					/*
>  					 * Just the P stripe has failed, without
>  					 * a bad data or Q stripe.
> -					 * TODO, we should redo the xor here.
>  					 */
> +					run_xor(pointers, rbio->nr_data - 1, PAGE_CACHE_SIZE);
>  					err = -EIO;
>  					goto cleanup;
