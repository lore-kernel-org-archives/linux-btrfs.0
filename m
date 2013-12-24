Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:63918 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab3LXGfi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Dec 2013 01:35:38 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBO6ZZ2c004975
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Dec 2013 14:35:35 +0800
Message-ID: <52B92B6B.1030204@cn.fujitsu.com>
Date: Tue, 24 Dec 2013 14:36:27 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [BUG] generic/224 causes OOM and hangs 1G RAM system
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

When using testcase generic/224 in xfstests on a 1Gigabytes RAM test
machine,
OOM is triggered after about 5 sec and then hangs the system.

This bug can be triggered *all the time* but only on 1Gigabytes or less RAM
machine.
If tested on a 2Gigabytes or higher machine, the memory consumption is high,
but OOM will not be triggered and after the testcase, memory consumption
will
return normal.

So this is not a memory leak but a ridiculous btrfs behavior.

Since systems with 1Gigabytes are not quite old and even very common in
VMs or
embedded devices, it would be better to fix the ridiculous memory
consuption.

Thanks,
Qu
