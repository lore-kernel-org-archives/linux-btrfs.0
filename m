Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:33936 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbcDFPel (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Apr 2016 11:34:41 -0400
Received: by mail-wm0-f45.google.com with SMTP id l6so70652460wml.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Apr 2016 08:34:41 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 6 Apr 2016 11:34:39 -0400
Message-ID: <CAFKQ2BsxWYejWOPMCw5JuF-SXM03-papUu6LXM5KBNKthxAPxg@mail.gmail.com>
Subject: unable to mount btrfs pool even with -oro,recovery,degraded, unable
 to do 'btrfs restore'
From: Ank Ular <ankular.anime@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am currently unable to mount nor recover data from my btrfs storage pool.

To the best of my knowledge, the situation did not arise from hard
disk failure. I believe the sequence of events is:

One or possibly more of my external devices had the USB 3.0
communications link fail. I recall seeing the message which is
generated when a USB based storage device is newly connected.

I was near the end of a 'btrfs balance' run which included adding
devices and converting the pool from RAID5 to RAID6. There were
approximately 1000 chunks {out of 22K+ chunks} left to go.
I was also participating in several torrents {this means my btrfs pool
was active}

>From the ouput of 'dmesg', the section:
[   20.998071] BTRFS: device label FSgyroA devid 9 transid 625039 /dev/sdm
[   20.999984] BTRFS: device label FSgyroA devid 10 transid 625039 /dev/sdn
[   21.004127] BTRFS: device label FSgyroA devid 11 transid 625039 /dev/sds
[   21.011808] BTRFS: device label FSgyroA devid 12 transid 625039 /dev/sdu

bothers me because the transid value of these four devices doesn't
match the other 16 devices in the pool {should be 625065}. In theory,
I believe these should all have the same transid value. These four
devices are all on a single USB 3.0 port and this is the link I
believe went down and came back up. This is an external, four drive
bay case with 4 6T drives in it.

I can no longer mount the storage pool
pyrogyro ~ # mount -t btrfs -o ro,recovery,degraded /dev/sdb /PublicA
mount: wrong fs type, bad option, bad superblock on /dev/sdb,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

nor can I restore data from the storage pool
pyrogyro ~ # btrfs restore -D -i -v /dev/sdb /dev/null
checksum verify failed on 120890386268160 found D7319043 wanted 33D22DF5
checksum verify failed on 120890386268160 found 50ECAB17 wanted 2D8EEBCA
checksum verify failed on 120890386268160 found D7319043 wanted 33D22DF5
bytenr mismatch, want=120890386268160, have=65536
This is a dry-run, no files are going to be restored
parent transid verify failed on 120874721263616 wanted 625047 found 625039
parent transid verify failed on 120874721263616 wanted 625047 found 625039
checksum verify failed on 120874721263616 found 6FE4916B wanted 824E1F4D
checksum verify failed on 120874721263616 found 6FE4916B wanted 824E1F4D
bytenr mismatch, want=120874721263616, have=45608042283264
Error searching -5

blkid has no problem accessing all the devices in the storage pool.
smartcl tells me that every device in the pool has a 'Passed' health status.
The oldest drive is about 14 months old.

I understand I'll be losing some data. Of course, I'd like to recover
as much as possible. I can think two possible approaches though I
don't have any idea how to go about them:

Somehow fix things so I can mount the pool 'in place'. I don't mind
rolling back {if possible} the other 16 devices so that all devices
are at the same transid. I can recreate any corrupt/missing files up
to several weeks back. This might include fixing the chunk-tree,
re-creating any other trees or other repairs.

Somehow fix things so that I can perform 'btrfs restore' which will
copy all recoverable files to a new storage location.

I have not run any 'btrfs' commands such at 'check', 'rescue',
'replace', 'scrub' etc. The idea was to not make things worse. I have
rebooted 3 times before I understood that I had real issues with the
btrfs pool. These reboots all failed to mount the btrfs pool.

Any other information I can provide will be happily provided. All help
will be appreciated.

pyrogyro ~ # uname -a
Linux pyrogyro 4.4.6-gentoo #1 SMP PREEMPT Wed Apr 6 07:45:45 EDT 2016
x86_64 AMD A10-7850K Radeon R7, 12 Compute Cores 4C+8G AuthenticAMD
GNU/Linux
pyrogyro ~ # btrfs --version
btrfs-progs v4.5.1
pyrogyro ~ # btrfs fi show
Label: 'PhoenixRootSSD'  uuid: ed1790a7-87e6-466c-a68c-e375303fd99f
        Total devices 1 FS bytes used 85.50GiB
        devid    1 size 200.04GiB used 110.01GiB path /dev/sda5

Label: 'PhoenixRoot'  uuid: 7ba4f981-c2ff-4a70-96a6-4c4b25f96e96
        Total devices 1 FS bytes used 2.00TiB
        devid    1 size 2.71TiB used 2.38TiB path /dev/sdg5

Label: none  uuid: a7e2e4f6-e324-4cf4-8b76-33bb7dedf5d1
        Total devices 1 FS bytes used 384.00KiB
        devid    1 size 2.73TiB used 2.02GiB path /dev/sdab1

checksum verify failed on 120890386268160 found D7319043 wanted 33D22DF5
checksum verify failed on 120890386268160 found 50ECAB17 wanted 2D8EEBCA
checksum verify failed on 120890386268160 found D7319043 wanted 33D22DF5
bytenr mismatch, want=120890386268160, have=65536
Label: 'FSgyroA'  uuid: 4dae41b0-a459-4c20-a09d-0aca9563b9ad
        Total devices 20 FS bytes used 53.15TiB
        devid    1 size 3.64TiB used 3.46TiB path /dev/sdb
        devid    2 size 3.64TiB used 3.46TiB path /dev/sdd
        devid    3 size 3.64TiB used 3.46TiB path /dev/sdc
        devid    4 size 2.73TiB used 2.73TiB path /dev/sdh
        devid    5 size 4.55TiB used 4.50TiB path /dev/sde
        devid    6 size 4.55TiB used 4.50TiB path /dev/sdf
        devid    7 size 4.55TiB used 4.49TiB path /dev/sdi
        devid    8 size 4.55TiB used 4.50TiB path /dev/sdj
        devid    9 size 5.46TiB used 5.19TiB path /dev/sdm
        devid   10 size 5.46TiB used 5.19TiB path /dev/sdn
        devid   11 size 5.46TiB used 5.19TiB path /dev/sds
        devid   12 size 5.46TiB used 5.19TiB path /dev/sdu
        devid   14 size 2.73TiB used 2.73TiB path /dev/sdag
        devid   15 size 2.73TiB used 2.73TiB path /dev/sdz
        devid   16 size 2.73TiB used 2.73TiB path /dev/sdy
        devid   17 size 2.73TiB used 2.73TiB path /dev/sdac
        devid   18 size 2.73TiB used 2.73TiB path /dev/sdaf
        devid   19 size 2.73TiB used 2.73TiB path /dev/sdx
        devid   20 size 2.73TiB used 2.73TiB path /dev/sdad
        *** Some devices missing

pyrogyro ~ # btrfs fi df /PublicA
Data, single: total=107.00GiB, used=84.23GiB
System, single: total=4.00MiB, used=16.00KiB
Metadata, single: total=3.01GiB, used=1.27GiB
GlobalReserve, single: total=448.00MiB, used=0.00B
pyrogyro ~ # dmesg | grep BTRFS
[   20.295632] BTRFS: device label PhoenixRootSSD devid 1 transid
300544 /dev/sda5
[   20.300144] BTRFS info (device sda5): disk space caching is enabled
[   20.300148] BTRFS: has skinny extents
[   20.321855] BTRFS: detected SSD devices, enabling SSD mode
[   20.998071] BTRFS: device label FSgyroA devid 9 transid 625039 /dev/sdm
[   20.999984] BTRFS: device label FSgyroA devid 10 transid 625039 /dev/sdn
[   21.004127] BTRFS: device label FSgyroA devid 11 transid 625039 /dev/sds
[   21.011808] BTRFS: device label FSgyroA devid 12 transid 625039 /dev/sdu
[   21.109647] BTRFS: device label FSgyroA devid 6 transid 625065 /dev/sdf
[   21.130846] BTRFS: device label FSgyroA devid 5 transid 625065 /dev/sde
[   21.131920] BTRFS: device label FSgyroA devid 3 transid 625065 /dev/sdc
[   21.133196] BTRFS: device label FSgyroA devid 17 transid 625065 /dev/sdac
[   21.152346] BTRFS: device label FSgyroA devid 19 transid 625065 /dev/sdx
[   21.158732] BTRFS: device label FSgyroA devid 15 transid 625065 /dev/sdz
[   21.168634] BTRFS: device label FSgyroA devid 20 transid 625065 /dev/sdad
[   21.172592] BTRFS: device label FSgyroA devid 1 transid 625065 /dev/sdb
[   21.173639] BTRFS: device label FSgyroA devid 18 transid 625065 /dev/sdaf
[   21.178384] BTRFS: device label FSgyroA devid 2 transid 625065 /dev/sdd
[   21.212464] BTRFS: device label FSgyroA devid 16 transid 625065 /dev/sdy
[   21.290614] BTRFS: device label FSgyroA devid 7 transid 625065 /dev/sdi
[   21.309370] BTRFS: device label FSgyroA devid 8 transid 625065 /dev/sdj
[   21.372684] BTRFS: device label FSgyroA devid 4 transid 625065 /dev/sdh
[   21.443467] BTRFS: device label FSgyroA devid 14 transid 625065 /dev/sdag
[   21.495110] BTRFS: device fsid a7e2e4f6-e324-4cf4-8b76-33bb7dedf5d1
devid 1 transid 14 /dev/sdab1
[   21.652071] BTRFS: device label PhoenixRoot devid 1 transid 593561 /dev/sdg5
[   29.881428] BTRFS info (device sda5): enabling auto defrag
[   29.881436] BTRFS info (device sda5): disk space caching is enabled
[   30.063829] BTRFS info (device sdg5): enabling auto defrag
[   30.063837] BTRFS info (device sdg5): disk space caching is enabled
[   30.063838] BTRFS: has skinny extents
[  340.714491] BTRFS info (device sdag): disk space caching is enabled
[  340.714496] BTRFS: has skinny extents
[  341.010175] BTRFS: failed to read chunk tree on sdag
[  341.030490] BTRFS: open_ctree failed
[  341.056664] BTRFS info (device sdag): disk space caching is enabled
[  341.056668] BTRFS: has skinny extents
[  341.070958] BTRFS: failed to read chunk tree on sdag
[  341.090538] BTRFS: open_ctree failed
[  341.176337] BTRFS info (device sdag): disk space caching is enabled
[  341.176340] BTRFS: has skinny extents
[  341.181257] BTRFS: failed to read chunk tree on sdag
[  341.193838] BTRFS: open_ctree failed
[  341.301907] BTRFS info (device sdag): disk space caching is enabled
[  341.301911] BTRFS: has skinny extents
[  341.302754] BTRFS: failed to read chunk tree on sdag
[  341.313773] BTRFS: open_ctree failed
[  341.681433] BTRFS info (device sdag): disk space caching is enabled
[  341.681437] BTRFS: has skinny extents
[  341.682436] BTRFS: failed to read chunk tree on sdag
[  341.700410] BTRFS: open_ctree failed
[  342.535884] BTRFS info (device sdag): disk space caching is enabled
[  342.535887] BTRFS: has skinny extents
[  342.536531] BTRFS: failed to read chunk tree on sdag
[  342.550450] BTRFS: open_ctree failed
[  342.562704] BTRFS info (device sdag): disk space caching is enabled
[  342.562708] BTRFS: has skinny extents
[  342.564068] BTRFS: failed to read chunk tree on sdag
[  342.594017] BTRFS: open_ctree failed
[  343.059777] BTRFS info (device sdag): disk space caching is enabled
[  343.059782] BTRFS: has skinny extents
[  343.061271] BTRFS: failed to read chunk tree on sdag
[  343.083753] BTRFS: open_ctree failed
[  343.501960] BTRFS info (device sdag): disk space caching is enabled
[  343.501963] BTRFS: has skinny extents
[  343.506562] BTRFS: failed to read chunk tree on sdag
[  343.520391] BTRFS: open_ctree failed
[  344.010038] BTRFS info (device sdag): disk space caching is enabled
[  344.010042] BTRFS: has skinny extents
[  344.014591] BTRFS: failed to read chunk tree on sdag
[  344.037124] BTRFS: open_ctree failed
[  344.249147] BTRFS info (device sdag): disk space caching is enabled
[  344.249152] BTRFS: has skinny extents
[  344.270668] BTRFS: failed to read chunk tree on sdag
[  344.283740] BTRFS: open_ctree failed
[  344.312789] BTRFS info (device sdab1): disk space caching is enabled
[  344.312793] BTRFS: has skinny extents
[  570.894920] BTRFS info (device sdag): enabling auto recovery
[  570.894926] BTRFS info (device sdag): disabling disk space caching
[  570.894929] BTRFS info (device sdag): force clearing of disk cache
[  570.894931] BTRFS: has skinny extents
[  570.896272] BTRFS: failed to read chunk tree on sdag
[  570.907534] BTRFS: open_ctree failed
[ 6328.239627] BTRFS info (device sdag): enabling auto recovery
[ 6328.239631] BTRFS info (device sdag): allowing degraded mounts
[ 6328.239634] BTRFS info (device sdag): disk space caching is enabled
[ 6328.239635] BTRFS: has skinny extents
[ 6328.271138] BTRFS warning (device sdag): devid 13 uuid
34774574-5c91-4366-a58a-d2c6799fc162 missing
[ 6328.735082] BTRFS info (device sdag): bdev /dev/sdu errs: wr 75, rd
48, flush 0, corrupt 0, gen 0
[ 6328.735089] BTRFS info (device sdag): bdev /dev/sds errs: wr 75, rd
36, flush 0, corrupt 0, gen 0
[ 6328.735094] BTRFS info (device sdag): bdev /dev/sdn errs: wr 75, rd
32, flush 0, corrupt 0, gen 0
[ 6328.735098] BTRFS info (device sdag): bdev /dev/sdm errs: wr 75, rd
22, flush 0, corrupt 0, gen 0
[ 6329.447352] BTRFS error (device sdag): parent transid verify failed
on 120878845526016 wanted 625047 found 624312
[ 6329.516712] BTRFS error (device sdag): bad tree block start
15703682036217976097 120878845526016
[ 6329.516838] BTRFS: Failed to read block groups: -5
[ 6329.559946] BTRFS: open_ctree failed
