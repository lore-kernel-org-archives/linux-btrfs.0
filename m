Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:37281 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab2KVTDo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Nov 2012 14:03:44 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
	by aserp1050.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qAM1JQCA020416
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Nov 2012 01:19:26 GMT
Date: Thu, 22 Nov 2012 09:16:54 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: btrfs <linux-btrfs@vger.kernel.org>
Cc: Marios Titas <redneb8888@gmail.com>, dsterba@suse.cz
Subject: Re: per-file NOCOW in 3.7
Message-ID: <20121122011653.GC3327@gmail.com>
Reply-To: bo.li.liu@oracle.com
References: <CAAdM647=qHnkfk=3c2hhGk61_-Jge02yxbj6nNVAqmEf+BJA-g@mail.gmail.com>
 <20121121172511.GC3102@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121121172511.GC3102@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 21, 2012 at 06:25:11PM +0100, David Sterba wrote:
> On Wed, Nov 21, 2012 at 10:48:08AM -0500, Marios Titas wrote:
> > According to the tentative changelog in the wiki, 3.7 will properly
> > support per-file NOCOW. I think this is misleading. In particular, it
> > still does not work correctly in the case when the NOCOW flag of a new
> > flag is being inherited from the directory. I think it would be better
> > to remove that item from the changelog until the the fix [1] is
> > merged.
> > [1] https://patchwork.kernel.org/patch/1438431/
> 
> You're right, the patch is not in 3.7-rc nor in btrfs-next, and fixes a
> real bug.
> 
> Technically it is a regresssion within the 3.7 cycle (so it could even
> go to a late -rc), in any case it's a small change that could also go
> through the stable tree.
> 
> david

Well, I'll resend it for merge with Marios's reported-by and your Reviewed-by.

Don't worry, it's a good fix though.

thanks,
liubo
