Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41126 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030228AbeFSR4M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 13:56:12 -0400
Date: Tue, 19 Jun 2018 19:53:19 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org, robbieko@synology.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix physical offset reported by fiemap for inline
 extents
Message-ID: <20180619175319.GU24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180619113142.9020-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180619113142.9020-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 19, 2018 at 12:31:42PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> So fix this by ensuring the physical offset is always set to 0 when we
> are processing an inline extent.
> 
> Fixes: 9d311e11fc1f ("Btrfs: fiemap: pass correct bytenr when fm_extent_count is zero")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to 4.18 queue, thanks.

This is a fix for a patch that was in for-next for a few weeks but the
bug was discovered only after the patch got merged to master. I wonder
if there's something to be improved in the patch flow.

I think it should take less time to catch bugs while the patches are
unmerged, either in the mailinglist or in the development branches.
Post-merge fixes will happen of course, but in this particular case it
looks like something that slipped too easily. I did the "fallback"
review and checked that tests regarding fiemap pass, the occasional
failure you mention has not happened on any of my testing setups.

There's another patch for fiemap that seems to have bigger impact and
for that reason I have postponed merging it to 4.18 unlike the first
one, but now I think this requires a testcase.

https://patchwork.kernel.org/patch/10383491/

The patch will be in for-next topic branch until then.
