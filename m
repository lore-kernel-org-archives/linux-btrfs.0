Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51074 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbbBLUBL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Feb 2015 15:01:11 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YLzwj-00033U-1w
	for linux-btrfs@vger.kernel.org; Thu, 12 Feb 2015 21:01:09 +0100
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 21:01:09 +0100
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 21:01:09 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs performance, sudden drop to 0 IOPs
Date: Thu, 12 Feb 2015 20:42:40 +0100
Message-ID: <gacvqb-mpa.ln1@hurikhan77.spdns.de>
References: <CABdHLQ7QPjUbzqNdzCfR0QxC-0coYs0dofuFvsROYXy-M9u4ig@mail.gmail.com> <pan$321bc$90037b7$6ca4e371$e54e1a3b@cox.net> <CABdHLQ6La7BO-TJ3cYEx_NnOUhAYJ69uv3tGnVRYsWkiUrqCsQ@mail.gmail.com> <pan$9532$65b1220e$320184ed$94bcf659@cox.net> <62ntqb-o2r.ln1@hurikhan77.spdns.de> <54DC9AB9.7030505@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn <ahferroin7@gmail.com> schrieb:

> On 2015-02-11 23:33, Kai Krakow wrote:
>> Duncan <1i5t5.duncan@cox.net> schrieb:
>>
>>> P. Remek posted on Tue, 10 Feb 2015 18:44:33 +0100 as excerpted:
>>>
>>>> In the test, I use --direct=1 parameter for fio which basically does
>>>> O_DIRECT on target file. The O_DIRECT should guarantee that the
>>>> filesystem cache is bypassed and IO is sent directly to the underlaying
>>>> storage. Are you saying that btrfs buffers writes despite of O_DIRECT?
>>>
>>> I'm out of my (admin, no claims at developer) league on that.  I see
>>> someone else replied, and would defer to them on this.
>>
>> I don't think that O_DIRECT can work efficiently on COW filesystems. It
>> probably has a negative effect and cannot be faster as normal access.
>> Linus itself said one time that O_DIRECT is broken and should go away,
>> and instead cache hinting should be used.
>>
>> Think of this: For the _unbuffered_ direct-io request to be fulfilled the
>> file system has to go through its COW logic first which it otherwise had
>> buffered and done in background. Bypassing the cache is probably only a
>> side-effect of O_DIRECT, not its purpose.
> IIUC, the original purpose of O_DIRECT was to allow the application to
> handle caching itself, instead of having the kernel do it.  The issue is
> that it is (again, IIUC) a hard requirement for AIO, which is a
> performance booster for many use cases.

Yes, it was implemented for the purpose of allowing an application to 
implement its own caching - probably for the sole purpose of doing it 
"better" or more efficient. But it simply does not work out that well, at 
least with COW fs. The original idea "performance" is more or less eaten 
away in a COW scenario - or worse. And that in turn is why Linus said 
O_DIRECT is broken and should go away, use cache hinting instead.

>From that perspective, I concluded what I wrote: Bypassing the cache is only 
a side-effect. It didn't solve the problem the right way - it 
unintentionally solved something else. So, to alleviate the design flaw, you 
can only use it for its intended purpose on nocow-files (or nocow-
filesystems).

>> At least I'd try with a nocow-file for the benchmark if you still have to
>> use O_DIRECT.
>>
> I'd definitely suggest using NOCOW for any file you are doing O_DIRECT
> with, as you should see _much_ better performance that way, and also
> don't run the (theoretical) risk of some of the same types of corruption
> that swapfiles on BTRFS can cause.

Dito.

-- 
Replies to list only preferred.

