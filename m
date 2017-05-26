Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58693 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754221AbdEZQWA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 12:22:00 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 03CD6ABB1
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 16:21:59 +0000 (UTC)
Date: Fri, 26 May 2017 18:20:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: rename btrfs_leaf_data to
 BTRFS_LEAF_DATA_OFFSET
Message-ID: <20170526162059.GD30842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1495448171-20606-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1495448171-20606-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 22, 2017 at 01:16:10PM +0300, Nikolay Borisov wrote:
> +static inline unsigned long BTRFS_LEAF_DATA_OFFSET(void)
> +{
> +	return offsetof(struct btrfs_leaf, items);
> +}

Can we make it a simple macro? Functions in place of macros are useful
for type checking, but the parameter is gone.
