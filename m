Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:52609 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932977AbeF0HzV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 03:55:21 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 36182AC017D
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2018 16:55:18 +0900 (JST)
Subject: Re: Enabling quota may not correctly rescan on 4.17
To: Nikolay Borisov <nborisov@suse.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <0ced0e29-9ecc-01fb-b0a5-9de32966666e@jp.fujitsu.com>
 <02577dd9-af06-95a6-77b4-954b583536e8@suse.com>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <60daf28c-b76c-60b7-34b4-88ea2e5d8ae3@jp.fujitsu.com>
Date: Wed, 27 Jun 2018 16:55:06 +0900
MIME-Version: 1.0
In-Reply-To: <02577dd9-af06-95a6-77b4-954b583536e8@suse.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/06/27 16:40, Nikolay Borisov wrote:
> 
> 
> On 26.06.2018 09:00, Misono Tomohiro wrote:
>> Hello Nikolay,
>>
>> I noticed that commit 5d23515be669 ("btrfs: Move qgroup rescan
>> on quota enable to btrfs_quota_enable") in 4.17 sometimes causes
>> to fail correctly rescanning quota when quota is enabled.
>>
>> Simple reproducer:
>>
>> $ mkfs.btrfs -f $DEV
>> $ mount $DEV /mnt
>> $ dd if=/dev/urandom of=/mnt/file bs=1000 count=1000
>> $ btrfs quota enbale /mnt
>> $ umount /mnt
>> $ btrfs check $DEV
>> ...
>> checking quota groups
>> Counts for qgroup id: 0/5 are different
>> our:            referenced 1019904 referenced compressed 1019904
>> disk:           referenced 16384 referenced compressed 16384
>> diff:           referenced 1003520 referenced compressed 1003520
>> our:            exclusive 1019904 exclusive compressed 1019904
>> disk:           exclusive 16384 exclusive compressed 16384
>> diff:           exclusive 1003520 exclusive compressed 1003520
>> found 1413120 bytes used, error(s) found
>> ...
> 
> I ran your script 100 times with progs 4.17 and 4.18-rc1 and didn't
> observe this error. I didn't observe btrfs/114 also failing but I ran it
> a lot less. Is there anything else i can do to make your small
> reproducer more likely to trigger?

How about btrfs/114? I saw the problem in it first (progs 4.17/kernel 4.18-rc2)
and it seems always happen in my environment. 

> 
>>
>> This can be also observed in btrfs/114. (Note that progs < 4.17
>> returns error code 0 even if quota is not consistency and therefore
>> test will incorrectly pass.)
>>
>> My observation is that this commit changed to call initial quota rescan
>> when quota is enabeld instead of first comit transaction after enabling
>> quota, and therefore if there is something not commited at that time,
>> their usage will not be accounted.
>>
>> Actually this can be simply fixed by calling "btrfs rescan" again or
>> calling "btrfs fi sync" before "btrfs quota enable".
>>
>> I think the commit itself makes the code much easier to read, so it may
>> be better to fix the problem in progs (i.e. calling sync before quota enable).
>>
>> Do you have any thoughts?
>>
>> Thanks,
>> Tomohiro Misono
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

