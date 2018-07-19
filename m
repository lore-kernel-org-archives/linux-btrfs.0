Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60352 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731442AbeGSOoo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 10:44:44 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DBBC1AE5C
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 14:01:24 +0000 (UTC)
Date: Thu, 19 Jul 2018 16:01:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] btrfs: scrub: Cleanup the nodatasum fixup code
Message-ID: <20180719140115.GQ26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180711054122.13727-1-wqu@suse.com>
 <20180711054122.13727-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180711054122.13727-2-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 11, 2018 at 01:41:22PM +0800, Qu Wenruo wrote:
> Since we no longer use the old method, which use inode page cache and
> could cause serious data corruption for compressed nodatasum extent, to
> fixup nodatasum error during scrub/replace, remove all related code.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

The compiler warns that scrub_pending_trans_workers_inc and
scrub_pending_trans_workers_dec are now unused and it's right. I'll
delete the code as well. The last callers got removed by this patch.
