Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:37455 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbaBJOfu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 09:35:50 -0500
Received: by mail-qc0-f176.google.com with SMTP id e16so10530802qcx.21
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 06:35:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAP9B-QmQVys_hZ_2OgDwX4S2YGV1Q6Af6msKqrrNLM8TtVRq0w@mail.gmail.com>
References: <CABgvyo-osstpR9wYa0jPp56bFsbUKov4b5po8Wsjg6NiV6r9FA@mail.gmail.com>
 <CAP9B-QmQVys_hZ_2OgDwX4S2YGV1Q6Af6msKqrrNLM8TtVRq0w@mail.gmail.com>
From: =?UTF-8?Q?Johan_Kr=C3=B6ckel?= <johan.kroeckel@gmail.com>
Date: Mon, 10 Feb 2014 15:35:09 +0100
Message-ID: <CABgvyo8HrLsJ7qexkcksk8=B=uki+AvfsHFFMEnXNsUfk7RPFA@mail.gmail.com>
Subject: Re: scrub crashed?
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you Shilong, that was the problem.

2014-02-10 Shilong Wang <wangshilong1991@gmail.com>:
> Hello Johan,
>
> This should be a known problem.
>
> The problem seemed that scrub log file is corrupt, so i added an option
> -f something like:
>
> btrfs scrub start -f <..>
>
> You can update latest btrfs-progs from david's latest integration
> branch and try it. if you don't
> want to do that, just rm /var/lib/btrfs/scrub* should fix your problem.
>
> Hopely it can help you.^_^
>
> Thanks,
> Wang
>
>
> 2014-02-10 22:02 GMT+08:00 Johan Kröckel <johan.kroeckel@gmail.com>:
>> root@fortknox:~# uname -a
>> Linux fortknox 3.12-0.bpo.1-amd64 #1 SMP Debian 3.12.9-1~bpo70+1
>> (2014-02-07) x86_64 GNU/Linux
>> root@fortknox:~# btrfs version
>> Btrfs v3.12
>> root@fortknox:~# btrfs scrub status -d /bunker
>> scrub status for 11312131-3372-4637-b526-35a4ef0c31eb
>> scrub device /dev/mapper/bunkerA (id 1) status
>>         scrub started at Sun Feb  9 19:12:22 2014, running for 11317 seconds
>>         total bytes scrubbed: 325.32GiB with 0 errors
>> scrub device /dev/dm-1 (id 2) status
>>         scrub started at Sun Feb  9 19:12:22 2014, running for 11317 seconds
>>         total bytes scrubbed: 321.76GiB with 0 errors
>> root@fortknox:~# btrfs scrub cancel /bunker
>> ERROR: scrub cancel failed on /bunker: not running
>> root@fortknox:~# btrfs scrub start /bunker
>> ERROR: scrub is already running.
>> To cancel use 'btrfs scrub cancel /bunker'.
>> To see the status use 'btrfs scrub status [-d] /bunker'.
>> root@fortknox:~# ps -A|grep btrfs
>>  3704 ?        00:00:00 btrfs-genwork-1
>>  3705 ?        00:00:00 btrfs-submit-1
>>  3706 ?        00:00:00 btrfs-delalloc-
>>  3707 ?        00:00:00 btrfs-fixup-1
>>  3708 ?        00:00:02 btrfs-endio-1
>>  3709 ?        00:00:00 btrfs-endio-met
>>  3710 ?        00:00:00 btrfs-rmw-1
>>  3711 ?        00:00:00 btrfs-endio-rai
>>  3712 ?        00:00:00 btrfs-endio-met
>>  3714 ?        00:00:05 btrfs-freespace
>>  3715 ?        00:00:00 btrfs-delayed-m
>>  3716 ?        00:00:00 btrfs-cache-1
>>  3717 ?        00:00:00 btrfs-readahead
>>  3718 ?        00:00:00 btrfs-flush_del
>>  3719 ?        00:00:00 btrfs-qgroup-re
>>  3720 ?        00:00:00 btrfs-cleaner
>>  3721 ?        00:02:00 btrfs-transacti
>>  8380 ?        00:00:00 btrfs-endio-wri
>>  8836 ?        00:00:00 btrfs-worker-4
>>  8936 ?        00:00:00 btrfs-worker-3
>>  8961 ?        00:00:00 btrfs-worker-3
>>  9138 ?        00:00:00 btrfs-worker-4
>>
>> What can/should I do now?
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
