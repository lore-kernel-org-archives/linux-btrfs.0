From: Sage Weil <sage@newdream.net>
Subject: [PATCH 0/3] clone ioctl fixes
Date: Tue, 19 Oct 2010 15:22:09 -0700
Message-ID: <1287526932-28369-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

These are a few critical bug fixes for the clone ioctl.  We've been 
hitting these on a number of different systems, so getting these into 
2.6.37 would be much appreciated.

Thanks!
sage

--

Sage Weil (1):
  Btrfs: fix lockdep warning on clone ioctl

Yehuda Sadeh (2):
  Btrfs: fix delalloc checks in clone ioctl
  Btrfs: fix clone ioctl where range is adjacent to extent

 fs/btrfs/ioctl.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

