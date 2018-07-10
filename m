Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38230 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932752AbeGJKaG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 06:30:06 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9B2CEAE61
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2018 10:30:05 +0000 (UTC)
Date: Tue, 10 Jul 2018 12:30:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove unused function
 btrfs_account_dev_extents_size()
Message-ID: <20180710103002.GO3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180709065254.1773-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180709065254.1773-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 09, 2018 at 02:52:54PM +0800, Qu Wenruo wrote:
> This function is never used by any one in kernel, just remove it.

It's good to note when and why the function got unused. In this case
it's after removal of alloc_start mount option in
0d0c71b317207082856f40dbe8a2bac813f49677 "btrfs: obsolete and remove
mount option alloc_start" . I'll update the changelog, thanks.
