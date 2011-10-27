From: Chris Mason <chris.mason@oracle.com>
Subject: Btrfs progs git repo on kernel.org
Date: Thu, 27 Oct 2011 11:27:07 -0400
Message-ID: <20111027152707.GA11028@shiny.Mikenopa.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arne Jansen <sensille@gmx.net>, Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I've pulled in Hugo's integration tree, minus the features that were not
yet in the kernel.  This also has a few small commits that I had queued
up outside of the fsck work.

Hugo, many thanks for keeping up the integration tree!  Taking out the
features not in the kernel meant I had to rebase it the commits, I'm
sorry about that.

The code from the integration tree is here:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

My next step is to push out a branch with Josef's recovery tool
integrated in.  I'm spending some time adding my metadata scanning code
with his, and trying to clean up things for a real beta fsck release.

-chris

