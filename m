From: Sean Reifschneider <jafo@tummy.com>
Subject: btrstress caused kernel oops after 8-ish days.
Date: Tue, 27 Apr 2010 05:14:26 -0600
Message-ID: <4BD6C712.6090202@tummy.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3076D97DF81F3D9BED78A5E6"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3076D97DF81F3D9BED78A5E6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I ported my zfsstress program over to btrfs, and started running it on
a test machine a few weeks ago.  See here for more information and a link=

to the program:

   http://www.tummy.com/journals/entries/jafo_20100418_124309

It looks like after around 8 days of running, there were some issues, as
shown in dmesg (below).

The system is a 64-bit Atom 330 with 2GB RAM, and a single 250GB hard
drive.  btrfs has 200GB of that.  The OS is the Fedora 13 Beta with kerne=
l
2.6.33.1-24.fc13.x86_64.

I had started btrstress and let it run a day or so.  Then I went in and
deleted the subvolume that btrstress puts everything into, then started i=
t
again.  A few days later, I did the same.  I also tried turning on
compression with "mount -o remount,compress /data".  Around 6 hours later=
,
it looks like btrstress was no longer working.

The primary issue seems to be that file deletions aren't freeing up space=
=2E
btrstress will fill the file-system up, but disables any write operations=

if the "df" output shows more than 95% full.  So normally it would clear =
up
some snapshots or files until it gets back down to 95% or less, and start=

doing writes again.

However, after the Oops, it looks like it was able to continue allowing
removes of files and snapshots, but "df" is no longer reflecting that.  F=
or
example:

   [root@btrtest btrstress-lZ6C7txz3n]# df -h
   Filesystem            Size  Used Avail Use% Mounted on
   /dev/sda1              29G   13G   16G  45% /
   tmpfs                 991M     0  991M   0% /dev/shm
   /dev/sda4             200G  189G  9.9G  96% /data
   [root@btrtest btrstress-lZ6C7txz3n]# find /data
   /data
   /data/btrstress-lZ6C7txz3n
   [root@btrtest btrstress-lZ6C7txz3n]# btrfs subvolume list /data
   ID 28423 top level 5 path btrstress-lZ6C7txz3n
   [root@btrtest btrstress-lZ6C7txz3n]# du -sh /data
   4.0K    /data
   [root@btrtest btrstress-lZ6C7txz3n]#

I've left the test system as it is, let me know if there's anything you'd=

like me to try on the system before I wipe it and start again.

Also, let me know if this sort of report helps.

Note that after enabling compression, but before the oops, dmesg reported=
 a
bunch of messages like:

   btrfs: relocating block group 11840520192 flags 1
   btrfs: relocating block group 10766778368 flags 1
   btrfs: relocating block group 9693036544 flags 1
   btrfs: relocating block group 8619294720 flags 1
   btrfs: relocating block group 7545552896 flags 1
   btrfs: relocating block group 6471811072 flags 1

Note that the group numbers started at 212630241280 and reduced by around=
 a
billion for every line.

dmesg output of oops below.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000075=

IP: [<ffffffff810e380f>] page_cache_sync_readahead+0x15/0x3a
PGD 7a937067 PUD 3310c067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:04:00.1/irq
CPU 0
Pid: 30242, comm: btrfs Not tainted 2.6.33.1-24.fc13.x86_64 #1 D945GCLF2/=

RIP: 0010:[<ffffffff810e380f>]  [<ffffffff810e380f>]
page_cache_sync_readahead+0x15/0x3a
RSP: 0018:ffff88003309fac8  EFLAGS: 00010206
RAX: 0000000000000000 RBX: ffff880046476940 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff88007ac840d0 RDI: ffff880046476b70
RBP: ffff88003309fac8 R08: 0000000000003f6a R09: 0000000000000246
R10: ffff88003309f8d8 R11: 0000000000000000 R12: ffff880077422968
R13: 0000000000000000 R14: ffff880046476608 R15: 0000000000000000
FS:  00007f893574d740(0000) GS:ffff880004a00000(0000) knlGS:0000000000000=
000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000075 CR3: 0000000033004000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs (pid: 30242, threadinfo ffff88003309e000, task ffff8800777a=
8000)
Stack:
 ffff88003309fb68 ffffffffa0364899 ffff88003309fae8 0000000181c00001
<0> ffff880046476a30 ffff880046476608 ffff88003309fb28 0000000000003f69
<0> 0000000000000000 ffff88007ac840d0 0000000000003f6a 0000000181c00000
Call Trace:
 [<ffffffffa0364899>] relocate_file_extent_cluster+0x18f/0x399 [btrfs]
 [<ffffffffa0364b46>] relocate_data_extent+0xa3/0xbb [btrfs]
 [<ffffffffa0364e1a>] relocate_block_group+0x2bc/0x384 [btrfs]
 [<ffffffffa036506f>] btrfs_relocate_block_group+0x18d/0x312 [btrfs]
 [<ffffffffa034dfe7>] btrfs_relocate_chunk+0x6c/0x4c2 [btrfs]
 [<ffffffffa033e051>] ? btrfs_item_offset+0xbb/0xcb [btrfs]
 [<ffffffffa034c81b>] ? btrfs_item_key_to_cpu+0x2a/0x46 [btrfs]
 [<ffffffffa034ea24>] btrfs_balance+0x1ce/0x21b [btrfs]
 [<ffffffff811f02b0>] ? inode_has_perm+0xaa/0xce
 [<ffffffffa0355cec>] btrfs_ioctl+0x6f9/0x871 [btrfs]
 [<ffffffff81071226>] ? sched_clock_cpu+0xc3/0xce
 [<ffffffff8107ba94>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff81071274>] ? cpu_clock+0x43/0x5e
 [<ffffffff8112c054>] vfs_ioctl+0x32/0xa6
 [<ffffffff8112c5d4>] do_vfs_ioctl+0x490/0x4d6
 [<ffffffff8112c670>] sys_ioctl+0x56/0x79
 [<ffffffff81009c72>] system_call_fastpath+0x16/0x1b
Code: 47 48 48 85 c0 74 04 31 f6 ff d0 48 83 c4 28 5b 41 5c 41 5d c9 c3 5=
5 48
89 e5 0f 1f 44 00 00 83 7e 10 00 48 89 d0 48 89 ca 74 23 <f6> 40 75 10 74=
 0d
4c 89 c1 48 89 c6 e8 3d fb ff ff eb 10 4d 89
RIP  [<ffffffff810e380f>] page_cache_sync_readahead+0x15/0x3a
 RSP <ffff88003309fac8>
CR2: 0000000000000075
---[ end trace 1b855fa188411071 ]---

Sean
--=20
Sean Reifschneider, Member of Technical Staff <jafo@tummy.com>
tummy.com, ltd. - Linux Consulting since 1995: Ask me about High Availabi=
lity


--------------enig3076D97DF81F3D9BED78A5E6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iD8DBQFL1scSxUhyMYEjVX0RAuaPAJ9OkMTEqBD2eCXZCsX2bTfwG2glswCglxFT
Ge9tN7H1foJObWGjLILWCg0=
=degu
-----END PGP SIGNATURE-----

--------------enig3076D97DF81F3D9BED78A5E6--
