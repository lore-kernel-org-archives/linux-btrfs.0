Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:3148 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753342Ab2FKD6J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Jun 2012 23:58:09 -0400
Message-ID: <4FD56E71.9070101@cn.fujitsu.com>
Date: Mon, 11 Jun 2012 12:05:05 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: WeiFeng Liu <weifeng.liu@hushmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Two questions about update_global_block_rsv()
References: <20120607144622.96FFDE674A@smtp.hushmail.com>
In-Reply-To: <20120607144622.96FFDE674A@smtp.hushmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/07/2012 10:46 PM, WeiFeng Liu wrote:

> Help two questions about update_global_block_rsv()
> 
> update_global_block_rsv(fs_info) {
> 
> ...
> block_rsv = &fs_info->global_block_rsv;
> sinfo = block_rsv->space_info;
> 
> num_bytes = sinfo->bytes_used + sinfo->bytes_pinned +
>             sinfo->bytes_reserved + sinfo->bytes_readonly +
>             sinfo->bytes_may_use;
>  
> if (sinfo->total_bytes > num_bytes) {
> 		num_bytes = sinfo->total_bytes - num_bytes;
> 		block_rsv->reserved += num_bytes;
> 		sinfo->bytes_may_use += num_bytes;
> }
> ...
> }
> 
> 1. I don't quite understand the lines:
> 	block_rsv->reserved += num_bytes;
> 	sinfo->bytes_may_use += num_bytes;
> 	
> why aren't they like these?
> 	block_rsv->reserved = num_bytes;
> 	sinfo->bytes_may_use = num_bytes;
> 

> assuming that nothing else is changed, and we just call
> update_global_block_rsv() for several times, then block_rsv->reserved will
> increase constantly, and so sinfo->bytes_may_use; can anyone tell me what it
> means? I mean if nothing else is changed the two variables should keep their
> values unchanged also, is that right? a bit puzzlement to me.
> 


the following if-statement tells the truth:

if (block_rsv->reserved >= block_rsv->size) {
	...
}

> 2. Is the meaning of sinfo->bytes_may_use that bytes which is available for use
> or that bytes which will likely/unlikely be used?
> 


You need to understand how a block_rsv works,

both block_rsv and space_info are a kind of _container_:

    Introducing metadata reseravtion contexts has two major advantages.
    First, it makes metadata reservation more traceable.
    Second, it can reclaim freed space and re-add them to the itself after transaction committed.


here is a basic model:

      +--+--->size          +--+--->size                       +--------------+
      |  |                  |  |                               |              |
      |  |                  |  |                               |              |
      +--+--->reserved      +--+--->reserved                   +--------------+-->may_used
      |  |                  |  |                               |              |
      |  |                  |  |                               |              |
      |  |                  |  |                               |              |
      +--+                  +--+                               +--------------+
    block_rsv          +   block_rsv          +   ...    =     space_info(flag=4)
       A                      B                    |
                                                   |
                                                   +--> reserved meta bytes


Hope that this helps.

thanks,
liubo

> thanks
> 
> WeiFeng Liu
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


