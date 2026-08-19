Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93D03BBFB3;
	Wed, 19 Aug 2026 02:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787108120; cv=none; b=WfftjpY8lLf80LRyIIEp2cbCeoAcafmlM1iXkNSzDwfWSb0RAj5ETwsTvWsIknVFa8/dZO0rJr3CDk1mb/bH8TH/M/TiCWDpFS7W+FQAs1GRXPFPntFb8lkzbr2+im3/uLib9/nQ7qwWcMflaHpUM0ehR9J10IWyBWjkWm2Jc4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787108120; c=relaxed/simple;
	bh=DpLNz7R/4cZsC3fPJSScKd1Nqw7c+AD6NfRxiVN78kM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LtTVQSQOpY1sHqszKApk3mbiQTx55kqelXk1gMeOsVaf/R0Qg7RzbFwqtTETWBeYkCSktdGix1lF/vOpCSzKspQJWZ1l7xumO4naZZhMVKKEDtPUBTZ4g92ymejhRpAl2yCY1qYlyUrYYJwab2qkwdYNYfpQ2iee++Uu2YM5iwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=LNP1Mhub; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="LNP1Mhub"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Bl
	JH6p1shfWaFTrmaOCNyNcZsFDczLY8Q3hepbTnRlU=; b=LNP1MhubGExr7U6Ng1
	dpQYqPwl9BUEAjPtdv3u0EDGTEesI68Gco3PiV/0XIxr6pE+ksHUhBmScHcDa9wt
	+rRb64u6E+UEWyL3Je567aq6Plp/W2btZwV9BYfGxQhn5Yj5bFaG7GbzT6wmaCYO
	8nlfTsx3QRbC0c7d78WOnDzTM=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgAnxADwGoVqdX4FMA--.6093S7;
	Wed, 19 Aug 2026 10:55:00 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: clm@fb.com,
	dsterba@suse.com
Cc: quwenruo.btrfs@gmx.com,
	linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v3 5/5] btrfs: drop unused uring encoded IO REISSUE stash helpers
Date: Wed, 19 Aug 2026 10:54:36 +0800
Message-Id: <20260819025436.1949152-6-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260819025436.1949152-1-yangxiuwei@kylinos.cn>
References: <20260819025436.1949152-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgAnxADwGoVqdX4FMA--.6093S7
X-Coremail-Antispam: 1Uf129KBjvJXoW7Zw4rKF47uFyDXw1rCrW5trb_yoW8ur4xpr
	yYkFn8tFW5Jrn7GFZ5Ca95CayFqws5tw4UArZ3uF4fJ34UArnaqFyS93WrCF92yFZ0yF1j
	vF4Iqa45Cw1qyaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j4LvZUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6QTDVGqFGwTIcAAA3y

After not keeping state across -EAGAIN, restoring bc->data on REISSUE is
dead.  Remove it, stop using the cmd PDU on the write path, and fold the
read -EAGAIN check into the existing error path.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 fs/btrfs/ioctl.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a3ca15901cde..2ac2d51d564d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4700,9 +4700,6 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 	struct io_btrfs_cmd *bc = io_uring_cmd_to_pdu(cmd, struct io_btrfs_cmd);
 	struct btrfs_uring_encoded_data *data = NULL;
 
-	if (cmd->flags & IORING_URING_CMD_REISSUE)
-		data = bc->data;
-
 	if (!capable(CAP_SYS_ADMIN)) {
 		ret = -EPERM;
 		goto out_acct;
@@ -4784,8 +4781,6 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 
 	ret = btrfs_encoded_read(&kiocb, &data->iter, &data->args, &cached_state,
 				 &disk_bytenr, &disk_io_size);
-	if (ret == -EAGAIN)
-		goto out_free;
 	if (ret < 0 && ret != -EIOCBQUEUED)
 		goto out_free;
 
@@ -4842,12 +4837,8 @@ static int btrfs_uring_encoded_write(struct io_uring_cmd *cmd, unsigned int issu
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
@@ -4871,8 +4862,6 @@ static int btrfs_uring_encoded_write(struct io_uring_cmd *cmd, unsigned int issu
 			goto out_acct;
 		}
 
-		bc->data = data;
-
 		if (issue_flags & IO_URING_F_COMPAT) {
 #if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
 			struct btrfs_ioctl_encoded_io_args_32 args32;
@@ -4958,7 +4947,6 @@ static int btrfs_uring_encoded_write(struct io_uring_cmd *cmd, unsigned int issu
 	inc_syscw(current);
 
 	kfree(data);
-	bc->data = NULL;
 	return ret;
 }
 
-- 
2.25.1

