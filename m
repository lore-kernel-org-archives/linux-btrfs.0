From: Bernhard Rosenkraenzer <bero@arklinux.org>
Subject: [PATCH] current btrfs-progs-unstable fails to compile
Date: Fri, 18 Jun 2010 22:49:17 +0200
Message-ID: <973363eb2b532a0d12b580c6246db3f3@blankpage.ch>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_dc82ea24512c69fb62515e5b2cc7ce3e"
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--=_dc82ea24512c69fb62515e5b2cc7ce3e
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 charset=UTF-8

Hi,
current btrfs-progs-unstable fails to compile for me (Ark Linux devel
branch, using gcc 4.5 and eglibc 2.12):

/usr/bin/ld: btrfsck.o: in function maybe_free_inode_rec:btrfsck.c:323:
error: undefined reference to 'S_ISDIR'
/usr/bin/ld: btrfsck.o: in function maybe_free_inode_rec:btrfsck.c:340:
error: undefined reference to 'S_ISREG'
/usr/bin/ld: btrfsck.o: in function maybe_free_inode_rec:btrfsck.c:328:
error: undefined reference to 'S_ISREG'
/usr/bin/ld: btrfsck.o: in function maybe_free_inode_rec:btrfsck.c:340:
error: undefined reference to 'S_ISLNK'
/usr/bin/ld: btrfsck.o: in function maybe_free_inode_rec:btrfsck.c:328:
error: undefined reference to 'S_ISLNK'
collect2: ld returned 1 exit status

Patch attached.

ttyl
bero
--=_dc82ea24512c69fb62515e5b2cc7ce3e
Content-Transfer-Encoding: base64
Content-Type: text/x-c;
 name=btrfsck-compile.patch;
 charset=UTF-8
Content-Disposition: attachment;
 filename=btrfsck-compile.patch

LS0tIGJ0cmZzLXByb2dzLXVuc3RhYmxlL2J0cmZzY2suYy5hcmsJMjAxMC0wNi0xOCAyMjo1Mjo1
Mi41OTI1MzU1ODYgKzAyMDAKKysrIGJ0cmZzLXByb2dzLXVuc3RhYmxlL2J0cmZzY2suYwkyMDEw
LTA2LTE4IDIyOjUyOjU5LjU0MDQxNzE2NCArMDIwMApAQCAtMTgsNiArMTgsNyBAQAogCiAjZGVm
aW5lIF9YT1BFTl9TT1VSQ0UgNTAwCiAjZGVmaW5lIF9HTlVfU09VUkNFIDEKKyNpbmNsdWRlIDxz
eXMvc3RhdC5oPgogI2luY2x1ZGUgPHN0ZGlvLmg+CiAjaW5jbHVkZSA8c3RkbGliLmg+CiAjaW5j
bHVkZSA8ZmNudGwuaD4K
--=_dc82ea24512c69fb62515e5b2cc7ce3e--

