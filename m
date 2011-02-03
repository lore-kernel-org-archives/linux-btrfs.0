From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: [Bug #27842] [regression?] hang with 2.6.37 on a BTRFS test machine
Date: 03 Feb 2011 12:46:00 +0100
Message-ID: <BfAAZL8T1uB@helmut.hullen.de>
References: <201102031220.46250.Martin@lichtvoll.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201102031220.46250.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Martin,

Du meintest am 03.02.11:

[...]

> I am stuck with what to try next. Since trying to track it down to a
> specific commit appears too involved for me and its appears also
> quite laborious to get any value debug information out of the kernel
> - cause it can take days for the bug to appear -, I am inclined to
> either test with 2.6.37.1 once its available or just give it a go
> with 2.6.38-rc3 or rc4. Maybe 2.6.38-rc3/4 would be the best bet, I
> have seen a report on the btrfs mailing list of 2.6.38 fixing a BTRFS
> hang bug that appeared with 2.6.37. I am just not sure whether its
> related or not.

I've just checked the 2.6.38-rc[1-3] ChangeLog. Only rc1 (18.1.2011) has  
included many btrfs changes, neither rc2 nor rc3 includes any btrfs  
change.

Viele Gruesse!
Helmut
