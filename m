From: Adrian von Bidder <avbidder@fortytwo.ch>
Subject: Re: task imap:2958 blocked for more than 120 seconds
Date: Mon, 11 Jan 2010 09:45:31 +0100
Message-ID: <201001110945.32352@fortytwo.ch>
References: <201001102105.47192.johannes.hirte@fem.tu-ilmenau.de> <201001110834.36865@fortytwo.ch>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4170908.0XA22HpcXH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201001110834.36865@fortytwo.ch>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart4170908.0XA22HpcXH
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Monday 11 January 2010 08.34:36 Adrian von Bidder wrote:
> "btrfs-vol -b" on an 2T btrfs fs (raid 1 mode over 4 disks) on an arm
>  CPU  has triggered it several times, so it seems a reliable way to
>  reproduce this.
>=20

=46ound it (Debian kernel 2.6.32 on ARM):

[78260.386272] INFO: task btrfs-vol:10979 blocked for more than 120 seconds.
[78260.386306] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[78260.386331] btrfs-vol     D c02b080c     0 10979      1 0x00000001
[78260.386373] [<c02b080c>] (schedule+0x424/0x488) from [<c02b0c9c>] (sched=
ule_timeout+0x1c/0x244)
[78260.386408] [<c02b0c9c>] (schedule_timeout+0x1c/0x244) from [<c02b0b10>]=
 (wait_for_common+0xdc/0x178)
[78260.386611] [<c02b0b10>] (wait_for_common+0xdc/0x178) from [<bf29b880>] =
(merge_reloc_roots+0x15c/0x1a4 [btrfs])
[78260.386940] [<bf29b880>] (merge_reloc_roots+0x15c/0x1a4 [btrfs]) from [<=
bf2a3fd8>] (relocate_block_group+0x548/0x5c8 [btrfs])
[78260.387258] [<bf2a3fd8>] (relocate_block_group+0x548/0x5c8 [btrfs]) from=
 [<bf2a4434>] (btrfs_relocate_block_group+0x17c/0x3a4 [btrfs])
[78260.387564] [<bf2a4434>] (btrfs_relocate_block_group+0x17c/0x3a4 [btrfs]=
) from [<bf2868e0>] (btrfs_relocate_chunk+0x70/0x7c0 [btrfs])
[78260.387856] [<bf2868e0>] (btrfs_relocate_chunk+0x70/0x7c0 [btrfs]) from =
[<bf2879f4>] (btrfs_balance+0x370/0x424 [btrfs])
[78260.388148] [<bf2879f4>] (btrfs_balance+0x370/0x424 [btrfs]) from [<bf28=
d3a8>] (btrfs_ioctl+0x754/0x968 [btrfs])
[78260.388319] [<bf28d3a8>] (btrfs_ioctl+0x754/0x968 [btrfs]) from [<c00d87=
88>] (vfs_ioctl+0x2c/0x70)
[78260.388357] [<c00d8788>] (vfs_ioctl+0x2c/0x70) from [<c00d8e8c>] (do_vfs=
_ioctl+0x4f4/0x55c)
[78260.388390] [<c00d8e8c>] (do_vfs_ioctl+0x4f4/0x55c) from [<c00d8f44>] (s=
ys_ioctl+0x50/0x74)
[78260.388423] [<c00d8f44>] (sys_ioctl+0x50/0x74) from [<c0026ea0>] (ret_fa=
st_syscall+0x0/0x28)
[78380.381159] INFO: task btrfs-vol:10979 blocked for more than 120 seconds.
[78380.381194] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[78380.381219] btrfs-vol     D c02b080c     0 10979      1 0x00000001
[78380.381262] [<c02b080c>] (schedule+0x424/0x488) from [<c02b0c9c>] (sched=
ule_timeout+0x1c/0x244)
[78380.381297] [<c02b0c9c>] (schedule_timeout+0x1c/0x244) from [<c02b0b10>]=
 (wait_for_common+0xdc/0x178)
[78380.381501] [<c02b0b10>] (wait_for_common+0xdc/0x178) from [<bf29b880>] =
(merge_reloc_roots+0x15c/0x1a4 [btrfs])
[78380.381830] [<bf29b880>] (merge_reloc_roots+0x15c/0x1a4 [btrfs]) from [<=
bf2a3fd8>] (relocate_block_group+0x548/0x5c8 [btrfs])
[78380.382232] [<bf2a3fd8>] (relocate_block_group+0x548/0x5c8 [btrfs]) from=
 [<bf2a4434>] (btrfs_relocate_block_group+0x17c/0x3a4 [btrfs])
[78380.382545] [<bf2a4434>] (btrfs_relocate_block_group+0x17c/0x3a4 [btrfs]=
) from [<bf2868e0>] (btrfs_relocate_chunk+0x70/0x7c0 [btrfs])
[78380.382839] [<bf2868e0>] (btrfs_relocate_chunk+0x70/0x7c0 [btrfs]) from =
[<bf2879f4>] (btrfs_balance+0x370/0x424 [btrfs])
[78380.383131] [<bf2879f4>] (btrfs_balance+0x370/0x424 [btrfs]) from [<bf28=
d3a8>] (btrfs_ioctl+0x754/0x968 [btrfs])
[78380.383302] [<bf28d3a8>] (btrfs_ioctl+0x754/0x968 [btrfs]) from [<c00d87=
88>] (vfs_ioctl+0x2c/0x70)
[78380.383341] [<c00d8788>] (vfs_ioctl+0x2c/0x70) from [<c00d8e8c>] (do_vfs=
_ioctl+0x4f4/0x55c)
[78380.383374] [<c00d8e8c>] (do_vfs_ioctl+0x4f4/0x55c) from [<c00d8f44>] (s=
ys_ioctl+0x50/0x74)
[78380.383408] [<c00d8f44>] (sys_ioctl+0x50/0x74) from [<c0026ea0>] (ret_fa=
st_syscall+0x0/0x28)

