From: "A. James Lewis" <james@fsck.co.uk>
Subject: Configuring default mount options..
Date: Mon, 26 Jul 2010 01:56:46 +0100
Message-ID: <1280105806.3327.4.camel@hardline>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If using BTRFS on a removable drive... it may be a problem for example,
to always mount with compression, or always mount with encryption (If
supported in future)... perhaps btrfstune could define default mount
options, such as compression... so if there is a BTRFS filesystem on a
removable hard drive, or flash stick, the filesystem can be configured
to mount with compression by default.

Maybe there is a way to do this already, but it seems like the
filesystem itself should contain preferences for the way it is used
under those circumstances.

A. James Lewis



