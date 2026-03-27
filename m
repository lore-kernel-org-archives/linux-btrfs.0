Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010035.outbound.protection.outlook.com [52.101.56.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4EB317715;
	Fri, 27 Mar 2026 01:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774575818; cv=fail; b=p/FSZPsJNOQPqFekhvLp51EXIywZlpflfnJFDVT+YyeYJMSYKz0lo328og9r3ApFQBuYTjLXRvE8C6zD3yslAaDEvXG30f+8isM9G5RuXAXKvHBTFeVjeTXMtanOEtsbVLngbC9hGXcNV0WYpucKHf6XuW+kgnbN6rnxgeTDh9w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774575818; c=relaxed/simple;
	bh=kl+nhqAgppA1Mp/gMWSttAhKOmjMPtelEgmQnKlvprQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=S4STzTXKf6zBqhe/wnPqZ2D+Iska0KY0V0j65ntl1LQAUQvuCLMbnmmYIChcrS5TO+oFjdGJJOBFCLkgX7YE7+K+M4+DDu65nwwlPqOs75cgTA+AfcPeBdJ2MBMbJVpm3ZbmqGaHeN4/6+UnOceKt7xE/gD/IberhK5hTDp+OFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=prYngYaI; arc=fail smtp.client-ip=52.101.56.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="prYngYaI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PJn/Kda43XZ8Clk9H2f56V3BznoFjYhp0X7WVU3klbFCEK1a2d/whALeVs9FZlW7Gs8hg7Nvq06Zn0nnsCN97Aarv+n9HvIVx01XFRbD+4p/1KSESvf51VWdnAsAPFRtGpiy8I+Fc7ADl5wb3QRCJyjnabTPo/VVma24CBMFYEtbVz/N8v1ezPk7Xnf4oIryS81F09faUtszOVYTWl6d7hVg1Wkm6rIeygbbChExGvNilAJR3shAd47GQ8PznWhXpOAZvoQtQ9xeD4+QCHVEe6qTE5OTmRnDgKndChjZ5bslz83PQDc65Q2ag3+Gbpdc3ttHQe/jKssKxqlYViNe+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4pPDdKDPyAnyBEpPwSyNQ9WAtdgTQNUESex29jy0624=;
 b=Z3FL9awDpAZkDnFdSOHYaD2dLLJ3PTTouwxgO1c0ZD2jMrxXlgn9rmbCAQ5fzQry2ibHKpo5ZZFrvFuY+zzZzC1SMrhoEIoDeWMM5qIGkIw6O+5cS5Jp4J5Ybgqndev7RhxHDyVZYrNn3w6kcSIQKAdYDtuqb/jBr96LOMBFXPdq9Q5HSvgFBUYMrX954g8+D4oEQE4Wh1aUNiQVqGT7igFu+on9tZrBy1+B8d/Rb0cp1PwlRHw083a/HCP0MNt+Z7tjFtg0bwzZi+dVcBCz87INJrmPGRSP2kJejmUx2YHYZS6EJEw9nNU+FDGylfLoRPWcaxUiRvhr71sFOomj3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4pPDdKDPyAnyBEpPwSyNQ9WAtdgTQNUESex29jy0624=;
 b=prYngYaIvjm4gIGs1R7nl0Z6cB93v5l4sDwFlRXoM5rTONnDoUO/F4W3044kk2AMknKK0GFh+E0+d5vz+hF0zHLguYLN9+Atri6jJpW0V5apHKFdHPhwyVYNt3GR5hrhB+TJQUa/at/Aex0OZ+ApLOQ3Psbdhy+JQy1fNwV8QNrfSaEwpoEKrBls2WLz+WG+iuv4HE3S2Wnx2AajqiP/d+d0t1q6PCmHPvwHuzwMTnt323EI4HmnuBQhoWOMs3M431x2RWXFR7Il4a2C10GEPAArUlYyj2NWUu1Cv9APXprmOWkOR7k6qNZ5+KG2zZBwwNzyK4S5899yJK0j7Rx+Ow==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV8PR12MB9264.namprd12.prod.outlook.com (2603:10b6:408:1e8::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.20; Fri, 27 Mar 2026 01:43:17 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 01:43:17 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v1 09/10] selftests/mm: remove READ_ONLY_THP_FOR_FS in khugepaged
Date: Thu, 26 Mar 2026 21:42:54 -0400
Message-ID: <20260327014255.2058916-10-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260327014255.2058916-1-ziy@nvidia.com>
References: <20260327014255.2058916-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0170.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::25) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV8PR12MB9264:EE_
X-MS-Office365-Filtering-Correlation-Id: 566478f4-4fc3-407e-f271-08de8ba237d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|56012099003|22082099003|20052099010;
X-Microsoft-Antispam-Message-Info:
	Cx2DSosfIFXz2lehPtSHbIRklR5unMvgz+X2jbymk6eI/0OZWCKGMAQ+I+NqwRwhvgQtEW7A/zVQuNLl+yQaT1L4BTApm/A8IBW/QrZ0IB4Lepq1imfMpUs07xd7sbeRg1ge0WctWJU3/+bZO/hg3OskEhOJAyV+7QmpQCUIAFDQq7sjSmBk8djsAFn49aSxFfs1wB0Er2QJFUjr4iyvNNOSc+IToZLxkW9m1EumOr+x+jI6TMxFta1u/sG9rchoGej8EFyJWA2y4DetB/nRaA6onjNYFETaWtwI0/zQSkWaU9RtbMAOqiE5ODn3I5zJHRVdhpA2nkaf98wT1y2o1NE+vJvAcwjRKbSEj+HiqLu83kSyolaRmfVsoktkY+60/6zOjUnklFg1WxePj97Eo3lDUlbjjWAko40IQJaVD1hqHHSIWsTHobhKzErd+ik17BbJRDwsSie5csLAvigqJMWOjsUBhwfqWEFEt3adHRYX/Hu5OirpC9xXjFA1aB5eAUkfoRqlXdUV81NL0x5NI2n2GA75K15a5SQ7R/WUjJ+OjTD2abUIQ7CiYOi/xSPM7zhXD4bLUffwAwaNRfSXIyh5pYKlUP2gXaItBBXjQcgBrJuLTPKlvddGUywO/oHWQfRA287GZauSzhE6cC4NShDsolhIcwX4Fzy/tLoL6sSiGD/cn3d7JdLezc6vcXmYKIhVTn06WI0H/i3gHiFMmqdFWwYoFj3Y5ynz3zhme+4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(56012099003)(22082099003)(20052099010);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?arAQ7HlyJCh8MDihvbyURJL5WU5sYK6Y/qHnHia/76agM02zwqnd/F50mWw6?=
 =?us-ascii?Q?nicIeq4lf+Jftth19hDFpCiHl2pC04goheNlWF3la6JLEKGE/YGvHVTIA+CK?=
 =?us-ascii?Q?E82LgOU6FqHBpS3P44wQN10C86tUlwLyAJupl9DJhJ9t6pC4YWHYyxJtL948?=
 =?us-ascii?Q?1BDVbx6AnHTUofTTaOXAqLSJOyAeQSWwZlzBjhUwCJRzaZTH0lasvZSFNt3F?=
 =?us-ascii?Q?9RWwYvkcixTgXVE4RRHtBwmvD5Iw37thijX0qhE79lkFAS4V9VcfHyn4e/sM?=
 =?us-ascii?Q?st4IrYuHail/JB2BV0DYI5aTjwxSHLJEdntY3fZLrzpm6IQ3+ESiXpLmqL59?=
 =?us-ascii?Q?mdB0KMnKSs3FX2NFZ94PIxXJGsbnZ/ef5IeRgu0ZhvDmjgagB2JItPUhCD5b?=
 =?us-ascii?Q?V5ZxvIro8kiY8VJ85nzdlW64riKIxJ7Z50Is6q2kVA75pq1Wk4MwpPP+ey7h?=
 =?us-ascii?Q?M63nCD9TQHYrzJX/O9IxHVPJ4G2vqPgqEl9s5uR5yjtQLJiL10ER23xBtMeq?=
 =?us-ascii?Q?0+dac5lDLK8G/vaz5lK4zL+L4xJHWFUe3blGMTlVUr6TKkv5UFVZzTwSoQz1?=
 =?us-ascii?Q?hEsyk81n8fjVeIIYdCZyRHCfvVvI3HOrgxb7iEmiKt624sSKM8VlSbiCen+j?=
 =?us-ascii?Q?DKfUKV5ebqHMugUYUwNaA6J+p/BlLF5jsTZvaYYULM/A4ORjKWQkSJywpyRE?=
 =?us-ascii?Q?gfGZSxa/et8o9B35gjZ9w89pw9/GAyWMh4bwuRWfhymOv9S0j2OfivA1N8S1?=
 =?us-ascii?Q?qh8x7oXopqaSOd/cWfVkugzvjge9PNH3DqKDTElAyJ4kjvSAbQFFAxqhCtQD?=
 =?us-ascii?Q?qSA25wLzzK1v8TI+2B1sW6V5OekNAaoz1lXbM0czSPXqiUZRwbw5zwEW2z2D?=
 =?us-ascii?Q?idESve3AWh0Cbjtj9U1q3j+Kg/+7yYKSpIRJQyQ7UVjbY4mSSvTWwxa65nmG?=
 =?us-ascii?Q?Ho7N9wFTD8Jazy01cWgU0rc2mOwEuU6M1+vD5msaSUFDdRISennDRpZ41utZ?=
 =?us-ascii?Q?10MdxNydbxKbu3pzQNiazb3505QIwErZtzD9LzO5NUK0nAyo3aR+Mvg0qsdn?=
 =?us-ascii?Q?/eHko1yrr18tkmyShib+nUhIwBVJ2wBo0jixLdwAynnIbDur+CgkcIpsSS0g?=
 =?us-ascii?Q?YHmF8tzn9JAS9dApB3eQ0mYGkv3tEaq7L7UyLIIWKtLT5TzChx9Gv1YuxbUv?=
 =?us-ascii?Q?FFzkfBosgnNk+IihgKI0lCWdWU7M53FlZAH07yHgzWcY4Ala9CI2PsyhoMVE?=
 =?us-ascii?Q?b0PP3esyYhRxFIM3sV03dCiAL9LFE6aBsaDTS/dwd3OVzXendnLxxuTG/RPu?=
 =?us-ascii?Q?NS/hMOivR1Qyg8939n10T7ba4Km2Tue0+fHe+cnWH/FeY+De0WQQZYG9cBxf?=
 =?us-ascii?Q?QBr6Nrhegde47JgrLzrxi5RcPLvFWnqxM4GxBagCMSOAON7PYQbTy7eo494z?=
 =?us-ascii?Q?Z3ofXH+vmtZ5TV4/ufcOjhbuw/Cyu0em6m/kQjJDEj1/LdOtp9XPKd0Ra0q4?=
 =?us-ascii?Q?zy62a8E4yQSl3iM4IulGFE/d1ilHpvZ24uBwQDEO7esQlhz+5oZUXW4RPg8E?=
 =?us-ascii?Q?xSYScfPuVWEXcSMAzaaC2AX5PYWL6+L/3Nc9KNRTOwoSg7Rbga4QeID+Ny1a?=
 =?us-ascii?Q?Y3qdw8lHs/MZYLTeM8iRMThg/yvvjfZLbvrmLx0cUrlKNe3yGyGU1LWnfnym?=
 =?us-ascii?Q?lEmyN000VC/Bm4/QyhxgTjn5Dy/tOtjipjGQk3i91fUAN85o?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 566478f4-4fc3-407e-f271-08de8ba237d1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 01:43:17.1793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CiuNygqRBIGvkj9u4JqFsTszFE5Sgeflx5hSQEw93+8pkH5cNVS+NoD98z09eWst
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9264

Change the requirement to a file system with large folio support and the
supported order needs to include PMD_ORDER.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 tools/testing/selftests/mm/khugepaged.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 3fe7ef04ac62..bdcdd31beb1e 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1086,8 +1086,8 @@ static void usage(void)
 	fprintf(stderr, "\t<context>\t: [all|khugepaged|madvise]\n");
 	fprintf(stderr, "\t<mem_type>\t: [all|anon|file|shmem]\n");
 	fprintf(stderr, "\n\t\"file,all\" mem_type requires [dir] argument\n");
-	fprintf(stderr, "\n\t\"file,all\" mem_type requires kernel built with\n");
-	fprintf(stderr,	"\tCONFIG_READ_ONLY_THP_FOR_FS=y\n");
+	fprintf(stderr, "\n\t\"file,all\" mem_type requires a file system\n");
+	fprintf(stderr,	"\twith large folio support (order >= PMD order)\n");
 	fprintf(stderr, "\n\tif [dir] is a (sub)directory of a tmpfs mount, tmpfs must be\n");
 	fprintf(stderr,	"\tmounted with huge=advise option for khugepaged tests to work\n");
 	fprintf(stderr,	"\n\tSupported Options:\n");
-- 
2.43.0

