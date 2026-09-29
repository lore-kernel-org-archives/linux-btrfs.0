Received: from a4-3.smtp-out.eu-west-1.amazonses.com (a4-3.smtp-out.eu-west-1.amazonses.com [54.240.4.3])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6812844607B
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2026 19:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.4.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790708833; cv=none; b=rb1xYjuWCsSHv2Troz5ZLACUJNFVpTth8qZo61zzqZVBJmgVt/1NH1RP0jW8b5PQ+AuHZ2ygPj5qte0jRSS4Mw9cMJ3puoXsgpXQnwI9oD/jFB22ov5NWwKstw9ilPlacjFnw/bKRCZHp7fpW8EK5ZYOREw+agJ1fvtlFbV8wUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790708833; c=relaxed/simple;
	bh=HsyNdWHpzYz/+ocOY07H9F+OzwZhKOcbnm6O1YmlDgQ=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=SjKTUsh9t/cOp8ndk+0EXWEZmP9A+l203f1sqxvlEpkfzA2Vy4+XMauDM9OMRPECAbxWwMYdn7Vup2xCCvf5fwp2mkb+HD9oExoXnOj+3HAIm4Ddy6Wq1OjFNaL4XzZ7t4WqR7zLZAU3W4bxfs7B0r7PedcS9YfgViYQHpoIAN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=urbackup.org; spf=pass smtp.mailfrom=bounce.urbackup.org; dkim=pass (1024-bit key) header.d=urbackup.org header.i=@urbackup.org header.b=JUNM524q; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=mgd6LOc+; arc=none smtp.client-ip=54.240.4.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=urbackup.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bounce.urbackup.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=urbackup.org header.i=@urbackup.org header.b="JUNM524q";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="mgd6LOc+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=pqvuhxtqt36lwjpmqkszlz7wxaih4qwj; d=urbackup.org; t=1790708831;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=HsyNdWHpzYz/+ocOY07H9F+OzwZhKOcbnm6O1YmlDgQ=;
	b=JUNM524qLQdcQ5waamu2llFJSpXw4G7Csmc7h8zzCTgpC7X9EhNXrUH4o6EeGwWC
	y2Wl0P0Fb/Hxhjh0AdV7TxHPjn9KjllcdYEoFLYZ6NbTE/eJST9Rmsr2Z0JvkZya5Pt
	vmB3jkBg4hQP9sq7ooss22XWk+BIR72+NOAoo8bk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=shh3fegwg5fppqsuzphvschd53n6ihuv; d=amazonses.com; t=1790708831;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Feedback-ID;
	bh=HsyNdWHpzYz/+ocOY07H9F+OzwZhKOcbnm6O1YmlDgQ=;
	b=mgd6LOc+h1GptfdVdn/zjnxlp4oPtBrNe+EOu+7A+YXyUMMGicWAmRJggehCbgMH
	iv0c1OPjCCiz/Yd9onDSOQ4FqsAaqEUZ5XEOnoEebbMNKzUzBS00fmAVDD2GZosT1WI
	Zm2pN2yxKLhBgz5BNKqKX+atLTPJjOdCvfBbVDpU=
Message-ID: <010201a0ee9052a7-45286f9b-6c3a-4e00-ab15-40c792cd0f8a-000000@eu-west-1.amazonses.com>
Date: Tue, 29 Sep 2026 19:07:10 +0000
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Martin Raiber <martin@urbackup.org>
Subject: Re: [PATCH 0/6] btrfs: allocator perf improvements
To: Boris Burkov <boris@bur.io>, Sun YangKai <sunyangkai@fygo.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1790641462.git.boris@bur.io>
 <5736105a-5ba3-463d-90a7-5c70bb034621@fygo.io>
 <20260929170450.GA2494917@zen.localdomain>
