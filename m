Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:51882 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647Ab3JOSAU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Oct 2013 14:00:20 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 73B3A7C0425
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Oct 2013 12:00:19 -0600 (MDT)
Date: Tue, 15 Oct 2013 14:00:17 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix incorrect inode acl reset
Message-ID: <20131015180017.GC14323@localhost.localdomain>
References: <1381859040-11211-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1381859040-11211-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 15, 2013 at 06:44:00PM +0100, Filipe David Borba Manana wrote:
> When a directory has a default ACL and a subdirectory is created
> under that directory, btrfs_init_acl() is called when the
> subdirectory's inode is created to initialize the inode's ACL
> (inherited from the parent directory) but it was clearing the ACL
> from the inode after setting it if posix_acl_create() returned
> success, instead of clearing it only if it returned an error.
> 
> To reproduce this issue:
> 
> $ mkfs.btrfs -f /dev/loop0
> $ mount /dev/loop0 /mnt
> $ mkdir /mnt/acl
> $ setfacl -d --set u::rwx,g::rwx,o::- /mnt/acl
> $ getfacl /mnt/acl
> user::rwx
> group::rwx
> other::r-x
> default:user::rwx
> default:group::rwx
> default:other::---
> 
> $ mkdir /mnt/acl/dir1
> $ getfacl /mnt/acl/dir1
> user::rwx
> group::rwx
> other::---
> 
> After unmounting and mounting again the filesystem, fgetacl returned the
> expected ACL:
> 
> $ umount /mnt/acl
> $ mount /dev/loop0 /mnt
> $ getfacl /mnt/acl/dir1
> user::rwx
> group::rwx
> other::---
> default:user::rwx
> default:group::rwx
> default:other::---
> 
> Meaning that the underlying xattr was persisted.
> 

Can you put this into an xfstest please?  Thanks,

Josef
