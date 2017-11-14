Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:55154 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755803AbdKNRpa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 12:45:30 -0500
Received: by mail-lf0-f46.google.com with SMTP id a2so23250135lfh.11
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Nov 2017 09:45:29 -0800 (PST)
Subject: Re: how to repair or access broken btrfs?
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <32c4071e-4ec0-4d22-95f9-68b22725cff7@profihost.ag>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <c43e6c85-2ecc-47a6-2a59-45c65dd693bc@gmail.com>
Date: Tue, 14 Nov 2017 20:45:26 +0300
MIME-Version: 1.0
In-Reply-To: <32c4071e-4ec0-4d22-95f9-68b22725cff7@profihost.ag>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

14.11.2017 12:56, Stefan Priebe - Profihost AG пишет:
> Hello,
> 
> after a controller firmware bug / failure i've a broken btrfs.
> 
> # parent transid verify failed on 181846016 wanted 143404 found 143399
> 
> running repair, fsck or zero-log always results in the same failure message:
> extent-tree.c:2725: alloc_reserved_tree_block: BUG_ON `ret` triggered,
> value -1
> .. stack trace ..
> 
> Is there an chance to get at least a single file out of the broken fs?
> 

Did you try "btrfs restore"?
