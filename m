Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:50103 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaAQCW7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jan 2014 21:22:59 -0500
Received: by mail-wi0-f182.google.com with SMTP id ex4so124919wid.9
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Jan 2014 18:22:57 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 16 Jan 2014 21:22:57 -0500
Message-ID: <CAB5sJHwdf+MmNPfFrrmX7HYnmTjKXY-Wju2db_0i3VQ7A+eMag@mail.gmail.com>
Subject: [PATCH] Btrfs-progs: Fix bus error on sparc
From: Ivan Jager <aij+@mrph.org>
To: linux-btrfs@vger.kernel.org
Content-Type: multipart/mixed; boundary=089e0115e78c63f0e304f021380a
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--089e0115e78c63f0e304f021380a
Content-Type: text/plain; charset=ISO-8859-1

Hello,

Currently, as of 8cae1840afb3ea44dcc298f32983e577480dfee4 when running
btrfs-convert I get a bus error.

The problem is that struct btrfs_key has __attribute__ ((__packed__))
so it is not aligned. Then, a pointer to it's objectid field is taken,
cast to a  void*, then eventually cast back to a u64* and
dereferenced. The problem is that the dereferenced u64* is not
necessarily aligned (ie, not necessarily a valid u64*), resulting in
undefined behavior.

This patch adds a local u64 variable which would of course be properly
aligned and then uses a pointer to that.

I did not modify the call from btrfs_fs_roots_compare_roots as that
uses struct btrfs_root which is a regular struct and would thus have
it's members correctly aligned to begin with.

After patching this I realized Liu Bo had already written a similar
patch, but I think mine is cleaner, so I'm sending it anyway.

If you like, I could also change the location->objectid references
between my two changes, which would make the patch bigger, but would
make it actually reduce the overall code size slightly.

Feel free to make or request any necessary style changes as I couldn't
find documentation on the coding style for btrfs-tools.

Please CC me as I'm not on the list.

Thanks,
Ivan

PS: Here is the gdb output in case anyone is interested.

ivan@chacoi:~/src/btrfs-progs$ gdb ./btrfs-convert
GNU gdb (GDB) 7.6.1 (Debian 7.6.1-1)
Copyright (C) 2013 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "sparc-linux-gnu".
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>...
Reading symbols from /home/ivan/src/btrfs-progs/btrfs-convert...done.
(gdb) run ../e4.img
Starting program: /home/ivan/src/btrfs-progs/./btrfs-convert ../e4.img
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/sparc-linux-gnu/libthread_db.so.1".

Program received signal SIGBUS, Bus error.
btrfs_fs_roots_compare_objectids (node=0x7ab00, data=0xffffd1fb) at
disk-io.c:656
656             u64 objectid = *((u64 *)data);
(gdb) bt
#0  btrfs_fs_roots_compare_objectids (node=0x7ab00, data=0xffffd1fb)
at disk-io.c:656
#1  0x0004d964 in rb_search (root=<optimized out>, key=0xffffd1fb,
    comp=0x1ae24 <btrfs_fs_roots_compare_objectids>, next_ret=0x0) at
rbtree.c:425
#2  0x0001e048 in btrfs_read_fs_root (fs_info=0x78be0,
location=0xffffd1fb) at disk-io.c:698
#3  0x00046244 in create_subvol (trans=0x7adc8, root=0x7a8e0,
root_objectid=256) at btrfs-convert.c:1583
#4  0x00048eb8 in init_btrfs (root=0x7a8e0) at btrfs-convert.c:1631
#5  do_convert (devname=0xffffd935 "../e4.img", datacsum=1, packing=1,
noxattr=0) at btrfs-convert.c:2275
#6  0x0004cfcc in main (argc=1, argv=0xffffd814) at btrfs-convert.c:2743
(gdb) frame 3
#3  0x00046244 in create_subvol (trans=0x7adc8, root=0x7a8e0,
root_objectid=256) at btrfs-convert.c:1583
1583            new_root = btrfs_read_fs_root(root->fs_info, &key);
(gdb) print &key
$1 = (struct btrfs_key *) 0xffffd1fb

--089e0115e78c63f0e304f021380a
Content-Type: text/plain; charset=US-ASCII; name="btrfs-tools-patch-sparc.diff"
Content-Disposition: attachment; filename="btrfs-tools-patch-sparc.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hqisxf3j0

ZGlmZiAtLWdpdCBhL2Rpc2staW8uYyBiL2Rpc2staW8uYwppbmRleCAwYWYzODk4Li5hOTk1YjUy
IDEwMDY0NAotLS0gYS9kaXNrLWlvLmMKKysrIGIvZGlzay1pby5jCkBAIC02ODAsNiArNjgwLDcg
QEAgc3RydWN0IGJ0cmZzX3Jvb3QgKmJ0cmZzX3JlYWRfZnNfcm9vdChzdHJ1Y3QgYnRyZnNfZnNf
aW5mbyAqZnNfaW5mbywKIAlzdHJ1Y3QgYnRyZnNfcm9vdCAqcm9vdDsKIAlzdHJ1Y3QgcmJfbm9k
ZSAqbm9kZTsKIAlpbnQgcmV0OworCXU2NCBvYmplY3RpZCA9IGxvY2F0aW9uLT5vYmplY3RpZDsK
IAogCWlmIChsb2NhdGlvbi0+b2JqZWN0aWQgPT0gQlRSRlNfUk9PVF9UUkVFX09CSkVDVElEKQog
CQlyZXR1cm4gZnNfaW5mby0+dHJlZV9yb290OwpAQCAtNjk1LDcgKzY5Niw3IEBAIHN0cnVjdCBi
dHJmc19yb290ICpidHJmc19yZWFkX2ZzX3Jvb3Qoc3RydWN0IGJ0cmZzX2ZzX2luZm8gKmZzX2lu
Zm8sCiAJQlVHX09OKGxvY2F0aW9uLT5vYmplY3RpZCA9PSBCVFJGU19UUkVFX1JFTE9DX09CSkVD
VElEIHx8CiAJICAgICAgIGxvY2F0aW9uLT5vZmZzZXQgIT0gKHU2NCktMSk7CiAKLQlub2RlID0g
cmJfc2VhcmNoKCZmc19pbmZvLT5mc19yb290X3RyZWUsICh2b2lkICopJmxvY2F0aW9uLT5vYmpl
Y3RpZCwKKwlub2RlID0gcmJfc2VhcmNoKCZmc19pbmZvLT5mc19yb290X3RyZWUsICh2b2lkICop
Jm9iamVjdGlkLAogCQkJIGJ0cmZzX2ZzX3Jvb3RzX2NvbXBhcmVfb2JqZWN0aWRzLCBOVUxMKTsK
IAlpZiAobm9kZSkKIAkJcmV0dXJuIGNvbnRhaW5lcl9vZihub2RlLCBzdHJ1Y3QgYnRyZnNfcm9v
dCwgcmJfbm9kZSk7Cg==
--089e0115e78c63f0e304f021380a--
