Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f66.google.com ([74.125.82.66]:33679 "EHLO
	mail-wg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbbGNBy3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jul 2015 21:54:29 -0400
Received: by wgwk7 with SMTP id k7so31237587wgw.0
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2015 18:54:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$5cbe0$8cc66c0e$aaa41b37$d4ac9035@cox.net>
References: <CAOE4rSxMhwqn49fqPz2knzaRPyvkRr3roFD-JYTcm2rvB-LKkA@mail.gmail.com>
	<pan$5cbe0$8cc66c0e$aaa41b37$d4ac9035@cox.net>
Date: Tue, 14 Jul 2015 04:54:27 +0300
Message-ID: <CAOE4rSzBrvcGBuwiqPm33ZiajnKFYbZvWN-CweUnKQ_J-nFmsg@mail.gmail.com>
Subject: Re: Disk "failed" while doing scrub
From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2015-07-13 11:12 GMT+03:00 Duncan <1i5t5.duncan@cox.net>:
> You say five disk, but nowhere in your post do you mention what raid mode
> you were using, neither do you post btrfs filesystem show and btrfs
> filesystem df, as suggested on the wiki and which list that information.

Sorry, I forgot. I'm running Arch Linux 4.0.7, with btrfs-progs v4.1
Using RAID1 for metadata and single for data, with features
big_metadata, extended_iref, mixed_backref, no_holes, skinny_metadata
and mounted with noatime,compress=zlib,space_cache,autodefrag

Label: 'Data'  uuid: 1ec5b839-acc6-4f70-be9d-6f9e6118c71c
       Total devices 5 FS bytes used 7.16TiB
       devid    1 size 2.73TiB used 2.35TiB path /dev/sdc
       devid    2 size 1.82TiB used 1.44TiB path /dev/sdd
       devid    3 size 1.82TiB used 1.44TiB path /dev/sde
       devid    4 size 1.82TiB used 1.44TiB path /dev/sdg
       devid    5 size 931.51GiB used 539.01GiB path /dev/sdh

Data, single: total=7.15TiB, used=7.15TiB
System, RAID1: total=8.00MiB, used=784.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, RAID1: total=16.00GiB, used=14.37GiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=0.00B


>> Because filesystem still mounts, I assume I should do "btrfs device
>> delete /dev/sdd /mntpoint" and then restore damaged files from backup.
>
> You can try a replace, but with a failing drive still connected, people
> report mixed results.  It's likely to fail as it can't read certain
> blocks to transfer them to the new device.

As I understand, device delete will copy data from that disk and
distribute across rest of disks,
while btrfs replace will copy to new disk which must be atleast size
of disk I'm replacing.
Assuming other existing disks are good, if so, why replace would be
preferable over delete?
because delete could fail, but replace not?


> There's no such partial-file with null-fill tools shipped just yet.
> Those files normally simply trigger errors trying to read them, because
> btrfs won't let you at them if the checksum doesn't verify.

>From journal I have only 14 files mentioned where errors occurred. Now
13 files from
them don't throw any errors and their SHA's match to my backups so they're fine.
And actually btrfs does allow to copy/read that one damaged file, only
I get I/O error
when trying to read data from those broken sectors

kernel: drivers/scsi/mvsas/mv_sas.c 1863:Release slot [0] tag[0], task
[ffff88011c8c9900]:
kernel: drivers/scsi/mvsas/mv_94xx.c 625:command active 00000001,  slot [0].
kernel: sas: sas_ata_task_done: SAS error 8a
kernel: sas: Enter sas_scsi_recover_host busy: 1 failed: 1
kernel: sas: ata9: end_device-7:2: cmd error handler
kernel: sas: ata7: end_device-7:0: dev error handler
kernel: sas: ata14: end_device-7:7: dev error handler
kernel: ata9.00: exception Emask 0x0 SAct 0x4000 SErr 0x0 action 0x0
kernel: ata9.00: failed command: READ FPDMA QUEUED
kernel: ata9.00: cmd 60/00:00:00:33:a1/0f:00:ab:00:00/40 tag 14 ncq 1966080 in
                         res 41/40:00:48:40:a1/00:0f:ab:00:00/00 Emask
0x409 (media error) <F>
kernel: ata9.00: status: { DRDY ERR }
kernel: ata9.00: error: { UNC }
kernel: ata9.00: configured for UDMA/133
kernel: sd 7:0:2:0: [sdd] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x00
driverbyte=0x08
kernel: sd 7:0:2:0: [sdd] tag#0 Sense Key : 0x3 [current] [descriptor]
kernel: sd 7:0:2:0: [sdd] tag#0 ASC=0x11 ASCQ=0x4
kernel: sd 7:0:2:0: [sdd] tag#0 CDB: opcode=0x28 28 00 ab a1 33 00 00 0f 00 00
kernel: blk_update_request: I/O error, dev sdd, sector 2879471688
kernel: ata9: EH complete
kernel: sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1


but all other sectors can be copied fine

$ du -m ./damaged_file
6250 ./damaged_file

$ cp ./damaged_file /tmp/
cp: error reading ‘damaged_file’: Input/output error

$ du -m /tmp/damaged_file
4335    /tmp/damaged_file

cp copies first file part correctly, and I verified that both
start of file (first 4336M) and end of file (last 1890M) SHA's match backup

$ head -c 4336M ./damaged_file | sha256sum
e81b20bfa7358c9f5a0ed165bffe43185abc59e35246e52a7be1d43e6b7e040d  -
$ head -c 4337M ./damaged_file | sha256sum
head: error reading ‘./damaged_file’: Input/output error

$ tail -c 1890M ./damaged_file | sha256sum
941568f4b614077858cb8c8dd262bb431bf4c45eca936af728ecffc95619cb60  -
$ tail -c 1891M ./damaged_file  | sha256sum
tail: error reading ‘./damaged_file’: Input/output error

with dd can also copy almost all file, only using noerror option it
excludes those regions
from target file rather than filling with nulls so this isn't good for recovery

$ dd conv=noerror if=damaged_file of=/tmp/damaged_file
dd: error reading ‘damaged_file’: Input/output error
8880328+0 records in
8880328+0 records out
4546727936 bytes (4,5 GB) copied, 69,7282 s, 65,2 MB/s
dd: error reading ‘damaged_file’: Input/output error
8930824+0 records in
8930824+0 records out
4572581888 bytes (4,6 GB) copied, 113,648 s, 40,2 MB/s
12801720+0 records in
12801720+0 records out
6554480640 bytes (6,6 GB) copied, 223,212 s, 29,4 MB/s

$ du -m /tmp/damaged_file
6251     /tmp/damaged_file


best and correct way to recover a file is using ddrescue

$ ddrescue ./damaged_file /tmp/damaged_file info.log
rescued:     6554 MB,  errsize:    8192 B,  current rate:        0 B/s
  ipos:     4572 MB,   errors:       2,    average rate:   43407 kB/s
  opos:     4572 MB, run time:    2.51 m,  successful read:      34 s ago
Finished
      pos        size  status
0x00000000  0x10F019000  +
0x10F019000  0x00001000  -
0x10F01A000  0x018A8000  +
0x1108C2000  0x00001000  -
0x1108C3000  0x76216000  +

$ du -m /tmp/damaged_file
6251    /tmp/damaged_file

so basically only like 8K bytes are unrecoverable from this file. Probably there
could be created some tool which could get even more data knowing about btrfs.

> There /is/, however, a command that can be used to either regenerate or
> zero-out the checksum tree.  See btrfs check --init-csum-tree.  Current
> versions recalculate the csums, older versions (btrfsck as that was
> before btrfs check) simply zeroed it out.  Then you can read the file
> despite bad checksums, tho you'll still get errors if the block
> physically cannot be read.
>

Seems, you can't specify a path/file for it and it's quite destructive
action if you
want to get data only about some one specific file.

I did scrub second time and this time there aren't that many
uncorrectable errors and
also there's no csum_errors so --init-csum-tree is useless here I think.
Most likely previously scrub got that many errors because it still
continued for a bit even
if disk didn't respond.

scrub status for 1ec5b839-acc6-4f70-be9d-6f9e6118c71c
       scrub resumed at Mon Jul 13 22:24:43 2015 and finished after 02:47:28
       data_extents_scrubbed: 26357534
       tree_extents_scrubbed: 316780
       data_bytes_scrubbed: 1574584311808
       tree_bytes_scrubbed: 5190123520
       read_errors: 2
       csum_errors: 0
       verify_errors: 0
       no_csum: 89600
       csum_discards: 656214
       super_errors: 0
       malloc_errors: 0
       uncorrectable_errors: 2
       unverified_errors: 0
       corrected_errors: 0
       last_physical: 2590041112576

also now, there's i/o errors from device stats which were 0 previously

[/dev/sdd].write_io_errs   0
[/dev/sdd].read_io_errs    123
[/dev/sdd].flush_io_errs   0
[/dev/sdd].corruption_errs 0
[/dev/sdd].generation_errs 0

these are all errors which came from 2nd scrub, only 2 dead sectors

kernel: BTRFS: i/o error at logical 7358423011328 on dev /dev/sdd,
sector 2879471688, root 3034, inode 5619902, offset 4546727936, length
4096, links 1 (path: dir2/damaged_file)
kernel: BTRFS: bdev /dev/sdd errs: wr 0, rd 50, flush 0, corrupt 0, gen 0
kernel: BTRFS: unable to fixup (regular) error at logical
7358423011328 on dev /dev/sdd
kernel: BTRFS: i/o error at logical 7358448869376 on dev /dev/sdd,
sector 2879522192, root 3034, inode 5619902, offset 4572585984, length
4096, links 1 (path: dir2/damaged_file)
kernel: BTRFS: bdev /dev/sdd errs: wr 0, rd 51, flush 0, corrupt 0, gen 0
kernel: BTRFS: unable to fixup (regular) error at logical
7358448869376 on dev /dev/sdd


> There's also btrfs restore, which works on the unmounted filesystem
> without actually writing to it, copying the files it can read to a new
> location, which of course has to be a filesystem with enough room to
> restore the files to, altho it's possible to tell restore to do only
> specific subdirs, for instance.
>

I tried restore for that file, but it's not as good as ddrescue because it
stopped on error even with --ignore-errors flag and seems there aren't option
to continue and try more.

$ btrfs restore -i -x -m -v --path-regex
"^/dir1(|/dir2(|/damaged_file))$" /dev/sdd ./
Restoring ./dir1
Restoring ./dir1/dir2
Restoring ./dir1/dir2/damaged_file
offset is 258048
offset is 212992
offset is 233472
offset is 217088
offset is 237568
Exhausted mirrors trying to read
Error copying data for ./dir1/dir2/damaged_file
Done searching /dir1/dir2/damaged_file
Done searching /dir1/dir2
Done searching /dir1
Done searching

$ du -m ./dir1/dir2/damaged_file
4296    ./dir1/dir2/damaged_file

can see that it got only first half, similar how simple cp does.

> What I'd recommend depends on how complete and how recent your backup
> is.  If it's complete and recent enough, probably the easiest thing is to
> simply blow away the bad filesystem and start over, recovering from the
> backup to a new filesystem.

Actually this time I've 100% complete and up-to-date backups of all
files so I can
freely experiment and try practicing real world recovery which could
be very useful.
So far seems if I didn't had backup I would have lost only 8K bytes.
Why recreate to new filesystem rather than just delete/replace dying
disk? I will still
check if all files are ok, but I don't really see need to recreate
filesystem if files are fine.


by the way I managed to crash btrfs progs, I had scrub running  with -B and then
Xorg crashed (not related to btrfs) and it took down scrub process.
Then I just resumed scrub.
I've stripped symbols so stack trace is totally useless..

#0  0x0000000000418103 in ?? ()
#1  0x000000000040ee82 in main ()


also when I try restore from different root tree it crashes (this is
on 2 disk RAID0)

# btrfs restore -v -t 74579968 /dev/sdk ./
parent transid verify failed on 74579968 wanted 135 found 132
parent transid verify failed on 74579968 wanted 135 found 132
parent transid verify failed on 74579968 wanted 135 found 132
parent transid verify failed on 74579968 wanted 135 found 132
Ignoring transid failure
volumes.c:1554: btrfs_chunk_readonly: Assertion `!ce` failed.
btrfs[0x44c6ce]
btrfs[0x44f426]
btrfs(btrfs_read_block_groups+0x23e)[0x4442de]
btrfs(btrfs_setup_all_roots+0x387)[0x43edd7]
btrfs[0x43f124]
btrfs(open_ctree_fs_info+0x43)[0x43f2b3]
btrfs(cmd_restore+0xb5b)[0x42e77b]
btrfs(main+0x82)[0x40ee82]
/usr/lib/libc.so.6(__libc_start_main+0xf0)[0x7f1090778790]
btrfs(_start+0x29)[0x40ef79]


Thanks for your reply :)
