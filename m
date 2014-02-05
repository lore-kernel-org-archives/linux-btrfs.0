Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:61370 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaBENcI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Feb 2014 08:32:08 -0500
Received: by mail-pb0-f48.google.com with SMTP id rr13so372538pbb.7
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Feb 2014 05:32:08 -0800 (PST)
MIME-Version: 1.0
From: Elifarley Callado Coelho Cruz <elifarley@gmail.com>
Date: Wed, 5 Feb 2014 11:31:28 -0200
Message-ID: <CALU6X8=qRRT5CTj0M_E34dJapQemo61Qi2QZRpxRG91O3Z8yxg@mail.gmail.com>
Subject: Frequent error messages (block group X has wrong amount of free space)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've recently installed ArchLinux on a Lenovo Ideapad laptop.
Right on the first day of use, I received error messages at boot time
like these:

BTRFS error (device dm-0): block group 11840520192 has wrong amount of
free space
BTRFS error (device dm-0): failed to load free space cache for block
group 11840520192


Then I added the clear_cache option to see if the problem would go
away. After 3 boots, it did go away. But after some more boots, it's
back!

I believe there has been no unclean shutdowns nor lock-ups so far.

What could be causing this error during normal operation?

I have:
Kernel 3.12.9
btrfs-progs 3.12

/etc/fstab:

# /dev/mapper/luks-pool
UUID=c56031b3-af27-41f6-8103-ede1f0743ac0       /               btrfs
         subvol=arch,compress=zlib,nospace_cache,rw,noatime,clear_cache
 0 0

# /dev/mapper/luks-pool
UUID=c56031b3-af27-41f6-8103-ede1f0743ac0       /var            btrfs
         subvol=arch-var,compress=lzo,nospace_cache,commit=180,rw,noatime,clear_cache
   0 0

# /dev/mapper/luks-pool
UUID=c56031b3-af27-41f6-8103-ede1f0743ac0       /home           btrfs
         subvol=home,compress=zlib,nospace_cache,rw,noatime,clear_cache
 0 0


Thanks!
