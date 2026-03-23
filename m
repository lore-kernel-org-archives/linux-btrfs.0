Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809D53B27F9;
	Mon, 23 Mar 2026 15:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279731; cv=none; b=pqzgTDggbkOmnYCZOBtCVd2o/G/RLAUO4EwFVPqWaxV3xMIqbexOb1htVZ9onI4l1R4M07v+jPSaQR6wkQluWdsS5H58SAxdiayDtv8Qj8lpH7SOmjrKDqwKDtA+Z/8ertHEnFy03TmrFguCZlFuQ3T9yN+sUTn2T7Di/E/sZUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279731; c=relaxed/simple;
	bh=uKxhkwNLQ1A6zwshl17eoxhqYldXen4HDfeimtnqolw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HdRCV+Un98HSC3pQQfkObz+7oUdh+/7qEw5FSfyN/HTKqw98ddWivmTSG8QIC/dTghz3lIMcNg1po5lng3pnnnyYdJMYY0+IXt1w8G/i9xxCnYb7w+uqyWbWpeu/lH9kxFJEhVSSCygnFOj0MXsHTET4ZrNaMBocxBL7jBMhvfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SrG2XzhG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SrG2XzhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BB3C4CEF7;
	Mon, 23 Mar 2026 15:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774279731;
	bh=uKxhkwNLQ1A6zwshl17eoxhqYldXen4HDfeimtnqolw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SrG2XzhGCXO0jUc79sDAIaXw18YG8XtYZClqLqb7u0nvyZ0hZ6kBjDzWNesVxEOBV
	 8EqwhoysAWLLqQpCM1+v2+RZLpklIt8r1+abuvOQPHVsq8d58ekiVEa0V+2ys3jOqi
	 xAgAqumpoaYzq12fPMd+yRbLZMrGxdBUDImcCtBefNmfy9vRA43z38DK4Ou4xGFzGL
	 lOyTv97zBumxHsf5q6yeYjSBZPuyj92g83S3kKQvvBoElh0W+RqfNw+YI9SjkYknB4
	 +0Z/ee/7ASCbOOZTlysWEhTAZwGG1OWYdLWEMh/W+302eJTUA+5nGtVxkiWi1xHuHV
	 prSi57Zd99QGg==
Message-ID: <f2f7fff3-2f6a-4ebb-aa5e-33188be4dd9a@kernel.org>
Date: Mon, 23 Mar 2026 11:28:49 -0400
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] workqueue: Introduce a sharded cache affinity
 scope
To: Breno Leitao <leitao@debian.org>
Cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 puranjay@kernel.org, linux-crypto@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Michael van der Westhuizen <rmikey@meta.com>, kernel-team@meta.com,
 Chuck Lever <chuck.lever@oracle.com>
References: <20260320-workqueue_sharded-v2-0-8372930931af@debian.org>
 <04af531d-d8a3-4fbb-993d-e1da2df62a03@app.fastmail.com>
 <acFVEr7iVnU_70yh@gmail.com>
Content-Language: en-US
From: Chuck Lever <cel@kernel.org>
Organization: kernel.org
In-Reply-To: <acFVEr7iVnU_70yh@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 3/23/26 11:10 AM, Breno Leitao wrote:
> Hello Chuck,
> 
> On Mon, Mar 23, 2026 at 10:11:07AM -0400, Chuck Lever wrote:
>> On Fri, Mar 20, 2026, at 1:56 PM, Breno Leitao wrote:
>>> TL;DR: Some modern processors have many CPUs per LLC (L3 cache), and
>>> unbound workqueues using the default affinity (WQ_AFFN_CACHE) collapse
>>> to a single worker pool, causing heavy spinlock (pool->lock) contention.
>>> Create a new affinity (WQ_AFFN_CACHE_SHARD) that caps each pool at
>>> wq_cache_shard_size CPUs (default 8).
>>>
>>> Changes from RFC:
>>>
>>> * wq_cache_shard_size is in terms of cores (not vCPU). So,
>>>   wq_cache_shard_size=8 means the pool will have 8 cores and their siblings,
>>>   like 16 threads/CPUs if SMT=1
>>
>> My concern about the "cores per shard" approach is that it
>> improves the default situation for moderately-sized machines
>> little or not at all.
>>
>> A machine with one L3 and 10 cores will go from 1 UNBOUND
>> pool to only 2. For virtual machines commonly deployed as
>> cloud instances, which are 2, 4, or 8 core systems (up to
>> 16 threads) there will still be significant contention for
>> UNBOUND workers.
> 
> Could you clarify your concern? Are you suggesting the default value of
> wq_cache_shard_size=8 is too high, or that the cores-per-shard approach
> fundamentally doesn't scale well for moderately-sized systems?
> 
> Any approach—whether sharding by cores or by LLC—ultimately relies on
> heuristics that may need tuning for specific workloads. The key difference
> is where we draw the line. The current default of 8 cores prevents the
> worst-case scenario: severe lock contention on large systems with 16+ CPUs
> all hammering a single unbound workqueue.

An 8-core machine with 16 threads can handle quite a bit of I/O, but
with the proposed scheme it will still have a single UNBOUND pool.
For NFS workloads I commonly benchmark, splitting the UNBOUND pool
on such systems is a very clear win.


> For smaller systems (2-4 CPUs), contention is usually negligible
> regardless of the approach. My perf lock contention measurements
> consistently show minimal contention in that range.
> 
>> IOW, if you want good scaling, human intervention (via a
>> boot command-line option) is still needed.
> 
> I am not convinced. The wq_cache_shard_size approach creates multiple
> pools on large systems while leaving small systems (<8 cores) unchanged.

This is exactly my concern. Smaller systems /do/ experience measurable
contention in this area. I don't object to your series at all, it's
clean and well-motivated; but the cores-per-shard approach doesn't scale
down to very commonly deployed machine sizes.

We might also argue that the NFS client and other subsystems that make
significant use of UNBOUND workqueues in their I/O paths might be well
advised to modify their approach. (net/sunrpc/sched.c, hint hint)


> This eliminates the pathological lock contention we're observing on
> high-core-count machines without impacting smaller deployments.
> 
> In contrast, splitting pools per LLC would force fragmentation even on
> systems that aren't experiencing contention, increasing the need for
> manual tuning across a wider range of configurations.

I claim that smaller deployments also need help. Further, I don't see
how UNBOUND pool fragmentation is a problem on such systems that needs
to be addressed (IMHO).


-- 
Chuck Lever
