Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:65110 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab3G2USX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jul 2013 16:18:23 -0400
Received: by mail-oa0-f43.google.com with SMTP id i10so8859269oag.2
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jul 2013 13:18:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <EECFF15F-5957-4186-99B2-CC1B656861B5@gmail.com>
References: <CAA6RbirvdqOvCcWi1qGG1+USCmcc9J=ECXGJiUH3anHa5EaP7g@mail.gmail.com>
 <8E1258E3-BCFC-406E-B8F6-2ABB3280C9F0@gmail.com> <CAA6RbiqwS8mvZERdENv1ixD+=He9HehmA6rMtcW8wSGud+V6nA@mail.gmail.com>
 <EECFF15F-5957-4186-99B2-CC1B656861B5@gmail.com>
From: Kyriakos <kyriakosbrastianos@gmail.com>
Date: Mon, 29 Jul 2013 23:18:03 +0300
Message-ID: <CAA6Rbipj3j30ASmAJ3KvQtBwwpsU-2H6rbwhfSkN9=jnvoxQsQ@mail.gmail.com>
Subject: Re: Recovering from btrfs error Couldn't read chunk root.
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unrecoverable?
I know i cant mount and have access but my data are still there intact
( as i was using them till the reboot) i shouldn't be able to
extract/recover them to another disc? With any magic command without
mounting?
Any other solutions?

http://bpaste.net/show/118112/

On 29 July 2013 15:06, Wang Shilong <wangshilong1991@gmail.com> wrote:
>
> 在 2013-7-29，上午2:12，Kyriakos <kyriakosbrastianos@gmail.com> 写道：
>
>> Just tried it as you said with the -v option enabled
>> This is my output:
>>
>> http://bpaste.net/show/118112/
>>
>>
> This is a *long* email, and seems that btrfs list refuse it.
>
>>  Device extent: devid = 1, start = 1667558801408, len = 1073741824,
>> chunk offset = 1663255445504
>> Couldn't map the block 626309926912
>> btrfs: volumes.c:1020: btrfs_num_copies: Assertion `!(ce->start >
>> logical || ce->start + ce->size < logical)' failed.
>> Aborted (core dumped)
>
> Strange enough, we don't find any chunks during scanning process.
>
> And seems this is unrecoverable ~_~
>
>
> Wang,
>>
>>
>> Any thoughts?
>>
>> On 28 July 2013 08:17, Wang Shilong <wangshilong1991@gmail.com> wrote:
>>> Hello,
>>>
>>> It seems Btrfs Chunk Tree is damaged, so you can not mount Btrfs filesystem any more.
>>>
>>> However, you can try the latest Btrfs-progs, Miao Xie implements chunk tree recover function.
>>>
>>> The url is:
>>>
>>>        git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
>>>
>>>
>>> you can try it:
>>>                btrfs chunk-recover  -v <dev>
>>>
>>> This is Time-consuming, because it will scan the whole disk. And also,
>>> please catch output of processing(this is helpful to us if the recovery fails, -v option
>>> enable this).
>>>
>>> Thanks,
>>> Wang
>>>
>>>
>>>
>>>
>>>
>>>
>
