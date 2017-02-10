Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37921 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752608AbdBJPpe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Feb 2017 10:45:34 -0500
Date: Fri, 10 Feb 2017 16:43:51 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 2/2] Btrfs: use helper to simplify lock/unlock pages
Message-ID: <20170210154351.GH16928@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1486086563-25543-1-git-send-email-bo.li.liu@oracle.com>
 <1486086563-25543-2-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1486086563-25543-2-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 02, 2017 at 05:49:23PM -0800, Liu Bo wrote:
> Since we have a helper to set page bits, let lock_delalloc_pages and
> __unlock_for_delalloc use it.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

I've separated the changes of __process_pages_contig to another patch,
just moving hunks.
