Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:30952 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727152AbeIMRc6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 13:32:58 -0400
Date: Thu, 13 Sep 2018 20:23:37 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Nikolay Borisov <nborisov@suse.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/3] Misc refactoring of check_file_extent
Message-ID: <20180913122337.GH2790@fnst.localdomain>
References: <20180913120507.18197-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20180913120507.18197-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 13, 2018 at 03:05:04PM +0300, Nikolay Borisov wrote:
>While looking at check_file_extent I thought that the code might be a bit 
>cleaner than it actually is and cleaner as well. The first patch factors out 
>the code dealing with inline extents into a separate function aptly named 
>check_file_extent_inline. This allows to remove some inline-specific variable 
>from check_file_extent. Patch 2 just moves the final check in the new function 
>into the already existing branch handling the !compressed case. Finally 
>the check which detects unknown extent types is moved first in check_file_extent, 
>followed by the code to handle inline extents and finally the existing code to 
>handle regular/prealloc extents is left intact. 
>
>This patchset brings no functional changes. 

For the series,

Reviewed-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

-- 
Thanks,
Lu

>
>Nikolay Borisov (3):
>  btrfs-progs: check: lowmem: Factor out inline extent checking code in
>    its own function
>  btrfs-progs: check: lowmem: Refactor extent len test in
>    check_file_extent_inline
>  btrfs-progs: check: lowmem: Refactor extent type checks in
>    check_file_extent
>
> check/mode-lowmem.c | 151 ++++++++++++++++++++++++++------------------
> 1 file changed, 89 insertions(+), 62 deletions(-)
>
>-- 
>2.17.1
>
>
>
