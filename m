From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: [PATCH v2 2/2] Cancel filesystem balance.
Date: 12 Nov 2010 09:08:00 +0100
Message-ID: <B$jN0wNT1uB@helmut.hullen.de>
References: <4CDCC258.1050402@csamuel.org>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CDCC258.1050402@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Chris,

Du meintest am 12.11.10:

>> Is there any blocker that prevents us from canceling balance
>> by just Ctrl+C ?

> Given that there's been at least 1 report of it taking 12 hours
> to balance a non-trivial amount of data I suspect putting this
> operation into the background by default and having the cancel
> option might be a better plan.

> Thoughts ?

Here: 17 hours for adding a 1.5-TByte partition with 1 TByte data.  
That's no foreground job. Even monitoring blocks a console for a long  
time.

I've seen log entries in "/var/log/messages" - they don't (didn't) show  
how much work was remaining, but they showed at least that btrfs was  
still working hard.

Nov  9 06:52:35 Arktur kernel: btrfs: relocating block group 1546888675328 flags 1
Nov  9 06:53:20 Arktur kernel: btrfs: relocating block group 1545814933504 flags 1
...
Nov 10 00:14:01 Arktur kernel: btrfs: relocating block group 12582912 flags 1
Nov 10 00:14:06 Arktur kernel: btrfs: relocating block group 4194304 flags 4

Viele Gruesse!
Helmut
