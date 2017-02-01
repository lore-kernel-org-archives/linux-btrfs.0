Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:55959 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750974AbdBAFX2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Feb 2017 00:23:28 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cYnO5-0003GJ-Hm
        for linux-btrfs@vger.kernel.org; Wed, 01 Feb 2017 06:23:21 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: raid1: cannot add disk to replace faulty because can only mount
 fs as read-only.
Date: Wed, 1 Feb 2017 05:23:16 +0000 (UTC)
Message-ID: <pan$be2e$8a233bb0$f63eb0cb$d3413db@cox.net>
References: <54678ac94c95687e00485d41fa5b5bc9@server1.deragon.biz>
        <W75Sc6PDCBok7W75TcCgc7@videotron.ca>
        <51114ea93a0f76a5ff6621e4d8983944@server1.deragon.biz>
        <fab34ac1-03c0-76ea-eac2-ef4a210a48de@gmail.com>
        <07bba687-64c3-6713-6f6a-c8da183cbd3d@gmail.com>
        <YAvBcoM9EImXYYAvCcegSf@videotron.ca>
        <a5262907-06f2-2c6f-d23a-2703b10429b7@deragon.biz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hans Deragon posted on Tue, 31 Jan 2017 21:51:22 -0500 as excerpted:

> But the current scenario makes it difficult for me to put redundancy
> back into service!  How much time did I waited until I find the mailing
> list, subscribe to it, post my email and get an answer?  Wouldn't it be
> better if the user could actually add the disk at anytime, mostly ASAP?
> 
> And to fix this, I have to learn how to patch and compile the kernel.  I
> have not done this since the beginning of the century.  More delays,
> more risk added to the system (what if I compile the kernel with the
> wrong parameters?).

Comes with the territory.  Note that nobody with any knowledge of btrfs 
is claiming it's fully stable and mature, as you seem to expect.  Rather, 
the state is explicitly stabilizing, NOT fully stable and mature, backups 
very strongly recommended as there's a real possibility you'll need to 
use them, running current kernels and keeping up with the list if you 
choose to run btrfs strongly recommended, etc.

The patch fixing the problem and making return from degraded not the one-
shot thing it tends to be now will eventually be merged, but known 
problems, with or without patches available to fix them, are just part of 
running a still stabilizing filesystem, and if you choose to do so and 
run into those problems, you have the choice of waiting for a fix to make 
its way to you, or if a patch is already available, rebuilding with that 
patch.

Otherwise, you simply mkfs and restore from the backup that was strongly 
recommended if the data isn't of only trivial value in the first place.  
If you didn't have that backup, and the data was stored on a still 
stabilizing btrfs, well then, you defined it as of only trivial value by 
the inaction of not having that backup while running a filesystem known 
to be still stabilizing, didn't you?

Otherwise, run a filesystem more appropriately stable and mature 
according to your needs, as btrfs in its current state apparently doesn't 
meet those needs.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

