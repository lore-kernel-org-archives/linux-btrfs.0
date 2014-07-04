Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43274 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754722AbaGDGRB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jul 2014 02:17:01 -0400
Message-ID: <53B645D4.1060003@cn.fujitsu.com>
Date: Fri, 4 Jul 2014 14:12:36 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: 3.15.1: kernel BUG at fs/btrfs/locking.c:269
References: <53B5125F.4070707@cn.fujitsu.com> <20140703134421.GS26932@merlins.org> <53B62481.3030606@cn.fujitsu.com> <20140702204152.GI20961@merlins.org> <20140703081318.GB20612@localhost.localdomain> <53B5125F.4070707@cn.fujitsu.com> <20140703134421.GS26932@merlins.org> <20140704030721.GE20612@localhost.localdomain> <20140704041102.GS11539@merlins.org> <53B63BB9.2020208@cn.fujitsu.com> <20140704060253.GV11539@merlins.org>
In-Reply-To: <20140704060253.GV11539@merlins.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/04/2014 02:02 PM, Marc MERLIN wrote:
> On Fri, Jul 04, 2014 at 01:29:29PM +0800, Wang Shilong wrote:
>>> Well, I explained the problem, ext4 and others of course tell me which
>>> devid
>>> an error is on, hopefully btrfs will able to do so in the near future.
>> So it is ok for you to print one of btrfs filesystem device(for example
>> device name) ? maybe it is not really physical address the metadata
>> locates in, this is easier.
> Yes, the device name is great, now I can see which of my 3 filesystems has a
> problem, that's a start.
> Next would be knowing which filename this occurred in, but I understand this
> would be harder to get from that point in the code.
> Ideally scrub should be able to find that problem and report it, at least I
> would know which filesystem to rescan for errors:
>
>>> Back to the original problem, would you agree that
>>> find / -type f -print0 | xargs grep . >/dev/nul?
> I'll also have to try this to see if I get lucky with it :)
>
>> +       printk_ratelimited("BTRFS (device: %s) parent transid verify
>> failed on %llu wanted %llu found %llu\n",
>> +                       eb->fs_info->sb->s_id, eb->start,
>> +                       parent_transid, btrfs_header_generation(eb));
> That looks great. Ideally all such errors would look like this.
OK,  i found there is a mirror num recorded  in struct @extent_buffer, 
so it is not diffcult
to locate the real physical address that this corrupt metadata block 
locates.

But another question is that if such problems happen, it should also 
help little, because
usually other mirrors maybe have the same errors...

Looking at btrfs codes, if it found such error which means checksum has 
passed but generation
verification fails it  dosen't even try other mirrors if existed, so i 
supposed such kinds of errors
is fatal and could be corrected by btrfs itself..

Anyway, let me see if there are any other output even dose not output 
btrfs specific info.

Thanks,
>
> Thanks for looking into this, I appreciate it.
>
> Best,
> Marc

