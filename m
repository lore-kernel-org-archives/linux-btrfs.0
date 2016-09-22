Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40554 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752016AbcIVOpW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 10:45:22 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6A26CAB9F
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Sep 2016 14:45:21 +0000 (UTC)
Date: Thu, 22 Sep 2016 16:43:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH] btrfs: btrfs_debug should consume fs_info when DEBUG is
 not defined
Message-ID: <20160922144321.GO16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1474380303-25995-1-git-send-email-jeffm@suse.com>
 <44bec1b2-b961-ff13-374d-57b7adf5e3fd@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <44bec1b2-b961-ff13-374d-57b7adf5e3fd@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 21, 2016 at 12:17:37PM -0400, Jeff Mahoney wrote:
> We can hit unused variable warnings when btrfs_debug and friends are
> just aliases for no_printk.  This is due to the fs_info not getting
> consumed by the function call, which can happen if convenenience
> variables are used.  This patch adds a new btrfs_no_printk static inline
> that consumes the convenience variable and does nothing else.  It
> silences the unused variable warning and has no impact on the generated
> code:
> 
> $ size fs/btrfs/extent_io.o*
>    text	   data	    bss	    dec	    hex	filename
>   44072	    152	     32	  44256	   ace0	fs/btrfs/extent_io.o.btrfs_no_printk
>   44072	    152	     32	  44256	   ace0	fs/btrfs/extent_io.o.no_printk
> 
> Fixes: 27a0dd61a5 (Btrfs: make btrfs_debug match pr_debug handling related to DEBUG)
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Looks good, aded to the queue.
