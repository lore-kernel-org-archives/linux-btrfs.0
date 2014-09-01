Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:57856 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbaIAIrf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Sep 2014 04:47:35 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: Zooko Wilcox-OHearn <zooko@leastauthority.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: fs corruption report
Date: Mon, 01 Sep 2014 10:47:26 +0200
Message-ID: <1484373.Oezxgh4u8P@ax5200p>
In-Reply-To: <1409192882.1582.13.camel@localhost.localdomain>
References: <CAM_a8JxJBFQykuF13UF1Fi9jbM-=yromXbQ5PrWM5JPR7u6pXA@mail.gmail.com> <1409192882.1582.13.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart3608757.l4H6ftootx"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart3608757.l4H6ftootx
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Guy,

Am Donnerstag 28 August 2014, 10:28:02 schrieb Gui Hecheng:
> On Mon, 2014-08-25 at 05:08 +0000, Zooko Wilcox-OHearn wrote:
> > Aha. When it is run under valgrind it consistently stops (killing
> > valgrind, in fact!) in the same way on every run.
> >=20
> > Here's the tail of stdout and stderr when it aborted when run under=

> > valgrind:
> >=20
> > Restoring
> > ./sda6-btrfs-restore-3/@home/zooko/.mozilla/firefox/ltjwtkwe.ketoti=
c.org/
> > thumbnails/188888af64f6d2871b0f24e325d8a298.png Restoring
> > ./sda6-btrfs-restofailed to inflate: -6
> >=20
> > Full valgrind outputs from such a run is attached to this letter.
> >=20
> > I've spent a little time looking at the stack traces in the valgrin=
d
> > log, and I *guess* that there is corruption such that the
> > decompression fails, and I guess it would be possible to make
> > cmds-restore handle corrupted compressedtext better, so that it wou=
ld
> > end up skipping whatever files and directories were unrestorable du=
e
> > to corruption. However, I don't immediately see how to proceed.
> >=20
> > Regards,
>=20
> Hi Zooko=EF=BC=8C
> Here are some pieces for your information:
>=20
> For the first:
> =3D=3D5569=3D=3D Syscall param pwrite64(buf) points to uninitialised =
byte(s)
> =3D=3D5569=3D=3D    at 0x56ABD03: __pwrite_nocancel (syscall-template=
.S:81)
> =3D=3D5569=3D=3D    by 0x41F346: search_dir (cmds-restore.c:392)
>=20
> It is handled by
> https://patchwork.kernel.org/patch/4755441/
>=20
> For the second:
> =3D=3D5569=3D=3D Invalid read of size 1
> =3D=3D5569=3D=3D    at 0x4C2F95E: memcpy@@GLIBC_2.14
> =3D=3D5569=3D=3D    by 0x4388E6: read_extent_buffer (string3.h:51)
> =3D=3D5569=3D=3D    by 0x41ED6C: search_dir (cmds-restore.c:233)
>=20
> It should be handled by
> https://patchwork.kernel.org/patch/4792381/
> And it handles Marc's similar problem too.

I can confirm that this patch really cures these memleaks, but ....

>=20
> And for the last one and the crucial one...
> =3D=3D5569=3D=3D Invalid read of size 4
> =3D=3D5569=3D=3D    at 0x41E394: decompress (cmds-restore.c:93)
> =3D=3D5569=3D=3D    by 0x41F291: search_dir (cmds-restore.c:378)
> along with
> =3D=3D5569=3D=3D Invalid read of size 1
> =3D=3D5569=3D=3D    at 0x548DDB6: lzo1x_decompress_safe
> =3D=3D5569=3D=3D    by 0x41E3BD: decompress (cmds-restore.c:122)
> =3D=3D5569=3D=3D    by 0x41F291: search_dir (cmds-restore.c:378)
>=20
> Sorry, I'm not able to reproduce it yet, it may be just what you've
> guessed that corruption happens. But I am sure that there are bugs
> around the decompress routine, because I've got "failed to inflate"s =
too
> with a non-corrupted btrfs. I'm going to track it down.

