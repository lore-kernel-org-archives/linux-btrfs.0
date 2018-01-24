Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36971 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932072AbeAXUlf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jan 2018 15:41:35 -0500
Received: by mail-wm0-f49.google.com with SMTP id v71so11094956wmv.2
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jan 2018 12:41:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAxOLF8KgC=_LoaEaKft2Q7gUhKL3Fp8OLizbnnA9v4h_cSprQ@mail.gmail.com>
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
 <270851c6-7725-ec63-fa6d-6ff63e99c637@gmx.com> <CAAxOLF8GRV3ZX=cahf0szsvtyQO0Qv32PEKoMBzq+1R=imjzxw@mail.gmail.com>
 <c0f89fad-2c98-fd78-4bcb-7c19dd3c03b0@gmx.com> <08afcd3e-b365-b49f-55c6-770a2b560395@gmail.com>
 <a990d2db-a9ba-256b-1389-e9f350a94060@gmx.com> <CAAxOLF9Hqnbc6g20dPasrtXW+Es562mOBujc7ve7Fc6LzG7tcQ@mail.gmail.com>
 <03ba8382-3271-6c11-b217-a48d1423e684@gmx.com> <CAAxOLF_DB4_5wBem3qgU-B97Hq8xkmE67_qD-7Fe2=my-FN_iw@mail.gmail.com>
 <CAAxOLF8KgC=_LoaEaKft2Q7gUhKL3Fp8OLizbnnA9v4h_cSprQ@mail.gmail.com>
From: "^m'e" <marcoep@gmail.com>
Date: Wed, 24 Jan 2018 20:41:13 +0000
Message-ID: <CAAxOLF9k3WJ-JPJsCEaW4ZD+XMzhRdaRXouaWLwX1JBSM1Xnxw@mail.gmail.com>
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

And here it is:

--------------------------------------------
# ./btrfs-debug-tree.static -t 1385 /dev/sdb3 | grep -C 20 30039322 |
tee /mnt/custom/rescue/btrfs-recovery/btrfs-debug.30039322.2.log
        location key (30037910 INODE_ITEM 0) type DIR
        transid 136248 data_len 0 name_len 3
        name: bam
    item 52 key (30037720 DIR_ITEM 508462201) itemoff 14104 itemsize 40
        location key (30039832 INODE_ITEM 0) type DIR
        transid 136248 data_len 0 name_len 10
        name: suse-build
    item 53 key (30037720 DIR_ITEM 541125215) itemoff 14070 itemsize 34
        location key (30038354 INODE_ITEM 0) type DIR
        transid 136248 data_len 0 name_len 4
        name: cram
    item 54 key (30037720 DIR_ITEM 543235706) itemoff 14035 itemsize 35
        location key (30039133 INODE_ITEM 0) type DIR
        transid 136248 data_len 0 name_len 5
        name: lsuio
    item 55 key (30037720 DIR_ITEM 586823170) itemoff 14000 itemsize 35
        location key (30038846 INODE_ITEM 0) type DIR
        transid 136248 data_len 0 name_len 5
        name: geany
    item 56 key (30037720 DIR_ITEM 603413733) itemoff 13938 itemsize 62
        location key (30039322 INODE_ITEM 0) type DIR
        transid 136248 data_len 0 name_len 32
        name: obs-service-download_src_package
    item 57 key (30037720 DIR_ITEM 623694194) itemoff 13903 itemsize 35
        location key (30038092 INODE_ITEM 0) type DIR
        transid 136248 data_len 0 name_len 5
        name: byacc
    item 58 key (30037720 DIR_ITEM 637448305) itemoff 13868 itemsize 35
        location key (43374420 INODE_ITEM 0) type DIR
        transid 200308 data_len 0 name_len 5
        name: vpuml
    item 59 key (30037720 DIR_ITEM 660989717) itemoff 13828 itemsize 40
        location key (30038283 INODE_ITEM 0) type DIR
        transid 136248 data_len 0 name_len 10
        name: comparator
    item 60 key (30037720 DIR_ITEM 666000672) itemoff 13782 itemsize 46
        location key (30039257 INODE_ITEM 0) type DIR
        transid 136248 data_len 0 name_len 16
        name: molecule-plugins
    item 61 key (30037720 DIR_ITEM 679217690) itemoff 13749 itemsize 33
        location key (36281336 INODE_ITEM 0) type DIR
