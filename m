Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB80A370AEC;
	Mon, 24 Aug 2026 23:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787613859; cv=none; b=TNgynuR+rDP9pVrL2VJnEtUrYT1zLi/lKk0iS7H4+1Y9q4M2mF5MWNpJsZuyqhPVFMpEu4p/+KDCMxuLvh7VkGVjsvBu0QOMkwEiYTcSwNOFT+RWw2o6io+XnCsPKGeokWx7tf+CxYPPCJTL9Lve+sclww/Wt8pWZjkIMbvWxYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787613859; c=relaxed/simple;
	bh=adOiD5KafkF6qvtKXkip0aox5S//FFAwiXdRqx/1ihM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=YpDthNdfcTcdcfG+WtwG2ReNHfRYygAQREITOuBiSdNRfhQbg1lfyLCE3N2lCVWCDvxYX9Uc7YwVW3aCRVgVCE2pzqe6RppEVUAH6TiMHKbNtL/jMzwlPMjPHiVhtale3ypZd/E1NFwyUdFdOSp5nMIA1uDAPWp6Pk5/WusqkmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BcJejdDk; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BcJejdDk"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hTRnX3zHxzlfvpN;
	Mon, 24 Aug 2026 23:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:content-language:references:from:from:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1787613846; x=1790205847; bh=ocuDfgeVeXBvxz+EsS87xMyg
	ugyxd5KplnFbu5clVXA=; b=BcJejdDki4grlIGKntNsI5pgZfzlGd1YyvbWX0ZB
	Cwf50OkEFYbov4nP2f6p8J9Cr1t+uet8WRAGtAfaCmROtsgYWJkzW7SWwds5chSR
	zsgLVKY9TybKRXdWnwji2VqmwjFyEbnQLcfg0vuuGpVgJ+L44Gee7f05T5eYvgPF
	1lxKwsZpPZnjrTfAyXQVKzJv7z2iix82/zGvlx8wVI0a8LRMCDO32GidrNfqVDzZ
	QJ/mcvJztkoWhmV1mcY0p3dJdwOVXOV2FoNqqv2U481l2WlE38OYrlNImlDfE/Je
	//R0S3s/GKxTXK3umvBwnoW9hM50PyOHAk3R6kbGzGMAFA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IeeEtXAXikXI; Mon, 24 Aug 2026 23:24:06 +0000 (UTC)
Received: from [100.80.227.50] (unknown [104.135.182.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hTRnF6xHvzlfvq9;
	Mon, 24 Aug 2026 23:24:01 +0000 (UTC)
Message-ID: <27bcb147-bead-4432-8cd0-981489f36228@acm.org>
Date: Mon, 24 Aug 2026 16:24:00 -0700
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] loop: Fix NULL pointer dereference in lo_rw_aio()
From: Bart Van Assche <bvanassche@acm.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Markus Elfring <Markus.Elfring@web.de>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, Damien Le Moal
 <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, lkp@intel.com,
 oe-lkp@lists.linux.dev, Christian Brauner <brauner@kernel.org>,
 Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>,
 Hillf Danton <hdanton@sina.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Mark Brown <broonie@kernel.org>, Oliver Sang <oliver.sang@intel.com>
References: <8dedfc40-9cae-44ff-9960-e0eb1825e963@I-love.SAKURA.ne.jp>
 <550ff0b4-df39-46d2-9781-c8688df10c93@web.de>
 <38ad64c1-edc7-431d-8f52-fba572ebf3eb@I-love.SAKURA.ne.jp>
 <372ca5f6-81a0-4f6c-8f55-ebeeada9f955@acm.org>
Content-Language: en-US
In-Reply-To: <372ca5f6-81a0-4f6c-8f55-ebeeada9f955@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/24/26 3:53 PM, Bart Van Assche wrote:
> On 8/24/26 3:06 PM, Tetsuo Handa wrote:
>> I still cannot catch why Bart's approach can become safe without
>> synchronize_rcu() and drain_workqueue().
> 
> Agreed that drain_workqueue() or flush_workqueue() is necessary. I do
> not agree that an explicit synchronize_rcu() call is required. Waiting
> until the request queue is frozen includes this call implicitly.
> See also __percpu_ref_switch_to_atomic().

A correction: it is not safe to call drain_workqueue() nor to freeze the
request queue in __loop_clr_fd(). I'm considering to modify the comment
in that function as follows:

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1203,8 +1203,13 @@ static void __loop_clr_fd(struct loop_device *lo)
         /*
          * Reset the block size to the default.
          *
-        * No queue freezing needed because this is called from the final
-        * ->release call only, so there can't be any outstanding I/O.
+        * Asynchronously submitted I/O may still be in progress. 
Freezing the
+        * request queue is not possible without triggering lock inversion.
+        * Freezing a request queue must happen between the
+        * queue_limits_start_update() and queue_limits_commit_update 
calls.  If
+        * the request queue would be frozen between these two calls, a 
deadlock
+        * can be triggered with the loop_clear_limits() call from the 
I/O path
+        * since loop_clear_limits() also calls queue_limits_start_update().
          */

Thanks,

Bart.
