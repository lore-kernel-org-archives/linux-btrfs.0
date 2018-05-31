Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45915 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754304AbeEaMFz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 May 2018 08:05:55 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 77840ACBF
        for <linux-btrfs@vger.kernel.org>; Thu, 31 May 2018 12:05:54 +0000 (UTC)
Date: Thu, 31 May 2018 14:03:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/1] btrfs-progs: dump-tree: allow -b multiple times
Message-ID: <20180531120310.GT3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180406061202.6529-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180406061202.6529-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 06, 2018 at 02:12:01PM +0800, Qu Wenruo wrote:
> Although just one patch, it needs the extent buffer cleanup code as
> basis, so please fetch it from my github repo:
> https://github.com/adam900710/btrfs-progs/tree/dump_tree_multi_blocks

Could you please refresh the patch on a recent devel? The branches have
diverged too much over time, sorry.
