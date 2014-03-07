Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbaCGAZv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Mar 2014 19:25:51 -0500
Date: Thu, 6 Mar 2014 16:25:49 -0800
From: Zach Brown <zab@redhat.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix deadlock with nested trans handles
Message-ID: <20140307002549.GC16439@lenny.home.zabbo.net>
References: <1394150467-5990-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1394150467-5990-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 06, 2014 at 07:01:07PM -0500, Josef Bacik wrote:
> Zach found this deadlock that would happen like this
> 
> btrfs_end_transaction <- reduce trans->use_count to 0
>   btrfs_run_delayed_refs
>     btrfs_cow_block
>       find_free_extent
> 	btrfs_start_transaction <- increase trans->use_count to 1
>           allocate chunk
> 	btrfs_end_transaction <- decrease trans->use_count to 0
> 	  btrfs_run_delayed_refs
> 	    lock tree block we are cowing above ^^

Indeed, I stumbled across this while trying to reproduce reported
problems with iozone.  This deadlock would consistently hit during
random 1k reads in a 2gig file.

> We need to only decrease trans->use_count if it is above 1, otherwise leave it
> alone.  This will make nested trans be the only ones who decrease their added
> ref, and will let us get rid of the trans->use_count++ hack if we have to commit
> the transaction.  Thanks,

And this fixes it.  It's run through a few times successfully.

> cc: stable@vger.kernel.org
> Reported-by: Zach Brown <zab@redhat.com>
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Tested-by: Zach Brown <zab@redhat.com>

- z
