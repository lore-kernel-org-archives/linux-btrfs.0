Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:37278 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab2FYSsx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 14:48:53 -0400
Received: from merkaba.localnet (ppp-88-217-126-64.dynamic.mnet-online.de [88.217.126.64])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 9092B195
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Jun 2012 20:48:52 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: 3.5-rc4: BTRFS unmountable after hard lockup
Date: Mon, 25 Jun 2012 20:48:51 +0200
References: <201206252029.34545.Martin@lichtvoll.de> (sfid-20120625_204005_007114_552D1AD6)
In-Reply-To: <201206252029.34545.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201206252048.52022.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 25. Juni 2012 schrieb Martin Steigerwald:
> Hi!
> 
> I got a X server / drm related crash or hard lockup. After I rebooted I
> tried to mount the BTRFS on my esata disk. It has big metadata
> (mkfs.btrfs -l 32768 -n 32768).
> 
> 
> I got:
> 
[… backtrace …]

> BTRFS was not mounted. After trying to mount again, I got:
> 
> merkaba:~> ps aux | grep " D" | grep -v grep
> root      3446  0.0  0.0      0     0 ?        D    20:22   0:00
> [btrfs-transacti] root      4666  0.0  0.0  18640  1184 tty1     D+  
> 20:24   0:00 mount /mnt/amazon-daten
> 
> Any hints how to get my disk mounted?
> 
> I have a fairly recent backup, but I would prefer when I do not have to
> replay it. Its one of my expectations for a file system: be safe on
> sudden write interruptions like power loss or crash.

Well, I wanted to have back my disk ASAP. So I just tried that btrfs-zero-
log mantra again.

It worked. Hopefully the backtrace still gives you a clue on what has 
happened. I thought these kind of errors where gone now.

(Yeah, I know its still experimental… no indoctrination requested;-)

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
