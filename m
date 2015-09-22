Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53736 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757711AbbIVNK3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 09:10:29 -0400
Date: Tue, 22 Sep 2015 15:09:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Alexandru Moise <00moses.alexander00@gmail.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, holger.hoffstaette@googlemail.com
Subject: Re: [PATCH 1/2] btrfs: avoid passing int param to start_transaction
 which takes u64
Message-ID: <20150922130933.GD12815@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150913184720.GA25846@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150913184720.GA25846@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 13, 2015 at 06:47:20PM +0000, Alexandru Moise wrote:
> Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
> ---
> v2: Forgot to add transaction.h when I made the commit, many thanks
> Holger for pointing it out.
> 
>  fs/btrfs/transaction.c | 2 +-
>  fs/btrfs/transaction.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 8f259b3..8a83acd 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -570,7 +570,7 @@ reserve_fail:
>  }
>  
>  struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
> -						   int num_items)
> +						   u64 num_items)

I think it's better to do it the other way around, ie. let all the
equivalents of 'num_items' be an int. We know that this is a small
number, using u64 for that is an overkill. As the number is always
positive, please make it 'unsigned'.
