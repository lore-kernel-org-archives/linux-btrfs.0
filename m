Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:44802 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbcCUXYN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 19:24:13 -0400
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
	by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u2LJE9DP031258
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 19:14:09 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u2LJE8CD023461
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 19:14:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by userv0022.oracle.com (8.14.4/8.13.8) with ESMTP id u2LJE8Zn030051
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 19:14:08 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id u2LJE7pU032118
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 19:14:07 GMT
Date: Mon, 21 Mar 2016 12:16:28 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs: fix up read_tree_block to return proper error
Message-ID: <20160321191628.GB1111@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20160318053713.GA2111@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160318053713.GA2111@mwanda>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Dan,

On Fri, Mar 18, 2016 at 08:37:13AM +0300, Dan Carpenter wrote:
> Hello Liu Bo,
> 
> The patch 64c043de466d: "Btrfs: fix up read_tree_block to return
> proper error" from May 25, 2015, leads to the following static
> checker warning:
> 
> 	fs/btrfs/relocation.c:1858 replace_path()
> 	error: 'eb' dereferencing possible ERR_PTR()
> 
> fs/btrfs/relocation.c
>   1850                          eb = read_tree_block(dest, old_bytenr, old_ptr_gen);
>   1851                          if (IS_ERR(eb)) {
>                                     ^^^^^^^^^^
> 
>   1852                                  ret = PTR_ERR(eb);
> 
> Missing break or continue?
> 
>   1853                          } else if (!extent_buffer_uptodate(eb)) {
>   1854                                  ret = -EIO;
>   1855                                  free_extent_buffer(eb);
>   1856                                  break;
>   1857                          }
>   1858                          btrfs_tree_lock(eb);
>                                                 ^^
> Dereference.
> 
>   1859                          if (cow) {
>   1860                                  ret = btrfs_cow_block(trans, dest, eb, parent,
>   1861                                                        slot, &eb);

Ah, thanks a lot for reporting this!

I've double checked other places in that patch, the above one is the only place
we have such a problem.

I'll cook a patch to fix it.

Thanks,

-liubo
