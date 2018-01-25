Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:43543 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751202AbeAYQk0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Jan 2018 11:40:26 -0500
Received: by mail-wm0-f66.google.com with SMTP id g1so15772086wmg.2
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 08:40:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <80321b99-a89c-fadf-8f1a-26ed8f598a66@gmx.com>
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
 <270851c6-7725-ec63-fa6d-6ff63e99c637@gmx.com> <CAAxOLF8GRV3ZX=cahf0szsvtyQO0Qv32PEKoMBzq+1R=imjzxw@mail.gmail.com>
 <c0f89fad-2c98-fd78-4bcb-7c19dd3c03b0@gmx.com> <08afcd3e-b365-b49f-55c6-770a2b560395@gmail.com>
 <a990d2db-a9ba-256b-1389-e9f350a94060@gmx.com> <CAAxOLF9Hqnbc6g20dPasrtXW+Es562mOBujc7ve7Fc6LzG7tcQ@mail.gmail.com>
 <03ba8382-3271-6c11-b217-a48d1423e684@gmx.com> <CAAxOLF_DB4_5wBem3qgU-B97Hq8xkmE67_qD-7Fe2=my-FN_iw@mail.gmail.com>
 <CAAxOLF8KgC=_LoaEaKft2Q7gUhKL3Fp8OLizbnnA9v4h_cSprQ@mail.gmail.com>
 <CAAxOLF9k3WJ-JPJsCEaW4ZD+XMzhRdaRXouaWLwX1JBSM1Xnxw@mail.gmail.com>
 <6d5bfa3f-3c49-1380-2bcf-d6eeca57020a@gmx.com> <CAAxOLF_wRCxgebwXUy7A5AqKtKchGLz46DKNiM-iPejVpfjbFg@mail.gmail.com>
 <0662a08f-5869-3eb3-5ab2-391ba9603095@gmx.com> <CAAxOLF8wt98KCONdEJXMvUuzxeB5_GwigGhCzEE6hSpmurXRNw@mail.gmail.com>
 <80321b99-a89c-fadf-8f1a-26ed8f598a66@gmx.com>
From: "^m'e" <marcoep@gmail.com>
Date: Thu, 25 Jan 2018 16:40:04 +0000
Message-ID: <CAAxOLF9wYwUzT_AAx1Wa12XyCwACo7vp021BytHn-VaANC--=Q@mail.gmail.com>
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quite some progress, thanks :-)

The check:
---------------------------------------------------
# ./btrfs.static check --mode=lowmem /dev/sdb3  2>&1 | tee
/mnt/custom/rescue/btrfs-recovery/btrfs-check.3.log
checking extents
checking free space cache
checking fs roots
ERROR: root 1385 INODE[30039323] is orphan item
ERROR: root 1385 INODE[18446744073709551361] is orphan item
ERROR: root 1399 DIR_ITEM[30039322 4007295565] name  namelen 0
filetype 0 mismatch with its hash, wanted 4007295565 have 4294967294
ERROR: root 1399 INODE_ITEM[0] index 18446744073709551615 name
filetype 0 missing
ERROR: root 1399 DIR_ITEM[30039322 4007295565] data_len shouldn't be 32907
ERROR: root 1399 DIR_ITEM[30039322 4007295565] name  namelen 3
filetype 0 mismatch with its hash, wanted 4007295565 have 987418363
ERROR: root 1399 INODE_ITEM[0] index 18446744073709551615 name
filetype 0 missing
ERROR: errors found in fs roots
Checking filesystem on /dev/sdb3
UUID: de1723e2-150c-4448-bb36-be14d7d96093
cache and super generation don't match, space cache will be invalidated
found 104496005120 bytes used, error(s) found
total csum bytes: 99678168
total tree bytes: 14560952320
total fs tree bytes: 14340227072
total extent tree bytes: 87851008
btree space waste bytes: 3163325351
file data blocks allocated: 362049273856
 referenced 315584987136
# echo $?
0
---------------------------------------------------

Please also mind a minor glitch (v4.14.1): that the exit is code is 0,
though there are errors


The rapair attempt:
---------------------------------------------------
 # ./btrfs.static check --repair /dev/sdb3  2>&1 | tee
/mnt/custom/rescue/btrfs-recovery/btrfs-repair.3.log
Fixed 0 roots.
checking extents
checking free space cache
checking fs roots
invalid location in dir item 0
Failed to reset nlink for inode 18446744073709551361: No such file or directory
    unresolved ref dir 30039322 index 0 namelen 12 name metadata.xml
