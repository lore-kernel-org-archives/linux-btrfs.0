Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41095 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750966AbaJPJm2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Oct 2014 05:42:28 -0400
Message-ID: <1413452485.7609.7.camel@localhost.localdomain>
Subject: Re: [PATCH] btrfs: fix wrong pad for kernelspace arg of btrfs dev
 stat
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: <linux-btrfs@vger.kernel.org>
Date: Thu, 16 Oct 2014 17:41:25 +0800
In-Reply-To: <543F8F4B.5080506@giantdisaster.de>
References: <1413424419-15237-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <543F8F4B.5080506@giantdisaster.de>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2014-10-16 at 11:26 +0200, Stefan Behrens wrote:
> On Thu, 16 Oct 2014 09:53:37 +0800, Gui Hecheng wrote:
> > The @btrfs_ioctl_get_dev_stats fails to pad to 1k as descripted,
> > actually it valuates to 1032 bytes.
> > The corresponding userspace change follows this change.
> > 
> > Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> > ---
> >  include/uapi/linux/btrfs.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> > index 2f47824..fc4e326 100644
> > --- a/include/uapi/linux/btrfs.h
> > +++ b/include/uapi/linux/btrfs.h
> > @@ -416,7 +416,7 @@ struct btrfs_ioctl_get_dev_stats {
> >  	/* out values: */
> >  	__u64 values[BTRFS_DEV_STAT_VALUES_MAX];
> >  
> > -	__u64 unused[128 - 2 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
> > +	__u64 unused[128 - 3 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
> 
> You can't change an existing ioctl interface like this and make it
> incompatible, the length of the structure is used in _IOWR(). Just
> change the comment from "pad to 1k" to "pad to 1032 bytes" instead.

Er... yeah, the problem exists, and such a fix seems cost much.
Since the related tool itself doesn't influence much, just scratch these
two may be a reasonable idea. ^_^

("pad to 1032 bytes" seems a bit...) 

> 
> >  };
> >  
> >  #define BTRFS_QUOTA_CTL_ENABLE	1
> > 
> 
> 


