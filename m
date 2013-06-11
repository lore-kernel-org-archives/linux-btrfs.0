Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:58866 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab3FKU5E (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Jun 2013 16:57:04 -0400
Received: by mail-we0-f177.google.com with SMTP id m19so6047484wev.8
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Jun 2013 13:57:02 -0700 (PDT)
Message-ID: <51B78F1B.7000100@gmail.com>
Date: Tue, 11 Jun 2013 22:56:59 +0200
From: Gabriel de Perthuis <g2p.code@gmail.com>
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.de>
CC: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <josef@redhat.com>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 0/4] btrfs: offline dedupe v2
References: <1370982698-757-1-git-send-email-mfasheh@suse.de>
In-Reply-To: <1370982698-757-1-git-send-email-mfasheh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 11/06/2013 22:31, Mark Fasheh a écrit :
> Perhaps this isn't a limiation per-se but extent-same requires read/write
> access to the files we want to dedupe.  During my last series I had a
> conversation with Gabriel de Perthuis about access checking where we tried
> to maintain the ability for a user to run extent-same against a readonly
> snapshot. In addition, I reasoned that since the underlying data won't
> change (at least to the user) that we ought only require the files to be
> open for read.
> 
> What I found however is that neither of these is a great idea ;)
> 
> - We want to require that the inode be open for writing so that an
>   unprivileged user can't do things like run dedupe on a performance
>   sensitive file that they might only have read access to.  In addition I
>   could see it as kind of a surprise (non-standard behavior) to an
>   administrator that users could alter the layout of files they are only
>   allowed to read.
> 
> - Readonly snapshots won't let you open for write anyway (unsuprisingly,
>   open() returns -EROFS).  So that kind of kills the idea of them being able
>   to open those files for write which we want to dedupe.
> 
> That said, I still think being able to run this against a set of readonly
> snapshots makes sense especially if those snapshots are taken for backup
> purposes. I'm just not sure how we can sanely enable it.

The check could be: if (fmode_write || cap_sys_admin).

This isn't incompatible with mnt_want_write, that check is at the
level of the superblocks and vfsmount and not the subvolume fsid.

> Code review is very much appreciated. Thanks,
>      --Mark
> 
> 
> ChangeLog
> 
> - check that we have appropriate access to each file before deduping. For
>   the source, we only check that it is opened for read. Target files have to
>   be open for write.
> 
> - don't dedupe on readonly submounts (this is to maintain 
> 
> - check that we don't dedupe files with different checksumming states
>  (compare BTRFS_INODE_NODATASUM flags)
> 
> - get and maintain write access to the mount during the extent same
>   operation (mount_want_write())
> 
> - allocate our read buffers up front in btrfs_ioctl_file_extent_same() and
>   pass them through for re-use on every call to btrfs_extent_same(). (thanks
>   to David Sterba <dsterba@suse.cz> for reporting this
> 
> - As the read buffers could possibly be up to 1MB (depending on user
>   request), we now conditionally vmalloc them.
> 
> - removed redundant check for same inode. btrfs_extent_same() catches it now
>   and bubbles the error up.
> 
> - remove some unnecessary printks
> 
> Changes from RFC to v1:
> 
> - don't error on large length value in btrfs exent-same, instead we just
>   dedupe the maximum allowed.  That way userspace doesn't have to worry
>   about an arbitrary length limit.
> 
> - btrfs_extent_same will now loop over the dedupe range at 1MB increments (for
>   a total of 16MB per request)
> 
> - cleaned up poorly coded while loop in __extent_read_full_page() (thanks to
>   David Sterba <dsterba@suse.cz> for reporting this)
> 
> - included two fixes from Gabriel de Perthuis <g2p.code@gmail.com>:
>    - allow dedupe across subvolumes
>    - don't lock compressed pages twice when deduplicating
> 
> - removed some unused / poorly designed fields in btrfs_ioctl_same_args.
>   This should also give us a bit more reserved bytes.
> 
> - return -E2BIG instead of -ENOMEM when arg list is too large (thanks to
>   David Sterba <dsterba@suse.cz> for reporting this)
> 
> - Some more reserved bytes are now included as a result of some of my
>   cleanups. Quite possibly we could add a couple more.
> 

