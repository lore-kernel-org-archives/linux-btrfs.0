Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from y235201.ppp.asahi-net.or.jp ([118.243.235.201]:57512 "EHLO
	mactop" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754108Ab3EAIJQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 May 2013 04:09:16 -0400
Received: from [10.81.1.3] (mydomain.com [10.81.1.3])
	by mactop (Postfix) with ESMTP id 2C2295FFFB
	for <linux-btrfs@vger.kernel.org>; Wed,  1 May 2013 16:59:35 +0900 (JST)
Message-ID: <5180CB66.9030803@parallels.com>
Date: Wed, 01 May 2013 16:59:34 +0900
From: dima <dolenin@parallels.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Best Practice - Partition, or not?
References: <loom.20130501T094600-451@post.gmane.org>
In-Reply-To: <loom.20130501T094600-451@post.gmane.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/01/2013 04:51 PM, Alexander Skwar wrote:
> Hello
>
> If I want to manage a complete disk with btrfs, what's the "Best Practice"?
> Would it be best to create the btrfs filesystem on "/dev/sdb", or would it be
> better to create just one partition from start to end and then do "mkfs.btrfs
> /dev/sdb1"?
>
> Would the same recomendation hold true, if we're talking about huge disks,
> like 4TB or so?
>
> Cross platform compatibility (OS X, Windows, FreeBSD, …) is of no matter to
> me.
>
> Thanks,
> Alexander


(NB: grub will not boot from "/dev/sdb", selinux will)
