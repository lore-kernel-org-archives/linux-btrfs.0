Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from a.smtp.srvr.mx ([75.126.210.127]:37795 "EHLO a.smtp.srvr.mx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbbGTEjn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jul 2015 00:39:43 -0400
Message-ID: <55AC7B8C.3050704@sandino.net>
Date: Sun, 19 Jul 2015 23:39:40 -0500
From: =?windows-1252?Q?Sandino_Araico_S=E1nchez?= <sandino@sandino.net>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Integer underflow in ctree.c
References: <558443D4.3050506@sandino.net> <559B9872.7070000@cn.fujitsu.com>
In-Reply-To: <559B9872.7070000@cn.fujitsu.com>
Content-Type: multipart/mixed;
 boundary="------------060102080501050700010502"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060102080501050700010502
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/07/15 04:14, Qu Wenruo wrote:
>
>
> Sandino Araico S=E1nchez wrote on 2015/06/19 11:31 -0500:
>> :btrfs check crashed while trying to fix my corrupted filesystem.
>>
>> btrfs check --repair /dev/sdd3
>> enabling repair mode
>> Checking filesystem on /dev/sdd3
>> UUID: 58222ebc-79ca-4dc4-891f-129aae342313
>> checking extents
>> bad key ordering 0 1
>> bad block 3535142326272
>> Errors found in extent allocation tree or chunk allocation
>> Fixed 0 roots.
>> checking free space cache
>> cache and super generation don't match, space cache will be invalidate=
d
>> checking fs roots
>> bad key ordering 0 1
>> bad key ordering 0 1
>> The following tree block(s) is corrupted in tree 814:
>>          tree block bytenr: 3535142346752, level: 0, node key:
>> (1270098042880, 168, 4096)
>> Try to repair the btree for root 814
>> Segmentation fault
>>
>> What I found on the gdb backtrace:
>>
>> (gdb) bt
>> #0=C2  0x00006fc5cb578411 in ?? ()
>> #1=C2  0x000009d5fe028bab in memmove_extent_buffer (dst=3D0x9d76942cf3=
0,
>> dst_offset=3D1586, src_offset=3D1619, len=3D141733920735) at extent_io=
=2Ec:880
>> #2=C2  0x000009d5fe002e1b in btrfs_del_ptr (trans=3D0x9d7669ec990,
>> root=3D0x9d7648891c0, path=3D0x9d7669f69f0, level=3D0, slot=3D45) at
>> ctree.c:2592
>> #3=C2  0x000009d5fdfd467a in repair_btree (root=3D0x9d7648891c0,
>> corrupt_blocks=3D0x70f1b0905030) at cmds-check.c:3267
>> #4=C2  0x000009d5fdfd4e40 in check_fs_root (root=3D0x9d7648891c0,
>> root_cache=3D0x70f1b0905380, wc=3D0x70f1b0905240) at cmds-check.c:3422=

>> #5=C2  0x000009d5fdfd52e6 in check_fs_roots (root=3D0x9d5ffdf0d10,
>> root_cache=3D0x70f1b0905380) at cmds-check.c:3523
>> #6=C2  0x000009d5fdfe4ce6 in cmd_check (argc=3D1, argv=3D0x70f1b090556=
0) at
>> cmds-check.c:9470
>> #7=C2  0x000009d5fdfad8a1 in main (argc=3D3, argv=3D0x70f1b0905560) at=

>> btrfs.c:245
>> (gdb) select-frame 2
>> (gdb) info locals
>> parent =3D 0x9d76942cf30
>> nritems =3D 45
>> ret =3D 0
>> __func__ =3D "btrfs_del_ptr"
>>
>> function btrfs_del_ptr parameter is called with slot=3D45
>> and in line 2590=C2  btrfs_header_nritems(parent) returns 45 for varia=
ble
>> nritems;
>>
>> in line 2596 the result of (nritems - slot - 1) equals to 0x00000000 -=
 1
>> and memmove_extent_buffer gets called with a huge value for parameter
>> len.
>>
>> After the patch btrfs check is not crashing anymore.
>>
>
> The root problem seems not here.
> Would you please show the "level" variant in frame 3?
>
> Or, btrfs-debug-tree with its error output please.
> As for such problem we can't use btrfs-image do dump the metadata.
>
>
> The problem here, is why btrfs_search_slot will return the pointer to
> the last *non-exist* slot.
> Normally, it means btrfs_search_slot can't find the exact item, and
> the result slot is where new key should be inserted into.
>
> I'm afraid the level things is corrupted...
It's a corrupted filesystem. I tried to fix it but I was unsuccessful. I
patched another integer underflow but forgot to send the patch to the
list and now btrfs-progs has changed to 4.1. I have attached the patch
to this e-mail in case you might find it useful.

After this patch the btrfs check process did not crash anymore but now
it loops indefinitely... I spent about a week messing with code in
repair_btree() trying to force deletion of the corrupted blocks but I
didn't succeed; it kept looping in check_fs_roots() between ret =3D
check_fs_root() and goto again; I stoped trying but the filesystem is
still corrupt so I can give it another try.

I will do another  btrfs check with btrfs-progs 4.1 and I will send you
btrfs-debug-tree output.

>
> Thanks,
> Qu
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


--=20
Sandino Araico S=E1nchez=20
http://sandino.net


--------------060102080501050700010502
Content-Type: text/x-patch;
 name="btrfs-progs-v4.0.1-integer-underflow.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="btrfs-progs-v4.0.1-integer-underflow.patch"

diff -uriN btrfs-progs-v4.0.1.orig/ctree.c btrfs-progs-v4.0.1/ctree.c
--- btrfs-progs-v4.0.1.orig/ctree.c	2015-06-19 03:43:12.000000000 -0500
+++ btrfs-progs-v4.0.1/ctree.c	2015-06-21 05:15:35.000000000 -0500
@@ -2588,14 +2588,16 @@
 	int ret =3D 0;
=20
 	nritems =3D btrfs_header_nritems(parent);
-	if (slot !=3D nritems -1) {
-		memmove_extent_buffer(parent,
-			      btrfs_node_key_ptr_offset(slot),
-			      btrfs_node_key_ptr_offset(slot + 1),
-			      sizeof(struct btrfs_key_ptr) *
-			      (nritems - slot - 1));
+	if (nritems > 0) {
+		if (slot < nritems -1) {
+			memmove_extent_buffer(parent,
+					 btrfs_node_key_ptr_offset(slot),
+					 btrfs_node_key_ptr_offset(slot + 1),
+					 sizeof(struct btrfs_key_ptr) *
+					 (nritems - slot - 1));
+		}
+		nritems--;
 	}
-	nritems--;
 	btrfs_set_header_nritems(parent, nritems);
 	if (nritems =3D=3D 0 && parent =3D=3D root->node) {
 		BUG_ON(btrfs_header_level(root->node) !=3D 1);

--------------060102080501050700010502--
