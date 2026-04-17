Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013067.outbound.protection.outlook.com [40.93.201.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE82224336D;
	Fri, 17 Apr 2026 02:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776391757; cv=fail; b=hNsnJyrEvBIyAsr+TxwftpFaBZB06vTOtwE4geNDoZXJfeSeL6Tywn9vu/hBhqAqL7hSguCOJEo6Q3QrY6DTr+fspjCMvElZOGDqlrnmKa8kJogfNhyYI3/sAQYkyNsz85a8kwSVpw9NtItQO42y8dayWogmy6Cyl0Z58gXdwvk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776391757; c=relaxed/simple;
	bh=SDj7xpOno3N7P9iZQlJdp4HDKOxiT1bAQp4gi/0FYac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MWasamm+SOtVvhQ7az5OGqDZeestlheo5YmMxKLU+lLah7SPAxWMBrXNaUAUb0Pc+J0V13NSMY/qHkEnyFIti274JP7jT/H+1KtIGpNVMeO27QrydWOizFg95ogPSmfk4vqZFAWOvUf/SaLFd/sTdbV6GFaGv86C9zuOw0YUiRI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RYpLmHdV; arc=fail smtp.client-ip=40.93.201.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RYpLmHdV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jPF0Gr7GLc0khua1GN7gyDw0L1ghGGn9e750buAcn55RM8ilYgIIZjuHIFnABNqTRGFwYw9F7pY0arjf3PgdIX1API8ved4a+jDlCtWwcvLuiBSN4TMKm1aqzWIdyWLVcdu0n0djpyeBS3fXvS4sR8X/bZX46JVRa2qfrE2C6U/lJyWJltW5TivzJY8Nd4DX73TToo4RGM63aj7Xewbq+CYuECQFx9rJt4Q3npkl1f65mnLIC+yYpK6MsfZr88AnqXF9aPqF0bw9Am4jkoKYc2R1BNOPtlkuZTmvroC4RhrZ+H8O3AnHlKRC5fZLnH8Zfj/zHBpRR1b4XzwiYRJi2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hV6RCifodAOigvYXlOey0D5Qr4Qq7j7sfSsz1qimd6E=;
 b=iU9nC3KvaogY4xtWAU31pxdGmVrDARExf4ZBPV5NsNywSMERlhp0IX+YcJWaxRJT/+oi7BLXkmKx9jjc6/uGpo291Of1xK3Plh8Z625JDKfu/ura+YOh3JAIIhAyFwa/6uu38abkA9/FL7Y5zXgf2PIOs+SxM2dv0Rwf1N4OwtDfS6Tzmu8GFngHQ0U8toXfAy6d8gVxS/HwsPSvPyfkUP3Sa4SliPrHpmfLMctlKb1myb4O3ooCq1CLfbYZfmug9DEZRlaWgbq4FJFdq5oB5AMZn7YrKv1ZkIjWI5wZH0WmsjqFETh+42nRUgBvGW7mVIJwAVtNK12RVvUw49BjNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hV6RCifodAOigvYXlOey0D5Qr4Qq7j7sfSsz1qimd6E=;
 b=RYpLmHdV6Fzk2xvfsNZ1evI1HMjHKX0Zmc+jLBUiN6znjpt4nvLnfNhNgPODKfUgk9Vun6c9R1P7ALe3sn5Bgh0atuc4sDaUkyYFnC0uqIqLHRliMdgq08pcGG+CcYG2hKUuXjDc4Mc9Onle1ojfymOGIzLVHeABlV8upLfYroNttsliMr0Q4yoWufDMFW6Dn3ScQ40ZG1B84hkDQQ81pZchCAwe+IDIdSjkN1vKOY3xVbOxrJa6zK2oin0rJOJxG6cWwliIusDabrHHSPBel0RHcGVzvxOlq/bbRJoWdhqiVUt6iEagsADgEclxkxZ15n8fdtJFgNxoncQIS/B+qA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW4PR12MB7165.namprd12.prod.outlook.com (2603:10b6:303:21b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Fri, 17 Apr
 2026 02:09:09 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9818.017; Fri, 17 Apr 2026
 02:09:08 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH 7.2 v2 02/12] mm/khugepaged: add folio dirty check after
 try_to_unmap_flush()
Date: Thu, 16 Apr 2026 22:09:05 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <C83282EC-F3C3-44FB-A8A4-615F67F9CEEC@nvidia.com>
In-Reply-To: <842D3AD2-32A0-41E1-AC09-08EC793EAF7F@nvidia.com>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-3-ziy@nvidia.com>
 <10aadfeb-86c6-47b2-b6ab-b86657aafb88@kernel.org>
 <842D3AD2-32A0-41E1-AC09-08EC793EAF7F@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0383.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::28) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW4PR12MB7165:EE_
