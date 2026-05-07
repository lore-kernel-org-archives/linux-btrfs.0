Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010031.outbound.protection.outlook.com [52.101.46.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2141EFFB7;
	Thu,  7 May 2026 06:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778137079; cv=fail; b=NOiYHAc77HB74MMmtD/xk1uTIzzKFiYRCV0R4o/4geZ2eB9kN3fhbeohpK+REUPqStJfJ0uP+Ng3HXRv574SLHcy1LuG4h2VEBhyM6OGWgqvg672djvxGw93jfT6nu9+srVlgRhcymmOm8jhEq81Dd2av5HLt+w//vBFsvtm9hw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778137079; c=relaxed/simple;
	bh=0r1n0x8VTbV1kiR7thvgz0mWFRG7ANfH0XvmU0Fzcqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HfCHoqjbn5AukDKD9nrhooJyjzqgg6K99v+wfbS7S26W8JRxz6RjxSKalzg9ztTzBnUkfj5Gm9VDyy6Voz3NLqqHQv2jdZeYI4X51HS8HoVHlRsseLMVY1m207Pj40yqbdvUFAcNvyn2ACWGq2GV3ArVt3JrPxLWRYl14HcKYpU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TeNhhV/T; arc=fail smtp.client-ip=52.101.46.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TeNhhV/T"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RM9XYjmwNq79c1e7wYTFkO0jWcIl1KfDgIdMQDBbgTfrtm26xVz2aFAtDHh31OiBAuHlpEbEPFqL9yM4EC3si8rWEi8hm+eXOSyFsiUscstLrK/fp8MPz6RyiOgu0XcTZUg9pJ4lHJvwv2zSNLGA+8P+09iJynTZG6Dg6Ct3ctP1SA4uWs9U2tLH5na+kR4xws2YwFawE9GvWZfaWrZxi59f9eNjvKgfWTdQS2V4s6ihQZen4aK3iyK73XdlGUZX0GTWToxEij4KMsC9Bz2iKPtf5HGw4Lr242lNtQadhnIE9HkjqQgszZpjSxTApzCORiVZDUUim1xQNdVp/b4iRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R/UDHkR9oL0JcFpOsv9u6tDWi8snmsl8cj9F42i4abs=;
 b=v9gn7rVGDF4+tK/HfuNBrIcpjLrY7U9gjy4XONO8BQz5w/NNTU8arRIrN56Kwtf6p0VcGq9Ee2bZGCg3aTiaGpcwVkSY3wRBpVOoJ+ZX69W7gdEsPbXoARkO0g8aOp5WPknHvl8gMENCX+wK+RsRfVnaS1voyClLRqH7vWWPzsyMg5vRK1kUINyBIxciK/LaELclk/uArpxpHhAFCfnYMmGEEfc7TC255moU4jT9NggNpHUIaREsydmMA7LsjXBLa7s5F93PlS8fOR6ChDgSDly04KG8jUMAx2QU0emlYUlvK2fa+d2QJ+zpDl2H8bVaH+o5/SGT3vJIWLxX9F4xWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R/UDHkR9oL0JcFpOsv9u6tDWi8snmsl8cj9F42i4abs=;
 b=TeNhhV/TpKYH8+uia+h7tPMbjCLxHkXbJNlsJWt4l/3hlB69xMQ7Gjkehytj8K6sQqOdCNrGahJAsk1ZQS4DlNGEQ2e1QbDeqv4pJFB1XVuKEo9jNtH3j3d08+mY4PD7UYbwpMg4gE+QVEcfb+iTs4396Oo3W9/vEolsGXptw6VwDUfrS7my5ZPfkopEOhNun54vIJcvuiBDzP2tJU0LPnuo7HHjlaIrDgwMxUchKtkECkQj7jzjzPAHIC4+WQlg/LYU27RResR5Zyq4rXEZSy9AiJFChfTxbdzI+NLk24fm1wK2fJ3cyTJjTHx6jPiDg8jFAB25LKWgdmFHn3vrlw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9)
 by SA1PR12MB8947.namprd12.prod.outlook.com (2603:10b6:806:386::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.27; Thu, 7 May
 2026 06:57:53 +0000
Received: from BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1]) by BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1%6]) with mapi id 15.20.9891.008; Thu, 7 May 2026
 06:57:53 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>, Nico Pache <npache@redhat.com>,
 Lance Yang <lance.yang@linux.dev>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 David Hildenbrand <david@kernel.org>, Song Liu <songliubraving@fb.com>,
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v5 01/14] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Thu, 07 May 2026 14:57:39 +0800
X-Mailer: MailMate (2.0r6292)
Message-ID: <73AB53AB-6EAA-4077-AFCA-90929F20D17A@nvidia.com>
In-Reply-To: <CCD6A5D1-AF64-4AC7-A717-E497AD2AF15B@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429152924.727124-2-ziy@nvidia.com>
 <CCD6A5D1-AF64-4AC7-A717-E497AD2AF15B@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: YQBPR01CA0089.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:3::25) To BL4PR12MB9478.namprd12.prod.outlook.com
 (2603:10b6:208:58e::9)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9478:EE_|SA1PR12MB8947:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fd3cc3a-ca67-49c5-f7e0-08deac05f5d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|10070799003|1800799024|376014|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	k+n+GlRT1IDbvXwlothoOeSSZ2ZXquf48+9OlvQx8MsksaYfg0BJraJGuzW6yNxhR7x+nur/KlCDE9d7Y9+NVOQ2EeZmzd1pxEaN3+bc7YE8X7LcMXJYhTVoFZVZkpO7rwLnB8nOb8wFFfK3o3FeAtLqxM7Uz7TgEi59A+j+/62KKE89D9swgO2rsRVNzeRJs2L+4DPJ5lR+oCq0wPgqzhvoVVaMe38j8Q13Npj5hIOGec5vQVvE2XQ+mq1w3cWBtebF1vDSjsEcXi1kQiB6WDq++3X3WnXNnpOwOoXU6fW8ZKZAWszbyL6CIzIJQlYuJGEFw18ogXS6p9FH2CL3fzt2cfZODoy+d82gmePZAZL6iMCAVOK+nFV9j8oK9LFSi/WesCxZDSW+AufELXj4/scsSXpj3anEE0LThdf9cKjl7KIe9vZsIKYvkIWD7UU1rMA6HMbnM1ogJ9n+hts5Od911VaEw1OVusmuX3wJl0pZJVmZYOYBGfznI86L2Iyt91erX520PBwtF45pL3TXRPDD5Ismxp05WzUfZ5Xp66x15Ifk8Qq3PgX1KcmsuiTNgTs3e+txMW2mN0mSsVgbWpZ0778SB6ANO9wxA/2oKcV3bMrMB9hUQboh+QKgQwHcXrrHy7LCFSbi/9epVEF8MNtay/ehSyqzrwAM0EUdrx4mJvxa5KZQxHFDQnliNm/THou36eryHrwU9ZS5lGDiFg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(10070799003)(1800799024)(376014)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z6tnSy7jH8Ae/g/oKQutBWd9NUbiAcQCqADPCGXqM4WYK1TknLCQcEXRKtBj?=
 =?us-ascii?Q?ZDHcsqru6J6EgBEGlALkSvaxDtM7Ter4N4kI+CCvYcLY6r7uhltsZ1SzS8K7?=
 =?us-ascii?Q?cF+NE7p6MfDROEeE0ayOCkniNhOnTsid0VP7zNexovRNbUL0t9+2zy+oLZ9m?=
 =?us-ascii?Q?Pd/83RTbJVEOkvb42yB/b9pRDevH06PKJc0ggUn8ia/pmhBezk4dPrHRcc9E?=
 =?us-ascii?Q?D5ZB06IlwbLYjv4mJuW5ygQ3yzcB761lELODTnE4rRyOIymKRwMMc4eJ46xi?=
 =?us-ascii?Q?j3/OSSamcOhlMHaXcrAIy5i0qZbocsDxpT8+P3HVdRAy25xYzznpJZDy18I8?=
 =?us-ascii?Q?y7CUkf1hOBNmp1bWWbqafZMP6WZrIfc8AdB0GLE3/8ovamkxcw48VD+2YDOW?=
 =?us-ascii?Q?39ZLNaSY8eDi4Tvy4O2YjpVjmbpq41yWPErFDb74XrIIy8yZJPW8n7w5B65A?=
 =?us-ascii?Q?ODC3bBU+8z96FYOq8nqtGEDd+IsKbtx4KKoHVMpno0cdD0LemMyMSefcg0XL?=
 =?us-ascii?Q?/kBRW3pts520n9UsFhEKojPewU+l7iLlSCejWyjGaNu17+S4lbxx65WwqjVR?=
 =?us-ascii?Q?ykytTKeQ8WWDuIznQppR5uOsrG77lEAON97K/CgXJzJn8QVFjGK54q8GxcEh?=
 =?us-ascii?Q?QWZdeUvMZw2zDKB8IxQqNl+qZLP1+pNuPSwNE8E+KidsNrledVGFjhLmx32h?=
 =?us-ascii?Q?oCNRW5Sy2rWRAxzWSHxM+Mb4PcsZGeLNve9W94d3L4sXQQKGuJF3TKddXQ7D?=
 =?us-ascii?Q?J5IDZpVlxJrOVY+04LU/mQ2JGaNoSgKhoH1wy0S6P9+Q05KRTTwpthw7lkfD?=
 =?us-ascii?Q?fep876ZkfFvi7agtLt0nwLsT2JOps7tKqz08J/P25pbX3V8FgtwH/jySHNpv?=
 =?us-ascii?Q?gZUwvi5oS01LtqPdc8XVWpLRx+Wlp0faTo3Qg9zEaHBXj/x+AnTue2qOogXJ?=
 =?us-ascii?Q?K2VmPriXgONlimN4yDvMucgutliny7W9nIi0wN7MuQV5Pfki0cz2tLcSB3vS?=
 =?us-ascii?Q?jymo9r/vLUdviYij5Vxxn2pk8YLPDQS9pfJcapPYP/WQ1P8Mow4oBn1xm+84?=
 =?us-ascii?Q?VfzEJfmoaVG2+NZNPumrTkfT2/twYbxRm0qQpZfezTJWzeLKWVxZMG5vkA/R?=
 =?us-ascii?Q?iWmztfJrRe5Lc/qf3TgWtWjnE/JW/cJI8Et4VjA9V5VFIzqsE4DJNXvs0ZoV?=
 =?us-ascii?Q?Vf/9XkcnGctIDvMTCLueprq7135f5P+OsIUZUyryxLLnFjrw+/gaTBW7W6T9?=
 =?us-ascii?Q?MGQ/4MR1uujUX/Rab+rul4WjM4MsLVFwFJRwmJibbntHyYbWyFOy+ThU6sZD?=
 =?us-ascii?Q?GFoHf56/rQ1cxq686lgV62rmD7Mqicih6IvEpYhtUf4H+Y7/hxjTLptyf7Jv?=
 =?us-ascii?Q?0LO0syGEA9GVdJQssAIHOBuNhFlRZRXG+ydrGPYmFFzeV+2vAXQNImUHwCZy?=
 =?us-ascii?Q?LfSbS4oJXzQ4Uyjow51O9n7mhPVijYa8DsjquCguJ0BQvufA45xZh9FrWovB?=
 =?us-ascii?Q?DBM2dLyATniRi50fCFFQb6ohTnekcNnaMPMBYgCcl1xFR8H/W+OTa1J0BX4S?=
 =?us-ascii?Q?8d3kqT40bLd+DsmoXl5ZexwFqPPereIvRYVqh5EAT9wZTwgDz5wvkUdbTPMf?=
 =?us-ascii?Q?5o3xivBAsmT+9LHLmIh178lGjZat7VNRmoIaMwX5tTKVSaSCsSTi3EoBs3vK?=
 =?us-ascii?Q?bOP9GPpZ5EIhsn3kvCCmIEe1A5eVYKkoqLSGA++8pSWHV7iojucBwAeJ/2Kn?=
 =?us-ascii?Q?81zxHp9D4BkFcvLuCoEuXZd6iVs03ntIW4QAdFG91bSLWSWl9nkt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fd3cc3a-ca67-49c5-f7e0-08deac05f5d6
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 06:57:53.3778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p6OFQbwh2hT5cXvVfLpuBI0P0VXIycddfXgqW/uot4wOAO3hjFA6sCMQAcCA/jZ5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8947

