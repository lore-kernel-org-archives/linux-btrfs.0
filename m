From: cwillu <cwillu@cwillu.com>
Subject: Mysteriously changing RAID levels
Date: Wed, 16 Jun 2010 08:12:03 -0600
Message-ID: <AANLkTinwCgndAxTGOAnzybhpAXG8DnemHj25WFR4489N@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I just noticed today that "btrfs fi df /" no longer reports any raid
level on Metadata or Data.  I know as of Jun 4 that Data was RAID1 and
Metadata was DUP (I had posted my df output to irc).  I've already
checked that I didn't revert to an old version of btrfs-progs, and am
at a bit of a loss to explain it.

I'm currently running 2.6.35rc1.

Any ideas what could have caused this?
