Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:15040 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753268AbdHOJye (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Aug 2017 05:54:34 -0400
Date: Tue, 15 Aug 2017 17:54:26 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Eryu Guan <eguan@redhat.com>
CC: <linux-btrfs@vger.kernel.org>, <fstests@vger.kernel.org>,
        <bo.li.liu@oracle.com>
Subject: Re: [PATCH] fstests: btrfs: enhance regression test for nocsum dio
 read's repair
Message-ID: <20170815095426.GC512@fnst>
References: <20170814070313.20092-1-lufq.fnst@cn.fujitsu.com>
 <20170815091606.GG14807@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20170815091606.GG14807@eguan.usersys.redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 15, 2017 at 05:16:06PM +0800, Eryu Guan wrote:
>On Mon, Aug 14, 2017 at 03:03:13PM +0800, Lu Fengqi wrote:
>> I catch this following error from dmesg when this testcase fails.
>> 
>> [17446.661127] Buffer I/O error on dev sdb1, logical block 64, async page read
>> 
>> We expect to inject disk IO errors on the device when xfs_io reads the
>> specific file, but other processes may trigger IO error earlier. So, we
>> can use task-filter to solve this problem.
>> 
>> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>
>This looks OK to me. Does btrfs/143 need a similar fix?
>
>Thanks,
>Eryu
>
>

Although btrfs/143 has a similar problem, this method doesn't work for it.
Unlike btrfs/142, the second IO error needs to be triggered by another process,
not by xfs_io. So we can't simply set task-filter to solve this problem.

I'm still investigating a way to solve the problem.

Do you have any ideas?
Any help will be greatly appreciated.

-- 
Thanks,
Lu


