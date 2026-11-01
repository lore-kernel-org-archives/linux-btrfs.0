Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793558394;
	b=fESnG8icgx2xnwPce1Y/Ib7vTl48cyUdvwppBr+lvcpoyBSOMtp5WzS6rp0KBtiXWCIb
	 pJ5Jrjw2UcQ2imaAeMkzMMUN9XSL6ne2ISYhoQDhYOFFBv1cfUOutWXNXLnLwejbtNk2j
	 iRKN0lzQU77ASkFTd2mZd373GVgi6pvw/pD+VG7HuioVDCTSISchbnZxfvN1NdwQ4DsLK
	 PsUOZTXqKlfCP8mJI0EeJEpoVOY+o+aVnBDGL47+fbAjIEapGr39a0AY6BIuwV5fWiXDD
	 t7IxDpaf1FTGFDPji2O9NrbOHqD2YHmpPBjifiSPEAmJzABGiKTCdbCbjIPeIfpDUHw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793558394;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=K8p0/by7agCfj7cfrjXSzQBtR85LBTs3B+zqPUaeaN4=;
	b=1eLiaDQxiGKHDfEpOj/zFPVlM5/gyd83t1CX2+c2qnz/6FU5m56xW7DJCKBAQeivvPVD
	 rESqbK5xcO/oXIZigRetFjF/eygu9ucrxK7EBopeiDHbzH7sguJ8EbRoxFbrQZBMCtNjZ
	 xp0NjToodyWkqCBFru6oNPOijRfk4JOUPbX3b7IktB7BZ24WXCG+xjPiWSmRg4XayA5Yj
	 jpIbiKvQxYmguN3N1zOGxTNmxdrz9P5RmXNSwDT3qjaqZPIjAFqe4IVaAm3j5MQss2HMV
	 pijlcLAhp+Np/T33k8z2AG8fpfgnhyJ+am3/a4WcECIZCJVXOOaS6cb6btm2Mlgf/1w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OZ99QUOe;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D5B606A324;
	Sun,  1 Nov 2026 18:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OZ99QUOe
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793558393;
	b=p3rsiFaq997RU8zq6h0mnR5tr7kKz9axw4YOpZgMqU8YQWwcQP15rvWh5Ql4W8/DZvp0
	 4AEWs7tKHnomNzwl+/zs3t5kp3aUazWUiCiXxnyu6iMmJE9MdG9uFsAIezEDEdpSF07mW
	 B1FA+/G/W/qZGawcpCQKYh/82u5JCYBW3fbXmDWjqwN/GTXjnOB4nCC3Ib6FyQ85voRWI
	 TqSWlZ3OctdwGJG0Baz0VsE3ZD6yNkCh1lMe0b3e1SSK6+ZEQUaYwOxCnVKB5rxQbH/Wm
	 IjBg6xq9GOMgMznED7cq2Q1cgM0oCVRaof/MrT2UbrnF1f4nzsBXG6pLCaJ2o6t9+6A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793558393;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=K8p0/by7agCfj7cfrjXSzQBtR85LBTs3B+zqPUaeaN4=;
	b=yfCXEi525eQiAig+Li288e0X9qL4wlvlfwCmO0sTdFR4pqhebxfq1SORxtcQ6aOhRSOJ
	 u4wOCU+wQ6a9F/OzCEgwcS2ZcalBW214GCTOE0ZXzDlLtopUXHpGb0/4j0cN2rAfAjk7a
	 Jh455YEmFyNxg9wBlmKEnrAhf78C29gyKZsjUFIGkgZlsJdGrzDf9oisI792dV4y2gTrk
	 U217LjYT1SglvqE7gW+j7e8uR007UbCpXKQhmSEZaq0S6r99dUd4R4JcZlAJV4CM7GAVn
	 0S0NlzSQJGH3BTcRmV7njp93ZhcWGxDcJNYG8FqMDdUauGQt14Daf+t62ByFJ/OK+HQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 369451F000C1;
	Sun,  1 Nov 2026 18:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793558393;
	bh=K8p0/by7agCfj7cfrjXSzQBtR85LBTs3B+zqPUaeaN4=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=OZ99QUOeUvolgMglKWLyMkeX1Uza6gSgu+VRTrnIH4tpfkwKeJZyA5ZTxv/DaY0SG
	 xumiDWc8gn130x0gcK/AjOll+BLGZSWSKkHj6U221RE2oeOSw99sJpfXDvg7ZISYNk
	 a+RO4G6ybOuEJz6EGOoDiDiDLH8mLDpWI6FIJ7qmkLgQ2t4zJwhyhu+vb8TUY5d9Yu
	 CSh4ThVB8fYQY1Fsb1wBj7Oh3sVrjLOAKezC1vJWEPAU0S9bGuycBWy36bcBwZhWq+
	 fvAZpRcdytNlESvgl2fYRoTst1NNekgLjuGQXfMQAlEPjm90BABED1e8tDaw9XXTP0
	 wXrJVcu+K0KwA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A2FFB46228;
	Sun,  1 Nov 2026 18:39:52 +0000 (UTC)
