Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:49363 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab3FXKZJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Jun 2013 06:25:09 -0400
Received: by mail-la0-f53.google.com with SMTP id fs12so10104591lab.12
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jun 2013 03:25:07 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 24 Jun 2013 12:25:07 +0200
Message-ID: <CAOEw3RbTrQkogo44sxdo62+Y8yJd_Bp_QTPQWW7-FVcv4TrJ6w@mail.gmail.com>
Subject: Btrfs lockup during defrag and removing device
From: =?ISO-8859-2?Q?Ond=F8ej_Kunc?= <kunc88@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi developers,

I have been playing with btrfs on our test server. I have streessed it
much ... and I can say ... it's troughput and features are very nice
and usable, but I experienced one problem during testing, btrfs
triggered lockup of 3 of 8 CPU cores of testing server.

What I was doing ?

Simultaneously:
- copying 130GB file on one subvolume to another file and measuring speed by pv
- removing one device (/dev/md3) from btrfs
- running btrfs defrag on whole  fs (via xargs)
- rsyncing files from another server to subvolume
- untaring the first 130GB tar to one subdirectory

Our server is HP-DL380, 12*146GB SAS HDD, 72GB RAM, Intel Xeon 5620
Running uptodate debian wheezy with kernel and btrfs-tools from testing
3.9-1-amd64 #1 SMP Debian 3.9.6-1 x86_64 GNU/Linux
# btrfs version
Btrfs Btrfs v0.19

btrfs was created on top on 3 software RAID6 devices, every one built
from 4 SAS drive

About one hour after this(see dmesg) server became inaccessible, so I
had to restart it by power cycle.

After reboot there was problem with free space cache, but it was fixed
automatically. I have one suspection, I have tried next this:

btrfs balance start /btrfs
and then btrfs resize 4:max /btrfs (device was previosly smaller)

it failed with dmesg output: btrfs: dev
add/delete/balance/replace/resize operation in progress.

So it is possible, that it is mutualy exclusive and should not be
permitted in the other way, to start balance or defrag when device is
being removed, is this true ?

Thank you all for your good work!

Ondrej Kunc

dmesg output: http://pastebin.com/Ndxypkxa

P.S. in case of duplicate message I'm sorry, but I was not able to
post from our company email.

--
Ondøej Kunc
