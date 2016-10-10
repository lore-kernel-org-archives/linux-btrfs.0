Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:35114 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752483AbcJJQEa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Oct 2016 12:04:30 -0400
Received: by mail-it0-f65.google.com with SMTP id l13so6060339itl.2
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Oct 2016 09:04:30 -0700 (PDT)
Received: from DELPHI ([2001:470:c194:1::10])
        by smtp.gmail.com with ESMTPSA id j69sm13473253iod.8.2016.10.10.09.04.27
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 10 Oct 2016 09:04:27 -0700 (PDT)
From: "Jason D. Michaelson" <jasondmichaelson@gmail.com>
To: <linux-btrfs@vger.kernel.org>
Subject: raid6 file system in a bad state
Date: Mon, 10 Oct 2016 11:04:24 -0500
Message-ID: <5cde01d2230f$fa1e3150$ee5a93f0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

At some point in the last week, I had a 6-disk raid6 pool go south on me.
One of the disks had a write problem, unbeknownst to me, which caused the
entire pool and its subvolumes to remount read only.

When this problem occurred I was on debian jessie kernel 3.16.something.
Following list advice I upgraded to the latest in jessie-backports, 4.7.5.
My git clone of btrfs-progs is at commit
81f4d96f3d6368dc4e5edf7e3cb9d19bb4d00c4f

Not knowing the cause of the problem, I unmounted and attempted to remount,
which failed, with the following coming from dmesg:

[308063.610960] BTRFS info (device sda): allowing degraded mounts
[308063.610972] BTRFS info (device sda): disk space caching is enabled
[308063.723461] BTRFS error (device sda): parent transid verify failed on
5752357961728 wanted 161562 found 159746
[308063.815224] BTRFS info (device sda): bdev /dev/sdh errs: wr 261, rd 1,
flush 87, corrupt 0, gen 0
[308063.849613] BTRFS error (device sda): parent transid verify failed on
5752642420736 wanted 161562 found 159786
[308063.881024] BTRFS error (device sda): parent transid verify failed on
5752472338432 wanted 161562 found 159751
[308063.940225] BTRFS error (device sda): parent transid verify failed on
5752478842880 wanted 161562 found 159752
[308063.979517] BTRFS error (device sda): parent transid verify failed on
5752543526912 wanted 161562 found 159764
[308064.012479] BTRFS error (device sda): parent transid verify failed on
5752513036288 wanted 161562 found 159764
[308064.049169] BTRFS error (device sda): parent transid verify failed on
5752642617344 wanted 161562 found 159786
[308064.080507] BTRFS error (device sda): parent transid verify failed on
5752642650112 wanted 161562 found 159786
[308064.138951] BTRFS error (device sda): parent transid verify failed on
5752610603008 wanted 161562 found 159783
[308064.164326] BTRFS error (device sda): bad tree block start
5918360357649457268 5752610603008
[308064.173752] BTRFS error (device sda): bad tree block start
5567295971165396096 5752610603008
[308064.182026] BTRFS error (device sda): failed to read block groups: -5
[308064.234174] BTRFS: open_ctree failed


/dev/sdh is the disc that had the write error

btrfs filesystem show produces this:

root@castor:~/btrfs-progs# btrfs filesystem show
Label: none  uuid: 73ed01df-fb2a-4b27-b6fc-12a57da934bd
        Total devices 6 FS bytes used 6.46TiB
        devid    1 size 2.73TiB used 1.64TiB path /dev/sda
        devid    2 size 2.73TiB used 1.64TiB path /dev/sdh
        devid    3 size 2.73TiB used 1.64TiB path /dev/sdd
        devid    4 size 2.73TiB used 1.64TiB path /dev/sdg
        devid    5 size 2.73TiB used 1.64TiB path /dev/sdf
        devid    6 size 2.73TiB used 1.64TiB path /dev/sde


I just now discovered the raid5/6 checksum bug and am hoping I haven't
somehow hit that, since I haven't actually written much of anything to the
discs in quite a long time (save for a few recently-ripped ISOs that must
have been going there when the sdh write error happened).