filetype 1 errors 6, no dir index, no inode ref
ERROR: DIR_ITEM[30039322 4007295565] name  ]�  namelen 0 filetype 0
mismatch with its hash, wanted 4007295565 have 4294967294
invalid location in dir item 0
ERROR: DIR_ITEM[30039322 4007295565] name  namelen 3 filetype 0
mismatch with its hash, wanted 4007295565 have 987418363
invalid location in dir item 125
root 1399 inode 30039322 errors 10, odd dir item
Failed to reset nlink for inode 18446744073709551361: No such file or directory
    unresolved ref dir 30039322 index 0 namelen 0 name  filetype 0
errors 6, no dir index, no inode ref
    unresolved ref dir 30039322 index 0 namelen 3 name  filetype 0
errors 6, no dir index, no inode ref
ERROR: DIR_ITEM[30039322 4007295565] name  ]�  namelen 0 filetype 0
mismatch with its hash, wanted 4007295565 have 4294967294
invalid location in dir item 0
ERROR: DIR_ITEM[30039322 4007295565] name  namelen 3 filetype 0
mismatch with its hash, wanted 4007295565 have 987418363
invalid location in dir item 125
root 1399 inode 30039322 errors 10, odd dir item
Failed to reset nlink for inode 18446744073709551361: No such file or directory
    unresolved ref dir 30039322 index 0 namelen 0 name  filetype 0
errors 6, no dir index, no inode ref
    unresolved ref dir 30039322 index 0 namelen 3 name  filetype 0
errors 6, no dir index, no inode ref
ERROR: DIR_ITEM[30039322 4007295565] name  ]�  namelen 0 filetype 0
mismatch with its hash, wanted 4007295565 have 4294967294
invalid location in dir item 0
ERROR: DIR_ITEM[30039322 4007295565] name  namelen 3 filetype 0
mismatch with its hash, wanted 4007295565 have 987418363
invalid location in dir item 125
root 1399 inode 30039322 errors 10, odd dir item
Failed to reset nlink for inode 18446744073709551361: No such file or directory
    unresolved ref dir 30039322 index 0 namelen 0 name  filetype 0
errors 6, no dir index, no inode ref
    unresolved ref dir 30039322 index 0 namelen 3 name  filetype 0
errors 6, no dir index, no inode ref
ERROR: DIR_ITEM[30039322 4007295565] name  ]�  namelen 0 filetype 0
mismatch with its hash, wanted 4007295565 have 4294967294
invalid location in dir item 0
ERROR: DIR_ITEM[30039322 4007295565] name  namelen 3 filetype 0
mismatch with its hash, wanted 4007295565 have 987418363
invalid location in dir item 125
root 1399 inode 30039322 errors 10, odd dir item
Failed to reset nlink for inode 18446744073709551361: No such file or directory
    unresolved ref dir 30039322 index 0 namelen 0 name  filetype 0
errors 6, no dir index, no inode ref
    unresolved ref dir 30039322 index 0 namelen 3 name  filetype 0
errors 6, no dir index, no inode ref
ERROR: DIR_ITEM[30039322 4007295565] name  ]�  namelen 0 filetype 0
mismatch with its hash, wanted 4007295565 have 4294967294
invalid location in dir item 0
ERROR: DIR_ITEM[30039322 4007295565] name  namelen 3 filetype 0
mismatch with its hash, wanted 4007295565 have 987418363
invalid location in dir item 125
root 1399 inode 30039322 errors 10, odd dir item
Failed to reset nlink for inode 18446744073709551361: No such file or directory
    unresolved ref dir 30039322 index 0 namelen 0 name  filetype 0
errors 6, no dir index, no inode ref
    unresolved ref dir 30039322 index 0 namelen 3 name  filetype 0
errors 6, no dir index, no inode ref
ERROR: DIR_ITEM[30039322 4007295565] name  ]�  namelen 0 filetype 0
mismatch with its hash, wanted 4007295565 have 4294967294
invalid location in dir item 0
ERROR: DIR_ITEM[30039322 4007295565] name  namelen 3 filetype 0
mismatch with its hash, wanted 4007295565 have 987418363
invalid location in dir item 125
root 1399 inode 30039322 errors 10, odd dir item
Failed to reset nlink for inode 18446744073709551361: No such file or directory
    unresolved ref dir 30039322 index 0 namelen 0 name  filetype 0
