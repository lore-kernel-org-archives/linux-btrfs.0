Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011052.outbound.protection.outlook.com [52.101.62.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5B721770B;
	Sun, 17 May 2026 02:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778985946; cv=fail; b=Bwx4w1n6rB5RDCaRwrw1IOJwqH53zokjMVZ/oFWqyX/PVs5po9gSKuhf+mBI9As9Nqui1kIqZpjftOMUaHpZeA8FyQANJtGjXZVNqqBBaxhxLSBCJGXp6bd3ZQTJu2R1RpLAGlUbLj/I76MMEQyOl6QK6WhLcngHZIGk/9fg7rw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778985946; c=relaxed/simple;
	bh=fNP3d18n3ky/ztNpe2/+sVWTtzUcr9frkYWUpriIMwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cJnXtbfKeQabR0CtHQhAj6Crl03JEOy4mtvqLzodGnkh+fF3F4X8Uf2yl2Q+bf153tf0zCW4vEZSO70MuSBVrJgPH0u6KfffdsEjhedkjIaWZo4XqDuNLYBMHlDX9TGOIFr5FyyH8RSpyzf/OTQ/8+Vcqo0PE+xRI2a8d18vdHY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GAXvvoi4; arc=fail smtp.client-ip=52.101.62.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GAXvvoi4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mF4exfW6UulnooaNR+uMpIBE5cLR7P/kHL3wesd2lWa2TG43tUURAmXdgfOxRoLU5Zb/5NSpycYKianUZ7gbTdrXeRPzvwhx1GNUgKNjdyinFq6O2p889iBlYDm0nPC8Kxt0FHJmDnwsK9w9RMjam98TkvzFArH41kcERBNtSNIxkvksj68p1rfAjFmqXKR7bowuPppOhHYFXbegJ8Ez9hZcKm1t5UIPtIFrXVldr03gNrMqS2V9+UV04EQME3oQhVKvHEA2iFZQM8IlYHBSqt8EGMhuCzevwITaJ6gRV0lf6CovgBzCXMBpPXo+uzYp/QX1zkNBOqg7j/XJIJOkUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UUSjQL/TvRMGryKXOEXSNRx4X9ixSr29VY99AiqdvL8=;
 b=flL/Im0dLMpLAHNGnJ/xPpeac3zURNM2HJNS3taUiB0DNkJiEs320akAhj0jCkBgOZdoTYPQkLhXM+yI/xJar49Gez+DJtdatb09FMO+j/xaW/dqIFIQugZ/+EjW0KKQkstSMdrqR+nrUXqz97WJFWek9SEDyWQ1sKvzXjSv+23rLdExMdn7BI2zwofCdsOFAn2IzhO7wxHxb7zZoq1Mj6lzOWOJ64hsrWHMQX1imdu4G0gofs+NmP/+2hzPCHVyplJm5MJjj7ZvC2d+Y9DbyY6wg/H/SIV42x/VZyPV+JS9ensPBB1TPMbjRrhbu0UxR9daiQiiTsW466tSMRLX1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UUSjQL/TvRMGryKXOEXSNRx4X9ixSr29VY99AiqdvL8=;
 b=GAXvvoi4nY2Wwz/6nUKRfbp1Ds8JF7pM5NRjpYaE/24BmsZbu/2pYJqkmAfQxHz3l8MFHesY8Ln5j/Z2oqbuR/aoFQWulFIDpEvwU0UpO9Dwk7RZNQ/UtKJHIQyTsi+MvsgREOPCqWI8jlMeQGP/Ez99fh715w+NicwKCDHU1DYpd+97r3QCG63Du27xH9a1rbgNVIuoD9JL5cPj/waWED1RLAV9yCD36EelCs21HMW6GOGQQPKmrk26G1KB4tCN4WFEAtEMdAB9ZR3a5S/gHz/8Q5de4N7diT/MlkiFA8d/UP1MPdK2G/TgPQzZpKXFQN230Rsl4Bkry8rwL+p6jw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW3PR12MB4473.namprd12.prod.outlook.com (2603:10b6:303:56::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.22; Sun, 17 May 2026 02:45:39 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Sun, 17 May 2026
 02:45:39 +0000
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
Subject: Re: [PATCH v5 11/14] selftests/mm: remove READ_ONLY_THP_FOR_FS in
 khugepaged
Date: Sun, 17 May 2026 10:45:27 +0800
X-Mailer: MailMate (2.0r6292)
Message-ID: <269C18BB-0E83-4DDF-A459-C41BCE2E87FC@nvidia.com>
In-Reply-To: <959238dd-2493-4d9c-ac35-6d04460a8239@kernel.org>
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429153538.727855-7-ziy@nvidia.com>
 <959238dd-2493-4d9c-ac35-6d04460a8239@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: DS0PR17CA0018.namprd17.prod.outlook.com
 (2603:10b6:8:191::18) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW3PR12MB4473:EE_
X-MS-Office365-Filtering-Correlation-Id: afe77f3a-98da-4165-a0e7-08deb3be617e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|10070799003|366016|1800799024|20052099010|56012099003|22082099003|18002099003|4143699003|11063799003;
X-Microsoft-Antispam-Message-Info:
	eqXKTtbfkStkmn6KeF2Z7xOgnHLIH+8llOtd5ITHk0HNN+bTrK0Jl9AaNBPj/+q1eggBZDbZv+zRqRzurQLaJKWXQIe4+bfL70mk9YKiNTcOEvm81jYvQiDJrI2axtHrBnKLdJAIfRCtrZQ/32VC46euTEdyhNRr+lA/OWAdBDZtOKo3bwch6eIDzA8RkL/z/8YBNiXR6V3CdXpOgHyUmm+V5Kpvn4I3JKgdeBf7MEZArCwLp/VZQOEN1xZ/70WDuMGZCKXN6Ulu4AYQX9+QE+OftFmI3PgqAc8d/YZuIeh4Pfyl1CL3NPlxBaL/1DXGYcNXi/8sITwo4RFQRPuoE0HWK9bOVJ1FT9877tM5XD2SsXlMO9MfnMiYhmtzu45//WYDNNT5TPJFDj95cB303NywzMSWFZfLzp4dydjIiRe1W67TL+MA768CH/FHnZEiINwFzhAXX++bdHV2qSQmfQ4aF8vSeCUlbtkwgaSRhTmuBBRc8KBW7k4QCo8uKmQMZxkjdds2i2LbXYMPHbz3hu0Ph3o5a0CCFbITAr5xImcOuSdLaXAA+lT/O5ToKVd5m3QrFbSXgSVRzkq81I5i2xi977zKeUVN+kuC7NpyKKhUrVSzfX8oVqMO31edVVjuvrQ9wtrcaE54EVFKYrXRyEKqCf55Q/1OKFJ0kOqR6Li/AwtkOBSBo5pxrVDK8UTV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(366016)(1800799024)(20052099010)(56012099003)(22082099003)(18002099003)(4143699003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XCXm7/lqWI0OS4uqMmU8BD0MuRChLFSF0HrK0jakY4Dv+1Wyso837jUX3b0S?=
 =?us-ascii?Q?ttSu8kmrZTbrfzFMZvjQTE6LkRMBoXaFTiSCyugjvb9CIUcpQHqHid/hH3LW?=
 =?us-ascii?Q?ExL4S5BZfX1Ikd7SQa6hzNEJEs7da8uDbDov3BN4IiKdudAQtii/gTFzgekD?=
 =?us-ascii?Q?kjkQZXKTPpJfptt7smXFzrVnnTWch1olqapiRrQBr2o9ZmtCm1odt3OLpsWS?=
 =?us-ascii?Q?A5BsD7en1/hggGcOvaZA/+WlHCEwgS0MJpWRBSk5mLo+atYwQjV3GiJNS7bz?=
 =?us-ascii?Q?EcvblyyGGmDczTrTUwxuAvZZ7fgpHBcjrcbQgsCC5ezVELWc2Q1OaxrBSnIs?=
 =?us-ascii?Q?NRtcj5BPgVHjGQFrespTsW/f4iKQssX9urhy/pD1yR0aoOCbfOma1Y3YkBFj?=
 =?us-ascii?Q?cRA3BboDewhuxuCkAQit1f2/xJiR6pganp+WogMrgiVfZARNaBy+pcPEvjtL?=
 =?us-ascii?Q?KXnClNqeLdNYfp8ZKfHbLLUPkFVjbMQpKRzsBGSJwYD9T/YatORQYX1GD/w+?=
 =?us-ascii?Q?m+fsPu26ISjRw+P8R+BrqN/ubvau41gHRgqRszDaYXdZMasi4h3tvDYfEmN5?=
 =?us-ascii?Q?bRmV/uS3HZO2FHMjzkt9Sl5CX/L2fNshbEjfoi2XWBspJefWhMpaPLfTi+dw?=
 =?us-ascii?Q?VAf+YP9eJ4eQb2Aui61o777/WDaAZ4CJmyqnSqOvkAb3sfBUa89UOfX30/5+?=
 =?us-ascii?Q?pEq6tUvP4ufWgZMwPegxMllMY2kgOPOCLqQpQ7sbgbusREC/NnmQUz11ntLX?=
 =?us-ascii?Q?YdpzkqcWChzx+ciP4zwk83Rm7UivpxoJjG7KPfFlLhT/qYwkx37EYQPODrJ2?=
 =?us-ascii?Q?9H8CuOTXlynknd7bDHD28Go72baDhSjJS3VqRz8PM27Puynrd0f0gpO0H8h1?=
 =?us-ascii?Q?q5G04ZPB8SwU8wD0ROxtYPJvYajqqYfNvzaihJNZmrbT/rIHBcQPyz/Z4El7?=
 =?us-ascii?Q?UoRgvaaxQuJhhnuQBzqNZwq4HbAB2gzpq5qKQJKf+vBepYasDF2tVQfjNjwm?=
 =?us-ascii?Q?pTtleLI+azMYLvsJLsYunL1yhgkhxNlgBuA2HIjwhOFpRdEB3xmmW4eyg4PF?=
 =?us-ascii?Q?tPT5invShnPiz+ZHbMfP8Oggz1JX5EWa/XRpnXigOk0MQj8RfKeGWi+Ta+X0?=
 =?us-ascii?Q?x561fTpqwswwTcbGJMKO/gfevTYZ69aP1/vSGrh83uGRlVbnTwi9DBCx3ZUL?=
 =?us-ascii?Q?32SjE9HrDY6tWgtTNuMfbOYdl72E7I8eP9B5BWpKfGfwD3feKPpBJiTBTg/s?=
 =?us-ascii?Q?Yo843GygivfkcFqhm8cFgrQYV+GZxhrIPbcApugZ7HZ6CHPrgc1I8m6dyZtQ?=
 =?us-ascii?Q?XK/fX2ZYIg7nBdMrkZJVFeu5H0km0JVO1GTtYXIyFh9VamgmyJvtJAbY7vvl?=
 =?us-ascii?Q?x0g4lyrMj959568oCdP5FdU+j59oc+fQ7UPlzp1ugOCG1tfiTnxXB56jHLtF?=
 =?us-ascii?Q?oQIxMvTjss/OpscBrCkMBlMdxi83O5fCbtkcJc1FbMV0anENW8BHb1HsURSB?=
 =?us-ascii?Q?mSdY50HgtyTPOFef0ZT8U5v8Xl9Q00FQEDCjxk4cuBBXHsEgIiK0NG7oOpTr?=
 =?us-ascii?Q?YxHJ0J71sHJYjsSx4venSOSjoZy+XTrkr7tO3DZEKcHuNBkGAft+pWBljgqX?=
 =?us-ascii?Q?LJ+gj06SYuasdLStdUX6TF/jhVBUmQkxZgo268BPIJVyUOAgQgg1It0RhwNq?=
 =?us-ascii?Q?9if4T/jcmpXA5OPR/Xk6Uc5nbFTxAnFnX7Q3mJdN3Nj344BCf4lPvNrM8fwN?=
 =?us-ascii?Q?iDJbpfG+oqP9J1L73HbBAyB86T432lQUf+8rvhfFGwL8CCV3VMdu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afe77f3a-98da-4165-a0e7-08deb3be617e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2026 02:45:39.5143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2+/RvTQxJICYdEw85M4/+S4BRJUeQJQzmuVur+4blBgErZDcP/AjXgS8ktUABmJJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4473

On 9 May 2026, at 4:06, David Hildenbrand (Arm) wrote:

> On 4/29/26 17:35, Zi Yan wrote:
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
>>  tools/testing/selftests/mm/khugepaged.c   | 131 +++++++++++++++------=
-
>>  tools/testing/selftests/mm/run_vmtests.sh |  12 +-
>>  2 files changed, 102 insertions(+), 41 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/s=
elftests/mm/khugepaged.c
>> index a6bb9d50363d2..80b913185c643 100644
>> --- a/tools/testing/selftests/mm/khugepaged.c
>> +++ b/tools/testing/selftests/mm/khugepaged.c
>> @@ -49,7 +49,8 @@ struct mem_ops {
>>  	const char *name;
>>  };
>>
>> -static struct mem_ops *file_ops;
>> +static struct mem_ops *read_only_file_ops;
>> +static struct mem_ops *read_write_file_ops;
>>  static struct mem_ops *anon_ops;
>>  static struct mem_ops *shmem_ops;
>>
>> @@ -112,7 +113,8 @@ static void restore_settings(int sig)
>>  static void save_settings(void)
>>  {
>>  	printf("Save THP and khugepaged settings...");
>> -	if (file_ops && finfo.type =3D=3D VMA_FILE)
>> +	if ((read_only_file_ops || read_write_file_ops) &&
>> +	    finfo.type =3D=3D VMA_FILE)
>>  		thp_set_read_ahead_path(finfo.dev_queue_read_ahead_path);
>>  	thp_save_settings();
>>
>> @@ -364,11 +366,14 @@ static bool anon_check_huge(void *addr, int nr_h=
pages)
>>  	return check_huge_anon(addr, nr_hpages, hpage_pmd_size);
>>  }
>>
>> -static void *file_setup_area(int nr_hpages)
>> +static void *file_setup_area_common(int nr_hpages, bool read_only)
>>  {
>>  	int fd;
>>  	void *p;
>>  	unsigned long size;
>> +	int open_opt =3D read_only ? O_RDONLY : O_RDWR;
>> +	int mmap_prot =3D read_only ? PROT_READ : (PROT_READ | PROT_WRITE);
>> +	int mmap_opt =3D read_only ? MAP_PRIVATE : MAP_SHARED;
>
> Can all be const and read better at the very top of the list.
>
> Why do we go from private->shared depending on "read_only" parameter? I=
'd assume
> we'd want to test MAP_SHARED for both (read-only + read-write)?

The original code used MAP_PRIVATE, but I agree that MAP_SHARED works.
Will change it.

>
>
>>
>>  	unlink(finfo.path);  /* Cleanup from previous failed tests */
>>  	printf("Creating %s for collapse%s...", finfo.path,
>> @@ -399,14 +404,15 @@ static void *file_setup_area(int nr_hpages)
>>  	munmap(p, size);
>>  	success("OK");
>>
>> -	printf("Opening %s read only for collapse...", finfo.path);
>> -	finfo.fd =3D open(finfo.path, O_RDONLY, 777);
>> +	printf("Opening %s %s for collapse...", finfo.path,
>> +	       read_only ? "read only" : "read-write");
>
> "read-only" ?
>
>> +	finfo.fd =3D open(finfo.path, open_opt, 777);
>>  	if (finfo.fd < 0) {
>>  		perror("open()");
>>  		exit(EXIT_FAILURE);
>>  	}
>> -	p =3D mmap(BASE_ADDR, size, PROT_READ,
>> -		 MAP_PRIVATE, finfo.fd, 0);
>> +	p =3D mmap(BASE_ADDR, size, mmap_prot,
>> +		 mmap_opt, finfo.fd, 0);
>
> While at it, can fit that into a single line.
>
>>  	if (p =3D=3D MAP_FAILED || p !=3D BASE_ADDR) {
>>  		perror("mmap()");
>>  		exit(EXIT_FAILURE);
>> @@ -418,6 +424,16 @@ static void *file_setup_area(int nr_hpages)
>>  	return p;
>>  }
>>
>> +static void *file_setup_read_only_area(int nr_hpages)
>> +{
>> +	return file_setup_area_common(nr_hpages, /* read_only=3D */ true);
>> +}
>> +
>> +static void *file_setup_read_write_area(int nr_hpages)
>> +{
>> +	return file_setup_area_common(nr_hpages, /* read_only=3D */ false);
>> +}
>> +
>>  static void file_cleanup_area(void *p, unsigned long size)
>>  {
>>  	munmap(p, size);
>> @@ -425,14 +441,25 @@ static void file_cleanup_area(void *p, unsigned =
long size)
>>  	unlink(finfo.path);
>>  }
>>
>> -static void file_fault(void *p, unsigned long start, unsigned long en=
d)
>> +static void file_fault_common(void *p, unsigned long start, unsigned =
long end,
>> +		int madv_ops)
>>  {
>> -	if (madvise(((char *)p) + start, end - start, MADV_POPULATE_READ)) {=

>> +	if (madvise(((char *)p) + start, end - start, madv_ops)) {
>>  		perror("madvise(MADV_POPULATE_READ");
>>  		exit(EXIT_FAILURE);
>>  	}
>>  }
>>
>> +static void file_fault_read(void *p, unsigned long start, unsigned lo=
ng end)
>> +{
>> +	file_fault_common(p, start, end, MADV_POPULATE_READ);
>
> Do we really want file_fault_common()? I'd say, just inline it. In part=
icular
> avoids checking the madv_ops to figure out the error message ...
>
>> +}
>> +
>> +static void file_fault_write(void *p, unsigned long start, unsigned l=
ong end)
>> +{
>> +	file_fault_common(p, start, end, MADV_POPULATE_WRITE);
>> +}
>> +
>>  static bool file_check_huge(void *addr, int nr_hpages)
>>  {
>>  	switch (finfo.type) {
>> @@ -488,10 +515,18 @@ static struct mem_ops __anon_ops =3D {
>>  	.name =3D "anon",
>>  };
>
> [...]
>
>>  };
>>
>> +static bool is_tmpfs(struct mem_ops *ops)
>> +{
>> +	return (ops =3D=3D &__read_only_file_ops ||
>> +		ops =3D=3D &__read_write_file_ops) &&
>
> Can't this fit into two lines?
>
>> +	       finfo.type =3D=3D VMA_SHMEM;
>> +}
>> +
>> +static bool is_anon(struct mem_ops *ops)
>> +{
>> +	return ops =3D=3D &__anon_ops;
>> +}
>> +
>>  static void __madvise_collapse(const char *msg, char *p, int nr_hpage=
s,
>>  			       struct mem_ops *ops, bool expect)
>>  {
>
>> -
>>  static void alloc_at_fault(void)
>>  {
>>  	struct thp_settings settings =3D *thp_current_settings();
>> @@ -1097,8 +1142,8 @@ static void usage(void)
>>  	fprintf(stderr, "\t<context>\t: [all|khugepaged|madvise]\n");
>>  	fprintf(stderr, "\t<mem_type>\t: [all|anon|file|shmem]\n");
>>  	fprintf(stderr, "\n\t\"file,all\" mem_type requires [dir] argument\n=
");
>> -	fprintf(stderr, "\n\t\"file,all\" mem_type requires kernel built wit=
h\n");
>> -	fprintf(stderr,	"\tCONFIG_READ_ONLY_THP_FOR_FS=3Dy\n");
>> +	fprintf(stderr, "\n\t\"file,all\" mem_type requires a file system\n"=
);
>> +	fprintf(stderr,	"\twith large folio support (order >=3D PMD order)\n=
");
>
> "with PMD-sized large folio support"?
>
>>  	fprintf(stderr, "\n\tif [dir] is a (sub)directory of a tmpfs mount, =
tmpfs must be\n");
>>  	fprintf(stderr,	"\tmounted with huge=3Dadvise option for khugepaged =
tests to work\n");
>>  	fprintf(stderr,	"\n\tSupported Options:\n");
>> @@ -1154,20 +1199,22 @@ static void parse_test_type(int argc, char **a=
rgv)
>>  		usage();

Ack on all above.


Best Regards,
Yan, Zi
