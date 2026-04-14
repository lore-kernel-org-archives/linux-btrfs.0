Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011066.outbound.protection.outlook.com [52.101.62.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDA52BE03B;
	Tue, 14 Apr 2026 15:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776182158; cv=fail; b=osH8l6M4AAZco/EOyloo+l5nOC/0pPoRuVep21rLz+zsSVcfqbblqagVdWHtYc9VOfm6lZ2T8oSTOR1nfyFpfESD0RvF4h2ixMhx90vMNjC/GnpjNMhELQbPysl8efuxtuLX1u/65SlHGRpFvR2xjyFXp/4M4zzZZyMlI4P+jWI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776182158; c=relaxed/simple;
	bh=uTA48HIHnHpS8MtaQaXj4f6XeCsNu1HOtfyOsSw9CYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iCIYl86YqeJvPWaiuvELkv5opMjqMCa+PfaAeQ8lJRf3fRRx1oX9Z3CoZWA2SXqeuRHLVNRxowQoMVBBqdJtYMHcxzUPcYB1TPpAr4HPcCWfUBBh6z+J7rE0DMP9Ev4tfV3cMl4mkH/64a/ij4PiIieE3FZSYVXuWvcpY6hmX/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=H2zdk5/n; arc=fail smtp.client-ip=52.101.62.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="H2zdk5/n"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bEs55kLAY3zLecyQEZZhBUeNDG1QP17LtZgePfZmD+oTKFADJ6Mdw/qAG+YL5YcEl+AJoUxiiVyWYTuoqXg7zpcR9o4CoQm5p7Y/JRfq7QwiNIO9+d8IboRxMwknOwxL7bEjdlInV52FGK6kOVV8fe8sBJAIF3QYpWIImlJlGkF1Dcjya1MFEB30IQe+LP1luY7Oe2a/ZfPDP/CtIC+7KLCmikZs6U+e89UKQGJEOa5VRzjW/w5dIQGbLwCUEqZD2r9n6iZ077oTrcwH6Gb2ChebhesXTxJO7XqrLiJoAK5eSBLscriflbc5Cm9qBZ/7UAYPVjBiYmMzlESL6T60Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GkSMBL7JpEe1VpPaULzELlXhgxOBXeHBmEOZyeMlB74=;
 b=Uf8uTelq0+GpHSMuQW2xC+NknpEsMDimZ7FesGciCyfI0heajpjPSkwb58EvCIuibEZrdKEbINtX629nem2V6CQQebmKosPC1HmKlFpTHdOSJZPnb72+L5LocgS/cTmPw62cvPAgaP5xdGAGJQXrUvZ7BxMfbULN4WL8wMWD02thvX04wpol3/B/5CmqlkToqJjOmgtWJrMQUN/32dhyCvSKHw7FVV3o6fW8PTjM7VOw/fbnMwEpvMGioOs6spTJGVcZ1eJgaI9NyoWjqWGzTYGrtNTdOhzZPNaVSj9qROfsuMA5R5bkUmSvAIfCqbcHGRJqGpc6aOgWcT+B6R9+YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GkSMBL7JpEe1VpPaULzELlXhgxOBXeHBmEOZyeMlB74=;
 b=H2zdk5/niV2iGCrVO/lLvPZZrxiQfEqJNhftvQEO87CB+ZiJAcevv0LmfmKMVHJgonF+Av1MTtsvVRpZ49/eeJWNDIaqgJhYCIP4Tz3tp9aYAd7N5N5MtVUE2Up9RNsXtHb9tOfhLAtv5ZcPBthKoZbTudbtinkikQFwbwzAcWBWIX17A8JId9CJ13maaJcOffpe2zOqSvUcEB0SoFqUXyLGncpEeUVn8cVdYDr7kQ3epQPWkuuOQj8KsdYJDTFZW3XYMsUDoEsxQyCBeGlWOXjQ7/cRrEZBwNwOdwLUuk23CxWW43SS1/0kWdKk2d9zpKzoPEr///GcgX105+FQ0A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB6639.namprd12.prod.outlook.com (2603:10b6:8:be::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.20; Tue, 14 Apr 2026 15:55:45 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Tue, 14 Apr 2026
 15:55:45 +0000
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
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v2 02/12] mm/khugepaged: add folio dirty check after
 try_to_unmap_flush()
