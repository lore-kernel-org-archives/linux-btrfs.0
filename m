Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43708 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab2GLFNy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jul 2012 01:13:54 -0400
Received: by wibhq12 with SMTP id hq12so5200810wib.1
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Jul 2012 22:13:52 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 12 Jul 2012 00:13:52 -0500
Message-ID: <CAHZ_AjtMe2s+-LpmLNf1rtn7QBtsWk+ANhX9AUDsbCEMDsorOg@mail.gmail.com>
Subject: file system corruption removal / documentation quandry
From: eric gisse <jowr.pi@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While spinning up a nice new laptop, I needed to stage my Gentoo
install through Ubuntu so I could use EFI. The problem with this is
that my newly created and mounted btrfs was crashed multiple times
because Ubuntu wanted to be awful and unstable.

This isn't a complaint about Ubuntu, it knows what it did wrong. The
issue I had was how to remove the corruption that resulted.

Every attempt to remove the files via rm or whatever resulted in a
kernel oops. My natural throught was 'btrfsck' because I knew that had
been recently added. However the --help/-h showed nothing and the
corruption persisted.

After doing massive amounts of googling, I found the following article:

http://www.phoronix.com/scan.php?page=news_item&px=MTA2MDI

Basically, phoronix showed there is a --repair option. After enabling
snapshotting and playing around with the various discussed options, I
discovered that --repair and no special mount options was sufficient
to get the files removable.

Now what I'm hoping for is better documentation on btrfsck even if it
just boils down to a brief enumeration of the options as that would be
better than nothing which is what we have now. Do I need to file a bug
or is this sufficient? I'd like to see this project improve because
I'm very impressed with its' features and how it has reacted to the
abuse thrown at it thus far.
