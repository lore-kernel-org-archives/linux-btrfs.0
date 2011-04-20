From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] Btrfs: allocate extent state and check the result
 properly
Date: Wed, 20 Apr 2011 14:49:17 +0800
Message-ID: <4DAE81ED.9060505@cn.fujitsu.com>
References: <4DA409E6.7020406@cn.fujitsu.com> <4DACEA40.5020008@cn.fujitsu.com> <1303213987-sup-4275@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: LKML <linux-kernel@vger.kernel.org>,
	BTRFS <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1303213987-sup-4275@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/19/2011 07:55 PM, Chris Mason wrote:

> Sorry, could you please change this to check the results of the atomic
> allocatoin in set/clear_extent_bit?  I'd rather not add a new BUG_ON
> deeper into the code.
> 

OK, i have posted the v2 patch to fix it, thanks for your review!
