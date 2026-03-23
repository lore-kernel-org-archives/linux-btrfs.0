Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011007.outbound.protection.outlook.com [40.93.194.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282D63DA7EB;
	Mon, 23 Mar 2026 19:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774295239; cv=fail; b=WDnLgzkuEjp9TjyDKoykD5qKdk1QwloVE4D8IyAL1REdYRaesKm989db2YNNNQ77C9JPXPqijXBdbBBRFmp6Vb/C5qgvIFMU9tVlByBblLx3NCMXqhOPvcinA02+JHLEz3/jUB7z1io8aQbqlL4tGgrBfjWF7A7OKg77NoivHHk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774295239; c=relaxed/simple;
	bh=7juzwfkEHS2M/F1MpOo5USAMqOhSkbBUWJowc6Gab6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BLW6VBZqyWsXZWYb0t3PSfSnxNEiAHKNmCdULGokfdTxnMxaou2R+ji0UG3KElgHFdeKF8ctbymIW1PMKvheSkKQYQfZkHqS47ohutoLo8lksz4yjI6Ej1D2yTbA3GlTr8dVJiFL+hVITRbRxPWWMFKIBz2/6jXgWAMIH17Lot0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XYUqQE6N; arc=fail smtp.client-ip=40.93.194.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XYUqQE6N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WIgRgRlu6ZS20wCco76St5DOaAn2oYao3V77No+3trnFo4q1CAqQLgknzST6ESFbUtcweqRaCjUKgY9aZZ4fjFzEYVZEPsnSkYjG/Bu0ApHIzJwfhm9/ET4cFCNgOKBzTAnJm0njm2errSAao7883rsCsnrfJFcuxoAdlXJjNolYybgoHA9SWzTu9AKYH+pFDQ/Y1j/OmNG124oyExJs9YWv4MbCZUnBEo74sYVOWuxEvzY+Maxs7cVrJ+TsN2U8Tw7b6JGyb0qXCYsJTynhpRplCkK0YeIZC8XZ/p366avig/LL1Fx132HG13ID3JHRERxMrbUcsJnFRXJoUzPBdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ciH99q3EKR6091x/8JBfdCEBo/KhTUFldFYlf+SIjE0=;
 b=mEG72L7aPjGuOfSxIHSNQ9uy8lVGWt0QWaPK+/Xircn08ezO1CuBVGfmTbM8nUAv3264/y51tD8+GuIklzwebKx0ElfY12uOOjDgqfxrIBwjLC6WsESS/rR1OAmoCnXcxjnxpsXoTYsC/UyZmlVszPrTjiR8miJTPHoboup0ghX6h1C5Pmvs/lYOu0wCmt6Ztpsu7f22i8oxT1+gfgAJPcaCfmJGSpDidS0KX19tkqxIjcy+Gg7q5gSbamv7KrkrZJTv31mNCEF2S6n+XR6lWCdvNOzgsWKWIkppStkd736/7X8IP70FAmb4T9e0OqzYeeT5W/eFO8VuqkWcpn7U2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ciH99q3EKR6091x/8JBfdCEBo/KhTUFldFYlf+SIjE0=;
 b=XYUqQE6Ns60Z5CVELV/BEknY6Hw7QPx4JwbqJfn8mRs7XSwrs7TZOqPzJwDRiJMzg4ghNKkCkeAwVUF3psNH7enH7ZlYDkv493DIQS5ejXUY82MEkCN+AE5z2gwW+FnHmtiMgpxL6RXLtMpdJW/yV3SL5NOieaojTNMPH6joIeb4q0lv5+sUu3poTaIl03rfz529K7oePfVEhAGaweUwTDf345QAyjIIo490w9tKmcb4eKEjml/UktYYn2cl+gK2AZvw6xkyg7XsqtqvphU0dWxq/XeFBjTwSClyYrn7hJjpjKZRSgi8L2YHGb9R3t6Qk0ZmBRLymBbS44/egbMpyQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB9028.namprd12.prod.outlook.com (2603:10b6:610:123::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 19:47:06 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Mon, 23 Mar 2026
 19:47:06 +0000
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
Subject: Re: [RFC PATCH 02/11] mm/khugepaged: remove READ_ONLY_THP_FOR_FS code
 in collapse_file()
Date: Mon, 23 Mar 2026 15:47:02 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <E8D52134-B63E-44E9-BBBC-258DF74B8597@nvidia.com>
In-Reply-To: <7382046f-7c58-4a3e-ab34-b2704355b7d5@kernel.org>
References: <20260323190644.1714379-1-ziy@nvidia.com>
 <20260323190644.1714379-3-ziy@nvidia.com>
 <7382046f-7c58-4a3e-ab34-b2704355b7d5@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1P221CA0035.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:5b5::8) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB9028:EE_
X-MS-Office365-Filtering-Correlation-Id: d0a15440-f285-49a5-e766-08de8914f661
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	KxaO0cGbS2jAaJOuZWxNT2quk5Jr5LyyVDkiPJeVWmCj0EA98y7i/EEB0fgrbPuAm4eUrwmCQoQS+GzxsjPk/5a/IHDhF2kUJzc+kUwC+Tgp23Lr/nhY5xYstNtfWvhuPG5AzE0SEB9QXlfu2XQCqut5ppRvyiiJRF9niKcXkIXiuuTCy1EHIIgDEawrHbN8VaioGqjspsIkyei1+CVoeKyEA38BXmJqL6gKwxf+AWBCOt1292NCK2SPYVdWLW59Kcn0gop4CZJdiZRuo3CeI5UBglPYdkC218C5Xo6mgKYhFhch0d8FixR8HZ2yVr8m+HUOIGJMV4Ddo+0zWt0VR1vF4pUQLiz3Qmf00HNUXru3uqkIRmrZfId9bmi7/OERpJA9Cv/oRJjNUKo2NSKFJ+lsExuPdc5MO0C94E3FSjfU9zkJN4ge1xrLZIYZ8dCIieepne3QLbWkNtK4GrFgrcv5Y3BjX6Qs9JBQUAsUHAOCjsarh+gmm2XAvLBUdXiw5JAO38xjfyCKzkSTQN/TCD+n9g7Uqo3K+AHgwmaPeY/QRkqxUcxp0cdDXq3NU1cq4tw9wvKu6KExremo5RlAWTj4NKGxitksuj3M/SeMyVAi/PWuzvM/wybhsc1TS/IJmMDu63BwCwiEtClPMKpRdaLDCkFg5rBDX6WfaHunSx9YIDeP93zuXwsR9/6VUOEN7H560ROWHFtVV0jhtcpgnFbop7EoSlx43OoZvbm+HbU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KxiwWQTf1fq7u14JpC5LmrnNrITAwDxbm22/pYLhEkzlLJAK1mMY/rmhe+gA?=
 =?us-ascii?Q?Rz9jhM3lCjuO/PivlbOB6DFQuAXvAWXzAhWdwz4hz5Lt/mYEQZeX/mCtSnu5?=
 =?us-ascii?Q?OFgfhKMgTBWprK7B3kGS0FmFTQPmGrBVWGmyt5s0iFwKcuj8sHkQZb3uEHAX?=
 =?us-ascii?Q?perC76ZPmq+uMD1XLeT5mveAhzQ/2ZOdYVZnqPyJFaMFGruqk40jg9QO+eRJ?=
 =?us-ascii?Q?tTDvoTHQMYfpzh5Xubc5XqqXJMNsAiow4yMG+OJHDjZ/JE8X5Y2wY9JI83Gk?=
 =?us-ascii?Q?SYm7+nr5Xg4Qav8SwtHf87JukAIhd22aO1JWQrqY1ju4jrp0EQxzcPHNnZn9?=
 =?us-ascii?Q?90T3Inu+wHLh3tjo147C+BPkz5Uji17LYok8GvqCfu3P1COgugI4+NEgXKWq?=
 =?us-ascii?Q?11Osu1D6uNSl7r5xnhcwN64vT5L6QpisQi4CynsUZaiM5jefR5EaYXZPZxhg?=
 =?us-ascii?Q?gNrl8Ykko0tGOtEZGUsL+0GhdxKGP+UeRRns1nHc4XZ0lNGSAJ15aMLlOpiZ?=
 =?us-ascii?Q?14XClt5h2PbE/qN0sKXDaMmbrDFMXuxd73JrAleea6F0suW040x5hWakt5Hd?=
 =?us-ascii?Q?ICTCR8tOInm+4L2MVnOrpHai/dMFbqEHxjbjXZBb4U1eLKRgXcGsWCuXq4z2?=
 =?us-ascii?Q?edq+BvBlknB/bMREn5ISmY2GPt6DWIyd5lbPEQrlRv00fdQwh0iTcykmuKjy?=
 =?us-ascii?Q?CPD2auZB/YoRO/MV6KVpZFjGliERNUh7gdlg2fNi498ymLz/5Hzd0FYPpRua?=
 =?us-ascii?Q?Mvbq2TTP/HyHBWuaLg/sm0X0XITFY7WcJUUw1xVfTrnyAztOYmrZEKixsM4k?=
 =?us-ascii?Q?HhBfwSrM3kSn9+wodU+JcmNR9qB5rxQOk1mRYPWTzoTLxI+mBGgu9dCVT4K2?=
 =?us-ascii?Q?cNt2GqST6Kj/V6PgP1ir2PL6lwWmMkp1iIMZue4ZvPAJ0eSGFlGJ/UWa2Iea?=
 =?us-ascii?Q?jfKlncFJvwxvzePkjIn+tAGPJM2gl/NaDpvIPT5mxxpUpi5NQrfmYZSPIf8g?=
 =?us-ascii?Q?IeeWpsiYuaIaZNc/B8EkYz09NNcz3ngUHRer7yAq2uD1h7/lytd1qe9N3dMe?=
 =?us-ascii?Q?9pz2MSZMzcvCCt0NGhD7B/i8cS1kHf0B+NT2HnWzsc6lus8/rvQ3yrSZlij+?=
 =?us-ascii?Q?A0vhL0CylIznhYgxwUy4QxDyU8dQ7Lo4baqvqm9gCMz7QZBu2ZSlqxLRkXfS?=
 =?us-ascii?Q?3MMa0Dr9zlcmf5hZMOVKhzFIN6RBZ0Oh1lS3x6KTY3VR/oHfT6NEkgL29JZa?=
 =?us-ascii?Q?b5n2SfdTbsN5siJd3yAtqOWc2JBgCSPNol9D0mVsxpQR5oDEBbIAIzK6yAQh?=
 =?us-ascii?Q?kMa9Recj9Od7qXhuQaTdf+6tfK1s4FRubSpiiu1pIPXTsPcfzrXdLyAddkLk?=
 =?us-ascii?Q?fN3w76KXZU3jpqQdJ5dRLNV6AYokT0psesxGFtq00bdaGoQznP28LpuufVCy?=
 =?us-ascii?Q?otMBOa/I3oYNTaSZu/nnapv/3J3JOu8o08tIInbucJmHjhgl7qZtRN9ip0LK?=
 =?us-ascii?Q?rFRdyymgse6WqHz5Y5j4sB2ls4jBGA5St0PbVVFT+KkXRXAerBY0yYJRSX57?=
 =?us-ascii?Q?MMF7Ed06igIq6BvrxjibRCQ5bPnJGqGIDCQTnRFyDlmvnYXQqkb5smp/vWql?=
 =?us-ascii?Q?nXjzrbJP12JQpVX3qnlC2iWmu27j8OajOyv38cj2QHPk5To/SKeqk56JM1wd?=
 =?us-ascii?Q?S3r9uOW4XYKfjdy0NpIq7vm+O+69PNYeRr5T2uldLwUOYmiEHWpJbJu+cXJE?=
 =?us-ascii?Q?UjPtl0VFQw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0a15440-f285-49a5-e766-08de8914f661
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 19:47:06.1054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8vBpcZZBQymR2+SdNmulTzw1PVRErvtY4E5unx4zMs92XlRhGebOOMhrrVF+FEEf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9028

On 23 Mar 2026, at 15:41, David Hildenbrand (Arm) wrote:

> On 3/23/26 20:06, Zi Yan wrote:
>> READ_ONLY_THP_FOR_FS is no longer present, remove corresponding code.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>  mm/khugepaged.c | 159 +++++++++++------------------------------------=
-
>>  1 file changed, 34 insertions(+), 125 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index b2ac28ddd480..39f0b8959535 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1899,7 +1899,7 @@ static enum scan_result collapse_file(struct mm_=
struct *mm, unsigned long addr,
>>  	int nr_none =3D 0;
>>  	bool is_shmem =3D shmem_file(file);
>>
>> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>> +	VM_WARN_ON_ONCE(!is_shmem);
>
> Oh, but if that means that khugepaged cannot collapse large folios in
> FSes anymore, then this is the wrong approach I suppose?
>
> I would have assumed that we would now collapse for any files that
> support large folios (in PMD size), not stopping to collapse entirely.

My understanding is that collapse_file() is only used for
READ_ONLY_THP_FOR_FS. If FSes with large folio support also use it,
I can replace IS_ENABLE with mapping_large_folio_support().

Best Regards,
Yan, Zi
