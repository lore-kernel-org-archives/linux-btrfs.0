From: Werner Fischer <devlists@wefi.net>
Subject: will mkfs.btrfs do an initial pre-discard for SSDs like mke2fs
 does for Ext4?
Date: Sun, 03 Jul 2011 13:00:13 +0200
Message-ID: <1309690813.2987.8.camel@werner-t410>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

are there any plans that future versions of mkfs.btrfs will do an
initial pre-discard for SSDs? (AFAIK mkfs.btrfs does not do this
currently)

For Ext4, mke2fs does this with the -E discard option.
>From the mke2fs manpage:
  -E discard
    Attempt to discard blocks at mkfs time (discarding blocks initially is useful
    on solid state devices and sparse / thin-provisioned storage). When the device
    advertises that discard also zeroes data (any subsequent read after the discard
    and before write returns zero), then mark all not-yet-zeroed inode tables as
    zeroed. This significantly speeds up filesystem initialization. This is set
    as default.

Best regards,
Werner


