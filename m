Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39511 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751447AbeAaPkn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 10:40:43 -0500
Date: Wed, 31 Jan 2018 16:38:29 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix null pointer dereference when replacing
 missing device
Message-ID: <20180131153829.GE18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180130184022.1033-1-fdmanana@kernel.org>
 <d5510c90-f80b-2e2a-d7c6-981c9bcff483@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d5510c90-f80b-2e2a-d7c6-981c9bcff483@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 31, 2018 at 11:25:49AM +0800, Anand Jain wrote:
> > This is trivially reproduced by running the test btrfs/027 from fstests
> > like this:
> > 
> >    $ MOUNT_OPTIONS="-o discard" ./check btrfs/027
> > 
> > Fix this by skipping devices without a backing device before attempting
> > to discard.
> > 
> > Fixes: 38b5f68e9811 ("btrfs: drop btrfs_device::can_discard to query directly")
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
>   oh no, I missed the context of degraded when writing this patch.
>   Thanks for the fix.
> 
>   Reviewed-by: Anand Jain <anand.jain@oracle.com>

Added to next and will add it to the next 4.16 pull.
