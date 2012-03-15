From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: 3.2-rc4: scrubbing locks up the kernel, then hung tasks on boot
Date: Thu, 15 Mar 2012 18:32:19 +0100
Message-ID: <201203151832.19703.Martin@lichtvoll.de>
References: <201112171833.34720.Martin@lichtvoll.de> <201202241651.57233.Martin@lichtvoll.de> <4F48986D.4090703@gmx.net> (sfid-20120225_103102_396476_53ADE9E1)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: Arne Jansen <sensille@gmx.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F48986D.4090703@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 25. Februar 2012 schrieb Arne Jansen:
> On 02/24/12 16:51, Martin Steigerwald wrote:
> > Am Samstag, 21. Januar 2012 schrieb Martin Steigerwald:
> >> Am Samstag, 21. Januar 2012 schrieb Martin Steigerwald:
> >>> I still have this with 3.2.0-1-pae - which is a debian kernel bas=
ed
> >>> on 3.2.1.
> >>>=20
> >>> When I do btrfs scrub start / the machine locks immediately up
> >>> hard.
> >>>=20
> >>> Then usually on next boot it stops on space_cache enabled message=
,
> >>> but not  the one for /, but the one for /home which is mounted
> >>> later.
> >>>=20
> >>> When I then boot with 3.1 it works. BTRFS redos the space_cache
> >>> then while  the machine takes ages to boot - I mean ages - 10
> >>> minutes till KDM prompt is no problem there.
> >>=20
> >> I now tested scrubbing /home which is a different BTRFS filesystem
> >> on the same machine.
> >>=20
> >> Then the scrub is started, scrub status tells me so, but nothing
> >> happens, no block in/out activity in vmstat, no CPU related activi=
ty
> >> in top.
> >>=20
> >> btrfs scrub cancel then hangs, but not the complete machine, only
> >> the process.
> >>=20
> >> I had this once on my T520 with the internal Intel SSD 320 as well=
=2E
> >> The other time it worked.
> >>=20
> >> Well maybe that is due to BTRFS doing something else on my T23 now=
:
> >>=20
> >> deepdance:~>  ps aux | grep ino-cache | grep -v grep
> >> root      1992  5.5  0.0      0     0 ?        D    12:15   0:09
> >> [btrfs- ino-cache]
> >>=20
> >> Hmmm, so I just let it sit for a while, maybe eventually it will
> >> scrub /home.
> >>=20
> >> At least it doesn=C2=B4t lock up hard, so there might really be so=
mething
> >> strange with /.
> >=20
> > FWIW a btrfs filesystem balance / does work. After this a btrfs scr=
ub
> > start / still locks the kernel.
>
> Hi Martin,
>=20
> I just sent 2 patches to the list. Could you please test if these
> fix your problem with scrub?

I didn=C2=B4t yet test it but I tried the first balance then scrub stuf=
f again:

deepdance:~> btrfs filesystem balance /

This time scrub didn=C2=B4t lock up hard:

deepdance:~> btrfs scrub start /
scrub started on /, fsid 2bf5b1dc-1d89-4f0d-a561-1a5551a27275 (pid=3D33=
47)
deepdance:~> btrfs scrub status /
scrub status for 2bf5b1dc-1d89-4f0d-a561-1a5551a27275
        scrub started at Thu Mar 15 18:10:52 2012, running for 10 secon=
ds
        total bytes scrubbed: 272.59MB with 0 errors
deepdance:~> cat /proc/version
Linux version 3.2.0-1-686-pae (Debian 3.2.6-1) (ben@decadent.org.uk)
(gcc version 4.6.2 (Debian 4.6.2-14) ) #1 SMP Fri Feb 17 06:27:21 UTC 2=
012
deepdance:~> btrfs scrub status /
scrub status for 2bf5b1dc-1d89-4f0d-a561-1a5551a27275
        scrub started at Thu Mar 15 18:10:52 2012, running for 55 secon=
ds
        total bytes scrubbed: 1.29GB with 0 errors
deepdance:~> btrfs scrub status /
scrub status for 2bf5b1dc-1d89-4f0d-a561-1a5551a27275
        scrub started at Thu Mar 15 18:10:52 2012, running for 175 seco=
nds
        total bytes scrubbed: 2.58GB with 0 errors


But it seems to be stuck now:

deepdance:~> btrfs scrub status /
scrub status for 2bf5b1dc-1d89-4f0d-a561-1a5551a27275
        scrub started at Thu Mar 15 18:10:52 2012, running for 295 seco=
nds
        total bytes scrubbed: 2.58GB with 0 errors
