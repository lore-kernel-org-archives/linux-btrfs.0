Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79777480950;
	Mon, 31 Aug 2026 16:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788192710; cv=none; b=YQ/G7zwN+zxmnphBgNTM5RGgW9m//ffWA+6z+CIxkXw2XNc9QfwQJA5U4j/tBrYEHKxuBC/EygH3gQAZSkCoJE28trrGq/gLLWeTbIkMHk9VOdnb4u9CGi9DizSPYZ/b+oKN3+irdhiuQ8bkHRD4yKywScRKY0pfvIQKnryIGFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788192710; c=relaxed/simple;
	bh=sicnSWr3LLykL6VHJw4ru4rvykqfbQvophVJlU2VLeg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jotziZq7sN26hNCUWaAgrUNTa8RM1HELa+C3/HwRUKyCYwHMsM0/jY0qlPyHiwVNNGDMg+J6+O2rbT8L+6aBk0OnJeROh4Mutc2jos6gwyDs6uQ/gg8JQwdP0IYYIFi76ER2IEY6HBE+dIg7C3rYcDAQU8TKyjJUVntVcogyD8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=fT/f4BMM; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="fT/f4BMM"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hYYsB4rR1zlfvpM;
	Mon, 31 Aug 2026 16:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1788192693; x=1790784694; bh=jhX26N7F0/Ed1ARbfB1NVNHs
	qDMo83yFHzbfY9XMHws=; b=fT/f4BMMo5BXiBLtQgjm9PZDecej111CHumeT2BZ
	Ft3Ifp51QQc8NClJV+swhFgJHT9HOMqLRJgGQv9x6WZDqYc/tiSq2WxOWO7P9kpR
	hhMDgfQk49NRGlmUu1Yrxj8/hcElb5PsxP5k+DfOnv0qHqpLPI9f/E8LszkaShsT
	wLpPB0KGPI2oYt/e0Vw/XCqCN4vL2hTqBSMRXNgZn1aR93XJbw2GKdpN1Zf/umFl
	TnNYlRLcBM9Ye+axSJxOuNFb7QinJaiuXCiwNyiqjFcxgCyomZRpURzi+eXB/3IH
	ZpZQe4OGh3PuUnP6OtsS1+eRNEIoBVMfOIYylZvskk8kFA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ld4mIkJqITHn; Mon, 31 Aug 2026 16:11:33 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:a104:ffdc:9983:687c] (unknown [104.135.182.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hYYrt4LzMzlfvqR;
	Mon, 31 Aug 2026 16:11:26 +0000 (UTC)
Message-ID: <bf774766-0613-4465-9f9b-62455ac0813b@acm.org>
Date: Mon, 31 Aug 2026 09:11:25 -0700
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7] loop: Fix NULL pointer dereference in lo_rw_aio()
To: Tao Cui <cui.tao@linux.dev>, penguin-kernel@i-love.sakura.ne.jp,
 brauner@kernel.org
Cc: Markus.Elfring@web.de, axboe@kernel.dk, broonie@kernel.org,
 dlemoal@kernel.org, hch@infradead.org, hch@lst.de, hdanton@sina.com,
 linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-next@vger.kernel.org, lkp@intel.com, oe-lkp@lists.linux.dev,
 oliver.sang@intel.com, torvalds@linux-foundation.org,
 viro@zeniv.linux.org.uk, Tao Cui <cuitao@kylinos.cn>
References: <6a770a9c-2642-4392-9b9c-609836693f36@I-love.SAKURA.ne.jp>
 <20260831141143.704821-1-cui.tao@linux.dev>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260831141143.704821-1-cui.tao@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/26 7:11 AM, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> Hi Tetsuo, Bart,
> 
>> +	/* Step 1: Flush all outstanding I/O, without open_mutex held. */
>> +	/*
>> +	 * Now that loop_queue_rq() sees lo->lo_state != Lo_bound,
>> +	 * wait for already started loop_queue_rq() to complete.
>> +	 */
>> +	synchronize_rcu();
> 
> Your reply to Bart says loop_queue_rq() is called with RCU read
> lock, but I don't see one.
This is the code that protects .queue_rq() implementations like
loop_queue_rq() with an rcu_read_lock() / rcu_read_unlock() pair:

/* run the code block in @dispatch_ops with rcu/srcu read lock held */
#define __blk_mq_run_dispatch_ops(q, check_sleep, dispatch_ops)	\
do {								\
	if ((q)->tag_set->flags & BLK_MQ_F_BLOCKING) {		\
		struct blk_mq_tag_set *__tag_set = (q)->tag_set; \
		int srcu_idx;					\
								\
		might_sleep_if(check_sleep);			\
		srcu_idx = srcu_read_lock(__tag_set->srcu);	\
		(dispatch_ops);					\
		srcu_read_unlock(__tag_set->srcu, srcu_idx);	\
	} else {						\
		rcu_read_lock();				\
		(dispatch_ops);					\
		rcu_read_unlock();				\
	}							\
} while (0)

Bart.
