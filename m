From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: 800 GByte free, but "no space left"
Date: 06 Dec 2010 15:45:00 +0100
Message-ID: <BbNRoIAi1uB@helmut.hullen.de>
References: <20101206132817.GD4273@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101206132817.GD4273@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 06.12.10:

>>>    Can you try that again with either the latest 2.6.37-rc, or with
>>> the btrfs-unstable kernel? There's a bug in earlier versions that
>>> breaks the reporting of RAID types, which is what I wanted to see
>>> here.

>> Compiling 2.6.37-rc is no big problem, it only needs som time.

Compiling runs ..

>>>> And I don't dare running "balance" again - maybe it reduces the
>>>> available space again and again.

>>>    If you've hit the bug I think you have, then yes, it will.

>> Hmm - it can't get worse ...
>> If the error is related to the kernel or to the btrfs version and I
>> try a newer one: can that lead to more free space?

>    Not yet. I've taken the whole of December off work (using up my
> leave allocation for last year), and my plan is to get myself to the
> point where I can understand enough of the code to fix this
> particular problem.

I love such vacancies planning ...

If/when I install 2.6.37-rc4: should I update btrfs (from the 20101117  
version)?

How can I see that changing the kernel makes things better? It's more  
and more difficult to externalize (?) btrfs directories to other disks  
...

Viele Gruesse!
Helmut
