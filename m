Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:53982 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab2LHLlw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Dec 2012 06:41:52 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Question about btrfs snapshot delay and rm -rf delay
Date: Sat, 8 Dec 2012 12:41:47 +0100
Cc: Sylvain Alain <d2racing911@gmail.com>
References: <CACR_K2ss6LSQYeeEVcxmSvpEL-fHifO0trdaBmgURCQpgJi5kQ@mail.gmail.com> (sfid-20121207_145558_819721_AA48952F)
In-Reply-To: <CACR_K2ss6LSQYeeEVcxmSvpEL-fHifO0trdaBmgURCQpgJi5kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201212081241.48191.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 7. Dezember 2012 schrieb Sylvain Alain:
> Hi, I tested the fstrim
> 
> root@sysresccd /root % time fstrim -v /mnt/gentoo
> /mnt/gentoo: 8148938752 bytes were trimmed
> 
> I noticed that my btrfs hang my SSD only with small files.
> 
> I tested with removing the /usr/src/linux directory(kernel sources)
> with emerge -C vanilla-sources from Gentoo and I noticed this
> behaviour.
> 
> So, should I remove the discard option or not from my /etc/fstab ?

Did you test whether removing it fixes the delays?

If not, I think there is no need to remove it.

If yes, remove it and use fstrim instead.

Thats my suggestion.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
