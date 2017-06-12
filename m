Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43635 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753459AbdFLQPQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 12:15:16 -0400
Date: Mon, 12 Jun 2017 18:14:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/2] btrfs: write_dev_flush does not return ENOMEM anymore
Message-ID: <20170612161406.GR25451@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170609065229.8188-1-anand.jain@oracle.com>
 <20170609065229.8188-2-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170609065229.8188-2-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 09, 2017 at 02:52:28PM +0800, Anand Jain wrote:
> Commit
>  9035b5dbc576 btrfs: btrfs_io_bio_alloc never fails, skip error handling
> 
> removed the -ENOMEM return from write_dev_flush() so no need to
> check for the -ENOMEM during send.
> 
> This patch also peals write_dev_flush's wait part of the code,
> and creates a new function wait_dev_flush().

"This patch also" usually means that the patch should be split.

>  /*
> - * trigger flushes for one the devices.  If you pass wait == 0, the flushes are
> - * sent down.  With wait == 1, it waits for the previous flush.
> - *
> - * any device where the flush fails with eopnotsupp are flagged as not-barrier
> - * capable
> + * trigger flushes for one the devices.

In the patch that splits write_dev_flush, please use the following
comment wording:

 * Submit a flush request to the device if it supports it. Error handling is
 * done in the waiting counterpart.

>   */
> -static int write_dev_flush(struct btrfs_device *device, int wait)
> +static void write_dev_flush(struct btrfs_device *device)

and

/*
 * If the flush bio has been submitted by write_dev_flush, wait for it.
 */

> +static int wait_dev_flush(struct btrfs_device *device)
> +{

But otherwise the cleanup is good.
