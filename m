From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: [PATCH] Snapshot/subvolume listing feature
Date: Mon, 16 Nov 2009 10:42:00 +0900
Message-ID: <4B00ADE8.4090205@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
To: linux-btrfs@vger.kernel.org, chris.mason@oracle.com,
	zheng.yan@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I made Snapshot/subvolume listing feature.

This feature consists of two patches, for kernel(ioctl),
and for progs(btrfsctl). I send these two patches as response
of this mail soon.

New option '-l' is introduced to btrfsctl for listing.

If this option is specified, btrfsctl call new ioctl. New ioctl
searches root tree and enumerates subtrees. For each subtrees,
ioctl searches directory path to tree root, and enumerates
more descendant until no more subtree is found.

MANPAGE-like option description and examples are as follows.

 OPTIONS
 	-l _file_
 		List all snapshot/subvolume directories under a tree
 		which _file_ belongs to.

 EXAMPLES
 	# btrfsctl -l /work/btrfs
    Base path = /work/btrfs/
    No.	   Tree ID	Subvolume Relative Path
     1	       256	ss1/
     2	       257	ss2/
     3	       258	svs1/ss1/
     4	       259	svs1/ss2/
     5	       260	svs2/ss1/
     6	       261	svs2/ss2/
     7	       262	ss3/
     8	       263	ss4/
     9	       264	sv_pool/
    10	       265	sv_pool/ss01/
    11	       266	sv_pool/ss02/
    12	       267	sv_pool/ss03/
    13	       268	sv_pool/ss04/
    14	       269	sv_pool/ss05/
    15	       270	sv_pool/ss06/
    16	       271	sv_pool/ss07/
    17	       272	sv_pool/ss08/
    18	       273	sv_pool/ss09/
    19	       274	sv_pool/ss10/
 operation complete
 Btrfs v0.19-9-gd67dad2

Regards,
taruisi

