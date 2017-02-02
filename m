Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45826 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751880AbdBBRjR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Feb 2017 12:39:17 -0500
Date: Thu, 2 Feb 2017 18:38:48 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: pass delayed_refs directly to
 btrfs_find_delayed_ref_head
Message-ID: <20170202173848.GC16723@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1485807877-16883-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1485807877-16883-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 30, 2017 at 12:24:37PM -0800, Liu Bo wrote:
> All we need is @delayed_refs, all callers have get it ahead of calling
> btrfs_find_delayed_ref_head since lock needs to be acquired firstly, there is
> no reason to deference it again inside the function.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
