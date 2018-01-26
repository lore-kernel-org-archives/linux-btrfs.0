Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:46579 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752260AbeAZOCv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 09:02:51 -0500
Received: by mail-qt0-f179.google.com with SMTP id o35so1408307qtj.13
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 06:02:50 -0800 (PST)
Date: Fri, 26 Jan 2018 09:02:49 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix deadlock in run_delalloc_nocow
Message-ID: <20180126140248.mv5ddt7mtrhyipgv@destiny>
References: <20180125180256.10844-3-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180125180256.10844-3-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 25, 2018 at 11:02:50AM -0700, Liu Bo wrote:
> @cur_offset is not set back to what it should be (@cow_start) if
> btrfs_next_leaf() returns something wrong, and the range [cow_start,
> cur_offset) remains locked forever.
> 
> cc: <stable@vger.kernel.org>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