While there's a lot of stuff I don't care about on the pool, I've got a lot
of Blu Ray ISOs on it that I'd rather not have to re-rip if I can avoid it
(the backups for those are the original discs in my movie cabinet), plus a
local Debian mirror that I'd rather not have to re-sync.

btrfs restore gives this:

parent transid verify failed on 5752357961728 wanted 161562 found 159746
parent transid verify failed on 5752357961728 wanted 161562 found 159746
checksum verify failed on 5752357961728 found B5CA97C0 wanted 51292A76
checksum verify failed on 5752357961728 found 8582246F wanted B53BE280
checksum verify failed on 5752357961728 found 8582246F wanted B53BE280
bytenr mismatch, want=5752357961728, have=56504706479104
Couldn't setup extent tree
This is a dry-run, no files are going to be restored
Restoring /dev/null/BluRay-StarWars
Restoring /dev/null/BluRay-StarWars/Star Wars 4 A New Hope.iso
Restoring /dev/null/BluRay-StarWars/Star Wars 6 Return of the Jedi.iso
Restoring /dev/null/BluRay-StarWars/Star Wars Bonus Episodes 1 2 3.iso
Restoring /dev/null/BluRay-StarWars/Star Wars 5 The Empire Strikes Back.iso
Restoring /dev/null/BluRay-StarWars/Star Wars Spoofs and Documentaries.iso
Restoring /dev/null/BluRay-StarWars/Star Wars Bonus Episodes 4 5 6.iso
Restoring /dev/null/BluRay-StarWars/Star Wars 1 The Phantom Menace.iso
Restoring /dev/null/BluRay-StarWars/Star Wars 2 Attack of the Clones.iso
Restoring /dev/null/BluRay-StarWars/Star Wars 3 Revenge of the Sith.iso
Found objectid=257, key=256
Done searching /BluRay-StarWars
Restoring /dev/null/BluRay-HarryPotter
Restoring /dev/null/BluRay-HarryPotter/Year 1 Harry Potter and the Sorcerers
Stone.iso
Restoring /dev/null/BluRay-HarryPotter/Year 2 Harry Potter and the Chamber
of Secrets.iso
Restoring /dev/null/BluRay-HarryPotter/Year 3 Harry Potter and the Prizoner
of Azkaban.iso
Restoring /dev/null/BluRay-HarryPotter/Year 4 Harry Potter and the Goblet of
Fire.iso
Restoring /dev/null/BluRay-HarryPotter/Year 5 Harry Potter and the Order of
the Phoenix.iso
Found objectid=257, key=256
Done searching /BluRay-HarryPotter
Restoring /dev/null/BluRay-DowntonAbbey
Restoring /dev/null/BluRay-DowntonAbbey/Downton Abbey Season 1 Disc 1.iso
Restoring /dev/null/BluRay-DowntonAbbey/Downton Abbey Season 1 Disc 2.iso
Restoring /dev/null/BluRay-DowntonAbbey/Downton Abbey Season 2 Disc 1.iso
Restoring /dev/null/BluRay-DowntonAbbey/Downton Abbey Season 2 Disc 2.iso
Restoring /dev/null/BluRay-DowntonAbbey/Downton Abbey Season 2 Disc 3.iso
Restoring /dev/null/BluRay-DowntonAbbey/Downton Abbey Season 3 Disc 1.iso
Restoring /dev/null/BluRay-DowntonAbbey/Downton Abbey Season 3 Disc 2.iso
Restoring /dev/null/BluRay-DowntonAbbey/Downton Abbey Season 3 Disc 3.iso
Found objectid=257, key=256
Done searching /BluRay-DowntonAbbey


And there's a lot of stuff in here in the output that I don't really care
about so moving on to the end:

