Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24644 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751944AbdESAEk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 20:04:40 -0400
Date: Thu, 18 May 2017 17:02:12 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: cleanup root usage by btrfs_get_alloc_profile
Message-ID: <20170519000211.GE23822@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1495035516-3217-1-git-send-email-jeffm@suse.com>
 <1495035516-3217-2-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1495035516-3217-2-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 17, 2017 at 11:38:35AM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> There are two places where we don't already know what kind of alloc
> profile we need before calling btrfs_get_alloc_profile, but we need
> access to a root everywhere we call it.
> 
> This patch adds helpers for btrfs_{data,metadata,system}_alloc_profile()
> and relegates btrfs_system_alloc_profile to a static for use in those
> two cases.  The next patch will eliminate one of those.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
