Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:42519 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751795AbeAZOFW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 09:05:22 -0500
Received: by mail-qt0-f181.google.com with SMTP id c2so1457444qtn.9
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 06:05:21 -0800 (PST)
Date: Fri, 26 Jan 2018 09:05:20 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix extent state leak from tree log
Message-ID: <20180126140520.3cyb53ttwayadqu6@destiny>
References: <20180125180256.10844-5-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180125180256.10844-5-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 25, 2018 at 11:02:52AM -0700, Liu Bo wrote:
> It's possible that btrfs_sync_log() bails out after one of the two
> btrfs_write_marked_extents() which convert extent state's state bit into
> EXTENT_NEED_WAIT from EXTENT_DIRTY/EXTENT_NEW, however only EXTENT_DIRTY
> and EXTENT_NEW are searched by free_log_tree() so that those extent states
> with EXTENT_NEED_WAIT lead to memory leak.
> 
> cc: <stable@vger.kernel.org>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
