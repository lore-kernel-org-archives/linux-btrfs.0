Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:34029 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664AbcGHSv7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jul 2016 14:51:59 -0400
Received: by mail-lf0-f54.google.com with SMTP id h129so33242846lfh.1
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Jul 2016 11:51:58 -0700 (PDT)
Subject: Re: rollback to a snapshot and delete old top volume - missing of "@"
To: Kai Herlemann <nesadaw@freenet.de>, linux-btrfs@vger.kernel.org
References: <96f8022e-4209-2498-62e4-50ccbee46e37@freenet.de>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <577FF64B.2070203@gmail.com>
Date: Fri, 8 Jul 2016 21:51:55 +0300
MIME-Version: 1.0
In-Reply-To: <96f8022e-4209-2498-62e4-50ccbee46e37@freenet.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

07.07.2016 15:17, Kai Herlemann пишет:
> Hi,
> 
> I want to rollback a snapshot and have done this by execute "btrfs sub
> set-default / 618".
> Now I want to delete the old top volume to save space, but google and
> manuals didn't helped.
> 
> I mounted for the following the root volume at /mnt/gparted with
> subvolid=0, subvol=/ has the same effect.
> Usually, the top volume is saved in /@, so I would be able to delete it
> by execute "btrfs sub delete /@" (or move at first @ to @_badroot and
> the snapshot to @). But that isn't possible, the output of that command
> is "ERROR: cannot access subvolume /@: No such file or directory".
> I've posted the output of "btrfs sub list /mnt/gparted" at
> http://pastebin.com/r7WNbJq8. As you can see, there's no subvolume named @.
> 
> I have the same problem with my /home/ partition.
> 
> Output of "uname -a" (self-compiled kernel):
> Linux debian-linux 4.1.26 #1 SMP Wed Jun 8 18:40:04 CEST 2016 x86_64
> GNU/Linux
> 

You need to ask on your distribution list; this is really not a question
of btrfs but rather how distribution manages snapshots.

But if you originally installed in top level subvolume, then you have no
way to delete it. You may try to manually clean content of top level
subvolume if you need to free space.

That was initial implementation done by (open)SUSE and they changed it
later to install in subvolume from the very start. But information you
provided is not enough to know how system was installed originally.
