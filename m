Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42608 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964938AbbDXPFq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Apr 2015 11:05:46 -0400
Date: Fri, 24 Apr 2015 17:05:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] btrfs: Add extra check for sub_stripes to avoid
 hostile 0 division attack.
Message-ID: <20150424150545.GR4996@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1429837961-2255-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1429837961-2255-2-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1429837961-2255-2-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 24, 2015 at 09:12:41AM +0800, Qu Wenruo wrote:
> Although only RAID10 use sub_stripes, a hostile attack can modify chunk
> tree and just add RAID10 bit to a single chunk.
> Then btrfs_map_block will trigger a 0 division in kernel and destroy
> everything.
> 
> Just add extra check when reading chunk from disk.
> 
> Reported-by: Lukas Lueg <lukas.lueg@gmail.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
