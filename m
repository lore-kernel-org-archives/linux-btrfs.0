Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:34516 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751009AbdAXRte (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 12:49:34 -0500
Received: by mail-pg0-f42.google.com with SMTP id 14so56644336pgg.1
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jan 2017 09:49:34 -0800 (PST)
Date: Tue, 24 Jan 2017 09:49:07 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, agruenba@redhat.com
Subject: Re: read-only fs, kernel 4.9.0, fs/btrfs/delayed-inode.c:1170
 __btrfs_run_delayed_items,
Message-ID: <20170124174907.GA27340@vader>
References: <CAJCQCtT73Zh2F13tg3v4UZC3+rdTMhgC==Ag3LZQ-RZMTpisOg@mail.gmail.com>
 <CAJCQCtSZyfHdmsaVdEM7iQiKfK-s4Qqs4ORZrE1MCpWCgeCWbw@mail.gmail.com>
 <CAJCQCtQz5fhYymEgFuxuiactZpWeUSEeCCXFCAEmLTTA6AOZLQ@mail.gmail.com>
 <20170123213109.GA11778@vader.DHCP.thefacebook.com>
 <CAJCQCtSVXRXvGmnmfFt5yn_L33a8eCCuuFANxTOyWLrJeqrK9g@mail.gmail.com>
 <CAJCQCtRip_D7BPhCJDVP53LRoQoEcVrvCf7eyGK9sa8qv23BNQ@mail.gmail.com>
 <20170123220448.GB11778@vader.DHCP.thefacebook.com>
 <CAJCQCtQNgvu72GUBpvJtnAH-Sj-fd566HwDpeuGjaPmdtrUO3g@mail.gmail.com>
 <20170124000524.GC11778@vader.DHCP.thefacebook.com>
 <CAJCQCtSHx8cEanC7e71akLiRKzi+Rt96CSAoK11Ngud9=n1U-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtSHx8cEanC7e71akLiRKzi+Rt96CSAoK11Ngud9=n1U-Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 23, 2017 at 08:51:24PM -0700, Chris Murphy wrote:
> On Mon, Jan 23, 2017 at 5:05 PM, Omar Sandoval <osandov@osandov.com> wrote:
> > Thanks! Hmm, okay, so it's coming from btrfs_update_delayed_inode()...
> > That's probably us failing btrfs_lookup_inode(), but just to make sure,
> > could you apply the updated diff at the same link as before
> > (https://gist.github.com/osandov/9f223bda27f3e1cd1ab9c1bd634c51a4)? If
> > that's the case, I'm even more confused about what xattrs have to do
> > with it.
> 
> [   35.015363] __btrfs_update_delayed_inode(): inode is missing

Okay, like I expected...

> [   35.015372] btrfs_update_delayed_inode(ino=2) -> -2

Wtf? Inode numbers should be >=256. I updated the diff a third time to
catch where that came from. If we're lucky, the backtrace should have
the exact culprit. If we're unlucky, there might be memory corruption
involved.

> osandov-9f223b_2-dmesg.log
> https://drive.google.com/open?id=0B_2Asp8DGjJ9UnNSRXpualprWHM
> 
> 
> -- 
> Chris Murphy
