Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35263 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391251AbeIVCJt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Sep 2018 22:09:49 -0400
Received: by mail-pf1-f194.google.com with SMTP id p12-v6so6455575pfh.2
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Sep 2018 13:19:20 -0700 (PDT)
Date: Fri, 21 Sep 2018 13:19:18 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/6] btrfs-progs: Pull free space tree related code from
 kernel
Message-ID: <20180921201918.GD31081@vader>
References: <1529060762-4372-1-git-send-email-nborisov@suse.com>
 <1529060762-4372-4-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1529060762-4372-4-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 15, 2018 at 02:05:59PM +0300, Nikolay Borisov wrote:
> To help implement free space tree checker in user space some kernel
> function are necessary, namely iterating/deleting/adding freespace
> items, some internal search functions. Functions to populate a block
> group based on the extent tree. The code is largely copy/paste from
> the kernel with locking eliminated (i.e free_space_lock). It supports
> reading/writing of both bitmap and extent based FST trees.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Why doesn't this include the bitmap <-> extent conversions? If we end up
rebuilding the free space tree, we're never going to use the bitmap
format, which sucks if the free space is fragmented.
