Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49218 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab3FQCLf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Jun 2013 22:11:35 -0400
Date: Mon, 17 Jun 2013 10:11:25 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: converting lzo compression to zlib compression?
Message-ID: <20130617021124.GA30460@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20130617021653.4718a5e0@virtall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130617021653.4718a5e0@virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 17, 2013 at 02:16:53AM +0900, Tomasz Chmielewski wrote:
> I have a btrfs filesystem mounted with "compress=lzo" now.
> 
> I'd like to see how much space would I save by converting it to zlib.
> 
> 
> Would it be possible to convert lzo compression to zlib compression
> with the following:
> 
> - mount the filesystem with "compress=zlib"
> - run balance
> - when balance finishes, the data would be compressed with zlib
> 
> Would this work as above, or do I have to copy the data out and back to
> convert from lzo compression to zlib compression?

Hi,

I'm afraid the above won't work, cause balance is not aware of the
compression so that it won't decompress the data.

thanks,
liubo

> 
> 
> -- 
> Tomasz Chmielewski
> http://wpkg.org
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
