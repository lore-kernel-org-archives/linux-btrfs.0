Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46284 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753138AbdJPOax (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 10:30:53 -0400
Date: Mon, 16 Oct 2017 16:29:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: fix false EIO for missing device
Message-ID: <20171016142906.GP3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171013134218.19048-1-anand.jain@oracle.com>
 <20171014003402.7230-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20171014003402.7230-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 14, 2017 at 08:34:02AM +0800, Anand Jain wrote:
> When one of the device is missing, bbio_error() takes care
> of setting the error status. And if its only IO that is
> pending in that stripe, it fails to check the status of the
> other IO at %bbio_error before setting the error %bi_status
> for the %orig_bio. Fix this by checking if %bbio->error is
> has crossed the %bbio->max_errors. Thxs.
> 
> Reproducer as below fdatasync error is seen intermittently.
> 
>  mount -o degraded /dev/sdc /btrfs
>  dd status=none if=/dev/zero of=$(mktemp /btrfs/XXX) bs=4096 count=1 conv=fdatasync
> 
>  dd: fdatasync failed for ‘/btrfs/LSe’: Input/output error
> 
>  The reason for the intermittences of the problem is because..
>  following condition has to be met, which depends on timely
>  coordination.
>  In btrfs_map_bio()
>   . The RAID1 the missing device has to be at %dev_nr = 1
>  In bbio_error()
>   . Before bbio_error() is called the bio of the not-missing
>     device at %dev_nr=0 must be completed so that the below
>     condition is true
>      if (atomic_dec_and_test(&bbio->stripes_pending)) {
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Added to queue, thanks.
