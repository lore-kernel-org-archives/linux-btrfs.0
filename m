Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757246AbcGZQ66 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jul 2016 12:58:58 -0400
Date: Tue, 26 Jul 2016 18:58:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: remove BUG() in raid56
Message-ID: <20160726165842.GL30795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
 <1467248276-12310-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1467248276-12310-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 29, 2016 at 05:57:56PM -0700, Liu Bo wrote:
> This BUG() has been triggered by a fuzz testing image, but in fact
> btrfs can handle this gracefully by returning -EIO.
> 
> Thus, use btrfs_warn to give us more debugging information than a 
> single BUG() and return error properly.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> v2: - use btrfs_warn with more debugging information instead of WARN_ONCE.
>     - change the patch title.
> 
>  fs/btrfs/raid56.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index f8b6d41..5f4712c 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -2139,7 +2139,10 @@ int raid56_parity_recover(struct btrfs_root *root, struct bio *bio,
>  
>  	rbio->faila = find_logical_bio_stripe(rbio, bio);
>  	if (rbio->faila == -1) {
> -		BUG();
> +		btrfs_warn(root->fs_info,
> +	"rbio->faila is -1: (bio has logical %llu len %llu, bbio has map_type %llu)",

That's rather cryptic message for a casual user, can it be prepended by
a short summary what actually happened? Like "bad stripe for parity" or
whatever seems more appropriate to you. Also the changelog could
describe the error condition.
