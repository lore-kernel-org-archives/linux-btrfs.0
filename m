Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39014 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaHAJCE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Aug 2014 05:02:04 -0400
Message-ID: <53DB585F.8040400@oracle.com>
Date: Fri, 01 Aug 2014 17:05:35 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, Miao Xie <miaox@cn.fujitsu.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: integration tree updated
References: <53D1B595.7070908@fb.com>
In-Reply-To: <53D1B595.7070908@fb.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Hi Chris,

  Looks like you missed Miao update (on 17 Jul) to back out the bad
  patch (below), and your integration branch (published on 25 Jul)
  still contains the same.

[PATCH 2/2] Btrfs: fix wrong total device counter after removing a seed 
device

  You should remove it.

  Simple test cases on your integration branch (like btrfs dev del OR
  btrfs/003) is failing due to this and I (+ others would) spend some
  time digging it out


Miao,

  If it helps -
     cur_devices in the loop is null.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000050
IP: [<ffffffffa00a8fc0>] btrfs_rm_device+0x4c0/0x860 [btrfs]

         cur_devices = root->fs_info->fs_devices;
         do {
                 cur_devices->total_devices--;
                 cur_devices = cur_devices->seed;
         } while (device->fs_devices != cur_devices);


  PS: I didn't find the follow-up patch in the mailing list,
     did I missing anything ?

Thanks, Anand


On 07/25/2014 09:40 AM, Chris Mason wrote:
> Hi everyone,
>
> I've pushed out my current integration branch.  It does have a few of
> Miao Xie's patches missing because there were some rejects.  I think
> this was just because some things got pulled in out of order, and I'll
> get it fixed up.
>
> Also missing is Mark's quota snapshot deletion fixes.  They were
> crashing during btrfs/011 with CONFIG_DEBUG_PAGE_ALLOC on.  We'll get
> that nailed down.
>
> integration is subject to rebasing, so please treat it more like a patch
> queue.  It is very lightly tested, the goal is just to show which
> patches are already applied and which ones are still pending.
>
> Thanks!
>
> -chris
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
