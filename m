Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:61105 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751797AbeCWIRw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Mar 2018 04:17:52 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id DDD6DAC00D4
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 17:17:48 +0900 (JST)
Subject: Re: [PATCH] btrfs: ctree.h: Fix wrong comment position about csum
 size
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cacb081b-619f-413e-0ebf-38f8e8af3d25@jp.fujitsu.com>
 <34461665-141e-55a5-ea29-ebc20cf939de@gmx.com>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <193e1333-7ea1-5fc9-d719-fade3e0b014d@jp.fujitsu.com>
Date: Fri, 23 Mar 2018 17:17:43 +0900
MIME-Version: 1.0
In-Reply-To: <34461665-141e-55a5-ea29-ebc20cf939de@gmx.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/03/20 17:50, Qu Wenruo wrote:
> 
> 
> On 2018年03月20日 14:47, Misono, Tomohiro wrote:
>>
>> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> 
> BTW this reminds me that, btrfs-progs is still using BTRFS_CRC32_SIZE
> macro which the original comment is for.
> 
> It may be a good time to clean it up in btrfs-progs.
> 
> Thanks,
> Qu

Thanks for the suggestion, I will send a cleanup patch.

