From: "Yan Zheng" <yanzheng@21cn.com>
Subject: Re: 'cp -p' leaves mode on destination files/dirs incorrect
Date: Tue, 3 Jun 2008 18:20:27 +0800
Message-ID: <3d0408630806030320u6610f93ep469917f914035291@mail.gmail.com>
References: <200805291148.46203.chris.mason@oracle.com>
	 <4844857A.4010708@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Joe Peterson" <lavajoe@gentoo.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4844857A.4010708@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

2008/6/3 Joe Peterson <lavajoe@gentoo.org>:
> Hi all, this is a problem observed in btrfs-0.15:
>
> Using 'cp -p', 'cp -a', or moving files to btrfs from another filesystem
> (which does a copy then remove) will leave the copied files with the
> wrong mode.  Specifically, all permissions for 'group' or 'other' are
> nulled out.  My umask is the typical 0022, but umask should not matter
> here anyway (to make sure I wasn't crazy, I tried it on an ext3 partition).

Hello,

This is a known bug.  The attached patch can temporarily fix it.

Regards
YZ
---
diff -r 4b7e2b315a32 xattr.c
--- a/xattr.c	Thu May 29 10:31:43 2008 -0400
+++ b/xattr.c	Tue Jun 03 18:19:19 2008 +0800
@@ -29,22 +29,22 @@ static struct xattr_handler *btrfs_xattr
 static struct xattr_handler *btrfs_xattr_handler_map[] = {
 	[BTRFS_XATTR_INDEX_USER]		= &btrfs_xattr_user_handler,
 #ifdef CONFIG_FS_POSIX_ACL
-	[BTRFS_XATTR_INDEX_POSIX_ACL_ACCESS]	= &btrfs_xattr_acl_access_handler,
-	[BTRFS_XATTR_INDEX_POSIX_ACL_DEFAULT]	= &btrfs_xattr_acl_default_handler,
+//	[BTRFS_XATTR_INDEX_POSIX_ACL_ACCESS]	= &btrfs_xattr_acl_access_handler,
+//	[BTRFS_XATTR_INDEX_POSIX_ACL_DEFAULT]	= &btrfs_xattr_acl_default_handler,
 #endif
 	[BTRFS_XATTR_INDEX_TRUSTED]		= &btrfs_xattr_trusted_handler,
 	[BTRFS_XATTR_INDEX_SECURITY]		= &btrfs_xattr_security_handler,
-	[BTRFS_XATTR_INDEX_SYSTEM]		= &btrfs_xattr_system_handler,
+//	[BTRFS_XATTR_INDEX_SYSTEM]		= &btrfs_xattr_system_handler,
 };
 struct xattr_handler *btrfs_xattr_handlers[] = {
 	&btrfs_xattr_user_handler,
 #ifdef CONFIG_FS_POSIX_ACL
-	&btrfs_xattr_acl_access_handler,
-	&btrfs_xattr_acl_default_handler,
+//	&btrfs_xattr_acl_access_handler,
+//	&btrfs_xattr_acl_default_handler,
 #endif
 	&btrfs_xattr_trusted_handler,
 	&btrfs_xattr_security_handler,
-	&btrfs_xattr_system_handler,
+//	&btrfs_xattr_system_handler,
 	NULL,
 };
