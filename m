Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:33741 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbbCYXpb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Mar 2015 19:45:31 -0400
Received: by labto5 with SMTP id to5so32910366lab.0
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2015 16:45:30 -0700 (PDT)
MIME-Version: 1.0
From: Anand Patil <anand.prabhakar.patil@gmail.com>
Date: Wed, 25 Mar 2015 16:45:09 -0700
Message-ID: <CAFzWkZGytSfhvx8zts=pwBseua-Hdpp+ZXmDPNLrpwJqhiaU_A@mail.gmail.com>
Subject: Metadata about to fill up, how to make it bigger next time?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I have a BTRFS filesystem on a 1TB block device, kernel 3.16.2+, tools
v3.14_pre20140414. There are many (several thousand) subvolumes,
folders and small files.

When I run btrfs fi df /path/to/fs, I see:

Data, single: total=53.01GiB, used=51.79GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=16.00GiB, used=14.72GiB

I have already done "btrfs balance start -dusage 50" and "btrfs
balance start -musage 50".


My most pressing question is, does that metadata line really mean that
the filesystem is going to become unusable soon?

If so, do I really need to migrate the data to a new filesystem with a
much bigger metadata allowance, or is there an easier way? For
example, can I migrate the metadata and leave the data in place?

Assuming I need to do some kind of migration, my next question is how
do I size the metadata on the new filesystem? The btrfs faq says

"No, the value passed to mkfs.btrfs -n SIZE cannot be changed once the
filesystem is created. A backup/restore is needed.
Note, that this will likely never be implemented because it would
require major updates to the core functionality. "

man mkfs.btrfs says of the '-n' option:

       -n, --nodesize size
              -l,  --leafsize  size  Specify  the  nodesize,  the tree
block size in which btrfs
              stores data. The default value is the page size. Must be
a multiple of the sector‐
              size,  but  not larger than 65536. Leafsize always
equals nodesize and the options
              are aliases.

The relationship between that and the 'Metadata' line in btrfs fi df
is not clear to me.

Thanks in advance for any help,
Anand
