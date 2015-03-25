Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbbCYDPA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 23:15:00 -0400
Date: Wed, 25 Mar 2015 11:14:58 +0800
From: Eryu Guan <eguan@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: fstests@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] fstests: update _filter_btrfs_version
Message-ID: <20150325031458.GR4810@dhcp-13-216.nay.redhat.com>
References: <5511D94C.9090109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5511D94C.9090109@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 24, 2015 at 04:38:20PM -0500, Eric Sandeen wrote:
> The btrfs cmd now sometimes emits "btrfs-progs" not "Btrfs-progs"
> as it used to, so update the filter accordingly.
> 
> (This fixes a failure on btrfs/006 w/ btrfs-progs v3.19)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good to me.

Reviewed-by: Eryu Guan <eguan@redhat.com>

> ---
> 
> diff --git a/common/filter.btrfs b/common/filter.btrfs
> index c9b3f3a..ea047c5 100644
> --- a/common/filter.btrfs
> +++ b/common/filter.btrfs
> @@ -5,7 +5,7 @@
>  # Some, but not all, commands emit "Btrfs <version>"
>  _filter_btrfs_version()
>  {
> -	sed -e "s/^Btrfs.*//g"
> +	sed -e "s/^[Bb]trfs.*//g"
>  }
>  
>  _filter_devid()
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
