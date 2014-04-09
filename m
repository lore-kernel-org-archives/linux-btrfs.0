Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:59446 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933114AbaDIRkg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Apr 2014 13:40:36 -0400
Received: by mail-wg0-f46.google.com with SMTP id b13so2841721wgh.5
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Apr 2014 10:40:35 -0700 (PDT)
Received: from [192.168.43.116] (public-gprs514566.centertel.pl. [31.61.129.71])
        by mx.google.com with ESMTPSA id t6sm11408303wix.4.2014.04.09.10.40.33
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 09 Apr 2014 10:40:34 -0700 (PDT)
Message-ID: <5345A224.2050801@qdot.me>
Date: Wed, 09 Apr 2014 21:40:20 +0200
From: Tomasz Mloduchowski <q@qdot.me>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfsck - process_inode_item: Assertion `!(rec->ino != key->objectid
 || rec->refs > 1)' failed
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm experiencing the following error when performing btrfsck --repair on
the damaged filesystem (some files indicate 'stale NFS handle' errors
when accessing).

checking extents
parent transid verify failed on 199000064 wanted 1868 found 1586
parent transid verify failed on 199000064 wanted 1868 found 1586
parent transid verify failed on 199000064 wanted 1868 found 1586
parent transid verify failed on 199000064 wanted 1868 found 1586
Ignoring transid failure
leaf parent key incorrect 199000064
bad block 199000064
Chunk[256, 228, 1103101952]: length(1073741824), offset(1103101952),
type(1) is not found in block group

-- snip --

Chunk[256, 228, 111121793024]: length(1023410176), offset(111121793024),
type(1) is not found in block group
Errors found in extent allocation tree or chunk allocation
checking free space cache
checking fs roots
parent transid verify failed on 199000064 wanted 1868 found 1586
Ignoring transid failure

-- snip --

parent transid verify failed on 199000064 wanted 1868 found 1586
Ignoring transid failure
btrfsck: cmds-check.c:512: process_inode_item: Assertion `!(rec->ino !=
key->objectid || rec->refs > 1)' failed.


The image (btrfs-image  -s -c 9 -t 4) of this filesystem is available here:

http://static.qdot.me/home-btrfs-fail-2.img

btrfs-progs:
commit 761650b628d3b8964cc55da68ad5c8187f55c543

Thanks a lot for pointers or assistance (or patches to try out).

Cheers,
Tomasz