X-MS-Office365-Filtering-Correlation-Id: d3e48bdf-11c1-4fd9-0747-08de9c264f51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7416014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	CNFKmMKJZfINIIRWxF+ZNk52ZmseP3yKvqYsTmKdDDI8MBm4RTWdhCqmAMECuqo8wlRBzmeQ47Ra7mHD12TbumeiFu418R1OFiHxKXn55aR1tBgPcRecrSGlrQ7w8mYWnM/Ia+7dKEmMRfArV8M3f+a9IrP1GE3j36XKqGoN+hYXq6I+f+OD0/rgxPvqfUOrFjcWYLixQeZuR3AKzFJ1QfO+q6CHSoGnIh99j2H4lD9kSLeMIK1sXwRBj49+XNLF6nD9c1zj9jfmdekrynVLwXzJETh88Y6+f+TCfT5x5oX0ZT27XR3Tui6reFXsP/vbbcalNHIUhWGaQpVWSZKRGSu1D+T6PDBBtyiLN5OZVWTzrsgXUonIQjnZx+s4z+FBVTSM0r4SToO1GBBPUiXkXDIJcaguVPiOw+SUpcyaDmrBMjftEw+0Navyrkq4b+2AZnFB/5wNTN/jKwOh28YuA8Ac7fc/LAOtFkQe2gTQfwlZl2RRxBhG1yklr7TPSszNv1QWoXOp1WSNTkefPlebC4AOvdGGy5ZYBqxdN2y6m16IZCVXRS3e+UxzXKlZJO+zpEg2e3BGA2Qz1E+YqMGuAlZFVpY8vGdT0rkBW9DTJYAqby8DoND8iKuW3QlfRIdQakHh1En+GB+RltUa7cOeQ8VxlgVdkc4llykV5wUx7cRXdyXXTmm9Q21Cudem8piK8Kf/j26WCRyAKz9t9XWYZq8ZQJ/t96I51ST8LjaENp8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lIaV24uWW4xv+O3h9TwXVp1lOLl7CeDFc61s2X/m3FM8PcveCk7WGUgEp4/T?=
 =?us-ascii?Q?0D1amvpABXdkglHBEH7cmxz+/qOkGpipmiBLPC413Y8rjYRanSro3EnsnQQN?=
 =?us-ascii?Q?IdIpeGHkOiXuS/+NJO/kv61uxzsdx7ON9p3mg1QJQVyWVTc7+wNDEksXJhXe?=
 =?us-ascii?Q?1BBBgkNJfb9/1EzbDjJrAMsSKk1OH6Rul71f4yu09K7CLkJxc9gS/WCsNy4w?=
 =?us-ascii?Q?8bpEC5dJiSoJk8FjrOUrpARx4wttZ2Znt2KqRB1eZW66voBGHCpq661exAgM?=
 =?us-ascii?Q?u70zjf+QR+lKcCXdOToFD7bb6B1me0b2wUr90JDGLMEqrzJVrjm8RA5CBwwq?=
 =?us-ascii?Q?9Uas5cf/VShwOtu8Qxv5y23UnapY/XYu4RNwu9p3XmAer1WkJOX/d1gj9pNY?=
 =?us-ascii?Q?5aXSJn+YUjH080YvFWThgDlix0zKhuyJbsVajyLidV4PiJY9+7txO7vzEeG0?=
 =?us-ascii?Q?f72eFmfrIhvTzZ4Y+FTEutnzFFfN8BT0EDlKhUd7LDKRiHe4wdGu3DCfedav?=
 =?us-ascii?Q?TgpZXLwPj1oH7pZd1ELtxXoJZkAp0l2ZYkf404Ha6I6T6aWIfjy1nssk9FZq?=
 =?us-ascii?Q?LYHHFghfhshK6ojF8QzJ5nx5CLshkQXoCyQVhtzaLx1fp/8EquGQux0GeFV2?=
 =?us-ascii?Q?9meCyrMseVdSKh//gqy1QGHxTbJ7p0IZQswiUbze0zdd35PzCJTALu0TyNkz?=
 =?us-ascii?Q?n5mQXynbk3ex59heLuFPQKYOksZ8CUqtHn3lxlz9ZJ+DPYx4fvSVGw+i1VoV?=
 =?us-ascii?Q?ufYCeBPq/HNJ/Z4U/wx7zN3kQl1WPaBIsClbwTnBRxj3/omcsgfL+eL6ecEi?=
 =?us-ascii?Q?OwqGS92uXB53JIQPz5S3YIcsJZXsMOrWS9AiCtf28W6IGYhxmDc4ski07Pl2?=
 =?us-ascii?Q?llQFaCkjnVEZfzM9p7Se+iqLDR6B0KUYkhl3JNRYdpkXt15SXSG2IY8fPSdm?=
 =?us-ascii?Q?lpTCs1s+f0ePsRI8pqZ5ts/QiodABHjkltSzrs6NuLcIVAFUIM+qvXj+tedL?=
 =?us-ascii?Q?Ge1C+LPT7OdpxGDUV/ftCsu+xz1WusSMATt6rBUneITBBrWAAG2Zm6TGZMCy?=
 =?us-ascii?Q?jBJGc5Hx44aOfyR7A+hhWh+YxQKgJpSLISUNlqvO1rNeHI9PO9Javzm1XePZ?=
 =?us-ascii?Q?prdRvmf6tIztWF6KtR3067GtW1Zp9M7B65Y2jsrbNCV1Q10zEgLa7P3hQKke?=
 =?us-ascii?Q?xwoyFMmrkvyjpabMPeGpV8oRmbhV+qADQexduDAtCFpU8aW8uphhZhNI3M1v?=
 =?us-ascii?Q?H9RMweu2XH+9wvBWvfyyvte4O5YWhZrIYoBWNflgboC+Kp7eGFzDn+CNR5xd?=
 =?us-ascii?Q?Lp6SD102tnDlNvf1AfhpMq8QOCwkcW4e0JirWbMOF6nxyGLldcsR+rpL/YkZ?=
 =?us-ascii?Q?RApZXvun7ub4iN9pzf0TGtzOsnzd3L7ZzhBYT9ssXx6VeRz3mIr/Xc2l737T?=
 =?us-ascii?Q?QR4CXrASZZFNPTthHl76wFpJzLiW1JOin5WXD2v80bGrgdlZlinDKpEI0KSf?=
 =?us-ascii?Q?ipjW34km4NAzQkzHCpWvjXhustVgNN0Ufy/cJ1TFAftPvV8Ri1cT1Tza6BcN?=
 =?us-ascii?Q?HZa8IoYLbK2PIcu3ByRFDUW453kPjjqNdw5rXLTI2VLhZFcsD9bkhy+azCLt?=
 =?us-ascii?Q?0ghECAypghv1AcAe0MmsGYwIOzk+oAcPF5f346jNjD6Bp46ktglgsPFFZEtT?=
 =?us-ascii?Q?+6RWBKeGw7E5Jpzl3CrqJhBEsFbF7UiZswObL3tY0iPkpxxi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3e48bdf-11c1-4fd9-0747-08de9c264f51
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2026 02:09:08.8122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y4fav+8fdYiwg1lWXkggn4AQfQ7LjC+tHDInr50rWZ5CCmnf293c0ncNQhfM6/6a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7165