deepdance:~> btrfs scrub status /
scrub status for 2bf5b1dc-1d89-4f0d-a561-1a5551a27275
        scrub started at Thu Mar 15 18:10:52 2012, running for 395 seco=
nds
        total bytes scrubbed: 2.58GB with 0 errors
deepdance:~> btrfs scrub status /
scrub status for 2bf5b1dc-1d89-4f0d-a561-1a5551a27275
        scrub started at Thu Mar 15 18:10:52 2012, running for 636 seco=
nds
        total bytes scrubbed: 2.58GB with 0 errors


There is almost no activity in vmstat 5:

 2  0 108812  63812     36 412716    0   22     0   437  515 1723 47 13=
 37  3
 2  0 108812  63320     36 413168    0    0    81     0  453 1600 44 12=
 43  1
 2  0 108812  68056     36 413512    0    0    64     0  480 1589 51 11=
 38  0
 2  0 108812  68112     36 413516    0    0     0     0  460 1454 46 11=
 43  0
 1  0 108812  68112     36 413536    0    0     0     1  454 1456 45 11=
 44  0
 1  1 108812  67924     36 413692    0    0     0   330  491 1578 49 13=
 37  1
 2  0 108812  67808     36 413792    0    0     0     6  473 1556 48 11=
 41  0
 2  0 108812  67436     36 414124    0    0     0   424  523 1922 47 13=
 39  2
 1  0 108812  67460     36 414136    0    0     0     0  453 1578 46  9=
 45  0
 2  0 108812  67476     36 414136    0    0     0     0  465 1493 46 12=
 41  0
procs -----------memory---------- ---swap-- -----io---- -system-- ----c=
pu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy=
 id wa
 3  0 108812  67492     36 414140    0    0     0     0  467 1609 48 10=
 42  0
 2  0 108812  67500     36 414148    0    0     0     0  470 1686 46 12=
 41  0
 1  0 108812  66872     36 414152    0    0     0     1  463 1585 46 11=
 43  0
 1  0 108812  67492     36 414156    0    0     0     1  483 1612 48 13=
 39  0
 2  0 108812  67428     36 414156    0    0     0   325  497 1654 48  9=
 41  1
 0  0 108812  67452     36 414160    0    0     0     3  478 1588 46 15=
 39  0
 2  0 108812  65840     36 415228    0    0   214     0  465 1408 54 10=
 36  0
 0  0 108812  66124     36 415352    0    0    24     0  510 1476 62 14=
 22  2

Given the general slowness of the machine, I waited about 15 seconds on=
 a

tail -f /var/log/syslog

while just a Konsole and Amarok was running and wait about that time or
even longer when logging via SSH at times, I think next I try newest
Debian kernel which should be up to 3.2.10.

If that doesn=C2=B4t work, I consider trying your patches.

At least its a step forward: The machine doesn=C2=B4t lock up hard anym=
ore. Its
still playing music.

=46WIW a cancel hangs:

deepdance:~> btrfs scrub cancel /


martin@deepdance:~> ps aux | grep btrfs | grep cancel
root      3429  0.0  0.0   2128   304 pts/5    D+   18:24   0:00 btrfs =
scrub cancel /



Ah, now there we go, from dmesg:

