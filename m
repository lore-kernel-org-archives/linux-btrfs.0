Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40208 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932745AbeGDL6Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Jul 2018 07:58:25 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AD32BAD24
        for <linux-btrfs@vger.kernel.org>; Wed,  4 Jul 2018 11:58:24 +0000 (UTC)
Date: Wed, 4 Jul 2018 13:58:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Don't BUG_ON() if we failed to load one
 device or one chunk
Message-ID: <20180704115823.GN3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180703134040.8108-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180703134040.8108-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 03, 2018 at 09:40:40PM +0800, Qu Wenruo wrote:
> Don't panic for btrfs_read_chunk_tree() if one device or chunk is
> corrupted.
> Caller can already handle it pretty well.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=199839
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.

In case there's a fuzzed image, please send it too. There are example
commits how to name, format and document it. Thanks.
