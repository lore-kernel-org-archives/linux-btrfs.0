Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:38333 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753926AbdHURsD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 13:48:03 -0400
Received: by mail-qk0-f173.google.com with SMTP id k126so2932391qkb.5
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 10:48:02 -0700 (PDT)
Date: Mon, 21 Aug 2017 13:48:01 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: make plug in writing meta blocks really work
Message-ID: <20170821174800.GF23807@destiny>
References: <20170818174207.21613-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170818174207.21613-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 18, 2017 at 11:42:07AM -0600, Liu Bo wrote:
> We have started plug in btrfs_write_and_wait_marked_extents() but the
> generated IOs actually go to device's schedule IO list where the work
> is doing in another task, thus the started plug doesn't make any
> sense.
> 
> And since we wait for IOs immediately after writing meta blocks, it's
> the same case as writing log tree, doing sync submit can merge more
> IOs.
> 

We're plugging when we do the per-device scheduled IO right?  So we aren't
really gaining anything by it being async.  Also we do a lot of work between the
time that we start writing the marked extents for the tree-log and when we
actually wait for them, so we really don't want to do a synchronous write out in
that case.  Instead move the sync_writers into write_and_wait_marked_extents.
Thanks,

Josef
