From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] Btrfs: allocate extent state and check the result
 properly
Date: Tue, 19 Apr 2011 09:49:52 +0800
Message-ID: <4DACEA40.5020008@cn.fujitsu.com>
References: <4DA409E6.7020406@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: LKML <linux-kernel@vger.kernel.org>,
	BTRFS <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DA409E6.7020406@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/12/2011 04:14 PM, Xiao Guangrong wrote:
> It doesn't allocate extent_state and check the result properly:
> - in set_extent_bit, it doesn't allocate extent_state if the path is not
>   allowed wait
> 
> - in clear_extent_bit, it doesn't check the result after atomic-ly allocate,
>   we trigger BUG_ON() if it's fail
> 
> - if allocate fail, we trigger BUG_ON instead of returning -ENOMEM since
>   the return value of clear_extent_bit() is ignored by many callers
> 

Ping...to see what happened. :-)
