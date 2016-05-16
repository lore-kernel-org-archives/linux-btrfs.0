Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:38611 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbcEPCL3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 May 2016 22:11:29 -0400
Received: by mail-wm0-f43.google.com with SMTP id g17so113753951wme.1
        for <linux-btrfs@vger.kernel.org>; Sun, 15 May 2016 19:11:28 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 15 May 2016 22:11:27 -0400
Message-ID: <CAD=QJKjop2j+K16nPcAU-bXiCVqm_aGK0g7WxjvTpBvXar+fQQ@mail.gmail.com>
Subject: problems with free space cache
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The volume was created with btrfs-progs-4.4.41; I upgraded to
linux-4.4.10 today, and here is what I grepped from my dmesg:

[  +0.002613] Btrfs loaded
[  +0.080621] BTRFS: device label Red devid 1 transid 108234 /dev/sda3
[  +0.000106] BTRFS: device label Red devid 2 transid 108234 /dev/sdb2
[  +0.011888] BTRFS info (device sdb2): disk space caching is enabled
[  +0.000001] BTRFS: has skinny extents
[  +0.063532] BTRFS info (device sdb2): disk space caching is enabled
[  +3.615389] BTRFS warning (device sdb2): block group 183639212032
has wrong amount of free space
[  +0.000002] BTRFS warning (device sdb2): failed to load free space
cache for block group 183639212032, rebuilding it now
[  +1.718348] BTRFS warning (device sdb2): block group 859022819328
has wrong amount of free space
[  +0.000003] BTRFS warning (device sdb2): failed to load free space
cache for block group 859022819328, rebuilding it now
[  +4.357965] BTRFS info (device sdb2): The free space cache file
(1082361118720) is invalid. skip it
[  +0.026489] BTRFS info (device sdb2): The free space cache file
(1094172278784) is invalid. skip it
[  +0.740340] BTRFS info (device sdb2): The free space cache file
(1183292850176) is invalid. skip it
[  +0.610161] BTRFS info (device sdb2): The free space cache file
(1248791101440) is invalid. skip it
[  +0.353670] BTRFS info (device sdb2): The free space cache file
(1284224581632) is invalid. skip it

What is the standard procedure for fixing the cache?  Rootfs is a
subvolume and the first entry in fstab.  Second entry is /btrfs-admin,
which is where I mount the whole volume.  Is it sufficient to add the
clear_cache option to the rootfs entry, or does the /btrfs-admin entry
also need it?

>From what I've read in the documentation one modifies fstab, reboots,
removes modification from fstab, and it's fixed.

Cheers,
Nicholas
