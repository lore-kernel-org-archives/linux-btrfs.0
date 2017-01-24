Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:35889 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750751AbdAXUsO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 15:48:14 -0500
Received: by mail-yw0-f193.google.com with SMTP id q71so16965824ywg.3
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jan 2017 12:48:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ-h++dwSRGtNp6RZXJjo0T63ouYwwM8PnasqGAyJCB=A@mail.gmail.com>
References: <CAJCQCtQNgvu72GUBpvJtnAH-Sj-fd566HwDpeuGjaPmdtrUO3g@mail.gmail.com>
 <20170124000524.GC11778@vader.DHCP.thefacebook.com> <CAJCQCtSHx8cEanC7e71akLiRKzi+Rt96CSAoK11Ngud9=n1U-Q@mail.gmail.com>
 <20170124174907.GA27340@vader> <CAJCQCtQVYdc9JK_B=XCrTBE6YYjqz23D3rEmRLoJUbM7gQVQSQ@mail.gmail.com>
 <20170124185644.GA2853@vader> <CAJCQCtTcanEcoPGwLxBcLUjzgt5MZYdDMpEvk1vgX3ZVPizHvg@mail.gmail.com>
 <CAJCQCtQvt=xYtAGwPXk1Vhb7pmVNCbpFOg+W3Eh=-L9LSJkbaw@mail.gmail.com>
 <20170124201038.GB2853@vader> <CAJCQCtQm4RoN6zGEWDFTn9CigTaMM8Mxepc=UJhNhWCavp9U-A@mail.gmail.com>
 <20170124202723.GD2853@vader> <CAJCQCtQ-h++dwSRGtNp6RZXJjo0T63ouYwwM8PnasqGAyJCB=A@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 24 Jan 2017 13:48:12 -0700
Message-ID: <CAJCQCtQbHNyiK0L8MGk+2UO6ajGPBvowg6bg2EZPXpE3XySvWA@mail.gmail.com>
Subject: Re: read-only fs, kernel 4.9.0, fs/btrfs/delayed-inode.c:1170 __btrfs_run_delayed_items,
To: Chris Murphy <lists@colorremedies.com>
Cc: Omar Sandoval <osandov@osandov.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, agruenba@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

journal_debug.log booted with patched kernel and params
systemd.log_level=debug rd.debug, and then output to file with
journalctl -b -o short-monotonic
https://drive.google.com/open?id=0B_2Asp8DGjJ9MjRDWi0tZ0x4V2s

I'm uncertain of the immediacy of some event resulting in another but...


[    8.159581] f25h systemd-tmpfiles[720]: Running create action for
entry d /var/run/pptp
[    8.159703] f25h systemd-tmpfiles[720]: Created directory "/var/run/pptp".
[    8.159825] f25h systemd-tmpfiles[720]: "/var/run/pptp" has right mode 40750
[    8.159944] f25h systemd-tmpfiles[720]: Running remove action for
entry d /var/run/pptp
[    8.160070] f25h systemd-tmpfiles[720]: Running create action for
entry d /var/run/radvd
[    8.160186] f25h systemd-tmpfiles[720]: Created directory "/var/run/radvd".
[    8.160312] f25h systemd-tmpfiles[720]: "/var/run/radvd" has right mode 40755
[    8.171770] f25h kernel: ------------[ cut here ]------------
[    8.174028] f25h kernel: WARNING: CPU: 2 PID: 720 at
fs/btrfs/delayed-inode.c:55
btrfs_get_or_create_delayed_node+0x16a/0x1e0 [btrfs]
[    8.176316] f25h kernel: ino 2 is out of range


Is it the creation of these directories triggering the error? Anyway,
there's a bunch of systemd-tmpfiles activity prior to this, and right
before the btrfs_get_or_create_delayed_node call trace.


The final call trace is cut off, I guess when systemd switches from
/run to /var and flushes, if the fs goes read only and can't write all
of what's flushed, it results in journal data loss. If the rest of the
output is useful I can switch systemd to only use volatile storage to
avoid this problem.


Chris Murphy
