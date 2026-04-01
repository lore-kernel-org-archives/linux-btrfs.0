Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD16E2FD1B3;
	Wed,  1 Apr 2026 14:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775054311; cv=none; b=iALtiRL6bzNfAn0Paqs1tMNV7qti73zoaQ8Jnuva0d5InqpD1I8f90EH4pro6wFky1eX6tV93FMPCLU/VY6ipAkHJvnWlSznd70J70MHxoBSRJ4kDRox5uQYD/bPVFRuOIEKoiRHDhKXdLp2rivuk5ztDeAtOC45r6iN7FsM0Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775054311; c=relaxed/simple;
	bh=IYpu66gqA4awdKDYhB4MiwLR+Zk0dYRc4YHZqrv0M9Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T/LPcm5UfpzO6qJveupPBPHOsMNNbPbwaJmwF3aH4pSAyN8XohXjNaw+b85girH+M0CImyKKAlVkmryjR+zaC9QYyYWDuTUnc4fg6gfwtZHuYqbvHiVWIVKMCo1XenUFC+sXP/3HsvmLgDHaAvleGEOzWK8TJhdWOnRlin59PjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I1JeGroo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I1JeGroo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784FBC2BCB0;
	Wed,  1 Apr 2026 14:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775054310;
	bh=IYpu66gqA4awdKDYhB4MiwLR+Zk0dYRc4YHZqrv0M9Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=I1JeGroo5hMIqTqxRa9QFMgft/zZ2PWbwIK+GJHof+NucF9RGKXu06QCYnxZ1izgD
	 VbwCrk+dYOlxJQLJ7HhTThd5XmYRA9pg6KNyqX7+95qIhlwTJJ8M86rc2IxOuqjTMS
	 KzKMutpZYR7A+bH/IliIGo1NS7jSKG/R+lOCJQA/gk64/YG7XBFSmThGeTBsoBBVJ/
	 9rg3ENyOIFI7CMS5xIou2ziewdT8gGkHb1w7VE0BSiMN17MSCaOw4q4oskKNy5vw+o
	 0kAj6gGT8+ghznlOpAUxMyAe2wE7zZmz+lvg99mMqQSGEnsqW9sIhedMARplbaKD1i
	 O8nkVwtBTCcUg==
Message-ID: <b6596c2c-94de-43f4-b30c-c9361d55e3b8@kernel.org>
Date: Wed, 1 Apr 2026 16:38:21 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS from
 file_thp_enabled()
To: Matthew Wilcox <willy@infradead.org>, WANG Rui <r@hev.cc>
Cc: ziy@nvidia.com, ljs@kernel.org, Liam.Howlett@oracle.com,
 akpm@linux-foundation.org, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 brauner@kernel.org, clm@fb.com, dev.jain@arm.com, dsterba@suse.com,
 jack@suse.cz, lance.yang@linux.dev, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
 npache@redhat.com, rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org,
 songliubraving@fb.com, surenb@google.com, vbabka@kernel.org,
 viro@zeniv.linux.org.uk
References: <DDFEC0C1-3ECF-41CC-9630-A4A742F2B842@nvidia.com>
 <20260330160942.173324-1-r@hev.cc> <acqinu8H5jo3Zw7b@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <acqinu8H5jo3Zw7b@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/30/26 18:19, Matthew Wilcox wrote:
> On Tue, Mar 31, 2026 at 12:09:42AM +0800, WANG Rui wrote:
>> Given the diversity of filesystems in use, each one requires dedicated
>> engineering effort to implement and validate large folio support, and
>> that assumes both sufficient resources and prioritization on the
>> filesystem side. Even after support lands, coverage across different
>> base page sizes and configurations may take additional time to mature.
>>
>> What I am really concerned about is the transition period: if filesystem
>> support is not yet broadly ready, while we have already removed the
>> fallback path, we may end up in a situation where PMD-sized mappings
>> become effectively unavailable on many systems for some time.
>>
>> This is not about the long-term direction, but about the timing and
>> practical readiness.
> 
> If we leave this fallback in place, we'll never get filesystems to move
> forward.  It's time to rip off this bandaid; they've got eight months
> before the next stable kernel.

I guess if we don't force them to work on it I guess this will never
happen. They shouldn't be holding our THP hacks we want to remove hostage.

-- 
Cheers,

David
