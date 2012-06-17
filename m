Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:38975 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab2FQIwy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jun 2012 04:52:54 -0400
Received: from merkaba.localnet (ppp-93-104-149-2.dynamic.mnet-online.de [93.104.149.2])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 44F7CA9
	for <linux-btrfs@vger.kernel.org>; Sun, 17 Jun 2012 10:52:53 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: kernel got struck while scrubbing BTRFS with node- and leafsize 32768
Date: Sun, 17 Jun 2012 10:52:52 +0200
References: <201206162223.20392.Martin@lichtvoll.de> (sfid-20120616_222349_638324_6A19C7C9)
In-Reply-To: <201206162223.20392.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201206171052.52542.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 16. Juni 2012 schrieb Martin Steigerwald:
> [246028.219701] btrfs csum failed ino 151001 off 9441280 csum
> 3484644058 private 2813574800 
> [246028.368763] btrfs csum failed ino
> 151001 off 9441280 csum 3484644058 private 2813574800
[…]
> I have no idea where these checksum errors might come from. 2 TB disk
> steigerwald reports good SMART status, no recent errors and is quite
> new.

I think I now have an idea where they might come from:

Bug 43511 - Partitions: Amiga RDB partition on 2 TB disk way too big, 
while OK in AmigaOS 4.1
https://bugzilla.kernel.org/show_bug.cgi?id=43511

Bug 43521 - Amiga RDB partitions: truncates miscalculated partition size 
instead of refusing to use it
https://bugzilla.kernel.org/show_bug.cgi?id=43521


This in unrelated to BTRFS.

BTRFS checksumming has made me aware of a serious issues with my Amiga RDB 
formatted backup harddisk.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
