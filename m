Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010030.outbound.protection.outlook.com [52.101.46.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7FD3FA5C8;
	Wed,  6 May 2026 13:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778073112; cv=fail; b=bwu0BNCAZrf8tz5YLHXukp5rEDC/DgV1Lu36PgbRUBH1XpkRLdyfKPxxkERW1RZqAerYOSq2BXGXs/7xEAgjfcnonZSuj9qIykMGw/nX1/STVrkK5Y3FpqN64ym0p/A066WwpbIeqOXfPdQeCvlWAsfp4dBaeuhD3wZ0Lk81U5g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778073112; c=relaxed/simple;
	bh=z5l5q7/AXkH3CM8ZbtArV5uafSx8eAIkbfE2Eg4dLr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Btriuw4+AQgpTo7c/ZJI25KxX32PNyj8m7FOuO4WvGS+QjLCjs0kWaNa+AngWp7YCOTFa0aDILuBmvauWQx6Kn5u/KG0WdDBAMtg6IZcApgiGjDz94ict2wIN+uzdkwwpKkeOmTqf1GlDey2EbrHXc8uKKHnDbc8VWCp9UnWQqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HC5URyod; arc=fail smtp.client-ip=52.101.46.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HC5URyod"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fkj+gbdJDK5swYaZvmxRD4GKBFwPLZdM48j6X1EQUoUWoS+qNnACQZgIKs3T8snHyarVrZeHm4PqRC7dqWSxDSaCqwpL26tPq75ANnsvVgsju9h0YsBGhCuAN+2LVVRtEaQ4rfUF4l4giZXACc2/b96SmKhL2ggOu95CA91MMfzVFjJ4BTsw/N5dGvy8R31fqUxj7P7QKmB1v1ipm2NO01Lsm7tyFFUGi4UiH5pYZ25CjCX2NOwiC162YBFo4fHqkd3Kk6KEWHn+yvL5eAkjGqttvJr0TrNrOqMO+d5De0fsPLD9Gms3ng72Hv65TSHK7Cmo82L0kce71R/OOnV9OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KUdU/YKm9HXcsDHE+sXepmxr1a2IyKG+Rsq1uP3oH5s=;
 b=kJs8Upr9MfyeSbIDhN2P5FPH4Ju0BIYjphBmC8a40JlZXYE8fV82bX+2q/RRaqh2NlOcGRmJkEB8ORucn5R2L1F9L+rTItZjvwjoVivn9DzRuI81Y45v6Ox6efd4QP2N+wmaDxbz/86m38GUjNxeXnI2x07T/Cd/Kt+bR57pQdN6Z8xMdVw6/idzGo07pggEXIOislORBbX9ef49TvFmm02qNC5peJ+od/GEHB+Qv56uXTVRoGmRVclQDOhHKG9aaJNZoY8nAcZn5M0gryImXgbRehRPqPJ5y3kselKrS5/iUi3Y7N/Qa/D4bBNvR1SLNcW9UJoeo1oB2xJyLmEKyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUdU/YKm9HXcsDHE+sXepmxr1a2IyKG+Rsq1uP3oH5s=;
 b=HC5URyodmRh7quciAhj+jRwwRTQ8DXXSjxqeSboEBc3P27PyZrB4oqx6OSb325q8Oh4rlzPfhy/yAYkjFYVfh8CxP2J+iWemy/Ykksxm9AQG8DFW/mxLPyfPHPVrK1S4RWtvvRUfXdphuSCkzl8GHgHwWnU8vIjx0JL9lHobC5ydsfUWMXT7D33EIRB3pcBfQSB9hBwZUoZWtIZBiY3Ds1xybNkZcLak53D8xozk8tctMGxgqI+4Ie7H8YNbb2iGVtCM+H1rEFShlHebLrzUiil6WuFIqlB3LtKMGvCcNF1iphAZC1MeLkBi4yBS6fmlMTrzb41r324pHvtDKaNgEw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB7039.namprd12.prod.outlook.com (2603:10b6:806:24e::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.15; Wed, 6 May 2026 13:11:43 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.023; Wed, 6 May 2026
 13:11:43 +0000
From: Zi Yan <ziy@nvidia.com>
To: Nico Pache <npache@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 11/14] selftests/mm: remove READ_ONLY_THP_FOR_FS in
 khugepaged
Date: Wed, 06 May 2026 21:11:30 +0800
X-Mailer: MailMate (2.0r6292)
Message-ID: <E2400A6C-C0F8-44FB-B8F8-92B5371737B6@nvidia.com>
In-Reply-To: <52285e2c-af42-4c0d-9926-017f80b6614c@redhat.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429153538.727855-7-ziy@nvidia.com>
 <52285e2c-af42-4c0d-9926-017f80b6614c@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: CH2PR14CA0031.namprd14.prod.outlook.com
 (2603:10b6:610:56::11) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB7039:EE_
X-MS-Office365-Filtering-Correlation-Id: b09991b2-dda6-445d-4f4e-08deab710492
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|10070799003|1800799024|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Rsmuz2cJ0RWfENkfLNKBfEEnsmhFT3h01uIpSD86nndasUy/n5NLxdsAZLhvB8zfxubcIDh0nSaXYBGV/vzOKesrhvyzSwdmRKdsPPWzrRdlwRHxgaqKwsF0j6Kny1CDt/2UNutS/7BzI3oRvyPJYc937XuZejwXzTA8sCeWDcQ3rJ3SEVyBSxv2ayAzzhoaXkmiQSguNStEN9Poawtk+4eI+3GT398tZ1YiF1B5zzdkI/kMMVnUqedPTWDRNMUTyS2BjcJ4TWH+AXbIx1eFz9iyfxsai9eRnP6tFGDWH1cUv/oSdbSPt+l7O0EzuqgAIM+m15Bvhk/W2AFAVsid734KYoD6HvsKru5MSa8G596onunXGsk7dy06k9KuShWO2PvyYd6N6xdZS/SwvuTeTDeDU/gAVQOsZC022Jb53lMoMaipOrxu5RQ/tYQkd+trSITf6tITZcVOdCexQOQ2Hdo9SSbTaAuFqNEfqiTYKfwX7zAo9TQ/YB8rFyclIgZ8V0j1Zml+EVHkPjeJAgD29V0JeyoZEixOXlfUdRkvQ9Nebo2l4oelVNNjTiLMswLShHceiR6Ds/RHY9wHxQSBlbtCDxBWgVbYmKMCfPL1cQVaxD+NTIm9uc4l4W1jGx9ow6HmjqY81BzLXsVgUzw4mqCUqytsWVirdqePpfejeSInRTQibRaZwIyQqyeNH4MI
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(1800799024)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tPQxvL0PsTbnOf7l/iocQIH6+yhxa7xkIbPbhg5azEVwtK2g2O2gp2J/0aD2?=
 =?us-ascii?Q?SCdoUA9t+QwDcTECtpJZN8MTbtPChX6tzHiiZkeXWnTYbX7yFwfQX7hFAnEA?=
 =?us-ascii?Q?70kmerexhdkiUx/v1/GmSiqjquDQsE3idQu37/C58vLLw3dQU0OWAZ0KG3Im?=
 =?us-ascii?Q?IbVYbItcEWDpXgWMgv8WKyVFvslkChQ50DGy2NnS00XS2mrwsi+n57rARHuV?=
 =?us-ascii?Q?o491lxhV+3sFHika/bb9AQTHwR40bdlBlHjuRAEUz1JyTc87G1x5XpUFiQ9n?=
 =?us-ascii?Q?LrURG1L8of0fWoYn33Hxj5Ip4nuu+SlfYjA3Myk87GwqinV0myrkNSYbQpy6?=
 =?us-ascii?Q?aYdbFU5KHACUi0gWk2wSbJiA43L7j/6sRHsA8TGPViz3cY+Aj9/SZg3nb6ch?=
 =?us-ascii?Q?ROjumzSr1oy7smcBuZUudOAUx+4IHTI5E8jQ72xvC8Rrw3mL+5U0InJkrxY3?=
 =?us-ascii?Q?qPLdOIUxnz+pndCZM7jWF6n3XcCJnTVtfnJlpg+o/jIoKfEpaYNNnTqg85bt?=
 =?us-ascii?Q?PIbcgfLjjx4XyEFa9hCA1rw7dkvMBBz4OvwAvYv8Cd2yLjR1E+bed9p4iPKQ?=
 =?us-ascii?Q?ZuSLHa+4XdXVzdXsuoXztHecbni//8bxb3PI0s0e9cQBgJ/cjYTz1E98s6KK?=
 =?us-ascii?Q?+a71LSidjCpmL2wcetvLpXLv4rDwiyVGnmj8JJUaWEoUg58YhkHb3KM8zt6r?=
 =?us-ascii?Q?w5AdeQAunbcNMbEypJtupt5vyrpI0+meRyqG16U3498zjosoTWun7fGPFtwn?=
 =?us-ascii?Q?Pa4tyCelGrf8PPmxXGyGu3ZuYEfKLHGc7Wv1ckCh0NxKbzEqCyUDJQPgnvem?=
 =?us-ascii?Q?9ClkCR7wVULDqB1yBlrhI9owDt6p6wgvfayVxjDTrgz107VKw/4nD9CQYnL3?=
 =?us-ascii?Q?cIjmidg+Yk0EuSWvXv9WlhEldaBlDHhPX1wYhVKRLNCSmfSqkCS7hvU0G52N?=
 =?us-ascii?Q?pMS0EH1WpbZbghZzi3+XY/11XnacR9WByMw3+4p6n4LS0175qx581/gmsed9?=
 =?us-ascii?Q?68rF7p/PEuSuX41xCogfR51ex9DiRAIHgtAGNs37CXiOrFAJloDoKq0VeL3y?=
 =?us-ascii?Q?0yoE9IdsU0hpy243YNLFKzm463/d02HT/gqt5Z0kzRwvgpb8yByoGdpAeK7r?=
 =?us-ascii?Q?yr1xP70T09OxQCV11vIN0ms7OyxjBRBuiMpgSfh+vQ3sAP1olLD5C1kMxsTk?=
 =?us-ascii?Q?/NmgRUmBVOryO2inJtt6HVZA3y0Nm9mi3e63Ssb8RdbuXWgWiMTaDtfCP/7k?=
 =?us-ascii?Q?RgI/AnfEUt4jHGGuMxempY5uVdJ+Dg97asmv9WamjM6wkwsQrvWvjpGKS+UI?=
 =?us-ascii?Q?WFj5zBDPW5kNwZDFOlPYmOqAQQtHCV4vHvTL4GX0EGb5u0/cvv1tL+ODexlk?=
 =?us-ascii?Q?2zEvbS7Xo9mKUkMSIS38kHj3Y1vNu+OJgaEWumAQil/eVySstAA8lAD7pT4e?=
 =?us-ascii?Q?PdLurRqf6nNHcMf4WG6PECvl0xoIZAwRg/iEMRQEysDS18llOcg+BP3aFbpX?=
 =?us-ascii?Q?LjzzgdEOLoN26XHzbHv5/Hvw8KIOjQtlLcNVXRMTwX4T+bQcXn5LeJmtWi14?=
 =?us-ascii?Q?QXiILwon5vMTMaOM2nANW8djEaURihebZvIoTBT9cObX3j+4SXkW5HmHTD4f?=
 =?us-ascii?Q?FFxaoC8U2PEfiXp1DP7QOatmPX+hQCZWBf5dVVUkEOI5DYxuIEh/kNgmgbAr?=
 =?us-ascii?Q?gQ+pNI5QXRmJCuG1UpEkIGtxIzd5xgf8osWeJOYIX8xwPIGAQ6mI8Vdpe986?=
 =?us-ascii?Q?5E7adxOAO/hRtWbsTdKDhk/pTe1rabtYYUsBHK19fNy0NGWdmdbS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b09991b2-dda6-445d-4f4e-08deab710492
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 13:11:43.1177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: irFQ+tTmu/XMVU/vCXjd+lRN4f2tcFAt87ybJB1gjOl6Lh7MWVZQ7P/IiBRFdaT1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7039

On 4 May 2026, at 12:23, Nico Pache wrote:

> On 4/29/26 9:35 AM, Zi Yan wrote:
>> Change the requirement to a file system with large folio support and t=
he
>> supported order needs to include PMD_ORDER.
>>
>> Also add tests of opening a file with read write permission and popula=
ting
>> folios with writes. Reuse the XFS image from split_huge_page_test.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>   tools/testing/selftests/mm/khugepaged.c   | 131 +++++++++++++++-----=
--
>>   tools/testing/selftests/mm/run_vmtests.sh |  12 +-
>>   2 files changed, 102 insertions(+), 41 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/s=
elftests/mm/khugepaged.c
>> index a6bb9d50363d2..80b913185c643 100644
>> --- a/tools/testing/selftests/mm/khugepaged.c
>> +++ b/tools/testing/selftests/mm/khugepaged.c
>> @@ -49,7 +49,8 @@ struct mem_ops {
>>   	const char *name;
>>   };
>>  -static struct mem_ops *file_ops;
>> +static struct mem_ops *read_only_file_ops;
>> +static struct mem_ops *read_write_file_ops;
>>   static struct mem_ops *anon_ops;
>>   static struct mem_ops *shmem_ops;
>>  @@ -112,7 +113,8 @@ static void restore_settings(int sig)
>>   static void save_settings(void)
>>   {
>>   	printf("Save THP and khugepaged settings...");
>> -	if (file_ops && finfo.type =3D=3D VMA_FILE)
>> +	if ((read_only_file_ops || read_write_file_ops) &&
>> +	    finfo.type =3D=3D VMA_FILE)
>>   		thp_set_read_ahead_path(finfo.dev_queue_read_ahead_path);
>>   	thp_save_settings();
>>  @@ -364,11 +366,14 @@ static bool anon_check_huge(void *addr, int nr_=
hpages)
>>   	return check_huge_anon(addr, nr_hpages, hpage_pmd_size);
>>   }
>>  -static void *file_setup_area(int nr_hpages)
>> +static void *file_setup_area_common(int nr_hpages, bool read_only)
>>   {
>>   	int fd;
>>   	void *p;
>>   	unsigned long size;
>> +	int open_opt =3D read_only ? O_RDONLY : O_RDWR;
>> +	int mmap_prot =3D read_only ? PROT_READ : (PROT_READ | PROT_WRITE);
>> +	int mmap_opt =3D read_only ? MAP_PRIVATE : MAP_SHARED;
>>    	unlink(finfo.path);  /* Cleanup from previous failed tests */
>>   	printf("Creating %s for collapse%s...", finfo.path,
>> @@ -399,14 +404,15 @@ static void *file_setup_area(int nr_hpages)
>>   	munmap(p, size);
>>   	success("OK");
>>  -	printf("Opening %s read only for collapse...", finfo.path);
>> -	finfo.fd =3D open(finfo.path, O_RDONLY, 777);
>> +	printf("Opening %s %s for collapse...", finfo.path,
>> +	       read_only ? "read only" : "read-write");
>> +	finfo.fd =3D open(finfo.path, open_opt, 777);
>>   	if (finfo.fd < 0) {
>>   		perror("open()");
>>   		exit(EXIT_FAILURE);
>>   	}
>> -	p =3D mmap(BASE_ADDR, size, PROT_READ,
>> -		 MAP_PRIVATE, finfo.fd, 0);
>> +	p =3D mmap(BASE_ADDR, size, mmap_prot,
>> +		 mmap_opt, finfo.fd, 0);
>>   	if (p =3D=3D MAP_FAILED || p !=3D BASE_ADDR) {
>>   		perror("mmap()");
>>   		exit(EXIT_FAILURE);
>> @@ -418,6 +424,16 @@ static void *file_setup_area(int nr_hpages)
>>   	return p;
>>   }
>>  +static void *file_setup_read_only_area(int nr_hpages)
>> +{
>> +	return file_setup_area_common(nr_hpages, /* read_only=3D */ true);
>> +}
>> +
>> +static void *file_setup_read_write_area(int nr_hpages)
>> +{
>> +	return file_setup_area_common(nr_hpages, /* read_only=3D */ false);
>> +}
>> +
>>   static void file_cleanup_area(void *p, unsigned long size)
>>   {
>>   	munmap(p, size);
>> @@ -425,14 +441,25 @@ static void file_cleanup_area(void *p, unsigned =
long size)
>>   	unlink(finfo.path);
>>   }
>>  -static void file_fault(void *p, unsigned long start, unsigned long e=
nd)
>> +static void file_fault_common(void *p, unsigned long start, unsigned =
long end,
>> +		int madv_ops)
>>   {
>> -	if (madvise(((char *)p) + start, end - start, MADV_POPULATE_READ)) {=

>> +	if (madvise(((char *)p) + start, end - start, madv_ops)) {
>>   		perror("madvise(MADV_POPULATE_READ");
>>   		exit(EXIT_FAILURE);
>>   	}
>>   }
>>  +static void file_fault_read(void *p, unsigned long start, unsigned l=
ong end)
>> +{
>> +	file_fault_common(p, start, end, MADV_POPULATE_READ);
>> +}
>> +
>> +static void file_fault_write(void *p, unsigned long start, unsigned l=
ong end)
>> +{
>> +	file_fault_common(p, start, end, MADV_POPULATE_WRITE);
>> +}
>> +
>>   static bool file_check_huge(void *addr, int nr_hpages)
>>   {
>>   	switch (finfo.type) {
>> @@ -488,10 +515,18 @@ static struct mem_ops __anon_ops =3D {
>>   	.name =3D "anon",
>>   };
>>  -static struct mem_ops __file_ops =3D {
>> -	.setup_area =3D &file_setup_area,
>> +static struct mem_ops __read_only_file_ops =3D {
>> +	.setup_area =3D &file_setup_read_only_area,
>>   	.cleanup_area =3D &file_cleanup_area,
>> -	.fault =3D &file_fault,
>> +	.fault =3D &file_fault_read,
>> +	.check_huge =3D &file_check_huge,
>> +	.name =3D "file",
>> +};
>> +
>> +static struct mem_ops __read_write_file_ops =3D {
>> +	.setup_area =3D &file_setup_read_write_area,
>> +	.cleanup_area =3D &file_cleanup_area,
>> +	.fault =3D &file_fault_write,
>>   	.check_huge =3D &file_check_huge,
>>   	.name =3D "file",
>>   };
>> @@ -504,6 +539,18 @@ static struct mem_ops __shmem_ops =3D {
>>   	.name =3D "shmem",
>>   };
>>  +static bool is_tmpfs(struct mem_ops *ops)
>> +{
>> +	return (ops =3D=3D &__read_only_file_ops ||
>> +		ops =3D=3D &__read_write_file_ops) &&
>> +	       finfo.type =3D=3D VMA_SHMEM;
>> +}
>> +
>> +static bool is_anon(struct mem_ops *ops)
>> +{
>> +	return ops =3D=3D &__anon_ops;
>> +}
>> +
>>   static void __madvise_collapse(const char *msg, char *p, int nr_hpag=
es,
>>   			       struct mem_ops *ops, bool expect)
>>   {
>> @@ -512,6 +559,10 @@ static void __madvise_collapse(const char *msg, c=
har *p, int nr_hpages,
>>    	printf("%s...", msg);
>>  +	/* read&write file collapse always fail */
>
> Just to confirm, you are adding the write part here so that before comm=
it 13 & 14, the behavior is that it will fail. Whereas after with patch 1=
3/14, we expect this behavior to be supported correct?
Yes.

>
> Thanks for working on this :)
>
> I plan on testing the selftests changes at some point this week (if I f=
ind some downtime during LSFMM), and finishing my review here.
>
Thanks.


Best Regards,
Yan, Zi
