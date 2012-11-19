Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33572 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab2KSKck (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Nov 2012 05:32:40 -0500
Date: Mon, 19 Nov 2012 18:32:23 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: btrfs crash - Null dereference - 3.7.0-rc5-00068-gc5e35d6
Message-ID: <20121119103221.GA8810@gmail.com>
Reply-To: bo.li.liu@oracle.com
References: <20121119025540.GA3858@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121119025540.GA3858@joana>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 19, 2012 at 12:55:40AM -0200, Gustavo Padovan wrote:
> Hi,
> 
> my system suddenly crashed and gave me this dump:
> 
> http://imgur.com/oO6S0
> 
> I checked and there is not btrfs commit in linus' tree since I compiled this
> kernel.
> 

Hi Gustavo,

It's weird that NULL pointer oops happens here.

Since you own the kernel, you may also have debuginfo left,

can you please run
'gdb fs/btrfs/btrfs.ko' and 'list *block_rsv_release_bytes+0x21' to
check which one is NULL pointer?

thanks,
liubo

> 	Gustavo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
