From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 0/8] btrfs: Error handling fixes
Date: Thu, 18 Aug 2011 14:56:53 -0700
Message-ID: <1313704621-15219-1-git-send-email-mfasheh@suse.de>
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

The following are assorted fixes to error handling from all parts of the
Btrfs code.  Every patch in this series stands on it's own, with the
exception of the last patch which relies on the one before it (so patches 7
and 8 can be considered a pair).  I also included in this series an
uncommited patch from Tsutomu Itoh which was a better version of a patch I
had written. He should be cc'd on that mail.

For the most part, I'm still concentrating on eliminating sites where we
BUG_ON(ret) instead of bubbling errors up the stack. The patches were
tested using some simple file system commands and a background kernel build.

A git branch with these patches is available:

git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/btrfs-error-handling.git for_mason


Thanks,
	--Mark
