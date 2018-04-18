Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44784 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752849AbeDRW2i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 18:28:38 -0400
Date: Thu, 19 Apr 2018 00:26:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Howard McLauchlan <hmclauchlan@fb.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        kernel-team@fb.com
Subject: Re: [PATCH 2/2] btrfs: optimize free space tree bitmap conversion
Message-ID: <20180418222606.GX21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180418213059.8025-1-hmclauchlan@fb.com>
 <20180418213059.8025-2-hmclauchlan@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180418213059.8025-2-hmclauchlan@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 18, 2018 at 02:30:59PM -0700, Howard McLauchlan wrote:
> Presently, convert_free_space_to_extents() does a linear scan of the
> bitmap. We can speed this up with find_next_{bit,zero_bit}_le().
> 
> This patch replaces the linear scan with find_next_{bit,zero_bit}_le().
> Testing shows a 20-33% decrease in execution time for
> convert_free_space_to_extents().
> 
> Suggested-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>
> ---
> 
> Since we change bitmap to be unsigned long, we have to do some casting for the
> bitmap cursor. In le_bitmap_set() it makes sense to use u8, as we are doing
> bit operations. Everywhere else, we're just using it for pointer arithmetic and
> not directly accessing it, so char seems more appropriate.

Ok, makes sense for just passing the pointers around. I'll add the text
to changelog and apply the patch to next.

> -		bit = !!le_test_bit(bitnr, bitmap);

This is the last use of le_test_bit, so it can be removed (in another
patch).
