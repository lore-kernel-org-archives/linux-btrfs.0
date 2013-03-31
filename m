Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:63392 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755294Ab3CaJWy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Mar 2013 05:22:54 -0400
Received: from mailout-de.gmx.net ([10.1.76.29]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0LiZta-1UuTtR1ZfQ-00ckZg for
 <linux-btrfs@vger.kernel.org>; Sun, 31 Mar 2013 11:22:53 +0200
Message-ID: <515800BB.50102@gmx.net>
Date: Sun, 31 Mar 2013 11:24:11 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: "list.btrfs@jan-o-sch.net Schmidt" <list.btrfs@jan-o-sch.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG] btrfs quota
References: <1DF9A68C-FBA2-460F-921F-CBF94A06CD6B@gmail.com>
In-Reply-To: <1DF9A68C-FBA2-460F-921F-CBF94A06CD6B@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Wang,

On 03/31/13 03:44, Wang Shilong wrote:
> Hello Arne, Jan,
> 
>  When i run stresstest with quota enabled, i hit a panic where
> btrfs_find_all_roots() is called. Would you please double check it.
> 

On what kernel version do you hit this (git commit id preferred)?
Can you send us the message from dmesg?

Thanks,
arne

>  stresstest -n 10000  -t 4.
> 
> Maybe there is still race condition when walking backref  trees, Jan
> would you please check the backref.c ..
> btrfs_find_all_roots() is called in btrfs_qgroup_account_ref () to find
> all roots that reference a extent. I think this is called because
> 
> we introduce referenced/exclusive concepts. The point is that i think
>  this concept's disadvantages outweigh the advantages:
>       <1>
> walking backref  tree is really time-consuming.
> <2> referenced/exclusive makes it really complex when snapshot happens.
> <3> quota has a high coupling with other module.
>      I'd prefer to just keep referenced value, it is not be elegant, but
> it helps more.
> 
> Thanks,
> Wang
> 
> 
> 
> 
> 

