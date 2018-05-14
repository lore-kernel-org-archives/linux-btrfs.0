Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57463 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752333AbeENOmM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 10:42:12 -0400
Date: Mon, 14 May 2018 16:39:30 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix duplicate extents after fsync of file with
 prealloc extents
Message-ID: <20180514143930.GK6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180509150146.13331-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180509150146.13331-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 09, 2018 at 04:01:46PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
...
> Fixes: 471d557afed1 ("Btrfs: fix loss of prealloc extents past i_size after fsync log replay")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Thanks for the excellent and very educational writeup!

Added to 4.17-rc queue as it fixes a regression.
