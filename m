Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51483 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932329Ab3JPQJi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Oct 2013 12:09:38 -0400
Message-ID: <525EBA40.4020401@sandeen.net>
Date: Wed, 16 Oct 2013 11:09:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>
CC: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, jbacik@fusionio.com,
        dsterba@suse.cz
Subject: Re: [PATCH v2] xfstests: add specific test for default ACL inheritance
References: <1381932296-14674-1-git-send-email-fdmanana@gmail.com> <1381938761-31625-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1381938761-31625-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/16/13 10:52 AM, Filipe David Borba Manana wrote:
> This test is motivated by an issue found by a btrfs user, addressed
> and described by the following GNU/Linux kernel patch:
> 
> https://patchwork.kernel.org/patch/3046931/
> 
> The steps to reproduce the issue on btrfs are the following:
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
> After unmounting and mounting again the filesystem, getfacl returned the
> expected default ACL for the subdirectory:
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
> This means that the underlying ACL xattr was persisted correctly but
> the in memory representation of the inode had (incorrectly) a NULL ACL.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
> 
> V2: Moved the regression test into a dedicated and new file, as suggested
>     by Eric Sandeen.

Great, thanks.  Verified that it succeeds on xfs & ext3 as well.

It also fails properly when mounting ext3 -o noacl:

shared/052 1s ... [not run] ACLs not supported by this filesystem type: ext3

...

> +# real QA test starts here
> +_supported_os Linux

Technically this should have a:

+_supported_fs generic 

here.  And then it can move to tests/generic/xxx

(I guess that's a little odd and redundant, and it does
run today w/o the _supported_fs, I guess, but still
best to be consistent).

Sorry for the runaround :)

If you don't mind a V3, we'll be done,  I think!

-Eric

