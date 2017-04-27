Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:33661 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932575AbdD0K1T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Apr 2017 06:27:19 -0400
Received: by mail-pf0-f174.google.com with SMTP id a188so22820465pfa.0
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Apr 2017 03:27:18 -0700 (PDT)
MIME-Version: 1.0
From: Clemens Eisserer <linuxhippy@gmail.com>
Date: Thu, 27 Apr 2017 12:27:17 +0200
Message-ID: <CAFvQSYQkyKUe_+BWQL0atxfjDF2mhe1H-mXNHE9Cr902e7Q+Rg@mail.gmail.com>
Subject: Error during backup to zlib-compressed btrfs-volume (kernel stack
 frame pointer at ffff9f1f433ebf50 in kworker/u8:7:6702 has bad value (null))
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

During a backup to an external USB3 hdd with the following mount
options "rw,nosuid,nodev,relatime,compress-force=zlib,space_cache,subvolid=5,subvol=/,user"
runnning linux-4.10.11-200.fc25.x86_64 I got the backtrace at the end
of the email.

Best regards, Clemens

[ 3723.511132] WARNING: kernel stack frame pointer at ffff9f1f433ebf50
in kworker/u8:7:6702 has bad value           (null)
[ 3723.511133] unwind stack type:0 next_sp:          (null) mask:2 graph_idx:0
[ 3723.511135] ffff9f1f433ebab8: 0000000000001000 (0x1000)
[ 3723.511136] ffff9f1f433ebac0: ffff9f1f49184000 (0xffff9f1f49184000)
[ 3723.511136] ffff9f1f433ebac8: ffff9f1f491849b0 (0xffff9f1f491849b0)
[ 3723.511136] ffff9f1f433ebad0: 0000000000000000 ...
[ 3723.511137] ffff9f1f433ebad8: ffff9f1f433ebb70 (0xffff9f1f433ebb70)
[ 3723.511137] ffff9f1f433ebae0: 0000000000000009 (0x9)
[ 3723.511138] ffff9f1f433ebae8: 0000000000000004 (0x4)
[ 3723.511138] ffff9f1f433ebaf0: 000000000000000a (0xa)
[ 3723.511138] ffff9f1f433ebaf8: 0000000000000000 ...
[ 3723.511139] ffff9f1f433ebb00: 0000000000000060 (0x60)
[ 3723.511139] ffff9f1f433ebb08: 0000000000000001 (0x1)
[ 3723.511140] ffff9f1f433ebb10: 000000000000000a (0xa)
[ 3723.511140] ffff9f1f433ebb18: 0000000000000107 (0x107)
[ 3723.511141] ffff9f1f433ebb20: ffff9f1f491840bc (0xffff9f1f491840bc)
[ 3723.511141] ffff9f1f433ebb28: ffff9f1f49184000 (0xffff9f1f49184000)
[ 3723.511141] ffff9f1f433ebb30: ffffffffffffff10 (0xffffffffffffff10)
[ 3723.511145] ffff9f1f433ebb38: ffffffff91430e4d (scan_tree+0xbd/0x110)
[ 3723.511145] ffff9f1f433ebb40: 0000000000000010 (0x10)
[ 3723.511146] ffff9f1f433ebb48: 0000000000000216 (0x216)
[ 3723.511146] ffff9f1f433ebb50: ffff9f1f433ebb68 (0xffff9f1f433ebb68)
[ 3723.511146] ffff9f1f433ebb58: 0000000000000018 (0x18)
[ 3723.511147] ffff9f1f433ebb60: ffff9f1f49184000 (0xffff9f1f49184000)
[ 3723.511147] ffff9f1f433ebb68: ffff9f1f491840bc (0xffff9f1f491840bc)
[ 3723.511148] ffff9f1f433ebb70: ffff9f1f433ebbb0 (0xffff9f1f433ebbb0)
[ 3723.511149] ffff9f1f433ebb78: ffffffff91432949
(zlib_tr_flush_block+0x79/0x760)
[ 3723.511149] ffff9f1f433ebb80: ffff9f1f49193748 (0xffff9f1f49193748)
[ 3723.511150] ffff9f1f433ebb88: ffff9f1f49184000 (0xffff9f1f49184000)
[ 3723.511150] ffff9f1f433ebb90: 0000000000000003 (0x3)
[ 3723.511151] ffff9f1f433ebb98: 000000000000efef (0xefef)
[ 3723.511151] ffff9f1f433ebba0: 0000000000000005 (0x5)
[ 3723.511151] ffff9f1f433ebba8: ffff8c16076494e8 (0xffff8c16076494e8)
[ 3723.511152] ffff9f1f433ebbb0: ffff9f1f433ebbd8 (0xffff9f1f433ebbd8)
[ 3723.511153] ffff9f1f433ebbb8: ffffffff91430355 (deflate_fast+0x295/0x2e0)
[ 3723.511153] ffff9f1f433ebbc0: ffff9f1f49184000 (0xffff9f1f49184000)
[ 3723.511154] ffff9f1f433ebbc8: ffff8c1607649480 (0xffff8c1607649480)
[ 3723.511154] ffff9f1f433ebbd0: 0000000000000003 (0x3)
[ 3723.511155] ffff9f1f433ebbd8: ffff9f1f433ebc00 (0xffff9f1f433ebc00)
[ 3723.511156] ffff9f1f433ebbe0: ffffffff914308fe (zlib_deflate+0xae/0x3a0)
[ 3723.511156] ffff9f1f433ebbe8: ffffd25e42de5340 (0xffffd25e42de5340)
[ 3723.511157] ffff9f1f433ebbf0: 0000000000020000 (0x20000)
[ 3723.511157] ffff9f1f433ebbf8: 0000000000001000 (0x1000)
[ 3723.511157] ffff9f1f433ebc00: ffff9f1f433ebc70 (0xffff9f1f433ebc70)
[ 3723.511177] ffff9f1f433ebc08: ffffffffc05b9198
(zlib_compress_pages+0x148/0x420 [btrfs])
[ 3723.511178] ffff9f1f433ebc10: 00000000076494e8 (0x76494e8)
[ 3723.511178] ffff9f1f433ebc18: 0000000000000020 (0x20)
[ 3723.511179] ffff9f1f433ebc20: ffff8c1614774a88 (0xffff8c1614774a88)
[ 3723.511179] ffff9f1f433ebc28: ffff8c144d973e00 (0xffff8c144d973e00)
[ 3723.511180] ffff9f1f433ebc30: ffffd25e41b89e40 (0xffffd25e41b89e40)
[ 3723.511180] ffff9f1f433ebc38: ffff8c1607649480 (0xffff8c1607649480)
[ 3723.511180] ffff9f1f433ebc40: 000000000004e000 (0x4e000)
[ 3723.511181] ffff9f1f433ebc48: 0000000000000001 (0x1)
[ 3723.511181] ffff9f1f433ebc50: ffff8c1614774a88 (0xffff8c1614774a88)
[ 3723.511182] ffff9f1f433ebc58: 0000000000040000 (0x40000)
[ 3723.511182] ffff9f1f433ebc60: 0000000000020000 (0x20000)
[ 3723.511182] ffff9f1f433ebc68: ffff8c16076494e8 (0xffff8c16076494e8)
[ 3723.511183] ffff9f1f433ebc70: ffff9f1f433ebcd8 (0xffff9f1f433ebcd8)
[ 3723.511194] ffff9f1f433ebc78: ffffffffc05bb5d8
(btrfs_compress_pages+0x78/0xa0 [btrfs])
[ 3723.511194] ffff9f1f433ebc80: ffff9f1f433ebd80 (0xffff9f1f433ebd80)
[ 3723.511195] ffff9f1f433ebc88: ffff9f1f433ebd90 (0xffff9f1f433ebd90)
[ 3723.511195] ffff9f1f433ebc90: ffff9f1f433ebd88 (0xffff9f1f433ebd88)
[ 3723.511196] ffff9f1f433ebc98: 0000000000020000 (0x20000)
[ 3723.511196] ffff9f1f433ebca0: ffff8c144d973e00 (0xffff8c144d973e00)
[ 3723.511196] ffff9f1f433ebca8: 0000000000000020 (0x20)
[ 3723.511197] ffff9f1f433ebcb0: 0000000000040000 (0x40000)
[ 3723.511197] ffff9f1f433ebcb8: 0000000000040000 (0x40000)
[ 3723.511198] ffff9f1f433ebcc0: ffff8c144d973e00 (0xffff8c144d973e00)
[ 3723.511198] ffff9f1f433ebcc8: ffff8c1614774910 (0xffff8c1614774910)
[ 3723.511198] ffff9f1f433ebcd0: 0000000000000001 (0x1)
[ 3723.511199] ffff9f1f433ebcd8: ffff9f1f433ebdc8 (0xffff9f1f433ebdc8)
[ 3723.511209] ffff9f1f433ebce0: ffffffffc057156a
(compress_file_range.constprop.69+0x1ba/0x840 [btrfs])
[ 3723.511210] ffff9f1f433ebce8: ffff9f1f433ebd80 (0xffff9f1f433ebd80)
[ 3723.511210] ffff9f1f433ebcf0: ffff9f1f433ebd90 (0xffff9f1f433ebd90)
[ 3723.511211] ffff9f1f433ebcf8: ffff9f1f433ebd88 (0xffff9f1f433ebd88)
[ 3723.511211] ffff9f1f433ebd00: 0000000000020000 (0x20000)
[ 3723.511212] ffff9f1f433ebd08: ffff8c15f7764000 (0xffff8c15f7764000)
[ 3723.511213] ffff9f1f433ebd10: ffffd25e40237000 (0xffffd25e40237000)
[ 3723.511214] ffff9f1f433ebd18: ffff8c15008ea580 (0xffff8c15008ea580)
[ 3723.511214] ffff9f1f433ebd20: ffff8c15008ea580 (0xffff8c15008ea580)
[ 3723.511215] ffff9f1f433ebd28: ffff8c15804e3800 (0xffff8c15804e3800)
[ 3723.511216] ffff9f1f433ebd30: 0000000000080000 (0x80000)
[ 3723.511217] ffff9f1f433ebd38: 00000001f77642c0 (0x1f77642c0)
[ 3723.511217] ffff9f1f433ebd40: 000000000000007f (0x7f)
[ 3723.511218] ffff9f1f433ebd48: ffff9f1f433ebddc (0xffff9f1f433ebddc)
[ 3723.511219] ffff9f1f433ebd50: ffff8c143b6d16c0 (0xffff8c143b6d16c0)
[ 3723.511220] ffff9f1f433ebd58: 0000000000000020 (0x20)
[ 3723.511221] ffff9f1f433ebd60: fffffffffffff000 (0xfffffffffffff000)
[ 3723.511221] ffff9f1f433ebd68: 0000000000080000 (0x80000)
[ 3723.511222] ffff9f1f433ebd70: 000000000007ffff (0x7ffff)
[ 3723.511223] ffff9f1f433ebd78: 0000000000001000 (0x1000)
[ 3723.511223] ffff9f1f433ebd80: 0000000000000000 ...
[ 3723.511224] ffff9f1f433ebd98: 00000000292abac3 (0x292abac3)
[ 3723.511225] ffff9f1f433ebda0: ffff8c143b6d16f8 (0xffff8c143b6d16f8)
[ 3723.511226] ffff9f1f433ebda8: ffff8c143b6d16f8 (0xffff8c143b6d16f8)
[ 3723.511227] ffff9f1f433ebdb0: ffff8c158bf56640 (0xffff8c158bf56640)
[ 3723.511227] ffff9f1f433ebdb8: ffff8c143b6d1710 (0xffff8c143b6d1710)
[ 3723.511237] ffff9f1f433ebdc0: ffffffffc0571320
(submit_compressed_extents+0x580/0x580 [btrfs])
[ 3723.511238] ffff9f1f433ebdc8: ffff9f1f433ebdf0 (0xffff9f1f433ebdf0)
[ 3723.511246] ffff9f1f433ebdd0: ffffffffc0571c34
(async_cow_start+0x44/0x80 [btrfs])
[ 3723.511246] ffff9f1f433ebdd8: 00000002433ebe38 (0x2433ebe38)
[ 3723.511247] ffff9f1f433ebde0: 00000000292abac3 (0x292abac3)
[ 3723.511247] ffff9f1f433ebde8: ffff8c1611384180 (0xffff8c1611384180)
[ 3723.511248] ffff9f1f433ebdf0: ffff9f1f433ebe38 (0xffff9f1f433ebe38)
[ 3723.511259] ffff9f1f433ebdf8: ffffffffc059e1e0
(btrfs_scrubparity_helper+0xc0/0x2f0 [btrfs])
[ 3723.511260] ffff9f1f433ebe00: ffffffff910bdf51
(pwq_activate_delayed_work+0x41/0xb0)
[ 3723.511261] ffff9f1f433ebe08: 00000000292abac3 (0x292abac3)
[ 3723.511262] ffff9f1f433ebe10: ffff8c1611384180 (0xffff8c1611384180)
[ 3723.511262] ffff9f1f433ebe18: ffff8c1616010800 (0xffff8c1616010800)
[ 3723.511263] ffff9f1f433ebe20: ffff8c15db56cc00 (0xffff8c15db56cc00)
[ 3723.511263] ffff9f1f433ebe28: ffff8c143b6d1718 (0xffff8c143b6d1718)
[ 3723.511264] ffff9f1f433ebe30: ffff8c143b6d1710 (0xffff8c143b6d1710)
[ 3723.511264] ffff9f1f433ebe38: ffff9f1f433ebe48 (0xffff9f1f433ebe48)
[ 3723.511276] ffff9f1f433ebe40: ffffffffc059e54e
(btrfs_delalloc_helper+0xe/0x10 [btrfs])
[ 3723.511277] ffff9f1f433ebe48: ffff9f1f433ebe90 (0xffff9f1f433ebe90)
[ 3723.511278] ffff9f1f433ebe50: ffffffff910bf417 (process_one_work+0x197/0x450)
[ 3723.511279] ffff9f1f433ebe58: ffff8c1616010800 (0xffff8c1616010800)
[ 3723.511279] ffff9f1f433ebe60: 0000000000000000 ...
[ 3723.511279] ffff9f1f433ebe68: ffff8c1616010800 (0xffff8c1616010800)
[ 3723.511280] ffff9f1f433ebe70: ffff8c16113841b0 (0xffff8c16113841b0)
[ 3723.511280] ffff9f1f433ebe78: 0000000000000088 (0x88)
[ 3723.511281] ffff9f1f433ebe80: ffff8c1616010820 (0xffff8c1616010820)
[ 3723.511281] ffff9f1f433ebe88: ffff8c1611384180 (0xffff8c1611384180)
[ 3723.511282] ffff9f1f433ebe90: ffff9f1f433ebef8 (0xffff9f1f433ebef8)
[ 3723.511283] ffff9f1f433ebe98: ffffffff910bf71e (worker_thread+0x4e/0x4a0)
[ 3723.511283] ffff9f1f433ebea0: ffff8c1616010aa8 (0xffff8c1616010aa8)
[ 3723.511284] ffff9f1f433ebea8: ffff8c15008ea580 (0xffff8c15008ea580)
[ 3723.511284] ffff9f1f433ebeb0: ffff8c15008ea580 (0xffff8c15008ea580)
[ 3723.511285] ffff9f1f433ebeb8: ffff8c15008ea580 (0xffff8c15008ea580)
[ 3723.511285] ffff9f1f433ebec0: ffff8c15008ea580 (0xffff8c15008ea580)
[ 3723.511286] ffff9f1f433ebec8: ffff8c1616010878 (0xffff8c1616010878)
[ 3723.511286] ffff9f1f433ebed0: ffff8c15cdb92420 (0xffff8c15cdb92420)
[ 3723.511287] ffff9f1f433ebed8: ffff8c1550dfd900 (0xffff8c1550dfd900)
[ 3723.511287] ffff9f1f433ebee0: ffff9f1f4393bd90 (0xffff9f1f4393bd90)
[ 3723.511288] ffff9f1f433ebee8: ffff8c1611384180 (0xffff8c1611384180)
[ 3723.511288] ffff9f1f433ebef0: ffff8c15008ea580 (0xffff8c15008ea580)
[ 3723.511289] ffff9f1f433ebef8: ffff9f1f433ebf40 (0xffff9f1f433ebf40)
[ 3723.511290] ffff9f1f433ebf00: ffffffff910c6441 (kthread+0x101/0x140)
[ 3723.511292] ffff9f1f433ebf08: ffffffff910bf6d0 (process_one_work+0x450/0x450)
[ 3723.511292] ffff9f1f433ebf10: ffff8c15cdb92458 (0xffff8c15cdb92458)
[ 3723.511294] ffff9f1f433ebf18: ffffffff910c6340 (kthread_park+0x90/0x90)
[ 3723.511294] ffff9f1f433ebf20: ffff8c1550dfd900 (0xffff8c1550dfd900)
[ 3723.511296] ffff9f1f433ebf28: ffffffff91003baa
(syscall_return_slowpath+0xaa/0xb0)
[ 3723.511296] ffff9f1f433ebf30: ffff9f1f433ebf48 (0xffff9f1f433ebf48)
[ 3723.511297] ffff9f1f433ebf38: 00000000ffffffff (0xffffffff)
[ 3723.511297] ffff9f1f433ebf40: ffff9f1f433ebf50 (0xffff9f1f433ebf50)
[ 3723.511299] ffff9f1f433ebf48: ffffffff9185549c (ret_from_fork+0x2c/0x40)
[ 3723.511299] ffff9f1f433ebf50: 0000000000000000 ...
