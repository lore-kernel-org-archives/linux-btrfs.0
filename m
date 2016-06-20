Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36710 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbcFTOZp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jun 2016 10:25:45 -0400
Received: by mail-wm0-f49.google.com with SMTP id f126so71713822wma.1
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jun 2016 07:24:35 -0700 (PDT)
Received: from [10.3.41.144] ([109.201.143.216])
        by smtp.googlemail.com with ESMTPSA id e8sm13891453wma.2.2016.06.20.07.24.32
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Mon, 20 Jun 2016 07:24:32 -0700 (PDT)
Subject: Re: dd on wrong device, 1.9 GiB from the beginning has been
 overwritten, how to restore partition?
References: <CACvw6BEt1bkXaB=G27beS+H1UcMVk-Fkko3s3Y08dq_CyNGP4g@mail.gmail.com>
 <CAPmG0jZxM65Fn3WsUMEO-EJ8oVEEW7DT=S09q2fLv8cXkoqUGA@mail.gmail.com>
 <575E3BDD.5000405@gmail.com>
 <CACvw6BELVbF=f5o=imwUSbcandY0imWZNq676Fi6ouxU6Q35-A@mail.gmail.com>
From: =?UTF-8?Q?Maximilian_B=c3=b6hm?= <winlux@gmail.com>
To: linux-btrfs@vger.kernel.org
Message-ID: <29c3f726-fa94-ddf4-d97b-43d69536de16@gmail.com>
Date: Mon, 20 Jun 2016 16:24:32 +0200
MIME-Version: 1.0
In-Reply-To: <CACvw6BELVbF=f5o=imwUSbcandY0imWZNq676Fi6ouxU6Q35-A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey, I want you to know that it was impossible to recover the filesystem and that I have recreated the partition. Lost ~1.5 TiB unredundant data but it's just an annoyance, no catastrophe – I can recreate my collection and it wasn't any critical data.

For others with related problems: My latest attempt was to recover the superblock and metadata:

$ btrfs rescue super-recover -v /dev/sdc1
All Devices:
        Device: id = 1, name = /dev/sdc1

Before Recovering:
        [All good supers]:
                device name = /dev/sdc1
                superblock bytenr = 274877906944

        [All bad supers]:
                device name = /dev/sdc1
                superblock bytenr = 65536

                device name = /dev/sdc1
                superblock bytenr = 67108864


