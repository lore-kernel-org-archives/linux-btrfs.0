Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD9F408617;
	Thu,  6 Aug 2026 08:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786006293; cv=none; b=WDJoL8N/pOkDogBT3JpI9QV7bi+M/dFRmRbyEaGCH+flJaatJWcQna5jHSIy1f0Qv3zUtFGjJ2JIsPSVDxLeA8LV/QtOwJDRTjNg6rFQAZsZ83sq+azeToVRhF9EnTv1NTLHcyPXv1ZtpB/RqFtHXu3xs90mecRbiCaKyYqJxo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786006293; c=relaxed/simple;
	bh=e/79A/cwUa9HGzKCrjbpE6mBwRBap/v5khoTsadY6uI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SQVrvj/6sjqvCOjm0+yCnUU08ec+NybNG+OBxFL+gxM8BM/ou2c0yiLnEoqgKychRvheufiaMwKj85kNYGPDpAs3wr87vJZhdeFKIbk6qjuqir5Ns2kh/4SluceUdxwNisSv/aFDwv7sXOT8wmq0gDfMzYniZlTq6yuapxJ/px4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=gVYTAje8; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="gVYTAje8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Zn
	XYmtN5R0nuWkD3C5jT0uJOcyku4gTWD8FpcntouqA=; b=gVYTAje8C4CpuOm4le
	Pg+//FNFq9GZzs2Umy7y7hacY7rQi7b6sLjAuNJ6AEgNYJ7IKolTz8jjsQFiCfHe
	3A8la6dCyTd5VFmNv3EfOu+klDfj0nSkzTpnVWxXv6kaNUa+xO/4GFwLppEmbg6o
	z4IZ2B03le4MEy5XzqAnFu1xo=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wDXGqvjSnRqmYLmMA--.78S9;
	Thu, 06 Aug 2026 16:50:57 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Mark Harmstone <maharmstone@fb.com>,
	Qu Wenruo <quwenruo.btrfs@gmx.com>,
	linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v2 7/7] btrfs: drop unused uring encoded IO REISSUE stash helpers
Date: Thu,  6 Aug 2026 16:50:41 +0800
Message-Id: <20260806085041.1410576-8-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260806085041.1410576-1-yangxiuwei@kylinos.cn>
References: <20260806085041.1410576-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXGqvjSnRqmYLmMA--.78S9
X-Coremail-Antispam: 1Uf129KBjvJXoW7Zw4rKF47uFyDXw1rCrW5trb_yoW8ur4xpr
	WYyFn8tFW5JrnrGFWkCws5CayFqws8tw4UArZ3uF4fJ347Arn3tFyF93WrCF92yFZ0yF1j
	vF40qFy5Zw1qyaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j5xhLUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwRGGF2p0SvF5wQAA3c

After not keeping state across -EAGAIN, restoring bc->data on REISSUE is
dead.  Remove it, stop using the cmd PDU on the write path, and fold the
read -EAGAIN check into the existing error path.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 fs/btrfs/ioctl.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 995a84ca86b7..1065416bcb1d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4704,9 +4704,6 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 	struct io_btrfs_cmd *bc = io_uring_cmd_to_pdu(cmd, struct io_btrfs_cmd);
 	struct btrfs_uring_encoded_data *data = NULL;
 
-	if (cmd->flags & IORING_URING_CMD_REISSUE)
-		data = bc->data;
-
 	if (!capable(CAP_SYS_ADMIN)) {
 		ret = -EPERM;
 		goto out_acct;
@@ -4789,8 +4786,6 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 
 	ret = btrfs_encoded_read(&kiocb, &data->iter, &data->args, &cached_state,
 				 &disk_bytenr, &disk_io_size);
-	if (ret == -EAGAIN)
-		goto out_free;
 	if (ret < 0 && ret != -EIOCBQUEUED)
 		goto out_free;
 
@@ -4847,12 +4842,8 @@ static int btrfs_uring_encoded_write(struct io_uring_cmd *cmd, unsigned int issu
 	struct kiocb kiocb;
 	ssize_t ret;
 	void __user *sqe_addr;
-	struct io_btrfs_cmd *bc = io_uring_cmd_to_pdu(cmd, struct io_btrfs_cmd);
 	struct btrfs_uring_encoded_data *data = NULL;
 
-	if (cmd->flags & IORING_URING_CMD_REISSUE)
-		data = bc->data;
-
 	if (!capable(CAP_SYS_ADMIN)) {
 		ret = -EPERM;
 		goto out_acct;
@@ -4876,8 +4867,6 @@ static int btrfs_uring_encoded_write(struct io_uring_cmd *cmd, unsigned int issu
 			goto out_acct;
 		}
 
-		bc->data = data;
-
 		if (issue_flags & IO_URING_F_COMPAT) {
 #if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
 			struct btrfs_ioctl_encoded_io_args_32 args32;
@@ -4964,7 +4953,6 @@ static int btrfs_uring_encoded_write(struct io_uring_cmd *cmd, unsigned int issu
 	inc_syscw(current);
 
 	kfree(data);
-	bc->data = NULL;
 	return ret;
 }
 
-- 
2.25.1

