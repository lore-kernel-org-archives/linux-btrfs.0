Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:34820 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753803AbaACXWq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 18:22:46 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:62135 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1VzE4k-002Ebd-7Q
	for linux-btrfs@vger.kernel.org; Fri, 03 Jan 2014 16:22:46 -0700
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52C74415.3020407@jrs-s.net>
Date: Fri, 3 Jan 2014 16:22:44 -0700
Message-Id: <7B4E55D1-BA9B-4560-8442-429EDD01C92A@colorremedies.com>
References: <52C73987.7000106@jrs-s.net> <52C73D1A.8060805@gmail.com> <52C7402A.7050605@jrs-s.net> <52C741F5.7030106@gmail.com> <52C74415.3020407@jrs-s.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 3, 2014, at 4:13 PM, Jim Salter <jim@jrs-s.net> wrote:

> Sorry - where do I put this in GRUB? /boot/grub/grub.cfg is still kinda black magic to me, and I don't think I'm supposed to be editing it directly at all anymore anyway, if I remember correctly…

Don't edit the grub.cfg directly. At the grub menu, only highlight the entry you want to boot, then hit 'e', and then edit the existing linux/linuxefi line. If you already have rootfs on a subvolume, you'll have an existing parameter on that line rootflags=subvol=<rootname> and you can change this to rootflags=subvol=<rootname>,degraded

I would not make this option persistent by putting it permanently in the grub.cfg; although I don't know the consequence of always mounting with degraded even if not necessary it could have some negative effects (?)


Chris Murphy