this one still exists. It took me a while to reproduce this (actually, =
find=20
the file which causes it). So we have:

=3D=3D27292=3D=3D Invalid read of size 8
=3D=3D27292=3D=3D    at 0x57A10D2: lzo1x_decompress_safe (in=20
/usr/lib64/liblzo2.so.2.0.0)
=3D=3D27292=3D=3D    by 0x41E9ED: decompress (cmds-restore.c:129)
=3D=3D27292=3D=3D    by 0x41F8A7: search_dir (cmds-restore.c:386)
=3D=3D27292=3D=3D    by 0x41FFE6: search_dir (cmds-restore.c:916)
=3D=3D27292=3D=3D    by 0x41FFE6: search_dir (cmds-restore.c:916)
=3D=3D27292=3D=3D    by 0x41FFE6: search_dir (cmds-restore.c:916)
=3D=3D27292=3D=3D    by 0x41FFE6: search_dir (cmds-restore.c:916)
=3D=3D27292=3D=3D    by 0x420C6F: cmd_restore (cmds-restore.c:1319)
=3D=3D27292=3D=3D    by 0x4042FC: main (btrfs.c:247)
=3D=3D27292=3D=3D  Address 0x6280afc is 24,572 bytes inside a block of =
size 24,576=20
alloc'd
=3D=3D27292=3D=3D    at 0x4C277AB: malloc (in /usr/lib64/valgrind/vgpre=
load_memcheck-
amd64-linux.so)
=3D=3D27292=3D=3D    by 0x41F577: search_dir (cmds-restore.c:317)
=3D=3D27292=3D=3D    by 0x41FFE6: search_dir (cmds-restore.c:916)
=3D=3D27292=3D=3D    by 0x41FFE6: search_dir (cmds-restore.c:916)
=3D=3D27292=3D=3D    by 0x41FFE6: search_dir (cmds-restore.c:916)
=3D=3D27292=3D=3D    by 0x41FFE6: search_dir (cmds-restore.c:916)
=3D=3D27292=3D=3D    by 0x420C6F: cmd_restore (cmds-restore.c:1319)
=3D=3D27292=3D=3D    by 0x4042FC: main (btrfs.c:247)
=3D=3D27292=3D=3D=20
=3D=3D27292=3D=3D (action on error) vgdb me ...=20

and the attached debug backtrace is (I attached the full bt):

Program received signal SIGTRAP, Trace/breakpoint trap.
0x00000000057a10d2 in lzo1x_decompress_safe () from /usr/lib64/liblzo2.=
so.2
(gdb) bt
#0  0x00000000057a10d2 in lzo1x_decompress_safe () from=20
/usr/lib64/liblzo2.so.2
#1  0x000000000041e9ee in decompress_lzo (decompress_len=3D0x7feff9f60,=
=20
compress_len=3D417,=20
    outbuf=3D0x63229a0 "ource/core/dom/webcore_dom.StaticNodeList.o",=20=

inbuf=3D0x6280a6d "\017ource/core/dom/webl\001") at cmds-restore.c:129
#2  decompress (inbuf=3Dinbuf@entry=3D0x627ab00 "zU\001",=20
outbuf=3Doutbuf@entry=3D0x631a9a0 "<X", compress_len=3Dcompress_len@ent=
ry=3D24576,=20
    decompress_len=3Ddecompress_len@entry=3D0x7feff9f60,=20
compress=3Dcompress@entry=3D2) at cmds-restore.c:155
#3  0x000000000041f8a8 in copy_one_extent (pos=3D4063232, fi=3D<optimiz=
ed out>,=20
leaf=3D0x5fb58d0, fd=3D4, root=3D0x61405c0) at cmds-restore.c:386
#4  copy_file (file=3D0x66a700 <path_name>=20
"/work/chromium/src/out/Release/.ninja_deps", key=3D0x7feffb080, fd=3D4=
,=20
root=3D0x61405c0)
    at cmds-restore.c:659