16453.391004] btrfs: relocating block group 41393586176 flags 1
[16568.504524] btrfs: found 9891 extents
[16660.810000] btrfs: found 9891 extents
[16664.818271] btrfs: relocating block group 40319844352 flags 1
[16729.029078] btrfs: found 3593 extents
[16755.771257] btrfs: found 3593 extents
[16757.816472] btrfs: relocating block group 39246102528 flags 1
[16843.042862] btrfs: found 13147 extents
[16898.078594] btrfs: found 13147 extents
[16905.444650] btrfs: relocating block group 39237713920 flags 34
[16910.579963] btrfs: found 1 extents
[16915.946553] btrfs: relocating block group 39103496192 flags 36
[16997.308374] btrfs: found 14552 extents
[17002.239868] btrfs: relocating block group 38969278464 flags 36
[17165.253567] btrfs: found 22792 extents
[17166.522513] btrfs: relocating block group 38835060736 flags 36
[17376.519168] btrfs: found 22857 extents
[17377.526508] btrfs: relocating block group 38700843008 flags 36
[17559.413243] btrfs: found 24810 extents
[17563.767590] btrfs: relocating block group 37627101184 flags 1
[17646.272226] btrfs: found 10900 extents
[17694.323897] btrfs: found 10900 extents
[17697.171187] btrfs: relocating block group 36553359360 flags 1
[17779.364231] btrfs: found 12149 extents
[17828.395574] btrfs: found 12149 extents
[17831.593055] btrfs: relocating block group 35479617536 flags 1
[17923.352624] btrfs: found 22174 extents
[18014.147595] btrfs: found 22174 extents
[18015.821756] btrfs: relocating block group 35345399808 flags 36
[18055.201043] btrfs: found 9166 extents
[18061.692337] btrfs: relocating block group 34271657984 flags 1
[18173.986306] btrfs: found 29124 extents
[18328.733328] btrfs: found 29124 extents
[18333.141061] btrfs: relocating block group 33197916160 flags 1
[18427.523898] btrfs: found 26881 extents
[18587.015489] btrfs: found 26880 extents
[18590.183797] btrfs: relocating block group 33063698432 flags 36
[18590.183797] btrfs: relocating block group 33063698432 flags 36
[18624.883576] btrfs: found 6522 extents
[18628.618415] btrfs: relocating block group 32929480704 flags 36
[18670.147756] btrfs: found 9876 extents
[18671.426925] btrfs: relocating block group 32795262976 flags 36
[18863.313381] btrfs: found 27324 extents
[18864.392712] btrfs: relocating block group 31721521152 flags 1
[18945.941315] btrfs: found 21748 extents
[19076.164135] btrfs: found 21721 extents
[20880.564211] INFO: task btrfs:3348 blocked for more than 120 seconds.
[20880.564225] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les this message.
[20880.564234] btrfs           D 000012d2     0  3348      1 0x00000000
[20880.564251]  c0b72080 00000086 2cae1a17 000012d2 ec3ae5a0 00000000 0=
00012d2 c14769c0
[20880.564275]  c0b7222c c14769c0 00008050 e0b96ce0 ee000120 d1d5dae0 d=
1d5db20 00000028
[20880.564298]  c105d451 00000092 c12b949b 00000092 f0b7037c 00000246 e=
ee6073c c105d451
[20880.564321] Call Trace:
[20880.564348]  [<c105d451>] ? arch_local_irq_save+0xf/0x14
[20880.564368]  [<c12b949b>] ? _raw_spin_lock_irqsave+0x8/0x21
[20880.564482]  [<f0b7037c>] ? btrfs_queue_worker+0x1cd/0x1fc [btrfs]
[20880.564497]  [<c105d451>] ? arch_local_irq_save+0xf/0x14
[20880.564511]  [<c12b949b>] ? _raw_spin_lock_irqsave+0x8/0x21
[20880.564526]  [<c104d402>] ? prepare_to_wait+0x12/0x50
[20880.564601]  [<f0b8a8c8>] ? btrfs_reada_wait+0x5b/0x84 [btrfs]
[20880.564615]  [<c104d4d0>] ? add_wait_queue+0x30/0x30
[20880.564687]  [<f0b87e33>] ? scrub_stripe+0x34c/0xbda [btrfs]
[20880.564729]  [<f0a4da1f>] ? scsi_alloc_sgtable+0x1a/0x38 [scsi_mod]
[20880.564786]  [<f0b37a7f>] ? comp_keys+0x2f/0x34 [btrfs]
[20880.564842]  [<f0b37b4d>] ? generic_bin_search.constprop.31+0xc9/0x1=
04 [btrfs]
[20880.564856]  [<c104d4d0>] ? add_wait_queue+0x30/0x30
[20880.564912]  [<f0b37bbf>] ? bin_search+0x37/0x3d [btrfs]
[20880.564987]  [<f0b5e3d4>] ? __lookup_extent_mapping+0xe5/0x101 [btrf=
s]
[20880.565061]  [<f0b88781>] ? scrub_chunk.isra.13+0xc0/0xef [btrfs]
[20880.565134]  [<f0b889a3>] ? scrub_enumerate_chunks+0x1f3/0x23a [btrf=
s]
[20880.565209]  [<f0b89486>] ? btrfs_scrub_dev+0x215/0x34e [btrfs]
[20880.565230]  [<c10c061a>] ? __kmalloc_track_caller+0x9b/0xa7
[20880.565248]  [<c102a280>] ? should_resched+0x5/0x1e
[20880.565320]  [<f0b74b14>] ? btrfs_ioctl+0xc55/0xda1 [btrfs]
[20880.565335]  [<c1029188>] ? kmap_atomic_prot+0x2f/0xe0
[20880.565353]  [<c10ad3d5>] ? handle_mm_fault+0x1ee/0x1fd
[20880.565426]  [<f0b73ebf>] ? btrfs_ioctl_trans_end+0x49/0x49 [btrfs]
[20880.565442]  [<c10d7023>] ? do_vfs_ioctl+0x459/0x48f
[20880.565457]  [<c12bc3d7>] ? do_page_fault+0x2e0/0x2fc
[20880.565469]  [<c12bc3c4>] ? do_page_fault+0x2cd/0x2fc
[20880.565484]  [<c10d709d>] ? sys_ioctl+0x44/0x67
[20880.565499]  [<c12bdd1f>] ? sysenter_do_call+0x12/0x28
[21000.564277] INFO: task btrfs:3348 blocked for more than 120 seconds.
[21000.564292] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les this message.
[21000.564302] btrfs           D 000012d2     0  3348      1 0x00000000
[21000.564319]  c0b72080 00000086 2cae1a17 000012d2 ec3ae5a0 00000000 0=
00012d2 c14769c0
[21000.564344]  c0b7222c c14769c0 00008050 e0b96ce0 ee000120 d1d5dae0 d=
1d5db20 00000028
[21000.564366]  c105d451 00000092 c12b949b 00000092 f0b7037c 00000246 e=
ee6073c c105d451
[21000.564390] Call Trace:
[21000.564422]  [<c105d451>] ? arch_local_irq_save+0xf/0x14
[21000.564442]  [<c12b949b>] ? _raw_spin_lock_irqsave+0x8/0x21
[21000.564582]  [<f0b7037c>] ? btrfs_queue_worker+0x1cd/0x1fc [btrfs]
[21000.564600]  [<c105d451>] ? arch_local_irq_save+0xf/0x14
[21000.564614]  [<c12b949b>] ? _raw_spin_lock_irqsave+0x8/0x21
[21000.564630]  [<c104d402>] ? prepare_to_wait+0x12/0x50
[21000.564707]  [<f0b8a8c8>] ? btrfs_reada_wait+0x5b/0x84 [btrfs]
[21000.564721]  [<c104d4d0>] ? add_wait_queue+0x30/0x30
[21000.564793]  [<f0b87e33>] ? scrub_stripe+0x34c/0xbda [btrfs]
[21000.564840]  [<f0a4da1f>] ? scsi_alloc_sgtable+0x1a/0x38 [scsi_mod]
[21000.564899]  [<f0b37a7f>] ? comp_keys+0x2f/0x34 [btrfs]
[21000.564954]  [<f0b37b4d>] ? generic_bin_search.constprop.31+0xc9/0x1=
04 [btrfs]
[21000.564968]  [<c104d4d0>] ? add_wait_queue+0x30/0x30
[21000.565024]  [<f0b37bbf>] ? bin_search+0x37/0x3d [btrfs]
[21000.565099]  [<f0b5e3d4>] ? __lookup_extent_mapping+0xe5/0x101 [btrf=
s]
[21000.565173]  [<f0b88781>] ? scrub_chunk.isra.13+0xc0/0xef [btrfs]
[21000.565246]  [<f0b889a3>] ? scrub_enumerate_chunks+0x1f3/0x23a [btrf=
s]
[21000.565322]  [<f0b89486>] ? btrfs_scrub_dev+0x215/0x34e [btrfs]
[21000.565345]  [<c10c061a>] ? __kmalloc_track_caller+0x9b/0xa7
[21000.565363]  [<c102a280>] ? should_resched+0x5/0x1e
[21000.565436]  [<f0b74b14>] ? btrfs_ioctl+0xc55/0xda1 [btrfs]
[21000.565451]  [<c1029188>] ? kmap_atomic_prot+0x2f/0xe0
[21000.565471]  [<c10ad3d5>] ? handle_mm_fault+0x1ee/0x1fd
[21000.565544]  [<f0b73ebf>] ? btrfs_ioctl_trans_end+0x49/0x49 [btrfs]
[21000.565561]  [<c10d7023>] ? do_vfs_ioctl+0x459/0x48f
[21000.565577]  [<c12bc3d7>] ? do_page_fault+0x2e0/0x2fc
[21000.565589]  [<c12bc3c4>] ? do_page_fault+0x2cd/0x2fc
[21000.565603]  [<c10d709d>] ? sys_ioctl+0x44/0x67
[21000.565619]  [<c12bdd1f>] ? sysenter_do_call+0x12/0x28

[=E2=80=A6 it seems to go on this way =E2=80=A6]


Maybe something of that is helpful?

I leave the machine running for a while, but I think it won=C2=B4t hibe=
rnate
with a process stuck in D state so eventually at some time I will shut =
it
down and restart. OTOH I could leave it running till tomorrow or what.

I will put log files aside for further diagnostics in any case.

Ciao,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
