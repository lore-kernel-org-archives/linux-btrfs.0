From: Hadmut Danisch <hadmut@danisch.de>
Subject: Setting options permanently?
Date: Fri, 27 Jan 2012 16:03:40 +0100
Message-ID: <4F22BCCC.5090800@danisch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

just a question:

Mounting options for file systems are usually given on the command line
or in /etc/fstab.

Both do not work with mobile storage devices like usb hard disks, since
they are either mounted automatically through the desktop, or manually
by a user who does not know or remember the mount options for this file
system. At least it's error prone.



What happens if a btrfs is mounted sometimes with and sometimes without
the compression option? I'd guess it generates a mixture of compressed
and uncompressed files, what is not exactly smart.

Is there a way to set options like compression on a btrfs permanently to
activate them even when mounted automatically by the desktop or manually
by a third person?


regards
Hadmut

