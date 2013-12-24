Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:51439 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab3LXIAE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Dec 2013 03:00:04 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBO7lIhO010225
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Dec 2013 15:47:19 +0800
Message-ID: <52B93C38.2010502@cn.fujitsu.com>
Date: Tue, 24 Dec 2013 15:48:08 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [BUG] generic/224 causes OOM and hangs 1G RAM system
References: <52B92B6B.1030204@cn.fujitsu.com>
In-Reply-To: <52B92B6B.1030204@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It seems that ext4 also has the same problem.
And the problem also happens in 3.11 kernel, seems to be a fs independent
things.

Qu

On tue, 24 Dec 2013 14:36:27 +0800, Qu Wenruo wrote:
> Hi everyone,
>
> When using testcase generic/224 in xfstests on a 1Gigabytes RAM test
> machine,
> OOM is triggered after about 5 sec and then hangs the system.
>
> This bug can be triggered *all the time* but only on 1Gigabytes or less RAM
> machine.
> If tested on a 2Gigabytes or higher machine, the memory consumption is high,
> but OOM will not be triggered and after the testcase, memory consumption
> will
> return normal.
>
> So this is not a memory leak but a ridiculous btrfs behavior.
>
> Since systems with 1Gigabytes are not quite old and even very common in
> VMs or
> embedded devices, it would be better to fix the ridiculous memory
> consuption.
>
> Thanks,
> Qu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

