Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40968 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727760AbeHWQZ6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Aug 2018 12:25:58 -0400
Date: Thu, 23 Aug 2018 14:56:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: use next_state in find_first_extent_bit
Message-ID: <20180823125610.GL24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1534965293-70614-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534965293-70614-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 23, 2018 at 03:14:53AM +0800, Liu Bo wrote:
> As next_state() is already defined to get the next state, update us to use
> the helper.
> 
> No functional changes.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Added to misc-next, thanks.
