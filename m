From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: switching "balance" into background
Date: 09 Apr 2011 11:04:00 +0200
Message-ID: <BjW+ZCyi1uB@helmut.hullen.de>
References: <20110409084445.GD5301@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110409084445.GD5301@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 09.04.11:

>> I can't switch a running "btrfs filesystem balance ..." via
>>
>>         ctrl z
>>         bg
>>
>> into the background,

[...]

>    I've got a patch that forks the process, and runs the ioctl in the
> background, returning immediately. I should be able to get it to the
> list this weekend as part of the userspace side of the balance
> management patches.

Sounds fine - thank you!

Viele Gruesse!
Helmut
