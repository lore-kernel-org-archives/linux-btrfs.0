Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE97B3C5DB5;
	Mon, 23 Mar 2026 18:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774289101; cv=none; b=TIQz20625G5dVN/tLiS5JqYRAHhjybDyc6766nZpvwA3RNMzdrKLLjYe97xkjFuOTkq4lmk5lMdey9SfxKFDyPFe9Gzd1x7JyMC7WtN/DXd/IdiWKk674mwmLsbQUMGkVVePl3kwsrHVYgTmh3RtVR94ta6njAMrVRHgNJ6eJXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774289101; c=relaxed/simple;
	bh=0u4JasBlYSKASg+QbISo2phqKucpCXk7LdckBb6sXjI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZQZugTvLcp4R694+8PDGkuo/wSqJ7Es95XQgOdV/jcFB+WyHbUm/rGojE+Bl+CUnpXOE5YJQXUwCodI9UOcZCjfBjyuaaKY/2MX9QAeiKriwzPO+/6FHc/FLnz3OqMO8vE+hsytMLXZJt0Ph8dm5viyEtNX/CE5kvcrDx0jrjAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u6Z5S+n4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u6Z5S+n4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EC9C2BC9E;
	Mon, 23 Mar 2026 18:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774289101;
	bh=0u4JasBlYSKASg+QbISo2phqKucpCXk7LdckBb6sXjI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=u6Z5S+n4xiQ3XcZURc/dn3ofbB8sDA8HrWBXLc/yoBjyzs/fmDnPK0vPZHNoSGV80
	 qoH+zza8X1nMv1ljOYXhf85ZJifeESGCJkc4WUen6BqJ5aretOOccrqgidfrJOgCzx
	 NOIoILZizrjqfGQ+pDsEqaX4zO9JGR5TLag/TdNThtrq5DnOHe/uUTA5KiFSIzxYGD
	 EPxxKr8Dw/Wx80Ixh8Aezcke4lr4jo+dEhdNi6RCR4ceBX88z+oDBPqmsLAKhO9Q1u
	 kltxKmQht+4jprvr9mLQTb7FoFNd719uaRP+4aE5L8gWxHA5Lwk3+QyDFCkSooCU7t
	 JNpXJSsHzcH5w==
Message-ID: <53a8bc40-f22a-4447-a233-1cf88f837bbf@kernel.org>
Date: Mon, 23 Mar 2026 14:04:57 -0400
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
 <f2f7fff3-2f6a-4ebb-aa5e-33188be4dd9a@kernel.org>
 <acFmcCcbPfznH_it@gmail.com>
Content-Language: en-US
From: Chuck Lever <cel@kernel.org>
Organization: kernel.org
In-Reply-To: <acFmcCcbPfznH_it@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/23/26 12:26 PM, Breno Leitao wrote:
> Hello Chuck,
> 
> On Mon, Mar 23, 2026 at 11:28:49AM -0400, Chuck Lever wrote:
>> On 3/23/26 11:10 AM, Breno Leitao wrote:
>>>
>>> I am not convinced. The wq_cache_shard_size approach creates multiple
>>> pools on large systems while leaving small systems (<8 cores) unchanged.
>>
>> This is exactly my concern. Smaller systems /do/ experience measurable
>> contention in this area. I don't object to your series at all, it's
>> clean and well-motivated; but the cores-per-shard approach doesn't scale
>> down to very commonly deployed machine sizes.
> 
> I don't see why the cores-per-shard approach wouldn't scale down
> effectively.

Sharding the UNBOUND pool is fine. But with a fixed cores-per-shard
ratio of 8, it doesn't scale down to smaller systems.


> The sharding mechanism itself is independent of whether we use
> cores-per-shard or shards-per-LLC as the allocation strategy, correct?
> 
> Regardless of the approach, we retain full control over the granularity
> of the shards.
> 
>> We might also argue that the NFS client and other subsystems that make
>> significant use of UNBOUND workqueues in their I/O paths might be well
>> advised to modify their approach. (net/sunrpc/sched.c, hint hint)
>>
>>
>>> This eliminates the pathological lock contention we're observing on
>>> high-core-count machines without impacting smaller deployments.
>>
>>> In contrast, splitting pools per LLC would force fragmentation even on
>>> systems that aren't experiencing contention, increasing the need for
>>> manual tuning across a wider range of configurations.
>>
>> I claim that smaller deployments also need help. Further, I don't see
>> how UNBOUND pool fragmentation is a problem on such systems that needs
>> to be addressed (IMHO).
> 
> Are you suggesting we should reduce the default value to something like
> wq_cache_shard_size=2 instead of wq_cache_shard_size=8?

A shard size of 2 clearly won't scale properly to hundreds of cores. A
varying default cores-per-shard ratio would help scaling in both
directions, without having to manually tune.


-- 
Chuck Lever
