Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44502 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728063AbeGPQSG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 12:18:06 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2FC55AF3A
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 15:50:05 +0000 (UTC)
Date: Mon, 16 Jul 2018 17:49:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: Exit gracefully when overlap chunks are
 detected
Message-ID: <20180716154958.GM3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180709065054.1392-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180709065054.1392-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 09, 2018 at 02:50:53PM +0800, Qu Wenruo wrote:
> BUG_ON() can be triggered if some image contains overlap chunks.
> volumes.c:1930: read_one_chunk: BUG_ON `ret` triggered, value -17
> btrfs(+0x2cf12)[0x5601efa17f12]
> btrfs(+0x2fd8b)[0x5601efa1ad8b]
> btrfs(btrfs_read_chunk_tree+0x2bf)[0x5601efa1b30f]
> btrfs(btrfs_setup_chunk_tree_and_device_map+0xe8)[0x5601efa07718]
> btrfs(+0x1c944)[0x5601efa07944]
> btrfs(open_ctree_fs_info+0x90)[0x5601efa07b90]
> btrfs(cmd_check+0x4d7)[0x5601efa4f8c7]
> btrfs(main+0x88)[0x5601ef9fd768]
> /usr/lib/libc.so.6(__libc_start_main+0xeb)[0x7f3c7787306b]
> btrfs(_start+0x2a)[0x5601ef9fd88a]
> 
> Extent cache code can already detect it without problem, we only need to
> remove the BUG_ON() and exit gracefully.
> 
> Reported-by: Xu Wen <wen.xu@gatech.edu>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=200409
> Signed-off-by: Qu Wenruo <wqu@suse.com>

1 and 2 applied, thanks.
