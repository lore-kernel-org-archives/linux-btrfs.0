Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012027.outbound.protection.outlook.com [52.101.48.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D57037E306;
	Mon, 13 Apr 2026 20:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776113499; cv=fail; b=a8+qFKs+tZLriGiuobSXL3Ut5cLLRuA7i9RTboVeAooEVQx/0OvVObhYiyov0lqwYmB0UfQfQ623UydAgz9aX34fRl5C15MdlUylb8QS7NOOFnk/OVMsRUR6FNR+XDwd++7LTPtH6zA82s6zq+tPopTi2J/3Upap4i/PUkT4ch8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776113499; c=relaxed/simple;
	bh=x61aJ4ClOo9za8X+5VCiI2t68T4WYIHGwzqB8kJfNu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qE4R+Pkgwb7DFPQbOGxH31l0AoMIozDANrukvI6+5cMSp5hC+d5zA5rOEi1K1DRwmCCnA6asvABK7TZt/uqadHwcD8Pl81j0negFpFzyy8tUYQ+j4g3SdrLr8Z2SS2cHm4L98CrYt4WMfvUbQdh1zb9ZqXgltZe3Pr3ppQK9/VE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PIxAu9Gs; arc=fail smtp.client-ip=52.101.48.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PIxAu9Gs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RJpYKwZLPNNtDxvKX8IVouaj6w36mZMyOCC2H/yP9Uo2QplBS5znKfF+h5QXVgo8rx2N9NBOWsuyS9haBYPteuSH0Og02bWzvvbvishji7dfokZyaUPJxjalF1JXXNo06HjpzFCJ/bIzi79CWhK8cfakZIZtmasIx8VhSQo0maXMjDvXgW28crg+4OXIWnw7Billcff8hXx/QNCKiY6FmOYAyPSZ6JM5Bi7jSAVFcL/rgfXKmf7FvNOQemG17hqy8o+tqG/fW7eIyTsW2oG294GtpukzKj+X/wIbUKlRwUra8cORO+FDgu5pbqxB+PUuHOeI+TOKSYUJvFV3CuOuUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HgNnPZ9gojkYO19I2YySqkRIermST+JPU/nKrrzlkBc=;
 b=jYIo0gcEtli4iBO8j2bWxQfE08xQqei4n9inFqXEBx0TqqLVP6/PMt9WTsPztCpzpZmTvvorvTVESBkhXeqx8PHONvZ+LWnd6lfVYrPgqxnt9SDYFZZgDSpiIGNE4SjPEADSWRHDS1+PRIgYUoVXAe6AhEKGA7m2b+Ygunh9fods/Pj8BI/qZEvWKAUdbVkPs37qA//NGgf9wGgtfiXbGKRAM0asdtZPlLIpgKHLAcTGzPkWwtA/l+h/n54M5H7tn7SvLJ+uB9ByAIVdEqZFfm4E48q3CjoXJZElsjxC//fpyf+9g4t4AD7IsH2C4gkygGfpEfMVJbKaP1jerMW9gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HgNnPZ9gojkYO19I2YySqkRIermST+JPU/nKrrzlkBc=;
 b=PIxAu9Gs9/bj8MPgU8Fmy0gja0jKjnz2ogb4fxAoFqtYBT8KKOZS5gpHyx29R/fJf89xzFrrHvTG3A0neTpYgSUFKKlETgVjkoWYU1on6EcW+eT3wgapfnqWv+bdeTVIS2iI6LB0AKPsbiVgDAKGZr31b+XbtNlbHU2SGzvDN+8smb6xhWYeAEcmKxjIJPiwPkqkA3uplMYV2CovI2sXRVclLF4CJdonD2XulHA26F1uAkVC9c8A1CWblp/w4rM33yw7Z4I5EOeshiEy+QlgK0WIUWp+DU3LsvXk/HfH/6DINsJOcAPhSNii1nDpINwI/zd9U/Fo/+aRAyCBKQbiyA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CYYPR12MB8871.namprd12.prod.outlook.com (2603:10b6:930:c2::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.48; Mon, 13 Apr 2026 20:51:31 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 20:51:31 +0000
From: Zi Yan <ziy@nvidia.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v2 12/12] selftests/mm: remove READ_ONLY_THP_FOR_FS
 from comments in guard-regions
Date: Mon, 13 Apr 2026 16:51:28 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <E3268570-18E4-40AF-92E5-931A8ED1C9B5@nvidia.com>
In-Reply-To: <ad1WTCR5Kld-tiL8@casper.infradead.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-13-ziy@nvidia.com>
 <ad1WTCR5Kld-tiL8@casper.infradead.org>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0018.namprd13.prod.outlook.com
 (2603:10b6:208:256::23) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CYYPR12MB8871:EE_
X-MS-Office365-Filtering-Correlation-Id: a7310ce7-e331-4423-7ee2-08de999e70fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	5JNTdKkADCmdeFKfmTh6ATeFuyWMLsv6KGrpodqKFMeE6C0c2jSXuiOC4kXhY9BHORs0z1A4eRirvOY5LssdWpxtMeZYUbmKImHj4BCAu4CqV/bZiaoi5nDf/4qvUwfCJh4oVK2W/RnztTj1oom73JEc+rLCntyUS3Cv0Zl6RH/0GD9mYt4YH6OrEVFaXf5yLZY4zpvZCqWaEagJ+MvIFdJTjoxFg3PyMcGwZ8joGSlPq2ZpS0DLeLZQe3UL8LMyS/zZ5/4lDN8D/jwlOthePESzv4Q7Ae1d/V2KjsaeZewSylphW+UmH7Gt5cc8bcmQ43aO+LbymDIW+AWrSbbS4D2A8pZOtcJ7ulo24RnnItoQSKqhekBvPI+ilW1Hmp0xP1O6yUfB+H6aNP5eNpr/8+zp4BD26iqbwptNJi8XN4OK/edJOUMBRZbLmBLY3RiCTXUkA9gZ84/QGgTMSuiSdz4N3qoxAG38I1dpwwc7uAWk+XZqESRyQBADZUqILzg5gMK/xQUeE5MUkHkxGFGQsfM9Ujw+ATUMXxSHjZZ6aEZJgMPu2VlMlUMNbhlaONsTCC443u/CSPaJLvsMaOagBzcIjAKF4nHA5KP8ITuTO0uPoNLZoeqQF9Cu+auhznSK7s7di55nzz0eqfzjEkgkHtVEhY5jHP4AW7wYJOsLNOPxTS7cokUgFRqw5nLkvEPvtsjUHehRyGF3cHtQy+PkH5a5bygCPKCI2FSBGS5kSNQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MTLRMkINsVJNuvGL1iVskdqWlnPsa7zQabFZX4/YdfDMtybN9FoOqqTYH3m6?=
 =?us-ascii?Q?h8L12uNODRDaauomMVXn80QzZDomalaLuZ8KfrjWkpsMN9J4him8Cy6nvKO/?=
 =?us-ascii?Q?stLRSNEobe5ENoAp8Cy0l67bDceFZ4Mzf77/9XgL/P/KLpGxlh/MBh3NGLp/?=
 =?us-ascii?Q?ubk08vfFgAQf3Y4yJ7SnjDGY/OedMB5dA8y22W8U2jdaR1ChUCEn9RrFg/0Q?=
 =?us-ascii?Q?qlg6drUIw8FN7rTODqB+S6r+yz1ZuIXvfQ8w3HzJ55OJGklf0pRexfFkHkgX?=
 =?us-ascii?Q?GD4upabkkxzNHNUnxp3iw6wX9IrSvlnlfl8n1SdJcUSNUQoND5ovLGhPyXFr?=
 =?us-ascii?Q?JvLCQYXPaQGsapjDloLmc5zG76X7sgCxQV3EtOZ6JhQdb/IL7BiYkJHu0UpE?=
 =?us-ascii?Q?sGEOb775aUsQscYbJvbKJYNcPnt72En7hwHPD3UmXIwSOJQqeFXlTxmdciFO?=
 =?us-ascii?Q?uBSa2Cc4E3htr1QRH+N2sZTT8wXtMxSHYWcYrVQbR0jFxkAFaebX9wr40R4L?=
 =?us-ascii?Q?B8WXrKCvSqBPclIIThWu7HF69e4thKDh1ORJieXt5nVnTq71Mym1eQBPncXP?=
 =?us-ascii?Q?VwQAI2iYvtiLHWTM8sdu41UvPHTt/S6fJU52toiUKUuVVLUNPP6hWx6y1ChL?=
 =?us-ascii?Q?VoOtCMDp5LArrUff2Q9sh0UMwt9lRBInv1r3Lbap7cN6a676yuOxXJoSe/IX?=
 =?us-ascii?Q?EbCAREw0RM4EC66B+UXyH2zRbr/bZa/CMWi2U9jhQLE23ftVqryfohvAb/70?=
 =?us-ascii?Q?7AasS9JrXlS84yUcLRKkKqjvl4EHYWHhMkevF7mG5yd7HrP4zoydWStGi8zy?=
 =?us-ascii?Q?D620v5T5vs69pbyPWvsRcRxfquKC29O4OVsO8Li0n9rT8yxX9p0zs9t7Z/Mn?=
 =?us-ascii?Q?Kp95gDVntv7u2KY1wmPy/nHOoLKx67n5/SreVFuV9Eues/SsEJXwN4MIJMuO?=
 =?us-ascii?Q?cmCLgZknHUuBStIJncDAnt9+rh2nvDqJsU0XXWOceB1tysr7rpwd3hJcHfMB?=
 =?us-ascii?Q?TK4qqrMgF0Lp97ArESKyHlRwcopkbhT+QU6tLRu19hCOa+KtBgMOCvkLBUjR?=
 =?us-ascii?Q?6iAbP4MlV2EkMNDTPRVJHYpTgYdLTl6OXx/jHohJlpeEhgUXATT34HulAGZG?=
 =?us-ascii?Q?wXvrIqBHydVaBuOIa1kAZ/ND6tID2MY/hL0hSiakCYCb0F/HEW3Lh0od/alw?=
 =?us-ascii?Q?kraDXAFjhaSAvmvnZGTapj6JneIBZy8Aw9MSLnf1EGzH30//GHoTeaZNoAwP?=
 =?us-ascii?Q?uHEBXuznVY6J0aKY/BAx1GOhguYmT4XYQmnA9MxFqa4e/M5Kg/hTM64xCaim?=
 =?us-ascii?Q?d+sq0kC0iX9Mf1bD2spuTgPs6BqrFmRLw5sijAm0imDpFiglBAosPTGkV6nM?=
 =?us-ascii?Q?UUoGIBzdPOfGTd3+HXnJLHZaAormZl9E2AmoPj6XGhdoGP4FGDeaacA2vuT5?=
 =?us-ascii?Q?bdpkgUlanL+Wd50WY1DNKtcYljasu76kBieK10Ph55gZtGsLKV/AaWg+HSWX?=
 =?us-ascii?Q?ng0zys92VfyFkqbGBVx8dUkG6BK+cb3UlZTK2aB94B1Hmb9enQCDvdMaW+DM?=
 =?us-ascii?Q?nLCquHO5qCgxdmRxy12W0ys9r45R/kZITNdbhL+t4jXO3yfdqXr31k9K+rg7?=
 =?us-ascii?Q?82ytbcOeUIPWCUz5uEQD5RdA97Mwxx5Ife6/t0VrNEvtS6w8Hed/sjMJm49W?=
 =?us-ascii?Q?aJuJ1isSifbmKj4IBJd/DrT2Ak0eRg2pdOVRlkD9/b5FGp6BNJ3fH8WWK2Fr?=
 =?us-ascii?Q?uR//FDobLA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7310ce7-e331-4423-7ee2-08de999e70fe
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 20:51:31.3874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yo19esFsH13yure6/aQerOaVhvaCxe+G5tl1QzwgQnCqPSyV/YsKvxfOVAYG+XHp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8871

On 13 Apr 2026, at 16:47, Matthew Wilcox wrote:

> On Mon, Apr 13, 2026 at 03:20:30PM -0400, Zi Yan wrote:
>> +++ b/tools/testing/selftests/mm/guard-regions.c
>> @@ -2205,7 +2205,7 @@ TEST_F(guard_regions, collapse)
>>
>>  	/*
>>  	 * We must close and re-open local-file backed as read-only for
>> -	 * CONFIG_READ_ONLY_THP_FOR_FS to work.
>> +	 * MADV_COLLAPSE to work.
>
> Is this true?  Does MADV_COLLAPSE refuse to work on writable files?
> Should we delete some code here as well as fix the comment?  ;-)

file_thp_enabled() used by __thp_vma_allowable_orders() refuses
writable files with inode_is_open_for_write(). That should prevent
MADV_COLLAPSE from working on writable files.

Best Regards,
Yan, Zi
