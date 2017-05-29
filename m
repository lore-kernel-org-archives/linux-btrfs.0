Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54096 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751025AbdE2Nxn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 May 2017 09:53:43 -0400
Date: Mon, 29 May 2017 15:52:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] fixup: btrfs: reduce arguments for decompress_bio ops
Message-ID: <20170529135242.GF14523@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170526074500.20342-3-anand.jain@oracle.com>
 <20170526223633.23575-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170526223633.23575-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 27, 2017 at 06:36:33AM +0800, Anand Jain wrote:
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> Hi David,
>  I note the original patch [1] is already queued so here I am sending
>  a fix-up patch can you pls squash this to [1]
>   [1]
>    [PATCH 2/3 v2] btrfs: reduce arguments for decompress_bio ops
> 
>  This fixup patch, fixes issues reported by kbuild test robot which
>  reported the build failure with ARCH=s390, looking at what was missed
>  i.e to include refcount.h it puzzles me why there wasn't such an error
>  on my default x86 build though. Thanks.

Thanks, patch updated.
