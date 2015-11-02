Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:41132 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773AbbKBUuN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Nov 2015 15:50:13 -0500
Date: Mon, 2 Nov 2015 15:50:12 -0500
To: Neil Brown <neil@brown.name>
Cc: Chris Mason <clm@fb.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC] make btrfs subvol mounts appear in /proc/mounts
Message-ID: <20151102205012.GA26986@fieldses.org>
References: <87oafkc5kp.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87oafkc5kp.fsf@notabene.neil.brown.name>
From: bfields@fieldses.org (J. Bruce Fields)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 28, 2015 at 07:25:10AM +0900, Neil Brown wrote:
> 
> If you create a subvolume in btrfs and access it (by name) without
> mounting it, then the subvolume looks like a separate mount to some
> extent, returning a different st_dev to stat(), but it doesn't look like
> a separate mount in that it isn't listed in /proc/mounts. This
> inconsistency can confuse tools.
> 
> This patch causes these subvolumes to become separate mounts by using
> the VFS' automount functionality, much like NFS uses automount when it
> discovered mountpoints on the server.
> 
> The VFS currently makes it impossible to auto-mount a directory on to itself
> (i.e. a bind mount).  For NFS this isn't a problem as a new superblock
> is created for the child filesystem so there are two separate dentries
> (and inodes) for the one directory: one in the parent filesystem, one in
> the child (note that the two superblocks share a common connection to
> the server so there is still a lot of commonality).
> 
> BTRFS has chosen instead to use a single superblock for all subvolumes.

Naive question: was there a reason for that choice?

--b.

> This results in a single dentry for the subvol-root.  A dentry which
> must be auto-mounted on itself.
