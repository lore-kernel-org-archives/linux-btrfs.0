Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34003 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751003AbbKXFdd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 00:33:33 -0500
Subject: Re: shall distros run btrfsck on boot?
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Duncan <1i5t5.duncan@cox.net>, <linux-btrfs@vger.kernel.org>
References: <1448337754.14125.33.camel@scientia.net>
 <pan$32768$921cbe34$6a22269c$2c7db710@cox.net>
 <1448340211.14125.44.camel@scientia.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5653F697.7060601@cn.fujitsu.com>
Date: Tue, 24 Nov 2015 13:33:11 +0800
MIME-Version: 1.0
In-Reply-To: <1448340211.14125.44.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Christoph Anton Mitterer wrote on 2015/11/24 05:43 +0100:
> On Tue, 2015-11-24 at 04:35 +0000, Duncan wrote:
>> I'm a list regular and btrfs user, not a dev, but all the indications
>
>> continue to point to _not_ running it automatically at boot, nobody
>> even
>> _suggesting_ otherwise.
> Sure, I just asked because maybe that would have just been an
> anachronism from the days btrfsck was much more alpha.
>
>
>>    The btrfs kernel code itself detects and often
>> corrects many problems, and btrfs check is simply not recommended for
>> automatic at-boot scheduling -- if the kernel code can't fix it
>> without
>> intervention, then the problem is too serious to be fixed without
>> intervention by some scheduled btrfs check run, as well.
> I once had an issue with a btrfs, where the kernel didn't show anything
> but btrfsck did...(not the one Qu's currently looking into).
> And I though the same is basically the case for other filesystems like
> ext.
>
>
>> In fact, take a look at the shipped fsck.btrfs shell-script, based
>> upon
>> the xfs one.  As both the code and the comments suggest, it's
>> specifically designed to simply return success
> Sure, but that could have simply been forgotten to update...
>
>
> Thanks for the update on the status in that matter :)
> Cheers,
> Chris.
>

Another point of never running btrfsck at boot time is, it's super 
SLOOOOOOOOOOOOOOOOOOOW!
And you should have experienced it during the false alert investigation. :)

It's SLOOOOOOOOOOOOOOOOOOW because it will need to iterate all the 
metadata of filesystems to make sure every thing devs can think about is OK.

Unlike traditional filesystem (maybe only ext*), it has some dirty flag 
in superblock or things like that to indicate a filesystem needs extra 
check, and e2fsck will only do comprehensive check if the filesystem is 
dirty.
That's why e2fsck can be run at boot time, as most of time, it just 
finds the fs is clean and no extra check.

But btrfs doesn't use the old-fashion method, it uses COW to protect 
metadata. So btrfsck is only designed to do comprehensive check and it's 
very SLOOOOOOOOOOOOW (not to mention sometimes it's buggy and too 
sensitive to give false alert).

Thanks,
Qu

-- 
This message has been scanned for viruses and
dangerous content by FCNIC, and is
believed to be clean.

