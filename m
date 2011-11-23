From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: fsck with "err is 1"
Date: 23 Nov 2011 18:32:00 +0100
Message-ID: <ByQ7Wl$y1uB@helmut.hullen.de>
References: <5ED58F1E-368C-414F-BA60-9C8E240338F6@orcaware.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <5ED58F1E-368C-414F-BA60-9C8E240338F6@orcaware.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Blair,

Du meintest am 23.11.11:

>> I can't answer that, but I can tell you that fsck for btrfs right
>> now is almost useless. It can't fix anyting.

> Thank you, I've read that fsck doesn't fix anything.  I was curious
> if doing the scrub would resolve it.

I had tried ... about 4 Tbyte data have gone.

3 disks bundled with data=raid0, metadata=raid1.

One disk had problems, before I run "scrub" I could read most files,  
Running "scrub": all had gone.

One big problem of btrfs seems to be: you can't see on which partition/ 
disk the defect sector (or something else) may be, if there is 1 error  
in 1 partition you have to restore the complete bundle of disks/ 
partitions.

Yes - I know: btrfs is still under construction.

In my special case: the 4 TByte are a kind of video archive. No  
"valuable" data, only "nice to have". And old people still know the  
behaviour of old 35 mm film and/or VHS cassettes: they have errors. But  
these errors don't damage the whole archive.

Viele Gruesse!
Helmut
