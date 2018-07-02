Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34018 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753258AbeGBWUk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 18:20:40 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0CDC9AD52
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Jul 2018 22:20:39 +0000 (UTC)
Date: Tue, 3 Jul 2018 00:20:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: free-space-cache: Don't panic when free
 space cache is corrupted
Message-ID: <20180702222033.GG3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180701024526.25740-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180701024526.25740-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 01, 2018 at 10:45:26AM +0800, Qu Wenruo wrote:
> In btrfs_add_free_space(), if the free space to be added is already
> here, we trigger ASSERT() which is just another BUG_ON().
> 
> Let's remove such BUG_ON() at all.
> 
> Reported-by: Lewis Diamond <me@lewisdiamond.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.
