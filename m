From: David Sterba <dave@jikos.cz>
Subject: WARNING: at fs/dcache.c:1256 d_set_d_op+0xaa/0xc0() , nested snapshots
Date: Mon, 3 Oct 2011 18:17:43 +0200
Message-ID: <20111003161743.GM22205@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the $subj warning just appeared in the log after snapshotting a
subvolume with a snaphost inside. Reproducer:

#!/bin/sh

subv=subv$RANDOM
mnt=/mnt/sdb

btrfs subvol create $mnt/$subv
btrfs subvol snap $mnt/$subv $mnt/$subv/snap1
btrfs subvol snap $mnt/$subv $mnt/$subv/snap2
btrfs subvol snap $mnt/$subv/snap2 $mnt/$subv/snap3

find $mnt/$subv

mkdir $mnt/$subv/snap2/snap1/error-dir
touch $mnt/$subv/snap2/snap1/error-file

stat $mnt/$subv/snap2/snap*
stat $mnt/$subv/snap3/snap*

for i in $mnt/$subv/snap* $mnt/$subv; do
        btrfs subvol delete $i
done
<<EOF>>


warning details:

[   69.218718] ------------[ cut here ]------------
[   69.224557] WARNING: at fs/dcache.c:1252 d_set_d_op+0x87/0xc0()
[   69.232186] Hardware name: Santa Rosa platform
[   69.232189] Modules linked in: btrfs aoe
[   69.232198] Pid: 2887, comm: mkdir Not tainted 3.1.0-rc8-default+ #41
[   69.232202] Call Trace:
[   69.232211]  [<ffffffff810980bf>] warn_slowpath_common+0x7f/0xc0
[   69.232217]  [<ffffffff8109811a>] warn_slowpath_null+0x1a/0x20
[   69.232223]  [<ffffffff81199cc7>] d_set_d_op+0x87/0xc0
[   69.232230]  [<ffffffff811a9aef>] simple_lookup+0x3f/0x60
[   69.232235]  [<ffffffff8118eff5>] d_alloc_and_lookup+0x45/0x90
[   69.232241]  [<ffffffff8119ce05>] ? d_lookup+0x35/0x60
[   69.232246]  [<ffffffff811900b8>] __lookup_hash+0xa8/0xf0
[   69.232251]  [<ffffffff81190119>] lookup_hash+0x19/0x20
[   69.232257]  [<ffffffff811930e2>] kern_path_create+0x92/0x140
[   69.232264]  [<ffffffff8139dde6>] ? strncpy_from_user+0x36/0x50
[   69.232269]  [<ffffffff8118f3ac>] ? getname_flags+0x6c/0x210
[   69.232274]  [<ffffffff811931dd>] user_path_create+0x4d/0x80
[   69.232279]  [<ffffffff81194211>] sys_mkdirat+0x31/0xe0
[   69.232284]  [<ffffffff811942d8>] sys_mkdir+0x18/0x20
[   69.232292]  [<ffffffff81be8b42>] system_call_fastpath+0x16/0x1b
[   69.232296] ---[ end trace 6ff19356b0390d0a ]---
[   69.232299] ------------[ cut here ]------------
[   69.232304] WARNING: at fs/dcache.c:1256 d_set_d_op+0xaa/0xc0()
[   69.232307] Hardware name: Santa Rosa platform
[   69.232309] Modules linked in: btrfs aoe
[   69.232316] Pid: 2887, comm: mkdir Tainted: G        W 3.1.0-rc8-default+ #41
[   69.232319] Call Trace:
[   69.232325]  [<ffffffff810980bf>] warn_slowpath_common+0x7f/0xc0
[   69.232330]  [<ffffffff8109811a>] warn_slowpath_null+0x1a/0x20
[   69.232336]  [<ffffffff81199cea>] d_set_d_op+0xaa/0xc0
[   69.232341]  [<ffffffff811a9aef>] simple_lookup+0x3f/0x60
[   69.232346]  [<ffffffff8118eff5>] d_alloc_and_lookup+0x45/0x90
[   69.232352]  [<ffffffff8119ce05>] ? d_lookup+0x35/0x60
[   69.232358]  [<ffffffff811900b8>] __lookup_hash+0xa8/0xf0
[   69.232363]  [<ffffffff81190119>] lookup_hash+0x19/0x20
[   69.232368]  [<ffffffff811930e2>] kern_path_create+0x92/0x140
[   69.232374]  [<ffffffff8139dde6>] ? strncpy_from_user+0x36/0x50
[   69.232379]  [<ffffffff8118f3ac>] ? getname_flags+0x6c/0x210
[   69.232384]  [<ffffffff811931dd>] user_path_create+0x4d/0x80
[   69.232389]  [<ffffffff81194211>] sys_mkdirat+0x31/0xe0
[   69.232393]  [<ffffffff811942d8>] sys_mkdir+0x18/0x20
[   69.232399]  [<ffffffff81be8b42>] system_call_fastpath+0x16/0x1b
[   69.232403] ---[ end trace 6ff19356b0390d0b ]---


