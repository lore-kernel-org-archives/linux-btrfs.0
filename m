Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52118 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725868AbeIERmQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Sep 2018 13:42:16 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E4ACDAE88
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Sep 2018 13:12:01 +0000 (UTC)
Date: Wed, 5 Sep 2018 15:11:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: qgroup: Don't trace subtree if we're dropping
 tree reloc tree
Message-ID: <20180905131146.GX24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180905050339.5356-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180905050339.5356-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 05, 2018 at 01:03:39PM +0800, Qu Wenruo wrote:
> Tree reloc tree doesn't contribute to qgroup numbers, as we have

I think you can call it just 'reloc tree', I'm fixing that in all
changelogs and comments anyway.

> accounted them at balance time (check replace_path()).
> 
> Skip such unneeded subtree trace should reduce some performance
> overhead.

Please provide some numbers or description of the improvement. There are
several performance problems caused by qgroups so it would be good to
get a better idea how much this patch is going to help. Thanks.
