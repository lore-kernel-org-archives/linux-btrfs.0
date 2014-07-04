Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43937 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754722AbaGDGXN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jul 2014 02:23:13 -0400
Message-ID: <53B64746.1000105@cn.fujitsu.com>
Date: Fri, 4 Jul 2014 14:18:46 +0800
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
So there is a problem, ususally such generation verifications errors is 
related to
Btrfs metdata block.it is maybe just a Btrfs node , not related to any 
actually files,
or even a leaf that contains more that one file....

If this is a read/write path from normal fs/file root, we may output 
its' root..but if this is
something like extent root...i think it helps little....

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
>
> Thanks for looking into this, I appreciate it.
>
> Best,
> Marc

