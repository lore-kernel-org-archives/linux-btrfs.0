From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: no space left on device
Date: 08 Feb 2011 20:43:00 +0100
Message-ID: <BfUOQPXT1uB@helmut.hullen.de>
References: <4D5191F2.5080509@logtenberg.eu>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D5191F2.5080509@logtenberg.eu>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Erik,

Du meintest am 08.02.11:

>>> But the next step is to update kernel and btrfs-progs from git.

>> Maybe that doesn't help now. I'm working with kernel 2.6.37 and
>> kernel 2.6.38-rc2, and I've got big problems.

[...]

> Fortunately Zheng Yan coded a patch, which I
> applied to 2.6.38-rc2, so that I could finally run - and finish - the
> balance operation.

[...]

> That patch is released on this list on january 26th, called "Fix
> balance panic". If you experience the same, you could try applying
> this patch too. There is no (pre-built) kernel yet with this patch
> already applied.

Maybe it will help. But my actual problem is: I cannot mount the btrfs  
system (it leads to "kernel panic"). And starting "btrfs filesystem  
balance ..." requires a mounted btrfs system.

I'll see ...

Viele Gruesse!
Helmut
