Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21242 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966166AbcIVR6I (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 13:58:08 -0400
Date: Thu, 22 Sep 2016 10:57:58 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix memory leak in do_walk_down
Message-ID: <20160922175753.GA12906@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1473818547-615-1-git-send-email-bo.li.liu@oracle.com>
 <20160922151025.GQ16983@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160922151025.GQ16983@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 22, 2016 at 05:10:25PM +0200, David Sterba wrote:
> On Tue, Sep 13, 2016 at 07:02:27PM -0700, Liu Bo wrote:
> > The extent buffer 'next' needs to be free'd conditionally.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> 
> Reviewed-by: David Sterba <dsterba@suse.com>
> 
> Josef's patch contained this fix but mixed with other (removing BUG_ON).
> I've removed it so we can merge both patches, for sake of better change
> separation.

Good to know that, thank you for the efforts.

Thanks,

-liubo
