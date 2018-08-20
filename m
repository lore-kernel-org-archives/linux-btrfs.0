Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37318 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726689AbeHTQ4w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Aug 2018 12:56:52 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 604EBAE6D
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Aug 2018 13:41:09 +0000 (UTC)
Date: Mon, 20 Aug 2018 15:40:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/2] btrfs-progs: completion: Small fixes to make
 debug simpler
Message-ID: <20180820134058.GW24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180813060244.8795-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180813060244.8795-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 13, 2018 at 02:02:42PM +0800, Qu Wenruo wrote:
> For developer, it's pretty common to use "btrfs check" or "btrfs ins
> dump-tree" on raw dumps.
> Even for end user, they may hit case where they need to run "btrfs check"
> on raw images.
> 
> However "btrfs check" can only complete real block devices, and
> "btrfs inspect dump-tree" can only complete dir.
> 
> Make them to use _filedir() so any filename can be completed and save us
> developer a little time and nerve hitting that holy tab.
> 
> changelog:
> v2:
>   Discard _btrfs_dev() macro completely.
> 
> Qu Wenruo (2):
>   btrfs-progs: completion: Use _filedir() to replace _btrfs_devs()
>   btrfs-progs: completion: Let dump-tree/dump-super/inode-resolve to
>     accept any file

Applied, thanks.
