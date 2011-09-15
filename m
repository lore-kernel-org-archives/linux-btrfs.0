From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 0/20] btrfs: More error handling fixes
Date: Thu, 15 Sep 2011 10:34:39 -0700
Message-ID: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>, Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

The following are assorted fixes to error handling from all parts of the
Btrfs code.  I included in this series an uncommited patch from Tsutomu Itoh
which was a better version of a patch I had written.  He should be cc'd on
that mail.

Some of the patches (the first 8) were previously sent to this list but got
no comments so I'm resending them with this set. Changes from last time are
that I also started setting the file system readonly on errors which look
like possible corruption.

For the most part, I'm still concentrating on eliminating sites where we
BUG_ON(ret) instead of bubbling errors up the stack. The patches were
tested using some simple file system commands and a background kernel build.

Please review, all constructive feedback is appreciated :)

Thanks,
	--Mark

--
Mark Fasheh
