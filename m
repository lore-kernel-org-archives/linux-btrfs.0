Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54142 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754278AbcCRPRl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 11:17:41 -0400
Date: Fri, 18 Mar 2016 16:17:14 +0100
From: David Sterba <dsterba@suse.cz>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, clm@fb.com
Subject: Re: [PATCH v2] btrfs-progs: add stat check in open_ctree_fs_info
Message-ID: <20160318151714.GA21722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1458309822-5550-1-git-send-email-ahferroin7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458309822-5550-1-git-send-email-ahferroin7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 18, 2016 at 10:03:42AM -0400, Austin S. Hemmelgarn wrote:
> Currently, open_ctree_fs_info will open whatever path you pass it and try
> to interpret it as a BTRFS filesystem.  While this is not nessecarily
> dangerous (except possibly if done on a character device), it does
> result in some rather cryptic and non-sensical error messages when
> trying to run certain commands in ways they weren't intended to be run.
> Add a check using stat(2) to verify that the path we've been passed is
> in fact a regular file or a block device, or a symlink pointing to a
> regular file or block device.
> 
> This causes the following commands to provide a helpful error message
> when run on a FIFO, directory, character device, or socket:
>     * btrfs check
>     * btrfs restore
>     * btrfs-image
>     * btrfs-find-root
>     * btrfs inspect-internal dump-tree
> 
> stat(2) is used instead of lstat(2), as stat(2) follows symlinks just
> like open(2) does, which means we check the same inode that open(2)
> opens, and thus don't need special handling for symlinks.
> 
> Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>

Applied, thanks.

> This has been both build and runtime tested on an x86-64 system with
> glibc.  It has been build but not runtime tested with uClibc on x86-64
> and ARMv7.  It has not been tested on Android or with musl, although it
> should work there also.

I would not expect any difference among the other arches and libc, it's
using a common interface.

> There are other tools that have similarly poor error behavior when
> called incorrectly (btrfs rescue immediately comes to mind), but they
> don't use open_ctree_fs_info, so this doesn't affect them.  I may do
> followup patches to fix those too if I have the time.

Yeah, it would be good to fix all.

> Whitelisting is used instead of blacklisting because I feel it provides
> a more concise and more easily readable conditional, and because I
> think it's a lot less likely that a new file type will be added that
> can contain a filesystem image than it is that one will be added which
> can't contain a filesystem image (it's more likely that Solaris doors
> get ported to Linux than that we get some new file type).

Agreed.
