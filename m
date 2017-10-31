Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:27932 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751050AbdJaDAc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 23:00:32 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id DD998AC00FF
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 12:00:25 +0900 (JST)
Subject: Re: [PATCH] btrfs-progs: ins: fix arg order in print_inode_item()
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <91513913-9626-da65-5830-b372895f1325@jp.fujitsu.com>
 <6bfbf8c5-3108-3073-1ef0-26cbba0e356d@gmx.com>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Message-ID: <8aec1e05-673b-1615-b52a-623eb1eecaf4@jp.fujitsu.com>
Date: Tue, 31 Oct 2017 12:00:12 +0900
MIME-Version: 1.0
In-Reply-To: <6bfbf8c5-3108-3073-1ef0-26cbba0e356d@gmx.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017/10/30 17:39, Qu Wenruo wrote:
> 
> 
> On 2017年10月30日 16:10, Misono, Tomohiro wrote:
>> In the print_inode_item(), the argument order of sequence and flags are
>> reversed:
>>
>> printf("... sequence %llu flags 0x%llx(%s)\n",
>> 				... 
>> 	       (unsigned long long)btrfs_inode_flags(eb,ii),
>>  	       (unsigned long long)btrfs_inode_sequence(eb, ii),
>> 				...)
>>
>> So, just fix it.
> 
> Not related to this patch, but considering you're going to enhance
> root_item creation, it's also a good idea to print such info like
> c/o/s/r time and parent/receive UUID.
> 
> More patches will never be a bad thing.

Actually parent/received UUID is printed if it exists but c/o/s/r time is not
(for ROOT_ITEM). So, I will send a patch.

Thanks,
Tomohiro 


