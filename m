From: Michael Stephenson <mickstephenson@googlemail.com>
Subject: Filesystem corrupted, is there any hope?
Date: Fri, 24 Jun 2011 11:16:14 +0100
Message-ID: <BANLkTikLCk9=_CgXUWUTf91x7Aiyhuvndg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
I formatted my home partition with btrfs, not realising that the fsck
tool can't actually fix errors, as I have just discovered on your
wiki.
Had I knew this I would have not used it so early, this detail you
would think would make distributions wary to make it an option on the
livecd with no warning that if you ever have a power cut you are most
certainly going to lose your data even if your hardware is fine.
Anyway is their any hope? Is there beta code for an fsck that can do
repairs? How long do I have to wait before there is? I can always just
wait for a few months to get the data back.

Thanks
Michael.
