Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50077 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755805AbdABPQV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jan 2017 10:16:21 -0500
Date: Mon, 2 Jan 2017 16:16:04 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com
Subject: Re: [PATCH] btrfs: Replace ACCESS_ONCE with (READ|WRITE)_ONCE
Message-ID: <20170102151604.GI12081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1482750489-13666-1-git-send-email-n.borisov.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1482750489-13666-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 26, 2016 at 01:08:09PM +0200, Nikolay Borisov wrote:
> Use the newer and standardized functions when performing volatile
> accesses. Following text is taken from 4d3199e4ca8e
> ("locking: Remove ACCESS_ONCE() usage") :
> 
>     ACCESS_ONCE() does not work reliably on non-scalar types.
>     For example gcc 4.6 and 4.7 might remove the volatile tag
>     for such accesses during the SRA (scalar replacement of
>     aggregates) step:
> 	https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145
> 
> Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>

A patch fort that has been sent and queued already,
https://patchwork.kernel.org/patch/9476137/
