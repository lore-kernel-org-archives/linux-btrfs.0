From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: btrfs-convert crashes
Date: Wed, 27 Apr 2011 20:05:49 +0800
Message-ID: <BANLkTimA-8YAvAFS257tG-j=Mf1vR-N5ig@mail.gmail.com>
References: <4DB7A796.90800@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Brian Parma <freecode@cox.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DB7A796.90800@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 27, 2011 at 1:20 PM, Brian Parma <freecode@cox.net> wrote:
> I have a 1.5 TB (1,475,720,773,632) partition that I wanted to conver=
t from
> ext4 to btrfs. =C2=A0It is currently used as / for ubuntu 10.10.
>
> I booted into 11.04 beta2 and tried a 'btrfs-convert /dev/sdc1', but =
after
> about 20 minutes it segfaulted.
>
> I performed a:
>
> sck.ext4 -cDfty -C 0 /dev/sdc1
>
>
> After everything was clean, I downloaded the debugging symbols for
> btrfs-convert and tried again. =C2=A0Below is the 'bt full' output. =C2=
=A0I don't have
> enough free space to copy all the data off, create a fresh btrfs part=
ition,
> and copy everything back on (I have backups of important stuff). =C2=A0=
Is there
> something else I can try to get this to work?
>
> Brian
>

The crash was caused by the hard links per directory limit in btrfs.
In short, your ext4 is not convertible.

