From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: [Patch] btrfs-image.c: fix return values
Date: Mon, 19 Jan 2009 19:27:39 +0800
Message-ID: <20090119112739.GB4867@hack.private>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


- Exit with non-zero when fail;
- Don't exit in non-main functions, return.

Signed-off-by: WANG Cong <wangcong@zeuux.org>

---
diff --git a/btrfs-image.c b/btrfs-image.c
index 9925bdb..62b3dd8 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -741,7 +741,7 @@ static int restore_metadump(const char *input, FILE *out, int num_threads)
 		in = fopen(input, "r");
 		if (!in) {
 			perror("unable to open metadump image");
-			exit(1);
+			return 1;
 		}
 	}
 
@@ -760,7 +760,7 @@ static int restore_metadump(const char *input, FILE *out, int num_threads)
 		if (le64_to_cpu(header->magic) != HEADER_MAGIC ||
 		    le64_to_cpu(header->bytenr) != bytenr) {
 			fprintf(stderr, "bad header in metadump image\n");
-			exit(1);
+			return 1;
 		}
 		ret = add_cluster(cluster, &mdrestore, &bytenr);
 		BUG_ON(ret);
@@ -850,5 +850,5 @@ int main(int argc, char *argv[])
 	else
 		fclose(out);
 
-	exit(0);
+	exit(ret);
 }


