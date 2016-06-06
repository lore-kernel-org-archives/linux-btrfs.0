Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54344 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbcFFIWW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jun 2016 04:22:22 -0400
Date: Mon, 6 Jun 2016 10:21:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] btrfs: return all mirror whether need_raid_map set
 or not
Message-ID: <20160606082139.GS29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1450177455.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1450177455.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 15, 2015 at 07:09:48PM +0800, Zhao Lei wrote:
> __btrfs_map_block() should return all mirror on WRITE,
> REQ_GET_READ_MIRRORS, and RECOVERY case, whether need_raid_map set
> or not.
> 
> need_raid_map only used to control is to set bbio->raid_map.
> 
> Current code works right becuase there is only one caller can
> trigger above bug, which is readahead, and this function happened
> to bypass on less mirror.
> 
> But after we fixed __btrfs_map_block(), readahead will be really
> works, and exit with warning at another bug.
> This patchset fixed __btrfs_map_block(), and disable raid56
> readahead temp temporary, (actually, it already disable by this bug),
> and I'll fix raid56 readahead next.
> 
> Zhao Lei (4):
>   btrfs: Disable raid56 readahead
>   btrfs: return all mirror whether need_raid_map set or not
>   btrfs: Small cleanup for get index_srcdev loop
>   btrfs: Use direct way to determine raid56 write/recover mode

Are these patches still relevant? If yes, please update and resed,
thanks.
