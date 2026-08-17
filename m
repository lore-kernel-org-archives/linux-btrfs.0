Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0978626296;
	Mon, 17 Aug 2026 06:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786949590; cv=none; b=O9XlcyeSqPVO4NX8cS1nRJJDf83C7bYaDqtDTUOJGeDlHGDyP1Pk3YXz8TuyFrsHASYovGT92KDFkBjY0w+ddy5CYtDx11ydDZuhGL2f9Ojy9ePx/SuvZJTIwyCBiMudvxG+KBLTNNO5B9vNgIDgJ2atxr6c8Od9kZdfwe9/3A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786949590; c=relaxed/simple;
	bh=p3/Sw/eJ0ZET0TkCIyedSL83NsIXWqmnGZVWEyechoQ=;
	h=Message-ID:Date:From:MIME-Version:To:CC:Subject:References:
	 In-Reply-To:Content-Type; b=nsJPi+UvGP6zbAASx5LvRROgUswZE8d2kn1hA/slNy2QJqy9/pO3lsUEHodoB6FZfhLtn35x3EbKw9H94WH/xhERwJb2RYbWKDfJHfdOYxwISsQXCA8oLqtMK9cBcWxGl2fN34tpKw1BYP53SOQGcgd5IY8ILL1nxsNKUlScr2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=G7K2PYfn; arc=none smtp.client-ip=117.135.210.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="G7K2PYfn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Message-ID:Date:From:MIME-Version:To:Subject:
	Content-Type; bh=T6JhlI5Lwjo13OciHZyhNMqjBQV4tl4R3bmbw7QKmeE=;
	b=G7K2PYfn6R2XrEw0DonOaL7V01DFst+Bm+tlEbxvey/TW0jV4IOoWr2+Bk/gRw
	UShrlpH4fB+DHeh4+iFl3GuIYVsyqB+5emPWI7LU7TgZ7ByEoDOCphIDLk3+c7p+
	B4tKsAflqQV/w3fKsTpH0czBU9i+f3Aq8MspOBFapYVNc=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wDHL2igr4Jq4LjfFw--.22964S2;
	Mon, 17 Aug 2026 14:52:16 +0800 (CST)
Message-ID: <6A82AF88.4090101@126.com>
Date: Mon, 17 Aug 2026 14:51:52 +0800
From: Hongling Zeng <zhongling0719@126.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
To: Qu Wenruo <wqu@suse.com>, Hongling Zeng <zenghongling@kylinos.cn>, 
 clm@fb.com, dsterba@suse.com, boris@bur.io, willy@infradead.org
CC: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix missing folio_unlock in read_merkle_tree_page
 error path
References: <20260817053607.46939-1-zenghongling@kylinos.cn> <72e6138f-3c9e-4094-a746-bd1e4c6f1558@suse.com>
In-Reply-To: <72e6138f-3c9e-4094-a746-bd1e4c6f1558@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDHL2igr4Jq4LjfFw--.22964S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CrWfKry5XF4fZr1fJrykuFg_yoW8Cryfpr
	4xG3Z8C395Jr18ur4IkanIyryFv34DJa15ZF9xWw4Iv3Z3ZFn2gFW2k3WY93y8Jr4UGFWf
	tw4SgF1qvF1DArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jjyIUUUUUU=
X-CM-SenderInfo: x2kr0wpolqwiqxrzqiyswou0bp/xtbBoQFPIGqCr6G9qQAA39


在 2026年08月17日 14:43, Qu Wenruo 写道:
>
>
> 在 2026/8/17 15:06, Hongling Zeng 写道:
>> filemap_add_folio() adds the folio to the page cache and leaves it 
>> locked.
>> If read_key_bytes() fails, the error path only calls folio_put() without
>> first unlocking the folio, leaving it permanently locked in the page 
>> cache.
>> This causes subsequent attempts to lock this folio to hang.
>>
>> Fix by adding folio_unlock() before folio_put() in the error handling 
>> path.
>>
>> Fixes: 06ed09351b67 ("btrfs: convert btrfs_read_merkle_tree_page() to 
>> use a folio")
>> Cc: stable@vger.kernel.org
>> Assisted-by: Codex:gpt-5.5
>> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
>
> A fix is already submitted and merged:
>
> https://lore.kernel.org/linux-btrfs/20260722025435.1493093-1-chenyichong@uniontech.com/ 
>
>
> Next time let your agent to read the btrfs developer's note and check 
> if there is already a fix:
>
> https://btrfs.readthedocs.io/en/latest/dev/Developer-s-FAQ.html#development-phase-linux-next-for-next 
>
>
   Thanks for the feedback.

   I should have checked for existing fixes first.

   I will ensure to check git history and mailing lists before submitting
   future patches.

   Apologies for the duplicate submission.
>> ---
>>   fs/btrfs/verity.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
>> index 983365a73541..4431656140f8 100644
>> --- a/fs/btrfs/verity.c
>> +++ b/fs/btrfs/verity.c
>> @@ -753,6 +753,7 @@ static struct page 
>> *btrfs_read_merkle_tree_page(struct inode *inode,
>>       ret = read_key_bytes(BTRFS_I(inode), 
>> BTRFS_VERITY_MERKLE_ITEM_KEY, off,
>>                    folio_address(folio), PAGE_SIZE, folio);
>>       if (ret < 0) {
>> +        folio_unlock(folio);
>>           folio_put(folio);
>>           return ERR_PTR(ret);
>>       }

