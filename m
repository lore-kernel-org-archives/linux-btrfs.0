From: Jan Schubert <Jan.Schubert@GMX.li>
Subject: Re: btrfs-progs integration branch updated
Date: Fri, 5 Aug 2011 20:47:22 +0000 (UTC)
Message-ID: <loom.20110805T224533-845@post.gmane.org>
References: <20110804224334.GD8970@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills <hugo <at> carfax.org.uk> writes:
>    It includes the latest scrub patches, the compile fixes for gcc
> 4.6, and a selection of other, smaller features. Go forth and play.
>=20

Thx Hugo, I hit this error while trying to compile:

# make dir-test
ls dir-test.c
dir-test.c
gcc -Wp,-MMD,./.dir-test.o.d,-MT,dir-test.o -Wall -D_FILE_OFFSET_BITS=3D=
64 -
D_FORTIFY_SOURCE=3D2 -g -Werror -Os -c dir-test.c
dir-test.c: In function =C3=A2initial_inode_init=C3=A2:
dir-test.c:66:2: error: passing argument 1 of =C3=A2btrfs_set_inode_gen=
eration=C3=A2 from=20
incompatible pointer type [-Werror]
ctree.h:1064:1: note: expected =C3=A2struct extent_buffer *=C3=A2 but a=
rgument is of type=20
=C3=A2struct btrfs_inode_item *=C3=A2
dir-test.c:66:2: error: passing argument 2 of =C3=A2btrfs_set_inode_gen=
eration=C3=A2 makes=20
pointer from integer without a cast [-Werror]
ctree.h:1064:1: note: expected =C3=A2struct btrfs_inode_item *=C3=A2 bu=
t argument is of=20
type =C3=A2u64=C3=A2
dir-test.c:66:2: error: too few arguments to function=20
=C3=A2btrfs_set_inode_generation=C3=A2
ctree.h:1064:1: note: declared here
dir-test.c:67:2: error: passing argument 1 of =C3=A2btrfs_set_inode_mod=
e=C3=A2 from=20
incompatible pointer type [-Werror]
ctree.h:1073:1: note: expected =C3=A2struct extent_buffer *=C3=A2 but a=
rgument is of type=20
=C3=A2struct btrfs_inode_item *=C3=A2
dir-test.c:67:2: error: passing argument 2 of =C3=A2btrfs_set_inode_mod=
e=C3=A2 makes=20
pointer from integer without a cast [-Werror]
ctree.h:1073:1: note: expected =C3=A2struct btrfs_inode_item *=C3=A2 bu=
t argument is of=20
type =C3=A2int=C3=A2
dir-test.c:67:2: error: too few arguments to function =C3=A2btrfs_set_i=
node_mode=C3=A2
ctree.h:1073:1: note: declared here
dir-test.c: In function =C3=A2ins_one=C3=A2:
dir-test.c:89:11: error: =C3=A2struct btrfs_key=C3=A2 has no member nam=
ed =C3=A2flags=C3=A2
dir-test.c:98:9: error: too few arguments to function =C3=A2btrfs_inser=
t_dir_item=C3=A2
ctree.h:1832:5: note: declared here
dir-test.c:117:6: error: assignment makes integer from pointer without =
a cast [-
Werror]
dir-test.c:128:8: error: =C3=A2struct extent_buffer=C3=A2 has no member=
 named =C3=A2leaf=C3=A2
dir-test.c:128:8: error: =C3=A2struct extent_buffer=C3=A2 has no member=
 named =C3=A2leaf=C3=A2
dir-test.c:131:3: error: passing argument 1 of =C3=A2btrfs_dir_name_len=
=C3=A2 from=20
incompatible pointer type [-Werror]
ctree.h:1346:1: note: expected =C3=A2struct extent_buffer *=C3=A2 but a=
rgument is of type=20
=C3=A2struct btrfs_dir_item *=C3=A2
dir-test.c:131:3: error: too few arguments to function =C3=A2btrfs_dir_=
name_len=C3=A2
ctree.h:1346:1: note: declared here
dir-test.c: In function =C3=A2insert_dup=C3=A2:
dir-test.c:160:5: error: =C3=A2struct btrfs_key=C3=A2 has no member nam=
ed =C3=A2flags=C3=A2
dir-test.c:164:9: error: too few arguments to function =C3=A2btrfs_inse=
rt_dir_item=C3=A2
ctree.h:1832:5: note: declared here
dir-test.c: In function =C3=A2del_dir_item=C3=A2:
dir-test.c:184:7: error: =C3=A2struct extent_buffer=C3=A2 has no member=
 named =C3=A2leaf=C3=A2
dir-test.c:184:7: error: =C3=A2struct extent_buffer=C3=A2 has no member=
 named =C3=A2leaf=C3=A2
