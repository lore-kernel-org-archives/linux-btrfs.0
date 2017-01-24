Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:32798 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbdAXWvT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 17:51:19 -0500
Received: by mail-pg0-f46.google.com with SMTP id 204so58523474pge.0
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jan 2017 14:51:19 -0800 (PST)
Date: Tue, 24 Jan 2017 14:50:52 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, agruenba@redhat.com
Subject: Re: read-only fs, kernel 4.9.0, fs/btrfs/delayed-inode.c:1170
 __btrfs_run_delayed_items,
Message-ID: <20170124225052.GA10425@vader>
References: <20170124174907.GA27340@vader>
 <CAJCQCtQVYdc9JK_B=XCrTBE6YYjqz23D3rEmRLoJUbM7gQVQSQ@mail.gmail.com>
 <20170124185644.GA2853@vader>
 <CAJCQCtTcanEcoPGwLxBcLUjzgt5MZYdDMpEvk1vgX3ZVPizHvg@mail.gmail.com>
 <CAJCQCtQvt=xYtAGwPXk1Vhb7pmVNCbpFOg+W3Eh=-L9LSJkbaw@mail.gmail.com>
 <20170124201038.GB2853@vader>
 <CAJCQCtQm4RoN6zGEWDFTn9CigTaMM8Mxepc=UJhNhWCavp9U-A@mail.gmail.com>
 <20170124202723.GD2853@vader>
 <CAJCQCtQ-h++dwSRGtNp6RZXJjo0T63ouYwwM8PnasqGAyJCB=A@mail.gmail.com>
 <CAJCQCtQbHNyiK0L8MGk+2UO6ajGPBvowg6bg2EZPXpE3XySvWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtQbHNyiK0L8MGk+2UO6ajGPBvowg6bg2EZPXpE3XySvWA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 24, 2017 at 01:48:12PM -0700, Chris Murphy wrote:
> journal_debug.log booted with patched kernel and params
> systemd.log_level=debug rd.debug, and then output to file with
> journalctl -b -o short-monotonic
> https://drive.google.com/open?id=0B_2Asp8DGjJ9MjRDWi0tZ0x4V2s
> 
> I'm uncertain of the immediacy of some event resulting in another but...
> 
> 
> [    8.159581] f25h systemd-tmpfiles[720]: Running create action for
> entry d /var/run/pptp
> [    8.159703] f25h systemd-tmpfiles[720]: Created directory "/var/run/pptp".
> [    8.159825] f25h systemd-tmpfiles[720]: "/var/run/pptp" has right mode 40750
> [    8.159944] f25h systemd-tmpfiles[720]: Running remove action for
> entry d /var/run/pptp
> [    8.160070] f25h systemd-tmpfiles[720]: Running create action for
> entry d /var/run/radvd
> [    8.160186] f25h systemd-tmpfiles[720]: Created directory "/var/run/radvd".
> [    8.160312] f25h systemd-tmpfiles[720]: "/var/run/radvd" has right mode 40755
> [    8.171770] f25h kernel: ------------[ cut here ]------------
> [    8.174028] f25h kernel: WARNING: CPU: 2 PID: 720 at
> fs/btrfs/delayed-inode.c:55
> btrfs_get_or_create_delayed_node+0x16a/0x1e0 [btrfs]
> [    8.176316] f25h kernel: ino 2 is out of range
> 
> 
> Is it the creation of these directories triggering the error? Anyway,
> there's a bunch of systemd-tmpfiles activity prior to this, and right
> before the btrfs_get_or_create_delayed_node call trace.
> 
> 
> The final call trace is cut off, I guess when systemd switches from
> /run to /var and flushes, if the fs goes read only and can't write all
> of what's flushed, it results in journal data loss. If the rest of the
> output is useful I can switch systemd to only use volatile storage to
> avoid this problem.

Got this to repro after installing systemd-container. It's happening on
lsetxattr() to set the SELinux context on /var/lib/machines, which is a
subvolume. Looking into it now. Thanks for all of the help, Chris.
