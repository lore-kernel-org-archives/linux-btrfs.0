Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40807 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756898AbbIYPUt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 11:20:49 -0400
Date: Fri, 25 Sep 2015 17:19:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] Fix for btrfs-convert chunk type and fsck support
Message-ID: <20150925151951.GI11442@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1441852458-10289-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150911145638.GP8891@twin.jikos.cz>
 <56034F7B.5050107@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56034F7B.5050107@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 24, 2015 at 09:18:51AM +0800, Qu Wenruo wrote:
> After some ext* lecture given by my teammate, Wang Xiaoguang, I'm more 
> convinced that, at least for convert from ext*, separate chunk type will 
> not be a good idea.

Thanks for the additional research.

> For above almost empty ext4 case, it will cause less problem, as
> we can batch several groups and put a large data chunk to cover them,
> then allocate a 100+M metadata chunk.

> But if the filesystem is used and most group only has scattered 
> available space, we may ended up unable to alloc any metadata chunk.

I think this is the price we pay for the in-place conversion, we can
safely use only the free space and respect the constraints it gives.
As long as the ext2_subvol exists, ie. the original data and metadata
are pinned, we don't have much choice. Rebalancing is possible but given
the remaining space may fail to allocate block groups of desired size.

> This will make the usage of limited block group quite limited.
> Although I'll continue add such support for btrfs-convert, I'm quite 
> concerned about the usage...

So can we do it like this:

1) enable support for mixed bg in convert
2) implement mixed -> split conversion in balance
3) force convert to do mixed bgs by default

The conversion from/to mixed would be good on it's own but may not be
trivial to implement. If the main concern about result of conversion is
bad bg layout, I'd say that we rely on balance to reshuffle the bgs to
make the filesystem more up to the desired layout.
