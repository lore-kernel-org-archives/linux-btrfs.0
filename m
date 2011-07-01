From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: btrfs-progs: integration branch updated
Date: Sat, 02 Jul 2011 01:03:23 +0200
Message-ID: <4E0E523B.9060705@gmail.com>
References: <20110630211902.GC4352@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>,
	Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110630211902.GC4352@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
On 30.06.2011 23:19, Hugo Mills wrote:
> After a reorganisation of patches, and sending a bunch of them to
> Chris, I've also updated the integration branch to match that. It's
> available from:
>
> http://git.darksatanic.net/repo/btrfs-progs-unstable.git/ integration-20110630
>
> The shortlog of 17 patches in this branch beyond the ones I've sent
> to Chris is below.
>
When trying to build 'dir-test' I encountered a lot of build errors; see below.

Cheers,
Andreas

ls ctree.c
ctree.c
gcc -Wp,-MMD,./.ctree.o.d,-MT,ctree.o -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -g -Werror -Os -c ctree.c
ls disk-io.c
disk-io.c
gcc -Wp,-MMD,./.disk-io.o.d,-MT,disk-io.o -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -g -Werror -Os -c disk-io.c
ls radix-tree.c
radix-tree.c
gcc -Wp,-MMD,./.radix-tree.o.d,-MT,radix-tree.o -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -g -Werror -Os -c radix-tree.c
ls extent-tree.c
extent-tree.c
gcc -Wp,-MMD,./.extent-tree.o.d,-MT,extent-tree.o -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -g -Werror -Os -c extent-tree.c
ls print-tree.c
print-tree.c
gcc -Wp,-MMD,./.print-tree.o.d,-MT,print-tree.o -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -g -Werror -Os -c print-tree.c
ls root-tree.c
root-tree.c
gcc -Wp,-MMD,./.root-tree.o.d,-MT,root-tree.o -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -g -Werror -Os -c root-tree.c
ls dir-item.c
dir-item.c
gcc -Wp,-MMD,./.dir-item.o.d,-MT,dir-item.o -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -g -Werror -Os -c dir-item.c
ls file-item.c
file-item.c
gcc -Wp,-MMD,./.file-item.o.d,-MT,file-item.o -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -g -Werror -Os -c file-item.c
ls inode-item.c
inode-item.c
gcc -Wp,-MMD,./.inode-item.o.d,-MT,inode-item.o -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -g -Werror -Os -c inode-item.c
ls inode-map.c
inode-map.c
gcc -Wp,-MMD,./.inode-map.o.d,-MT,inode-map.o -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -g -Werror -Os -c inode-map.c
ls crc32c.c
crc32c.c
gcc -Wp,-MMD,./.crc32c.o.d,-MT,crc32c.o -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -g -Werror -Os -c crc32c.c
ls rbtree.c
rbtree.c
gcc -Wp,-MMD,./.rbtree.o.d,-MT,rbtree.o -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -g -Werror -Os -c rbtree.c
ls extent-cache.c
extent-cache.c
gcc -Wp,-MMD,./.extent-cache.o.d,-MT,extent-cache.o -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -g -Werror -Os -c extent-cache.c
ls extent_io.c
extent_io.c
gcc -Wp,-MMD,./.extent_io.o.d,-MT,extent_io.o -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -g -Werror -Os -c extent_io.c
ls volumes.c
volumes.c
gcc -Wp,-MMD,./.volumes.o.d,-MT,volumes.o -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -g -Werror -Os -c volumes.c
ls utils.c
utils.c
gcc -Wp,-MMD,./.utils.o.d,-MT,utils.o -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -g -Werror -Os -c utils.c
bash version.sh
ls btrfs-list.c
btrfs-list.c
gcc -Wp,-MMD,./.btrfs-list.o.d,-MT,btrfs-list.o -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -g -Werror -Os -c btrfs-list.c
ls btrfslabel.c
btrfslabel.c
gcc -Wp,-MMD,./.btrfslabel.o.d,-MT,btrfslabel.o -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -g -Werror -Os -c btrfslabel.c
ls dir-test.c
dir-test.c
gcc -Wp,-MMD,./.dir-test.o.d,-MT,dir-test.o -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -g -Werror -Os -c dir-test.c
cc1: warnings being treated as errors
dir-test.c: In function ?initial_inode_init?:
dir-test.c:66: error: passing argument 1 of ?btrfs_set_inode_generation? from incompatible pointer type
ctree.h:1064: note: expected ?struct extent_buffer *? but argument is of type ?struct btrfs_inode_item *?
dir-test.c:66: error: passing argument 2 of ?btrfs_set_inode_generation? makes pointer from integer without a cast
ctree.h:1064: note: expected ?struct btrfs_inode_item *? but argument is of type ?u64?
dir-test.c:66: error: too few arguments to function ?btrfs_set_inode_generation?
dir-test.c:67: error: passing argument 1 of ?btrfs_set_inode_mode? from incompatible pointer type
ctree.h:1073: note: expected ?struct extent_buffer *? but argument is of type ?struct btrfs_inode_item *?
dir-test.c:67: error: passing argument 2 of ?btrfs_set_inode_mode? makes pointer from integer without a cast
ctree.h:1073: note: expected ?struct btrfs_inode_item *? but argument is of type ?int?
dir-test.c:67: error: too few arguments to function ?btrfs_set_inode_mode?
dir-test.c: In function ?ins_one?:
dir-test.c:89: error: ?struct btrfs_key? has no member named ?flags?
dir-test.c:98: error: too few arguments to function ?btrfs_insert_dir_item?
dir-test.c:118: error: assignment makes integer from pointer without a cast
dir-test.c:128: error: ?struct extent_buffer? has no member named ?leaf?
dir-test.c:128: error: ?struct extent_buffer? has no member named ?leaf?
dir-test.c:131: error: passing argument 1 of ?btrfs_dir_name_len? from incompatible pointer type
ctree.h:1346: note: expected ?struct extent_buffer *? but argument is of type ?struct btrfs_dir_item *?
dir-test.c:131: error: too few arguments to function ?btrfs_dir_name_len?
dir-test.c: In function ?insert_dup?:
dir-test.c:160: error: ?struct btrfs_key? has no member named ?flags?
dir-test.c:164: error: too few arguments to function ?btrfs_insert_dir_item?
dir-test.c: In function ?del_dir_item?:
dir-test.c:184: error: ?struct extent_buffer? has no member named ?leaf?
dir-test.c:184: error: ?struct extent_buffer? has no member named ?leaf?
dir-test.c:196: error: passing argument 4 of ?btrfs_lookup_inode? makes pointer from integer without a cast
ctree.h:1883: note: expected ?struct btrfs_key *? but argument is of type ?u64?
dir-test.c:204: error: ?struct btrfs_fs_info? has no member named ?last_inode_alloc?
dir-test.c:205: error: ?struct btrfs_fs_info? has no member named ?last_inode_alloc?
dir-test.c: In function ?del_one?:
dir-test.c:233: error: assignment makes integer from pointer without a cast
dir-test.c: In function ?lookup_item?:
dir-test.c:263: error: assignment makes integer from pointer without a cast
dir-test.c:265: error: ?struct extent_buffer? has no member named ?leaf?
dir-test.c:265: error: ?struct extent_buffer? has no member named ?leaf?
dir-test.c: In function ?lookup_enoent?:
dir-test.c:291: error: assignment makes integer from pointer without a cast
dir-test.c: In function ?empty_tree?:
dir-test.c:314: error: ?struct btrfs_key? has no member named ?flags?
dir-test.c:332: error: ?struct extent_buffer? has no member named ?leaf?
dir-test.c:332: error: ?struct extent_buffer? has no member named ?leaf?
dir-test.c:334: error: passing argument 1 of ?btrfs_dir_name_len? from incompatible pointer type
ctree.h:1346: note: expected ?struct extent_buffer *? but argument is of type ?struct btrfs_dir_item *?
dir-test.c:334: error: too few arguments to function ?btrfs_dir_name_len?
dir-test.c: In function ?fill_tree?:
dir-test.c:367: error: too many arguments to function ?btrfs_commit_transaction?
dir-test.c: In function ?main?:
dir-test.c:438: error: passing argument 2 of ?open_ctree? makes integer from pointer without a cast
disk-io.h:46: note: expected ?u64? but argument is of type ?struct btrfs_super_block *?
dir-test.c:478: error: ?struct extent_buffer? has no member named ?node?
dir-test.c:479: error: ?struct extent_buffer? has no member named ?node?
dir-test.c:480: error: too many arguments to function ?close_ctree?
dir-test.c:481: error: passing argument 2 of ?open_ctree? makes integer from pointer without a cast
disk-io.h:46: note: expected ?u64? but argument is of type ?struct btrfs_super_block *?
dir-test.c:503: error: too many arguments to function ?close_ctree?
make: *** [dir-test.o] Error 1

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJODlI6AAoJEJIcBJ3+XkgizoIP/iareA/1U72sv0ETzDoJ8HZz
MdX0nJjx7grYr76RnmKPpnu3w49IjS62PuXrzYmW48Y4UocevWdnszJZv+pPRib1
JH1F+gvMA+qmgePcjIXbAG827Gbvz4nNt1admgJFFVWoqDWkuH1guQ1WhVIEnaXg
sTuqECvFnj/15Bwkg5uAWQ+/HX8sZ52e5TIztaKjtRSBltUBvNfZwPmIsIQ2P+jL
xwilRlAx5jezf36ezYldej/oLskboZDsDIGzwFKt9lbqWKD5m93MHTSYatjX4Jfl
Nlq7KEwg23DqUoEM6+7Odh5NyP1C1XiT8pbLL/VswoPnsRoebKTq0C/8A5FR0CMQ
xKPuhwQjzO7kaJUdnUUdxgHcY1Ne+z5CB6306eCeSnup/hq+TKMjPgpiYVkcMAET
7jfCrCbrtt6caPOo6R2Y58Gf8lbXrnljU/fnq04Cg38ufY5X7qUMO62MRYAvm8cI
LY2s0UOHGCkr4XCkU9zx229CYXXQ2yUnUaMI/pQNUnHQ1U2X5cP0fYkFVuexF9UX
TboC8+V3YdzNh5nDRBsPzLSlC+di5i/E0bBd/IiCOSvY6OEO7aflTVM9zC1NiylO
/IL0cK/BHiMfs7uDaJyjR5Uf9u7L9RMP3ocnIKkipoSjKmGyixz5yS9sdk9AY3P2
BMqheNbNxN09OSXy7SCl
=Drl6
-----END PGP SIGNATURE-----

