Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:54632 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S965254AbdKQWgr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 17:36:47 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eFpFW-0004bc-6T
        for linux-btrfs@vger.kernel.org; Fri, 17 Nov 2017 23:36:38 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Need help with incremental backup strategy (snapshots,
 defragmentingt & performance)
Date: Fri, 17 Nov 2017 23:36:37 +0100
Message-ID: <20171117233637.6a3e1ae4@jupiter.sol.kaishome.de>
References: <CAH=dxU5mGQ5ws11fFKC+X3F810MceMxNBwnCR=g=Rau9DLDRng@mail.gmail.com>
        <20171101101510.218eeead@natsu>
        <CAH=dxU56geiO7MuWSbPgpfBQ3vbkPYm6juQZzu3-1=-RzG+ZSQ@mail.gmail.com>
        <20171114135040.65a659c0@natsu>
        <CAH=dxU7wjag+BPNdu__WidU1qNPeF7Sxgc8YthAVvxbrHx5VmA@mail.gmail.com>
        <20171116171330.7493c9c4@jupiter.sol.kaishome.de>
        <d7f8d215-e845-79e6-12a9-29468287d7b9@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Fri, 17 Nov 2017 06:51:52 +0300
schrieb Andrei Borzenkov <arvidjaar@gmail.com>:

> 16.11.2017 19:13, Kai Krakow пишет:
> ...
> > > BTW: From user API perspective, btrfs snapshots do not guarantee  
> > perfect granular consistent backups.  
> 
> Is it documented somewhere? I was relying on crash-consistent
> write-order-preserving snapshots in NetApp for as long as I remember.
> And I was sure btrfs offers is as it is something obvious for
> redirect-on-write idea.

I think it has ordering guarantees, but it is not as atomic in time as
one might think. That's the point. But devs may tell better.


> > A user-level file transaction may
> > still end up only partially in the snapshot. If you are running
> > transaction sensitive applications, those usually do provide some
> > means of preparing a freeze and a thaw of transactions.
> >   
> 
> Is snapshot creation synchronous to know when thaw?

I think you could do "btrfs snap create", then "btrfs fs sync", and
everything should be fine.


> > I think the user transactions API which could've been used for this
> > will even be removed during the next kernel cycles. I remember
> > reiserfs4 tried to deploy something similar. But there's no
> > consistent layer in the VFS for subscribing applications to
> > filesystem snapshots so they could prepare and notify the kernel
> > when they are ready. 
> 
> I do not see what VFS has to do with it. NetApp works by simply
> preserving previous consistency point instead of throwing it away.
> I.e. snapshot is always last committed image on stable storage. Would
> something like this be possible on btrfs level by duplicating current
> on-disk root (sorry if I use wrong term)?

I think btrfs gives the same consistency. But the moment you issue
"btrfs snap create" may delay snapshot creation a little bit. So if
your application relies on exact point in time snapshots, you need to
ensure synchronizing your application to the filesystem. I think the
same is true for NetApp.

I just wanted to point that out because it may not be obvious, given
that btrfs snapshot creation is built right into the tool chain of
filesystem itself, unlike e.g. NetApp or LVM, or other storage layers.

Background: A good while back I was told that btrfs snapshots during
ongoing IO may result in some of the later IO carried over to before
the snapshot. Transactional ordering of IO operations is still
guaranteed but it may overlap with snapshot creation. So you can still
loose a transaction you didn't expect to loose at that point in time.

So I understood this as:

If you just want to ensure transactional integrity of your database,
you are all fine with btrfs snapshots.

But if you want to ensure that a just finished transaction makes it
into the snapshot completely, you have to sync the processes.

However, things may have changed since then.


-- 
Regards,
Kai

Replies to list-only preferred.