--
        location key (30039292 INODE_ITEM 0) type DIR
        transid 136248 data_len 0 name_len 15
        name: nvidia-cuda-sdk
    item 73 key (30037720 DIR_INDEX 238) itemoff 13448 itemsize 49
        location key (30039299 INODE_ITEM 0) type DIR
        transid 136248 data_len 0 name_len 19
        name: nvidia-cuda-toolkit
    item 74 key (30037720 DIR_INDEX 239) itemoff 13411 itemsize 37
        location key (30039309 INODE_ITEM 0) type DIR
        transid 136248 data_len 0 name_len 7
        name: objconv
    item 75 key (30037720 DIR_INDEX 240) itemoff 13361 itemsize 50
        location key (30039314 INODE_ITEM 0) type DIR
        transid 136248 data_len 0 name_len 20
        name: obs-service-cpanspec
    item 76 key (30037720 DIR_INDEX 241) itemoff 13305 itemsize 56
        location key (30039318 INODE_ITEM 0) type DIR
        transid 136248 data_len 0 name_len 26
        name: obs-service-download_files
    item 77 key (30037720 DIR_INDEX 242) itemoff 13243 itemsize 62
        location key (30039322 INODE_ITEM 0) type DIR
        transid 136248 data_len 0 name_len 32
        name: obs-service-download_src_package
    item 78 key (30037720 DIR_INDEX 243) itemoff 13189 itemsize 54
        location key (30039326 INODE_ITEM 0) type DIR
        transid 136248 data_len 0 name_len 24
        name: obs-service-download_url
    item 79 key (30037720 DIR_INDEX 244) itemoff 13135 itemsize 54
        location key (30039330 INODE_ITEM 0) type DIR
        transid 136248 data_len 0 name_len 24
        name: obs-service-extract_file
    item 80 key (30037720 DIR_INDEX 245) itemoff 13077 itemsize 58
        location key (30039334 INODE_ITEM 0) type DIR
        transid 136248 data_len 0 name_len 28
        name: obs-service-format_spec_file
    item 81 key (30037720 DIR_INDEX 246) itemoff 13007 itemsize 70
        location key (30039338 INODE_ITEM 0) type DIR
        transid 136248 data_len 0 name_len 40
        name: obs-service-generator_driver_update_disk
    item 82 key (30037720 DIR_INDEX 247) itemoff 12953 itemsize 54
        location key (30039342 INODE_ITEM 0) type DIR
