Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:50228 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab2EQNm1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 09:42:27 -0400
Date: Thu, 17 May 2012 16:46:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Arne Jansen <sensille@gmx.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs: initial readahead code and prototypes
Message-ID: <20120517134613.GN16999@mwanda>
References: <20120517071446.GI14660@elgon.mountain>
 <4FB4FDC6.5070306@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FB4FDC6.5070306@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 17, 2012 at 03:31:50PM +0200, Arne Jansen wrote:
> The assumption here is that if err == 0, eb is always != NULL. There's
> even a tiny comment above the function stating this:
> 
>       107              /* in case of err, eb might be NULL */
> 

Ah, right.  I missed the comment.

> This code changes significantly with the patch
> 
> btrfs: extend readahead interface
> 
> Where it is written in a more obvious way.

Cool.

regards,
dan carpenter

