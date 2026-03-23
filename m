Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010065.outbound.protection.outlook.com [52.101.193.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2D032F749;
	Mon, 23 Mar 2026 19:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774292820; cv=fail; b=jZO4xY1p9aD4bPUOFfmKfNYQJEw0MrxCWT5RrUGOWHQVkFDYeiygGoeCvrHtUF2lqkkRMXi6EcDBWeC7Tl5oMgEPxshBZZIoKBcLqjJppJWv1I2YonJwvobCZtm7HO5iAK7xAHtjnoLcayqI8b1PCElD5Px5FkCv+CuXvMv3Sq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774292820; c=relaxed/simple;
	bh=ESRNqu9sqqdEMrwtc2b9Nj6chmmDfugmDmwXH8DjAEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tpWzo4hfmMHHkvcahKQEUyaPihp7u+m14EUyOKRWVSPZmRTV0AmxSAMjzp9s9VW4AoPvTsABYgvXqxE3ZGzRe/OpSUX4RsOM/ISn7lylmkqClNS5w+/EcHSNXKyZjHC8XLuspv5IJtbYdYFu5kUKQy5jRr3xbl9v8GvrQ7uL0Gs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JSaGsfUX; arc=fail smtp.client-ip=52.101.193.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JSaGsfUX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N3AmVwM31dV2TqRWTzscC+pRTdb4w83kQ+PW/XdO56vlidRnKaIbDLOpf4lkc9xCWPPkJc4kHGzMpgGgcIsT4TesdXI5WFHVHyx0ptLXGy8RB1as+pKh3KYlaveYLWL6OY6LBpniaytvdPw0009D7liENNDgfZZC33QA3lZDgoF+d5OIlNFdoMfGK/hlFkY7Oigakkk9/g04/8h8IxZXyi4lb4EoGckVSElEz9dby2MkSq+o+izxLjj+Yxd4EZm4tS/feGSF1RWJE2n9PcFS33zVr1/JxJPbbDoWxEgntmJZuPZBAqGRYay2nVYwXnrh2p4Meijy0Ppe+RjLaySWXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rcOdDndzZrfbZ55rDcwBJOIPoxYYTVfJGwraIDGQWt0=;
 b=JQQYYvgj7s/ccs4h0pHFXnud3/dNJ0jLHXOFfRGrqzH1Bv+fbyQVVdX9w6IWIXxDDVwbfnAtXc6cVB8MkDWkV3HHzJTpa24UDp3L3RsHsihs7iNzuO5Vma7hgoWWG4l2B1vk2oQLPB26feAJJPPbd0zScbiDiWvSwEYAX+kOIQ2NdHRSYA4yfP7pL5PBY3DX2TnCf4jHbgKEXtdtpEAUSbxumHMR0YCngENRAbSV7oZhNGUTlmQT+PbHMaTzLnf5SLSxLnN3USM58Ron1mAqdTr19bA6FCdfwlfwg5IT4M+08Pqj8b8BriF1t7lSuoCpwl0oueEPd6xmdelxeNMpoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rcOdDndzZrfbZ55rDcwBJOIPoxYYTVfJGwraIDGQWt0=;
 b=JSaGsfUX8Nh0uez1h9PA8n0+zxIZCBTNE6z/2f/uhGYz1BLTKpt6FTLf8XfynEm+ofNrWKzBq3OGAW6YP4PQTZhgnqVgnGBIpWsTOELiq8d/e3srmOrQ5FLcSmEx2bVyzS83rIL1Cr50KdZiZOc43Zc68oQgdXrZcHPblciHdo1hCnGDUi4GmI72ibQtSbf21mmVhY0E5qQZeKWrdSerb3BmYlQWRV9dNCzP9O8x7zuVd7BQJJjAZtEHVH4ed+ZbBaLX1H8J/zcK54wfcpP2BBa/tI8kTnC2ZfbStBTc72V/A8rpXD5PXXQKIZIbfq+X1dMuIej4arpZ67oiRq07Ow==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB6813.namprd12.prod.outlook.com (2603:10b6:806:267::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 19:06:52 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Mon, 23 Mar 2026
 19:06:52 +0000
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
Subject: [RFC PATCH 03/11] mm: remove filemap_nr_thps*() functions
Date: Mon, 23 Mar 2026 15:06:36 -0400
Message-ID: <20260323190644.1714379-4-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260323190644.1714379-1-ziy@nvidia.com>
References: <20260323190644.1714379-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:208:32d::8) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB6813:EE_
X-MS-Office365-Filtering-Correlation-Id: 03daebe4-aaad-4774-78d4-08de890f57db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	juT+JWxt1KTkE9zCgH0NGIjyBvEaPxkyzOLInDLO8MA30B0dqyPQTndynIVmozR9lg5UEIinFijoRZy0P72bC9bubPUZSHwE+e84stHMa5xLFhAW/jBt0ZKCbScOHKE7eHV1Bw2WAxKnUkxjJc2NbiIPZpnWsO3QEsU+6PYbdnprYYShFm5ZOzLuhRf7GVRmcIUpbMpDKl5IQ1K6oOCUhCIpJ/txoqvprrwpNE/ogOXJBkM0b9sBDTmoxkXVx7ADonK9FBe5aAjbDmbXIhCuIhv49PbE4pE7IfzN2wQ59jJHhB83h5SGi+Ra1kukm66lksePBTcicAxEEDoct/HM5S5ew4WdwrBruuDAK+h7Gx+qQEP1oUoYee0HUEC6EJSFQJ/Z/cP48jxNyGGfgi+FHaWpRslV7kq88W3yOq76oWjw1P3g2d75nAw7lCzPq2iQqmJlCzBXgKIJXGGwMXSpYwqICs4MIxUfNCNIf212Dr9g9bD6G6OafA4vbq0UTAHtO0z2fbdhvGs36Hxe4fa+C16GEtrCOVTi2O+u18FSsg1f2OjcdOxBTOVPFy0wO+ueill+gz91xG/bPj9HpbC2CMdD7AGMnfEqml/TquSS63ZBha3HuU5bewT6uSQhQqin+4Jcy7LN5FV08xVchPl22mYFgvu+5Nv8XXtnf4u1VQ5auw0UQPZeXldo2EwN6sgD+yxQphZ3NhTNBgp1pSZqGsoY7p7s1Y7nbawLI7FJilI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WHG4MhY+/+/DJoFqC0BmQEo/78E5qHWgVsUdiE/PMWdV56S8sE1ROA/+1Rpt?=
 =?us-ascii?Q?XmgphtAXUQtbD1YWa/o8cGWJwWZCiYz7ZnsiraaUQfKTpRGW9fyWb0VjVZpD?=
 =?us-ascii?Q?PRQ6kyNth25kIW6qfqh9Q0e13tX9tb7lhlvqkp3zibyKXMZ34U1Mzg1wqf7j?=
 =?us-ascii?Q?OZe3aUh6PXZNyKMmkSpvPMLiT+GU/gJWo1etHQCgU7ya+9p448LRMSIXp+1f?=
 =?us-ascii?Q?qFvalyVA2VESw3ZGMP/b+9lls3Sk0jDp0BM1DFeaN34by8IQocygrHG+zSVF?=
 =?us-ascii?Q?3PYRzWGIWKGacOvkWepaHsjsPYmSDEjIMdkIYkunN5wMYWR1bEsmn2fbCcFJ?=
 =?us-ascii?Q?/1wX+DuJccf6SJhVaT76RifnyiPosV8hvkCOv86BQUZ9tvwoPNuaz+/sWjVh?=
 =?us-ascii?Q?FUpYFvcqYi/6YT8mmByHaedn/CdEo9RD6FqQE9vhAspbke7bSj1ODil7WBzd?=
 =?us-ascii?Q?wtVj2oZ17bnBynGkCxQG4Fqaq3PZop/X9X5TuazJ/Jdf/Bv8kBMBhcGMK3zj?=
 =?us-ascii?Q?fU9hrsFWSkPbAqdJKaJDQyeKm0MYigiqHeaFcmJUsWmwlHp4GbICVmhWk1xG?=
 =?us-ascii?Q?Guu40DUMztSIPux7ekuimTvd+4oSNISbfjfPJ39CkaMNygOjJokYro7m1GoO?=
 =?us-ascii?Q?DYhAaTdiMBKpj0JoBru3wDlRlE3gSN0xWa5YBjUZJZtl/3XnaFjqVCRahveb?=
 =?us-ascii?Q?p+t+YY5i8AQ5AgbYz168BH+TbZbOna7OwBVTB3pq42SYz+FsZARhS2e4WHjG?=
 =?us-ascii?Q?lAgSG1/HMRZuCC5It5N9PxOa82qszxmM/U/BQKoSm4ABT0NJ3Dy7M6+eJjlJ?=
 =?us-ascii?Q?yUZmEYLTwdiBUIHYgRSGrpG70HQzq3tLcE39IpuoFueEIDKrg6aq6KpXzD26?=
 =?us-ascii?Q?5z1h9PZtAssj8RogCtQc3jtGaK25D1WU2Nn765mF4hkMUVe7MTftqnuqK8HV?=
 =?us-ascii?Q?Cu1PfmGz9p9O8gQ/Vps/cudJFr0rzUuOlHPVZr/x41QGf9y1VMlumUPKsVi9?=
 =?us-ascii?Q?UPsFrtC19pjUGueaLl1TtBNqzq4XOmlSlViZRm0yC3PgMl3ScXt2k/q0/cyY?=
 =?us-ascii?Q?mV9WGGV0AUr9zRhB5S/KrPQv2T7XUJW6V0BURUwfe1cvXXgagvuIwMu6n3wu?=
 =?us-ascii?Q?LAlQ0lj+Y8csdm0FVNC5b9FpWadWcBuLwilQz7qHzgDjErh9GW6U8ONg+4+Z?=
 =?us-ascii?Q?k9vNd598UaWqAJUZhmlWWixksP6YGd8jv7T5OgYKVz/xqepQ7cVKDQ1A5Kl5?=
 =?us-ascii?Q?Mz69MyMYpQ4lNB3RqxhA8PH+1NN63PukUzBjHScVCGjKi6KndJL1rPCOYde4?=
 =?us-ascii?Q?5l3Kl1nboGgAO8fdqqcNa94JSrSkLYfTRqLUIw9zrDeheieoHrTtLO65mnkp?=
 =?us-ascii?Q?sTIZFRmN0eLt5iCX6AxdtHsOjhj1NS2Y2PT8AEbjVtzAhb79MIPK37NW9QK6?=
 =?us-ascii?Q?Hg4JFWhv+liV4PZ05oOax9F9YUOaqv3eTL96uJ/bYQ+49hAWOpm9ZhfOUT7h?=
 =?us-ascii?Q?PyhdLsq2wYWZ1IqAl1oikf/XwaZ+icRpOICDwtUbngtRbV4RHZ6prWV2cW3Z?=
 =?us-ascii?Q?V3wdP1DzYPGXFzDq9U7099vh9mKvAH58Tsvl60emwZfoQY5/knt3DvUoINw4?=
 =?us-ascii?Q?hfVAkMt8hyinYhXBk06lVjRZyWe43MDSdHFvsv9BK1UcE15riJAeIcttSB0h?=
 =?us-ascii?Q?eeA16OWzHZ3jQJfF86wkwm716w9B7LK9VBuAJOlANf9sGnhB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03daebe4-aaad-4774-78d4-08de890f57db
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 19:06:52.5913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8bLBgndZY7w+Qg0yL71JQUALDqK8kH+Uh+bMjLdmS4CVRpymsfVkoS456DiDjzkN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6813

They are used by READ_ONLY_THP_FOR_FS and no longer needed.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/pagemap.h | 29 -----------------------------
 mm/filemap.c            |  1 -
 mm/huge_memory.c        |  1 -
 3 files changed, 31 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index ec442af3f886..dad3f8846cdc 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -530,35 +530,6 @@ static inline size_t mapping_max_folio_size(const struct address_space *mapping)
 	return PAGE_SIZE << mapping_max_folio_order(mapping);
 }
 
