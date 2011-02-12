From: Erik Logtenberg <erik@logtenberg.eu>
Subject: Re: no space left on device
Date: Sat, 12 Feb 2011 15:11:50 +0100
Message-ID: <4D569526.1010506@logtenberg.eu>
References: <BfUOQPXT1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BfUOQPXT1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


>> That patch is released on this list on january 26th, called "Fix
>> balance panic". If you experience the same, you could try applying
>> this patch too. There is no (pre-built) kernel yet with this patch
>> already applied.
> 
> Maybe it will help. But my actual problem is: I cannot mount the btrfs  
> system (it leads to "kernel panic"). And starting "btrfs filesystem  
> balance ..." requires a mounted btrfs system.

Yeah sorry, I hadn't noticed that. No, that patch will certainly not fix
a filesystem you can't mount to begin with. Can't help you out.

 - Erik
