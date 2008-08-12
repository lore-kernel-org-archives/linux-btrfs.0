From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Btrfs-devel] btrfs without acl
Date: Tue, 12 Aug 2008 09:38:21 -0400
Message-ID: <1218548301.15342.306.camel@think.oraclecorp.com>
References: <200808121140.23390.mail@earthworm.de>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Josef Bacik <jbacik@redhat.com>
To: Christian Hesse <mail@earthworm.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200808121140.23390.mail@earthworm.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-08-12 at 11:40 +0200, Christian Hesse wrote:
> Hello everyone,
> 
> trying to build btrfs-0.16 without acl support (CONFIG_FS_POSIX_ACL unset) 
> results in the following error messages for me:
> 
> fs/built-in.o: In function `btrfs_permission':
> inode.c:(.text+0x61250): undefined reference to `btrfs_check_acl'
> fs/built-in.o: In function `btrfs_create':
> inode.c:(.text+0x63bdf): undefined reference to `btrfs_init_acl'
> fs/built-in.o: In function `btrfs_mknod':
> inode.c:(.text+0x63eef): undefined reference to `btrfs_init_acl'
> fs/built-in.o: In function `btrfs_mkdir':
> inode.c:(.text+0x6410b): undefined reference to `btrfs_init_acl'
> fs/built-in.o: In function `btrfs_symlink':
> inode.c:(.text+0x64386): undefined reference to `btrfs_init_acl'
> fs/built-in.o: In function `btrfs_setattr':
> inode.c:(.text+0x66443): undefined reference to `btrfs_acl_chmod'
> 
> Looking at the unstable tree I do not think this is fixed yet.

Josef, looks like we need a few #ifdefs ;)

-chris


