Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58011 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750977AbeERQCy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 12:02:54 -0400
Date: Fri, 18 May 2018 18:00:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/6] Btrfs: use more straightforward
 extent_buffer_uptodate
Message-ID: <20180518160010.GR6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
 <1526612424-97061-3-git-send-email-bo.liu@linux.alibaba.com>
 <dc89782c-b9d2-cd1c-4e5e-a308dd647962@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <dc89782c-b9d2-cd1c-4e5e-a308dd647962@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 18, 2018 at 01:17:16PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年05月18日 11:00, Liu Bo wrote:
> > If parent_transid "0" is passed to btrfs_buffer_uptodate(),
> > btrfs_buffer_uptodate() is equivalent to extent_buffer_uptodate(), but
> > extent_buffer_uptodate() is preferred since we don't have to look into
> > verify_parent_transid().
> > 
> > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> 
> And considering how little extra work we do in btrfs_buffer_uptodate(),
> what about make it an inline function?

The actual picture as the compiler sees the function can be quite
different, eg if there are static functions called from that one, they
could get inlined and suddenly btrfs_buffer_uptodate becomes
btrfs_buffer_uptodate + verify_parent_transid.

IOW, leave the inlining on the compiler and use 'static inline' only for
really lightweight functions.