umount right after some big fs action (not sure, it was either lots of=20
file deletions, a big rsync of some tree, or right after the btrfs-vol
stuff) manages to trigger a btrfs related hang, too:

[97460.345446] INFO: task umount:12765 blocked for more than 120 seconds.
[97460.345481] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[97460.345505] umount        D c02b080c     0 12765  12681 0x00000000
[97460.345554] [<c02b080c>] (schedule+0x424/0x488) from [<c00e719c>] (bdi_s=
ched_wait+0xc/0x18)
[97460.345592] [<c00e719c>] (bdi_sched_wait+0xc/0x18) from [<c02b0f68>] (__=
wait_on_bit+0x5c/0xa8)
[97460.345625] [<c02b0f68>] (__wait_on_bit+0x5c/0xa8) from [<c02b1060>] (ou=
t_of_line_wait_on_bit+0xac/0xc4)
[97460.345661] [<c02b1060>] (out_of_line_wait_on_bit+0xac/0xc4) from [<c00e=
7210>] (sync_inodes_sb+0x68/0x100)
[97460.345699] [<c00e7210>] (sync_inodes_sb+0x68/0x100) from [<c00eb340>] (=
__sync_filesystem+0x64/0x94)
[97460.345737] [<c00eb340>] (__sync_filesystem+0x64/0x94) from [<c00cdc74>]=
 (generic_shutdown_super+0x28/0x110)
[97460.345776] [<c00cdc74>] (generic_shutdown_super+0x28/0x110) from [<c00c=
dda8>] (kill_anon_super+0x14/0x3c)
[97460.345813] [<c00cdda8>] (kill_anon_super+0x14/0x3c) from [<c00ce46c>] (=
deactivate_super+0x6c/0x90)
[97460.345849] [<c00ce46c>] (deactivate_super+0x6c/0x90) from [<c00e2310>] =
(sys_umount+0x2bc/0x2e8)
[97460.345883] [<c00e2310>] (sys_umount+0x2bc/0x2e8) from [<c0026ea0>] (ret=
_fast_syscall+0x0/0x28)
[97580.340641] INFO: task umount:12765 blocked for more than 120 seconds.
[97580.340674] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[97580.340699] umount        D c02b080c     0 12765  12681 0x00000000
[97580.340749] [<c02b080c>] (schedule+0x424/0x488) from [<c00e719c>] (bdi_s=
ched_wait+0xc/0x18)
[97580.340787] [<c00e719c>] (bdi_sched_wait+0xc/0x18) from [<c02b0f68>] (__=
wait_on_bit+0x5c/0xa8)
[97580.340821] [<c02b0f68>] (__wait_on_bit+0x5c/0xa8) from [<c02b1060>] (ou=
t_of_line_wait_on_bit+0xac/0xc4)
[97580.340857] [<c02b1060>] (out_of_line_wait_on_bit+0xac/0xc4) from [<c00e=
7210>] (sync_inodes_sb+0x68/0x100)
[97580.340894] [<c00e7210>] (sync_inodes_sb+0x68/0x100) from [<c00eb340>] (=
__sync_filesystem+0x64/0x94)
[97580.340932] [<c00eb340>] (__sync_filesystem+0x64/0x94) from [<c00cdc74>]=
 (generic_shutdown_super+0x28/0x110)
[97580.340970] [<c00cdc74>] (generic_shutdown_super+0x28/0x110) from [<c00c=
dda8>] (kill_anon_super+0x14/0x3c)
[97580.341008] [<c00cdda8>] (kill_anon_super+0x14/0x3c) from [<c00ce46c>] (=
deactivate_super+0x6c/0x90)
[97580.341044] [<c00ce46c>] (deactivate_super+0x6c/0x90) from [<c00e2310>] =
(sys_umount+0x2bc/0x2e8)
[97580.341079] [<c00e2310>] (sys_umount+0x2bc/0x2e8) from [<c0026ea0>] (ret=
_fast_syscall+0x0/0x28)


I've never had the system or even the affected processes die on me, the=20
end result was always ok.  Just took ages.  (Ok, btrfs-vol -b taking ages
on a big fs is ok.  umount taking 10min is a bit over the top, especially
since the machine only has 1G ram, so there can't be that many dirty caches
in any case...

cheers
=2D- vbi



=2D-=20
featured product: PostgreSQL - http://postgresql.org

--nextPart4170908.0XA22HpcXH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: get my key from http://fortytwo.ch/gpg/92082481

iKcEABECAGcFAktK5StgGmh0dHA6Ly9mb3J0eXR3by5jaC9sZWdhbC9ncGcvZW1h
aWwuMjAwMjA4MjI/dmVyc2lvbj0xLjUmbWQ1c3VtPTVkZmY4NjhkMTE4NDMyNzYw
NzFiMjVlYjcwMDZkYTNlAAoJECqqZti935l6CyEAn3VxuuSGNdlkaw+MhJUBQb/S
2vkrAKC4Ko6p0eAk850GZkQA3c7TD75vww==
=ipI9
-----END PGP SIGNATURE-----

--nextPart4170908.0XA22HpcXH--
