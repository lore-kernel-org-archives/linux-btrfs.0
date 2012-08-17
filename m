Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:19440 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787Ab2HQBrB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Aug 2012 21:47:01 -0400
Message-ID: <502DA230.6010202@oracle.com>
Date: Fri, 17 Aug 2012 09:45:20 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Llu=EDs_Batlle_i_Rossell?= <viric@viric.name>
CC: Btrfs mailing list <linux-btrfs@vger.kernel.org>,
        David Sterba <dave@jikos.cz>
Subject: Re: State of nocow file attribute
References: <20120815101229.GH25996@vicerveza.homeunix.net>
In-Reply-To: <20120815101229.GH25996@vicerveza.homeunix.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/15/2012 06:12 PM, Lluís Batlle i Rossell wrote:
> Hello,
> 
> some time ago we discussed on #btrfs that the nocow attribute for files wasn't
> working (around 3.3 or 3.4 kernels). That was evident by files fragmenting even
> with the attribute set.
> 
> Chris mentioned to find a fix quickly for that, and posted some lines of change
> into irc. But recently someone mentioned that 3.6-rc looks like still not
> respecting nocow for files.
> 
> Is there really a fix upstream for that? Do nocow attribute on files work for
> anyone already?
> 

Hi Lluís,

Dave had post a patch to fix it but only enabling NOCOW with zero sized file.

FYI, the patch is http://article.gmane.org/gmane.comp.file-systems.btrfs/17351

With the patch, you don't need to mount with nodatacow any more :)

And why it is only for only zero sized file:
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/18046

thanks,
liubo

> Regards,
> Lluís.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

