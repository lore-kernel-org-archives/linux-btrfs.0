Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37022 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741Ab3GAQVY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Jul 2013 12:21:24 -0400
Date: Mon, 1 Jul 2013 18:21:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Stefan Paletta <stefanp@cabal1.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: why check f_path.mnt is equal for source and dest in
 btrfs_ioctl_clone()?
Message-ID: <20130701162122.GE18204@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <kqoobm$jq4$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <kqoobm$jq4$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 30, 2013 at 09:55:26AM +0200, Stefan Paletta wrote:
> This gives EXDEV for clone operations that btrfs could otherwise execute and
> with slight change of circumstances will actually execute fine.
> 
> Imagine we have a btrfs on /dev/mapper/foobar with subvols /foo and /bar.
> Let’s also imagine top of said fs in mounted at /mnt. In this case, a
> cross-subvol clone of /mnt/foo/srcfile to /mnt/bar/dstfile will succeed.

This does not cross a mountpoint.

> However, if only the individual subvols were mounted like this:
> 	/dev/mapper/foobar on /mnt (subvol=foo)
> 	/dev/mapper/foobar on /mnt2 (subvol=bar),
> then a clone of /mnt/srcfile to /mnt2/dstfile will fail with EXDEV even
> though it is otherwise equal to the former clone operation.

And this does. This is prevented for the same reason hadlinks do not
work accross mountpoints when the same filesytem is mounted multiple
times.

> Would anyone care to shed some light on this? Is it due to legacy policy? Am
> I missing something?

http://thread.gmane.org/gmane.comp.file-systems.btrfs/9867

Although it's more about reflink/clone spanning subvolumes regardless of
the mountpoints, there's an objection against file operations performed
accross vfsmounts and current implementation respects that.

david
