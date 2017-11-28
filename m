Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40767 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753883AbdK1PeG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 10:34:06 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2B6C2AE6F
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Nov 2017 15:34:05 +0000 (UTC)
Date: Tue, 28 Nov 2017 16:32:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 3/7] btrfs-progs: mkfs: Only zero out the first 1M for
 rootdir
Message-ID: <20171128153208.GQ3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171020015907.25430-1-wqu@suse.com>
 <20171020015907.25430-4-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171020015907.25430-4-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 20, 2017 at 09:59:03AM +0800, Qu Wenruo wrote:
> It's a waste of IO to fill the whole image before creating btrfs on it,
> just wiping the first 1M, and then write 1 byte to the last position to
> create a sparse file.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.
