Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34567 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932505AbeCEVlj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Mar 2018 16:41:39 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 030A4AF63
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Mar 2018 21:41:38 +0000 (UTC)
Date: Mon, 5 Mar 2018 22:39:18 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: free-space-cache: Use DIV_ROUND_UP() to
 replace open code
Message-ID: <20180305213918.GI5942@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180305080912.5417-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180305080912.5417-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 05, 2018 at 04:09:12PM +0800, Qu Wenruo wrote:
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.
