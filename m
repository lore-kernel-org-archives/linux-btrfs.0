Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36801 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750817AbeCFLaj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Mar 2018 06:30:39 -0500
Date: Tue, 6 Mar 2018 12:28:18 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: replace: cache rbio when rebuild data on missing
 device
Message-ID: <20180306112818.GN5942@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180302231041.10442-2-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180302231041.10442-2-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 02, 2018 at 04:10:38PM -0700, Liu Bo wrote:
> Rebuild on missing device is as same as recover, after it's done, rbio
> has data which is consistent with on-disk data, so it can be cached to
> avoid further reads.

Please add a comment that describes why the READ and REBUILD can be
merged together, it's not obvious from the code.