Restoring /dev/null/root/Software
Found objectid=304888, key=257402
Done searching /root/Software
Found objectid=257, key=256
Done searching /root
parent transid verify failed on 5752616845312 wanted 161562 found 159784
parent transid verify failed on 5752616845312 wanted 161562 found 159784
checksum verify failed on 5752616845312 found 0EB38D74 wanted 1BB07DCA
checksum verify failed on 5752616845312 found B4E0DBD6 wanted DD91E4E9
checksum verify failed on 5752616845312 found B4E0DBD6 wanted DD91E4E9
bytenr mismatch, want=5752616845312, have=857463135251540499
Error reading subvolume /dev/null/BluRay-Disney: 18446744073709551611



After reading some of the suggestions, I attempted a btrfs rescue
chunk-recover, which results in a SIGBUS error ~40% through the process:

root@castor:~/btrfs-progs#  gdb --args ./btrfs rescue chunk-recover -vvvv
/dev/sda
GNU gdb (Debian 7.7.1+dfsg-5) 7.7.1
Copyright (C) 2014 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later
<http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/>.
For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from ./btrfs...done.
(gdb) r
Starting program: /root/btrfs-progs/btrfs rescue chunk-recover -vvvv
/dev/sda
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
All Devices:
        Device: id = 2, name = /dev/sdh
        Device: id = 3, name = /dev/sdd
        Device: id = 5, name = /dev/sdf
        Device: id = 6, name = /dev/sde
        Device: id = 4, name = /dev/sdg
        Device: id = 1, name = /dev/sda

[New Thread 0x7ffff6f91700 (LWP 14913)]
[New Thread 0x7ffff6790700 (LWP 14914)]
[New Thread 0x7ffff5f8f700 (LWP 14915)]
[New Thread 0x7ffff578e700 (LWP 14916)]
[New Thread 0x7ffff4f8d700 (LWP 14917)]
[New Thread 0x7fffe7fff700 (LWP 14918)]
Scanning: 449541562368 in dev0, 689038929920 in dev1, 681330704384 in dev2,
669722726400 in dev3, 681526239232 in dev4, 675649212416 in dev5[Thread
0x7ffff6f91700 (LWP 14913) exited]
Scanning: DONE in dev0, 1203854462976 in dev1, 1209906450432 in dev2,
1194740371456 in dev3, 1211076476928 in dev4, 1212511375360 in dev5
Program received signal SIGBUS, Bus error.
[Switching to Thread 0x7ffff4f8d700 (LWP 14917)]
btrfs_new_block_group_record (leaf=leaf@entry=0x7fffdc0008c0,
key=key@entry=0x7ffff4f8ccb0, slot=slot@entry=30) at cmds-check.c:5258
5258            rec->flags = btrfs_disk_block_group_flags(leaf, ptr);
(gdb) p leaf
p $1 = (struct extent_buffer *) 0x7fffdc0008c0
(gdb) p ptr
$2 = (struct btrfs_block_group_item *) 0x68eb1bad
(gdb) p *leaf
$3 = {cache_node = {rb_node = {__rb_parent_color = 0, rb_right = 0x0,
rb_left = 0x0}, objectid = 0, start = 0, size = 0}, start = 0, dev_bytenr =
0,
  len = 16384, tree = 0x0, lru = {next = 0x0, prev = 0x0}, recow = {next =
0x0, prev = 0x0}, refs = 0, flags = 0, fd = 0, data = 0x7fffdc000940
"5\f\004\n"}
(gdb) p *ptr
Cannot access memory at address 0x68eb1bad
(gdb) bt
#0  btrfs_new_block_group_record (leaf=leaf@entry=0x7fffdc0008c0,
key=key@entry=0x7ffff4f8ccb0, slot=slot@entry=30) at cmds-check.c:5258
#1  0x0000000000434c2f in process_block_group_item (slot=30,
key=0x7ffff4f8ccb0, leaf=0x7fffdc0008c0, bg_cache=0x7fffffffe998) at
chunk-recover.c:232
#2  extract_metadata_record (rc=rc@entry=0x7fffffffe960,
leaf=leaf@entry=0x7fffdc0008c0) at chunk-recover.c:717
#3  0x000000000043538c in scan_one_device (dev_scan_struct=0x6a6450) at
chunk-recover.c:807
#4  0x00007ffff73450a4 in start_thread (arg=0x7ffff4f8d700) at
pthread_create.c:309
#5  0x00007ffff707a62d in clone () at
../sysdeps/unix/sysv/linux/x86_64/clone.S:111


