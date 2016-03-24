Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:56668 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbcCXPZt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 11:25:49 -0400
Date: Thu, 24 Mar 2016 15:25:47 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeff Mahoney <jeffm@jeffm.io>
Cc: Roman Lebedev <lebedev.ri@gmail.com>, David Howells <dhowells@redhat.com>,
        linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: kernel BUG when fsync'ing file in a overlayfs merged dir,
 located on btrfs
Message-ID: <20160324152547.GJ17997@ZenIV.linux.org.uk>
References: <1443643065-16460-1-git-send-email-lebedev.ri@gmail.com>
 <563C171F.30702@jeffm.io>
 <20151106031845.GV22011@ZenIV.linux.org.uk>
 <563C26AE.1020403@jeffm.io>
 <20160324152043.GA22781@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160324152043.GA22781@ZenIV.linux.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 24, 2016 at 03:20:43PM +0000, Al Viro wrote:

> > ocfs2_prepare_inode_for_write uses file->f_path.dentry for
> > should_remove_suid (due to needing to do it early since cluster locking
> > is unknown in setattr, according to the commit).  Having
> > should_remove_suid operate on an inode would solve that easily.
> 
> Can't do - there are filesystems that _need_ dentry for ->setattr().

Grr...  Sorry, misread what you'd written.  should_remove_suid()
ought to be switched to inode, indeed.
