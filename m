Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011027.outbound.protection.outlook.com [52.101.57.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF3F24466C;
	Thu, 30 Apr 2026 15:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777562188; cv=fail; b=LIMR6X8DSah2ImMOFnVIWWxJvZ3lSnl1Ul7nDtgxmVD2D6bA0OVSwtBGT8EnsEHjccKyqGEQ7dlkZcDDT1SQPESfOKaWu8tJRIdAlSCIkCurwen9JyTCvjsWZ1BgHjos+xn5dXJOGmBOKsdbV6qJJTUi49l/JJdGAVygIZiagdo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777562188; c=relaxed/simple;
	bh=Taq8uS3vPjFqaSY+wRRY1gKKiezVbTYSiKxB3ZV63Qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BwMUdAgQObA1TQ5Rd5Q2UTxZ2WVZrQMkhyBf7VvCMMQFPCugnb0IghHt851PxccryeuqNxdhre4nmSXYuQNDv9YCtSsbjsZw8JZ6Ja40naWxTir/hG+sGavToYTlON62eml0JscSB8KEPhEDgyRBzRpp4l13ig0RcbiYr1FbWE8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TYB6kTw/; arc=fail smtp.client-ip=52.101.57.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TYB6kTw/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VtQzj9OIxPYjROxUttmkhFPzEchseSdJihpr47347VL5fu3VMTVJdQMCLxqTeRCSwfVy5CXjKPdNaB39I5Gxz62FYtjQB1KtlZa+/bcWaLMZ+cY/LrGBSKL9G2qsI5BEQqyVeaZ989DUfK2Y5irUZWNpPIncDyN8G0Vo3Gs5jEwoFqoEF4YGn68K43dtqZAqiSuJDW8E1mMeoHdZD0o+oqOzp4cGHcwdFN5VCQMnItnwXd265ty+fM/EB/5vQ2Y4ImMw9tyO8CpbrmRJP/n2NbPzt9FnHxNJY88wBbDxWfIYunaMmFgBvTIgFJjEnUAYVF/SwIl1L8/HBp/qgTDgYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WWRHdzTsAcL6pEPoDasgkI9OaogCytgRC+/HbnAi5oA=;
 b=pmE5L6cwWoxg7Zxlw303QxLPAN5zBMoP73Jg93VxcYD+XRctrqDnDtY5eKwNLiB8nPfL08aCLFJ5fP7KFukwEPZdVF/9x9tNstOiqZuMa463e7tdpQ+e2Cy/kwDTGD7HMGN3ouiRzi7/EV7vttUJXnQaBh74tm6aduGMgO4K/JjjEnQcwES1DBamHoVxWprqagXooh0I6nJWmaev3D4HPesgg5BIeTT0k7q1EwBxGVfPklLTTRiHlej+uX17W3e4xYfH7+3W00kksqcZO+L1aYvO9ui5iWX1WXvxjlebGq+Edz0AW6fHOsciwdfRpycp6KtLLvVRkoelCyQqpOZGkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WWRHdzTsAcL6pEPoDasgkI9OaogCytgRC+/HbnAi5oA=;
 b=TYB6kTw/Wps+qZLx2mpyOD2sTNdi4XWQtGIecj3aVzfr61tdRxzT/DnD+VDgfSv+KBLSPFXq/baz5WOL9HSWttU72VVDhYzRIRDA2Hp30B0hvS3fNbhHQqz0ido9Tj/0BmGHBubNqIX8Syco2JVmvIDw0Qj330vLCzO+iSBQIU0d/NDNOnZ6CCuPB/eQe+lkUiDrqgayA4xPATGJvcjuYfDIpDqAyLOKsOxO9h/ELWVPWk+CS9TZGiHnWCtkuBGk97EvAkHGeAwGAYgqExwg/qNswR4pbPAN4i5aL9mXBSHw8cmKpERbzPREhefBgWYK6PVPwigak/WENTNyh5nOYw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB6485.namprd12.prod.outlook.com (2603:10b6:8:c6::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9870.20; Thu, 30 Apr 2026 15:16:16 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Thu, 30 Apr 2026
 15:16:16 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v5 11/14] selftests/mm: remove READ_ONLY_THP_FOR_FS in
 khugepaged
Date: Thu, 30 Apr 2026 11:16:12 -0400
X-Mailer: MailMate (2.0r6292)
Message-ID: <B1D68BA2-11D2-4053-B715-F7704ED784DA@nvidia.com>
In-Reply-To: <20260429153538.727855-7-ziy@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429153538.727855-7-ziy@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: CY5PR17CA0049.namprd17.prod.outlook.com
 (2603:10b6:930:12::33) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB6485:EE_
X-MS-Office365-Filtering-Correlation-Id: d94ac013-32f6-4dbb-3e13-08dea6cb6c77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	su7oXi+YgJ/gAWv/zj/n3TDs2GurCjIZduAh590fsMyq8hFGgCFSftoy5QeH11DoJyI0XQ9cFSmZkcZng7ntBLuBECycUs0USSc5+ThYZVbpJ3zjx00XxYAKh/n9BC3MvLkOdnimfav8ok7oRWIW1gsw98ucJGs8S7ycoyx3q+0eAiOjMPs/sAp5S18/JRJdwb2DYU1qcfjYwU7QSnAmUN7+ItmArLVY4c2XKdXo11XBfr2U5fqsIIh8ZTkHHZ1GykJKB/YZxrill/qA781VJEYhl9Ef0WpZELk5t1q9cwew1PvNsTJ6yH7smTO0abN7YkKRX4lTP7glLxGi1YE2fnhUZj+3CJn2s909C+hL3MpVNBwqRD4MWfMjE+PoEILm3F9TRDmZ5ymTN+EtNtYsFJBFQF4AvBuYZfDOSTrBd0moqn+qheJW9LTOfkuqY8DpTvrVeBQ4uFh3rt1bJHodRfDVlTKKCNpTyj/LiRrw4RhCX/F0R/PmS8LIO0Bm0r6LPoHo1MMKzURm1j80on1lP/PiytxrP2ZL+it2wQVhKBAfooX1c+Yvg1robeNGA1nTstVEqhKGmhNKSPYnUfe/V+XCMS2oltWz6Iqm42qjghb8Na/CcMsUxvLufc5n0qc6vZzEWdHkEzp5sSGHCjqTwe7eh/U3e19prYHWs9e0b+77Y85Wcif9yuHfh/xr/7uj+suk/Tu/AumKtwFC5PymF4UObNUIYXz4IU3yBxxrYfg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6Qo6l91LHR256GgTsyJxwCr/7YxWzKMW9I4sPSaE0ffAVQtgTyB2urWr6B3a?=
 =?us-ascii?Q?XcPQmUxb1EjiJLveq+3uhXQvT4BjfpxBlwFgeDCOvglANKYvfKUDWnUX/Xuv?=
 =?us-ascii?Q?upBkSMxYrNyf1sgwHTEaRWyxxtE4Sl0yKJWq3PMPT+YTBR/cTjqDp0YGy/ge?=
 =?us-ascii?Q?xVbr7Acoph3Sk6kjqnRuNUctKvUGFGq+wBc5jdZfMabborZT1056cIpIAG59?=
 =?us-ascii?Q?GDR8f3PlzoWgTXEVF/+mw0zvZJ5OveGAn0MO5Gw/nsZpL9RvkVfsFdQnqA3g?=
 =?us-ascii?Q?MkgmUlXf4rIF3lGLD1PKKeRJ2UFllScW3WyRWI/Tn594EwDQg6SxQOFkHd3Y?=
 =?us-ascii?Q?tlwdSJjlfIijzwZGBbPPScyNe/TO+SocvZ0WPmUXxtFcfAw9JDQw6hMxl2cp?=
 =?us-ascii?Q?yURRRzznZt33Mn7GgSTLGgcMF9087XJK1cEZCtU532w7Q+ETSyCOcR+rOVjX?=
 =?us-ascii?Q?hSnOABasJWBy/5Tkdc/jo/0plCqgHToZ9QVIZgd6rfu2c0Io4TL9rfd2VWQE?=
 =?us-ascii?Q?c6OUVzyYQrQOwRbtr2KqMR0RFzNISQaazMqmZMg8sV5pLRrcZ/Ft3Kasmknl?=
 =?us-ascii?Q?Tyu8wZuj4IePi50kLrNuQs7FzkDkja69c0JRTUNPvJ2PWSsgrOtKZX2eb78t?=
 =?us-ascii?Q?x3Mj3JSXGYtVd+FWI8ij4jNgmy6Y9oS0tAFMJV5O0ThH++LHJ51szSevkrWM?=
 =?us-ascii?Q?ZvXV/fUgeVOnBgM5098gpjDJODDltNicaOPYduzd8Fsj4ZlaCgZ9vpFEhdhv?=
 =?us-ascii?Q?WlQCESdnLpxl7X2nEqPRraQorMmQIlTnWm1DTEPG9kTzTn0E56EM6yTQrYbH?=
 =?us-ascii?Q?vBno5lbJoJ2TdlqMqzrgIiwhSLV6ShzRq5DAEd4f+ylCSk+xU6NQ0X+nSCdS?=
 =?us-ascii?Q?pYOSFzQ57QnAhKTPLc15X3RPsce6nkCsnNoAz8u1fh1QDODJe8xZZ04ivYJy?=
 =?us-ascii?Q?Gtnzkfntu8j6IrOMAes72zyaeigTIKFNXMFoK1qPYdfB3zQizwlD2JOllED0?=
 =?us-ascii?Q?hQOaaHyoKO19O3n3HVlajPZ1tvqEFMhxGHPUJSXJNXu4ukjA7qhyReTiFPfa?=
 =?us-ascii?Q?o2jW3yrmxMihtmsN9o2K0QG6O33676HmnOauQFkS8HYcuz3Rjckq8ElqaqCi?=
 =?us-ascii?Q?+u+Xz1WQOYBVLmQwAXNnGNloCSYb6p/jWV+iJPS0bgLSAloIhny5JiAbL228?=
 =?us-ascii?Q?wNm1krRVysqew3LgRugbuXu0OvD1DkMaG++qCX4c7OfcFV2GRQ8OU8J2QblK?=
 =?us-ascii?Q?XKfiGP10gQxaldgfb4SGP7xSsvJaproj3+TWZHvW63Y3BScu+b/UZQXbKM6I?=
 =?us-ascii?Q?VKieyx++DGmMjNwLsMiMi93+c8aImlu9bEg06QATpZ/vWy9Yk1I030T99nXY?=
 =?us-ascii?Q?y5RknbHLiyrC0Emp7DTxIquqVlQBdAjk7vOIRc9lI7et2fCmHZuq4QbYtCZj?=
 =?us-ascii?Q?LeT+2EHu9K1rs6FkFMLORRLKsRI+8cyOlH/X68Y057f0zGH/uvSfDNayBPWm?=
 =?us-ascii?Q?mC77opd6EEDjlF+Zyf+62zo/KFWfWOvd24t4zhm1tWKQV368pjqEiOF2WrpJ?=
 =?us-ascii?Q?AiLJQ55adgyq8k+I+61LAV++zGAQYCIf1LVE/d06ikkq6OR/L1Iywgr/qT0D?=
 =?us-ascii?Q?+L5YepDqruviL2cxMARuVs2ToHb6wkFpHU0Tog1HToiBSPbdJkqlauSpELTg?=
 =?us-ascii?Q?zSdJx0AUvmVdf8omf+qpz5YOSoiQOaCuzw9RO5eFvxXXRYvw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d94ac013-32f6-4dbb-3e13-08dea6cb6c77
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2026 15:16:16.3303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ac7kGHXbC/rcyCPsh0E2EJYFk/FBmHs3ZKn0LHBf+c+h/FmJZfC+U2XBQZEgddYp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6485

On 29 Apr 2026, at 11:35, Zi Yan wrote:

> Change the requirement to a file system with large folio support and th=
e
> supported order needs to include PMD_ORDER.
>
> Also add tests of opening a file with read write permission and populat=
ing
> folios with writes. Reuse the XFS image from split_huge_page_test.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  tools/testing/selftests/mm/khugepaged.c   | 131 +++++++++++++++-------=

>  tools/testing/selftests/mm/run_vmtests.sh |  12 +-
>  2 files changed, 102 insertions(+), 41 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/se=
lftests/mm/khugepaged.c
> index a6bb9d50363d2..80b913185c643 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -49,7 +49,8 @@ struct mem_ops {
>  	const char *name;
>  };
>
> -static struct mem_ops *file_ops;
> +static struct mem_ops *read_only_file_ops;
> +static struct mem_ops *read_write_file_ops;
>  static struct mem_ops *anon_ops;
>  static struct mem_ops *shmem_ops;
>
> @@ -112,7 +113,8 @@ static void restore_settings(int sig)
>  static void save_settings(void)
>  {
>  	printf("Save THP and khugepaged settings...");
> -	if (file_ops && finfo.type =3D=3D VMA_FILE)
> +	if ((read_only_file_ops || read_write_file_ops) &&
> +	    finfo.type =3D=3D VMA_FILE)
>  		thp_set_read_ahead_path(finfo.dev_queue_read_ahead_path);
>  	thp_save_settings();
>
> @@ -364,11 +366,14 @@ static bool anon_check_huge(void *addr, int nr_hp=
ages)
>  	return check_huge_anon(addr, nr_hpages, hpage_pmd_size);
>  }
>
> -static void *file_setup_area(int nr_hpages)
> +static void *file_setup_area_common(int nr_hpages, bool read_only)
>  {
>  	int fd;
>  	void *p;
>  	unsigned long size;
> +	int open_opt =3D read_only ? O_RDONLY : O_RDWR;
> +	int mmap_prot =3D read_only ? PROT_READ : (PROT_READ | PROT_WRITE);
> +	int mmap_opt =3D read_only ? MAP_PRIVATE : MAP_SHARED;
>
>  	unlink(finfo.path);  /* Cleanup from previous failed tests */
>  	printf("Creating %s for collapse%s...", finfo.path,
> @@ -399,14 +404,15 @@ static void *file_setup_area(int nr_hpages)
>  	munmap(p, size);
>  	success("OK");
>
> -	printf("Opening %s read only for collapse...", finfo.path);
> -	finfo.fd =3D open(finfo.path, O_RDONLY, 777);
> +	printf("Opening %s %s for collapse...", finfo.path,
> +	       read_only ? "read only" : "read-write");
> +	finfo.fd =3D open(finfo.path, open_opt, 777);
>  	if (finfo.fd < 0) {
>  		perror("open()");
>  		exit(EXIT_FAILURE);
>  	}
> -	p =3D mmap(BASE_ADDR, size, PROT_READ,
> -		 MAP_PRIVATE, finfo.fd, 0);
> +	p =3D mmap(BASE_ADDR, size, mmap_prot,
> +		 mmap_opt, finfo.fd, 0);
>  	if (p =3D=3D MAP_FAILED || p !=3D BASE_ADDR) {
>  		perror("mmap()");
>  		exit(EXIT_FAILURE);
> @@ -418,6 +424,16 @@ static void *file_setup_area(int nr_hpages)
>  	return p;
>  }
>
> +static void *file_setup_read_only_area(int nr_hpages)
> +{
> +	return file_setup_area_common(nr_hpages, /* read_only=3D */ true);
> +}
> +
> +static void *file_setup_read_write_area(int nr_hpages)
> +{
> +	return file_setup_area_common(nr_hpages, /* read_only=3D */ false);
> +}
> +
>  static void file_cleanup_area(void *p, unsigned long size)
>  {
>  	munmap(p, size);
> @@ -425,14 +441,25 @@ static void file_cleanup_area(void *p, unsigned l=
ong size)
>  	unlink(finfo.path);
>  }
>
> -static void file_fault(void *p, unsigned long start, unsigned long end=
)
> +static void file_fault_common(void *p, unsigned long start, unsigned l=
ong end,
> +		int madv_ops)
>  {
> -	if (madvise(((char *)p) + start, end - start, MADV_POPULATE_READ)) {
> +	if (madvise(((char *)p) + start, end - start, madv_ops)) {
>  		perror("madvise(MADV_POPULATE_READ");

Sashiko:
Since madv_ops can now be either MADV_POPULATE_READ or MADV_POPULATE_WRIT=
E,
will this hardcoded error message be misleading if the write fault path
fails?

Answer:
Will send a fixup.

>  		exit(EXIT_FAILURE);
>  	}
>  }
>
> +static void file_fault_read(void *p, unsigned long start, unsigned lon=
g end)
> +{
> +	file_fault_common(p, start, end, MADV_POPULATE_READ);
> +}
> +
> +static void file_fault_write(void *p, unsigned long start, unsigned lo=
ng end)
> +{
> +	file_fault_common(p, start, end, MADV_POPULATE_WRITE);
> +}
> +
>  static bool file_check_huge(void *addr, int nr_hpages)
>  {
>  	switch (finfo.type) {
> @@ -488,10 +515,18 @@ static struct mem_ops __anon_ops =3D {
>  	.name =3D "anon",
>  };
>
> -static struct mem_ops __file_ops =3D {
> -	.setup_area =3D &file_setup_area,
> +static struct mem_ops __read_only_file_ops =3D {
> +	.setup_area =3D &file_setup_read_only_area,
>  	.cleanup_area =3D &file_cleanup_area,
> -	.fault =3D &file_fault,
> +	.fault =3D &file_fault_read,
> +	.check_huge =3D &file_check_huge,
> +	.name =3D "file",
> +};
> +
> +static struct mem_ops __read_write_file_ops =3D {
> +	.setup_area =3D &file_setup_read_write_area,
> +	.cleanup_area =3D &file_cleanup_area,
> +	.fault =3D &file_fault_write,
>  	.check_huge =3D &file_check_huge,
>  	.name =3D "file",

Sashiko:
Both __read_only_file_ops and __read_write_file_ops use "file" for their
name fields. Since the TEST() macro uses this name to format the test
execution logs, won't this cause both configurations to produce identical=
 log
output?

Answer:
file_setup_area_common() changes handle it.


Best Regards,
Yan, Zi
