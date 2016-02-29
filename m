Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:50502 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbcB2Pdy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Feb 2016 10:33:54 -0500
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1aaPpY-000184-JL
	for linux-btrfs@vger.kernel.org; Mon, 29 Feb 2016 16:33:52 +0100
Date: Mon, 29 Feb 2016 16:33:52 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
Message-ID: <20160229153352.GE2334@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <56D3A56A.20809@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <56D3A56A.20809@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Mon, Feb 29, 2016 at 09:56:58AM +0800, Qu Wenruo wrote:
> Marc Haber wrote on 2016/02/27 22:14 +0100:
> >I have again the issue of no space left on device while rebalancing
> >(with btrfs-tools 4.4.1 on kernel 4.4.2 on Debian unstable):
> >
> >mh@fan:~$ sudo btrfs balance start /mnt/fanbtr
> >ERROR: error during balancing '/mnt/fanbtr': No space left on device
> 
> It seems that, only when balancing all chunks, ENOSPC error happens.
> 
> And did you run any other heavy IO at background?

Not when running those last commands for the mailing list post.

> BTW, is there any kernel log when the ENOSPC happens?

> Would you please try the following commands to see which one caused the
> problem?
> And would you please provide the dmesg of them?
> 
> # btrfs balance start -dprofiles=single /mnt/fanbtr
> # btrfs balance start -mprofile=dup /mnt/fanbtr
> # btrfs balance start -sprofile=dup /mnt/fanbtr

I have attached the logs. I used logger(1) to have in syslog which
command I executed, and I have piped the userspace's output to logger
so that the syslog entries match the userspace output.

-mprofile gave an error message, I therefore tried -mprofiles, and
-sprofiles wanted me to use the --force, so I did that as well.

The three balance commands above all three finshed alright without
running into ENOSPC, while running a plain balance (which is also part
of the log) errors out every time.

And, the -dprofiles=single log caused a number of INFOs regarding
btrfs-cleaner and btrfa-balance processes gotten stuck for more than
120 seconds during the run.

I now have a kworker and a btfs-transact kernel process taking most of
one CPU core each, even after the userspace programs have terminated.
Is there a way to find out what these threads are actually doing?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
