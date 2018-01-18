Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44806 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932473AbeARPTV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Jan 2018 10:19:21 -0500
Date: Thu, 18 Jan 2018 16:17:11 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: do not cache rbio pages if using raid6 recover
Message-ID: <20180118151711.GO13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180113010702.25612-2-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180113010702.25612-2-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 12, 2018 at 06:07:02PM -0700, Liu Bo wrote:
> Since raid6 recover tries all possible combinations of failed stripes,
> 
> - when raid6 rebuild algorithm is used, i.e. raid6_datap_recov() and
>   raid6_2data_recov(), it may change the in-memory content of failed
>   stripes, if such a raid bio is cached, a later raid write rmw or recover
>   can steal @stripe_pages from it instead of reading from disks, such that
>   it carries the wrong content to do write rmw or recovery and ends up
>   with corruption or recovery failures.
> 
> - when raid5 rebuild algorithm is used, i.e. xor, raid bio can be cached
>   because the only failed stripe which contains @rbio->bio_pages gets
>   modified, others remain the same so that their in-memory content is
>   consistent with their on-disk content.
> 
> This adds a check to skip caching rbio if using raid6 recover.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Added to 4.16 queue, thanks.
