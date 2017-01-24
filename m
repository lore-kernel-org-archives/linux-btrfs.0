Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:35565 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750704AbdAXTGC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 14:06:02 -0500
Received: by mail-yb0-f195.google.com with SMTP id j82so7854405ybg.2
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jan 2017 11:06:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170124185644.GA2853@vader>
References: <CAJCQCtQz5fhYymEgFuxuiactZpWeUSEeCCXFCAEmLTTA6AOZLQ@mail.gmail.com>
 <20170123213109.GA11778@vader.DHCP.thefacebook.com> <CAJCQCtSVXRXvGmnmfFt5yn_L33a8eCCuuFANxTOyWLrJeqrK9g@mail.gmail.com>
 <CAJCQCtRip_D7BPhCJDVP53LRoQoEcVrvCf7eyGK9sa8qv23BNQ@mail.gmail.com>
 <20170123220448.GB11778@vader.DHCP.thefacebook.com> <CAJCQCtQNgvu72GUBpvJtnAH-Sj-fd566HwDpeuGjaPmdtrUO3g@mail.gmail.com>
 <20170124000524.GC11778@vader.DHCP.thefacebook.com> <CAJCQCtSHx8cEanC7e71akLiRKzi+Rt96CSAoK11Ngud9=n1U-Q@mail.gmail.com>
 <20170124174907.GA27340@vader> <CAJCQCtQVYdc9JK_B=XCrTBE6YYjqz23D3rEmRLoJUbM7gQVQSQ@mail.gmail.com>
 <20170124185644.GA2853@vader>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 24 Jan 2017 12:06:01 -0700
Message-ID: <CAJCQCtTcanEcoPGwLxBcLUjzgt5MZYdDMpEvk1vgX3ZVPizHvg@mail.gmail.com>
Subject: Re: read-only fs, kernel 4.9.0, fs/btrfs/delayed-inode.c:1170 __btrfs_run_delayed_items,
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, agruenba@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 24, 2017 at 11:56 AM, Omar Sandoval <osandov@osandov.com> wrote:
> Yup, definitely doesn't look like memory corruption. I set up a Fedora
> VM yesterday to try to repro with basically those same steps but it
> didn't happen. I'll try again, but is there anything special about your
> Fedora installation?

Default mkfs. Default mount options.

However, due to subsequent suboptimal situation (installing Windows 10
after Fedora), this Btrfs volume is actually a two device volume: two
partitions with Windows 10 in between them.

[chris@f25h ~]$ sudo btrfs fi show
Label: 'fedora'  uuid: c45caf39-a048-4c44-90c9-535dc8003c71
    Total devices 2 FS bytes used 51.37GiB
    devid    1 size 25.00GiB used 21.03GiB path /dev/nvme0n1p4
    devid    2 size 48.83GiB used 43.00GiB path /dev/nvme0n1p6

[chris@f25h ~]$ sudo gdisk -l /dev/nvme0n1
[...snip...]
Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048          411647   200.0 MiB   EF00  EFI System Partition
   2          411648         2508799   1024.0 MiB  8300
   3         2508800        16873471   6.8 GiB     8200
   4        16873472        69302271   25.0 GiB    8300  Linux filesystem
   5        69302272       229046271   76.2 GiB    0700  Microsoft basic data
   6       229046272       331446271   48.8 GiB    8300  Linux filesystem
   7       331446272       500118158   80.4 GiB    8E00  Linux LVM

p4 was made to small when adding in Windows; so I shrank Windows to
make p6, and then added p6 to p4. Hence p4 and p6 are the same Btrfs
volume (single profile for metadata and data).


-- 
Chris Murphy
