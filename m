Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48329 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752987AbdFMPYe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 11:24:34 -0400
Date: Tue, 13 Jun 2017 17:23:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/3 v2.1] btrfs: write_dev_flush does not return ENOMEM
 anymore
Message-ID: <20170613152328.GY25451@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1497344741-1135-1-git-send-email-anand.jain@oracle.com>
 <1497346349-1194-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1497346349-1194-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 13, 2017 at 05:32:29PM +0800, Anand Jain wrote:
> As commit
>  9035b5dbc576 btrfs: btrfs_io_bio_alloc never fails, skip error handling
> 
> removed the -ENOMEM return from write_dev_flush()/send-part so no need to
> check for the -ENOMEM during send.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v2.1: Part of commit log got missed out during send. fix it.
> v2: . Add the removal of submit_flush_error in check_barrier_error()
>     from 2/2 before to 1/3 here, as its appropriate to be here.
>     . Did not split the write and wait part here in this patch.

All 3 reviewed and queued, thanks. I have a prototype for the
preallocated flush bio but was waiting until these cleanups are in
before snding it.

I've noticed that threre are two more "if (!device->bdev)" checks under
the device lock in write_all_supers, that might be worth removing.

However, a NULL bdev and device->missing are related and I think there
are some dark corners in dev replace where the invariant can be
temporarily broken. Given that we probably don't have great testing
coverage of devices with the flush capabilities, we should make it
possible to override that for debugging purposes. Eg. add a
"/sys/fs/btrfs/UUID/force_dev_flush" if CONFIG_BTRFS_DEBUG is enabled.

Anyway, that can also wait for later. We've made some changes this time
so I'd not add any more intrusive ones until the current devel queue is
on the way to master.
