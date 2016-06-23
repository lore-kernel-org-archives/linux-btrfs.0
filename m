Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38028 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbcFWPRv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 11:17:51 -0400
Received: by mail-wm0-f41.google.com with SMTP id r201so54820960wme.1
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 08:17:50 -0700 (PDT)
Received: from [84.250.218.2] (dsl-kpobrasgw1-54fada-2.dhcp.inet.fi. [84.250.218.2])
        by smtp.gmail.com with ESMTPSA id f73sm6179679wmg.1.2016.06.23.08.17.48
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Jun 2016 08:17:48 -0700 (PDT)
From: Jussi Kansanen <jussi.kansanen@gmail.com>
Subject: Scrub not fixing checksum errors on RAID6
To: linux-btrfs@vger.kernel.org
Message-ID: <0c0d5c8f-af85-6e4d-83b4-e11bb811dc5d@gmail.com>
Date: Thu, 23 Jun 2016 18:17:46 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Scrub found some checksum errors on my RAID6, errors are said to be fixed but
every scrub results in identical errors. Any ideas why this is happening? The
HDD seems to be working OK, no IO errors, no SMART errors and it passed SMART
long-test.

Latest scrub was run with 4.6.2 kernel & 4.6 btrfs progs. Earlier runs where
done with 4.5.x & 4.6 with up to date btrfs progs (at the time).

This is after 3rd attempt (previous errors are identical):

BTRFS warning (device dm-6): checksum error at logical 10994876289024 on dev
/dev/mapper/crypt_sdk1, sector 3131104392, root 8265, inode 138347, offset
16846848, length 4096, links 1 (path: path/file1)
BTRFS warning (device dm-6): checksum error at logical 10994876289024 on dev
/dev/mapper/crypt_sdk1, sector 3131104392, root 8260, inode 138347, offset
16846848, length 4096, links 1 (path: path/file1)
BTRFS warning (device dm-6): checksum error at logical 10994876289024 on dev
/dev/mapper/crypt_sdk1, sector 3131104392, root 5, inode 138347, offset
16846848, length 4096, links 1 (path: path/file1)
BTRFS error (device dm-6): bdev /dev/mapper/crypt_sdk1 errs: wr 0, rd 0, flush
0, corrupt 11, gen 0
BTRFS error (device dm-6): fixed up error at logical 10994876289024 on dev
/dev/mapper/crypt_sdk1

BTRFS warning (device dm-6): checksum error at logical 10994876293120 on dev
/dev/mapper/crypt_sdk1, sector 3131104400, root 8265, inode 138347, offset
16850944, length 4096, links 1 (path: path/file1)
BTRFS warning (device dm-6): checksum error at logical 10994876293120 on dev
/dev/mapper/crypt_sdk1, sector 3131104400, root 8260, inode 138347, offset
16850944, length 4096, links 1 (path: path/file1)
BTRFS warning (device dm-6): checksum error at logical 10994876293120 on dev
/dev/mapper/crypt_sdk1, sector 3131104400, root 5, inode 138347, offset
16850944, length 4096, links 1 (path: path/file1)
BTRFS error (device dm-6): bdev /dev/mapper/crypt_sdk1 errs: wr 0, rd 0, flush
0, corrupt 12, gen 0
BTRFS error (device dm-6): fixed up error at logical 10994876293120 on dev
/dev/mapper/crypt_sdk1

BTRFS warning (device dm-6): checksum error at logical 10994876297216 on dev
/dev/mapper/crypt_sdk1, sector 3131104408, root 8265, inode 138347, offset
16855040, length 4096, links 1 (path: path/file1)
BTRFS warning (device dm-6): checksum error at logical 10994876297216 on dev
/dev/mapper/crypt_sdk1, sector 3131104408, root 8260, inode 138347, offset
16855040, length 4096, links 1 (path: path/file1)
BTRFS warning (device dm-6): checksum error at logical 10994876297216 on dev
/dev/mapper/crypt_sdk1, sector 3131104408, root 5, inode 138347, offset
16855040, length 4096, links 1 (path: path/file1)
BTRFS error (device dm-6): bdev /dev/mapper/crypt_sdk1 errs: wr 0, rd 0, flush
0, corrupt 13, gen 0
BTRFS error (device dm-6): fixed up error at logical 10994876297216 on dev
/dev/mapper/crypt_sdk1

