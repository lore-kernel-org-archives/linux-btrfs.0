Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51976 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753201AbeDSP4E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 11:56:04 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 17756AF7D
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 15:56:03 +0000 (UTC)
Date: Thu, 19 Apr 2018 17:53:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: Factor out read portion of
 btrfs_get_blocks_direct
Message-ID: <20180419155331.GK21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1519315934-13611-1-git-send-email-nborisov@suse.com>
 <20180410154905.GE2817@twin.jikos.cz>
 <e68cd719-3a3c-b125-eed0-97bf7f1afb08@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e68cd719-3a3c-b125-eed0-97bf7f1afb08@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 11, 2018 at 10:22:58AM +0300, Nikolay Borisov wrote:
> >> +			free_extent_map(em);
> >> +			goto unlock_err;
> >> +		}
> >> +		/*
> >> +		 * We need to unlock only the end area that we aren't using
> >> +		 * if there is any leftover space
> >> +		 */
> >> +		free_extent_state(cached_state);
> >>  		free_extent_map(em);
> >> -		goto unlock_err;
> >> +		return 0;
> > 
> > Please add a separate label for that, the funcion uses the single exit
> > block style (labels and one-or-two returns).
> 
> So I think this is unnecessary because in 2/2 I factor out common code
> i.e. the free_extent_map(em); return 0; outside of the 'if' branch and
> so this return disappears. The 3rd hunk in 2/2 begins with:
> 
> @@ -7780,106 +7882,8 @@ static int btrfs_get_blocks_direct(struct inode
> *inode, sector_t iblock,
>  		 * if there is any leftover space
>  		 */
>  		free_extent_state(cached_state);
> -		free_extent_map(em);
> -		return 0;
> -	}

Ok.
