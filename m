Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53403 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752264AbdK1Su0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 13:50:26 -0500
Date: Tue, 28 Nov 2017 19:48:28 +0100
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How about adding an ioctl to convert a directory to a subvolume?
Message-ID: <20171128184828.GB3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171127094156.GC29491@fnst.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20171127094156.GC29491@fnst.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 27, 2017 at 05:41:56PM +0800, Lu Fengqi wrote:
> As we all know, under certain circumstances, it is more appropriate to
> create some subvolumes rather than keep everything in the same
> subvolume. As the condition of demand change, the user may need to
> convert a previous directory to a subvolume. For this reason，how about
> adding an ioctl to convert a directory to a subvolume?

I'd say too difficult to get everything right in kernel. This is
possible to be done in userspace, with existing tools.

The problem is that the conversion cannot be done atomically in most
cases, so even if it's just one ioctl call, there are several possible
intermediate states that would exist during the call. Reporting where
did the ioctl fail would need some extended error code semantics.

> Users can convert by the scripts mentioned in this
> thread(https://www.spinics.net/lists/linux-btrfs/msg33252.html), but is
> it easier to use the off-the-shelf btrfs subcommand?

Adding a subcommand would work, though I'd rather avoid reimplementing
'cp -ax' or 'rsync -ax'.  We want to copy the files preserving all
attributes, with reflink, and be able to identify partially synced
files, and not cross the mountpoints or subvolumes.

The middle step with snapshotting the containing subvolume before
syncing the data is also a valid option, but not always necessary.

> After an initial consideration, our implementation is broadly divided
> into the following steps:
> 1. Freeze the filesystem or set the subvolume above the source directory
> to read-only;

Freezing the filesystme will freeze all IO, so this would not work, but
I understand what you mean. The file data are synced before the snapshot
is taken, but nothing prevents applications to continue writing data.

Open and live files is a problem and don't see a nice solution here.

> 2. Perform a pre-check, for example, check if a cross-device link
> creation during the conversion;

Cross-device links are not a problem as long as we use 'cp' ie. the
manual creation of files in the target.

> 3. Perform conversion, such as creating a new subvolume and moving the
> contents of the source directory;
> 4. Thaw the filesystem or restore the subvolume writable property.
> 
> In fact, I am not so sure whether this use of freeze is appropriate
> because the source directory the user needs to convert may be located
> at / or /home and this pre-check and conversion process may take a long
> time, which can lead to some shell and graphical application suspended.

I think the closest operation is a read-only remount, which is not
always possible due to open files and can otherwise considered as quite
intrusive operation to the whole system. And the root filesystem cannot
be easily remounted read-only in the systemd days anyway.
