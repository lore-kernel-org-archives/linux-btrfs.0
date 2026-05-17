Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012020.outbound.protection.outlook.com [40.107.200.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B01405C57;
	Sun, 17 May 2026 07:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779002972; cv=fail; b=dMrSLzRtJnbJcYVRWwy7JEtiXsYMXD7usdSf5c0OJoAUwWY7+KblsGbSYq74AWavof46d9AxLESMWw1ZXe6d6dOkroqGrqk7zi2xXOLqYawMWXhOg5dPsmTvRwLtyXt1PqfskkW5z1rLLkQ/KlNutGlnM9NOFGWcu5654e3Qlco=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779002972; c=relaxed/simple;
	bh=nR/BkSXxfUNeKKTb5nO8p2XrK/UkXuEK0/8JJBzCqaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lPBq2Onh6GhCZW3jvI2AXiRDoG1b9zQj5e45OwHHPnJJqwzHtchfS5cO/4s7Dm53m7keelQCxWJEaoa6foInSXWM617SPnhYkNKC/E2HJ7+IblHbfj1jDWCkjm3wX4iCtWIRXyYGAjkJ1FEVGePUiap6fPQjQZRu9NorqTVcuaA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=F6eddAlA; arc=fail smtp.client-ip=40.107.200.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="F6eddAlA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HftbYr8JNZcJe8qZB2bSCD4P54E4TQuHfjlBsCL0fNtJRPptgZ8KTETCBSpHGvfIZj3G7I0sL+c2mo2coN/ctGJHpEeQ2FcZ13tag+E0FnycfN/FzzleIL0H2DneVkNaKKVExnvxEumFNEEySwk1iuSa9d6AVQp39Bk0j8i556p+TSp1gV7J5EVFw1kDGaGwvLF2dpfvB6eo+p3xuv3ylie7TBtTeBjltOgQiNvGnSd9L6iLL0OtwXQ171YwGQxy5orzkP+tmcAiWJVENrvnJT7A7Ygi5a2c6/XnkD6dXNCDE8PV6KiZJPkWPPy9ZwamRfQpff7NPFEGpDt71GP0Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uoYgfXYD4ddiFseOqj78hJ26jNv40lh2DfNw03bugjg=;
 b=eM+3wxILNLo7rUohrRxZhHnSAQ58oop80qXMaLsn/nuYSnHFGwRC97W4O+RuK8CbfN5nKfSLyjWJIyAUn7HPE5ei9XGkbCwaoVdqcinI8+YnmTbbUW3lyAp2vXYnAq+gK0DaX+Mh+70x99rM/9Sp7msfG7uY9Ub5KA+2/WE/1KQNGj5hoIpAM0r7lrieuIeCnTzHzXjukRRtygPFIOKCDbwkYyVecGwmyhQfIyOMPY4u9u+9IiE7tpTL0Ed7FnPPLpQNm7Jo7W29WKm3Czk7uYuS4od2TEFnx3NTzxYuO70uSbAHDuyMSls/fQNaxLqCjuUp9G3D8guIfMRA84AWMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uoYgfXYD4ddiFseOqj78hJ26jNv40lh2DfNw03bugjg=;
 b=F6eddAlAcSRXHTzfGmHFdd/SFQrxygb9nCHNQHQ7pGAYlgqjFjVdC4JRUxCCZHZCfsw11sERITbc/6JjE/Tim745KB/bu578L/s6Q56FekB34RvexUy1s7aUn6dLUgGWXW7YhTrehWZJzYo3fagvQM+aq5AuDDoOHiIAuDpeOT+nKxe+kyNPiFOmBZDp7Y6zOWch0Oke1yRVqnbOJOU6el8nQaSSSNO829/X59TzCgBNbI23ms2jo9aG5dlKjOwaszysGjWJ6XbYcAQQA/CDZbkiXpF3t53ugYVXdZdtjEH7wFZXQ3cTyd6ihXX66SNk8TMIIAsUGmPMh6CBkZZN8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY1PR12MB9674.namprd12.prod.outlook.com (2603:10b6:930:106::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.18; Sun, 17 May 2026 07:29:26 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Sun, 17 May 2026
 07:29:26 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 13/14] mm/khugepaged: enable clean pagecache folio
 collapse for writable files
Date: Sun, 17 May 2026 15:29:10 +0800
X-Mailer: MailMate (2.0r6292)
Message-ID: <FA92C9E5-1339-4EAE-B2CA-5D533CF6DC2E@nvidia.com>
In-Reply-To: <b8a3c3eb-f241-40fe-9121-4ae5a1097807@kernel.org>
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429153538.727855-9-ziy@nvidia.com>
 <b8a3c3eb-f241-40fe-9121-4ae5a1097807@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR05CA0054.namprd05.prod.outlook.com
 (2603:10b6:208:236::23) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY1PR12MB9674:EE_
X-MS-Office365-Filtering-Correlation-Id: ed0301fe-10d2-4479-4c9a-08deb3e6065b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|10070799003|376014|7416014|1800799024|18002099003|22082099003|56012099003|4143699003|11063799003;
X-Microsoft-Antispam-Message-Info:
	tvtjL/Vszk5aQoQx83NoKKq+cJdqfOm3axYI4LGpHNdZPZPBv7ZImTz1JBgGGio9kNUtqzIZGHz7u0SYytoVNWjSCSJulpE1uX11hBKH8f0RvRv1wJayiv7w8QgsLOFmAyB0lT2YwKNwf/sx/cTVJsQ8ziBjR8aUblxbh3uPs5wlmOPBOZLFhaZy+qqu0UQGlYOQDq66AVS1JBgDIuqgtgzVzZRQWsXjzPpFJIxFcjGMo+RlBTs5474C4tPbr0VA2snaceyiR6+CVP0/kko8aK+RUN4cJChxnUNgI+/vENoHIuFBehVPmX+c9Way9eYh7HV/VJt/ypNOM0V2UG9CFYzNA+MnrmAYpzGrX/mluJxo9cofs3g8gAcGktRSJrQh9k6zuSbhdVjkUt/rd7MUBTqCTAYB9J0lXShQL0cf3jBALEgFPrHWpzCjroOrhORhtM6IpaqKCZ47mWhAYGqiLMjqv7ZvCGpy3FZykhE8UAU/2xnzcWb/hfHY9cN1QGpsZKZN81C1aNLzYQNllUUOpZ/a2nxwyKe5QLmN02VoPsp97phSVYIW5vG8KY+EgncEH+iF63nbS9rF6ZfziSNre2Ms7JRuBBPHDsRPyLVcAwa04p+Reu2H5SDlZBP4chIMd2BDgnpv/1BeJDvCv6uwja/75MM5KqugJLM9DMf9zC8EI/VWvHlvayhhk3P8hPjk
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(376014)(7416014)(1800799024)(18002099003)(22082099003)(56012099003)(4143699003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mtjCje+XkxaDSVCxDVD+nSYln3cZJci5ICqZZ23dUjpxZPhAB3257qXaXDsW?=
 =?us-ascii?Q?JbedZbd3yjkzxuN0AE94erJ/2iMaO4WrMphkjtIhA+J4lW00AO0qbv0rxwny?=
 =?us-ascii?Q?606cvgshcmVL+cjDQ+PIK2jt05+HhPYrWWytPhiWrq7FGbhWtYSGr8WRTjVb?=
 =?us-ascii?Q?kB51eDcHyHOvqpYMDWJ88ORdP7y8UNeEmIW+Ox+T+6cdOg0Kvpaf0WjZX1HJ?=
 =?us-ascii?Q?uq1EEbXxPl8pqUW6eqVsKRtzVZejNCabf0a6xRhZtf86D5+FsA/aJq5W0f9w?=
 =?us-ascii?Q?Wlo0/d10KlXIwLrKiSfjrRMLJctxVRWqW6qxJj+XAYPdRl52z1/LUg+RwaUv?=
 =?us-ascii?Q?upQrfigqWS8v1GVwrn1/iyWLPW47Rxdym17sNCN2EXviA6c04dU9OIdsRfYp?=
 =?us-ascii?Q?xEbjkNDgB7PS8upr8B7iK5EUX4/7BB66QIDYvB4bBWrduPJIU3pqdBYOS5vx?=
 =?us-ascii?Q?C3opSQL1mnbKawMPV77fvpPlU13r4qbP4wcJHKSlZN8DMZbVmyE1eQEH8ySw?=
 =?us-ascii?Q?RfvGCdt3jm0YfHhLwMOfpsMULhLPq3VowfwNXhgJYN1rrtnU4nOhOl2KPjCb?=
 =?us-ascii?Q?XQtF/r38qbIRhPLz0qBgfdXNUzhdUYhdf2ozVoVJ4zV/coO1J+mFO7t50lFU?=
 =?us-ascii?Q?MXJHlwjhHTl8RdVk2RZvgytnXVcc9Q/+nOrbTme8SIgGMvO9WQVn9Ty0UwsU?=
 =?us-ascii?Q?n9DSrXh699RpnRIjav7fUv1HiuFT01/voOT0kPa4WFDlZp4B2AeswDkhBV3j?=
 =?us-ascii?Q?Uw1KqSLB7X2SbC+6NM1/t6gPPshwS51hRITggIrRfWsYaxXmft44HpS4DrJO?=
 =?us-ascii?Q?6q+jO0zFWVM5inFkS/cDzYM1KY4E6mSnewXwaWy81DEO2hOCxTetyep5Cw+L?=
 =?us-ascii?Q?hg9dCEjPh5t3SEjBAhJl4OujXaT5NCZ9En7Kvu/YQ7XxqRRSKiuKkjmOlI9r?=
 =?us-ascii?Q?C9BrpVoEDNMs5m+8BsfJCmZhZPCQ/gMVcfI7Z8jxAr+9pNfh+02bylL6nOHn?=
 =?us-ascii?Q?nLUleBSyaDTgZLcJcfA3UlrV6mHC373hEZjT4dJ3bSEbJ2qdJrWyPRTRGZMF?=
 =?us-ascii?Q?MXSWrmLCNm+nkdCxVb3yJTnO0+pw0x1QGJFsBKhNqDPDleyAxJh06P7pCLEt?=
 =?us-ascii?Q?CrPOSqjd51woSF4FTqvMz1eseKajR1QaGF2lvrJg1jK8NiJMrLalj+H4bTBg?=
 =?us-ascii?Q?WZ6e6+L3j8sa4FuuGOABvVoUAIUd/D92rGLuec2e/+L8c8WetpKyr+CmuOwo?=
 =?us-ascii?Q?1SxZ/G1F0tbOrtRycdRox3ame/rfFqFmRpSt+jLa8lSWrKPEQ3C4CcAqpXo5?=
 =?us-ascii?Q?SGrFOuJPCypUHAgu0KMpIzEszqgL/BIbItYWwbQ+vaPAfP3LTRF0af9mMYiv?=
 =?us-ascii?Q?zhUKVFxLq7aoutuIhWwTZRVcUw3S4Ij0kMMj6l/HmapptWHIEzDoSJQXum7j?=
 =?us-ascii?Q?xwFnJ6qgJwuShG5nMmi/hm48KycTKXVzYNeVTVRa0ukVzqRodfoqKcNJYTnW?=
 =?us-ascii?Q?VwP6gtWCPLXBDZSaJjrvSxpGNiaqbZsBhVoAmnYdU3WkrhXnMsBFgOOCUI8A?=
 =?us-ascii?Q?vWCQbHjb43op09qhdLladl1OfvsVGC05d8YKnFOjNGijdmzXF61La0Zn27H6?=
 =?us-ascii?Q?UydKbu+s2/2CSs3fkP1U7KFF43wy/Brliz/jCCQXKs5kw+7pzUBGwlMssmpF?=
 =?us-ascii?Q?b8PAERsrEVnnAdStGQ0PYP8xrMpPi8uJWDmwXiHNMpQ5z6Au4EkEyjBllEo0?=
 =?us-ascii?Q?FAAos+Y6HUHbwN/k0TodiEHmvOMORiwv7oDtspht5WRhtuFGLnfI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed0301fe-10d2-4479-4c9a-08deb3e6065b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2026 07:29:26.4702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Y/G1a14VCOgHRxtb38CqVi745uJki4CWA+Z7+5g27OtI+X2RKNuz1Xdg1y6T8D9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9674

On 9 May 2026, at 4:13, David Hildenbrand (Arm) wrote:

> On 4/29/26 17:35, Zi Yan wrote:
>> collapse_file() is capable of collapsing pagecache folios from writabl=
e
>> files to PMD folios. Now enable clean pagecache folio collapse in addi=
tion
>> to read-only pagecache folio collapse by removing the
>> inode_is_open_for_write() from file_thp_enabled() and only performing
>> filemap_flush() if the file is read-only.
>>
>> This means userspace needs to explicitly flush the content of pagecach=
e
>> folios before khugepaged can collapse the folios, or use
>> madvise(MADV_COLLAPSE), which does the flush in the retry. The reason =
is
>> that blindly enabling dirty pagecache folio from writable files collap=
se
>> makes khugepaged flush these folios all the time. It is undesirable to=

>> cause system level pagecache flushes.
>>
>> To properly support dirty pagecache folio collapse, filemap_flush() ne=
eds
>> to be avoided. Potentially, merging associated buffer instead of dropp=
ing
>> it with filemap_release_folio() might be needed.
>>
>> NOTE: this breaks khugepaged selftests for writable file pagecache
>> collapse, which is set to fail all the time. The next commit fix it.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>  mm/huge_memory.c | 2 +-
>>  mm/khugepaged.c  | 9 ++++++++-
>>  2 files changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 9b3abb98a7e51..e1e9d59db6e70 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -97,7 +97,7 @@ static inline bool file_thp_enabled(struct vm_area_s=
truct *vma)
>>  	if (!mapping_pmd_folio_support(vma->vm_file->f_mapping))
>>  		return false;
>>
>> -	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
>> +	return S_ISREG(inode->i_mode);
>>  }
>>
>>  /* If returns true, we are unable to access the VMA's folios. */
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 1ee15b48962a3..fb7ff643973cc 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -2345,7 +2345,14 @@ static enum scan_result collapse_file(struct mm=
_struct *mm, unsigned long addr,
>>  				 * forcing writeback in loop.
>>  				 */
>>  				xas_unlock_irq(&xas);
>> -				filemap_flush(mapping);
>> +				/*
>> +				 * Only flush for read-only files. Writable
>> +				 * files can have their folios dirty at any
>> +				 * time; blindly flushing them would cause
>> +				 * undesirable system-wide writeback.
>> +				 */
>
> That comment should really be merged in the comment above.
>
> Also, there we say "khugepaged only works on read-only fd" ... which is=
 now just
> wrong?
>
> Please revise that whole comment as you incorporate your comment.
Sure.

>
> Apart from that I guess this is fine ... or we'll learn rather quickly,=
 haha.

:)

Best Regards,
Yan, Zi
