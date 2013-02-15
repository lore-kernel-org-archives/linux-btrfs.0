Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moltke.seatribe.se ([178.63.100.209]:42770 "EHLO
	moltke.seatribe.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1160996Ab3BODuc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 22:50:32 -0500
Date: Fri, 15 Feb 2013 04:50:23 +0100 (CET)
From: Fredrik Tolf <fredrik@dolda2000.com>
To: Chris Murphy <lists@colorremedies.com>
cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Rebalancing RAID1
In-Reply-To: <19ABBC76-F774-4225-87A4-73A4D546F53F@colorremedies.com>
Message-ID: <alpine.DEB.2.02.1302150447540.8810@shack.dolda2000.com>
References: <alpine.DEB.2.02.1302122348460.8810@shack.dolda2000.com> <C8ECD52F-F362-49CD-A3E3-627AF13CF180@colorremedies.com> <alpine.DEB.2.02.1302130711400.8810@shack.dolda2000.com> <5EEA9264-5DCA-4A3F-B305-F3E64E9A3CC5@colorremedies.com>
 <alpine.DEB.2.02.1302140733070.8810@shack.dolda2000.com> <17E4F30E-2945-44FE-A87F-0F475DFD794F@colorremedies.com> <alpine.DEB.2.02.1302140830310.8810@shack.dolda2000.com> <2D5AAB44-9DA8-460D-9141-3544DE6C45D7@colorremedies.com> <20130214085925.GD28997@carfax.org.uk>
 <19ABBC76-F774-4225-87A4-73A4D546F53F@colorremedies.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 14 Feb 2013, Chris Murphy wrote:
> Yeah he's getting a lot of these, and I don't know what it is:
>
>> Feb 14 08:32:30 nerv kernel: [180511.760850] lost page write due to I/O error on /dev/sdd1
>
> It's not tied to btrfs or libata so I don't think it's the drive itself 
> reporting the write error.

Actually, it appears it might just be from btrfs:

> $ grep -rlI 'lost page write' /usr/local/src/linux-3.7.1/fs
> /usr/local/src/linux-3.7.1/fs/btrfs/disk-io.c
> /usr/local/src/linux-3.7.1/fs/buffer.c

And at btrfs/disk-io.c:2711 in this 3.7.1 source:

> printk_ratelimited_in_rcu(KERN_WARNING "lost page write due to "
> 			  "I/O error on %s\n",
> 			  rcu_str_deref(device->name));

So it's either from btrfs, or from the buffer cache, and seeing as how it 
appears with other btrfs messages, I'd be willing to bet on the former. :)

--

Fredrik Tolf