Content-Language: en-US
In-Reply-To: <20260929170450.GA2494917@zen.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Feedback-ID: ::1.eu-west-1.zKMZH6MF2g3oUhhjaE2f3oQ8IBjABPbvixQzV8APwT0=:AmazonSES
X-SES-Outgoing: 2026.09.29-54.240.4.3

On 9/29/26 19:04 Boris Burkov wrote:
> On Tue, Sep 29, 2026 at 12:31:16PM +0800, Sun YangKai wrote:
>> On 2026/9/29 08:28, Boris Burkov wrote:
>>> Working on the bugs to do with large fs-es and unused block groups
>>>
>>> https://lore.kernel.org/linux-btrfs/20260916230447.GA1706558@zen.localdomain/T/#t
>>> and
>>> https://lore.kernel.org/linux-btrfs/cover.1790641111.git.boris@bur.io/T/#t
>>>
>>> revealed some low hanging fruit in allocation performance for very large
>>> mostly full fs-es. The gist is to try to skip unnecessary operations per block
>>> group which adds up with 10s of thousands of obviously skippable block
>>> groups. Running 20k fallocates in a loop on a sparse file fs improved from
>>> ~40s to ~7s.
>> Hi Boris,
>>
>> Glad to see this patchset resolves the long existing blockgroup 
>> allocator performance issue and I'm really impressed by the numbers of 
>> performance improvement.
>>
>> IMO we currently go along the list to look for a proper bg that have 
>> enough free space, which means we may have to go through thousands of 
>> bgs during the allocation, I wonder if it is worthy to use a more 
>> efficient method like something sorted by bg's free space to improve the 
>> lookup process?
> I considered this while working on the size class stuff some years ago.
> If you look into the free space cache inside each block group, it does
> in fact index by gap size as well as gap offset.
>
> However if you do that at the block group level, then each allocation
> requires a write to the global ordering of block groups so that means
> having many parallel allocating threads now requires them to fight over
> a write lock on that ordered structure. I think that at least rules out
> naive solutions.
>
> You could probably resolve it with some more clever scheme like batching
> or queuing the work to update the ordering, or maybe some duplicated
> view with atomic cut overs.
>
> If you are interested in allocator performance, another thing we should
> consider is resurrecting more of
> https://lore.kernel.org/linux-btrfs/0102019bb2ff5805-8aa151b8-1fe7-4087-9610-4c3314b3b144-000000@eu-west-1.amazonses.com/
>
> I actually didn't realize that Martin had hit a few of the same things
> in that series so now I feel a bit bad about not working harder to
> incorporate his work earlier.
>
> If this series of mine goes in, we are ok on the put/get part since I
> just got rid of it, and I was planning to get rid of data_rwsem after
> https://lore.kernel.org/linux-btrfs/20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu/
> goes in. But I have not tried to tackle the scalability of groups_sem
> yet, and would probably start by seriously evaluating Martin's patch and
> re-sending his work for that one.

Np, I was just solving for the specific problems I saw with minimum effort.

I would imagine there might be performance problems with just replacing with a percpu semaphore (e.g. with zoned).
Maybe it needs to be a RCU list? Or different arenas like memory allocators (since you are already using size classes...)?

>
>> Please correct me if I got anything wrong.
>>
>> And thanks for bringing these great patches.
>>
>> Sun Yangkai
>>
>>> Boris Burkov (6):
>>>    btrfs: skip unhelpful size class relaxing allocation loops
>>>    btrfs: don't take block group references in find_free_extent()
>>>    btrfs: remove redundant checks in find_free_extent() hint path
>>>    btrfs: factor the find_free_extent() block group skip into a helper
>>>    btrfs: find_free_extent checks full block groups unlocked
>>>    btrfs: find_free_extent checks size class unlocked
>>>
>>>   fs/btrfs/extent-tree.c | 88 +++++++++++++++++++++++++++++-------------
>>>   fs/btrfs/extent-tree.h |  3 ++
>>>   2 files changed, 65 insertions(+), 26 deletions(-)


