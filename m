Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43625 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933377AbcIVPM1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 11:12:27 -0400
Date: Thu, 22 Sep 2016 17:10:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: fix memory leak in do_walk_down
Message-ID: <20160922151025.GQ16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1473818547-615-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1473818547-615-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 13, 2016 at 07:02:27PM -0700, Liu Bo wrote:
> The extent buffer 'next' needs to be free'd conditionally.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Josef's patch contained this fix but mixed with other (removing BUG_ON).
I've removed it so we can merge both patches, for sake of better change
separation.