From: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Date: Sun, 01 Nov 2026 13:39:52 -0500
Subject: [PATCH] btrfs: fix bio counter and bioc leak when async
 checksumming fails
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261101-btrfs-async-csum-leak-v1-1-feafe7ae61e9@columbia.edu>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQ6CMBBA0auQWTtJW6IkXoWwKMNUB6SaDhAI4
 e5WXL7F/zsoJ2GFe7FD4kVU3jHDXgqgp48PRumywRl3s6Y02E4pKHrdIiHpPOKL/YC2qlwXrsF
 Q6SC3n8RB1vNbN3/r3PZM028Gx/EFeGIUMnkAAAA=
X-Change-ID: 20261030-btrfs-async-csum-leak-1772df5f0c32
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>
Cc: Qu Wenruo <wqu@suse.com>, Christoph Hellwig <hch@lst.de>, 
 Josef Bacik <josef@toxicpanda.com>, 
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, 
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 tz2294@columbia.edu, stable@vger.kernel.org, 
 Mani Tofigh <mt4022@columbia.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793558392; l=2369;
 i=mt4022@columbia.edu; s=20261026; h=from:subject:message-id;
 bh=mGiLrTH5AqlN5JS+ipDmST7KGFMjGScKRUdjepxjagw=;
 b=i817B+Hk0R44YFLbkmJkWr40ppVxvcWEv5xLvPF4pmkmoUO7WZFnyFJg6PlLMqTOdsEBNgl+w
 BTgE7frgH3tA9Dg6T79LE7JgyO6ikbL2mpIpYqeONCt8vUgikFsn3XI
X-Developer-Key: i=mt4022@columbia.edu; a=ed25519;
 pk=gljCMQDuxyKPmd5y37CRpEJGSPXDV1MyAnHBhCgXl0I=
X-Endpoint-Received: by B4 Relay for mt4022@columbia.edu/20261026 with
 auth_id=1322
X-Original-From: Mani Tofigh <mt4022@columbia.edu>
Reply-To: mt4022@columbia.edu
Content-Transfer-Encoding: 7bit

From: Mani Tofigh <mt4022@columbia.edu>

A single failed checksum allocation can make a later device replace
hang forever.  btrfs_submit_chunk() takes a dev-replace bio counter
reference and a bioc before it hands a write to the checksum worker.
If the checksum fails there (eg its allocation fails),
run_one_async_done() ends the bio but drops neither.  The counter then
never gets back to zero and the next replace waits for it:

  [    8.369171] BTRFS info (device ram0): dev_replace from /dev/ram0 (devid 1) to /dev/ram1 finished
  [   41.534247] INFO: task btrfscsum:80 blocked for more than 20 seconds.
  [   41.534391]  btrfs_rm_dev_replace_blocked+0x135/0x180
  [   41.534463]  btrfs_dev_replace_finishing+0xefe/0x13b0

Put the bioc and drop the counter in that error branch as the
synchronous error path does.  Also put the bioc on the synchronous
path, which only drops the counter.  With the fix, the replace
finishes.

This bug was identified and confirmed with the help of fault-injection
testing on a deterministic hypervisor currently under development.  The
C reproducer below however hits it within about 35s.

Fixes: f8a53bb58ec7 ("btrfs: handle checksum generation in the storage layer")
Cc: stable@vger.kernel.org # 6.6+
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
---
Reproducer: https://github.com/manitofigh/files/blob/main/linux-repros/btrfscsum.c
---
 fs/btrfs/bio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 2c6234f6182f..a508f4abd3a3 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -624,6 +624,8 @@ static void run_one_async_done(struct btrfs_work *work, bool do_free)
 
 	/* If an error occurred we just want to clean up the bio and move on. */
 	if (bio->bi_status) {
+		btrfs_put_bioc(async->bioc);
+		btrfs_bio_counter_dec(async->bbio->inode->root->fs_info);
 		btrfs_bio_end_io(async->bbio, bio->bi_status);
 		return;
 	}
@@ -822,6 +824,7 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 	return map_length == length;
 
 fail:
+	btrfs_put_bioc(bioc);
 	btrfs_bio_counter_dec(fs_info);
 	/*
 	 * We have split the original bbio, now we have to end both the current

---
base-commit: 5e6c45aaaf93343c7f8a1cde9797080238af5c1b
change-id: 20261030-btrfs-async-csum-leak-1772df5f0c32

Best regards,
--  
Mani Tofigh <mt4022@columbia.edu>


