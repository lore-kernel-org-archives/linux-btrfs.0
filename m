Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51772 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752323AbcLTQFb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Dec 2016 11:05:31 -0500
Date: Tue, 20 Dec 2016 17:05:13 +0100
From: David Sterba <dsterba@suse.cz>
To: Seraphime Kirkovski <kirkseraph@gmail.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, jbacik@fb.com, clm@fb.com
Subject: Re: [PATCH 4/4] Btrfs: code cleanup min/max -> min_t/max_t
Message-ID: <20161220160513.GK3620@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161215133828.25791-1-kirkseraph@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161215133828.25791-1-kirkseraph@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 15, 2016 at 02:38:28PM +0100, Seraphime Kirkovski wrote:
> This cleans up the cases where the min/max macros were used with a cast
> rather than using directly min_t/max_t.
> 
> Signed-off-by: Seraphime Kirkovski <kirkseraph@gmail.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Added to cleanups branch, thanks.
