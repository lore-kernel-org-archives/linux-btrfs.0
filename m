Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39077 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752423AbdAKQEG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jan 2017 11:04:06 -0500
Date: Wed, 11 Jan 2017 17:03:48 +0100
From: David Sterba <dsterba@suse.cz>
To: Michal Hocko <mhocko@kernel.org>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 2/2] btrfs: drop gfp mask tweaking in
 try_release_extent_state
Message-ID: <20170111160348.GK12081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170109143903.32280-1-mhocko@kernel.org>
 <20170109143903.32280-2-mhocko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170109143903.32280-2-mhocko@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 09, 2017 at 03:39:03PM +0100, Michal Hocko wrote:
> From: Michal Hocko <mhocko@suse.com>
> 
> try_release_extent_state reduces the gfp mask to GFP_NOFS if it is
> compatible. This is true for GFP_KERNEL as well. There is no real
> reason to do that though. There is no new lock taken down the
> the only consumer of the gfp mask which is
> try_release_extent_state
>   clear_extent_bit
>     __clear_extent_bit
>       alloc_extent_state
> 
> So this seems just unnecessary and confusing.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
