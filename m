Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from y235201.ppp.asahi-net.or.jp ([118.243.235.201]:46633 "EHLO
	mactop" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754571Ab3HMFhf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Aug 2013 01:37:35 -0400
Received: from [10.81.1.3] (mydomain.com [10.81.1.3])
	by mactop (Postfix) with ESMTP id 796605FA3D
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Aug 2013 14:37:30 +0900 (JST)
Message-ID: <5209C61A.5010702@parallels.com>
Date: Tue, 13 Aug 2013 14:37:30 +0900
From: dima <dolenin@parallels.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-ino-cache is running on each reboot
References: <52098BDB.5010400@parallels.com> <pan$9b25b$c3cfd854$ecd09a4$c58fb9da@cox.net>
In-Reply-To: <pan$9b25b$c3cfd854$ecd09a4$c58fb9da@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/13/2013 01:09 PM, Duncan wrote:
> dima posted on Tue, 13 Aug 2013 10:28:59 +0900 as excerpted:
>
>> About a week or so ago I noticed that [btrfs-ino-cache] process was
>> appearing in the 'top' on each reboot and disk is spinning like crazy
>> for about five minutes or so. Quite so often this caused X failing to
>> start because all I/O was busy with caching.
>> Even after letting it to calm down and seeing [btrfs-ino-cache]
>> disappearing from the process list, on next reboot it starts all over
>> again.
>
>> inode_cache was always enabled since the FS was created about a year or
>> so ago, and actually I have never had any problems with it up until
>> recently.
>>
>> Removing inode_cache option from fstab solves the problem, but I am not
>> sure if it is the right choice.
>
> A number of people have reported problems with inode_cache enabled, and
> the recommendation has always been to turn it off "unless you need it".
> Easy enough problem to fix, I guess. =:^)
>
> Of course that immediately invites the question of why have the option at
> all if all it does is cause trouble, and (as a user not a dev) I don't
> have the answer to that.  I don't know the use case when "unless you need
> it" would actually apply, but apparently, it does in some cases.
>
> I guess the wiki[1] should really have a warning on that option, but
> without a more solid reason than "just don't turn it on, causes more
> trouble than it's worth", I'd feel kind of goofy adding it.
>
> Anyway, yes, the general recommendation on the list at this point seems
> to be to simply leave inode_cache off and not worry about it.


Thanks Duncan. So I did.
I was just wondering why it stopped behaving all of a sudden.



> ---
> [1] https://btrfs.wiki.kernel.org/
>