> at: http://pastebin.com/NEwJNzuP
>
>
> #0 =C2=A00x00007ffff7444d05 in raise () from /lib/x86_64-linux-gnu/li=
bc.so.6
> No symbol table info available.
> #1 =C2=A00x00007ffff7448ab6 in abort () from /lib/x86_64-linux-gnu/li=
bc.so.6
> No symbol table info available.
> #2 =C2=A00x000000000040502c in btrfs_extend_item (trans=3D<value opti=
mized out>,
> root=3D0x633920, path=3D<value optimized out>, data_size=3D27) at ctr=
ee.c:2525
> =C2=A0 =C2=A0 =C2=A0 =C2=A0slot =3D<value optimized out>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0slot_orig =3D<value optimized out>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0leaf =3D 0x1955250
> =C2=A0 =C2=A0 =C2=A0 =C2=A0nritems =3D 1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0data_end =3D<value optimized out>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0old_data =3D<value optimized out>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0i =3D<value optimized out>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0__PRETTY_FUNCTION__ =3D "btrfs_extend_item=
"
> #3 =C2=A00x000000000040e32d in btrfs_insert_inode_ref (trans=3D0xc9ef=
10,
> root=3D0x633920, name=3D0xcfa314 "gtfntf.f.svn-base", name_len=3D17,
> =C2=A0 =C2=A0inode_objectid=3D<value optimized out>, ref_objectid=3D<=
value optimized out>,
> index=3D150) at inode-item.c:135
> =C2=A0 =C2=A0 =C2=A0 =C2=A0old_size =3D 3945
> =C2=A0 =C2=A0 =C2=A0 =C2=A0path =3D 0x1639aa0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0key =3D {objectid =3D 37361107, type =3D 1=
2 'f', offset =3D 37359706}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ref =3D<value optimized out>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ptr =3D<value optimized out>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D<value optimized out>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ins_len =3D 27
> =C2=A0 =C2=A0 =C2=A0 =C2=A0__PRETTY_FUNCTION__ =3D "btrfs_insert_inod=
e_ref"
> #4 =C2=A00x0000000000413fff in dir_iterate_proc (dir=3D<value optimiz=
ed out>,
> entry=3D<value optimized out>, old=3D0xcfa30c, offset=3D<value optimi=
zed out>,
> =C2=A0 =C2=A0blocksize=3D<value optimized out>, buf=3D<value optimize=
d out>,
> priv_data=3D0x7fffffffe370) at convert.c:289
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D<value optimized out>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0file_type =3D<value optimized out>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0objectid =3D 37361107
> =C2=A0 =C2=A0 =C2=A0 =C2=A0dotdot =3D ".."
> =C2=A0 =C2=A0 =C2=A0 =C2=A0location =3D {objectid =3D 37361107, type =
=3D 1 '=01', offset =3D 0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0dirent =3D 0xcfa30c
> =C2=A0 =C2=A0 =C2=A0 =C2=A0idata =3D 0x7fffffffe370
> =C2=A0 =C2=A0 =C2=A0 =C2=A0__PRETTY_FUNCTION__ =3D "dir_iterate_proc"
> #5 =C2=A00x00007ffff7bbdc13 in ext2fs_process_dir_block () from
> /lib/x86_64-linux-gnu/libext2fs.so.2
> No symbol table info available.
> #6 =C2=A00x00007ffff7bbac02 in ext2fs_block_iterate2 () from
> /lib/x86_64-linux-gnu/libext2fs.so.2
> No symbol table info available.
> #7 =C2=A00x00007ffff7bbdfb8 in ext2fs_dir_iterate2 () from
> /lib/x86_64-linux-gnu/libext2fs.so.2
> No symbol table info available.
> #8 =C2=A00x000000000041689d in create_dir_entries (devname=3D0x7fffff=
ffe897
> "/dev/sdc1", datacsum=3D1, packing=3D1, noxattr=3D0) at convert.c:322
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D<value optimized out>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0data =3D {trans =3D 0xc9ef10, root =3D 0x6=
33920, inode =3D 0x7fffffffe1c0,
> objectid =3D 37359706, index_cnt =3D 150, parent =3D 37359705, errcod=
e =3D 0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D<value optimized out>
> #9 =C2=A0copy_single_inode (devname=3D0x7fffffffe897 "/dev/sdc1", dat=
acsum=3D1,
> packing=3D1, noxattr=3D0) at convert.c:1072
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D<value optimized out>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs_inode =3D {generation =3D 1, transid=
 =3D 140737354044640, size =3D
> 4994, nbytes =3D 0, block_group =3D 0, nlink =3D 1, uid =3D 1000, gid=
 =3D 1000, mode =3D
> 16877,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rdev =3D 0, flags =3D 0, sequence =3D=
 140737351933932, reserved =3D {0,
> 140737354040256, 140733193388033, 0}, atime =3D {sec =3D 1303466526, =
nsec =3D 0},
> ctime =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sec =3D 1296464377, nsec =3D=
 0}, mtime =3D {sec =3D 1296464377, nsec =3D
> 0}, otime =3D {sec =3D 0, nsec =3D 0}}
> #10 copy_inodes (devname=3D0x7fffffffe897 "/dev/sdc1", datacsum=3D1, =
packing=3D1,
> noxattr=3D0) at convert.c:1154
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D<value optimized out>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D<value optimized out>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ext2_scan =3D 0xce2300
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ext2_ino =3D 37359452
> =C2=A0 =C2=A0 =C2=A0 =C2=A0objectid =3D 37359706
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ext2_inode =3D {i_mode =3D 16877, i_uid =3D=
 1000, i_size =3D 16384, i_atime =3D
> 1303466526, i_ctime =3D 1296464377, i_mtime =3D 1296464377, i_dtime =3D=
 0, i_gid =3D
> 1000,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0i_links_count =3D 2, i_blocks =3D 3=
2, i_flags =3D 528384, osd1 =3D {linux1
> =3D {l_i_version =3D 1981}, hurd1 =3D {h_i_translator =3D 1981}}, i_b=
lock =3D {193290,
> 4, 0,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00, 1, 149430439, 1, 3, 14943=
0464, 0, 0, 0, 0, 0, 0}, i_generation
> =3D 2854948622, i_file_acl =3D 0, i_dir_acl =3D 0, i_faddr =3D 0, osd=
2 =3D {linux2 =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0l_i_blocks_hi =3D 0, =
l_i_file_acl_high =3D 0, l_i_uid_high =3D 0,
> l_i_gid_high =3D 0, l_i_reserved2 =3D 0}, hurd2 =3D {h_i_frag =3D 0 '=
=EF=BF=BD',
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0h_i_fsize =3D 0 '=EF=BF=
=BD', h_i_mode_high =3D 0, h_i_uid_high =3D 0,
> h_i_gid_high =3D 0, h_i_author =3D 0}}}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0trans =3D 0xc9ef10
> #11 do_convert (devname=3D0x7fffffffe897 "/dev/sdc1", datacsum=3D1, p=
acking=3D1,
> noxattr=3D0) at convert.c:2411
> =C2=A0 =C2=A0 =C2=A0 =C2=A0i =3D<value optimized out>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0fd =3D 6
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D<value optimized out>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0blocksize =3D 4096
> =C2=A0 =C2=A0 =C2=A0 =C2=A0blocks =3D {9258, 9259, 9260, 9261, 9284, =
9285, 9286}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0total_bytes =3D<value optimized out>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0super_bytenr =3D 37920768
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ext2_fs =3D 0x622010
> =C2=A0 =C2=A0 =C2=A0 =C2=A0root =3D 0x633920
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ext2_root =3D<value optimized out>
> #12 0x0000000000418333 in main (argc=3D<value optimized out>, argv=3D=
<value
> optimized out>) at convert.c:2867
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D<value optimized out>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0packing =3D 1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0noxattr =3D 0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0datacsum =3D 1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0rollback =3D 0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0file =3D 0x7fffffffe897 "/dev/sdc1"
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