Date: Tue, 14 Apr 2026 11:55:42 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <842D3AD2-32A0-41E1-AC09-08EC793EAF7F@nvidia.com>
In-Reply-To: <10aadfeb-86c6-47b2-b6ab-b86657aafb88@kernel.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-3-ziy@nvidia.com>
 <10aadfeb-86c6-47b2-b6ab-b86657aafb88@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR05CA0045.namprd05.prod.outlook.com
 (2603:10b6:208:236::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB6639:EE_
X-MS-Office365-Filtering-Correlation-Id: bef77dde-6e37-4836-ba1c-08de9a3e4a1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Lc/d+gAbw52wQB5V01WwIz6mnAGOpjSRaWIQHTpIRpYqRygMm/PDfI7RPiCKN9BsN9kADF3jDEN+0LB5//ZNbFYTrxXslKW6iOGMimCQ92to2PoJde/iFr1pTjA85+0ouZdlQ24GI3pds1af3K2XQthu0PgkCP/EXj77yJgh67E808kZ/lxcCi++s6PkQ7W3TIJoBrtrNV9JVQP+uE0TShIz/+9garo8z0yG56ygUnr1bD1hfJI5ERB9yXZFQDyscHc88ZOptZ7Vk4NJ8lCfbk6jhqi0+2pFxDq0ePlwN2mYeYNJt2fuZ/tsuQPurosy5lWqgRT5nnIyIVKbX9NstahQH58b7iSz/WTUzxagV41a92HYXycfgLuJxPdA/+/G/JmLNYLe9psrnRjEu8ox2/XRN08M5ThgZVyK03cSQLcvsryz3sLDDtdy1lEbEgV8BhubRn7k9hV5L1RlraNig8gkwv2ueq+tqdd7pCXD/PX9cymZkHTN5/IBXz0909kO4uv+clhpJHk1Eb0YWAbMYuCrE/wM53HuuV8QmU6GOLiVpRzufSqo16grwbP9E4/PmAs7RRBU9DHsLOvltviC1X7MiKJh07sh/VwBf7R2qY78AFQzoPzBx65HGMXyymajYJ98Hswre/q2K0Dvlo+q98KWP/08EHJS8CPm4zATiMJoINf20k0OTlxLSMmabavnCZZV/HwY+QgfHACdYyFZpvyDz7K54npWUkwDJ5DzlBI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?occdMKOa21HKl4a+lLJ0cPZhbQFhypL0z1sZYpd3jZbDKfwLSjg1qTEWzo2Q?=
 =?us-ascii?Q?+u86tK706R/3uPdqUeNs4cWMcf1/r6RyW7DPC28bFP9q2emeBeRJCnORd3tg?=
 =?us-ascii?Q?t4j69blD6yEqTp3bBWfRltZWSrrmevZbaO3NiQzHQU6y3vcQSh1L8gkQvXq9?=
 =?us-ascii?Q?UXXYgI416BYigMOOUNOV0k0IcWkQw3blZCvoJPmM5kOhjd4YMiwO82RBY9gE?=
 =?us-ascii?Q?SIMj+rFvGLaY/+ACconf9E15JEscfqfwf3bGDIKAo0sSOnbUnvYVzCIhvtG/?=
 =?us-ascii?Q?26l+U7tUT0Zkdr0a1mP0DSszDAZseCkkqbQlZjyZXenNPIHDsykHMunOeNtU?=
 =?us-ascii?Q?sf9wCdKAA0P35Krsfuu67ZQQ7pCCd7xrnm+xl2VR9eJRxT4r73Rhhz+pTPzR?=
 =?us-ascii?Q?ZTWoWs+dDIKKtvtZCB3we3GopJ8KhUA65YQw7TJkjn2Bht5AmPhEgU13HbXc?=
 =?us-ascii?Q?4QPUjeDJ7TiBmLuTNSIgCWnL2/IQqEGdD0g91NrJvKbf+SW871GH8Qh/+OO5?=
 =?us-ascii?Q?02mJUz3dGnOEBg3EfQ9RGxVd+O/yNmSQAARoVi9cRyxri17rQLumRb1FLPXJ?=
 =?us-ascii?Q?WxxPAFMDGt5EO+DLTtV41TEJuLnd8O1XulBd9j1CnaOfhWm+MRSroEAXKLSK?=
 =?us-ascii?Q?GC4HC8557Dv14mj8viZY6zlss+cf1YvgFTu6v4iB8XOMjssMWcssCeVaB5Bk?=
 =?us-ascii?Q?wZSr6OxWAgs9YP8R2Gb6diu5O+NWGH6dyEXSkxVtSf9s8jcHBvIJg/lUclh1?=
 =?us-ascii?Q?FeA+ThqP7HO/3dfTS/2jc5rs5oyAV730RozOeVhq7Aa4qDPwnqSnL3q+T7n6?=
 =?us-ascii?Q?PD+IOvV2anCfnHh1j0pt1GDpd5V9p4lLn9AyT2dFeB6bAgB/BLTyxekhzOnT?=
 =?us-ascii?Q?B7OO+V2Afv+WM64bUM4wVEMtCR7qaPwW+G7109VwkzpfsRKSYO6wyP9S89hH?=
 =?us-ascii?Q?qtRnqXpidotRsmgr2HUjCeEmkxE5A1VQSwu5zJdP076e/5xFS6s5r2HGnu/L?=
 =?us-ascii?Q?z8DANmsCpWRL5yO0q/S9hY8Ftr/CF/hTd6Uz20z4oAzX21zYhEpZcusKrzzO?=
 =?us-ascii?Q?iKbXJmYIfmkmwVbx1Poa633v+nkBDs5iXSnFFp4xIM4XxTF4DxX64vwz6awk?=
 =?us-ascii?Q?BsvWzk62+m/qrz6T8W5XChxa5NILFKdORmwxPK1mXn7EYLnqyd7BAnEZFo/c?=
 =?us-ascii?Q?KdF3cm4P6bnnkiDkxuY3GT8I3TZnaGZzb8+nxL0iToOz9GEEuJH4pBWGyL23?=
 =?us-ascii?Q?xnjkbWLfMX7zYO2iROQbkBjx/XJegy06e3x75q19o8V/DEmNjbGwlhTxYMTM?=
 =?us-ascii?Q?vH+zVKv6QMRTu3pSVyVcnHM3JOq8hTa4NmzVqJqc7pA1JRWz6WBw7pPaWhKq?=
 =?us-ascii?Q?/2Q0oImMX8xFw28eNaPHoXpBiYzlMQs+Y1Bjd49V9YD+sBMJgBvjAKdhlJs6?=
 =?us-ascii?Q?QDWHEESQ5rV2EHOozlJPQGeE+b1y84WLonYNSI7tH6aGDHhOZGRLkmDkJ+6R?=
 =?us-ascii?Q?KdtCzD9e0y+8KRHOw7EKDxjU4MFE+5URUYZncJb8Es49EbuhFWUNi0jM37PV?=
 =?us-ascii?Q?Idfewt8s5cEZO7CQ0ppXVz1k/z3qwX9siz6zUgd/hgWXO3HPRAnAP9gNNgsb?=
 =?us-ascii?Q?wbtH8iSuZOpHhax2igf1/OXqwBYOqmFKupd/w/JeluzzQZOQyGRL67O7Mnu1?=
 =?us-ascii?Q?1UMXZRigZNuR43YfE5Nvag4wTWFJ0kUYZKmbQT3pdgJYqb72HQGElRsEc1kD?=
 =?us-ascii?Q?tyaHLBY7DQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bef77dde-6e37-4836-ba1c-08de9a3e4a1d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 15:55:45.6889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YtvfAyH65cuG2Ss+rxQG5OTk2umc8BrxULh5sZ2/7zfG6aIutaiiOs3TNDdwx8MA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6639

On 14 Apr 2026, at 6:38, David Hildenbrand (Arm) wrote:

> On 4/13/26 21:20, Zi Yan wrote:
>> This check ensures the correctness of collapse read-only THPs for FSes=

>> after READ_ONLY_THP_FOR_FS is enabled by default for all FSes supporti=
ng
>> PMD THP pagecache.
>>
>> READ_ONLY_THP_FOR_FS only supports read-only fd and uses mapping->nr_t=
hps
>> and inode->i_writecount to prevent any write to read-only to-be-collap=
sed
>> folios. In upcoming commits, READ_ONLY_THP_FOR_FS will be removed and =
the
>> aforementioned mechanism will go away too. To ensure khugepaged functi=
ons
>> as expected after the changes, rollback if any folio is dirty after
>> try_to_unmap_flush() to , since a dirty folio means this read-only fol=
io
>> got some writes via mmap can happen between try_to_unmap() and
>> try_to_unmap_flush() via cached TLB entries and khugepaged does not su=
pport
>> collapse writable pagecache folios.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>  mm/khugepaged.c | 18 ++++++++++++++++++
>>  1 file changed, 18 insertions(+)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index d2f0acd2dac2..ec609e53082e 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -2121,6 +2121,24 @@ static enum scan_result collapse_file(struct mm=
_struct *mm, unsigned long addr,
>>  	 */
>>  	try_to_unmap_flush();
>>
>> +	/*
>> +	 * At this point, all folios are locked, unmapped, and all cached
>> +	 * mappings in TLBs are flushed. No one else is able to write to the=
se
>> +	 * folios, since
>> +	 * 1. writes via FS ops require folio locks (see write_begin_get_fol=
io());
>> +	 * 2. writes via mmap require taking a fault and locking folio locks=
=2E
>> +	 *
>
> maybe simplify to "folios, since that would require taking the folio lo=
ck first."

Sure.

>
>> +	 * khugepaged only works for read-only fd, make sure all folios are
>> +	 * clean, since writes via mmap can happen between try_to_unmap() an=
d
>> +	 * try_to_unmap_flush() via cached TLB entries.
>
>
> IIRC, after successful try_to_unmap() the PTE dirty bit would be synced=
 to the
> folio. That's what you care about, not about any stale TLB entries.

Right. I missed the PTE dirty bit to folio dirtiness part.

>
> The important part is that the
>
> So can't we simply test for dirty folios after the refcount check (wher=
e
> we made sure the folio is no longer mapped)?
>

I think so.

>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b2ac28ddd480..920e16067134 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2089,6 +2089,14 @@ static enum scan_result collapse_file(struct mm_=
struct *mm, unsigned long addr,
>                         goto out_unlock;
>                 }
>
> +               /* ... */
> +               if (!is_shmem && folio_test_dirty(folio)) {
> +                       result =3D SCAN_PAGE_DIRTY_OR_WRITEBACK;
> +                       xas_unlock_irq(&xas);
> +                       folio_putback_lru(folio);
> +                       goto out_unlock;
> +               }
> +
>                 /*
>                  * Accumulate the folios that are being collapsed.
>
>
> I guess we don't have to recheck folio_test_writeback() ?

Right, writeback needs to take folio lock and we are holding it, so
others can only dirty the folio but are not able to initiate write backs.=


Best Regards,
Yan, Zi
