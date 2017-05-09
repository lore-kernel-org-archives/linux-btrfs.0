Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34086 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753437AbdEIRMo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 May 2017 13:12:44 -0400
Date: Tue, 9 May 2017 19:12:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2] btrfs: add framework to handle device flush error as
 a volume
Message-ID: <20170509171235.GH5491@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170505231754.9201-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20170505231754.9201-1-anand.jain@oracle.com>

On Sat, May 06, 2017 at 07:17:54AM +0800, Anand Jain wrote:
> This adds comments to the flush error handling part of
> the code, and hopes to maintain the same logic with a
> framework which can be used to handle the errors at the
> volume level.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

So the next step is to preallocate the flush_bio and remove the ENOMEM
handling.

I think we can skip the error handling on the submission path, even if
submit_bio can fail, the error code will be stored to the bio and this
will be checked in the waiting side.

Then write_dev_flush can be split into 2 functions by the parameter
'wait', as the paths are completely independent.

> +static int check_barrier_error(struct btrfs_fs_devices *fsdevs)
> +{
> +	int submit_flush_error = 0;
> +	int dev_flush_error = 0;
> +	struct btrfs_device *dev;
> +	int tolerance;
> +
> +	list_for_each_entry_rcu(dev, &fsdevs->devices, dev_list) {
> +		if (!dev->bdev) {
> +			submit_flush_error++;
> +			dev_flush_error++;
> +			continue;
> +		}
> +		if (dev->last_flush_error == -ENOMEM)
> +			submit_flush_error++;
> +		if (dev->last_flush_error && dev->last_flush_error != -ENOMEM)
> +			dev_flush_error++;
> +	}
> +
> +	tolerance = fsdevs->fs_info->num_tolerated_disk_barrier_failures;
> +	if (submit_flush_error > tolerance || dev_flush_error > tolerance)
> +		return -EIO;

Actually, after reading submit_bio and the comment above, do we need to
care about the submission errors? As submit_bio could return -EIO
immeditaelly, but does not help us anyway. We'll wait and check again
later.  It's the bio completion what counts.

This should simplify the code.
