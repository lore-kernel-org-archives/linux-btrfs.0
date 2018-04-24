Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41049 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756167AbeDXLdV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 07:33:21 -0400
Date: Tue, 24 Apr 2018 13:30:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/4] btrfs: Add incompat flags check for
 btrfs_check_super_valid()
Message-ID: <20180424113047.GD21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180424044809.29838-1-wqu@suse.com>
 <20180424044809.29838-3-wqu@suse.com>
 <20180424104800.GB21272@twin.jikos.cz>
 <057e31d8-f01d-267c-0498-50562a34d11b@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <057e31d8-f01d-267c-0498-50562a34d11b@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 24, 2018 at 07:28:27PM +0800, Qu Wenruo wrote:
> > I've read the discussion under previous version again, IMHO the best way
> > to report what's going on is to use 2 functions for mount ant pre-commit
> > time.
> 
> OK, next version will go that direction.
> 
> Although it may still be a little tricky to split what we need in
> btrfs_validate_super() and btrfs_precheck_super().
> 
> What about this idea:
> - btrfs_precheck_super() only checks the very basis:
>   * magic
>   * incompat flags
>   * csum type
>   Any mismatch will do friendly prompt ("no btrfs detected" or
>   "unsupported flags/csum type" respectively)
> 
> - btrfs_validate_super() do the comprehensive check:
>   * Everything we did in this patchset
>   * including magic, incompat flags and csum type
>   Any mismatch will be considered as corruption.
> 
> For mount time, we call btrfs_precheck_super() then btrfs_validate_super().
> 
> For commit time, only btrfs_validate_super().
> 
> How about this solution?

I'd do that the other way around:

* mount checks: btrfs_validate_super - the superblock on disk must be
  valid before we mount it

  btrfs_validate_super()

* pre-commit checks: the superblock must be valid and we can also do
  some additional checks to detect in-memory corruption

  btrfs_super_precommit_check()
	  btrfs_validate_super()
	  if (incompat) {
		  ...
	  }
