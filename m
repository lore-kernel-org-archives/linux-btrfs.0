Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:36216 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbdAYCxI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 21:53:08 -0500
Received: by mail-yw0-f194.google.com with SMTP id q71so17581095ywg.3
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jan 2017 18:53:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170124225052.GA10425@vader>
References: <20170124174907.GA27340@vader> <CAJCQCtQVYdc9JK_B=XCrTBE6YYjqz23D3rEmRLoJUbM7gQVQSQ@mail.gmail.com>
 <20170124185644.GA2853@vader> <CAJCQCtTcanEcoPGwLxBcLUjzgt5MZYdDMpEvk1vgX3ZVPizHvg@mail.gmail.com>
 <CAJCQCtQvt=xYtAGwPXk1Vhb7pmVNCbpFOg+W3Eh=-L9LSJkbaw@mail.gmail.com>
 <20170124201038.GB2853@vader> <CAJCQCtQm4RoN6zGEWDFTn9CigTaMM8Mxepc=UJhNhWCavp9U-A@mail.gmail.com>
 <20170124202723.GD2853@vader> <CAJCQCtQ-h++dwSRGtNp6RZXJjo0T63ouYwwM8PnasqGAyJCB=A@mail.gmail.com>
 <CAJCQCtQbHNyiK0L8MGk+2UO6ajGPBvowg6bg2EZPXpE3XySvWA@mail.gmail.com> <20170124225052.GA10425@vader>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 24 Jan 2017 19:53:06 -0700
Message-ID: <CAJCQCtQ4tmCB4OBw1Jx43yunxMChRwKmcUVb1xSLr0KHwKSe-A@mail.gmail.com>
Subject: Re: read-only fs, kernel 4.9.0, fs/btrfs/delayed-inode.c:1170 __btrfs_run_delayed_items,
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, agruenba@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 24, 2017 at 3:50 PM, Omar Sandoval <osandov@osandov.com> wrote:

> Got this to repro after installing systemd-container. It's happening on
> lsetxattr() to set the SELinux context on /var/lib/machines, which is a
> subvolume. Looking into it now. Thanks for all of the help, Chris.

Aha! So the snapshot part was a goose chase, it has nothing to do with
that, really. Because I'm taking a snapshot of root, the nested
/var/lib/machines subvolume is not in that snapshot, so now it has to
be created by systemd at next boot and the proper selinux label set on
it.

It means there's something different about subvolumes and directories
when it comes to xattrs, and the xattr patch I found in bisect is
exposing the difference, hence things getting tripped up.

-- 
Chris Murphy
