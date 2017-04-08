Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hermes.aosc.io ([199.195.250.187]:38701 "EHLO hermes.aosc.io"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751542AbdDHQJu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 8 Apr 2017 12:09:50 -0400
Date: Sun, 9 Apr 2017 00:02:58 +0800 (CST)
From: Icenowy Zheng <icenowy@aosc.io>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Linux next-20170407 failed to build on ARM due to usage of mod in
 btrfs code
Message-ID: <alpine.LNX.2.20.1704090002520.35546@x220i>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,
Today I tried to build a kernel with btrfs enabled on ARM, then when 
linking I met such an error:

```
fs/built-in.o: In function `scrub_bio_end_io_worker':
acl.c:(.text+0x2f0450): undefined reference to `__aeabi_uldivmod'
fs/built-in.o: In function `scrub_extent_for_parity':
acl.c:(.text+0x2f0bcc): undefined reference to `__aeabi_uldivmod'
fs/built-in.o: In function `scrub_raid56_parity':
acl.c:(.text+0x2f12a8): undefined reference to `__aeabi_uldivmod'
acl.c:(.text+0x2f15c4): undefined reference to `__aeabi_uldivmod'
```

These functions are found at fs/btrfs/scrub.c .

After disabling btrfs the kernel is successfully built.

For this problem, see also [1], which used to be a similar bug in PL330 
driver code.

[1] https://patchwork.kernel.org/patch/5299081/

Thanks,
Icenowy
