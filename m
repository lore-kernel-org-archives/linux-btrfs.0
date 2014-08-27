Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:38389 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935948AbaH0W6u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Aug 2014 18:58:50 -0400
Received: by mail-ob0-f180.google.com with SMTP id m8so23961obr.39
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Aug 2014 15:58:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADw2B2M3+M6-W-bqyQNYXLX4ug0=t9kNOp320UU3G2iN-CGbHQ@mail.gmail.com>
References: <CADw2B2PYPJdcLWvkufY71kvAdCdgXhsdO2Gizf8hXAruppxXPA@mail.gmail.com>
	<pan$427a1$f65bd1f8$7ddfd94c$6b06de1b@cox.net>
	<CADw2B2NX8XY3V_vD-7eN9vj0tHtEfJwdsS4bovQ0cOHus_9Q-g@mail.gmail.com>
	<CADw2B2MJS-pkd+XfwLTpq_pqzQzLWnkzxLcaw8UYjnS-jOF25g@mail.gmail.com>
	<CADw2B2M3+M6-W-bqyQNYXLX4ug0=t9kNOp320UU3G2iN-CGbHQ@mail.gmail.com>
Date: Wed, 27 Aug 2014 15:58:49 -0700
Message-ID: <CADw2B2MmR41K3_qEeHUg0ZQAEojK4T3PTFUeUQxLLxsEiEa8_w@mail.gmail.com>
Subject: Re: fallocate fail on btrfs
From: "G. Richard Bellamy" <rbellamy@pteradigm.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are two things going wrong here.

1. The "open" command fallocate is using isn't passing along the
O_CREAT flag properly.
https://git.kernel.org/cgit/utils/util-linux/util-linux.git/tree/sys-utils/fallocate.c#n368
CODE: fd = open(filename, O_RDWR | (!dig && !mode ? O_CREAT : 0), 0644);
STRACE: open("test.test", O_RDWR) = -1 ENOENT (No such file or directory)

2. If the file DOES exist, the "fallocate" command used by the
fallocate utility isn't setting the length of the file, even though it
thinks it is.
https://git.kernel.org/cgit/utils/util-linux/util-linux.git/tree/sys-utils/fallocate.c#n113
CODE: error = fallocate(fd, mode, offset, length);
STRACE: fallocate(3, 01, 0, 1024000) = 0

2014-08-27 15:49:45
root@eanna i ~ # ls -alh test.test
-rw------- 1 root root 0 Aug 27 15:46 test.test

Is this a bug, known weirdness that I can correct with a
scrub/check/whatever, or....

Regards,
Richard

On Wed, Aug 27, 2014 at 3:51 PM, G. Richard Bellamy
<rbellamy@pteradigm.com> wrote:
> And the strace of fallocate execution against a zero-length file I
> created with touch:
> http://sprunge.us/BRML
>
> You can see in the strace that fallocate thinks it worked (= 0), but
> here's the file post-execution:
> 2014-08-27 15:49:45
> root@eanna i ~ # ls -alh test.test
> -rw------- 1 root root 0 Aug 27 15:46 test.test
>
> On Wed, Aug 27, 2014 at 3:39 PM, G. Richard Bellamy
> <rbellamy@pteradigm.com> wrote:
>> Also, here's the strace of the fallocate call:
>> http://sprunge.us/QXFN
>>
>> On Wed, Aug 27, 2014 at 10:39 AM, G. Richard Bellamy
>> <rbellamy@pteradigm.com> wrote:
>>> Good questions, should have included that info in the OP.
>>>
>>> The current versions I can get, but I'm frankly terrified to try to
>>> roll back to prior versions to "test" this, since back in that land be
>>> monsters with deadlocks preventing degraded volumes from being fixed
>>> and other challenges I wasn't qualified to fix - and it was over three
>>> months ago that I tried fallocate last. I run Arch and aggressively
>>> update, so I can infer what those version were, and will do so, though
>>> I know that is of limited efficacy in helping you help me...
>>>
>>> Best-guess Prior (2014-06-30):
>>> ------------------------------------------------
>>> linux-lts 3.10.45-1
>>> btrfs-progs 3.14.2-2
>>> linux 3.15.2-1
>>> util-linux 2.24.2-1
>>>
>>> Current (2014-08-27 10:28:07):
>>> -----------
>>> rbellamy@eanna i ~ % pacman -Q linux-lts btrfs-progs-git linux util-linux
>>> linux-lts 3.14.17-1
>>> btrfs-progs-git 3.16_108_d34cbe7-1
>>> linux 3.16.1-1
>>> util-linux 2.25-3
>>>
>>> On Tue, Aug 26, 2014 at 11:39 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>>>> G. Richard Bellamy posted on Tue, 26 Aug 2014 22:05:01 -0700 as excerpted:
>>>>
>>>>> When I try to run fallocate with "--keep-size" on my btrfs partitions,
>>>>> it's failing, and I'm at a loss as to why. This was working in prior
>>>>> versions.
>>>>>
>>>>> Any suggestions on how to attack this problem? I'm betting I'm missing
>>>>> something simple here, and have just gone down the rabbit hole...
>>>>>
>>>>> BTW, I've confirmed that the line that fails is fallocate.c:368 [2],
>>>>> with "open" always returning -1.
>>>>
>>>> One "something simple" you're missing (either that or I am) is any
>>>> reference to which version you're running.  You say it was working in
>>>> prior versions, but /which/ prior versions, and /which/ version doesn't
>>>> work now?
>>>>
>>>> --
>>>> Duncan - List replies preferred.   No HTML msgs.
>>>> "Every nonfree program has a lord, a master --
>>>> and if you use the program, he is your master."  Richard Stallman
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