1250 void d_set_d_op(struct dentry *dentry, const struct dentry_operations *op)
1251 {

1252         WARN_ON_ONCE(dentry->d_op);
1253         WARN_ON_ONCE(dentry->d_flags & (DCACHE_OP_HASH  |
1254                                 DCACHE_OP_COMPARE       |
1255                                 DCACHE_OP_REVALIDATE    |
1256                                 DCACHE_OP_DELETE ));
(pops up only just once)

1257         dentry->d_op = op;
1258         if (!op)
1259                 return;
1260         if (op->d_hash)
1261                 dentry->d_flags |= DCACHE_OP_HASH;
1262         if (op->d_compare)
1263                 dentry->d_flags |= DCACHE_OP_COMPARE;
1264         if (op->d_revalidate)
1265                 dentry->d_flags |= DCACHE_OP_REVALIDATE;
1266         if (op->d_delete)
1267                 dentry->d_flags |= DCACHE_OP_DELETE;
1268
1269 }
1270 EXPORT_SYMBOL(d_set_d_op);


the 'mkdir' and 'touch' fail:

mkdir: cannot create directory `/mnt/sdb/subv18290/snap2/snap1/error-dir': Operation not permitted
touch: cannot touch `/mnt/sdb/subv18290/snap2/snap1/error-file': Permission denied


stat:

  File: `/mnt/sdb/subv18290/snap2/snap1'
  Size: 0               Blocks: 0          IO Block: 4096   directory
Device: 13h/19d Inode: 2           Links: 1
Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2011-10-03 18:04:12.001392638 +0200
Modify: 2011-10-03 18:04:12.001392638 +0200
Change: 2011-10-03 18:04:12.001392638 +0200
 Birth: -
  File: `/mnt/sdb/subv18290/snap3/snap1'
  Size: 0               Blocks: 0          IO Block: 4096   directory
Device: 13h/19d Inode: 2           Links: 1
Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2011-10-03 18:04:12.001392638 +0200
Modify: 2011-10-03 18:04:12.001392638 +0200
Change: 2011-10-03 18:04:12.001392638 +0200
 Birth: -
  File: `/mnt/sdb/subv18290/snap3/snap2'
  Size: 0               Blocks: 0          IO Block: 4096   directory
Device: 13h/19d Inode: 2           Links: 1
Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2011-10-03 18:04:12.001392638 +0200
Modify: 2011-10-03 18:04:12.001392638 +0200
Change: 2011-10-03 18:04:12.001392638 +0200
 Birth: -


Please note the 'Inode: 2'. Any regular directory created in under the
subvolume has inode number 257+ .

The snapshots are deletable.

Sources: http://repo.or.cz/w/linux-2.6/btrfs-unstable.git btrfs-next-stable
(linus + josef + hotfixes from mailinglist).


david
