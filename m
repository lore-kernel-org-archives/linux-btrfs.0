From: Erik Logtenberg <erik@logtenberg.eu>
Subject: Re: no space left on device
Date: Mon, 07 Feb 2011 22:27:14 +0100
Message-ID: <4D5063B2.4070609@logtenberg.eu>
References: <AANLkTi=KNt1JVq82FR-u9CGA1TcXiknz0c3bbD186U43@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=KNt1JVq82FR-u9CGA1TcXiknz0c3bbD186U43@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Leonidas,

Please check this:

btrfs fi df /home

If this shows much of your space used by metadata then please use:

btrfs fi balance /home

Note that this can take a long (>1 day) time to complete on a big FS.

 - Erik



On 02/07/2011 10:21 PM, Leonidas Spyropoulos wrote:
> Hey all,
> 
> I run into no space left on device on a virtualbox
> 
> After installing Debian 6 on a virtual machine
> I tried installing the KDE desktop
> 
> The system HDD is 8Gb
> Both root (/) and /home are btrfs
> over LVM.
> 
> While installing the packages I run into:
> 
> no space left, need 4096, 4096 dealloc bytes, 1776283648 bytes_used, 0
> bytes_reserved,
> 0 bytes_pinned, 0 bytes_readonly, 0 may use 1776287744 total
> 
> df shows only 74% used space on /
> 
> kernel used: stock debian 6 2.6.32-5-686
> 
> At the moment I cannot access it with normal boot, only recovery mode.
> 
> I can provide whatever info you would like as long as you think of a
> way to load the normal system and not the recovery mode.
> 
> 
> 
> 

