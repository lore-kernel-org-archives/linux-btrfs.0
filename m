Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:52641 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbcCESAd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Mar 2016 13:00:33 -0500
Subject: Re: balance hangs and starts again on reboot
To: Marc Haber <mh+linux-btrfs@zugschlus.de>, linux-btrfs@vger.kernel.org
References: <20160304173125.GA1902@torres.zugschlus.de>
 <56D9CF63.3060603@googlemail.com> <20160305141707.GC1902@torres.zugschlus.de>
 <56DAFD91.2090805@googlemail.com> <20160305172553.GF1902@torres.zugschlus.de>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <56DB1EBD.2070904@googlemail.com>
Date: Sat, 5 Mar 2016 19:00:29 +0100
MIME-Version: 1.0
In-Reply-To: <20160305172553.GF1902@torres.zugschlus.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/05/16 18:25, Marc Haber wrote:
> On Sat, Mar 05, 2016 at 04:38:57PM +0100, Holger Hoffstätte wrote:
>> On 03/05/16 15:17, Marc Haber wrote:
>>>> Then try to balance in small increments.
>>>
>>> -dusage=5 and incrementing? Or what do you mean with "in small
>>> increments"?
>>
>> Exactly, yes. Sorry for not being more clear.
> 
> So you would recommend something along
> 
> for nr in $(seq 5 5 100); do
>   btrfs balance start -dusage=$nr $FS
> done
> 
> right?

Except for the 100 part, which seems pointless. Maybe more like
10,20..80 max. If that doesn't help you are probably out of space
anyway.

> Won't this take ages longer than a straight unfiltered balance?

Touching less stuff conditionally is pretty much guaranteed to be
faster than unconditionally rewriting everything, and less likely to
end up out of space since you garbage-collect the smallest chunks
first, freeing up a larger one and so on.

> md as in the Linux Software RAID? That's not in the game here, it's a
> single SATA hard disk.

I thought your df output contained md or something. If not, all the
better.

-h

