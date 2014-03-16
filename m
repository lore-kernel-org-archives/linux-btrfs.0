Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:37421 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750715AbaCPAlT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Mar 2014 20:41:19 -0400
From: "quwenruo@cn.fujitsu.com" <quwenruo@cn.fujitsu.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs: Cleanup the btrfs_workqueue related function
 type
Date: Sun, 16 Mar 2014 00:41:17 +0000
Message-ID: <5324F370.4080303@cn.fujitsu.com>
References: <1394079657-24937-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20140314143903.GE32719@twin.jikos.cz>
In-Reply-To: <20140314143903.GE32719@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 14 Mar 2014 15:39:03 +0100, David Sterba wrote:
> On Thu, Mar 06, 2014 at 04:19:50AM +0000, quwenruo@cn.fujitsu.com wrote:
>> @@ -23,11 +23,13 @@
>>   struct btrfs_workqueue;
>>   /* Internal use only */
>>   struct __btrfs_workqueue;
>> +struct btrfs_work;
>> +typedef void (*btrfs_func_t)(struct btrfs_work *arg);
> I don't see what's wrong with the non-typedef type, CodingStyle
> discourages from using typedefs in general (Chapter 5).
>
> The name btrfs_func_t is a generic, if you really need to use a typedef
> here, please change it to something closer to the workqueues, eg.
> btrfs_work_func_t.
>
btrfs_func_t is just following the work_func_t naming style,
for btrfs it's only used to reduce the length of prototype definition.

Since btrfs_func_t is only used in btrfs, this patch can be ignored.

Thanks
Quÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
