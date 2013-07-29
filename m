Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:62192 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab3G2MGe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jul 2013 08:06:34 -0400
Received: by mail-pd0-f178.google.com with SMTP id w10so2520978pde.37
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jul 2013 05:06:33 -0700 (PDT)
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Recovering from btrfs error Couldn't read chunk root.
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <CAA6RbiqwS8mvZERdENv1ixD+=He9HehmA6rMtcW8wSGud+V6nA@mail.gmail.com>
Date: Mon, 29 Jul 2013 20:06:27 +0800
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <EECFF15F-5957-4186-99B2-CC1B656861B5@gmail.com>
References: <CAA6RbirvdqOvCcWi1qGG1+USCmcc9J=ECXGJiUH3anHa5EaP7g@mail.gmail.com> <8E1258E3-BCFC-406E-B8F6-2ABB3280C9F0@gmail.com> <CAA6RbiqwS8mvZERdENv1ixD+=He9HehmA6rMtcW8wSGud+V6nA@mail.gmail.com>
To: Kyriakos <kyriakosbrastianos@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


ÔÚ 2013-7-29£¬ÉÏÎç2:12£¬Kyriakos <kyriakosbrastianos@gmail.com> Ð´µÀ£º

> Just tried it as you said with the -v option enabled
> This is my output:
> 
> http://bpaste.net/show/118112/
> 
> 
This is a *long* email, and seems that btrfs list refuse it.

>  Device extent: devid = 1, start = 1667558801408, len = 1073741824,
> chunk offset = 1663255445504
> Couldn't map the block 626309926912
> btrfs: volumes.c:1020: btrfs_num_copies: Assertion `!(ce->start >
> logical || ce->start + ce->size < logical)' failed.
> Aborted (core dumped)

Strange enough, we don't find any chunks during scanning process.

And seems this is unrecoverable ~_~


Wang,
> 
> 
> Any thoughts?
> 
> On 28 July 2013 08:17, Wang Shilong <wangshilong1991@gmail.com> wrote:
>> Hello,
>> 
>> It seems Btrfs Chunk Tree is damaged, so you can not mount Btrfs filesystem any more.
>> 
>> However, you can try the latest Btrfs-progs, Miao Xie implements chunk tree recover function.
>> 
>> The url is:
>> 
>>        git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
>> 
>> 
>> you can try it:
>>                btrfs chunk-recover  -v <dev>
>> 
>> This is Time-consuming, because it will scan the whole disk. And also,
>> please catch output of processing(this is helpful to us if the recovery fails, -v option
>> enable this).
>> 
>> Thanks,
>> Wang
>> 
>> 
>> 
>> 
>> 
>> 

