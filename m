Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:10225 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726871AbeHDPU1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 4 Aug 2018 11:20:27 -0400
Message-ID: <5B65A7E9.90607@huawei.com>
Date: Sat, 4 Aug 2018 21:19:37 +0800
From: zhong jiang <zhongjiang@huawei.com>
MIME-Version: 1.0
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
CC: <clm@fb.com>, <jbacik@fb.com>, <dsterba@suse.com>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] btrfs/extent_map: Remove unneeded variable "ret"
References: <1533381223-16734-1-git-send-email-zhongjiang@huawei.com> <20180804125947.GF2049@fnst.localdomain>
In-Reply-To: <20180804125947.GF2049@fnst.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/8/4 20:59, Lu Fengqi wrote:
> On Sat, Aug 04, 2018 at 07:13:43PM +0800, zhong jiang wrote:
>> The ret is not used after initalization, So just remove it.
> So why not change these two functions to void function?
>
 I just keep the original interface  and make the minimal change.
of course,   It is also feasible that make these two functions to void function.

I will repost if  you prefer to that change.  I am ok with that.

Thanks,
zhong jiang

