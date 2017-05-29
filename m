Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59218 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750823AbdE2AVL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 May 2017 20:21:11 -0400
Subject: Re: [PATCH v4 00/20] Btrfs-progs offline scrub
To: <kreijack@inwind.it>, <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, <lakshmipathi.g@gmail.com>
References: <20170525062205.11660-1-quwenruo@cn.fujitsu.com>
 <e4e15f16-c6b7-a18a-57df-7f404d38107b@inwind.it>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <ee9f0a45-bd92-e534-c98f-a9bb398e10f2@cn.fujitsu.com>
Date: Mon, 29 May 2017 08:21:08 +0800
MIME-Version: 1.0
In-Reply-To: <e4e15f16-c6b7-a18a-57df-7f404d38107b@inwind.it>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 05/27/2017 02:37 AM, Goffredo Baroncelli wrote:
> Hi Qu,
> 
> On 2017-05-25 08:21, Qu Wenruo wrote:
> 
>> And since kernel scrub won't account P/Q corruption, it makes us quite
>> hard to detect error like kernel screwing up P/Q when scrubbing.
> 
> could you elaborate the above sentence: in my test the kernel-scrub (4.12.0-rc2) is able to correct a wrong 'P' parity; am I missing something ?

That's because Liu Bo and I exposed and fixed the bug.

Or the case will still be the same.

Thanks,
Qu

> 
> BR
> G.Baroncelli
> [...]
> 


