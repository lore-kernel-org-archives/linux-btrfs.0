From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: btrfsck core dump
Date: Tue, 29 Dec 2009 16:46:09 +0800
Message-ID: <3d0408630912290046i6514f924j7e4ed4fb87ea0463@mail.gmail.com>
References: <200912290426.nBT4QnfQ012260@laika.gnusto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Ted Phelps <phelps@gnusto.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200912290426.nBT4QnfQ012260@laika.gnusto.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 29, 2009 at 12:26 PM, Ted Phelps <phelps@gnusto.com> wrote:
>
> Summary:
>
> My btrfs test partition started failing btrfsck (0.19) today, which m=
ay
> be of interest. =A0What's probably more interesting is that git head
> version of btrfsck reliably crashes when pointed at the filesystem.
> What's more interesting still is that, after unmounting the filesyste=
m,
> btrfsck (both 0.19 and git head) finds no errors. =A0I have to admit =
that
> I find this a bit confusing. =A0Is this expected behavior?
>

btrfsck doesn't support checking mounted fs.

Yan, Zheng

>
> Details:
>
> Today I ran btrfsck-0.19 and it ran to completion without errors. =A0=
I
> then deleted a large number of files from the btrfs filesystem, ran
> sync, and then re-ran btrfsck-0.19. =A0This time it reported a large
> number of errors.
>
> Its output ended thusly:
>
> =A0 =A0...
> =A0 =A0Extent back ref already exists for 63434379264 parent 0 root 2
> =A0 =A0Extent back ref already exists for 48350736384 parent 0 root 2
> =A0 =A0Extent back ref already exists for 48365748224 parent 0 root 2
> =A0 =A0leaf 63447334912 items 52 free space 43 generation 1754 owner =
2
> =A0 =A0fs uuid cc48abf1-0be4-4163-bde6-f8a5264ffa46
> =A0 =A0chunk uuid ffbb5c4b-3848-4154-b7f7-ece63fefde52
> =A0 =A0 =A0 =A0 =A0 =A0item 0 key (63453257728 EXTENT_ITEM 4096) item=
off 3944 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 1753 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (4128112 54 564=
550111) level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 5
> =A0 =A0...
> =A0 =A0 =A0 =A0 =A0 =A0item 50 key (63454093312 EXTENT_ITEM 4096) ite=
moff 1394 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 1754 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (4123891 c 4123=
493) level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 5
> =A0 =A0 =A0 =A0 =A0 =A0item 51 key (63454117888 EXTENT_ITEM 4096) ite=
moff 1343 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 1745 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (4121053 60 24)=
 level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 5
> =A0 =A0failed to find block number 63453356032
> =A0 =A0Abort
>
> A second run produced different output and crashed at a different loc=
ation:
>
> =A0 =A0parent transid verify failed on 63451648000 wanted 1764 found =
1740
> =A0 =A0parent transid verify failed on 63451648000 wanted 1764 found =
1740
> =A0 =A0parent transid verify failed on 63452520448 wanted 1764 found =
1740
> =A0 =A0...
> =A0 =A0leaf parent key incorrect 63453581312
> =A0 =A0bad block 63453581312
> =A0 =A0parent transid verify failed on 63453335552 wanted 1764 found =
1739
> =A0 =A0parent transid verify failed on 63453335552 wanted 1764 found =
1739
> =A0 =A0parent transid verify failed on 63453335552 wanted 1764 found =
1739
> =A0 =A0warning, start mismatch 61248888832 61248884736
> =A0 =A0warning, start mismatch 61248942080 61248937984
> =A0 =A0warning, start mismatch 61249093632 61249077248
> =A0 =A0block 61249077248 rec extent_item_refs 1, passed 1
> =A0 =A0warning, start mismatch 61249105920 61249110016
> =A0 =A0block 61249110016 rec extent_item_refs 1, passed 1
> =A0 =A0Abort
>
> Unfortunately, the beginning of the first run scrolled off the top of=
 my
> scrollback buffer, but the entirety of what I do have is here:
>
> =A0 =A0http://www.gnusto.com/btrfs/dump-20091229.txt
>
>
> I then tried running btrfsck from git head (ab8fb4c9) and it crashed:
>
> =A0 =A0parent transid verify failed on 63447986176 wanted 1765 found =
1742
> =A0 =A0parent transid verify failed on 63447986176 wanted 1765 found =
1742
> =A0 =A0parent transid verify failed on 63447531520 wanted 1765 found =
1736
> =A0 =A0...
> =A0 =A0parent transid verify failed on 63447908352 wanted 1765 found =
1742
> =A0 =A0parent transid verify failed on 63447908352 wanted 1765 found =
1742
> =A0 =A0parent transid verify failed on 63447908352 wanted 1765 found =
1763
> =A0 =A0Segmentation fault (core dumped)
>
> The core file shows the following stack:
>
> (gdb) bt
> =A0 =A0#0 =A00x000000000041e242 in btrfs_header_nritems (eb=3D0x0) at=
 ctree.h:1411
> =A0 =A0#1 =A00x000000000041f87c in btrfs_print_leaf (root=3D0x1e2e200=
, l=3D0x0) at print-tree.c:454
> =A0 =A0#2 =A00x00000000004197e4 in btrfs_lookup_extent_info (trans=3D=
0x0, root=3D0x1e2e200, bytenr=3D63447326720, num_bytes=3D4096, refs=3D0=
x0, flags=3D0x7fff58a1f5c0) at extent-tree.c:1450
> =A0 =A0#3 =A00x0000000000408582 in run_next_block (root=3D0x1e2e200, =
bits=3D0x1e2f410, bits_nr=3D1024, last=3D0x7fff58a1f798, pending=3D0x7f=
ff58a1f890, seen=3D0x7fff58a1f8a0, reada=3D0x7fff58a1f880, nodes=3D0x7f=
ff58a1f870, extent_cache=3D0x7fff58a1f8b0) at btrfsck.c:2509
> =A0 =A0#4 =A00x000000000040942f in check_extents (root=3D0x1e2e200) a=
t btrfsck.c:2797
> =A0 =A0#5 =A00x000000000040951c in main (ac=3D2, av=3D0x7fff58a1fa28)=
 at btrfsck.c:2829
>
> At this point, I copied all of the files to another partition. =A0No
> errors were logged to syslog, which I thought a little odd/impressive=
=2E
> At this point I ran btrfs-image (also from git head). =A0It complaine=
d
> about various transid verify failures but produced the following 90MB
> image:
>
> =A0 =A0http://www.gnusto.com/btrfs/btrfs-image-20091229.img
>
> The partition was mounted with compress and noatime options only. =A0=
I
> then unmounted the file system and re-ran btrfsck-0.19 and it reporte=
d
> no errors. =A0Ditto for btrfsck from git head.
>
> Thanks,
> -Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
