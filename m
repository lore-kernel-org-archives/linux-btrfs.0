From: wfp5p@viridian.itc.virginia.edu (Bill Pemberton)
Subject: assertion failures
Date: Wed, 24 Feb 2010 08:45:32 -0500 (EST)
Message-ID: <20100224134532.282174094A@viridian.itc.virginia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've had 2 different filesystems fail in the same way recently.  In
both cases the server crashed (probably due to something unrelated to
btrfs).  On reboot the fsck fails as follows:

#  btrfsck /dev/raidvg/vol4
parent transid verify failed on 20971520 wanted 206856 found 214247
parent transid verify failed on 20971520 wanted 206856 found 214247
parent transid verify failed on 20971520 wanted 206856 found 214247
btrfsck: disk-io.c:723: open_ctree_fd: Assertion `!(!chunk_root->node)' failed.
Aborted (core dumped)


I tried compiling the latest tools from git, but the error is the
same.  This is on Fedora 12 machine running kernel
2.6.31.12-174.2.22.fc12.x86_64


-- 
Bill

