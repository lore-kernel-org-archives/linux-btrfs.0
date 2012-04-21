From: Jim Meyering <jim@meyering.net>
Subject: [PATCHv3 4/4] mkfs: avoid heap-buffer-read-underrun for zero-length "size" arg
Date: Sat, 21 Apr 2012 09:50:17 +0200
Message-ID: <1334994617-30016-5-git-send-email-jim@meyering.net>
References: <1334994617-30016-1-git-send-email-jim@meyering.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1334994617-30016-1-git-send-email-jim@meyering.net>
List-ID: <linux-btrfs.vger.kernel.org>

From: Jim Meyering <meyering@redhat.com>

* mkfs.c (parse_size): ./mkfs.btrfs -A '' would read and possibly
write the byte before beginning of strdup'd heap buffer.  All other
size-accepting options were similarly affected.

Reviewed-by: Josef Bacik <josef@redhat.com>
---
 mkfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs.c b/mkfs.c
index 03239fb..4aff2fd 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -63,7 +63,7 @@ static u64 parse_size(char *s)

 	s = strdup(s);

-	if (!isdigit(s[len - 1])) {
+	if (len && !isdigit(s[len - 1])) {
 		c = tolower(s[len - 1]);
 		switch (c) {
 		case 'g':
-- 
1.7.10.228.g81f95

