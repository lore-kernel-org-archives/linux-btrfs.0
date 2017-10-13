Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:53514 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751564AbdJMLCZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 07:02:25 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1e2xjK-0001qN-Kf
        for linux-btrfs@vger.kernel.org; Fri, 13 Oct 2017 13:02:14 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs warnings in kernel 4.13.5
Date: Fri, 13 Oct 2017 11:02:07 +0000 (UTC)
Message-ID: <pan$2aa3b$47885ead$d44bbe7e$37d6c337@cox.net>
References: <CAC+fKQXPGpwuhVz7oNLzPLd0ydo+kiqG1vpcWvx+-DZ+2jL6Bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Juan Orti Alcaine posted on Fri, 13 Oct 2017 10:40:20 +0200 as excerpted:

> Hi,
> 
> I've upgraded my system to Fedora 27 and now I see many btrfs warnings,
> although the system seems to be working fine. Is this something I should
> worry about?

> # uname -a Linux xenon 4.13.5-300.fc27.x86_64 #1 SMP Thu Oct 5 16:57:11
> UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
> 
> # btrfs --version btrfs-progs v4.13.2

> [  337.813416] ------------[ cut here ]------------
> [  337.813453] WARNING: CPU: 5 PID: 459 at fs/btrfs/ctree.h:1559
> btrfs_update_device+0x1be/0x1d0 [btrfs]

> [  337.814256] ------------[ cut here ]------------
> [  337.814281] WARNING: CPU: 5 PID: 459 at fs/btrfs/ctree.h:1559
> btrfs_update_device+0x1be/0x1d0 [btrfs]

> [  337.822161] ------------[ cut here ]------------
> [  337.822185] WARNING: CPU: 5 PID: 459 at fs/btrfs/ctree.h:1559
> btrfs_update_device+0x1be/0x1d0 [btrfs]

> [  337.822868] ------------[ cut here ]------------
> [  337.822890] WARNING: CPU: 5 PID: 459 at fs/btrfs/ctree.h:1559
> btrfs_update_device+0x1be/0x1d0 [btrfs]


Those warnings aren't anything to be /too/ worried about.  They are 
triggered when a btrfs device size isn't a multiple of the btrfs 
sectorsize (currently 4 KiB on amd64 aka x86_64).  You can manually 
shrink your btrfs devices the fraction to an exact 4 KiB multiple, or 
wait a bit, and a new release of btrfs-tools should have a command to do 
it for you. 

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

