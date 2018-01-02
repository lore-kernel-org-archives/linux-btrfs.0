Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40683 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751024AbeABSDS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Jan 2018 13:03:18 -0500
Date: Tue, 2 Jan 2018 19:01:12 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: factor btrfs_check_rw_degradable() to check given
 device
Message-ID: <20180102180112.GZ3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171218090859.8141-1-anand.jain@oracle.com>
 <00433e34-a56e-3898-80b9-32a304fe32e2@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <00433e34-a56e-3898-80b9-32a304fe32e2@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 18, 2017 at 05:46:59PM +0800, Qu Wenruo wrote:
> 
> 
> On 2017年12月18日 17:08, Anand Jain wrote:
> > Update btrfs_check_rw_degradable() to check against the given
> > device if its lost.
> > 
> > We can use this function to know if the volume is going to be
> > in degraded mode OR failed state, when the given device fails.
> > Which is needed when we are handling the device failed state.
> > 
> > A preparatory patch does not affect the flow as such.
> > 
> > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> Looks good.
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>

Added to 4.16 queue, thanks.
