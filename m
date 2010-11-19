From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: Symlinks' device numbers differ from regular files'
Date: Fri, 19 Nov 2010 10:05:24 +0800
Message-ID: <4CE5DB64.3010102@cn.fujitsu.com>
References: <20101118235423.GC12925@toke.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101118235423.GC12925@toke.dk>
List-ID: <linux-btrfs.vger.kernel.org>

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Hi
>=20
> I am having a problem with my btrfs partitions: symlinks are reported=
 to=20
> have different device numbers than directories and regular files, eve=
n=20
> though they are on the same partition. This causes my backup software=
 to=20
> mess up backing up the symlinks.
>=20
> An illustrative example:
>=20
> $ touch tmp; ln -s tmp tmp2; stat tmp tmp2
>   File: `tmp'
>   Size: 0         	Blocks: 0          IO Block: 4096   regular empty =
file
> Device: 15h/21d	Inode: 984027      Links: 1
> --- snip ---
>   File: `tmp2' -> `tmp'
>   Size: 3         	Blocks: 0          IO Block: 4096   symbolic link
> Device: 13h/19d	Inode: 984028      Links: 1
> --- snip ---
>=20
> $ uname -r
> 2.6.35-ck
>=20
> I'm not using subvolumes, or any fancy features of btrfs, really. I'm=
=20
> running Arch Linux.
>=20
> Is this normal? And if not, how do I fix it?
>=20
> Any help would be greatly appreciated.  Thanks in advance.
>=20

This should fix it:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

[PATCH] btrfs: Show device attr correctly for symlinks

Symlinks and files of other types show different device numbers, though
they are on the same partition:

 $ touch tmp; ln -s tmp tmp2; stat tmp tmp2
   File: `tmp'
   Size: 0         	Blocks: 0          IO Block: 4096   regular empty f=
ile
 Device: 15h/21d	Inode: 984027      Links: 1
 --- snip ---
   File: `tmp2' -> `tmp'
   Size: 3         	Blocks: 0          IO Block: 4096   symbolic link
 Device: 13h/19d	Inode: 984028      Links: 1

Reported-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5132c9a..d10b6d4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7139,6 +7139,7 @@ static const struct inode_operations btrfs_symlin=
k_inode_operations =3D {
 	.readlink	=3D generic_readlink,
 	.follow_link	=3D page_follow_link_light,
 	.put_link	=3D page_put_link,
+	.getattr	=3D btrfs_getattr,
 	.permission	=3D btrfs_permission,
 	.setxattr	=3D btrfs_setxattr,
 	.getxattr	=3D btrfs_getxattr,
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
