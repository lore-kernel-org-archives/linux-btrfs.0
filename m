Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:41286 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388099AbeGWPOy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jul 2018 11:14:54 -0400
Received: from tux.wizards.de (p3EE2F74B.dip0.t-ipconnect.de [62.226.247.75])
        by mail02.iobjects.de (Postfix) with ESMTPSA id 77F474161914
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jul 2018 16:13:26 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id 31A54F01612
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jul 2018 16:13:26 +0200 (CEST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Subject: Regression with crc32c selection?
Message-ID: <ca274e95-538c-0c0e-e184-3542b4524afe@applied-asynchrony.com>
Date: Mon, 23 Jul 2018 16:13:26 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

While backporting a bunch of fixes to my own 4.16.x tree
(4.17 had a few too many bugs for my taste) I also ended up merging:

df91f56adce1f: libcrc32c: Add crc32c_impl function
9678c54388b6a: btrfs: Remove custom crc32c init code

..which AFAIK went into 4.17 and seemed harmless enough; after fixing up
a trivial context conflict it builds, runs, all good..except that btrfs
(apprently?) no longer uses the preferred crc32c-intel module, but the
crc32c-generic one instead.

In order to rule out any mistakes on my part I built 4.18.0-rc6 and it
seems to have the same problem:

Jul 23 15:55:09 ragnarok kernel: raid6: sse2x1   gen() 11267 MB/s
Jul 23 15:55:09 ragnarok kernel: raid6: sse2x1   xor()  8110 MB/s
Jul 23 15:55:09 ragnarok kernel: raid6: sse2x2   gen() 13409 MB/s
Jul 23 15:55:09 ragnarok kernel: raid6: sse2x2   xor()  9137 MB/s
Jul 23 15:55:09 ragnarok kernel: raid6: sse2x4   gen() 15884 MB/s
Jul 23 15:55:09 ragnarok kernel: raid6: sse2x4   xor() 10579 MB/s
Jul 23 15:55:09 ragnarok kernel: raid6: using algorithm sse2x4 gen() 15884 MB/s
Jul 23 15:55:09 ragnarok kernel: raid6: .... xor() 10579 MB/s, rmw enabled
Jul 23 15:55:09 ragnarok kernel: raid6: using ssse3x2 recovery algorithm
Jul 23 15:55:09 ragnarok kernel: xor: automatically using best checksumming function   avx
Jul 23 15:55:09 ragnarok kernel: Btrfs loaded, crc32c=crc32c-generic

I understand that the new crc32c_impl() function changed from
crypto_tfm_alg_driver_name() to crypto_shash_driver_name() - could this
be the reason? The module is loaded just fine, but apprently not used:

$lsmod | grep crc32
crc32_pclmul           16384  0
crc32c_intel           24576  0

In other words, is this supposed to happen or is my kernel config somehow
no longer right? It worked before and doesn't look too wrong:

$grep CRC /etc/kernels/kernel-config-x86_64-4.18.0-rc6
# CONFIG_PCIE_ECRC is not set
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=m
# CONFIG_CRYPTO_CRCT10DIF is not set
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC4 is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set

Ultimately btrfs (and everything else) works, but the process of how
the kernel selects a crc32c implementation seems rather mysterious to me. :/

Any insights welcome. If it's a regression I can gladly test fixes.

cheers
Holger

