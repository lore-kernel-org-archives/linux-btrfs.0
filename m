Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:56891 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbaCWPMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Mar 2014 11:12:10 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Rebalance makes BTRFS 10x slower
Date: Sun, 23 Mar 2014 16:12:07 +0100
Message-ID: <7616233.4PhybLsPIr@merkaba>
In-Reply-To: <4392627.HWimVooIO4@tethys>
References: <4392627.HWimVooIO4@tethys>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 23. März 2014, 15:51:34 schrieben Sie:
> I was expecting either a speed improvement after rebalance, or no
> noticeable  effect, but I am extremely disappointed to see that now (and
> after having rebooted), my system has become slow like hell, takes at least
> 10x longer to boot and operate, to the point it has become hardly usable
> 
> I would have thought a rebalance would have improved the filesystem 
> organization, looks like it's the absolute contrary

I also found this to be the case as I rebalanced the root filesystem of my 
Debian installation on this ThinkPad T520 on an Intel SSD 320.

It doubled the boot time that systemd-analayze rebootet back then.

apt-get dist-upgrade was noticably slower to.

Thus I avoid balance unless I really need it.

For migrating of /home to BTRFS RAID 1 on Intel SSD 320 + Crucial mSATA M500 
SSD I did a balance to switch to RAID 1. Probably /home would be faster 
recreating it from scratch and restoring from backup tough.

Especially MySQL based Akonadi seems to be slower than with /home on a single 
SSD, but that might also be due to that amount of mails in Linux kernel-ml 
folder raising to a high amount (and inefficiencies in Akonadi).

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
