From: "Miguel Sousa Filipe" <miguel.filipe@gmail.com>
Subject: [PATCH] bio_endio support for linux 2.6.23 and older.
Date: Sat, 5 Apr 2008 20:45:39 +0100
Message-ID: <f058a9c30804051245i2eda2377p70a63f5e1725af@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: btrfs-devel@oss.oracle.com, linux-btrfs@vger.kernel.org
Return-path: <btrfs-devel-bounces@oss.oracle.com>
List-Unsubscribe: <http://oss.oracle.com/mailman/listinfo/btrfs-devel>,
	<mailto:btrfs-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/btrfs-devel>
List-Post: <mailto:btrfs-devel@oss.oracle.com>
List-Help: <mailto:btrfs-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <http://oss.oracle.com/mailman/listinfo/btrfs-devel>,
	<mailto:btrfs-devel-request@oss.oracle.com?subject=subscribe>
Errors-To: btrfs-devel-bounces@oss.oracle.com
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

bio_endio() changed prototype on linux 2.6.24, support older kernels
using the older prototype.


diff -r 4b838034355c volumes.c
--- a/volumes.c Sat Apr 05 19:06:30 2008 +0100
+++ b/volumes.c Sat Apr 05 20:41:15 2008 +0100
@@ -912,7 +912,11 @@ static int end_bio_multi_stripe(struct b
                        err = multi->error;
                kfree(multi);

+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,23)
+               bio_endio(bio, bio->bi_size, err);
+#else
                bio_endio(bio, err);
+#endif
        } else {
                bio_put(bio);
        }

Kind regards,

-- 
Miguel Sousa Filipe
