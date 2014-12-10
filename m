Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42960 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905AbaLJOgY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 09:36:24 -0500
Date: Wed, 10 Dec 2014 15:36:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: systemd.setenv and a mount.unit
Message-ID: <20141210143622.GC27601@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <gbjvjb-oqp.ln1@venus.xundeenergie.ssh22.net>
 <546DBFCB.4090506@inwind.it>
 <546DC3EC.1020903@nurfuerspam.de>
 <546DCD20.6030602@inwind.it>
 <CAJCQCtT88Ji52W2za++eUiAXYq1O2hpTaHo_FZgrpNvdVEN=Gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtT88Ji52W2za++eUiAXYq1O2hpTaHo_FZgrpNvdVEN=Gg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 20, 2014 at 11:39:19AM -0700, Chris Murphy wrote:
> On Thu, Nov 20, 2014 at 4:14 AM, Goffredo Baroncelli <kreijack@inwind.it> wrote:
> 
> > Supposing to have the following four subvolumes
> >
> > /root/
> > /root/etc
> > /root/usr
> > /root/var
> >
> > When you need to snapshot, you should:
> >
> > # btrfs subvolume snapshot /root /backup-root-20141120
> > # btrfs subvolume snapshot /root/etc /backup-root-20141120/etc
> > # btrfs subvolume snapshot /root/usr /backup-root-20141120/usr
> > # btrfs subvolume snapshot /root/var /backup-root-20141120/var
> >
> > So in order to remount an "old" filesystem, you need to make only
> > 1 mount.
> 
> I like this layout better than either the openSUSE or Fedora layouts.
> It's easier to mount and old filesystem, where on Fedora each
> subvolume must be explicitly mounted. And it ensures old binaries
> aren't in the current mount path – kinda like running in a chroot –
> where on openSUSE the snapshots containing old binaries are in the
> current mount path.

While the old binaries are in the current mount path, they're not
generally accessible due to 0750 on the .snapshots directory.

The 'single mountpoint for whole root' is not perfect in case there are
files that are independent on the system files, like logs or some
application data in wellknown paths.

The other option is to have separate subvolumes for the selected paths
and either mount them in fstab or do more work when the old filesystem
has to be rolled back and transformed to the expected layout.

Both have their pros and cons so this is a matter of user choice. Eg. if
the logs are forwarded and not kept locally, no applications store data
on root partition. Going to an older snapshot is trivial and without
unexpected consequences.

And of course the layouts are both ways convertible.
