Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34196 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727623AbeITCKK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 22:10:10 -0400
Subject: Re: very poor performance / a lot of writes to disk with space_cache
 (but not with space_cache=v2)
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Martin Steigerwald <martin@lichtvoll.de>
Cc: Tomasz Chmielewski <tch@virtall.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <e0f21dace16885d1bd615dd723235d57@virtall.com>
 <e712843a-d902-97c1-7270-84dfe56c83e1@mendix.com>
 <1646602.qIcv3L3msO@merkaba>
 <6d38300b-621c-a0e0-9bcc-6aafaa9d6f4e@mendix.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a8d38da3-8aa3-f4a3-8836-c6cf14fc9ad0@suse.com>
Date: Wed, 19 Sep 2018 23:30:32 +0300
MIME-Version: 1.0
In-Reply-To: <6d38300b-621c-a0e0-9bcc-6aafaa9d6f4e@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.09.2018 23:11, Hans van Kranenburg wrote:
> On 09/19/2018 10:04 PM, Martin Steigerwald wrote:
>> Hans van Kranenburg - 19.09.18, 19:58:
>>> However, as soon as we remount the filesystem with space_cache=v2 -
>>>
>>>> writes drop to just around 3-10 MB/s to each disk. If we remount to
>>>> space_cache - lots of writes, system unresponsive. Again remount to
>>>> space_cache=v2 - low writes, system responsive.
>>>>
>>>> That's a huuge, 10x overhead! Is it expected? Especially that
>>>> space_cache=v1 is still the default mount option?
>>>
>>> Yes, that does not surprise me.
>>>
>>> https://events.static.linuxfound.org/sites/events/files/slides/vault20
>>> 16_0.pdf
>>>
>>> Free space cache v1 is the default because of issues with btrfs-progs,
>>> not because it's unwise to use the kernel code. I can totally
>>> recommend using it. The linked presentation above gives some good
>>> background information.
>>
>> What issues in btrfs-progs are that?
> 
> Missing code to make offline changes to a filesystem that has a free
> space tree. So when using btrfstune / repair / whatever you first need
> to remove the whole free space tree with a command, and then add it back
> on the next mount.

And as a matter of fact this code has already been published on the
mailing list for review, and even some parts got merged so we are in
good shape to get it into progs and eventually switch the kernel to
default to v2 cache.
> 
> For me personally that's not a problem (I don't have to make offline
> changes), but I understand that having that situation out of the box for
> every new user would be a bit awkward.
> 
>> I am wondering whether to switch to freespace tree v2. Would it provide 
>> benefit for a regular / and /home filesystems as dual SSD BTRFS RAID-1 
>> on a laptop?
> 
> As shown in the linked presentation, it provides benefit on a largeish
> filesystem and if your writes are touching a lot of different block
> groups (since v1 writes out the full space cache for all of them on
> every transaction commit). I'd say, it provides benefit as soon as you
> encounter filesystem delays because of it, and as soon as you see using
> it eases the pain a lot. So, yes, that's your case.
> 
