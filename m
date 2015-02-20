Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:50323 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbbBTIvL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Feb 2015 03:51:11 -0500
MIME-Version: 1.0
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Fri, 20 Feb 2015 09:50:50 +0100
Message-ID: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com>
Subject: Documenting MS_LAZYTIME
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
        XFS Developers <xfs@oss.sgi.com>, linux-man@vger.kernel.org,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Ted,

Based on your commit message 0ae45f63d4e, I I wrote the documentation
below for MS_LAZYTIME, to go into the mount(2) man page. Could you
please check it over and let me know if it's accurate. In particular,
I added pieces marked with "*" below that were not part of the commit
message and I'd like confirmation that they're accurate.

Thanks,

Michael

[[
       MS_LAZYTIME (since Linux 3.20)
              Only  update  filetimes (atime, mtime, ctime) on the in-
              memory version of the file  inode.   The  on-disk  time‐
              stamps are updated only when:

              (a)  the inode needs to be updated for some change unre‐
                   lated to file timestamps;

              (b)  the application  employs  fsync(2),  syncfs(2),  or
                   sync(2);

              (c)  an undeleted inode is evicted from memory; or

*             (d)  more than 24 hours have passed since the i-node was
*                  written to disk.

              This mount option significantly reduces  writes  to  the
              inode  table  for workloads that perform frequent random
              writes to preallocated files.

*             As at Linux 3.20, this option is supported only on ext4.
]]

-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
