From: "yanhai zhu" <zhu.yanhai@gmail.com>
Subject: Re: [PATCH] Btrfs image tool
Date: Sat, 22 Nov 2008 21:06:51 +0800
Message-ID: <977a2be20811220506i1bd3ddc6q707c58e7649359b1@mail.gmail.com>
References: <49242951.2060302@oracle.com>
	 <a4423d670811201410y639b38ffmeef02adbf666a970@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Yan Zheng" <zheng.yan@oracle.com>, linux-btrfs@vger.kernel.org,
	"Chris Mason" <chris.mason@oracle.com>
To: "Alexander Beregalov" <a.beregalov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a4423d670811201410y639b38ffmeef02adbf666a970@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

diff --git a/btrfs-image.c b/btrfs-image.c
index 7499a5e..9925bdb 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -216,8 +216,9 @@ static void *dump_worker(void *data)
 			async->bufsize = compressBound(async->size);
 			async->buffer = malloc(async->bufsize);

-			ret = compress2(async->buffer, &async->bufsize, orig,
-					async->size, md->compress_level);
+			ret = compress2(async->buffer,
+					 (unsigned long *)&async->bufsize,
+					 orig, async->size, md->compress_level);
 			BUG_ON(ret != Z_OK);

 			free(orig);
@@ -595,8 +596,8 @@ static void *restore_worker(void *data)

 		if (mdres->compress_method == COMPRESS_ZLIB) {
 			size = MAX_PENDING_SIZE * 2;
-			ret = uncompress(buffer, &size, async->buffer,
-					 async->bufsize);
+			ret = uncompress(buffer, (unsigned long *)&size,
+					 async->buffer, async->bufsize);
 			BUG_ON(ret != Z_OK);
 			outbuf = buffer;
 		} else {

2008/11/21 Alexander Beregalov <a.beregalov@gmail.com>:
> 2008/11/19 Yan Zheng <zheng.yan@oracle.com>:
>> Hello,
>>
>> This patch adds btrfs image tool. The image tool is
>> a debugging tool that creates/restores btrfs metadump
>> image. Thank you,
>>
>> Signed-off-by: Yan Zheng <zheng.yan@oracle.com>
>
> gcc -Wp,-MMD,./.btrfs-image.o.d,-MT,btrfs-image.o -Wall
> -fno-strict-aliasing -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -g
> -Werror -Os -c btrfs-image.c
> cc1: warnings being treated as errors
> btrfs-image.c: In function 'dump_worker':
> btrfs-image.c:220: error: passing argument 2 of 'compress2' from
> incompatible pointer type
> btrfs-image.c: In function 'restore_worker':
> btrfs-image.c:599: error: passing argument 2 of 'uncompress' from
> incompatible pointer type
> make: *** [btrfs-image.o] Error 1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Zhu Yanhai
