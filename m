Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34896 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751618AbdISPMM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 11:12:12 -0400
Date: Tue, 19 Sep 2017 17:09:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Colin King <colin.king@canonical.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: make array types static const, reduces object
 code size
Message-ID: <20170919150906.GG29043@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170919150123.23913-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170919150123.23913-1-colin.king@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 19, 2017 at 04:01:23PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate the read-only array types on the stack, instead make
> it static const.  Makes the object code smaller by nearly 60 bytes:
> 
> Before:
>    text	   data	    bss	    dec	    hex	filename
>   90536	   6552	     64	  97152	  17b80	fs/btrfs/ioctl.o
> 
> After:
>    text	   data	    bss	    dec	    hex	filename
>   90414	   6616	     64	  97094	  17b46	fs/btrfs/ioctl.o
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: David Sterba <dsterba@suse.com>