#5  search_dir (root=3Droot@entry=3D0x61405c0, key=3Dkey@entry=3D0x7fef=
fc2d0,=20
output_rootdir=3Doutput_rootdir@entry=3D0x7fefffdb0 "/work",=20
    in_dir=3Din_dir@entry=3D0x6602d70 "/chromium/src/out/Release",=20
mreg=3Dmreg@entry=3D0x7fefffd60) at cmds-restore.c:840
#6  0x000000000041ffe7 in search_dir (root=3Droot@entry=3D0x61405c0,=20=

key=3Dkey@entry=3D0x7feffd520,=20
    output_rootdir=3Doutput_rootdir@entry=3D0x7fefffdb0 "/work",=20
in_dir=3Din_dir@entry=3D0x6df4d90 "/chromium/src/out",=20
    mreg=3Dmreg@entry=3D0x7fefffd60) at cmds-restore.c:916
#7  0x000000000041ffe7 in search_dir (root=3Droot@entry=3D0x61405c0,=20=

key=3Dkey@entry=3D0x7feffe770,=20
    output_rootdir=3Doutput_rootdir@entry=3D0x7fefffdb0 "/work",=20
in_dir=3Din_dir@entry=3D0x65d7080 "/chromium/src", mreg=3Dmreg@entry=3D=
0x7fefffd60)
    at cmds-restore.c:916
#8  0x000000000041ffe7 in search_dir (root=3Droot@entry=3D0x61405c0,=20=

key=3Dkey@entry=3D0x7fefff9c0,=20
    output_rootdir=3Doutput_rootdir@entry=3D0x7fefffdb0 "/work",=20
in_dir=3Din_dir@entry=3D0x6f35ac0 "/chromium", mreg=3Dmreg@entry=3D0x7f=
efffd60)
    at cmds-restore.c:916
#9  0x000000000041ffe7 in search_dir (root=3Droot@entry=3D0x61405c0,=20=

key=3Dkey@entry=3D0x7fefffe30,=20
    output_rootdir=3Doutput_rootdir@entry=3D0x7fefffdb0 "/work",=20
in_dir=3Din_dir@entry=3D0x45ab43 "", mreg=3Dmreg@entry=3D0x7fefffd60)
    at cmds-restore.c:916
#10 0x0000000000420c70 in cmd_restore (argc=3D<optimized out>, argv=3D<=
optimized=20
out>) at cmds-restore.c:1319
#11 0x00000000004042fd in main (argc=3D8, argv=3D0x7feffffa0) at btrfs.=
c:247


Hope that helps

Marc

--nextPart3608757.l4H6ftootx
Content-Disposition: attachment; filename="full-bt.txt"
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; name="full-bt.txt"

(gdb) bt full

#0  0x00000000057a10d2 in lzo1x_decompress_safe () from /usr/lib64/libl=
zo2.so.2
No symbol table info available.
#1  0x000000000041e9ee in decompress_lzo (decompress_len=3D0x7feff9f60,=
 compress_len=3D417,=20
    outbuf=3D0x63229a0 "ource/core/dom/webcore_dom.StaticNodeList.o", i=
nbuf=3D0x6280a6d "\017ource/core/dom/webl\001") at cmds-restore.c:129
        ret =3D <optimized out>
        new_len =3D 0
        out_len =3D 32768
        tot_in =3D 24429
#2  decompress (inbuf=3Dinbuf@entry=3D0x627ab00 "zU\001", outbuf=3Doutb=
uf@entry=3D0x631a9a0 "<X", compress_len=3Dcompress_len@entry=3D24576,=20=

    decompress_len=3Ddecompress_len@entry=3D0x7feff9f60, compress=3Dcom=
