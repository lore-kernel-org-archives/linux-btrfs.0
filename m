Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59537 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751077AbdFEQLG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Jun 2017 12:11:06 -0400
Date: Mon, 5 Jun 2017 18:10:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 2/2] Btrfs: compression must free at least one sector
 size
Message-ID: <20170605161003.GX12135@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170529231805.4797-1-nefelim4ag@gmail.com>
 <20170529231805.4797-3-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170529231805.4797-3-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 30, 2017 at 02:18:05AM +0300, Timofey Titovets wrote:
> Btrfs already skip store of data where compression didn't
> free at least one byte. Let's make logic better and make check
> that compression free at least one sector size
> because in another case it useless to store this data compressed
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/inode.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 17cbe930..2793007b 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -609,9 +609,10 @@ static noinline void compress_file_range(struct inode *inode,
>  		/*
>  		 * one last check to make sure the compression is really a
>  		 * win, compare the page count read with the blocks on disk
> +		 * compression must free at least one sector size
>  		 */
>  		total_in = ALIGN(total_in, PAGE_SIZE);
> -		if (total_compressed >= total_in) {
> +		if (total_compressed + blocksize > total_in) {

We're doing aligned calculation here, shouldn't this be >= ?

If total_compressed + blocksize == total_in, we have saved exactly one
blocksize.
