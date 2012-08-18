Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:44667 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab2HREC2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Aug 2012 00:02:28 -0400
Received: by weyx8 with SMTP id x8so2840818wey.19
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Aug 2012 21:02:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANDob0+VQ0UJJaDS89CGK5YNXys40SWgWMgeTjeZoca4teVEUw@mail.gmail.com>
References: <CANDob0+VQ0UJJaDS89CGK5YNXys40SWgWMgeTjeZoca4teVEUw@mail.gmail.com>
From: Not Zippy <notzippy@gmail.com>
Date: Fri, 17 Aug 2012 21:02:07 -0700
Message-ID: <CANDob0+XEHbYmp2PF-UW1EXRP6YbKw3Fn00th8u9A2R7XdCrJg@mail.gmail.com>
Subject: Re: Computer crash, btrfs partition errors
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

My sabayon box locked up while doing a repo sync, now I am getting the
following errors on one directory on my btrfs partition
rm: cannot remove
‘system.2/.repo/projects/packages/wallpapers/HoloSpiral.git/refs’:
Directory not empty
rm: cannot remove
‘system.2/.repo/projects/packages/wallpapers/HoloSpiral.git/hooks’:
Stale NFS file handle
rm: cannot remove
‘system.2/.repo/projects/packages/wallpapers/HoloSpiral.git/HEAD’:
Stale NFS file handle

Doing a btrfsck fails with the following error
# btrfsck /dev/sda2
checking extents
leaf parent key incorrect 46329503744
bad block 46329503744
owner ref check failed [46329503744 4096]
Errors found in extent allocation tree
checking fs roots
btrfsck: btrfsck.c:394: process_inode_item: Assertion `!(rec->ino !=
key->objectid || rec->refs > 1)' failed.
Aborted

Kernel
Linux homeu1 3.5.0-sabayon
btrfs
Btrfs Btrfs v0.19-dirty

Can this be repaired ? The drive is still mountable and I have moved
all other files to another drive so I could wipe it but I was
wondering if repairing was an option as well..

thanks
Nz
