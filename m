Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59430 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752467AbdHOJQI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Aug 2017 05:16:08 -0400
Date: Tue, 15 Aug 2017 17:16:06 +0800
From: Eryu Guan <eguan@redhat.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, bo.li.liu@oracle.com
Subject: Re: [PATCH] fstests: btrfs: enhance regression test for nocsum dio
 read's repair
Message-ID: <20170815091606.GG14807@eguan.usersys.redhat.com>
References: <20170814070313.20092-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170814070313.20092-1-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 14, 2017 at 03:03:13PM +0800, Lu Fengqi wrote:
> I catch this following error from dmesg when this testcase fails.
> 
> [17446.661127] Buffer I/O error on dev sdb1, logical block 64, async page read
> 
> We expect to inject disk IO errors on the device when xfs_io reads the
> specific file, but other processes may trigger IO error earlier. So, we
> can use task-filter to solve this problem.
> 
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

This looks OK to me. Does btrfs/143 need a similar fix?

Thanks,
Eryu
