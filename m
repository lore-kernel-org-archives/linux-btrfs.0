Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:64875 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750836AbeAQIas (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Jan 2018 03:30:48 -0500
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id E32C5AC00DF
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jan 2018 17:30:39 +0900 (JST)
Subject: Re: [PATCH v4 2/4] btrfs: cleanup btrfs_mount() using
 btrfs_mount_root()
To: Anand Jain <anand.jain@oracle.com>, <dsterba@suse.cz>,
        <linux-btrfs@vger.kernel.org>
References: <7dbb897c-1f1d-b54b-0cea-2a1c6c1d5027@jp.fujitsu.com>
 <eba24d5a-d5ad-b928-27b8-3c7f0b6a0e43@jp.fujitsu.com>
 <28c4963f-9e87-ce42-7c6a-85d32cd71951@oracle.com>
 <20180115192615.GF13726@twin.jikos.cz>
 <2e0c866f-42e4-6a9c-a562-e3724062b0f9@oracle.com>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Message-ID: <f96b3cf7-4853-465b-49a1-fa91f572228a@jp.fujitsu.com>
Date: Wed, 17 Jan 2018 17:30:14 +0900
MIME-Version: 1.0
In-Reply-To: <2e0c866f-42e4-6a9c-a562-e3724062b0f9@oracle.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/01/16 20:45, Anand Jain wrote:
> 
> 
> On 01/16/2018 03:26 AM, David Sterba wrote:
>> On Fri, Jan 12, 2018 at 06:14:40PM +0800, Anand Jain wrote:
>>>
>>> Misono,
>>>
>>>    This change is causing subsequent (subvol) mount to fail when device
>>>    option is specified. The simplest eg for failure is ..
>>>      mkfs.btrfs -qf /dev/sdc /dev/sdb
>>>      mount -o device=/dev/sdb /dev/sdc /btrfs
>>>      mount -o device=/dev/sdb /dev/sdc /btrfs1
>>>         mount: /dev/sdc is already mounted or /btrfs1 busy
>>>
>>>     Looks like
>>>       blkdev_get_by_path() <-- is failing.
>>>       btrfs_scan_one_device()
>>>       btrfs_parse_early_options()
>>>       btrfs_mount()
>>>
>>>    Which is due to different holders (viz. btrfs_root_fs_type and
>>>    btrfs_fs_type) one is used for vfs_mount and other for scan,
>>>    so they form different holders and can't let EXCL open which
>>>    is needed for both scan and open.

BTW, I noticed "btrfs device scan/ready" fails for mounted filesystem
because of this reason. I will send a patch to fix this.
(Though I believe this is not the cause of the problem you mentioned.)

Thanks,
Tomohiro

>>
>> This looks close to what I see in the random test failures. I've
>> reverted your patch "btrfs: optimize move uuid_mutex closer to the
>> critical section" as I bisected to it. The uuid mutex around
>> blkdev_get_path probably protected the concurrent mount and scan so they
>> did not ask for EXCL at the same time.
>>
>> Reverting (or removing the patch from the current misc-next) queue is
>> simpler for me ATM as I want to get to a stable base now, we can add it
>> later if we understand the issue with the mount/scan.
> 
>   Right. I don't see above test case failing on your branch [1] which
>   does not have the uuid_mutex patch. Quite strange, there isn't any
>   concurrency (mount and scan) in this test case.
>   [1]
>     git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
> 
>   Ran xfstests, got stuck at btrfs/011 failures, (and will wait for
>   Liubo's v2 patch). OR is there any other test case you were referring
>   to as random test failures ?
> 
> Thanks, Anand
> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 

