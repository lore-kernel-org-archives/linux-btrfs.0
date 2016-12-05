Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:50568 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751120AbcLECwM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Dec 2016 21:52:12 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cDjNs-0005bf-NG
        for linux-btrfs@vger.kernel.org; Mon, 05 Dec 2016 03:52:04 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs fi du is unreliable
Date: Mon, 5 Dec 2016 02:51:45 +0000 (UTC)
Message-ID: <pan$9f9e6$dc770aea$b355d690$762e1ab2@cox.net>
References: <CAJCQCtQcz6W-UD5eDAiWG1QJk3tSF7boN2haG_Du=PD_U6rx1g@mail.gmail.com>
        <CAPmG0jbMMBvY4pFm4D0AYi=QqGsiskVq4aE=bX3JtK_fUkcvFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Henk Slager posted on Sun, 04 Dec 2016 23:17:23 +0100 as excerpted:

> There are no btrfs changes between kernels 4.8.10 and 4.8.11. There is
> no compress mount option in my case, that is the only thing I currently
> can think of that could make your Set shared number non-zero.

Compression... might actually explain what I'm seeing here, even if it 
doesn't explain Chris Murphy's issue.

I don't do subvolumes or snapshots here, and I've not, knowingly at 
least, setup any reflinked files, so I expected my btrfs fi du's to all 
show 0 bytes shared.

And / shows exactly that, 0 bytes shared, but /home (/h here) shows a 
shared count in the /summary/ while a grep -v ' -  /h' of the full output 
only outputs the summary line, no actual file listing as shared.

(As my admin user so I can sudo w/o password, $$ indicates a command 
line.  Again, /home is a symlink to /h here, /h is thus the actual 
mountpoint for /home, an entirely separate btrfs, not a subvolume.)

$$ sudo btrfs fi du -s /
     Total   Exclusive  Set shared  Filename
   2.94GiB     2.94GiB       0.00B  /

$$ sudo btrfs fi du -s /h
     Total   Exclusive  Set shared  Filename
  16.16GiB    16.16GiB    32.00KiB  /h

$$ sudo btrfs fi du /h | grep -v ' -  /h' 
     Total   Exclusive  Set shared  Filename
  16.16GiB    16.16GiB    32.00KiB  /h

But I do use compress=lzo on both filesystems.  If compression accounts 
for the shared, however, I wonder why / isn't showing any shared, since 
it's mounted with compress=lzo as well.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

