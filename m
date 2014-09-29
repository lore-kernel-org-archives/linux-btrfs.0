Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:57898 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbaI2Brp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Sep 2014 21:47:45 -0400
Received: by mail-wi0-f181.google.com with SMTP id n3so937629wiv.2
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Sep 2014 18:47:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5428B81E.2090708@cn.fujitsu.com>
References: <CAG8k2+6MZHDH6Fb=RPW3=L1h63nk8SOWkZJ6JDR_aTZRWDP1wQ@mail.gmail.com>
	<5428B81E.2090708@cn.fujitsu.com>
Date: Sun, 28 Sep 2014 21:47:44 -0400
Message-ID: <CAG8k2+6J4-j-9cg0mEOE7=b+Wg517WMrqGCVwOmpcd1ETxKxRg@mail.gmail.com>
Subject: Re: bad areas cause btrfs segfault
From: Daniel Holth <dholth@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks

On Sun, Sep 28, 2014 at 9:38 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Hi,
>
> This bug seems to be one reported bug before:
> http://article.gmane.org/gmane.comp.file-systems.btrfs/33270
>
> And Chris has already updated the 3.13 stable branch to fix the bug.
>
> If it is OK for you, updating kernel to 3.14 would be a solution.
> (Since from 3.15, the new btrfs workqueue implementation caused some bug,
> and will be fixed in 3.17,
> 3.15~3.16 is not recommended)
>
> Thanks
> Qu
>
> -------- Original Message --------
> Subject: bad areas cause btrfs segfault
> From: Daniel Holth <dholth@gmail.com>
> To: <linux-btrfs@vger.kernel.org>
> Date: 2014年09月29日 09:11
>>
>> I've got a couple of directories that cause a btrfs segfault. First
>> one happened at the end of July and I just renamed it to get it out of
>> my way (can't delete it without crashing); the second one just
>> happened and I'll be discarding the filesystem.
>>
>> This "crash when touched" behavior is frustrating because it makes it
>> iffy to back up everything else. Usually about the second attempt to
>> touch the bad directory requires a reboot.
>>
>> Instead, I would prefer that the filesystem not crash the whole system
>> when it encounters a corrupted area.
>>
>> I've tried "btrfs scrub" and "btrfs check" but they don't find
>> anything wrong. I guess the next step would be "btrfs restore", but I
>> think I have a good enough backup made with a normal copy skipping the
>> two corrupted directories.
>>
>> Here's my info.
>>
>> $   uname -a
>> Linux cardamom 3.13.0-36-generic #63-Ubuntu SMP Wed Sep 3 21:30:07 UTC
>> 2014 x86_64 x86_64 x86_64 GNU/Linux
>>
>> $   btrfs --version
>> Btrfs v3.12
>>
>> $   btrfs fi show
>> Btrfs v3.12
>>
>> $   btrfs fi df /home # Replace /home with the mount point of your
>> btrfs-filesystem
>> Data, single: total=110.01GiB, used=108.09GiB
>> System, DUP: total=8.00MiB, used=20.00KiB
>> System, single: total=4.00MiB, used=0.00
>> Metadata, DUP: total=3.00GiB, used=2.31GiB
>> Metadata, single: total=8.00MiB, used=0.00
>
>