I was disappointed to see dev0 (which corresponds to /dev/sdh) come out as
DONE because of these dmesg entries:

[232572.871164] mpt2sas_cm0: log_info(0x31080000): originator(PL),
code(0x08), sub_code(0x0000)
[232572.871185] sd 0:0:8:0: [sdh] tag#4 CDB: Read(16) 88 00 00 00 00 00 34
55 61 c0 00 00 01 00 00 00
[232572.871190] mpt2sas_cm0:    sas_address(0x50030480002e5946), phy(6)
[232572.871193] mpt2sas_cm0:
enclosure_logical_id(0x50030442523a2033),slot(2)
[232572.871197] mpt2sas_cm0:    handle(0x0012), ioc_status(success)(0x0000),
smid(36)
[232572.871200] mpt2sas_cm0:    request_len(131072), underflow(131072),
resid(131072)
[232572.871202] mpt2sas_cm0:    tag(1), transfer_count(0),
sc->result(0x00000000)
[232572.871205] mpt2sas_cm0:    scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[232572.871208] mpt2sas_cm0:    [sense_key,asc,ascq]: [0x03,0x11,0x00],
count(18)
[232572.871239] sd 0:0:8:0: [sdh] tag#4 FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[232572.871243] sd 0:0:8:0: [sdh] tag#4 Sense Key : Medium Error [current]
[232572.871248] sd 0:0:8:0: [sdh] tag#4 Add. Sense: Unrecovered read error
[232572.871252] sd 0:0:8:0: [sdh] tag#4 CDB: Read(16) 88 00 00 00 00 00 34
55 61 c0 00 00 01 00 00 00
[232572.871256] blk_update_request: critical medium error, dev sdh, sector
878010816
[232578.796809] mpt2sas_cm0: log_info(0x31080000): originator(PL),
code(0x08), sub_code(0x0000)
[232578.796838] sd 0:0:8:0: [sdh] tag#4 CDB: Read(16) 88 00 00 00 00 00 34
55 61 f0 00 00 00 40 00 00
[232578.796845] mpt2sas_cm0:    sas_address(0x50030480002e5946), phy(6)
[232578.796850] mpt2sas_cm0:
enclosure_logical_id(0x50030442523a2033),slot(2)
[232578.796856] mpt2sas_cm0:    handle(0x0012), ioc_status(success)(0x0000),
smid(36)
[232578.796860] mpt2sas_cm0:    request_len(32768), underflow(32768),
resid(0)
[232578.796864] mpt2sas_cm0:    tag(0), transfer_count(32768),
sc->result(0x00000000)
[232578.796869] mpt2sas_cm0:    scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[232578.796874] mpt2sas_cm0:    [sense_key,asc,ascq]: [0x03,0x11,0x00],
count(18)
[232578.797129] sd 0:0:8:0: [sdh] tag#4 FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[232578.797138] sd 0:0:8:0: [sdh] tag#4 Sense Key : Medium Error [current]
[232578.797146] sd 0:0:8:0: [sdh] tag#4 Add. Sense: Unrecovered read error
[232578.797154] sd 0:0:8:0: [sdh] tag#4 CDB: Read(16) 88 00 00 00 00 00 34
55 61 f0 00 00 00 40 00 00
[232578.797160] blk_update_request: critical medium error, dev sdh, sector
878010888
[232581.663794] mpt2sas_cm0: log_info(0x31080000): originator(PL),
code(0x08), sub_code(0x0000)
[232581.663823] sd 0:0:8:0: [sdh] tag#1 CDB: Read(16) 88 00 00 00 00 00 34
55 62 30 00 00 00 80 00 00
[232581.663830] mpt2sas_cm0:    sas_address(0x50030480002e5946), phy(6)
[232581.663835] mpt2sas_cm0:
enclosure_logical_id(0x50030442523a2033),slot(2)
[232581.663841] mpt2sas_cm0:    handle(0x0012), ioc_status(success)(0x0000),
smid(62)
[232581.663845] mpt2sas_cm0:    request_len(65536), underflow(65536),
resid(65536)
[232581.663849] mpt2sas_cm0:    tag(0), transfer_count(0),
sc->result(0x00000000)
[232581.663854] mpt2sas_cm0:    scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[232581.663859] mpt2sas_cm0:    [sense_key,asc,ascq]: [0x03,0x11,0x00],
count(18)
[232581.663918] sd 0:0:8:0: [sdh] tag#1 FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[232581.663937] sd 0:0:8:0: [sdh] tag#1 Sense Key : Medium Error [current]
[232581.663951] sd 0:0:8:0: [sdh] tag#1 Add. Sense: Unrecovered read error
[232581.663960] sd 0:0:8:0: [sdh] tag#1 CDB: Read(16) 88 00 00 00 00 00 34
55 62 30 00 00 00 80 00 00
[232581.663967] blk_update_request: critical medium error, dev sdh, sector
878010928
[232584.622191] sd 0:0:8:0: [sdh] tag#0 CDB: Read(16) 88 00 00 00 00 00 34
55 62 08 00 00 00 08 00 00
[232584.622207] mpt2sas_cm0:    sas_address(0x50030480002e5946), phy(6)
[232584.622213] mpt2sas_cm0:
enclosure_logical_id(0x50030442523a2033),slot(2)
[232584.622219] mpt2sas_cm0:    handle(0x0012), ioc_status(success)(0x0000),
smid(55)
[232584.622224] mpt2sas_cm0:    request_len(4096), underflow(4096),
resid(4096)
[232584.622228] mpt2sas_cm0:    tag(0), transfer_count(0),
sc->result(0x00000000)
[232584.622233] mpt2sas_cm0:    scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[232584.622237] mpt2sas_cm0:    [sense_key,asc,ascq]: [0x03,0x11,0x00],
count(18)
[232584.622272] sd 0:0:8:0: [sdh] tag#0 FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[232584.622282] sd 0:0:8:0: [sdh] tag#0 Sense Key : Medium Error [current]
[232584.622295] sd 0:0:8:0: [sdh] tag#0 Add. Sense: Unrecovered read error
[232584.622304] sd 0:0:8:0: [sdh] tag#0 CDB: Read(16) 88 00 00 00 00 00 34
55 62 08 00 00 00 08 00 00
[232584.622311] blk_update_request: critical medium error, dev sdh, sector
878010888
[232584.630625] Buffer I/O error on dev sdh, logical block 109751361, async
page read


rather than moving on but that's neither here nor there, since the disc
really can't be trusted as it is.

btrfs check produces this output:

root@castor:~/btrfs-progs# ./btrfs check --readonly /dev/sda
parent transid verify failed on 5752357961728 wanted 161562 found 159746
parent transid verify failed on 5752357961728 wanted 161562 found 159746
checksum verify failed on 5752357961728 found B5CA97C0 wanted 51292A76
checksum verify failed on 5752357961728 found 8582246F wanted B53BE280
checksum verify failed on 5752357961728 found 8582246F wanted B53BE280
bytenr mismatch, want=5752357961728, have=56504706479104
Couldn't setup extent tree
ERROR: cannot open file system



Like I said, the vast majority of what's on this disc is either BluRay ISOs
that I can re-rip, stuff I don't care about recovering, or stuff that I can
always re-mirror if I have to. Given that I'm well versed in C programming,
I'd much rather devote my time to working with the code to resolve whatever
problem may be happening here than re-acquiring or re-ripping what's on that
pool.

Since it took somewhere near an hour and a half to get to that SIGBUS in
gdb, I've left my session open for anyone who may have ideas to chime in.
Just let me know what information you need!

Thanks


Jason Michaelson

