Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:49669 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754935Ab3DPA2x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 20:28:53 -0400
Received: from mail-in-18-z2.arcor-online.net (mail-in-18-z2.arcor-online.net [151.189.8.35])
	by mx.arcor.de (Postfix) with ESMTP id 6C2E1A9E9B
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 02:28:52 +0200 (CEST)
Received: from mail-in-10.arcor-online.net (mail-in-10.arcor-online.net [151.189.21.50])
	by mail-in-18-z2.arcor-online.net (Postfix) with ESMTP id 68CCD33A8F8
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 02:28:52 +0200 (CEST)
Received: from [192.168.0.37] (p5B0A02A1.dip0.t-ipconnect.de [91.10.2.161])
	(Authenticated sender: ochi@arcor.de)
	by mail-in-10.arcor-online.net (Postfix) with ESMTPA id 4CBEA2D6095
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 02:28:52 +0200 (CEST)
Message-ID: <516C9B43.7040605@arcor.de>
Date: Tue, 16 Apr 2013 02:28:51 +0200
From: Ochi <ochi@arcor.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Activating space_cache after read-only snapshots without space_cache
 have been taken
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I've ran into problems with _very_ slow unmounting of my btrfs-formatted 
"backup" volume. I have a suspicion what might be the cause but maybe 
someone with more experience with the btrfs code could enlighten me 
whether it is actually correct.

The situation is the following: I have created a backup-volume to which 
I regularly rsync a backup of my system into a subvolume. After 
rsync'ing, I take a _read-only_ snapshot of that subvolume with a 
timestamp added to its name.

Now at the time I started using this backup volume, I was _not_ using 
the space_cache mount option and two read-only snapshots were taken 
during this time. Then I started using the space_cache option and 
continued doing snapshots.

A bit later, I started having very long lags when unmounting the backup 
volume (both during shutdown and when unmounting manually). I scrubbed 
and fsck'd the volume but this didn't show any errors. Defragmenting the 
root and subvolumes took a long time but didn't improve the situation much.

Now I started having the suspicion that maybe the space cache possibly 
couldn't be written to disk for the readonly subvolumes/snapshots that 
were created during the time when I wasn't using the space_cache option, 
forcing the cache to be rebuilt every time.

Clearing the cache didn't help. But when I deleted the two snapshots 
that I think were taken during the time without the mount option, the 
unmounting time seems to have improved considerably.

I will have to observe whether unmounting stays quick now but my 
question is whether it is possible that the read-only snapshots taken 
during the time when I wasn't using space_cache might actually have been 
the culprits.

Best,
Sebastian