errors 6, no dir index, no inode ref
    unresolved ref dir 30039322 index 0 namelen 3 name  filetype 0
errors 6, no dir index, no inode ref
ERROR: DIR_ITEM[30039322 4007295565] name  ]�  namelen 0 filetype 0
mismatch with its hash, wanted 4007295565 have 4294967294
invalid location in dir item 0
ERROR: DIR_ITEM[30039322 4007295565] name  namelen 3 filetype 0
mismatch with its hash, wanted 4007295565 have 987418363
invalid location in dir item 125
root 1399 inode 30039322 errors 10, odd dir item
Failed to reset nlink for inode 18446744073709551361: No such file or directory
    unresolved ref dir 30039322 index 0 namelen 0 name  filetype 0
errors 6, no dir index, no inode ref
    unresolved ref dir 30039322 index 0 namelen 3 name  filetype 0
errors 6, no dir index, no inode ref
^C
---------------------------------------------------


Debugging the two faulty roots -- hopefuly I got the message right ;-)

---------------------------------------------------
# ./btrfs-debug-tree.static -t 1385 /dev/sdb3 | grep -C 20 -E
'300393223|18446744073709551361' | tee
/mnt/custom/rescue/btrfs-recovery/btrfs-debug.t1385.log

mtime 1516557882.551679697 (2018-01-21 18:04:42)
        otime 1504685599.188061317 (2017-09-06 08:13:19)
    item 79 key (30039322 INODE_REF 30037720) itemoff 4161 itemsize 42
        index 242 namelen 32 name: obs-service-download_src_package
    item 80 key (30039322 DIR_ITEM 1076301169) itemoff 4083 itemsize 78
        location key (30039325 INODE_ITEM 0) type FILE
        transid 136248 data_len 0 name_len 48
        name: obs-service-download_src_package-20130318.ebuild
    item 81 key (30039322 DIR_ITEM 4007295565) itemoff 4045 itemsize 38
        location key (47302013 INODE_ITEM 0) type FILE
        transid 3377699720527872 data_len 0 name_len 8
        name: Manifest
    item 82 key (30039322 DIR_INDEX 4) itemoff 3967 itemsize 78
        location key (30039325 INODE_ITEM 0) type FILE
        transid 136248 data_len 0 name_len 48
        name: obs-service-download_src_package-20130318.ebuild
    item 83 key (30039322 DIR_INDEX 5) itemoff 3929 itemsize 38
        location key (47302013 INODE_ITEM 0) type FILE
        transid 3861419965563273305 data_len 0 name_len 8
        name: Manifest
    item 84 key (30039323 INODE_ITEM 0) itemoff 3769 itemsize 160
        generation 136248 transid 202216 size 782 nbytes 782
        block group 0 mode 100644 links 0 uid 250 gid 250 rdev 0
        sequence 0 flags 0xb(none)
        atime 1504685599.188061317 (2017-09-06 08:13:19)
        ctime 1512818139.540278499 (2017-12-09 11:15:39)
        mtime 1504685599.188061317 (2017-09-06 08:13:19)
        otime 1504685599.188061317 (2017-09-06 08:13:19)
    item 85 key (30039323 EXTENT_DATA 0) itemoff 2966 itemsize 803
        generation 136248 type 0 (inline)
        inline extent data size 782 ram_bytes 782 compression 0 (none)
    item 86 key (30039324 INODE_ITEM 0) itemoff 2806 itemsize 160
        generation 136248 transid 202216 size 448 nbytes 448
        block group 0 mode 100644 links 1 uid 250 gid 250 rdev 0
        sequence 0 flags 0xb(none)
        atime 1504685599.188061317 (2017-09-06 08:13:19)
        ctime 1512818139.540278499 (2017-12-09 11:15:39)
        mtime 1504685599.188061317 (2017-09-06 08:13:19)
        otime 1504685599.188061317 (2017-09-06 08:13:19)
    item 87 key (30039324 INODE_REF 47329988) itemoff 2784 itemsize 22
        index 2 namelen 12 name: metadata.xml
leaf 36701356032 items 44 free space 8701 generation 202216 owner 257
leaf 36701356032 flags 0x1(WRITTEN) backref revision 1
fs uuid de1723e2-150c-4448-bb36-be14d7d96093
chunk uuid 443a227c-4f87-419a-b89a-3f5714eea403
    item 0 key (30039324 EXTENT_DATA 0) itemoff 15814 itemsize 469
        generation 136248 type 0 (inline)
        inline extent data size 448 ram_bytes 448 compression 0 (none)
    item 1 key (30039325 INODE_ITEM 0) itemoff 15654 itemsize 160