Make sure this is a btrfs disk otherwise the tool will destroy other fs, Are you sure? [y/N]: y
checksum verify failed on 21004288 found E4E3BDB6 wanted 00000000
checksum verify failed on 21004288 found E4E3BDB6 wanted 00000000
checksum verify failed on 21004288 found E4E3BDB6 wanted 00000000
checksum verify failed on 21004288 found E4E3BDB6 wanted 00000000
bytenr mismatch, want=21004288, have=0
ERROR: cannot read chunk root
Failed to recover bad superblocks
*** Error in `btrfs': double free or corruption (fasttop): 0x0000000000946010 ***
======= Backtrace: =========
/usr/lib/libc.so.6(+0x6ed4b)[0x7fa620c8cd4b]
/usr/lib/libc.so.6(+0x74546)[0x7fa620c92546]
/usr/lib/libc.so.6(+0x74d1e)[0x7fa620c92d1e]
btrfs(btrfs_close_devices+0xf7)[0x456227]
btrfs(btrfs_recover_superblocks+0x459)[0x437729]
btrfs(main+0x7b)[0x40ac3b]
/usr/lib/libc.so.6(__libc_start_main+0xf1)[0x7fa620c3e741]
btrfs(_start+0x29)[0x40ad39]
======= Memory map: ========
00400000-00495000 r-xp 00000000 00:13 4097939                            /usr/bin/btrfs
00694000-00698000 r--p 00094000 00:13 4097939                            /usr/bin/btrfs
00698000-0069a000 rw-p 00098000 00:13 4097939                            /usr/bin/btrfs
0069a000-0069f000 rw-p 00000000 00:00 0
00946000-00967000 rw-p 00000000 00:00 0                                  [heap]
7fa61c000000-7fa61c021000 rw-p 00000000 00:00 0
7fa61c021000-7fa620000000 ---p 00000000 00:00 0
7fa620a06000-7fa620a1c000 r-xp 00000000 00:13 3704352                    /usr/lib/libgcc_s.so.1
7fa620a1c000-7fa620c1b000 ---p 00016000 00:13 3704352                    /usr/lib/libgcc_s.so.1
7fa620c1b000-7fa620c1c000 rw-p 00015000 00:13 3704352                    /usr/lib/libgcc_s.so.1
7fa620c1e000-7fa620db5000 r-xp 00000000 00:13 3867364                    /usr/lib/libc-2.23.so
7fa620db5000-7fa620fb5000 ---p 00197000 00:13 3867364                    /usr/lib/libc-2.23.so
7fa620fb5000-7fa620fb9000 r--p 00197000 00:13 3867364                    /usr/lib/libc-2.23.so
7fa620fb9000-7fa620fbb000 rw-p 0019b000 00:13 3867364                    /usr/lib/libc-2.23.so
7fa620fbb000-7fa620fbf000 rw-p 00000000 00:00 0
7fa620fc6000-7fa620fde000 r-xp 00000000 00:13 3867345                    /usr/lib/libpthread-2.23.so
7fa620fde000-7fa6211dd000 ---p 00018000 00:13 3867345                    /usr/lib/libpthread-2.23.so
7fa6211dd000-7fa6211de000 r--p 00017000 00:13 3867345                    /usr/lib/libpthread-2.23.so
7fa6211de000-7fa6211df000 rw-p 00018000 00:13 3867345                    /usr/lib/libpthread-2.23.so
7fa6211df000-7fa6211e3000 rw-p 00000000 00:00 0
7fa6211e6000-7fa621207000 r-xp 00000000 00:13 6889                       /usr/lib/liblzo2.so.2.0.0
7fa621207000-7fa621406000 ---p 00021000 00:13 6889                       /usr/lib/liblzo2.so.2.0.0
7fa621406000-7fa621407000 r--p 00020000 00:13 6889                       /usr/lib/liblzo2.so.2.0.0
7fa621407000-7fa621408000 rw-p 00021000 00:13 6889                       /usr/lib/liblzo2.so.2.0.0
7fa62140e000-7fa621423000 r-xp 00000000 00:13 7051                       /usr/lib/libz.so.1.2.8
7fa621423000-7fa621622000 ---p 00015000 00:13 7051                       /usr/lib/libz.so.1.2.8
7fa621622000-7fa621623000 r--p 00014000 00:13 7051                       /usr/lib/libz.so.1.2.8
7fa621623000-7fa621624000 rw-p 00015000 00:13 7051                       /usr/lib/libz.so.1.2.8
7fa621626000-7fa621664000 r-xp 00000000 00:13 3436728                    /usr/lib/libblkid.so.1.1.0
7fa621664000-7fa621863000 ---p 0003e000 00:13 3436728                    /usr/lib/libblkid.so.1.1.0
7fa621863000-7fa621867000 r--p 0003d000 00:13 3436728                    /usr/lib/libblkid.so.1.1.0
7fa621867000-7fa621868000 rw-p 00041000 00:13 3436728                    /usr/lib/libblkid.so.1.1.0
7fa621868000-7fa621869000 rw-p 00000000 00:00 0
7fa62186e000-7fa621872000 r-xp 00000000 00:13 3436727                    /usr/lib/libuuid.so.1.3.0
7fa621872000-7fa621a71000 ---p 00004000 00:13 3436727                    /usr/lib/libuuid.so.1.3.0
7fa621a71000-7fa621a72000 r--p 00003000 00:13 3436727                    /usr/lib/libuuid.so.1.3.0
7fa621a72000-7fa621a73000 rw-p 00004000 00:13 3436727                    /usr/lib/libuuid.so.1.3.0
7fa621a76000-7fa621a99000 r-xp 00000000 00:13 3867363                    /usr/lib/ld-2.23.so
7fa621c95000-7fa621c99000 rw-p 00000000 00:00 0
7fa621c99000-7fa621c9a000 r--p 00023000 00:13 3867363                    /usr/lib/ld-2.23.so
7fa621c9a000-7fa621c9b000 rw-p 00024000 00:13 3867363                    /usr/lib/ld-2.23.so
7fa621c9b000-7fa621c9d000 rw-p 00000000 00:00 0
7fa621c9d000-7fa621c9f000 rw-p 00000000 00:00 0
7ffd2178f000-7ffd217b0000 rw-p 00000000 00:00 0                          [stack]
7ffd217ee000-7ffd217f1000 r--p 00000000 00:00 0                          [vvar]
7ffd217f1000-7ffd217f3000 r-xp 00000000 00:00 0                          [vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]
Abgebrochen


So this failed. Then I discovered the btrfs rescue chunk-recover tool:

$ btrfs rescue chunk-recover -v /dev/sdc1
All Devices:
        Device: id = 1, name = /dev/sdc1
Scanning: xxx in dev0

This took about 14 hours for the 7.2 TiB HDD but ended up with an impressive long error output: https://twitter.com/cyberfrumble/status/743099729110781952 (forgot to copy it, it was longer than the terminal history).

Then I gave up, created a new GPT and new btrfs partition. But thank you anyway for your recommendations! We can take away from this that we should check the device name each and every time before we do any dd stuff. ;)


Am 14.06.2016 um 16:34 schrieb Maximilian Böhm:
> Wow, I'm overwhelmed, thank you very much for your help!
>
> So, firstly I did a
> dd if=/dev/zero of=nullz.raw bs=1 count=0 seek=2028060672
> and overwrote the ISO on the HDD.
>
> Then I was able to restore the GPT using gdisk with "use backup GPT
> header (rebuilding main)". Now I have an intact GPT, a displayed
> partition with original name, and an unknown filesystem.
>
> btrfs check --repair /dev/sdc1
> and
> btrfs-show-super /dev/sdc1 --all
>
> still don't work.
>
> But I btrfs-show-super now finds the third superblock (see at the
> bottom of this mail).
>
> Then I tried btrfs restore with -u (superblock 3, because it's 0, 1, 2):
>
> $ losetup /dev/loop1 -o 1M /dev/sdc
> $ btrfs restore /dev/loop1 -l -u 2
> checksum verify failed on 21004288 found E4E3BDB6 wanted 00000000
> checksum verify failed on 21004288 found E4E3BDB6 wanted 00000000
> checksum verify failed on 21004288 found E4E3BDB6 wanted 00000000
> checksum verify failed on 21004288 found E4E3BDB6 wanted 00000000
> bytenr mismatch, want=21004288, have=0
> ERROR: cannot read chunk root
> Could not open root, trying backup super
>
> Hm, doesn't "-u 2" defines the backup superblock 3?
>
>
> $ btrfsck /dev/loop1
> No valid Btrfs found on /dev/loop1
> Couldn't open file system
>
> BTW, Photorecs finds lots of files but e.g. MKV video are corrupted in
> some form that they don't want to play but KDE's Dolphin is able to
> generate previews in some cases.
> Any idea about how I should proceed further?
>
>
>
>
> $ btrfs-show-super /dev/sdc1 --all
> superblock: bytenr=65536, device=/dev/sdc1
> ---------------------------------------------------------
> ERROR: bad magic on superblock on /dev/sdc1 at 65536
>
> superblock: bytenr=67108864, device=/dev/sdc1
> ---------------------------------------------------------
> ERROR: bad magic on superblock on /dev/sdc1 at 67108864
>
> superblock: bytenr=274877906944, device=/dev/sdc1
> ---------------------------------------------------------
> csum                    0x615e669a [match]
> bytenr                  274877906944
> flags                   0x1
>                         ( WRITTEN )
> magic                   _BHRfS_M [match]
> fsid                    446c7a9c-fcad-42f2-b093-ee495ca8f5be
> label                   Speicherschatz
> generation              5503
> root                    5113205555200
> sys_array_size          129
> chunk_root_generation   5485
> root_level              1
> chunk_root              21004288
> chunk_root_level        1
> log_root                0
> log_root_transid        0
> log_root_level          0
> total_bytes             8001561821184
> bytes_used              6272827662336
> sectorsize              4096
> nodesize                16384
> leafsize                16384
> stripesize              4096
> root_dir                6
> num_devices             1
> compat_flags            0x0
> compat_ro_flags         0x0
> incompat_flags          0x169
>                         ( MIXED_BACKREF |
>                           COMPRESS_LZO |
>                           BIG_METADATA |
>                           EXTENDED_IREF |
>                           SKINNY_METADATA )
> csum_type               0
> csum_size               4
> cache_generation        5503
> uuid_tree_generation    5503
> dev_item.uuid           0471bf89-89d1-424a-9fc1-d48241ff453b
> dev_item.fsid           446c7a9c-fcad-42f2-b093-ee495ca8f5be [match]
> dev_item.type           0
> dev_item.total_bytes    8001561821184
> dev_item.bytes_used     6283562319872
> dev_item.io_align       4096
> dev_item.io_width       4096
> dev_item.sector_size    4096
> dev_item.devid          1
> dev_item.dev_group      0
> dev_item.seek_speed     0
> dev_item.bandwidth      0
> dev_item.generation     0