press@entry=3D2) at cmds-restore.c:155
No locals.
#3  0x000000000041f8a8 in copy_one_extent (pos=3D4063232, fi=3D<optimiz=
ed out>, leaf=3D0x5fb58d0, fd=3D4, root=3D0x61405c0) at cmds-restore.c:=
386
        device =3D <optimized out>
        dev_fd =3D 5
        mirror_num =3D 1
        num_copies =3D <optimized out>
        inbuf =3D 0x627ab00 "zU\001"
        done =3D <optimized out>
        ram_size =3D 126976
        multi =3D 0x67fa250
        outbuf =3D 0x631a9a0 "<X"
        total =3D 0
        dev_bytenr =3D 317671178240
        compress =3D 2
        length =3D 24576
        ret =3D <optimized out>
        bytenr =3D 390685646848
        size_left =3D 0
        count =3D 24576
#4  copy_file (file=3D0x66a700 <path_name> "/work/chromium/src/out/Rele=
ase/.ninja_deps", key=3D0x7feffb080, fd=3D4, root=3D0x61405c0)
    at cmds-restore.c:659
        fi =3D <optimized out>
        ret =3D <optimized out>
        compression =3D 2
        found_size =3D 11632652
        leaf =3D 0x5fb58d0
        path =3D <optimized out>
        inode_item =3D <optimized out>
        extent_type =3D <optimized out>
        loops =3D 33
#5  search_dir (root=3Droot@entry=3D0x61405c0, key=3Dkey@entry=3D0x7fef=
fc2d0, output_rootdir=3Doutput_rootdir@entry=3D0x7fefffdb0 "/work",=20
    in_dir=3Din_dir@entry=3D0x6602d70 "/chromium/src/out/Release", mreg=
=3Dmreg@entry=3D0x7fefffd60) at cmds-restore.c:840
        path =3D <optimized out>
        leaf =3D 0x6daaa50
        dir_item =3D <optimized out>
        location =3D {objectid =3D 27472733, type =3D 108 'l', offset =3D=
 0}
        filename =3D ".ninja_deps", '\000' <repeats 29 times>, "\021\00=
0\000\000\b\000\000\000\b\000\000\000\020\000\000\000\240r\367\005\000\=
000\000\000\001\000\000\000\000\000\000\000\300\005\024\006\000\000\000=
\000\360\225\023\006\000\000\000\000\360M\337\006\000\000\000\000\020w\=
367\005\000\000\000\000A0\314\005\000\000\000\000@-\024\006\000\000\000=
\000\030\000\000\000\060\000\000\000\340\260\377\376\a\000\000\000\---T=
ype <return> to continue, or q <return> to quit---
020\260\377\376\a", '\000' <repeats 20 times>, "\247f\000\000\000\000\0=
00src/out/Release\000\000T\367\005\000\000\000\000\230\260\377\376\a\00=
0\000\000"...
        name_ptr =3D <optimized out>
        name_len =3D <optimized out>
        ret =3D <optimized out>
        loops =3D 0
#6  0x000000000041ffe7 in search_dir (root=3Droot@entry=3D0x61405c0, ke=
y=3Dkey@entry=3D0x7feffd520,=20
    output_rootdir=3Doutput_rootdir@entry=3D0x7fefffdb0 "/work", in_dir=
=3Din_dir@entry=3D0x6df4d90 "/chromium/src/out",=20
    mreg=3Dmreg@entry=3D0x7fefffd60) at cmds-restore.c:916
        search_root =3D <optimized out>
        dir =3D 0x6602d70 "/chromium/src/out/Release"
        path =3D <optimized out>
        leaf =3D 0x61395f0
        dir_item =3D <optimized out>
        location =3D {objectid =3D 27470610, type =3D 96 '`', offset =3D=
 0}
        filename =3D "Release\000\000\267f", '\000' <repeats 29 times>,=
 "\r\000\000\000\004\000\000\000\004\000\000\000\020\000\000\000\240r\3=
