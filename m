Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:8276 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757379Ab3DPJvr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 05:51:47 -0400
Message-ID: <516D2035.6010800@cn.fujitsu.com>
Date: Tue, 16 Apr 2013 17:56:05 +0800
From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH v2 1/3] Btrfs: split btrfs_qgroup_account_ref into four
 functions
References: <1366101920-13083-1-git-send-email-list.btrfs@jan-o-sch.net> <1366101920-13083-2-git-send-email-list.btrfs@jan-o-sch.net> <516D17F1.4070208@cn.fujitsu.com> <516D1C25.5060103@jan-o-sch.net>
In-Reply-To: <516D1C25.5060103@jan-o-sch.net>
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Jan,

> On Tue, April 16, 2013 at 11:20 (+0200), Wang Shilong wrote:
>> Hello Jan,
>>
>>> The function is separated into a preparation part and the three accounting
>>> steps mentioned in the qgroups documentation. The goal is to make steps two
>>> and three usable by the rescan functionality. A side effect is that the
>>> function is restructured into readable subunits.
>>
>> How about renaming the three functions like:
>>
>> 1> qgroup_walk_old_roots()
>> 2> qgroup_walk_new_root()
>> 3> qgroup_rewalk_old_root()
>>
>> I'd like this function to be meaningful, but not just step1,2,3.
>> Maybe you can think out better function name.
> 
> I'd like to keep it like 1, 2, 3, because that matches the documentation in the
> qgroup pdf and the code has always been documented in those three steps.


Oh, Yes, i have read the pdf carefully. I think the pdf document it three steps
just to make it clear that we need 3 steps. But static checker may want to know what is 3 steps
just by the function name but not to read the pdf.

In fact the tree steps are just do:
1>walk old roots
2>walk new root
3>rewalk old root

So i think rename the function like these will make things better. ^_^

Thanks,
Wang

> 
> Thanks,
> -Jan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 



