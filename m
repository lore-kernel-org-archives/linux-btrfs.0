From: "nick d." <blumph@gmail.com>
Subject: [PATCH] minor spelling correction in utilities
Date: Wed, 25 Mar 2009 10:34:52 +1000
Message-ID: <9e66534b0903241734w6272929ft520445001ce4247b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Minor spelling mistake when running 'btrfsck' when argument doesn't exist.

---
 disk-io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index e49c220..9e0cfe8 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -530,7 +530,7 @@ struct btrfs_root *open_ctree(const char
*filename, u64 sb_bytenr, int writes)

        fp = open(filename, flags, 0600);
        if (fp < 0) {
-               fprintf (stderr, "Coult not open %s\n", filename);
+               fprintf (stderr, "Could not open %s\n", filename);
                return NULL;
        }
        root = open_ctree_fd(fp, filename, sb_bytenr, writes);
--
1.6.2
