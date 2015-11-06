Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:42288 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965545AbbKFDSt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Nov 2015 22:18:49 -0500
Date: Fri, 6 Nov 2015 03:18:45 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeff Mahoney <jeffm@jeffm.io>
Cc: Roman Lebedev <lebedev.ri@gmail.com>, David Howells <dhowells@redhat.com>,
        linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: kernel BUG when fsync'ing file in a overlayfs merged dir,
 located on btrfs
Message-ID: <20151106031845.GV22011@ZenIV.linux.org.uk>
References: <1443643065-16460-1-git-send-email-lebedev.ri@gmail.com>
 <563C171F.30702@jeffm.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <563C171F.30702@jeffm.io>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 05, 2015 at 09:57:35PM -0500, Jeff Mahoney wrote:

> So now file_operations callbacks can't assume that file->f_path.dentry
> belongs to the same file system that implements the callback.  More than
> that, any code that could ultimately get a dentry that comes from an
> open file can't trust that it's from the same file system.

Use file_inode() for inode.

> This crash is due to this issue.  Unlike xfs and ext2/3/4, we use
> file->f_path.dentry->d_inode to resolve the inode.  Using file_inode()
> is an easy enough fix here, but we run into trouble later.  We have
> logic in the btrfs fsync() call path (check_parent_dirs_for_sync) that
> walks back up the dentry chain examining the inode's last transaction
> and last unlink transaction to determine whether a full transaction
> commit is required.  This obviously doesn't work if we're walking the
> overlayfs path instead.  Regardless of any argument over whether that's
> doing the right thing, it's a pretty common pattern to assume that
> file->f_path.dentry comes from the same file system when using a
> file_operation.  Is it intended that that assumption is no longer valid?

It's actually rare, and your example is a perfect demonstration of the
reasons why it is so rare.  What's to protect btrfs_log_dentry_safe()
from racing with rename(2)?  Sure, you do dget_parent().  Which protects
you from having one-time parent dentry freed under you.  What it doesn't
do is making any promises about its relationship with your file.
