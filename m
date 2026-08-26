Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4150F38759C;
	Wed, 26 Aug 2026 17:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787766299; cv=none; b=DQwHZ8SIp6yQTQBWE+JmerJxMk/TgRgdQcV2iCyRTSEwlv7qdgg/nBHpxx+g1bBQOD2cVFqrpqBoy970egsiX3DygYqznrAAi0kBmuKsoSF7GN2SyjVptTDG6TmcEukJ/tcxyH1AmWKjACOUUOtI1uuIa4ctERYB1u1lYVbTiN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787766299; c=relaxed/simple;
	bh=Cjej1b9ulZD4SLUQ65giMci24Ri25n5cpkeOZilNV4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fin0ynrAetuPs9jQYKJuWaYJFlq/WkPSe7GfMnb+jhwNBaeOadvLI4gYbnK0ENBqGaHGcTf3evqeNLVGfOSq7AfGQNvBdaZ0CBUAmc+qC+QAqzMvJw4qCNCBCDFMJ9QdqRAkcPsFRIHf2jm1NGj/plyQqTLzvprl1aa5gIgtd5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=OFqb6n8G; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="OFqb6n8G"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hVX8n71kxzlfvpx;
	Wed, 26 Aug 2026 17:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1787766265; x=1790358266; bh=pKO6GRYJSRPMTr9pvNHVs822
	TckI3HU9vvYb2xgjpAU=; b=OFqb6n8GcMt8UWt8cEPiFHdWAFNtin5l+i5VB6wP
	jTVOkEhfPtcdFjxv0Me7UiKOA2z0h0xP8UyT55M0bTYMwsyoKNj27kluU9XeeN+S
	vI1gSBHZsSOUWObkuiYnWNpWlJB95IbAA7U766Gkr5Ga0NUDakR9q3aF1vuXJPOc
	tC5IfBnbtS7iK4O/1o1CiOeJMbz7UAxPGHr9X0x5hX3HgdtzK0Dkpy1j+p5n/zwr
	DO4vdhdnXALV+9+IYemXGPhNutqDu3XKj0YfT/WiQImBFSIcx16OHu9gRF02ulZF
	RZ9CRZdGUVBC2c8EfJPH6b+iEy49QWhlQzkLD3tF9enSvg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3siDX9OQjeDl; Wed, 26 Aug 2026 17:44:25 +0000 (UTC)
Received: from [100.80.227.50] (unknown [104.135.182.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hVX8N5fq6zlfvpH;
	Wed, 26 Aug 2026 17:44:20 +0000 (UTC)
Message-ID: <d2f387b9-031a-4306-9323-56f98a8241b7@acm.org>
Date: Wed, 26 Aug 2026 10:44:19 -0700
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
 <7e51bca8-218a-40b8-8ff8-fc59671f5add@acm.org>
 <3bb080d0-4421-4012-8a62-6a2bf165cbd9@I-love.SAKURA.ne.jp>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <3bb080d0-4421-4012-8a62-6a2bf165cbd9@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/26/26 3:37 AM, Tetsuo Handa wrote:
> Current situation is a result of what we had considered 4 years ago; we don't need
> to destroy workqueue (note that destroy_workqueue() implies drain_workqueue()) from
> __loop_clr_fd() ( https://lkml.kernel.org/r/20220330052917.2566582-16-hch@lst.de ).
> 
> Since there is a
> 
>    Chain exists of:
>      (wq_completion)loop0 --> system_transition_mutex/1 --> &disk->open_mutex
>    
>     Possible unsafe locking scenario:
>    
>           CPU0                    CPU1
>           ----                    ----
>      lock(&disk->open_mutex);
>                                   lock(system_transition_mutex/1);
>                                   lock(&disk->open_mutex);
>      lock((wq_completion)loop0);

This ABBA locking scenario can only be triggered if a loop device is
bound to a sysfs attribute with read or write methods that lock
system_transition_mutex, e.g. /sys/kernel/power, isn't it?

> dependency, but my proposal to forbid binding loop device to pseudo files
> ( https://lkml.kernel.org/r/148efba2-a0b6-47d7-ac76-b19d2f4b696c@I-love.SAKURA.ne.jp )
 > was rejected by Christoph, we are stuck in a
 >
>    Draining workqueue with open_mutex held causes creating a complex lock dependency
>    chain involving the global system_transition_mutex. (Maybe there are other paths
>    that create similar dependency chain if we drain workqueue with open_mutex held.)
> 
> versus
> 
>    Not draining workqueue causes NULL pointer dereference in lo_rw_aio().
> 
> collision. Therefore,
> 
>    Draining workqueue *without open_mutex held* can avoid creating a complex lock
>    dependency chain involving the global system_transition_mutex and can also avoid
>    NULL pointer dereference in lo_rw_aio().
> 
> is my solution.

Releasing and reacquiring disk->open_mutex from __loop_clr_fd() seems
risky to me. There is plenty of code in block/bdev.c that assumes that
disk->open_mutex is not released by lo_release().

I think there is another solution: instead of draining the workqueue
from inside __loop_clr_fd(), postpone it until the next time the loop
device is bound. See also the patch below.

Regarding your earlier request for a Sashiko review: I will look into
configuring Sashiko such that I can run "sashiko review ${commit_id}"
locally. The only part I'm missing right now is a Sashiko API key.

Thanks,

Bart.

loop: Serialize I/O and queue limits updates

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 119758b45e47..1406932fae93 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1086,6 +1086,12 @@ static int loop_configure(struct loop_device *lo, 
blk_mode_t mode,
  			error = -ENOMEM;
  			goto out_unlock;
  		}
+	} else {
+		/*
+		 * Wait until all work related to a previously bound file has
+		 * finished.
+		 */
+		flush_workqueue(lo->workqueue);
  	}

  	/* suppress uevents while reconfiguring the device */
@@ -1154,11 +1160,27 @@ static int loop_configure(struct loop_device 
*lo, blk_mode_t mode,
  static void __loop_clr_fd(struct gendisk *disk, struct loop_device *lo)
  	__must_hold(&disk->open_mutex)
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
  	mutex_lock(&lo->lo_mutex);
  	filp = lo->lo_backing_file;
  	lo->lo_backing_file = NULL;
@@ -1169,17 +1191,12 @@ static void __loop_clr_fd(struct gendisk *disk, 
struct loop_device *lo)
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

  	invalidate_disk(disk);
  	loop_sysfs_exit(lo);
@@ -1217,6 +1234,9 @@ static void __loop_clr_fd(struct gendisk *disk, 
struct loop_device *lo)
  	WRITE_ONCE(lo->lo_state, Lo_unbound);
  	mutex_unlock(&lo->lo_mutex);

+	/* Reallow I/O. */
+	blk_queue_flag_clear(QUEUE_FLAG_DYING, q);
+
  	fput(filp);
  }


