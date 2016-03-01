Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12784 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751953AbcCAAq5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Feb 2016 19:46:57 -0500
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
To: Marc Haber <mh+linux-btrfs@zugschlus.de>, <linux-btrfs@vger.kernel.org>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <56D3A56A.20809@cn.fujitsu.com> <20160229153352.GE2334@torres.zugschlus.de>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56D4E621.3010604@cn.fujitsu.com>
Date: Tue, 1 Mar 2016 08:45:21 +0800
MIME-Version: 1.0
In-Reply-To: <20160229153352.GE2334@torres.zugschlus.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Marc Haber wrote on 2016/02/29 16:33 +0100:
> Hi,
>
> On Mon, Feb 29, 2016 at 09:56:58AM +0800, Qu Wenruo wrote:
>> Marc Haber wrote on 2016/02/27 22:14 +0100:
>>> I have again the issue of no space left on device while rebalancing
>>> (with btrfs-tools 4.4.1 on kernel 4.4.2 on Debian unstable):
>>>
>>> mh@fan:~$ sudo btrfs balance start /mnt/fanbtr
>>> ERROR: error during balancing '/mnt/fanbtr': No space left on device
>>
>> It seems that, only when balancing all chunks, ENOSPC error happens.
>>
>> And did you run any other heavy IO at background?
>
> Not when running those last commands for the mailing list post.
>
>> BTW, is there any kernel log when the ENOSPC happens?
>
>> Would you please try the following commands to see which one caused the
>> problem?
>> And would you please provide the dmesg of them?
>>
>> # btrfs balance start -dprofiles=single /mnt/fanbtr
>> # btrfs balance start -mprofile=dup /mnt/fanbtr
>> # btrfs balance start -sprofile=dup /mnt/fanbtr
>
> I have attached the logs. I used logger(1) to have in syslog which
> command I executed, and I have piped the userspace's output to logger
> so that the syslog entries match the userspace output.

Didn't see the attachment though, seems to be filtered by maillist police.

>
> -mprofile gave an error message, I therefore tried -mprofiles, and
> -sprofiles wanted me to use the --force, so I did that as well.
>
> The three balance commands above all three finshed alright without
> running into ENOSPC, while running a plain balance (which is also part
> of the log) errors out every time.

Strange, but at least some small clue to chase.

>
> And, the -dprofiles=single log caused a number of INFOs regarding
> btrfs-cleaner and btrfa-balance processes gotten stuck for more than
> 120 seconds during the run.

That's not normal and it would be a bug.

>
> I now have a kworker and a btfs-transact kernel process taking most of
> one CPU core each, even after the userspace programs have terminated.
> Is there a way to find out what these threads are actually doing?

Did btrfs balance status gives any hint?

Thanks,
Qu

>
> Greetings
> Marc
>


