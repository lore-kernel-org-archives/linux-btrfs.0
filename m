Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56715 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934836AbeE2Owo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 May 2018 10:52:44 -0400
Date: Tue, 29 May 2018 16:49:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] Btrfs: remove unused check of skip_locking
Message-ID: <20180529144959.GA4325@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1526612424-97061-5-git-send-email-bo.liu@linux.alibaba.com>
 <1527600426-131024-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1527600426-131024-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 29, 2018 at 09:27:06PM +0800, Liu Bo wrote:
> The check is superfluous since all of callers who set search_for_commit
> also have skip_locking set.
> 
> ASSERT() is put in place to ensure skip_locking is set by callers.
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Added to the rest, thanks.
