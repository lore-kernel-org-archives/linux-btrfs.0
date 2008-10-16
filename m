From: "Miguel Sousa Filipe" <miguel.filipe@gmail.com>
Subject: crc32c implementation on x86 with SSE4.2... CONFIG_BTRFS_HW_SUM
Date: Thu, 16 Oct 2008 14:40:27 +0100
Message-ID: <f058a9c30810160640r3a8c8427hc8b35d6881583fb5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

I noticed that btrfs, in the git tree, has its own implementation of
crc32c for x86 with SSE4.2 that implement a crc32 instruction.. it
appears.
Its protected by a ifdef CONFIG_BTRFS_HW_SUM, and if we're executing
on the right cpu, that will bypass the kernel implementation of
crc32c.

please see: http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=blob_plain;f=fs/btrfs/crc32c.h;hb=HEAD

Based on this understanding, should this be a implementation detail of
crc32c, and be correctly implemented (and therefore patched) in the
mainline kernel implementation of crc32c ?

I know that checksumming is cpu expensive, and btrfs wants the best
impl. possible. but that shouldn't be a btrfs issue, that should be
crc32c issue, and its the crc32c implementation that should be fixed,
instead of having our own special crc32c in case we're executing in
the right cpu.

Should I post a patch with this for the vanilla crc32c implementation?

kind regards,

-- 
Miguel Sousa Filipe
