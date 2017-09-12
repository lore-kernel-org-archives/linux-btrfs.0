Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:44303 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751292AbdILKCa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 06:02:30 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dri0X-0007oP-FO
        for linux-btrfs@vger.kernel.org; Tue, 12 Sep 2017 12:01:29 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: qemu-kvm VM died during partial raid1 problems of btrfs
Date: Tue, 12 Sep 2017 10:01:07 +0000 (UTC)
Message-ID: <pan$556a1$a0a94487$f12a0554$4371a5e6@cox.net>
References: <2ee9f15b-a11a-886e-2460-557bb9f8d41d@rqc.ru>
        <CAGqmi770j8gO8zFNiMgie5n3b6rm2JVdvG+K+HMDJ-CpMCiEiw@mail.gmail.com>
        <69e843f4-1233-261a-3b88-306359ef20c9@rqc.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marat Khalili posted on Tue, 12 Sep 2017 11:42:52 +0300 as excerpted:

> On 12/09/17 11:25, Timofey Titovets wrote:
>> AFAIK, if while read BTRFS get Read Error in RAID1, application will
>> also see that error and if application can't handle it -> you got a
>> problems
>>
>> So Btrfs RAID1 ONLY protect data, not application (qemu in your case).

> That's news to me! Why doesn't it try another copy and when does it
> correct the error then?

AFAIK that's wrong -- the only time the app should see the error on btrfs 
raid1 is if the second copy is also bad (and if it's good, the bad copy 
is automatically rewritten... elsewhere of course, due to cow)... or if 
the problem with btrfs is bad enough it sends the entire filesystem read-
only, which I don't believe happened in your case (it was the ext4 on the 
VM that went ro).

So you should be able to rest easy on that, at least. =:^)

> Any idea on how to work it around at least for
> qemu? (Assemble the array from within the VM?)

BTW, I am most definitely /not/ a VM expert, and won't pretend to 
understand the details or be able to explain further, but IIRC from what 
I've read on-list, qcow2 isn't the best alternative for hosting VMs on 
top of btrfs.  Something about it being cow-based as well, which means cow
(qcow2)-on-cow(btrfs), which tends to lead to /extreme/ fragmentation, 
leading to low performance.  I'd guess that due to the additional stress, 
it may also trigger race conditions and/or deadlocks that wouldn't 
ordinarily trigger.

I don't know enough about it to know what the alternatives to qcow2 are, 
but something that not itself cow when it's on cow-based btrfs, would 
presumably be a better alternative.

Sorry I can't do better on that, but this should at least give you enough 
information to look for more, if no one reposts the details here.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

