Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:58506 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728360AbeGYR3A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jul 2018 13:29:00 -0400
Received: from natsu (unknown [IPv6:fd39::e9:9eff:fe8f:1bcf])
        by rin.romanrm.net (Postfix) with SMTP id 644BD4018E
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2018 16:16:37 +0000 (UTC)
Date: Wed, 25 Jul 2018 21:16:36 +0500
From: Roman Mamedov <rm@romanrm.net>
To: linux-btrfs@vger.kernel.org
Subject: "error inheriting props for ino": Btrfs "compression" property
Message-ID: <20180725211636.36d66800@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

On two machines I have subvolumes where I backup other hosts' root filesystems
via rsync. These subvolumes have the +c attribute on them.

During the backup, sometimes I get tons of messages like these in dmesg:

[Wed Jul 25 20:58:22 2018] BTRFS error (device dm-8): error inheriting props for ino 1213720 (root 1301): -28
[Wed Jul 25 20:58:22 2018] BTRFS error (device dm-8): error inheriting props for ino 1213723 (root 1301): -28
[Wed Jul 25 20:58:22 2018] BTRFS error (device dm-8): error inheriting props for ino 1213724 (root 1301): -28
[Wed Jul 25 20:58:22 2018] BTRFS error (device dm-8): error inheriting props for ino 1213725 (root 1301): -28

# btrfs inspect inode-resolve 1213720 .
./gemini/lib/modules/4.14.58-rm2+/kernel/virt

This seems to be related to the "compression" property in Btrfs:

# btrfs property get ./gemini/lib/modules/4.14.58-rm2+/
compression=zlib

# btrfs property get ./gemini/lib/modules/4.14.58-rm2+/kernel/virt

(no output)

Why would it fail like that? This does seem harmless, but the messages are annoying and it's puzzling why 
this happens in the first place.

-- 
With respect,
Roman