dir-test.c:196:2: error: passing argument 4 of =C3=A2btrfs_lookup_inode=
=C3=A2 makes=20
pointer from integer without a cast [-Werror]
ctree.h:1883:5: note: expected =C3=A2struct btrfs_key *=C3=A2 but argum=
ent is of type=20
=C3=A2u64=C3=A2
dir-test.c:204:19: error: =C3=A2struct btrfs_fs_info=C3=A2 has no membe=
r named=20
=C3=A2last_inode_alloc=C3=A2
dir-test.c:205:16: error: =C3=A2struct btrfs_fs_info=C3=A2 has no membe=
r named=20
=C3=A2last_inode_alloc=C3=A2
dir-test.c: In function =C3=A2del_one=C3=A2:
dir-test.c:232:6: error: assignment makes integer from pointer without =
a cast [-
Werror]
dir-test.c: In function =C3=A2lookup_item=C3=A2:
dir-test.c:262:6: error: assignment makes integer from pointer without =
a cast [-
Werror]
dir-test.c:265:8: error: =C3=A2struct extent_buffer=C3=A2 has no member=
 named =C3=A2leaf=C3=A2
dir-test.c:265:8: error: =C3=A2struct extent_buffer=C3=A2 has no member=
 named =C3=A2leaf=C3=A2
dir-test.c:254:6: error: variable =C3=A2objectid=C3=A2 set but not used=
 [-Werror=3Dunused-
but-set-variable]
dir-test.c: In function =C3=A2lookup_enoent=C3=A2:
dir-test.c:290:6: error: assignment makes integer from pointer without =
a cast [-
Werror]
dir-test.c: In function =C3=A2empty_tree=C3=A2:
dir-test.c:314:5: error: =C3=A2struct btrfs_key=C3=A2 has no member nam=
ed =C3=A2flags=C3=A2
dir-test.c:332:8: error: =C3=A2struct extent_buffer=C3=A2 has no member=
 named =C3=A2leaf=C3=A2
dir-test.c:332:8: error: =C3=A2struct extent_buffer=C3=A2 has no member=
 named =C3=A2leaf=C3=A2
dir-test.c:334:3: error: passing argument 1 of =C3=A2btrfs_dir_name_len=
=C3=A2 from=20
incompatible pointer type [-Werror]
ctree.h:1346:1: note: expected =C3=A2struct extent_buffer *=C3=A2 but a=
rgument is of type=20
=C3=A2struct btrfs_dir_item *=C3=A2
dir-test.c:334:3: error: too few arguments to function =C3=A2btrfs_dir_=
name_len=C3=A2
ctree.h:1346:1: note: declared here
dir-test.c: In function =C3=A2fill_tree=C3=A2:
dir-test.c:367:4: error: too many arguments to function=20
=C3=A2btrfs_commit_transaction=C3=A2
disk-io.h:71:5: note: declared here
dir-test.c: In function =C3=A2main=C3=A2:
dir-test.c:438:2: error: passing argument 2 of =C3=A2open_ctree=C3=A2 m=
akes integer from=20
pointer without a cast [-Werror]
disk-io.h:46:20: note: expected =C3=A2u64=C3=A2 but argument is of type=
 =C3=A2struct=20
btrfs_super_block *=C3=A2
dir-test.c:478:35: error: =C3=A2struct extent_buffer=C3=A2 has no membe=
r named =C3=A2node=C3=A2
dir-test.c:479:37: error: =C3=A2struct extent_buffer=C3=A2 has no membe=
r named =C3=A2node=C3=A2
dir-test.c:480:4: error: too many arguments to function =C3=A2close_ctr=
ee=C3=A2
disk-io.h:49:5: note: declared here
dir-test.c:481:4: error: passing argument 2 of =C3=A2open_ctree=C3=A2 m=
akes integer from=20
pointer without a cast [-Werror]
disk-io.h:46:20: note: expected =C3=A2u64=C3=A2 but argument is of type=
 =C3=A2struct=20
btrfs_super_block *=C3=A2
dir-test.c:503:2: error: too many arguments to function =C3=A2close_ctr=
ee=C3=A2
disk-io.h:49:5: note: declared here
cc1: all warnings being treated as errors

make: *** [dir-test.o] Error 1


# gcc -v
Using built-in specs.
COLLECT_GCC=3Dgcc
COLLECT_LTO_WRAPPER=3D/usr/lib/gcc/x86_64-unknown-linux-gnu/4.6.1/lto-w=
rapper
Target: x86_64-unknown-linux-gnu
Configured with: /build/src/gcc-4.6.1/configure --prefix=3D/usr --libdi=
r=3D/usr/lib=20
--libexecdir=3D/usr/lib --mandir=3D/usr/share/man --infodir=3D/usr/shar=
e/info --with-
bugurl=3Dhttps://bugs.archlinux.org/ --enable-
languages=3Dc,c++,ada,fortran,go,lto,objc,obj-c++ --enable-shared --ena=
ble-
threads=3Dposix --with-system-zlib --enable-__cxa_atexit --disable-libu=
nwind-
exceptions --enable-clocale=3Dgnu --enable-gnu-unique-object --enable-l=
inker-
build-id --with-ppl --enable-cloog-backend=3Disl --enable-lto --enable-=
gold --
enable-ld=3Ddefault --enable-plugin --with-plugin-ld=3Dld.gold --enable=
-multilib --
disable-libstdcxx-pch --enable-checking=3Drelease
Thread model: posix
gcc version 4.6.1 (GCC)=20






--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