On 7 May 2026, at 14:08, Zi Yan wrote:

> On 29 Apr 2026, at 23:29, Zi Yan wrote:
>
>> collapse_file() requires FSes supporting large folio with at least
>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
>> MADV_COLLAPSE ignores shmem huge config, so exclude the check for shme=
m.
>>
>> While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.
>>
>> Add a helper function mapping_pmd_folio_support() for FSes supporting =
large
>> folio with at least PMD_ORDER.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>  include/linux/pagemap.h | 26 ++++++++++++++++++++++++++
>>  mm/khugepaged.c         | 10 ++++++++--
>>  2 files changed, 34 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
>> index 1f50991b43e3b..1fed3414fe9b8 100644
>> --- a/include/linux/pagemap.h
>> +++ b/include/linux/pagemap.h
>> @@ -513,6 +513,32 @@ static inline bool mapping_large_folio_support(co=
nst struct address_space *mappi
>>  	return mapping_max_folio_order(mapping) > 0;
>>  }
>>
>> +/**
>> + * mapping_pmd_folio_support() - Check if a mapping support PMD-sized=
 folio
>> + * @mapping: The address_space
>> + *
>> + * Some file supports large folio but does not support as large as PM=
D order.
>> + * If a PMD-sized pagecache folio is attempted to be created on a fil=
esystem,
>> + * this check needs to be performed first.
>> + *
>> + * Return: true - PMD-sized folio is supported, false - PMD-sized fol=
io is not
>> + * supported.
>> + */
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> +static inline bool mapping_pmd_folio_support(const struct address_spa=
ce *mapping)
>> +{
>> +	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
>> +	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
>> +
>> +	return mapping_max_folio_order(mapping) >=3D PMD_ORDER;
>
> Hi Andrew,
>
> Can you help apply the fixup below? It addresses the concern raised by
> Nico and Lance[1]. Thanks.
>
> [1] https://lore.kernel.org/all/aa778cfc-b7f8-4100-89bb-d2b2ef8e1138@re=
dhat.com/
>

I was missing a semicolon. Here is the right fixup. Sorry for the noise.

=46rom fbd183f7528a3d0bdb421018af4aef45f6366682 Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Thu, 7 May 2026 02:02:28 -0400
Subject: [PATCH] fix mapping_pmd_folio_support() to represent its exact
 meaning.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/pagemap.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index c6a4ecd3d6ed1..41dbb55a47d8e 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -530,7 +530,8 @@ static inline bool mapping_pmd_folio_support(const st=
ruct address_space *mapping
 	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
 	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);

-	return mapping_max_folio_order(mapping) >=3D PMD_ORDER;
+	return mapping_min_folio_order(mapping) <=3D PMD_ORDER &&
+	       mapping_max_folio_order(mapping) >=3D PMD_ORDER;
 }
 #else
 static inline bool mapping_pmd_folio_support(const struct address_space =
*mapping)
-- =

2.53.0




Best Regards,
Yan, Zi
