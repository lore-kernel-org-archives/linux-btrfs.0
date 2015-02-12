Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:64897 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385AbbBLMVU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Feb 2015 07:21:20 -0500
Received: by mail-ig0-f178.google.com with SMTP id hl2so3232534igb.5
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 04:21:20 -0800 (PST)
Message-ID: <54DC9AB9.7030505@gmail.com>
Date: Thu, 12 Feb 2015 07:21:13 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Kai Krakow <hurikhan77@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs performance, sudden drop to 0 IOPs
References: <CABdHLQ7QPjUbzqNdzCfR0QxC-0coYs0dofuFvsROYXy-M9u4ig@mail.gmail.com> <pan$321bc$90037b7$6ca4e371$e54e1a3b@cox.net> <CABdHLQ6La7BO-TJ3cYEx_NnOUhAYJ69uv3tGnVRYsWkiUrqCsQ@mail.gmail.com> <pan$9532$65b1220e$320184ed$94bcf659@cox.net> <62ntqb-o2r.ln1@hurikhan77.spdns.de>
In-Reply-To: <62ntqb-o2r.ln1@hurikhan77.spdns.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-02-11 23:33, Kai Krakow wrote:
> Duncan <1i5t5.duncan@cox.net> schrieb:
>
>> P. Remek posted on Tue, 10 Feb 2015 18:44:33 +0100 as excerpted:
>>
>>> In the test, I use --direct=1 parameter for fio which basically does
>>> O_DIRECT on target file. The O_DIRECT should guarantee that the
>>> filesystem cache is bypassed and IO is sent directly to the underlaying
>>> storage. Are you saying that btrfs buffers writes despite of O_DIRECT?
>>
>> I'm out of my (admin, no claims at developer) league on that.  I see
>> someone else replied, and would defer to them on this.
>
> I don't think that O_DIRECT can work efficiently on COW filesystems. It
> probably has a negative effect and cannot be faster as normal access. Linus
> itself said one time that O_DIRECT is broken and should go away, and instead
> cache hinting should be used.
>
> Think of this: For the _unbuffered_ direct-io request to be fulfilled the
> file system has to go through its COW logic first which it otherwise had
> buffered and done in background. Bypassing the cache is probably only a
> side-effect of O_DIRECT, not its purpose.
IIUC, the original purpose of O_DIRECT was to allow the application to 
handle caching itself, instead of having the kernel do it.  The issue is 
that it is (again, IIUC) a hard requirement for AIO, which is a 
performance booster for many use cases.
>
> At least I'd try with a nocow-file for the benchmark if you still have to
> use O_DIRECT.
>
I'd definitely suggest using NOCOW for any file you are doing O_DIRECT 
with, as you should see _much_ better performance that way, and also 
don't run the (theoretical) risk of some of the same types of corruption 
that swapfiles on BTRFS can cause.
