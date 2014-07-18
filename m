Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:43579 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaGREfc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jul 2014 00:35:32 -0400
In-Reply-To: <1405627978.2630.39.camel@s-Air>
References: <1405627978.2630.39.camel@s-Air>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: Questions on incremental backups
From: Russell Coker <russell@coker.com.au>
Date: Fri, 18 Jul 2014 14:35:20 +1000
To: Sam Bull <sam.hacking@sent.com>, linux-btrfs@vger.kernel.org
Message-ID: <e1b3b459-ea44-4272-9320-4cb5218b3966@email.android.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Daily snapshots work welk with kernel 3.14 and above (I had problems with 3.13 and previous). I have snapshots every 15 mins on some subvols.

Very large numbers of snapshots can cause performance problems. I suggest keeping below 1000 snapshots at this time.

You can use send/recv functionality for remote backups. So far I've used rsync, it works well and send/recv has some limitations about filesystem structure etc. Rsync can transfer to a ext4 or ZFS filesystem if you wish.

Ignoring directories in send/recv is done by subvol. Even if you use rsync it's a good idea to have different subvols for directory trees with different backup requirements.

Displaying backups is an issue of backup software. It is above the level that BTRFS development touches. While people here can probably offer generic advice on backup software it's not the topic of the list.

I use date based snapshots on my backup BTRFS filesystems and I can easily delete snapshots in the middle of the list.
-- 
Sent from my Samsung Galaxy Note 2 with K-9 Mail.
