Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:34402 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932885AbdD0PMu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Apr 2017 11:12:50 -0400
Received: by mail-wr0-f179.google.com with SMTP id l9so19052263wre.1
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Apr 2017 08:12:49 -0700 (PDT)
Received: from [192.168.77.22] (val06-1-88-182-161-34.fbx.proxad.net. [88.182.161.34])
        by smtp.gmail.com with ESMTPSA id g25sm4638437wra.1.2017.04.27.08.12.47
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Apr 2017 08:12:47 -0700 (PDT)
From: Christophe de Dinechin <dinechin@redhat.com>
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: File system corruption, btrfsck abort
Date: Thu, 27 Apr 2017 17:12:45 +0200
References: <D64BF81E-58B3-4B19-AD65-F5056768466C@redhat.com>
 <0A381C78-EC2E-42A8-92D6-E9465F0F86FE@redhat.com>
To: linux-btrfs@vger.kernel.org
In-Reply-To: <0A381C78-EC2E-42A8-92D6-E9465F0F86FE@redhat.com>
Message-Id: <0589B556-02B3-4D7F-A91B-36BFBFA3FE96@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On 27 Apr 2017, at 16:58, Christophe de Dinechin <dinechin@redhat.com> wrote:
> 
>> On 25 Apr 2017, at 19:50, Christophe de Dinechin <dinechin@redhat.com> wrote:
> 
>> The cause of the abort is that we call set_extent_dirty from check_extent_refs with rec->max_size == 0. I’ve instrumented to try to see where we set this to 0 (see https://github.com/c3d/btrfs-progs/tree/rhbz1435567), and indeed, we do sometimes see max_size set to 0 in a few locations. My instrumentation shows this:
>> 
>> 78655 [1.792241:0x451fe0] MAX_SIZE_ZERO: Add extent rec 0x139eb80 max_size 16384 tmpl 0x7fffffffd120
>> 78657 [1.792242:0x451cb8] MAX_SIZE_ZERO: Set max size 0 for rec 0x139ec50 from tmpl 0x7fffffffcf80
>> 78660 [1.792244:0x451fe0] MAX_SIZE_ZERO: Add extent rec 0x139ed50 max_size 16384 tmpl 0x7fffffffd120
>> 
>> I don’t really know what to make of it.
> 
> I dig a bit deeper. We set rec->max_size = 0 in add_extent_rec_nolookup called from add_tree_backref, where we cleared the extent_record tmpl with a memset, so indeed, max_size is 0. However, we immediately after that do a lookup_cache_extent with a size of 1. So I wonder if at that stage, we should not set max_size to 1 for the newly created extent record.

Well, for what it’s worth, it does not seem to help much:

*** Error in `btrfs check': double free or corruption (!prev): 0x0000000007d9c430 ***
======= Backtrace: =========
/lib64/libc.so.6(+0x7925b)[0x7ffff6feb25b]
/lib64/libc.so.6(+0x828ea)[0x7ffff6ff48ea]
/lib64/libc.so.6(cfree+0x4c)[0x7ffff6ff831c]
btrfs check[0x44d784]
btrfs check[0x4531ac]
btrfs check[0x45b24b]
btrfs check[0x45b743]
btrfs check[0x45c2b1]
btrfs check(cmd_check+0xcad)[0x4602d4]
btrfs check(main+0x8b)[0x40b7fb]
/lib64/libc.so.6(__libc_start_main+0xf1)[0x7ffff6f92401]
btrfs check(_start+0x2a)[0x40b4ba]
======= Memory map: ========
00400000-004a4000 r-xp 00000000 08:35 25167142                           /home/ddd/Work/btrfs-progs/btrfs
006a4000-006a8000 r--p 000a4000 08:35 25167142                           /home/ddd/Work/btrfs-progs/btrfs
006a8000-006fb000 rw-p 000a8000 08:35 25167142                           /home/ddd/Work/btrfs-progs/btrfs
006fb000-316a6000 rw-p 00000000 00:00 0                                  [heap]
7ffff0000000-7ffff0021000 rw-p 00000000 00:00 0 
7ffff0021000-7ffff4000000 ---p 00000000 00:00 0 
7ffff6d5b000-7ffff6d71000 r-xp 00000000 08:33 3156890                    /usr/lib64/libgcc_s-6.3.1-20161221.so.1
7ffff6d71000-7ffff6f70000 ---p 00016000 08:33 3156890                    /usr/lib64/libgcc_s-6.3.1-20161221.so.1
7ffff6f70000-7ffff6f71000 r--p 00015000 08:33 3156890                    /usr/lib64/libgcc_s-6.3.1-20161221.so.1
7ffff6f71000-7ffff6f72000 rw-p 00016000 08:33 3156890                    /usr/lib64/libgcc_s-6.3.1-20161221.so.1
7ffff6f72000-7ffff712f000 r-xp 00000000 08:33 3154711                    /usr/lib64/libc-2.24.so
7ffff712f000-7ffff732e000 ---p 001bd000 08:33 3154711                    /usr/lib64/libc-2.24.so
7ffff732e000-7ffff7332000 r--p 001bc000 08:33 3154711                    /usr/lib64/libc-2.24.so
7ffff7332000-7ffff7334000 rw-p 001c0000 08:33 3154711                    /usr/lib64/libc-2.24.so
7ffff7334000-7ffff7338000 rw-p 00000000 00:00 0 
7ffff7338000-7ffff7350000 r-xp 00000000 08:33 3155302                    /usr/lib64/libpthread-2.24.so
7ffff7350000-7ffff7550000 ---p 00018000 08:33 3155302                    /usr/lib64/libpthread-2.24.so
7ffff7550000-7ffff7551000 r--p 00018000 08:33 3155302                    /usr/lib64/libpthread-2.24.so
7ffff7551000-7ffff7552000 rw-p 00019000 08:33 3155302                    /usr/lib64/libpthread-2.24.so
7ffff7552000-7ffff7556000 rw-p 00000000 00:00 0 
7ffff7556000-7ffff7578000 r-xp 00000000 08:33 3155132                    /usr/lib64/liblzo2.so.2.0.0
7ffff7578000-7ffff7777000 ---p 00022000 08:33 3155132                    /usr/lib64/liblzo2.so.2.0.0
7ffff7777000-7ffff7778000 r--p 00021000 08:33 3155132                    /usr/lib64/liblzo2.so.2.0.0
7ffff7778000-7ffff7779000 rw-p 00000000 00:00 0 
7ffff7779000-7ffff778e000 r-xp 00000000 08:33 3155608                    /usr/lib64/libz.so.1.2.8
7ffff778e000-7ffff798d000 ---p 00015000 08:33 3155608                    /usr/lib64/libz.so.1.2.8
7ffff798d000-7ffff798e000 r--p 00014000 08:33 3155608                    /usr/lib64/libz.so.1.2.8
7ffff798e000-7ffff798f000 rw-p 00015000 08:33 3155608                    /usr/lib64/libz.so.1.2.8
7ffff798f000-7ffff79cc000 r-xp 00000000 08:33 3153511                    /usr/lib64/libblkid.so.1.1.0
7ffff79cc000-7ffff7bcc000 ---p 0003d000 08:33 3153511                    /usr/lib64/libblkid.so.1.1.0
7ffff7bcc000-7ffff7bd0000 r--p 0003d000 08:33 3153511                    /usr/lib64/libblkid.so.1.1.0
7ffff7bd0000-7ffff7bd1000 rw-p 00041000 08:33 3153511                    /usr/lib64/libblkid.so.1.1.0
7ffff7bd1000-7ffff7bd2000 rw-p 00000000 00:00 0 
7ffff7bd2000-7ffff7bd6000 r-xp 00000000 08:33 3154270                    /usr/lib64/libuuid.so.1.3.0
7ffff7bd6000-7ffff7dd5000 ---p 00004000 08:33 3154270                    /usr/lib64/libuuid.so.1.3.0
7ffff7dd5000-7ffff7dd6000 r--p 00003000 08:33 3154270                    /usr/lib64/libuuid.so.1.3.0
7ffff7dd6000-7ffff7dd7000 rw-p 00000000 00:00 0 
7ffff7dd7000-7ffff7dfc000 r-xp 00000000 08:33 3154536                    /usr/lib64/ld-2.24.so
7ffff7fdb000-7ffff7fe0000 rw-p 00000000 00:00 0 
7ffff7ff5000-7ffff7ff8000 rw-p 00000000 00:00 0 
7ffff7ff8000-7ffff7ffa000 r--p 00000000 00:00 0                          [vvar]
7ffff7ffa000-7ffff7ffc000 r-xp 00000000 00:00 0                          [vdso]
7ffff7ffc000-7ffff7ffd000 r--p 00025000 08:33 3154536                    /usr/lib64/ld-2.24.so
7ffff7ffd000-7ffff7ffe000 rw-p 00026000 08:33 3154536                    /usr/lib64/ld-2.24.so
7ffff7ffe000-7ffff7fff000 rw-p 00000000 00:00 0 
7ffffffde000-7ffffffff000 rw-p 00000000 00:00 0                          [stack]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]

This seems to match the other scenario I was referring to, with an inconsistent list.

> 
> Opinions?
> 
> Christophe
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

