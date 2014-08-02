Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:38123 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750971AbaHBMYv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 Aug 2014 08:24:51 -0400
Date: Sat, 2 Aug 2014 14:24:49 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Zach Brown <zab@zabbo.net>
Cc: Josef Bacik <jbacik@fb.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>
Subject: Re: [PATCH 1/1] Btrfs: fix sparse warning
Message-Id: <20140802142449.15f4cfc2c2821e90e04e175e@skynet.be>
In-Reply-To: <20140717190152.GB24196@lenny.home.zabbo.net>
References: <1405451837-8235-1-git-send-email-fabf@skynet.be>
	<20140716172021.GA10833@lenny.home.zabbo.net>
	<1762701571.679094.1405622254558.open-xchange@webmail.nmp.skynet.be>
	<20140717190152.GB24196@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 17 Jul 2014 12:01:52 -0700
Zach Brown <zab@zabbo.net> wrote:

> > > > @@ -515,7 +515,8 @@ static int write_buf(struct file *filp, const void *buf,
> > > > u32 len, loff_t *off)
> > >
> > > Though this probably wants to be rewritten in terms of kernel_write().
> > > That'd give an opportunity to get rid of the sctx->send_off and have it
> > > use f_pos in the filp.
> > 
> > Do you mean directly call kernel_write from send_cmd/send_header ?
> > I guess that loop around vfs_write in write_buf is there for something ...
> 
> write_buf() could still exist to iterate over the buffer in the case of
> partial writes but it doesn't need to muck around with set_fs() and
> forcing casts.
> 
> - z

Hello Zach,

	Here's an untested patch which

	-removes send_off and set_fs
	-calls kernel_write with ppos 0

but I don't know if something like adding filp->f_pos = pos
at the end of write_buf would be enough to replace send_off ...

Regards,
Fabian 
	

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 6528aa6..a144b4e 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -83,7 +83,6 @@ struct clone_root {
 
 struct send_ctx {
 	struct file *send_filp;
-	loff_t send_off;
 	char *send_buf;
 	u32 send_size;
 	u32 send_max_size;
@@ -505,35 +504,28 @@ static struct btrfs_path *alloc_path_for_send(void)
 	return path;
 }
 
-static int write_buf(struct file *filp, const void *buf, u32 len, loff_t *off)
+static int write_buf(struct file *filp, const void *buf, u32 len)
 {
 	int ret;
 	mm_segment_t old_fs;
 	u32 pos = 0;
 
-	old_fs = get_fs();
-	set_fs(KERNEL_DS);
-
 	while (pos < len) {
-		ret = vfs_write(filp, (char *)buf + pos, len - pos, off);
+		ret = kernel_write(filp, (char *)buf + pos, len - pos, 0);
 		/* TODO handle that correctly */
 		/*if (ret == -ERESTARTSYS) {
 			continue;
 		}*/
 		if (ret < 0)
-			goto out;
+			return ret;
 		if (ret == 0) {
 			ret = -EIO;
-			goto out;
+			return ret;
 		}
 		pos += ret;
 	}
 
-	ret = 0;
-
-out:
-	set_fs(old_fs);
-	return ret;
+	return 0;
 }
 
 static int tlv_put(struct send_ctx *sctx, u16 attr, const void *data, int len)
@@ -639,8 +631,7 @@ static int send_header(struct send_ctx *sctx)
 	strcpy(hdr.magic, BTRFS_SEND_STREAM_MAGIC);
 	hdr.version = cpu_to_le32(BTRFS_SEND_STREAM_VERSION);
 
-	return write_buf(sctx->send_filp, &hdr, sizeof(hdr),
-					&sctx->send_off);
+	return write_buf(sctx->send_filp, &hdr, sizeof(hdr));
 }
 
 /*
@@ -675,8 +666,7 @@ static int send_cmd(struct send_ctx *sctx)
 	crc = btrfs_crc32c(0, (unsigned char *)sctx->send_buf, sctx->send_size);
 	hdr->crc = cpu_to_le32(crc);
 
-	ret = write_buf(sctx->send_filp, sctx->send_buf, sctx->send_size,
-					&sctx->send_off);
+	ret = write_buf(sctx->send_filp, sctx->send_buf);
 
 	sctx->total_send_size += sctx->send_size;
 	sctx->cmd_send_size[le16_to_cpu(hdr->cmd)] += sctx->send_size;
