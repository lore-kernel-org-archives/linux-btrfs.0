Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:41955 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752547AbeAIRcE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 12:32:04 -0500
Received: by mail-qt0-f193.google.com with SMTP id i40so18748485qti.8
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 09:32:04 -0800 (PST)
Date: Tue, 9 Jan 2018 12:32:03 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 06/10] Btrfs: extent map selftest: buffered write vs
 dio read
Message-ID: <20180109173202.tesyzx5mglvcaf6s@destiny>
References: <20180105195117.5131-1-bo.li.liu@oracle.com>
 <20180105195117.5131-7-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180105195117.5131-7-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 05, 2018 at 12:51:13PM -0700, Liu Bo wrote:
> This test case simulates the racy situation of buffered write vs dio
> read, and see if btrfs_get_extent() would return -EEXIST.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
