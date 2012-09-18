Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:11595 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755744Ab2IRBry (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 21:47:54 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q8I1lqbF015934
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2012 09:47:53 +0800
Message-ID: <5057D2C6.9080001@cn.fujitsu.com>
Date: Tue, 18 Sep 2012 09:47:50 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V4 01/12] Btrfs: fix error path in create_pending_snapshot()
References: <50487434.1010305@cn.fujitsu.com> <50487440.7050202@cn.fujitsu.com> <20120917165627.GW17430@twin.jikos.cz>
In-Reply-To: <20120917165627.GW17430@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On mon, 17 Sep 2012 18:56:27 +0200, David Sterba wrote:
> On Thu, Sep 06, 2012 at 06:00:32PM +0800, Miao Xie wrote:
>> This patch fixes the following problem:
>> - If we failed to deal with the delayed dir items, we should abort transaction,
>>   just as its comment said. Fix it.
>> - If root reference or root back reference insertion failed, we should
>>   abort transaction. Fix it.
>> - Fix the double free problem of pending->inherit.
>> - Do not restore the trans->rsv if we doesn't change it.
>> - make the error path more clearly.
> 
> I've noticed a pattern in the error + transaction abort paths, that is
> touched in this patch and would like to ask you to update it:

OK, I will send a separate patch to fix this problem.

Thanks for your review.
Miao
