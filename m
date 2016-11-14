Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44252 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932261AbcKNMZF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 07:25:05 -0500
Date: Mon, 14 Nov 2016 13:25:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Henk Slager <eye1tm@gmail.com>
Cc: clm@fb.com, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs progs release 4.8.3
Message-ID: <20161114122501.GK12522@suse.cz>
Reply-To: dsterba@suse.cz
References: <20161111153831.22430-1-dsterba@suse.com>
 <CAPmG0jYZnB-Hva2GS3WCGQoer2p3rLu0xJBN3d0JfKPFCvi0sA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPmG0jYZnB-Hva2GS3WCGQoer2p3rLu0xJBN3d0JfKPFCvi0sA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 13, 2016 at 02:28:02PM +0100, Henk Slager wrote:
> On Fri, Nov 11, 2016 at 4:38 PM, David Sterba <dsterba@suse.com> wrote:
> > Hi,
> >
> > btrfs-progs version 4.8.3 have been released. Handful of fixes and lots of
> > cleanups.
> >
> > Changes:
> >   * check:
> >     * support for clearing space cache (v1)
> >     * size reduction of inode backref structure
> >   * send:
> >     * fix handling of multiple snapshots (-p and -c options)
> >     * transfer buffer increased (should reduce number of context switches)
> >     * reuse existing file for output (-f), eg. when root cannot create files (NFS)
> >   * dump-tree:
> >     * print missing items for various structures
> >     * new: dev stats, balance status item
> >     * sync key names with kernel (the persistent items)
> >   * subvol show: now able to print the toplevel subvolume -- the creation time
> >     might be wrong though
> >   * mkfs:
> >     * store the creation time of toplevel root inode
> 
> It looks like commit 5c4d53450b2c6ff7169c99f9158c14ae96b7b0a8
>  (btrfs-progs: mkfs: store creation time of the toplevel subvolume'')
> is not enough to display the creation time of a newly created fs with
> tools v4.8.3, or am I missing something?

This is known and mentioned on the changelog entry above mkfs.

> With kernel 4.8.6-2-default as well as 4.9.0-rc4-1-default:
> 
> # /net/src/btrfs-progs/mkfs.btrfs -L ctimetest -m single /dev/loop0
> btrfs-progs v4.8.3
> See http://btrfs.wiki.kernel.org for more information.
> 
> Performing full device TRIM (100.00GiB) ...
> Label:              ctimetest
> UUID:               d65486f0-368b-4b2a-962b-176cd945feb5
> Node size:          16384
> Sector size:        4096
> Filesystem size:    100.00GiB
> Block group profiles:
>   Data:             single            8.00MiB
>   Metadata:         single            8.00MiB
>   System:           single            4.00MiB
> SSD detected:       no
> Incompat features:  extref, skinny-metadata
> Number of devices:  1
> Devices:
>    ID        SIZE  PATH
>     1   100.00GiB  /dev/loop0
> 
> # mount /dev/loop0 /mnt
> # cd /mnt
> # ls > test
> # sync
> # /net/src/btrfs-progs/btrfs sub sh .
> /mnt
>         Name:                   <FS_TREE>
>         UUID:                   -
>         Parent UUID:            -
>         Received UUID:          -
>         Creation time:          -
>         Subvolume ID:           5
>         Generation:             9
>         Gen at creation:        0
>         Parent ID:              0
>         Top level ID:           0
>         Flags:                  -
>         Snapshot(s):
> 
> I noticed that   btrfs_set_stack_timespec_sec(&inode_item.otime, now);
> is called twice during mkfs.btrfs, but during btrfs sub sh
> get_ri.otime is 0 just before it is formatted/printed.

Your finding is right, I saw the same and would have fixed already, but
it turned out to be more than a simple fix. The on-disk items are
connected to in-memory ones, and the corresponding root item does not
keep them in sync. Ie. setting the otime in one place does not propagate
to the point where 'subvol show' reads it.

> My idea was to
> patch the code (kernel and/or progs) such that I can also put a time
> in some exiting filesystems.

Well, it's possible to write a oneshot tool to set the creation time, if
it's really desired. It would be an arbitrary value set by the user,
because the information about otime cannot be simply derived from the
existing timestamps.
