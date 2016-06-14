Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34731 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbcFNOfP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 10:35:15 -0400
Received: by mail-lf0-f66.google.com with SMTP id l184so4301686lfl.1
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jun 2016 07:35:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <575E3BDD.5000405@gmail.com>
References: <CACvw6BEt1bkXaB=G27beS+H1UcMVk-Fkko3s3Y08dq_CyNGP4g@mail.gmail.com>
 <CAPmG0jZxM65Fn3WsUMEO-EJ8oVEEW7DT=S09q2fLv8cXkoqUGA@mail.gmail.com> <575E3BDD.5000405@gmail.com>
From: =?UTF-8?Q?Maximilian_B=C3=B6hm?= <winlux@gmail.com>
Date: Tue, 14 Jun 2016 16:34:53 +0200
Message-ID: <CACvw6BELVbF=f5o=imwUSbcandY0imWZNq676Fi6ouxU6Q35-A@mail.gmail.com>
Subject: Re: dd on wrong device, 1.9 GiB from the beginning has been
 overwritten, how to restore partition?
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wow, I'm overwhelmed, thank you very much for your help!

So, firstly I did a
dd if=/dev/zero of=nullz.raw bs=1 count=0 seek=2028060672
and overwrote the ISO on the HDD.

Then I was able to restore the GPT using gdisk with "use backup GPT
header (rebuilding main)". Now I have an intact GPT, a displayed
partition with original name, and an unknown filesystem.

btrfs check --repair /dev/sdc1
and
btrfs-show-super /dev/sdc1 --all

still don't work.

But I btrfs-show-super now finds the third superblock (see at the
bottom of this mail).

Then I tried btrfs restore with -u (superblock 3, because it's 0, 1, 2):

$ losetup /dev/loop1 -o 1M /dev/sdc
$ btrfs restore /dev/loop1 -l -u 2
checksum verify failed on 21004288 found E4E3BDB6 wanted 00000000
checksum verify failed on 21004288 found E4E3BDB6 wanted 00000000
checksum verify failed on 21004288 found E4E3BDB6 wanted 00000000
checksum verify failed on 21004288 found E4E3BDB6 wanted 00000000
bytenr mismatch, want=21004288, have=0
ERROR: cannot read chunk root
Could not open root, trying backup super

Hm, doesn't "-u 2" defines the backup superblock 3?


$ btrfsck /dev/loop1
No valid Btrfs found on /dev/loop1
Couldn't open file system

BTW, Photorecs finds lots of files but e.g. MKV video are corrupted in
some form that they don't want to play but KDE's Dolphin is able to
generate previews in some cases.
Any idea about how I should proceed further?




$ btrfs-show-super /dev/sdc1 --all
superblock: bytenr=65536, device=/dev/sdc1
---------------------------------------------------------
ERROR: bad magic on superblock on /dev/sdc1 at 65536

superblock: bytenr=67108864, device=/dev/sdc1
---------------------------------------------------------
ERROR: bad magic on superblock on /dev/sdc1 at 67108864

superblock: bytenr=274877906944, device=/dev/sdc1
---------------------------------------------------------
csum                    0x615e669a [match]
bytenr                  274877906944
flags                   0x1
                        ( WRITTEN )
magic                   _BHRfS_M [match]
fsid                    446c7a9c-fcad-42f2-b093-ee495ca8f5be
label                   Speicherschatz
generation              5503
root                    5113205555200
sys_array_size          129
chunk_root_generation   5485
root_level              1
chunk_root              21004288
chunk_root_level        1
log_root                0
log_root_transid        0
log_root_level          0
total_bytes             8001561821184
bytes_used              6272827662336
sectorsize              4096
nodesize                16384
leafsize                16384
stripesize              4096
root_dir                6
num_devices             1
compat_flags            0x0
compat_ro_flags         0x0
incompat_flags          0x169
                        ( MIXED_BACKREF |
                          COMPRESS_LZO |
                          BIG_METADATA |
                          EXTENDED_IREF |
                          SKINNY_METADATA )
csum_type               0
csum_size               4
cache_generation        5503
uuid_tree_generation    5503
dev_item.uuid           0471bf89-89d1-424a-9fc1-d48241ff453b
dev_item.fsid           446c7a9c-fcad-42f2-b093-ee495ca8f5be [match]
dev_item.type           0
dev_item.total_bytes    8001561821184
dev_item.bytes_used     6283562319872
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          1
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0