--
        mtime 1516888573.0 (2018-01-25 13:56:13)
        otime 0.0 (1970-01-01 00:00:00)
    item 45 key (47329988 INODE_REF 256) itemoff 9768 itemsize 20
        index 28 namelen 10 name: lost+found
    item 46 key (47329988 DIR_ITEM 2438219243) itemoff 9726 itemsize 42
        location key (30039324 INODE_ITEM 0) type FILE
        transid 0 data_len 0 name_len 12
        name: metadata.xml
    item 47 key (47329988 DIR_INDEX 2) itemoff 9684 itemsize 42
        location key (30039324 INODE_ITEM 0) type FILE
        transid 0 data_len 0 name_len 12
        name: metadata.xml
    item 48 key (MULTIPLE INODE_ITEM 0) itemoff 9524 itemsize 160
        generation 461639 transid 0 size 0 nbytes 0
        block group 0 mode 100700 links 0 uid 0 gid 0 rdev 0
        sequence 0 flags 0x0(none)
        atime 1516888573.0 (2018-01-25 13:56:13)
        ctime 1516888573.0 (2018-01-25 13:56:13)
        mtime 1516888573.0 (2018-01-25 13:56:13)
        otime 0.0 (1970-01-01 00:00:00)
    item 49 key (ORPHAN ORPHAN_ITEM 30039323) itemoff 9524 itemsize 0
        orphan item
    item 50 key (ORPHAN ORPHAN_ITEM 18446744073709551361) itemoff 9524
itemsize 0
        orphan item
total bytes 247335313408
bytes used 104496005120
uuid de1723e2-150c-4448-bb36-be14d7d96093
---------------------------------------------------

---------------------------------------------------
# ./btrfs-debug-tree.static -t 1399 /dev/sdb3 | grep -C 20 -E
'30039322' | tee
/mnt/custom/rescue/btrfs-recovery/btrfs-debug.t1399.log

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
        generation 136248 transid 229515 size 99 nbytes 0
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
    item 81 key (30039322 DIR_ITEM 4007295565) itemoff 3969 itemsize 114
        location key (0 UNKNOWN.0 0) type DIR_ITEM.0
        transid 0 data_len 0 name_len 0
        name:
        location key (0 UNKNOWN.125 72057594038112709) type DIR_ITEM.0
        transid 0 data_len 32907 name_len 3
        name:
        data
    item 82 key (30039322 DIR_INDEX 4) itemoff 3891 itemsize 78
        location key (30039325 INODE_ITEM 0) type FILE
        transid 136248 data_len 0 name_len 48
        name: obs-service-download_src_package-20130318.ebuild
    item 83 key (30039323 INODE_ITEM 0) itemoff 3731 itemsize 160
        generation 136248 transid 202216 size 782 nbytes 782
        block group 0 mode 100644 links 1 uid 250 gid 250 rdev 0
        sequence 0 flags 0xb(none)
        atime 1504685599.188061317 (2017-09-06 08:13:19)
        ctime 1512818139.540278499 (2017-12-09 11:15:39)
        mtime 1504685599.188061317 (2017-09-06 08:13:19)
        otime 1504685599.188061317 (2017-09-06 08:13:19)
    item 84 key (30039323 INODE_REF 47330540) itemoff 3713 itemsize 18
        index 2 namelen 8 name: Manifest
    item 85 key (30039323 EXTENT_DATA 0) itemoff 2910 itemsize 803
        generation 136248 type 0 (inline)
        inline extent data size 782 ram_bytes 782 compression 0 (none)
    item 86 key (30039324 INODE_ITEM 0) itemoff 2750 itemsize 160
        generation 136248 transid 202216 size 448 nbytes 448
        block group 0 mode 100644 links 1 uid 250 gid 250 rdev 0
        sequence 0 flags 0xb(none)
--
        ctime 1512818139.540278499 (2017-12-09 11:15:39)
        mtime 1504685599.188061317 (2017-09-06 08:13:19)
        otime 1504685599.188061317 (2017-09-06 08:13:19)
    item 87 key (30039324 INODE_REF 47330540) itemoff 2728 itemsize 22
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
---------------------------------------------------

Cheers,

  Marco