-static inline int filemap_nr_thps(const struct address_space *mapping)
-{
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	return atomic_read(&mapping->nr_thps);
-#else
-	return 0;
-#endif
-}
-
-static inline void filemap_nr_thps_inc(struct address_space *mapping)
-{
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	if (!mapping_large_folio_support(mapping))
-		atomic_inc(&mapping->nr_thps);
-#else
-	WARN_ON_ONCE(mapping_large_folio_support(mapping) == 0);
-#endif
-}
-
-static inline void filemap_nr_thps_dec(struct address_space *mapping)
-{
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	if (!mapping_large_folio_support(mapping))
-		atomic_dec(&mapping->nr_thps);
-#else
-	WARN_ON_ONCE(mapping_large_folio_support(mapping) == 0);
-#endif
-}
-
 struct address_space *folio_mapping(const struct folio *folio);
 
 /**
diff --git a/mm/filemap.c b/mm/filemap.c
index 2b933a1da9bd..4248e7cdecf3 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -189,7 +189,6 @@ static void filemap_unaccount_folio(struct address_space *mapping,
 			lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, -nr);
 	} else if (folio_test_pmd_mappable(folio)) {
 		lruvec_stat_mod_folio(folio, NR_FILE_THPS, -nr);
-		filemap_nr_thps_dec(mapping);
 	}
 	if (test_bit(AS_KERNEL_FILE, &folio->mapping->flags))
 		mod_node_page_state(folio_pgdat(folio),
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 610a6184e92c..54b3d21e4cbb 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3832,7 +3832,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 				} else {
 					lruvec_stat_mod_folio(folio,
 							NR_FILE_THPS, -nr);
-					filemap_nr_thps_dec(mapping);
 				}
 			}
 		}
-- 
2.43.0