BTRFS warning (device dm-6): checksum error at logical 10994876301312 on dev
/dev/mapper/crypt_sdk1, sector 3131104416, root 8265, inode 138347, offset
16859136, length 4096, links 1 (path: path/file1)
BTRFS warning (device dm-6): checksum error at logical 10994876301312 on dev
/dev/mapper/crypt_sdk1, sector 3131104416, root 8260, inode 138347, offset
16859136, length 4096, links 1 (path: path/file1)
BTRFS warning (device dm-6): checksum error at logical 10994876301312 on dev
/dev/mapper/crypt_sdk1, sector 3131104416, root 5, inode 138347, offset
16859136, length 4096, links 1 (path: path/file1)
BTRFS error (device dm-6): bdev /dev/mapper/crypt_sdk1 errs: wr 0, rd 0, flush
0, corrupt 14, gen 0
BTRFS error (device dm-6): fixed up error at logical 10994876301312 on dev
/dev/mapper/crypt_sdk1

BTRFS warning (device dm-6): checksum error at logical 10994876305408 on dev
/dev/mapper/crypt_sdk1, sector 3131104424, root 8265, inode 138347, offset
16863232, length 4096, links 1 (path: path/file1)
BTRFS warning (device dm-6): checksum error at logical 10994876305408 on dev
/dev/mapper/crypt_sdk1, sector 3131104424, root 8260, inode 138347, offset
16863232, length 4096, links 1 (path: path/file1)
BTRFS warning (device dm-6): checksum error at logical 10994876305408 on dev
/dev/mapper/crypt_sdk1, sector 3131104424, root 5, inode 138347, offset
16863232, length 4096, links 1 (path: path/file1)
BTRFS error (device dm-6): bdev /dev/mapper/crypt_sdk1 errs: wr 0, rd 0, flush
0, corrupt 15, gen 0
BTRFS error (device dm-6): fixed up error at logical 10994876305408 on dev
/dev/mapper/crypt_sdk1


btrfs dev stats /storage/
[/dev/mapper/crypt_sde1].write_io_errs   0
[/dev/mapper/crypt_sde1].read_io_errs    0
[/dev/mapper/crypt_sde1].flush_io_errs   0
[/dev/mapper/crypt_sde1].corruption_errs 0
[/dev/mapper/crypt_sde1].generation_errs 0
[/dev/mapper/crypt_sdb1].write_io_errs   0
[/dev/mapper/crypt_sdb1].read_io_errs    0
[/dev/mapper/crypt_sdb1].flush_io_errs   0
[/dev/mapper/crypt_sdb1].corruption_errs 0
[/dev/mapper/crypt_sdb1].generation_errs 0
[/dev/mapper/crypt_sdc1].write_io_errs   0
[/dev/mapper/crypt_sdc1].read_io_errs    0
[/dev/mapper/crypt_sdc1].flush_io_errs   0
[/dev/mapper/crypt_sdc1].corruption_errs 0
[/dev/mapper/crypt_sdc1].generation_errs 0
[/dev/mapper/crypt_sdk1].write_io_errs   0
[/dev/mapper/crypt_sdk1].read_io_errs    0
[/dev/mapper/crypt_sdk1].flush_io_errs   0
[/dev/mapper/crypt_sdk1].corruption_errs 15
[/dev/mapper/crypt_sdk1].generation_errs 0
[/dev/mapper/crypt_sdd1].write_io_errs   0
[/dev/mapper/crypt_sdd1].read_io_errs    0
[/dev/mapper/crypt_sdd1].flush_io_errs   0
[/dev/mapper/crypt_sdd1].corruption_errs 0
[/dev/mapper/crypt_sdd1].generation_errs 0
[/dev/mapper/crypt_sdf1].write_io_errs   0
[/dev/mapper/crypt_sdf1].read_io_errs    0
[/dev/mapper/crypt_sdf1].flush_io_errs   0
[/dev/mapper/crypt_sdf1].corruption_errs 0
[/dev/mapper/crypt_sdf1].generation_errs 0


/dev/mapper/crypt_sde1 on /storage type btrfs
(rw,noatime,compress=lzo,noacl,space_cache,subvolid=5,subvol=/)