On 14 Apr 2026, at 11:55, Zi Yan wrote:

> On 14 Apr 2026, at 6:38, David Hildenbrand (Arm) wrote:
>
>> On 4/13/26 21:20, Zi Yan wrote:
>>> This check ensures the correctness of collapse read-only THPs for FSe=
s
>>> after READ_ONLY_THP_FOR_FS is enabled by default for all FSes support=
ing
>>> PMD THP pagecache.
>>>
>>> READ_ONLY_THP_FOR_FS only supports read-only fd and uses mapping->nr_=
thps
>>> and inode->i_writecount to prevent any write to read-only to-be-colla=
psed
>>> folios. In upcoming commits, READ_ONLY_THP_FOR_FS will be removed and=
 the
>>> aforementioned mechanism will go away too. To ensure khugepaged funct=
ions
>>> as expected after the changes, rollback if any folio is dirty after
>>> try_to_unmap_flush() to , since a dirty folio means this read-only fo=
lio
>>> got some writes via mmap can happen between try_to_unmap() and
>>> try_to_unmap_flush() via cached TLB entries and khugepaged does not s=
upport
>>> collapse writable pagecache folios.
>>>
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>>  mm/khugepaged.c | 18 ++++++++++++++++++
>>>  1 file changed, 18 insertions(+)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index d2f0acd2dac2..ec609e53082e 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -2121,6 +2121,24 @@ static enum scan_result collapse_file(struct m=
m_struct *mm, unsigned long addr,
>>>  	 */
>>>  	try_to_unmap_flush();
>>>
>>> +	/*
>>> +	 * At this point, all folios are locked, unmapped, and all cached
>>> +	 * mappings in TLBs are flushed. No one else is able to write to th=
ese
>>> +	 * folios, since
>>> +	 * 1. writes via FS ops require folio locks (see write_begin_get_fo=
lio());
>>> +	 * 2. writes via mmap require taking a fault and locking folio lock=
s.
>>> +	 *
>>
>> maybe simplify to "folios, since that would require taking the folio l=
ock first."
>
> Sure.
>
>>
>>> +	 * khugepaged only works for read-only fd, make sure all folios are=

>>> +	 * clean, since writes via mmap can happen between try_to_unmap() a=
nd
>>> +	 * try_to_unmap_flush() via cached TLB entries.
>>
>>
>> IIRC, after successful try_to_unmap() the PTE dirty bit would be synce=
d to the
>> folio. That's what you care about, not about any stale TLB entries.
>
> Right. I missed the PTE dirty bit to folio dirtiness part.
>
>>
>> The important part is that the
>>
>> So can't we simply test for dirty folios after the refcount check (whe=
re
>> we made sure the folio is no longer mapped)?
>>
>
> I think so.

After more thoughts, this still works but the reasoning is more complicat=
ed.

After try_to_unmap(), PTE dirty bit is transferred to folio dirty flag if=
 exists.
The code bails out if the folio is dirty. A clean folio means the removed=

PTEs were clean, thus TLB entries caching these PTEs have dirty bit not s=
et.
Any write to the folio after try_to_unmap() causes a page table walk and
a page fault due to invalid PTEs, and they cannot proceed since collapse_=
file()
is holding the folio lock. As a result, we can skip marking folio dirty
after the collapse.

If we allow a dirty folio after try_to_unmap(), we need to mark the folio=
 dirty
after the collapse like shmem. And a potential optimization is that we on=
ly
mark the after-collapse folio dirty if any old folio is dirty after try_t=
o_unmap().

>
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index b2ac28ddd480..920e16067134 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -2089,6 +2089,14 @@ static enum scan_result collapse_file(struct mm=
_struct *mm, unsigned long addr,
>>                         goto out_unlock;
>>                 }
>>
>> +               /* ... */
>> +               if (!is_shmem && folio_test_dirty(folio)) {
>> +                       result =3D SCAN_PAGE_DIRTY_OR_WRITEBACK;
>> +                       xas_unlock_irq(&xas);
>> +                       folio_putback_lru(folio);
>> +                       goto out_unlock;
>> +               }
>> +
>>                 /*
>>                  * Accumulate the folios that are being collapsed.
>>
>>
>> I guess we don't have to recheck folio_test_writeback() ?
>
> Right, writeback needs to take folio lock and we are holding it, so
> others can only dirty the folio but are not able to initiate write back=
s.
>
> Best Regards,
> Yan, Zi


--
Best Regards,
Yan, Zi
