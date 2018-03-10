Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:44256 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750703AbeCJSba (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Mar 2018 13:31:30 -0500
Date: Sat, 10 Mar 2018 23:31:27 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Adam Borowski <kilobyte@angband.pl>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: zerofree btrfs support?
Message-ID: <20180310233127.0dfa7823@natsu>
In-Reply-To: <20180310155022.wtdmwiyxu7mxt74s@angband.pl>
References: <1520650525.5641.47.camel@scientia.net>
        <20180310081606.7c2u2dtopijujhbz@angband.pl>
        <1520691545.24363.10.camel@scientia.net>
        <20180310193722.2d6b494a@natsu>
        <20180310155022.wtdmwiyxu7mxt74s@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 10 Mar 2018 16:50:22 +0100
Adam Borowski <kilobyte@angband.pl> wrote:

> Since we're on a btrfs mailing list, if you use qemu, you really want
> sparse format:raw instead of qcow2 or preallocated raw.  This also works
> great with TRIM.

Agreed, that's why I use RAW. QCOW2 would add a second layer of COW on top of
Btrfs, which sounds like a nightmare. Even if you would run those files as
NOCOW in Btrfs, somehow I feel FS-native COW is more efficient than emulating
it in userspace with special format files.

> > It works, just not with some of the QEMU virtualized disk device drivers.
> > You don't need to use qemu-img to manually dig holes either, it's all
> > automatic.
> 
> It works only with scsi and virtio-scsi drivers.  Most qemu setups use
> either ide (ouch!) or virtio-blk.

It works with IDE as well.

-- 
With respect,
Roman
