Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51579 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752334AbdIXNGP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Sep 2017 09:06:15 -0400
Date: Sun, 24 Sep 2017 15:04:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: fix kernel oops while reading compressed data
Message-ID: <20170924130441.GQ29043@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170920235019.10508-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170920235019.10508-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 20, 2017 at 05:50:18PM -0600, Liu Bo wrote:
> The kernel oops happens at
> 
> kernel BUG at fs/btrfs/extent_io.c:2104!
> ...
> RIP: clean_io_failure+0x263/0x2a0 [btrfs]
> 
> It's showing that read-repair code is using an improper mirror index.
> This is due to the fact that compression read's endio hasn't recorded
> the failed mirror index in %cb->orig_bio.

This sounds like the corner case of raid1 repair that was reported i the
past and actually is the only thing because of which we are not so
comfortable to mark raid1 'completely ok' in the Status page.
