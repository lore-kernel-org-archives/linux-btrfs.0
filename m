Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56419 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751668AbdF3HpV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Jun 2017 03:45:21 -0400
Date: Fri, 30 Jun 2017 09:44:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PULL] Btrfs for 4.13, part 1
Message-ID: <20170630074409.GO2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1498229425.git.dsterba@suse.com>
 <1ad1fcee-d7de-452d-3e9f-a87fe5d6117e@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ad1fcee-d7de-452d-3e9f-a87fe5d6117e@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 28, 2017 at 09:49:49AM +0300, Nikolay Borisov wrote:
> Dave I run bisection of all failures between -rc6 and your 
> pull request and here are the results: 
> 
> btrfs/048 - e79a33270d05 ("btrfs: Check name_len with boundary in verify dir_item")
> btrfs/053 - b780e22768d3 ("btrfs: fix validation of XATTR_ITEM dir items")
> generic/273 - 28785f70ef88 ("Btrfs: skip commit transaction if we don't have enough pinned bytes")
> generic/337 - e79a33270d05 ("btrfs: Check name_len with boundary in verify dir_item")
> shared/002 - e79a33270d05 ("btrfs: Check name_len with boundary in verify dir_item")
> 
> So those are tests which are failing as a direct of 
> the listed patches. 

Thanks for the list. I'm not sure the bisection helps here, the bug is
in the validation function, other patches call it in various places. But
I've used the list of tests for verifying my fix I sent yesterday.
Overnight run of all fstests still found one instance that fails, test
generic/066 so I'll look at it today.
