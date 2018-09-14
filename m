Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45732 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726845AbeINTba (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 15:31:30 -0400
Date: Fri, 14 Sep 2018 16:16:46 +0200
From: David Sterba <dsterba@suse.cz>
To: zhong jiang <zhongjiang@huawei.com>
Cc: dsterba@suse.com, jbacik@fb.com, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/2] btrfs: change remove_extent_mapping to be void
 function
Message-ID: <20180914141646.GG5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1536807675-25086-1-git-send-email-zhongjiang@huawei.com>
 <1536807675-25086-3-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1536807675-25086-3-git-send-email-zhongjiang@huawei.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 13, 2018 at 11:01:15AM +0800, zhong jiang wrote:
> remove_extent_mapping use the variable "ret" for return value,
> but it is not modified after initialzation. Further, I find that
> any of the callers do not handle the return value, so it is safe
> to drop the unneeded "ret" and make it to be void function.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

Reviewed-by: David Sterba <dsterba@suse.com>
