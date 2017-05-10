Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55334 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751829AbdEJKkf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 May 2017 06:40:35 -0400
Date: Wed, 10 May 2017 18:40:32 +0800
From: Eryu Guan <eguan@redhat.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@gmail.com>
Subject: Re: [PATCH 2/6] fstests: add _get_current_dmesg
Message-ID: <20170510104032.GA7250@eguan.usersys.redhat.com>
References: <1494352571-17199-1-git-send-email-bo.li.liu@oracle.com>
 <1494352571-17199-3-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1494352571-17199-3-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 09, 2017 at 11:56:07AM -0600, Liu Bo wrote:
> _get_current_dmesg can be used to grep customized pattern.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

I can't apply this patch on top of current master, perhaps it needs a
rebase :)

> ---
>  common/rc | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 78a2101..111ed69 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3215,6 +3215,12 @@ _get_device_size()
>  	grep `_short_dev $1` /proc/partitions | awk '{print $3}'
>  }
>  
> +# get current dmesg log
> +_get_current_dmesg()
> +{
> +	dmesg | tac | sed -ne "0,\#run fstests $seqnum at $date_time#p" | tac
> +}
> +
>  # check dmesg log for WARNING/Oops/etc.
>  _check_dmesg()
>  {
> @@ -3230,8 +3236,7 @@ _check_dmesg()
>  
>  	# search the dmesg log of last run of $seqnum for possible failures
>  	# use sed \cregexpc address type, since $seqnum contains "/"

This second line of comment should go to _get_current_dmesg.

Thanks,
Eryu

> -	dmesg | tac | sed -ne "0,\#run fstests $seqnum at $date_time#p" | \
> -		tac | $filter >$seqres.dmesg
> +	_get_current_dmesg | $filter >$seqres.dmesg
>  	grep -q -e "kernel BUG at" \
>  	     -e "WARNING:" \
>  	     -e "BUG:" \
> -- 
> 2.5.0
> 
