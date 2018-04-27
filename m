Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44118 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757457AbeD0QMt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 12:12:49 -0400
Date: Fri, 27 Apr 2018 18:10:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 12/16] btrfs: track running balance in a simpler way
Message-ID: <20180427161012.GE21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1524146555.git.dsterba@suse.com>
 <6d512cf2c8f825592703ee0d45c51f22396e6078.1524146556.git.dsterba@suse.com>
 <2e28020f-ef28-ee43-d9e3-1c74c03a472d@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2e28020f-ef28-ee43-d9e3-1c74c03a472d@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 27, 2018 at 10:10:24AM +0800, Anand Jain wrote:
> 
> 
> On 04/20/2018 12:33 AM, David Sterba wrote:
> > Currently fs_info::balance_running is 0 or 1 and does not use the
> > semantics of atomics. The pause and cancel check for 0, that can happen
> > only after __btrfs_balance exits for whatever reason.
> > 
> > Parallel calls to balance ioctl may enter btrfs_ioctl_balance multiple
> > times but will block on the balance_mutex that protects the
> > fs_info::flags bit.
> > 
> > Signed-off-by: David Sterba <dsterba@suse.com>
> 
>   Though it appears to me that we could optimize the lock and atomic bit
>   usage a little more, however it can be taken for the next round of
>   cleanups. So for now..
> 
>   Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, patches updated.
