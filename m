Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53564 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab3BMEi4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 23:38:56 -0500
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 1655F3EE0BC
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Feb 2013 13:38:55 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id EBE2345DE4E
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Feb 2013 13:38:54 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id C9C6945DE4D
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Feb 2013 13:38:54 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id B6FE91DB803E
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Feb 2013 13:38:54 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 6D6DC1DB8038
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Feb 2013 13:38:54 +0900 (JST)
Message-ID: <511B18BD.7070706@jp.fujitsu.com>
Date: Wed, 13 Feb 2013 13:38:21 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: Zach Brown <zab@redhat.com>, Eric Sandeen <sandeen@redhat.com>,
        chris.mason@fusionio.com, dsterba@suse.cz, kreijack@gmail.com
Subject: Re: [PATCH] Btrfs-progs: check out if the swap device
References: <201302120125.AA00019@FM-323941448.jp.fujitsu.com> <5119C379.7080305@redhat.com> <5119D813.40101@jp.fujitsu.com> <511A8228.9060109@redhat.com> <20130212205731.GA11872@lenny.home.zabbo.net>
In-Reply-To: <20130212205731.GA11872@lenny.home.zabbo.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, All,

Thanks for advice.

On 2013/02/13 5:57, Zach Brown wrote:
>>>
>>> So, I chose this one. (read /proc/swaps)
>>
>> Sure, I think your change is good.  I just think perhaps mkfs should also try
>> to open O_EXCL after all those other tests, as a last safety check.
>
> I think mkfs should first try an O_EXCL open.  If that works it doesn't
> need to do any of this work to try and predict if the open will fail.
>
> After it fails it can poke around a bit to try and give nice context for

> why it failed.  But it might not be able to because /proc/swaps is
> fundamentally unreliable.

Then, how should we do?    I have no idea...

>
>>>>>            file = av[optind++];
>>>>> +        ret = is_swap_device(file);
>
> The input string is a CWD-realtive path.  You'd at least want to use
> realpath() to get it to a canonical name.  So it's not full of junk like
> "./" and "../../.." which won't be present in /proc/swaps.
>
>>>>> +    char    buf[1024];
>
> Use PATH_MAX so it doesn't fail on absurd but allowed file names.
> (Where on earth does 1024 come from?)
>
>>>>> +    if ((f = fopen("/proc/swaps", "r")) == NULL)
>>>>> +        return -errno;
>
> As was pointed out, there's no reason this failure should stop mkfs.
> /proc/swaps might not be available or allowed and I should still be able
> to do an unpriviledged "./mkfs ./myfile; ./btrfs-debug-tree ./myfile".
>
>>>>> +        if (strcmp(file, buf) == 0) {
>>>>> +            ret = 1;
>>>>> +            break;
>>>>> +        }
>
> The command line path that lead to the inode might not be the path for
> the inode that is in /proc/swaps.  Bind mounts, chroot, name spaces,
> hard links, etc, all make it possible -- though unlikely -- that mkfs
> simply won't be able to tell if the path names are related.

OK. I agree.

 >
> Also, /proc/swaps escapes whitespace in file names.  So you could be
> comparing "swap file" with "swap\040file".

I had forgotten this. Thank you for pointing it out.

>
>>>>> +        if ((stat(buf, &st_buf) == 0) && S_ISBLK(st_buf.st_mode) &&
>>>>> +            rdev == st_buf.st_rdev) {
>>>>> +            ret = 1;
>>>>> +            break;
>>>>> +        }
>
> One possible alternative is to then try and open every swap file path to
> see if it points to the same inode as the path mkfs was given.  But you
> might not have access to the paths and we're back to the unpriviledged
> failure case.

I want to think about a new patch later. and, I will post it again if it
seems to make a sense.

Thanks,
Tsutomu


