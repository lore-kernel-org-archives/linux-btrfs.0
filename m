Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35270 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbcFWJnY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 05:43:24 -0400
Date: Thu, 23 Jun 2016 11:43:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <kernel@kyup.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, dsterba@suse.com
Subject: Re: On shrinkable caches
Message-ID: <20160623094347.GX4915@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5767D2D4.4090709@kyup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5767D2D4.4090709@kyup.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 20, 2016 at 02:26:12PM +0300, Nikolay Borisov wrote:
> I have a question regarding the SLAB_RECLAIM_ACCOUNT flag with which
> BTRFS caches are created. Currently there isn't a single usage of
> register_shrinker under fs/btrfs.

The SLAB_RECLAIM_ACCOUNT flag has been there since the first versions in
2007 (when shrinkeres did not exist) but I can't find any specific
reason why.

> Apart from the inode cache which is
> being shrunk from the generic super_cache_scan I don't think the memory
> used for those caches should be accounted as reclaimable?

I agree, in most cases I don't see any possibility to reclaim the
objects earlier than the explicit free.
