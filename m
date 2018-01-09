Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:46206 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754338AbeAIRbE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 12:31:04 -0500
Received: by mail-qk0-f177.google.com with SMTP id l12so19144513qke.13
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 09:31:04 -0800 (PST)
Date: Tue, 9 Jan 2018 12:31:03 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 05/10] Btrfs: add extent map selftests
Message-ID: <20180109173102.iky3zwc5rhsur3vl@destiny>
References: <20180105195117.5131-1-bo.li.liu@oracle.com>
 <20180105195117.5131-6-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180105195117.5131-6-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 05, 2018 at 12:51:12PM -0700, Liu Bo wrote:
> We've observed that btrfs_get_extent() and merge_extent_mapping() could
> return -EEXIST in several cases, and they are caused by some racy
> condition, e.g dio read vs dio write, which makes the problem very tricky
> to reproduce.
> 
> This adds extent map selftests in order to simulate those racy situations.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
