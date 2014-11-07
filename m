Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29259 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750998AbaKGBRN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Nov 2014 20:17:13 -0500
Message-ID: <545C1DFF.2070403@cn.fujitsu.com>
Date: Fri, 7 Nov 2014 09:18:55 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: don't do async reclaim during log replay V2
References: <1411054037-20136-1-git-send-email-jbacik@fb.com> <5448C006.1070808@cn.fujitsu.com> <545B8817.2040107@fb.com>
In-Reply-To: <545B8817.2040107@fb.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 6 Nov 2014 09:39:19 -0500, Josef Bacik wrote:
> On 10/23/2014 04:44 AM, Miao Xie wrote:
>> On Thu, 18 Sep 2014 11:27:17 -0400, Josef Bacik wrote:
>>> Trying to reproduce a log enospc bug I hit a panic in the async reclaim code
>>> during log replay.  This is because we use fs_info->fs_root as our root for
>>> shrinking and such.  Technically we can use whatever root we want, but let's
>>> just not allow async reclaim while we're doing log replay.  Thanks,
>>
>> Why not move the code of fs_root initialization to the front of log replay?
>> I think it is better than the fix way in this patch because the async reclaimer
>> can help us do some work.
>>
> 
> Because this is simpler.  We could move the initialization forward, but then say somebody comes and adds some other dependency to the async reclaim stuff in the future and doesn't think about log replay and suddenly some poor sap's box panics on mount.  Log replay is a known quantity, we don't have to worry about enospc, so lets make it as simple as possible.  Thanks,

Yes, you are right.

So this patch looks good.

Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>

