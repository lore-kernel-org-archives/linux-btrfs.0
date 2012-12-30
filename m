Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:38101 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab2L3BXX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Dec 2012 20:23:23 -0500
From: Russell Coker <russell+btrfs@coker.com.au>
Reply-To: russell+btrfs@coker.com.au
To: Bart Noordervliet <bart@noordervliet.net>
Subject: Re: determining filesystem mount points
Date: Sun, 30 Dec 2012 12:23:16 +1100
Cc: "linux-btrfs@vger.kernel.org list" <linux-btrfs@vger.kernel.org>
References: <201212291604.52597.russell+btrfs@coker.com.au> <CAGy7Utj=HpO-EetPJQzAkiXKWg8XvWE2mB6s8kRGJ9nBR34OKw@mail.gmail.com>
In-Reply-To: <CAGy7Utj=HpO-EetPJQzAkiXKWg8XvWE2mB6s8kRGJ9nBR34OKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201212301223.16325.russell+btrfs@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 29 Dec 2012, Bart Noordervliet <bart@noordervliet.net> wrote:
> all of the information you need should be available from the 'mount'
> and 'btrfs subvol list' commands. Though I realise it can be awkward
> to parse it out of there, this will be the only way to get accurate
> information in the face of bind-mounts and other fancy tricks. One
> other datapoint that you might be able to use is that btrfs, I
> believe, always shows inode number 256 for subvolumes in 'stat'. Keep
> in mind there that the root subvolume is, as the name implies, also
> technically a subvolume.

What I want to do is to have shell scripts create snapshots and then 
automatically remove them.  As the output of "btrfs subvol list" is relative 
to the root of the filesystem even if we don't consider bind mounts and other 
complications it becomes difficult to generate a "btrfs subvol delete" command 
that is correct from a shell script.

Perhaps the best solution would be to have an option to "btrfs subvol list" to 
give output with fully qualified paths.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
