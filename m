Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:56698 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966647AbcKLSBM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 Nov 2016 13:01:12 -0500
Received: from [192.168.0.32] (adsl.bouton.name [82.234.193.23])
        by mail.bouton.name (Postfix) with ESMTP id EDDAFB943
        for <linux-btrfs@vger.kernel.org>; Sat, 12 Nov 2016 19:01:09 +0100 (CET)
Subject: replace panic solved with add/balance/delete was: Compression and
 device replace on raid10 kernel panic on 4.4.6 and 4.6.x
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <b1fd641c-7047-e83c-83ff-582c6abfb815@bouton.name>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <7a0d9d30-3c83-69b2-e2ff-45ab82ca0cc3@bouton.name>
Date: Sat, 12 Nov 2016 19:01:09 +0100
MIME-Version: 1.0
In-Reply-To: <b1fd641c-7047-e83c-83ff-582c6abfb815@bouton.name>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

here's how I managed to recover from a BTRFS replace panic which
happened even on 4.8.4.

The kernel didn't seem to handle our raid10 filesystem with a missing
device correctly (even though it passed a precautionary scrub before
removing the device) :
- replace didn't work and triggered a kernel panic,
- we saw PostgreSQL corruption (duplicate entries in indexes and write
errors), both for database clusters using NoCoW and CoW (we run several
clusters on this filesystem and configure them differently based on our
needs).

What finally worked is adding devices to the filesystem, balancing (I
added skip_balance in fstab in case balance would trigger a panic like
replace) which removed data allocated to the missing device and then
delete it.
I didn't dare delete without balancing first as I couldn't get
confirmation that skip_balance would prevent the balance triggered by
delete to stop (which could mean a panic each time we tried to mount the
filesystem). In the end it seems that balancing before deleting is doing
the same work : balance correctly detects that it shouldn't use the
missing device and reallocate all data properly.

The sad result is that we are currently forced to check/restore most of
the data just because we had to replace a single disk : clearly BTRFS
can't handle itself properly until the missing device is completely
removed. That's not what I expected to do when using raid10 :-(

Best regards,

Lionel
