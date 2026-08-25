Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A1C48EBE0;
	Tue, 25 Aug 2026 22:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787696329; cv=none; b=E2BmE2NUMJltwZg6K9+Hbivyh4lphYJHkCaOYEgwAHeViilPWT+6wgrvBPH6BViSdY8exSvw2pGVQM+a+Ys4+MZD7dMeHqRsyIAg61rWT+HqbNDoGjoWbue58nbzuTTwjGU5C72G0E4UfDBX+JQlPLfENvhdrM5YIvjZj/brmIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787696329; c=relaxed/simple;
	bh=Wn8t1NSB9z51I0m/t0qwQvRj2tghN354WUGCY5oiGvo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EhhoUOBKmpuSSwl3LCqZ5xgGSLUqEG2AjWivVDYJN+TTI5+GivFFCLlCOCTSBNU2oyNkThRYArkCCn2owA6PGAjO2oFZaz4HIYmc+IEWwlhREmtimrBXy7vYmaO2A9bxqjs0emzg0C9F65FQomUjOHKKjv4x4UsV3YbRbXREEzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=h2t1aLCz; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="h2t1aLCz"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hV2HT71Zhz1XM0vy;
	Tue, 25 Aug 2026 22:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1787696312; x=1790288313; bh=APev5dkDvNxMzoK/H1N0BGHv
	e+cWp9xVJDN07fDHlNs=; b=h2t1aLCzuR/cd3KzlIaCdpxpXP/1Grx8HhnlliYY
	k7s1TeTHcnW4b/guFk2wOHoa41YqUwdLJawNJxPoWY0mOISs5IBDEcRnfyuhfhWq
	2U7V1HN+i8V6Z3JUpC0hoiriVrtbWSyhNR+X2CXgft2lLAqtQPRGnUMKZAwonwUg
	GTKbbHthuSZw+ZSWnIG2mc6CpTuXlEhMDRxwUTHVG9ZGFju2hCnVji1co9zCuays
	F+aNMn1ZtmWIkpfFT1uWK52nM/aHm8cn3+qZa0jkX/5U5T54KYFjJr2OV1ILBMdV
	DuRypGlhL5WXU5uCkgAv8ihIStYU45IAzxvJlR8EhKnzQQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VNNE9JcnAtl9; Tue, 25 Aug 2026 22:18:32 +0000 (UTC)
Received: from [100.80.227.50] (unknown [104.135.182.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hV2H66mzsz1XM4TB;
	Tue, 25 Aug 2026 22:18:26 +0000 (UTC)
Message-ID: <845464ce-43c0-45b3-94ea-ccc830fbc76f@acm.org>
Date: Tue, 25 Aug 2026 15:18:24 -0700
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] loop: Fix NULL pointer dereference in lo_rw_aio()
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Markus Elfring <Markus.Elfring@web.de>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, lkp@intel.com,
 oe-lkp@lists.linux.dev, Christian Brauner <brauner@kernel.org>,
 Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>,
 Hillf Danton <hdanton@sina.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Mark Brown <broonie@kernel.org>, Oliver Sang <oliver.sang@intel.com>,
 linux-btrfs@vger.kernel.org
References: <8dedfc40-9cae-44ff-9960-e0eb1825e963@I-love.SAKURA.ne.jp>
 <550ff0b4-df39-46d2-9781-c8688df10c93@web.de>
 <38ad64c1-edc7-431d-8f52-fba572ebf3eb@I-love.SAKURA.ne.jp>
 <372ca5f6-81a0-4f6c-8f55-ebeeada9f955@acm.org>
 <27bcb147-bead-4432-8cd0-981489f36228@acm.org>
 <c41e9198-86a8-4bcd-a608-6f457b24f345@I-love.SAKURA.ne.jp>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c41e9198-86a8-4bcd-a608-6f457b24f345@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/26 8:13 AM, Tetsuo Handa wrote:
> As of commit fe4c990e6a30 ("loop: Add __guarded_by() annotations") in block-loop branch,
> 
>    modprobe loop
>    losetup /dev/loop0 testfile.img; losetup /dev/loop1 /dev/loop0; losetup -D
>    sleep 1
>    losetup /dev/loop1 testfile.img; losetup /dev/loop0 /dev/loop1; losetup -D
> 
> causes lockdep warning. This is a false positive, but we need to avoid it anyway.

Thanks for having shared the above reproducer. I have dropped the 
patches that protect all lo_backing_file dereferences with lo_mutex. It
is too tricky to get this right and at the same time to keep lockdep
happy.

> you also recognized that we can't call drain_workqueue() or flush_workqueue().
> 
> Therefore, I chose to temporarily drop lo->lo_disk->open_mutex in order to
> make it possible to safely perform drain_workqueue().

There is another possibility: set QUEUE_FLAG_DYING in __loop_clr_fd() 
before modifying queue limits and clear it again after modifying queue
limits has finished. Feedback on the patch below is welcome.

Thanks,

Bart.

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index df72350cad15..2fb9dc8ea47e 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1153,11 +1153,30 @@ static int loop_configure(struct loop_device 
*lo, blk_mode_t mode,

  static void __loop_clr_fd(struct loop_device *lo)
  {
+	struct request_queue *q = lo->lo_queue;
  	struct queue_limits lim;
+	unsigned int memflags;
  	struct file *filp;
  	gfp_t gfp = lo->old_gfp_mask;
  	int err;

+	/*
+	 * Prevent that new asynchronous I/O is submitted while queue limits
+	 * are being modified.
+	 */
+	blk_queue_flag_set(QUEUE_FLAG_DYING, q);
+
+	/* Wait until asynchronous I/O has finished. */
+	memflags = blk_mq_freeze_queue(q);
+	blk_mq_unfreeze_queue(q, memflags);
+
+	/* Wait until I/O dispatching has finished. */
+	blk_mq_quiesce_queue(q);
+	blk_mq_unquiesce_queue(q);
+
+	/* Wait until all I/O-related work has finished. */
+	flush_workqueue(lo->workqueue);
+
  	mutex_lock(&lo->lo_mutex);
  	filp = lo->lo_backing_file;
  	lo->lo_backing_file = NULL;
@@ -1168,17 +1187,12 @@ static void __loop_clr_fd(struct loop_device *lo)
  	lo->lo_sizelimit = 0;
  	memset(lo->lo_file_name, 0, LO_NAME_SIZE);

-	/*
-	 * Reset the block size to the default.
-	 *
-	 * No queue freezing needed because this is called from the final
-	 * ->release call only, so there can't be any outstanding I/O.
-	 */
-	lim = queue_limits_start_update(lo->lo_queue);
+	/* Reset the block size to the default. */
+	lim = queue_limits_start_update(q);
  	lim.logical_block_size = SECTOR_SIZE;
  	lim.physical_block_size = SECTOR_SIZE;
  	lim.io_min = SECTOR_SIZE;
-	queue_limits_commit_update(lo->lo_queue, &lim);
+	queue_limits_commit_update(q, &lim);

  	invalidate_disk(lo->lo_disk);
  	loop_sysfs_exit(lo);
@@ -1216,6 +1230,9 @@ static void __loop_clr_fd(struct loop_device *lo)
  	WRITE_ONCE(lo->lo_state, Lo_unbound);
  	mutex_unlock(&lo->lo_mutex);

+	/* Reallow I/O. */
+	blk_queue_flag_clear(QUEUE_FLAG_DYING, q);
+
  	fput(filp);
  }


