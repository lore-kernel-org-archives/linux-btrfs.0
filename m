Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33420 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385Ab3HDMp0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 4 Aug 2013 08:45:26 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V5xgZ-0002iZ-Qp
	for linux-btrfs@vger.kernel.org; Sun, 04 Aug 2013 14:45:23 +0200
Received: from dyndsl-085-016-048-159.ewe-ip-backbone.de ([85.16.48.159])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Aug 2013 14:45:23 +0200
Received: from hurikhan77+btrfs by dyndsl-085-016-048-159.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Aug 2013 14:45:23 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Recovery advice
Date: Sun, 04 Aug 2013 14:41:54 +0200
Message-ID: <kpu1da-elm.ln1@hurikhan.ath.cx>
References: <CAPs0BijizOo0c566U6-uAe1voCr-W2SVHkMeT1sirTfi4jgeSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sandy McArthur <sandymac@gmail.com> schrieb:

> I have a 4 disk RAID1 setup that fails to {mount,btrfsck} when disk 4
> is connected.
> 
> With disk 4 attached btrfsck errors with:
> btrfsck: root-tree.c:46: btrfs_find_last_root: Assertion
> `!(path->slots[0] == 0)' failed
> (I'd have to reboot in a non-functioning state to get the full output.)
> 
> I can mount the filesystem in a degraded state with the 4th drive
> removed. I believe there is some data corruption as I see lines in
> /var/log/messages from the degraded,ro filesystem like this:
> 
> BTRFS info (device sdd1): csum failed ino 4433 off 3254538240 csum
> 1033749897 private 2248083221
> 
> I'm at the point where all I can think to do is wipe disk 4 and then
> add it back in. Is there anything else I should try first. I have
> booted btrfs-next with the latest btrfs-progs.

It is a RAID-1 so why bother with the faulty drive? Just wipe it, put it 
back in, then run a btrfs balance... There should be no data loss because 
all data is stored twice (two-way mirroring).

Regards,
Kai

