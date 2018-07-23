Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:43163 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387953AbeGWPks (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jul 2018 11:40:48 -0400
Received: by mail-qt0-f176.google.com with SMTP id f18-v6so820470qtp.10
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jul 2018 07:39:14 -0700 (PDT)
MIME-Version: 1.0
References: <ca274e95-538c-0c0e-e184-3542b4524afe@applied-asynchrony.com>
In-Reply-To: <ca274e95-538c-0c0e-e184-3542b4524afe@applied-asynchrony.com>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Mon, 23 Jul 2018 16:39:01 +0200
Message-ID: <CAA7pwKMRuDLS64zqQuTHN4DbM2HE-wBkpPJw-7kmAy6NJxqg_g@mail.gmail.com>
Subject: Re: Regression with crc32c selection?
To: holger@applied-asynchrony.com
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

$ uname -a
Linux nas 4.17.0-1-amd64 #1 SMP Debian 4.17.8-1 (2018-07-20) x86_64 GNU/Linux

$ dmesg | grep Btrfs
[    8.168408] Btrfs loaded, crc32c=crc32c-intel

$ lsmod | grep crc32
crc32_pclmul           16384  0
libcrc32c              16384  1 btrfs
crc32c_generic         16384  0
crc32c_intel           24576  2

$ grep CRC /boot/config-4.17.0-1-amd64
# CONFIG_PCIE_ECRC is not set
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC4 is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m


On Mon, 23 Jul 2018 at 16:14, Holger Hoffstätte
<holger@applied-asynchrony.com> wrote:
>
> Hi,
>
> While backporting a bunch of fixes to my own 4.16.x tree
> (4.17 had a few too many bugs for my taste) I also ended up merging:
>
> df91f56adce1f: libcrc32c: Add crc32c_impl function
> 9678c54388b6a: btrfs: Remove custom crc32c init code
>
> ..which AFAIK went into 4.17 and seemed harmless enough; after fixing up
> a trivial context conflict it builds, runs, all good..except that btrfs
> (apprently?) no longer uses the preferred crc32c-intel module, but the
> crc32c-generic one instead.
>
> In order to rule out any mistakes on my part I built 4.18.0-rc6 and it
> seems to have the same problem:
>
> Jul 23 15:55:09 ragnarok kernel: raid6: sse2x1   gen() 11267 MB/s
> Jul 23 15:55:09 ragnarok kernel: raid6: sse2x1   xor()  8110 MB/s
> Jul 23 15:55:09 ragnarok kernel: raid6: sse2x2   gen() 13409 MB/s
> Jul 23 15:55:09 ragnarok kernel: raid6: sse2x2   xor()  9137 MB/s
> Jul 23 15:55:09 ragnarok kernel: raid6: sse2x4   gen() 15884 MB/s
> Jul 23 15:55:09 ragnarok kernel: raid6: sse2x4   xor() 10579 MB/s
> Jul 23 15:55:09 ragnarok kernel: raid6: using algorithm sse2x4 gen() 15884 MB/s
> Jul 23 15:55:09 ragnarok kernel: raid6: .... xor() 10579 MB/s, rmw enabled
> Jul 23 15:55:09 ragnarok kernel: raid6: using ssse3x2 recovery algorithm
> Jul 23 15:55:09 ragnarok kernel: xor: automatically using best checksumming function   avx
> Jul 23 15:55:09 ragnarok kernel: Btrfs loaded, crc32c=crc32c-generic
>
> I understand that the new crc32c_impl() function changed from
> crypto_tfm_alg_driver_name() to crypto_shash_driver_name() - could this
> be the reason? The module is loaded just fine, but apprently not used:
>
> $lsmod | grep crc32
> crc32_pclmul           16384  0
> crc32c_intel           24576  0
>
> In other words, is this supposed to happen or is my kernel config somehow
> no longer right? It worked before and doesn't look too wrong:
>
> $grep CRC /etc/kernels/kernel-config-x86_64-4.18.0-rc6
> # CONFIG_PCIE_ECRC is not set
> CONFIG_CRYPTO_CRC32C=y
> CONFIG_CRYPTO_CRC32C_INTEL=m
> CONFIG_CRYPTO_CRC32=m
> CONFIG_CRYPTO_CRC32_PCLMUL=m
> # CONFIG_CRYPTO_CRCT10DIF is not set
> CONFIG_CRC_CCITT=m
> CONFIG_CRC16=y
> # CONFIG_CRC_T10DIF is not set
> CONFIG_CRC_ITU_T=y
> CONFIG_CRC32=y
> # CONFIG_CRC32_SELFTEST is not set
> CONFIG_CRC32_SLICEBY8=y
> # CONFIG_CRC32_SLICEBY4 is not set
> # CONFIG_CRC32_SARWATE is not set
> # CONFIG_CRC32_BIT is not set
> # CONFIG_CRC4 is not set
> # CONFIG_CRC7 is not set
> CONFIG_LIBCRC32C=y
> # CONFIG_CRC8 is not set
>
> Ultimately btrfs (and everything else) works, but the process of how
> the kernel selects a crc32c implementation seems rather mysterious to me. :/
>
> Any insights welcome. If it's a regression I can gladly test fixes.
>
> cheers
> Holger
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
