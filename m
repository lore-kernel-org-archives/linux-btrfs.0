From: "Yan Zheng" <zheng.yan@oracle.com>
Subject: Re: [PATCH] Fix csum error for compressed data
Date: Tue, 11 Nov 2008 16:57:15 +0800
Message-ID: <3d0408630811110057lec87365w1095f570d4bd55e5@mail.gmail.com>
References: <4917FFB0.2000100@oracle.com>
	 <200811102200.44107.mbuerger@edu.uni-klu.ac.at>
	 <1226351365.10966.2.camel@think.oraclecorp.com>
	 <200811110708.36712.mbuerger@edu.uni-klu.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "=?ISO-8859-1?Q?Martin_B=FCrger?=" <mbuerger@edu.uni-klu.ac.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200811110708.36712.mbuerger@edu.uni-klu.ac.at>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Martin,

Please try following patch. Thank you,

---
diff -urp 2/fs/btrfs/file.c 5/fs/btrfs/file.c
--- 2/fs/btrfs/file.c	2008-11-11 10:43:08.000000000 +0800
+++ 5/fs/btrfs/file.c	2008-11-11 16:52:11.000000000 +0800
@@ -436,7 +436,7 @@ next_slot:
 			goto out;
 		}
 		if (recow) {
-			search_start = key.offset;
+			search_start = max(key.offset, start);
 			continue;
 		}
 		if (btrfs_key_type(&key) == BTRFS_EXTENT_DATA_KEY) {
