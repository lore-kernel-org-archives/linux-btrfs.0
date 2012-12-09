Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:34654 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab2LILUf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Dec 2012 06:20:35 -0500
Received: from merkaba.localnet (ppp-93-104-144-117.dynamic.mnet-online.de [93.104.144.117])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 8F16E10A
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Dec 2012 12:19:16 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: How to refresh degraded BTRFS? free space fragmentation, file fragmentation...
Date: Sun, 9 Dec 2012 12:20:33 +0100
References: <201212091212.26248.Martin@lichtvoll.de> (sfid-20121209_121802_607942_89B77E9F)
In-Reply-To: <201212091212.26248.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201212091220.33609.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 9. Dezember 2012 schrieb Martin Steigerwald:
> Hi!
> 
> I have BTRFS on some systems since more than two years. My experience so
> far is: Performance at the beginning is pretty good, but some of my more 
> often used BTRFS filesystem degrade badly in different areas. On some
> workloads pretty quickly.
> 
> There are also some fs however that did not degrade that badly. These were
> some that have way more free space left than the ones that degraded
> badly. About 900 GB freespace left on my eSATA backup disk with BTRFS
> that is also quite new. About 80 GB left on my BTRFS RAID 1 local home disk
> where I can build debian packages or kernels and such without the restrictions
> NFS brings (root squash). These still appear to be fine, but I redid the local
> home one with mkfs.btrfs -n 32768 and -l 32768 not to long ago, but I
> think it was quite fine before anyway, so I might have overdone it here.
> This already points at a way to prevent some degradation BTRFS filesystems:
> Leave more free space.

I also do not use them regularily as in each day.

Backup disk just every two weeks or so.

Local home sometimes each day a week, then not at all for weeks.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
