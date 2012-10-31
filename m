Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36755 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933206Ab2JaAkX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 20:40:23 -0400
Message-ID: <5090736C.5040609@oracle.com>
Date: Wed, 31 Oct 2012 08:40:12 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Nyers?= <gnyers@suse.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>, Jie Liu <jeff.liu@oracle.com>
Subject: Re: How to find (out if) files sharing content?
References: <20121030162005.0308d5a2@lupus.demo.lan>
In-Reply-To: <20121030162005.0308d5a2@lupus.demo.lan>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/30/2012 11:20 PM, Gábor Nyers wrote:
> Hi,
> 
> How could one find out if 2 files share any extents on a btrfs file system?
> 
> A more generic variation of the above: How to list files on the same
> file system/subvolume sharing content?
> 

Indeed ocfs2 already has the feature where you can get shared parts via 'du',
we're planning to support this in btrfs, too.

thanks,
liubo

> Thanks,
> Gábor
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

