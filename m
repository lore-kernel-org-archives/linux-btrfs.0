From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: [PATCH] btrfs: checking NULL or not in some functions
Date: Wed, 02 Feb 2011 14:33:12 +0900
Message-ID: <4D48EC98.9020901@jp.fujitsu.com>
References: <201102010917.AA00006@T-ITOH1.jp.fujitsu.com> <4D48E68E.7000502@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D48E68E.7000502@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

(2011/02/02 14:07), Chris Samuel wrote:
> On 01/02/11 20:17, Tsutomu Itoh wrote:
> 
>> Because NULL is returned when the memory allocation fails,
>> it is checked whether it is NULL. 
> 
> Were the callers modified to cope with these functions
> returning -ENOMEM ?

I have not modified it yet. Currently, there is a case that becomes
BUG_ON() or BUG().
I think that it is our future work to decrease BUG_ON().

Thanks,
Itoh

> 
> cheers,
> Chris (way behind with email)

