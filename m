Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:33681 "EHLO
	mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbcGRHvE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jul 2016 03:51:04 -0400
Received: by mail-vk0-f68.google.com with SMTP id s189so1394378vkh.0
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jul 2016 00:51:03 -0700 (PDT)
MIME-Version: 1.0
From: Anatoly Pugachev <matorola@gmail.com>
Date: Mon, 18 Jul 2016 10:51:01 +0300
Message-ID: <CADxRZqxz7XJ43i_Mn8kdnP7KPR2sK1wK5T2B-QAYj9_jCqUbCg@mail.gmail.com>
Subject: xfstests: error: redefinition of 'struct fsxattr'
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

I can't compile xfstests on 4.6.3 kernel (headers installed) on debian
sid (unstable).

mator@windrunner:~/xfstests$ dpkg -l linux-image-4.6.0-1-amd64 linux-libc-dev
Desired=Unknown/Install/Remove/Purge/Hold
| Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
|/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
||/ Name                                    Version
Architecture             Description
+++-=======================================-========================-========================
ii  linux-image-4.6.0-1-amd64               4.6.3-1
amd64                    Linux 4.6 for 64-bit PCs
ii  linux-libc-dev:amd64                    4.6.3-1
amd64                    Linux support headers for userspace
development

mator@windrunner:~/xfstests$ uname -a
Linux windrunner 4.6.0-1-amd64 #1 SMP Debian 4.6.3-1 (2016-07-04)
x86_64 GNU/Linux

mator@windrunner:~/xfstests$ git describe
linux-v3.8-1104-g024bdae

mator@windrunner:~/xfstests$ make
Building include
Building lib
    [LTDEP]
    [CC] dataascii.lo
    [CC] databin.lo
    [CC] datapid.lo
    [CC] file_lock.lo
    [CC] forker.lo
    [CC] pattern.lo
    [CC] open_flags.lo
    [CC] random_range.lo
    [CC] string_to_tokens.lo
    [CC] str_to_bytes.lo
    [CC] tlibio.lo
    [CC] write_log.lo
    [CC] random.lo
    [LD]
ar: `u' modifier ignored since `D' is the default (see `U')
Building ltp
    [DEP]
    [CC]    doio
    [CC]    fsstress
In file included from /usr/include/xfs/xfs.h:58:0,
                 from ../src/global.h:25,
                 from fsstress.c:20:
/usr/include/xfs/xfs_fs.h:42:8: error: redefinition of 'struct fsxattr'
 struct fsxattr {
        ^
In file included from fsstress.c:19:0:
/usr/include/linux/fs.h:155:8: note: originally defined here
 struct fsxattr {
        ^
Makefile:42: recipe for target 'fsstress' failed
make[2]: *** [fsstress] Error 1
include/buildrules:30: recipe for target 'ltp' failed
make[1]: *** [ltp] Error 2
Makefile:66: recipe for target 'default' failed
make: *** [default] Error 2
mator@windrunner:~/xfstests$


So far, I've found
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=822369 where it is
told that there's uapi change in 4.5+ kernel.
How to fix xfstests on compile on 4.5+ kernels?

Thanks.

PS: and maybe a new git tag (since there's over 1000 commits already) ?
