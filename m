Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:43380 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab3G3Nc4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jul 2013 09:32:56 -0400
Received: by mail-pa0-f49.google.com with SMTP id bi5so7118691pad.8
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jul 2013 06:32:56 -0700 (PDT)
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Recovering from btrfs error Couldn't read chunk root.
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <CAA6Rbipj3j30ASmAJ3KvQtBwwpsU-2H6rbwhfSkN9=jnvoxQsQ@mail.gmail.com>
Date: Tue, 30 Jul 2013 21:32:50 +0800
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <C5861C9F-B907-4CDE-A0C3-B99909491B0E@gmail.com>
References: <CAA6RbirvdqOvCcWi1qGG1+USCmcc9J=ECXGJiUH3anHa5EaP7g@mail.gmail.com> <8E1258E3-BCFC-406E-B8F6-2ABB3280C9F0@gmail.com> <CAA6RbiqwS8mvZERdENv1ixD+=He9HehmA6rMtcW8wSGud+V6nA@mail.gmail.com> <EECFF15F-5957-4186-99B2-CC1B656861B5@gmail.com> <CAA6Rbipj3j30ASmAJ3KvQtBwwpsU-2H6rbwhfSkN9=jnvoxQsQ@mail.gmail.com>
To: Kyriakos <kyriakosbrastianos@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

> Unrecoverable?
> I know i cant mount and have access but my data are still there intact
> ( as i was using them till the reboot) i shouldn't be able to
> extract/recover them to another disc? With any magic command without
> mounting?
> Any other solutions?

As We Know chunk Tree really plays a vital role in btrfs filesystem, And it seems
your chunk Tree is totally damaged, And it is ok to recover chunk tree if block groups
are ok, Unfortunately, dd seems to destroy some of them.

Maybe you can refers to commands btrfs-restore's help, i guess it doesn't work either.

Thank,
Wang
> 
> http://bpaste.net/show/118112/
> 
> On 29 July 2013 15:06, Wang Shilong <wangshilong1991@gmail.com> wrote:
>> 
>> ÔÚ 2013-7-29£¬ÉÏÎç2:12£¬Kyriakos <kyriakosbrastianos@gmail.com> Ð´µÀ£º
>> 
>>> Just tried it as you said with the -v option enabled
>>> This is my output:
>>> 
>>> http://bpaste.net/show/118112/
>>> 
>>> 
>> This is a *long* email, and seems that btrfs list refuse it.
>> 
>>> Device extent: devid = 1, start = 1667558801408, len = 1073741824,
>>> chunk offset = 1663255445504
>>> Couldn't map the block 626309926912
>>> btrfs: volumes.c:1020: btrfs_num_copies: Assertion `!(ce->start >
>>> logical || ce->start + ce->size < logical)' failed.
>>> Aborted (core dumped)
>> 
>> Strange enough, we don't find any chunks during scanning process.
>> 
>> And seems this is unrecoverable ~_~
>> 
>> 
>> Wang,
>>> 
>>> 
>>> Any thoughts?
>>> 
>>> On 28 July 2013 08:17, Wang Shilong <wangshilong1991@gmail.com> wrote:
>>>> Hello,
>>>> 
>>>> It seems Btrfs Chunk Tree is damaged, so you can not mount Btrfs filesystem any more.
>>>> 
>>>> However, you can try the latest Btrfs-progs, Miao Xie implements chunk tree recover function.
>>>> 
>>>> The url is:
>>>> 
>>>>       git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
>>>> 
>>>> 
>>>> you can try it:
>>>>               btrfs chunk-recover  -v <dev>
>>>> 
>>>> This is Time-consuming, because it will scan the whole disk. And also,
>>>> please catch output of processing(this is helpful to us if the recovery fails, -v option
>>>> enable this).
>>>> 
>>>> Thanks,
>>>> Wang
>>>> 
>>>> 
>>>> 
>>>> 
>>>> 
>>>> 
>> 