67\005\000\000\000\000\001\000\000\000\000\000\000\000\300\005\024\006\=
000\000\000\000\020\017\a\006\000\000\000\000\200\234e\006\000\000\000\=
000\020w\367\005\000\000\000\000A0\314\005\000\000\000\000@-\024\006\00=
0\000\000\000\030\000\000\000\060\000\000\000\060\303\377\376\a\000\000=
\000`\302\377\376\a", '\000' <repeats 20 times>, "\247f\000\000\000\000=
\000hromium/src/out\000\000T\367\005\000\000\000\000\002\021\000\000\00=
0\000\000\000"...
        name_ptr =3D <optimized out>
        name_len =3D <optimized out>
        ret =3D <optimized out>
        loops =3D 0
#7  0x000000000041ffe7 in search_dir (root=3Droot@entry=3D0x61405c0, ke=
y=3Dkey@entry=3D0x7feffe770,=20
    output_rootdir=3Doutput_rootdir@entry=3D0x7fefffdb0 "/work", in_dir=
=3Din_dir@entry=3D0x65d7080 "/chromium/src", mreg=3Dmreg@entry=3D0x7fef=
ffd60)
    at cmds-restore.c:916
        search_root =3D <optimized out>
        dir =3D 0x6df4d90 "/chromium/src/out"
        path =3D <optimized out>
        leaf =3D 0x6070f10
        dir_item =3D <optimized out>
        location =3D {objectid =3D 27469314, type =3D 96 '`', offset =3D=
 0}
        filename =3D "out\000\000gnore\000settings", '\000' <repeats 21=
 times>, "\t\000\000\000\004\000\000\000\004\000\000\000\016\000\000\00=
0\240r\367\005\000\000\000\000\001\000\000\000\000\000\000\000\300\005\=
024\006\000\000\000\000\000\303\027\a\000\000\000\000\300\226:\006\000\=
000\000\000\020w\367\005\000\000\000\000A0\314\005\000\000\000\000@-\02=
4\006\000\000\000\000\030\000\000\000\060\000\000\000\200\325\377\376\a=
\000\000\000\260\324\377\376\a", '\000' <repeats 20 times>, "\247f\000\=
000\000\000\000ium/src\000\000\000\000\000\000\000\000\000\000T\367\005=
\000\000\000\000\002\021\000\000\000\000\000\000"...
        name_ptr =3D <optimized out>
        name_len =3D <optimized out>
        ret =3D <optimized out>
        loops =3D 0
#8  0x000000000041ffe7 in search_dir (root=3Droot@entry=3D0x61405c0, ke=
y=3Dkey@entry=3D0x7fefff9c0,=20
    output_rootdir=3Doutput_rootdir@entry=3D0x7fefffdb0 "/work", in_dir=
=3Din_dir@entry=3D0x6f35ac0 "/chromium", mreg=3Dmreg@entry=3D0x7fefffd6=
0)
    at cmds-restore.c:916
        search_root =3D <optimized out>
        dir =3D 0x65d7080 "/chromium/src"
        path =3D <optimized out>
        leaf =3D 0x717c300
---Type <return> to continue, or q <return> to quit---
        dir_item =3D <optimized out>
        location =3D {objectid =3D 26833838, type =3D 96 '`', offset =3D=
 0}
        filename =3D "src\000ient\000ls", '\000' <repeats 33 times>, "\=
t\000\000\000\t\000\000\000\n\000\000\000\240r\367\005\000\000\000\000\=
001\000\000\000\000\000\000\000\300\005\024\006\000\000\000\000\340=C8=93=
\006\000\000\000\000\240N\024\006\000\000\000\000\020w\367\005\000\000\=
000\000A0\314\005\000\000\000\000@-\024\006\000\000\000\000\030\000\000=
\000\060\000\000\000\320\347\377\376\a\000\000\000\000\347\377\376\a", =
'\000' <repeats 20 times>, "\247f\000\000\000\000\000hromium\000\000\00=
0\000\000\000\000\000\000\000T\367\005\000\000\000\000\260\060\375\005\=
000\000\000\000@"...
        name_ptr =3D <optimized out>
        name_len =3D <optimized out>
        ret =3D <optimized out>
        loops =3D 0
