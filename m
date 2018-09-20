Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:52596 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbeITOQj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 10:16:39 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1g2uNb-00082D-Kb
        for linux-btrfs@vger.kernel.org; Thu, 20 Sep 2018 10:32:07 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [RFC PATCH v2 0/4] btrfs-progs: build distinct binaries for
 specific btrfs subcommands
Date: Thu, 20 Sep 2018 08:32:01 +0000 (UTC)
Message-ID: <pan$1f31c$d7f59d13$3b6f50b9$200a6f62@cox.net>
References: <20180912144604.6178-1-axel@tty0.ch>
        <3ceee37e-66f5-e2f8-dbc9-fde2452a6447@tty0.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Axel Burri posted on Thu, 20 Sep 2018 00:02:22 +0200 as excerpted:

> Now not everybody wants to install these with fscaps or setuid, but it
> might also make sense to provide "/usr/bin/btrfs-subvolume-{show,list}",
> as they now work for a regular user. Having both root/user binaries
> concurrently is not an issue (e.g. in gentoo the full-featured btrfs
> command is in "/sbin/").

That's going to be a problem for distros (or users like me with advanced 
layouts, on gentoo too FWIW) that have the bin/sbin merge, where one is a 
symlink to the other.

FWIW I have both the /usr merge (tho reversed for me, so /usr -> . 
instead of having to have /bin and /sbin symlinks to /usr/bin) and the 
bin/sbin merge, along with, since I'm on amd64-nomultilib, the lib/lib64 
merge.  So:

$$ dir -gGd /bin /sbin /usr /lib /lib64
drwxr-xr-x 1 35688 Sep 18 22:56 /bin
lrwxrwxrwx 1     5 Aug  7 00:29 /lib -> lib64
drwxr-xr-x 1 78560 Sep 18 22:56 /lib64
lrwxrwxrwx 1     3 Mar 11  2018 /sbin -> bin
lrwxrwxrwx 1     1 Mar 11  2018 /usr -> .


Of course that last one (/usr -> .) leads to /share and /include hanging 
directly off of / as well, but it works.

But in that scheme /bin, /sbin, /usr/bin and /usr/sbin, are all the same 
dir, so only one executable of a particularly name can exist therein.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
