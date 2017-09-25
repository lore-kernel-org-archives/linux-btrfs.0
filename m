Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52909 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932698AbdIYOKV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 10:10:21 -0400
Date: Mon, 25 Sep 2017 16:08:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, josef@toxicpanda.com
Subject: Re: [PATCH] btrfs: Remove memory barrier from block_group_cache_done
Message-ID: <20170925140847.GG31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1504110942-23146-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1504110942-23146-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 30, 2017 at 07:35:42PM +0300, Nikolay Borisov wrote:
> This memory barrier was introduced in 817d52f8dba2 ("Btrfs: async block group
> caching"), but even at that time it's usage was broken since it didn't pair
> with anything. There was one situation where the cached member was set to
> BTRFS_CACHE_FINISHED in a spinlock region which *might* have acted as a pairing
> barrier. Since there is no clear semantics how it's supposed to work better
> to just remove it.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

As discussed offline, this needs a better description that removing the
barrier will not break it.
