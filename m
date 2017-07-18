Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:51650 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751371AbdGRMEy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Jul 2017 08:04:54 -0400
Received: from natsu (unknown [IPv6:fd39::e9:9eff:fe8f:1bcf])
        by len.romanrm.net (Postfix) with SMTP id D468020318
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Jul 2017 11:57:11 +0000 (UTC)
Date: Tue, 18 Jul 2017 16:57:10 +0500
From: Roman Mamedov <rm@romanrm.net>
To: linux-btrfs@vger.kernel.org
Subject: "detect-zeroes=unmap" support in Btrfs?
Message-ID: <20170718165710.111ac97e@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Qemu/KVM has this nice feature in its storage layer, "detect-zeroes=unmap".
Basically the VM host detects if a block written by the guest consists of
zeroes entirely, and instead of writing zeroes to the backing storage,
converts that into an "unmap" operation (FALLOC_FL_PUNCH_HOLE[1]).

I wonder if the same could be added into Btrfs directly? With a CoW filesystem
there is really no reason to store long runs of zeroes, or even spend
compression cycles on them (even if they compress really well), it would be
more efficient to turn all zero-filled blocks into file holes. (In effect
forcing all files with zero blocks into always being "sparse" files.)

You could say this increases fragmentation, but given the CoW nature of Btrfs,
any write to a file increases fragmentation already (except with "nocow"), and
converting zeroes into holes would be beneficial due to not requiring any
actual IO when those need to be read (reading back zeroes which are not stored
anywhere, as opposed to reading actual zeroes from disk).

[1] http://man7.org/linux/man-pages/man2/fallocate.2.html

-- 
With respect,
Roman
