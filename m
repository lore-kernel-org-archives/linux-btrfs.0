From: Sage Weil <sage@newdream.net>
Subject: [PATCH] Btrfs: fix arithmetic error in clone ioctl
Date: Tue, 25 Aug 2009 13:19:53 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0908251318450.1229@cobra.newdream.net>
References: <bcf98daa0908232200r854444dwde3cfcf6b2181c6b@mail.gmail.com>
 <bcf98daa0908232217m85e5479je26f9d37df39f6f7@mail.gmail.com>
 <20090824115232.GC15449@think> <4A928CEF.2060903@dpf.gov.br>
 <bcf98daa0908240652p22b786a9m9c9b3d563b0903f6@mail.gmail.com>
 <bcf98daa0908240722y6a6e767ahfab958d8e973370c@mail.gmail.com>
 <bcf98daa0908240942l1f2ad95v609321409434801c@mail.gmail.com>
 <Pine.LNX.4.64.0908240956500.2289@cobra.newdream.net>
 <bcf98daa0908250104j199d6e7ey705cc3b9913a5bbd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Atila <atila.alr@dpf.gov.br>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>
To: Markus Suvanto <markus.suvanto@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <bcf98daa0908250104j199d6e7ey705cc3b9913a5bbd@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Markus,

This should fix your problem!

sage

---
Subject: [PATCH] Btrfs: fix arithmetic error in clone ioctl

Fix an arithmetic error that was breaking extents cloned via the clone
ioctl starting in the second half of a file.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/ioctl.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e8e4ebe..63ca12a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1072,8 +1072,7 @@ static long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 					datao += off - key.offset;
 					datal -= off - key.offset;
 				}
-				if (key.offset + datao + datal + key.offset >
-				    off + len)
+				if (key.offset + datao + datal > off + len)
 					datal = off + len - key.offset - datao;
 				/* disko == 0 means it's a hole */
 				if (!disko)
-- 
1.5.6.5

