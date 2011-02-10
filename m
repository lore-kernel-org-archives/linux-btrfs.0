From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: Re: mkfs.btrfs - error checking /dev/sda5 mount status
Date: Thu, 10 Feb 2011 06:54:32 +0000 (UTC)
Message-ID: <ij0238$u5g$1@dough.gmane.org>
References: <iiqphe$217$1@dough.gmane.org> <4D51A0D9.9000701@libero.it>
	<iiscep$udg$1@dough.gmane.org> <4D52DC1E.2050302@libero.it>
	<iiusfk$lp4$1@dough.gmane.org> <4D5356DD.8040501@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Samuel, Thu, 10 Feb 2011 14:09:17 +1100:

> On 10/02/11 07:12, Lubos Kolouch wrote:
> 
>> /dev/root / btrfs rw,noatime,compress,ssd 0 0
> 
> My memory of the strace showed that there was no /dev/root when it tried
> to open it - can you confirm whether or not that's the case please ?
> 
> cheers!
> Chris
> --
>  Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

Chris, 

You mean this?

# ls -la /dev/root 
ls: cannot access /dev/root: No such file or directory

Lubos

