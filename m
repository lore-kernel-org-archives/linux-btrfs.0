From: Bill Nottingham <notting@redhat.com>
Subject: Re: [PATCH] Documentation/Changes: add required versions for new
	filesystems
Date: Wed, 28 Jan 2009 11:01:57 -0500
Message-ID: <20090128160157.GA5598@nostromo.devel.redhat.com>
References: <1233158441-5475-1-git-send-email-notting@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-kernel@vger.kernel.org, phillip@lougher.demon.co.uk,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1233158441-5475-1-git-send-email-notting@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Bill Nottingham (notting@redhat.com) said: 
> btrfs requires version 0.18 of its tools, and squashfs requires
> 4.0.

This time, with a typo fix.

...

btrfs requires version 0.18 of its tools, and squashfs requires
4.0.

Signed-off-by: Bill Nottingham <notting@redhat.com>
---
 Documentation/Changes |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/Changes b/Documentation/Changes
index cb2b141..011cc43 100644
--- a/Documentation/Changes
+++ b/Documentation/Changes
@@ -37,6 +37,8 @@ o  e2fsprogs              1.29                    # tune2fs
 o  jfsutils               1.1.3                   # fsck.jfs -V
 o  reiserfsprogs          3.6.3                   # reiserfsck -V 2>&1|grep reiserfsprogs
 o  xfsprogs               2.6.0                   # xfs_db -V
+o  squashfs-tools         4.0                     # mksquashfs -version
+o  btrfs-progs            0.18                    # btrfsck
 o  pcmciautils            004                     # pccardctl -V
 o  quota-tools            3.09                    # quota -V
 o  PPP                    2.4.0                   # pppd --version
-- 
1.6.1.1

