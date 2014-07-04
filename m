Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23604 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751260AbaGDFwn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jul 2014 01:52:43 -0400
Message-ID: <53B64022.9050900@cn.fujitsu.com>
Date: Fri, 4 Jul 2014 13:48:18 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: <bo.li.liu@oracle.com>, Marc MERLIN <marc@merlins.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: 3.15.1: kernel BUG at fs/btrfs/locking.c:269
References: <20140702204152.GI20961@merlins.org> <20140703081318.GB20612@localhost.localdomain> <53B5125F.4070707@cn.fujitsu.com> <20140703134421.GS26932@merlins.org> <20140704030721.GE20612@localhost.localdomain>
In-Reply-To: <20140704030721.GE20612@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/04/2014 11:07 AM, Liu Bo wrote:
> On Thu, Jul 03, 2014 at 06:44:21AM -0700, Marc MERLIN wrote:
>> Thanks for the patch. Hopefully this will make it to the next 3.15.x
>> kernel.
>>
>> I also went back to 3.14 anyway since the 'blocked for 120 seconds' look
>> like another instance of deadlocks we've been discussing here.
>>
>> But just curious:
>>
>>>>> [160562.925463] parent transid verify failed on 2776298520576 wanted 41015 found 18120
>> What should I be doing about this?
>> Does it mean that I do have some kind of corruption/damage on my
>> filesystem?
>>
> If there is another copy for the block(RAID1, DUP, RAID5/6), it'd try to read
> the copy and repair the crc with the good one, it's all we can do about it.
>
>> Also, is it possible to have all these messages state which devid they
>> occurred on? I don't even know which device I should be worrying about
>> right now, and although I'm running scrub now, my understanding is that
>> scrub doesn't actually look at FS structures and is likely to miss this
>> anyway.
> Yes we can but it'd need a bit more effort, for now, all device msg we've seen
> in panic info comes from sb->s_id which points to @fs_info->latest_device.
You means something like this:

+       printk_ratelimited("BTRFS (device: %s) parent transid verify 
failed on %llu wanted %llu found %llu\n",
+                       eb->fs_info->sb->s_id, eb->start,
+                       parent_transid, btrfs_header_generation(eb));


>
> thanks,
> -liubo
>
>> Thanks,
>> Marc
>> -- 
>> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
>> Microsoft is to operating systems ....
>>                                        .... what McDonalds is to gourmet cooking
>> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
> .
>

