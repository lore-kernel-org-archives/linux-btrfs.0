Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41209 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752440AbdK1PnL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 10:43:11 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CCEA2AE70
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Nov 2017 15:43:09 +0000 (UTC)
Date: Tue, 28 Nov 2017 16:41:13 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 6/7] btrfs-progs: mkfs: Update allocation info before
 verbose output
Message-ID: <20171128154113.GS3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171020015907.25430-1-wqu@suse.com>
 <20171020015907.25430-7-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171020015907.25430-7-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 20, 2017 at 09:59:06AM +0800, Qu Wenruo wrote:
> Since new --rootdir can allocate chunk, it will modify the chunk
> allocation result.
> 
> This patch will update allocation info before verbose output to reflect
> such info.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.
