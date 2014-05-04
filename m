Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:40808 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbaEDX2x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 May 2014 19:28:53 -0400
Received: from [172.56.12.67] (port=24507 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1Wh5pz-0002wA-OC by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Sun, 04 May 2014 16:28:52 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1Wh5nx-0000vl-9e
	for linux-btrfs@vger.kernel.org; Sun, 04 May 2014 16:26:45 -0700
Date: Sun, 4 May 2014 16:26:45 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: How does Suse do live filesystem revert with btrfs?
Message-ID: <20140504232645.GQ9061@merlins.org>
References: <20140504005257.GF9061@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140504005257.GF9061@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Actually, never mind Suse, does someone know whether you can revert to
an older snapshot in place?
The only way I can think of is to mount the snapshot on top of the other
filesystem. This gets around the umounting a filesystem with open
filehandles problem, but this also means that you have to keep track of
daemons that are still accessing filehandles on the overlayed
filesystem.

My one concern with this approach is that you can't free up the
subvolume/snapshot of the underlying filesystem if it's mounted and even
after you free up filehandles pointing to it, I don't think you can
umount it.

In other words, you can play this trick to delay a reboot a bit, but
ultimately you'll have to reboot to free up the mountpoints, old
subvolumes, and be able to delete them.

Somehow I'm thinking Suse came up with a better method.

Even if you don't know Suse, can you think of a better way to do this?

Thanks,
Marc

On Sat, May 03, 2014 at 05:52:57PM -0700, Marc MERLIN wrote:
> (more questions I'm asking myself while writing my talk slides)
> 
> I know Suse uses btrfs to roll back filesystem changes.
> 
> So I understand how you can take a snapshot before making a change, but
> not how you revert to that snapshot without rebooting or using rsync,
> 
> How do you do a pivot-root like mountpoint swap to an older snapshot,
> especially if you have filehandles opened on the current snapshot?
> 
> Is that what Suse manages, or are they doing something simpler?
> 
> Thanks,
> Marc

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
