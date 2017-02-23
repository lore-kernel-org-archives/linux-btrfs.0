Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43394 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751165AbdBWGfg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Feb 2017 01:35:36 -0500
Subject: Re: [PATCH] generic/311: Disable dmesg check
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
References: <1437109003-2357-1-git-send-email-chandan@linux.vnet.ibm.com>
 <44614455-beac-5191-59c8-2bda3cd14881@oracle.com>
 <2485150.WmAGPpieTt@localhost.localdomain>
Cc: linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <d1042de0-7bad-cd73-6952-765d01647c12@oracle.com>
Date: Thu, 23 Feb 2017 14:40:11 +0800
MIME-Version: 1.0
In-Reply-To: <2485150.WmAGPpieTt@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Hi Chandan,

> This bug is easily recreated when executing the test on Btrfs with
> subpage-blocksize patchset applied. I haven't been able to test the recently
> rebased subpage-blocksize patchset yet.
>
> Coming back to the issue ... The problem exists because the test code uses
> dm-flakey. Josef had suggested that using dm-log-writes instead of dm-flakey
> should fix the problem. I will work on this and post a patch soon.

  generic/311 is using the drop writes, it appears eio shouldn't be
  reported
	_load_flakey_table $FLAKEY_DROP_WRITES $lockfs

  Looks like there is a regression in the dm-flakey which was fixed by
  ---
  dm flakey: fix reads to be issued if drop_writes configured

  v4.8-rc3 commit 99f3c90d0d ("dm flakey: error READ bios during the
  down_interval") overlooked the 'drop_writes' feature, which is meant to
  allow reads to be issued rather than errored, during the down_interval.

  Fixes: 99f3c90d0d ("dm flakey: error READ bios during the
  down_interval")
  ---

  That also explains why I couldn't reproduce this at mainline.


Thanks, Anand