--
        mtime 1504685599.188061317 (2017-09-06 08:13:19)
        otime 1504685599.188061317 (2017-09-06 08:13:19)
    item 73 key (30039320 INODE_REF 30039318) itemoff 5278 itemsize 22
        index 3 namelen 12 name: metadata.xml
    item 74 key (30039320 EXTENT_DATA 0) itemoff 4809 itemsize 469
        generation 136248 type 0 (inline)
        inline extent data size 448 ram_bytes 448 compression 0 (none)
    item 75 key (30039321 INODE_ITEM 0) itemoff 4649 itemsize 160
        generation 136248 transid 202216 size 213 nbytes 213
        block group 0 mode 100644 links 1 uid 250 gid 250 rdev 0
        sequence 0 flags 0xb(none)
        atime 1504685599.188061317 (2017-09-06 08:13:19)
        ctime 1512818139.540278499 (2017-12-09 11:15:39)
        mtime 1504685599.188061317 (2017-09-06 08:13:19)
        otime 1504685599.188061317 (2017-09-06 08:13:19)
    item 76 key (30039321 INODE_REF 30039318) itemoff 4597 itemsize 52
        index 4 namelen 42 name: obs-service-download_files-20130716.ebuild
    item 77 key (30039321 EXTENT_DATA 0) itemoff 4363 itemsize 234
        generation 136248 type 0 (inline)
        inline extent data size 213 ram_bytes 213 compression 0 (none)
    item 78 key (30039322 INODE_ITEM 0) itemoff 4203 itemsize 160
        generation 136248 transid 229515 size 152 nbytes 0
        block group 0 mode 40755 links 1 uid 250 gid 250 rdev 0
        sequence 0 flags 0xf(none)
        atime 1504685599.188061317 (2017-09-06 08:13:19)
        ctime 1516557882.551679697 (2018-01-21 18:04:42)
        mtime 1516557882.551679697 (2018-01-21 18:04:42)
        otime 1504685599.188061317 (2017-09-06 08:13:19)
    item 79 key (30039322 INODE_REF 30037720) itemoff 4161 itemsize 42
        index 242 namelen 32 name: obs-service-download_src_package
    item 80 key (30039322 DIR_ITEM 1076301169) itemoff 4083 itemsize 78
        location key (30039325 INODE_ITEM 0) type FILE
        transid 136248 data_len 0 name_len 48
        name: obs-service-download_src_package-20130318.ebuild
    item 81 key (30039322 DIR_ITEM 2438219243) itemoff 4041 itemsize 42
        location key (0 UNKNOWN.0 0) type FILE
        transid 136192 data_len 0 name_len 12
        name: metadata.xml
    item 82 key (30039322 DIR_ITEM 4007295565) itemoff 4003 itemsize 38
        location key (47302013 INODE_ITEM 0) type FILE
        transid 3377699720527872 data_len 0 name_len 8
        name: Manifest
    item 83 key (30039322 DIR_INDEX 3) itemoff 3961 itemsize 42
        location key (30039324 INODE_ITEM 0) type FILE
        transid 136248 data_len 0 name_len 12
        name: metadata.xml
    item 84 key (30039322 DIR_INDEX 4) itemoff 3883 itemsize 78
        location key (30039325 INODE_ITEM 0) type FILE
        transid 136248 data_len 0 name_len 48
        name: obs-service-download_src_package-20130318.ebuild
    item 85 key (30039322 DIR_INDEX 5) itemoff 3845 itemsize 38
        location key (47302013 INODE_ITEM 0) type FILE
        transid 3861419965563273305 data_len 0 name_len 8
        name: Manifest
    item 86 key (30039323 INODE_ITEM 0) itemoff 3685 itemsize 160
        generation 136248 transid 202216 size 782 nbytes 782
        block group 0 mode 100644 links 0 uid 250 gid 250 rdev 0
        sequence 0 flags 0xb(none)
        atime 1504685599.188061317 (2017-09-06 08:13:19)
        ctime 1512818139.540278499 (2017-12-09 11:15:39)
        mtime 1504685599.188061317 (2017-09-06 08:13:19)
        otime 1504685599.188061317 (2017-09-06 08:13:19)
    item 87 key (30039323 EXTENT_DATA 0) itemoff 2882 itemsize 803
        generation 136248 type 0 (inline)
        inline extent data size 782 ram_bytes 782 compression 0 (none)
    item 88 key (30039324 INODE_ITEM 0) itemoff 2722 itemsize 160
        generation 136248 transid 202216 size 448 nbytes 448
        block group 0 mode 100644 links 1 uid 250 gid 250 rdev 0
        sequence 0 flags 0xb(none)
        atime 1504685599.188061317 (2017-09-06 08:13:19)
        ctime 1512818139.540278499 (2017-12-09 11:15:39)
        mtime 1504685599.188061317 (2017-09-06 08:13:19)
        otime 1504685599.188061317 (2017-09-06 08:13:19)
    item 89 key (30039324 INODE_REF 30039322) itemoff 2700 itemsize 22
        index 3 namelen 12 name: metadata.xml
leaf 36701356032 items 44 free space 8701 generation 202216 owner 257
leaf 36701356032 flags 0x1(WRITTEN) backref revision 1
fs uuid de1723e2-150c-4448-bb36-be14d7d96093
chunk uuid 443a227c-4f87-419a-b89a-3f5714eea403
    item 0 key (30039324 EXTENT_DATA 0) itemoff 15814 itemsize 469
        generation 136248 type 0 (inline)
        inline extent data size 448 ram_bytes 448 compression 0 (none)
    item 1 key (30039325 INODE_ITEM 0) itemoff 15654 itemsize 160
        generation 136248 transid 202216 size 213 nbytes 213
        block group 0 mode 100644 links 1 uid 250 gid 250 rdev 0
        sequence 0 flags 0xb(none)
        atime 1504685599.188061317 (2017-09-06 08:13:19)
        ctime 1512818139.540278499 (2017-12-09 11:15:39)
        mtime 1504685599.188061317 (2017-09-06 08:13:19)
        otime 1504685599.188061317 (2017-09-06 08:13:19)
    item 2 key (30039325 INODE_REF 30039322) itemoff 15596 itemsize 58
        index 4 namelen 48 name:
obs-service-download_src_package-20130318.ebuild
    item 3 key (30039325 EXTENT_DATA 0) itemoff 15362 itemsize 234
        generation 136248 type 0 (inline)
        inline extent data size 213 ram_bytes 213 compression 0 (none)
    item 4 key (30039326 INODE_ITEM 0) itemoff 15202 itemsize 160
        generation 136248 transid 202216 size 120 nbytes 0
        block group 0 mode 40755 links 1 uid 250 gid 250 rdev 0
        sequence 0 flags 0xe(none)
        atime 1504685599.188061317 (2017-09-06 08:13:19)
        ctime 1512818139.541278502 (2017-12-09 11:15:39)
        mtime 1504685599.188061317 (2017-09-06 08:13:19)
        otime 1504685599.188061317 (2017-09-06 08:13:19)
    item 5 key (30039326 INODE_REF 30037720) itemoff 15168 itemsize 34
        index 243 namelen 24 name: obs-service-download_url
    item 6 key (30039326 DIR_ITEM 1441374077) itemoff 15098 itemsize 70
        location key (30039329 INODE_ITEM 0) type FILE
        transid 136248 data_len 0 name_len 40
        name: obs-service-download_url-20130318.ebuild
    item 7 key (30039326 DIR_ITEM 2438219243) itemoff 15056 itemsize 42
        location key (30039328 INODE_ITEM 0) type FILE
--
        generation 229515 transid 229515 size 26 nbytes 26
        block group 0 mode 100644 links 1 uid 250 gid 250 rdev 0
        sequence 0 flags 0x2(none)
        atime 1516557882.505679580 (2018-01-21 18:04:42)
        ctime 1516557882.505679580 (2018-01-21 18:04:42)
        mtime 1516557882.505679580 (2018-01-21 18:04:42)
        otime 1516557882.505679580 (2018-01-21 18:04:42)
    item 61 key (47302010 INODE_REF 30002892) itemoff 11503 itemsize 14
        index 1798 namelen 4 name: HEAD
    item 62 key (47302010 EXTENT_DATA 0) itemoff 11456 itemsize 47
        generation 229515 type 0 (inline)
        inline extent data size 26 ram_bytes 26 compression 0 (none)
    item 63 key (47302013 INODE_ITEM 0) itemoff 11296 itemsize 160
        generation 229515 transid 229516 size 782 nbytes 782
        block group 0 mode 100644 links 1 uid 250 gid 250 rdev 0
        sequence 0 flags 0x0(none)
        atime 1516557882.551679697 (2018-01-21 18:04:42)
        ctime 1516557882.551679697 (2018-01-21 18:04:42)
        mtime 1516557882.551679697 (2018-01-21 18:04:42)
        otime 1516557882.551679697 (2018-01-21 18:04:42)
    item 64 key (47302013 INODE_REF 30039322) itemoff 11278 itemsize 18
        index 5 namelen 8 name: Manifest
leaf 186518913024 items 86 free space 3119 generation 229516 owner 257
leaf 186518913024 flags 0x1(WRITTEN) backref revision 1
fs uuid de1723e2-150c-4448-bb36-be14d7d96093
chunk uuid 443a227c-4f87-419a-b89a-3f5714eea403
    item 0 key (47302013 EXTENT_DATA 0) itemoff 15480 itemsize 803
        generation 229516 type 0 (inline)
        inline extent data size 782 ram_bytes 782 compression 0 (none)
    item 1 key (47302018 INODE_ITEM 0) itemoff 15320 itemsize 160
        generation 229515 transid 229515 size 41 nbytes 41
        block group 0 mode 100644 links 1 uid 250 gid 250 rdev 0
        sequence 0 flags 0x2(none)
        atime 1516557883.180681304 (2018-01-21 18:04:43)
        ctime 1516557883.180681304 (2018-01-21 18:04:43)
        mtime 1516557883.180681304 (2018-01-21 18:04:43)
        otime 1516557883.180681304 (2018-01-21 18:04:43)
    item 2 key (47302018 INODE_REF 30002892) itemoff 15301 itemsize 19
        index 1801 namelen 9 name: ORIG_HEAD
    item 3 key (47302018 EXTENT_DATA 0) itemoff 15239 itemsize 62
        generation 229515 type 0 (inline)
--------------------------------------------
