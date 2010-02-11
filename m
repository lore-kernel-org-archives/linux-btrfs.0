From: Sten Heinze <sten.heinze@gmx.de>
Subject: Patch: Allow options to be passed to btrfsck
Date: Thu, 11 Feb 2010 13:59:43 +0100
Message-ID: <201002111359.43978.sten.heinze@gmx.de>
References: <4B71B538.1040709@debian.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Cc: 567681@bugs.debian.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B71B538.1040709@debian.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch makes btrfsck ignore (for now) options passed to it. This makes 
btrfsck runs on startup not failing. I was asked to post my patch here by the 
Debian Maintainer of btrfs-tools.

Background: On Startup all filesystem (on a Debian system) are fsck'ed. A 
option to allow non-interactive filesystem checks on startup is passed to fsck, 
usually -a or -y. 
Currently btrfsck expects the device as the only parameter and fails if run 
with any option e.g. btrfsck -a /dev/hda1 (returns error code 1). My patch 
fixes this by allowing options to be passed, although all options are ignored 
at the moment. (The attached patch is slightly improved from the one I sent to 
the Debian bug report [1] before.)

Please comment if this is acceptable for inclusion in btrfsck. If not, I would 
be happy to improve the patch.

Thanks,
Sten

[1] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=567681