#9  0x000000000041ffe7 in search_dir (root=3Droot@entry=3D0x61405c0, ke=
y=3Dkey@entry=3D0x7fefffe30,=20
    output_rootdir=3Doutput_rootdir@entry=3D0x7fefffdb0 "/work", in_dir=
=3Din_dir@entry=3D0x45ab43 "", mreg=3Dmreg@entry=3D0x7fefffd60)
    at cmds-restore.c:916
        search_root =3D <optimized out>
        dir =3D 0x6f35ac0 "/chromium"
        path =3D <optimized out>
        leaf =3D 0x693c8e0
        dir_item =3D <optimized out>
        location =3D {objectid =3D 26832818, type =3D 96 '`', offset =3D=
 0}
        filename =3D "chromium\000.6.5\000\000\000r_2012_r2_x64_dvd_270=
7952.iso\000ER_EVAL_DE-DE-IRM_SSS_X64FREE_DE-DE_DV5.ISO\000\000ISO\000\=
000\002\000\000\000\002\000\000\000\260E\024\006\000\000\000\000\317\00=
3\000\377\a\000\000\000\317\003\000\377\a", '\000' <repeats 31 times>, =
"\021\000\000\000\021\000\000\000\021\000\000\000\020\000\000\000\020\0=
00\000\000\020\000\000\000\020\000\000\000\020", '\000' <repeats 15 tim=
es>...
        name_ptr =3D <optimized out>
        name_len =3D <optimized out>
        ret =3D <optimized out>
        loops =3D 0
#10 0x0000000000420c70 in cmd_restore (argc=3D<optimized out>, argv=3D<=
optimized out>) at cmds-restore.c:1319
        root =3D 0x61405c0
        key =3D {objectid =3D 256, type =3D 96 '`', offset =3D 0}
        dir_name =3D "/work", '\000' <repeats 122 times>
        tree_location =3D <optimized out>
        fs_location =3D 0
        root_objectid =3D 0
        len =3D <optimized out>
        ret =3D <optimized out>
        opt =3D <optimized out>
        option_index =3D 0
        super_mirror =3D <optimized out>
        find_dir =3D 0
        list_roots =3D 0
        match_regstr =3D 0x7ff0003cf "^/(|temp(|/.*))$"
        match_cflags =3D 13
        match_reg =3D {buffer =3D 0x6142d40 "`.\024\006", allocated =3D=
 224, used =3D 224, syntax =3D 242620, fastmap =3D 0x6142c00 "",=20
          translate =3D 0x0, re_nsub =3D 2, can_be_null =3D 0, regs_all=
ocated =3D 0, fastmap_accurate =3D 1, no_sub =3D 1, not_bol =3D 0, not_=
eol =3D 0,=20
          newline_anchor =3D 1}
        mreg =3D 0x7fefffd60
        reg_err =3D "\377\232f", '\000' <repeats 45 times>, "\370\375\3=
77\376\004\000\000\000H\021\"\004", '\000' <repeats 28 times>, "@\277\0=
---Type <return> to continue, or q <return> to quit---
05\004\000\000\000\000\377\377\377\377\377\377\377\377\000\000\000\000\=
000\000\000\000\001\000\000\000\000\000\000\000H\021\"\004\000\000\000\=
000\377\377\377\377\a\000\000\000\000\375\377\376\a\000\000\000\314?\f\=
257\000\000\000\000\000T\367\005", '\000' <repeats 12 times>, "\240\024=
\"\004\000\000\000\000@\375\377\376\a\000\000\000\060\375\377\376\a\000=
\000\000L\353:}\000\000\000\000"...
#11 0x00000000004042fd in main (argc=3D8, argv=3D0x7feffffa0) at btrfs.=
c:247
        cmd =3D 0x6689c8
        bname =3D <optimized out>

--nextPart3608757.l4H6ftootx--

