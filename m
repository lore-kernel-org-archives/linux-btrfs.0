Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7013822D4E9;
	Mon, 17 Aug 2026 03:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786937934; cv=none; b=l+UGSTIEETLKlfDNFgsWQ+WbBE4Y1QUEaASSxLleJjCEaYQxrgZam+xmVI1qEjgNTFYSXTJvEe6StcIb0HI7A/268TJtWlU2yJzzHGMjyWMnA9yq4iN/MAxy2MbJM3rb+ZMO41Oeio+noG0YEScLua78j1JHDaKk5Mik5XvVREk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786937934; c=relaxed/simple;
	bh=P08VSwN2Kt5nykcZ238igfZpFxoyKC4s439Vb+VZ5uo=;
	h=Message-ID:Date:From:MIME-Version:To:CC:Subject:References:
	 In-Reply-To:Content-Type; b=Ng+g1ovGA/WQOGSYGcj4K50M5pfexykA1sndmFZWcaFMw/1Ix0fCx0wZ+2GOPK+P7u5YzU/SUwP2PRzp1BfxOr8HvOErYkH6B/7krBLRC65yUAFou8sZ99Jr6qRawOKabo2QRF5Ar0OB07NA/3MC4w4WtzHqTUZqWW+I271Dt+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=ZAwR17u4; arc=none smtp.client-ip=220.197.31.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="ZAwR17u4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Message-ID:Date:From:MIME-Version:To:Subject:
	Content-Type; bh=SVKrx1CcbZW2FYvLz8CGi9plMno1uHCIltTvCH/a6CU=;
	b=ZAwR17u4OSmWzHN7mfMhQcuOMyclAyzoU9ZbZP8MRDpiElNWjbGLqnDZuZN+Le
	VnUY9avbZvZ34h6h1mzJnfUR8/wx3ru2vuk++JHZmvGIooDwD2Y6iu991OrHmFe8
	g2B+yIicWYaeweZMwgVvdXV1eRc7mq9Z/Fzx+JLpK+gWk=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCkvCgDnD3wqgoJqwR0sFQ--.18802S2;
	Mon, 17 Aug 2026 11:38:19 +0800 (CST)
Message-ID: <6A828214.40702@126.com>
Date: Mon, 17 Aug 2026 11:37:56 +0800
From: Hongling Zeng <zhongling0719@126.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
To: Qu Wenruo <wqu@suse.com>, clm@fb.com, dsterba@suse.com, 
 naohiro.aota@wdc.com, josef@toxicpanda.com
CC: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix use-after-free in mark_block_group_to_copy
References: <20260817014633.13293-1-zenghongling@kylinos.cn> <6A8275D6.4060709@126.com> <586ff25f-3a54-4ab7-b533-abdf692dbd22@suse.com>
In-Reply-To: <586ff25f-3a54-4ab7-b533-abdf692dbd22@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCkvCgDnD3wqgoJqwR0sFQ--.18802S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGFWkXw1rZFyDJrW8XrWfGrg_yoW5tFWDpF
	W5Aan8Jr4kAr1vvrn2q3WYvFySyws3KrWUWrn8KFWfZ3Z0vrn7WFWI9w1Y9FWUKr4kA342
	vF1UuFykXFZ8CrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j5zVbUUUUU=
X-CM-SenderInfo: x2kr0wpolqwiqxrzqiyswou0bp/xtbBrgvltmqCgishAAAA3W


在 2026年08月17日 11:09, Qu Wenruo 写道:
>
>
> 在 2026/8/17 12:15, Hongling Zeng 写道:
>>    Thanks for the review.
>>
>>    This patch was developed with assistance from Claude AI.
>>
>>    The AI helped with:
>>    - Analyzing the code paths to understand the use-after-free scenario
>>    - Identifying potential deadlock risks with different locking 
>> approaches
>>    - Cross-referencing similar locking patterns in send.c and backref.c
>>    - Drafting the commit message
>>
>>    I modified the code to add the commit_root_sem locking myself, 
>> reviewed and
>>    tested the changes before submission.
>>
>>    Apologies for not disclosing AI assistance earlier. I will ensure 
>> to do so in
>>    future submissions.
>>
>>    Best regards,
>>    Hongling Zeng
>>
>> 在 2026年08月17日 09:46, Hongling Zeng 写道:
>>> mark_block_group_to_copy() iterates over the commit root with
>>> skip_locking=true to avoid lock contention. Without holding
>>> commit_root_sem,a concurrent transaction commit can swap and free
>>> the commit root during iteration, leading to use-after-free when
>>> accessing extent buffers.
>>>
>>> The fix adds commit_root_sem locking, but CRITICALLY must only cover 
>>> the
>>> actual search period (btrfs_for_each_slot), NOT the preceding while 
>>> loop
>>> which calls btrfs_commit_transaction(). If held during that loop, we 
>>> get
>>> self-deadlock: down_read(commit_root_sem) → btrfs_commit_transaction()
>>> → switch_commit_roots() → down_write(commit_root_sem), blocking forever
>>> on our own read lock.
>>>
>>> Lock scope:
>>> - down_read() after path setup, before btrfs_for_each_slot
>>> - up_read() immediately after btrfs_for_each_slot completes
>>> - NOT held during while loop (btrfs_commit_transaction) path
>>> - NOT held on the !path error path (goto unlock before lock
>>>    acquisition)
>>>
>>> This matches the established btrfs pattern used in send.c, 
>>> backref.c, etc.:
>>> hold commit_root_sem read lock ONLY while searching commit root, never
>>> across transaction commits.
>>>
>>> Fixes: 78ce9fc269af ("btrfs: zoned: mark block groups to copy for 
>>> device-replace")
>>> Cc:stable@vger.kernel.org
>>> Signed-off-by: Hongling Zeng<zenghongling@kylinos.cn>
>>> ---
>>>   fs/btrfs/dev-replace.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
>>> index dc0834f920c3..734807bf48b3 100644
>>> --- a/fs/btrfs/dev-replace.c
>>> +++ b/fs/btrfs/dev-replace.c
>>> @@ -499,6 +499,7 @@ static int mark_block_group_to_copy(struct 
>>> btrfs_fs_info *fs_info,
>>>       key.type = BTRFS_DEV_EXTENT_KEY;
>>>       key.offset = 0;
>>>   +    down_read(&fs_info->commit_root_sem);
>
> And there is already path::need_commit_sem, which does a smaller 
> critical section than holding it manually.
   Thanks for the review.

   I've updated the patch to use path->need_commit_sem as suggested. This is
   indeed a better approach than manual commit_root_sem locking.

   V2 patch is attached.

   Best regards,
   Hongling Zeng

>
>>>       btrfs_for_each_slot(root, &key, &found_key, path, iter_ret) {
>>>           struct extent_buffer *leaf = path->nodes[0];
>>>   @@ -525,6 +526,8 @@ static int mark_block_group_to_copy(struct 
>>> btrfs_fs_info *fs_info,
>>>       if (iter_ret < 0)
>>>           ret = iter_ret;
>>>   +    up_read(&fs_info->commit_root_sem);
>>> +
>>>       btrfs_free_path(path);
>>>   unlock:
>>>       mutex_unlock(&fs_info->chunk_mutex);
>>

