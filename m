Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:49770 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760177Ab3DDNMH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Apr 2013 09:12:07 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id CBACF7C0427
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Apr 2013 07:12:06 -0600 (MDT)
Date: Thu, 4 Apr 2013 09:12:04 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V2 1/2] Btrfs: improve the performance of the csums lookup
Message-ID: <20130404131204.GQ1876@localhost.localdomain>
References: <5153FB01.9030506@cn.fujitsu.com>
 <515BF138.90309@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <515BF138.90309@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 03, 2013 at 03:07:04AM -0600, Miao Xie wrote:
> It is very likely that there are several blocks in bio, it is very
> inefficient if we get their csums one by one. This patch improves
> this problem by getting the csums in batch.
> 
> According to the result of the following test, the execute time of
> __btrfs_lookup_bio_sums() is down by ~28%(300us -> 217us).
> 
>  # dd if=<mnt>/file of=/dev/null bs=1M count=1024
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

This is panicing when I run my fsync tests and when kdave runs xfstest 91.  I
don't have time to track it down now so I'm just dropping it from btrfs-next.
I'll look at it after I figure out this fsync bug unless you beat me to it.
Thanks,

Josef
