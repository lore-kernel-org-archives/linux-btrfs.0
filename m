Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41064 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752542AbeGAXEA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Jul 2018 19:04:00 -0400
Date: Sun, 1 Jul 2018 16:03:53 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <20180701230353.sc3ftm6p4hocdaxa@merlins.org>
References: <20180701162722.mnm5wjgxc7weymiz@merlins.org>
 <CAJCQCtRwJONrdEmS0e7Wp9SVdEsxC7qhsw_4QffX6rdvLV0Btw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtRwJONrdEmS0e7Wp9SVdEsxC7qhsw_4QffX6rdvLV0Btw@mail.gmail.com>
Subject: Re: btrfs check of a raid0?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 01, 2018 at 01:15:09PM -0600, Chris Murphy wrote:
> > How is it supposed to work when you have multiple devices for a btrfs
> > filesystem?
> >
> > gargamel:~# btrfs check --repair -p /dev/bcache2
> > enabling repair mode
> > ERROR: mount check: cannot open /dev/bcache2: No such device or address
> > ERROR: could not check mount status: No such device or address
> > gargamel:~# btrfs check --repair -p /dev/bcache3
> > enabling repair mode
> > ERROR: cannot open device '/dev/bcache3': Device or resource busy
> > ERROR: cannot open file system
> >
> > [205248.299528] BTRFS info (device bcache3): disk space caching is enabled
> > [205248.320335] BTRFS error (device bcache3): Remounting read-write after error is not allowed
> 
> If it's successfully unmounted, I don't understand the error messages
> that it can't be opened. Is umount hung? Sounds to me like btrfs check
> thinks it's still mounted.

I spent more time on this and apparently because the underlying device
had a hardware fault (fell off the bus), its dmcrpyt device is still
there but not working.
In turn, I can't dmsetup rm it because it's in use by bcache which
didn't free it, but bcache won't let me free it because it got removed.
So, I'm stuck with a reboot in the end, oh well...

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
