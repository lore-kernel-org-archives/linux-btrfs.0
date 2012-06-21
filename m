Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp11.hushmail.com ([65.39.178.133]:50483 "EHLO
	smtp11.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759559Ab2FUM55 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jun 2012 08:57:57 -0400
Received: from smtp11.hushmail.com (localhost.localdomain [127.0.0.1])
	by smtp11.hushmail.com (Postfix) with SMTP id D51AA1CC2AC
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jun 2012 12:57:56 +0000 (UTC)
MIME-Version: 1.0
Date: Thu, 21 Jun 2012 04:57:54 -0800
To: "Liu Bo" <liubo2009@cn.fujitsu.com>
Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Subject: Re: Two questions about update_global_block_rsv()
From: "WeiFeng Liu" <weifeng.liu@hushmail.com>
Content-Type: text/plain; charset="UTF-8"
Message-Id: <20120621125754.A7C8FE6739@smtp.hushmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>
>You need to understand how a block_rsv works,
>
>both block_rsv and space_info are a kind of _container_:
>
>    Introducing metadata reseravtion contexts has two major 
>advantages.
>    First, it makes metadata reservation more traceable.
>    Second, it can reclaim freed space and re-add them to the 
>itself after transaction committed.
>
>
>here is a basic model:
>
>      +--+--->size          +--+--->size                       +---
>-----------+
>      |  |                  |  |                               |   
>           |
>      |  |                  |  |                               |   
>           |
>      +--+--->reserved      +--+--->reserved                   +---
>-----------+-->may_used
>      |  |                  |  |                               |   
>           |
>      |  |                  |  |                               |   
>           |
>      |  |                  |  |                               |   
>           |
>      +--+                  +--+                               +---
>-----------+
>    block_rsv          +   block_rsv          +   ...    =     
>space_info(flag=4)
>       A                      B                    |
>                                                   |
>                                                   +--> reserved 
>meta bytes
>
>
>Hope that this helps.
>
>thanks,
>liubo


I'm afraid it's a bit late to say thanks, LiuBo.
I saw your June 11 replay yesterday, I have not touched my mail account for nearly 
ten days since my original post, I thought it would have been burried by time after
I kept watching someone's replay for 2, 3 days and failed to get one.

your illustration is usefull for me, I will re-browse some rsv code with it.

thank you very much,

WeiFeng Liu

