Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E918D330D28;
	Tue, 14 Apr 2026 11:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776164534; cv=none; b=SBANktJmbVleqjnkhMhYyRSHJOJ8v/SjXfW3NRPH1tz2XLJBJJ7U4oZ3lCslzOKq+v4cEO3BHrTb5K8JiFpaqh5kgnvuBHZAG3ehqCftPc0MiIayqmqfic2Q8+RU/CyBQB0IjILDDYwNQTiegGlOZW9lc6ZGZzjomOFlKpKkTgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776164534; c=relaxed/simple;
	bh=3pzMZMfMkr/IcuqUWA3o3NMItdA227VUY7ANJl/0BFs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S1gKKqeaRNmpGzTnaEea2VmIglQTEY3LNrhits8YYJ1PFfOg+YygkidPNL+SyrZ4NV/ZMiERsC5hDUhNGHPJLhPYGvP7LdiKW7DT2uNDhCwIky6VxmMDAe1XljhmqI2j9X9bhJ6k+954QCOjXwacHnr5+qNaKM6rLz3VjD4LaLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NfrtkX74; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NfrtkX74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A6DC19425;
	Tue, 14 Apr 2026 11:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776164533;
	bh=3pzMZMfMkr/IcuqUWA3o3NMItdA227VUY7ANJl/0BFs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NfrtkX74P0KKHje61gprd/J6K00bTdrDkBqxS4bMicEwRhHRqJmr/MIBHFi059xyZ
	 9Nn4IbiL3DtTnBSsdyPa1YJJUsjrCw2R6T3DuulETl6gzTFaD1Y0VyI/ovgpryfF/o
	 kHLaibZ8LVCz6RgHsz3MlnqTYu6sKe3JWouz24qxN9ypDUqdMKi8Y8l39kaWMZTcdt
	 lhrJ6+kunkGflPirnUc0V6A1U/coHeRoDiTCn0Tnb/jqvzq/OUDrMWxlNxjEyhHbG+
	 HxAS4YEy/mcvYjZu6np5TrwFbHoST+htmjVEHLaeJWLafcixeHpyEjgpPQk5EOgcZu
	 a2s9DurQZtt8A==
Message-ID: <a4d477a8-71d8-4219-9cb3-153f2c01e184@kernel.org>
Date: Tue, 14 Apr 2026 13:02:02 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 05/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check in hugepage_pmd_enabled()
To: Zi Yan <ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-6-ziy@nvidia.com>
 <ad1TMjF1L3usYIC5@casper.infradead.org>
 <05F00072-7E06-47C9-BC26-FE3736F557FC@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <05F00072-7E06-47C9-BC26-FE3736F557FC@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/13/26 22:42, Zi Yan wrote:
> On 13 Apr 2026, at 16:33, Matthew Wilcox wrote:
> 
>> On Mon, Apr 13, 2026 at 03:20:23PM -0400, Zi Yan wrote:
>>> After READ_ONLY_THP_FOR_FS Kconfig is removed, this check becomes dead
>>> code.
>>>
>>> This changes hugepage_pmd_enabled() semantics. Previously, with
>>> READ_ONLY_THP_FOR_FS enabled, hugepage_pmd_enabled() returned true whenever
>>> /sys/kernel/mm/transparent_hugepage/enabled was set to "always" or
>>> "madvise".
>>>
>>> After this change, hugepage_pmd_enabled() is governed only by the anon and
>>> shmem PMD THP controls. As a result, khugepaged collapse for file-backed
>>> folios no longer runs unconditionally under the top-level THP setting, and
>>> now depends on the anon/shmem PMD configuration.
>>
>> This seems like it'll turn off khugepaged too easily.  I would have
>> thought we'd want:
>>
>> -	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>> -	    hugepage_global_enabled())
>> +	if (hugepage_global_enabled())
>>  		return true;
>

I assume such a change should come before patch #4, as it seems to affect
the functionality that depended on CONFIG_READ_ONLY_THP_FOR_FS.
 
> I thought about this, but it means khugepaged is turned on regardless of
> anon and shmem configs. I tend to think the original code was a bug,
> since enabling CONFIG_READ_ONLY_THP_FOR_FS would enable khugepaged all
> the time.

There might be some FS mapping to collapse? So that makes sense to
some degree.

I really don't like the side-effects of "/sys/kernel/mm/transparent_hugepage/enabled".
Like, enabling khugepaged+PMD for files.

> 
>>
>> ... or maybe this whole thing could be simplified?
> 
> Alternatives could be:
> 1. to add a file-backed khhugepaged config, but another sysfs?

Maybe that would be the time to decouple file THP logic from
hugepage_global_enabled()/hugepage_global_always().

In particular, as pagecache folio allocation doesn't really care about __thp_vma_allowable_orders() IIRC.

I'm thinking about something like the following:

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b2a6060b3c20..fb3a4fd84fe0 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -184,15 +184,6 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
                                                   forced_collapse);
 
        if (!vma_is_anonymous(vma)) {
-               /*
-                * Enforce THP collapse requirements as necessary. Anonymous vmas
-                * were already handled in thp_vma_allowable_orders().
-                */
-               if (!forced_collapse &&
-                   (!hugepage_global_enabled() || (!(vm_flags & VM_HUGEPAGE) &&
-                                                   !hugepage_global_always())))
-                       return 0;
-
                /*
                 * Trust that ->huge_fault() handlers know what they are doing
                 * in fault path.

Then, we might indeed just want a khugepaged toggle whether to enable it at
all in files. (or just a toggle to disable khugeapged entirely?)

-- 
Cheers,

David
