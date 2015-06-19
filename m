Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from a.smtp.srvr.mx ([75.126.210.127]:37427 "EHLO a.smtp.srvr.mx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbbFSQbS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Jun 2015 12:31:18 -0400
Received: from a.smtp.srvr.mx (localhost [127.0.0.1])
	by a.smtp.srvr.mx (Postfix) with ESMTP id 51E34126
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2015 11:31:16 -0500 (CDT)
Received: from carpaccio.sandino.net (carpaccio.i.sandino.net [192.168.4.8])
	by a.smtp.srvr.mx (Postfix) with ESMTP id F199BCB
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2015 11:31:15 -0500 (CDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by carpaccio.sandino.net (Postfix) with ESMTP id 171B980B09
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2015 11:31:17 -0500 (CDT)
Message-ID: <558443D4.3050506@sandino.net>
Date: Fri, 19 Jun 2015 11:31:16 -0500
From: =?windows-1252?Q?Sandino_Araico_S=E1nchez?= <sandino@sandino.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Integer underflow in ctree.c
Content-Type: multipart/mixed;
 boundary="------------040904030609080201040203"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040904030609080201040203
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

:btrfs check crashed while trying to fix my corrupted filesystem.

btrfs check --repair /dev/sdd3
enabling repair mode
Checking filesystem on /dev/sdd3
UUID: 58222ebc-79ca-4dc4-891f-129aae342313
checking extents
bad key ordering 0 1
bad block 3535142326272
Errors found in extent allocation tree or chunk allocation
Fixed 0 roots.
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
bad key ordering 0 1
bad key ordering 0 1
The following tree block(s) is corrupted in tree 814:
        tree block bytenr: 3535142346752, level: 0, node key:
(1270098042880, 168, 4096)
Try to repair the btree for root 814
Segmentation fault

What I found on the gdb backtrace:

(gdb) bt
#0=C2  0x00006fc5cb578411 in ?? ()
#1=C2  0x000009d5fe028bab in memmove_extent_buffer (dst=3D0x9d76942cf30,
dst_offset=3D1586, src_offset=3D1619, len=3D141733920735) at extent_io.c:=
880
#2=C2  0x000009d5fe002e1b in btrfs_del_ptr (trans=3D0x9d7669ec990,
root=3D0x9d7648891c0, path=3D0x9d7669f69f0, level=3D0, slot=3D45) at ctre=
e.c:2592
#3=C2  0x000009d5fdfd467a in repair_btree (root=3D0x9d7648891c0,
corrupt_blocks=3D0x70f1b0905030) at cmds-check.c:3267
#4=C2  0x000009d5fdfd4e40 in check_fs_root (root=3D0x9d7648891c0,
root_cache=3D0x70f1b0905380, wc=3D0x70f1b0905240) at cmds-check.c:3422
#5=C2  0x000009d5fdfd52e6 in check_fs_roots (root=3D0x9d5ffdf0d10,
root_cache=3D0x70f1b0905380) at cmds-check.c:3523
#6=C2  0x000009d5fdfe4ce6 in cmd_check (argc=3D1, argv=3D0x70f1b0905560) =
at
cmds-check.c:9470
#7=C2  0x000009d5fdfad8a1 in main (argc=3D3, argv=3D0x70f1b0905560) at bt=
rfs.c:245
(gdb) select-frame 2
(gdb) info locals
parent =3D 0x9d76942cf30
nritems =3D 45
ret =3D 0
__func__ =3D "btrfs_del_ptr"

function btrfs_del_ptr parameter is called with slot=3D45
and in line 2590=C2  btrfs_header_nritems(parent) returns 45 for variable
nritems;

in line 2596 the result of (nritems - slot - 1) equals to 0x00000000 - 1
and memmove_extent_buffer gets called with a huge value for parameter len=
.

After the patch btrfs check is not crashing anymore.

--=20
Sandino Araico S=C3=A1nchez=20
http://sandino.net


--------------040904030609080201040203
Content-Type: text/x-patch;
 name="btrfs-progs-v4.0.1-integer-underflow.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="btrfs-progs-v4.0.1-integer-underflow.patch"

diff -uri btrfs-progs-v4.0.1.orig/ctree.c btrfs-progs-v4.0.1/ctree.c
--- btrfs-progs-v4.0.1.orig/ctree.c	2015-06-19 03:43:12.000000000 -0500
+++ btrfs-progs-v4.0.1/ctree.c	2015-06-19 03:43:49.000000000 -0500
@@ -2588,7 +2588,7 @@
 	int ret = 0;
 
 	nritems = btrfs_header_nritems(parent);
-	if (slot != nritems -1) {
+	if (slot < nritems -1) {
 		memmove_extent_buffer(parent,
 			      btrfs_node_key_ptr_offset(slot),
 			      btrfs_node_key_ptr_offset(slot + 1),


--------------040904030609080201040203--
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
