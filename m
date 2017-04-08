Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:34129 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751166AbdDHRpg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Apr 2017 13:45:36 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.20.1704090002520.35546@x220i>
References: <alpine.LNX.2.20.1704090002520.35546@x220i>
From: Fabio Estevam <festevam@gmail.com>
Date: Sat, 8 Apr 2017 14:45:34 -0300
Message-ID: <CAOMZO5B9J15qvrsjOb-e5gk47gA=+2p2yLNLhswG+H3S0L7LXg@mail.gmail.com>
Subject: Re: Linux next-20170407 failed to build on ARM due to usage of mod in
 btrfs code
To: Icenowy Zheng <icenowy@aosc.io>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 8, 2017 at 1:02 PM, Icenowy Zheng <icenowy@aosc.io> wrote:
> Hello everyone,
> Today I tried to build a kernel with btrfs enabled on ARM, then when linking
> I met such an error:
>
> ```
> fs/built-in.o: In function `scrub_bio_end_io_worker':
> acl.c:(.text+0x2f0450): undefined reference to `__aeabi_uldivmod'
> fs/built-in.o: In function `scrub_extent_for_parity':
> acl.c:(.text+0x2f0bcc): undefined reference to `__aeabi_uldivmod'
> fs/built-in.o: In function `scrub_raid56_parity':
> acl.c:(.text+0x2f12a8): undefined reference to `__aeabi_uldivmod'
> acl.c:(.text+0x2f15c4): undefined reference to `__aeabi_uldivmod'
> ```
>
> These functions are found at fs/btrfs/scrub.c .
>
> After disabling btrfs the kernel is successfully built.

I see the same error with ARM imx_v6_v7_defconfig + btrfs support.

Looks like it is caused by commit 7d0ef8b4dbbd220 ("Btrfs: update
scrub_parity to use u64 stripe_len").
