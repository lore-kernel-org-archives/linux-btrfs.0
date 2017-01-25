Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:35436 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751137AbdAYEnV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 23:43:21 -0500
Received: by mail-pf0-f177.google.com with SMTP id f144so55255082pfa.2
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jan 2017 20:43:21 -0800 (PST)
Date: Tue, 24 Jan 2017 20:42:53 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, agruenba@redhat.com
Subject: Re: read-only fs, kernel 4.9.0, fs/btrfs/delayed-inode.c:1170
 __btrfs_run_delayed_items,
Message-ID: <20170125044253.GA18885@vader>
References: <20170124185644.GA2853@vader>
 <CAJCQCtTcanEcoPGwLxBcLUjzgt5MZYdDMpEvk1vgX3ZVPizHvg@mail.gmail.com>
 <CAJCQCtQvt=xYtAGwPXk1Vhb7pmVNCbpFOg+W3Eh=-L9LSJkbaw@mail.gmail.com>
 <20170124201038.GB2853@vader>
 <CAJCQCtQm4RoN6zGEWDFTn9CigTaMM8Mxepc=UJhNhWCavp9U-A@mail.gmail.com>
 <20170124202723.GD2853@vader>
 <CAJCQCtQ-h++dwSRGtNp6RZXJjo0T63ouYwwM8PnasqGAyJCB=A@mail.gmail.com>
 <CAJCQCtQbHNyiK0L8MGk+2UO6ajGPBvowg6bg2EZPXpE3XySvWA@mail.gmail.com>
 <20170124225052.GA10425@vader>
 <CAJCQCtQ4tmCB4OBw1Jx43yunxMChRwKmcUVb1xSLr0KHwKSe-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtQ4tmCB4OBw1Jx43yunxMChRwKmcUVb1xSLr0KHwKSe-A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 24, 2017 at 07:53:06PM -0700, Chris Murphy wrote:
> On Tue, Jan 24, 2017 at 3:50 PM, Omar Sandoval <osandov@osandov.com> wrote:
> 
> > Got this to repro after installing systemd-container. It's happening on
> > lsetxattr() to set the SELinux context on /var/lib/machines, which is a
> > subvolume. Looking into it now. Thanks for all of the help, Chris.
> 
> Aha! So the snapshot part was a goose chase, it has nothing to do with
> that, really. Because I'm taking a snapshot of root, the nested
> /var/lib/machines subvolume is not in that snapshot, so now it has to
> be created by systemd at next boot and the proper selinux label set on
> it.
> 
> It means there's something different about subvolumes and directories
> when it comes to xattrs, and the xattr patch I found in bisect is
> exposing the difference, hence things getting tripped up.

The snapshots were actually the key -- the error was because setxattr()
was being allowed on the read-only directory created in the place of the
/var/lib/machines subvolume. Not sure if you saw the patch I sent up,
but this should fix it: https://patchwork.kernel.org/patch/9536307/
