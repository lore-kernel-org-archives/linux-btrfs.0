Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010012.outbound.protection.outlook.com [52.101.46.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BAC318EDF;
	Mon, 13 Apr 2026 19:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776108056; cv=fail; b=WLVHgYNQoW0pr9CchuhCy6cJZM2MDh1Z824kAbtffAzHUMct+0ySIlXuGytL41vW7ZR8k/Y25DM7epLezp7tbKT/yotvAVGl0/6lk75uCG7ESxrJX4SzoxFaw/wAS0tktGjSHCx9BkDksVuFHFRx/B1+gyxBQkC5lZfdGZNx8CU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776108056; c=relaxed/simple;
	bh=Kgmme/a6bfrYrO122tNVX0F219arapVTHWZnUrQv9b0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VeTlRE9ER7qxprvlfiKzMoQWARnBPY1oUB3FmNR0AnmZQDAURyktKIuYXZBlDeyfhaEtMHcYn2yuQszza5LdnXvuXla/Dok8+qnlMiiSs5kK8OSoJfMudJJXHUBGjBqP8QlHXVlVXu3yDIbPIg6D39B++fA0AgDBme2aC2UxPtU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Bng+NzvM; arc=fail smtp.client-ip=52.101.46.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Bng+NzvM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HtUrOGp9TkAR8jbf49uhTKY62Y7ywnhQUAA8p3ruUoZV0FNMH5Ob2cNDP5wBAL0u9ckktPJvgpwACmWMhJfjfYpba4dpSidLOYwoc+4MWbKnDO02f3uC8SBZ3qt8W90r8Vv3Eizl3eotvBDJI4anl++QTSyGBE5+MBFxVsYOC/wlzVBW2ZHGq6bXIXQXzss9+DCesMQbTqJDK2RJ9iCAK4WN0/BS3UMKJtMTZkZMsnuOs0VP94wG9LhDxULuu/YLUtX/D3H3EWg6aHyJLyaqlWQciscpzl+hFCwTZRp2rWvbTdA0js4a8UwcZ7/X97c5549L3BQRb/0CRbxrXrfB/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NejS8Z1t6Y+7zgrdIe4+MUiS+w3T7QiEI133vyKg5EM=;
 b=a0VPjtlj/u4yD+o8fEXrbJ3+8MNXHntWqLo1hdnN0ShFPZpACzEb+f/gAI7ahf83Gtj07QEezPiPWRYD7hJ3By+WKhweoUOWax5RANjo4abyUFzLABuGLNz9rL0NyRVf/hNsLGKKVbXMUNU0MogDc7BkUHs+letpGZ5AXYc3aJi0X0tpdsCqrLpNxCn9AKqNJ/QkXKAMQA+Y2dt8TFcXJ8swvoR8cO3M6V152hocpGLC88FkFtko6l+OZfHwJdxbvTWwv4kOllOgDs8ym2xZBp2XJKQrwMC3Qw2DZWnWukL0I/a9E1I8un2cOvuhiT9r+/GBD/i4Vib/QT8prA3Xtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NejS8Z1t6Y+7zgrdIe4+MUiS+w3T7QiEI133vyKg5EM=;
 b=Bng+NzvM+lXEmrxAl1fAjM3uX1YCqdGCki+r1l3maKO0qRj0i5LtknfNL2xHvqEA9lOfsv+Z/xrUzNo8K4p/dPp8dN7ZO3ASMZwsKFcnfMvP7p4tJQdmfkxt2av+b7DifC3aYL+CefqQeFTXlsVQEHV0GnxgDDL6W4kkLQMJ5mJJgh0nuCE//Dh7EUhqQSxYWUQu+xGZA6pfxDcDdZs2GSxwXP0/8tL36aSKas8K9INT7kDRPUNyvMeRMmP0AYj6zujYRmgGTzRhwV3JFPWia2S8Q1Sj3t+ahB4h4z4fOxTfaGum62DsuvOolXZJZbG90TQOMCkBRjR0QxDfUuOBzw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB8444.namprd12.prod.outlook.com (2603:10b6:8:128::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.20; Mon, 13 Apr 2026 19:20:45 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 19:20:45 +0000
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
Subject: [PATCH 7.2 v2 02/12] mm/khugepaged: add folio dirty check after try_to_unmap_flush()
Date: Mon, 13 Apr 2026 15:20:20 -0400
Message-ID: <20260413192030.3275825-3-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413192030.3275825-1-ziy@nvidia.com>
References: <20260413192030.3275825-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0053.namprd20.prod.outlook.com
 (2603:10b6:208:235::22) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB8444:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cc6e3b1-42bf-4c68-7c6e-08de9991c0fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	/JMYe/d9coFEAMupAhJIgy+huvYYKY5qE2JYpRcnU8Oku5beCqr261CAav6r51nvg3mNdOAPoODnI9wiJiNhPUUv/O+4XG49yBuQTTA071DNh15jwgyghgkOCDEN5tS161iFb+xLz3fFrlvFpDsGUVzK8Vi7stKs/aYycwAAEsPH9SCESjaW9pkBmSwxto65GRLqd24NcWsDxPg4O2Vb6hUhDht7npBYGBcUa8VkIFsFwl3hcmxuRyhL2KyFPYn8teshPibex+Ol13jh38oUMCOaAvoXQEFTaWyQ5vCeMjxVMkOONG4+m/nta7LSrT8p453MOYPuB0nX4ZyaeIgzViQ40KHsKGDSiZpTcCV4tq7/Wb173Mya9KGlvR52hsFRIPtB1cdtvXy55hBGQBw4kiDcp+ZbEidPP47IK2TthztT598SRrlWlefKZMA90Jx8/IuD1gv8Xt+AcMUMmpyRspDvBYgHbPQhEuy5BH5SJ61AV3u1AAP4SK6NGOogo7JIfm4tHApUASaXUBgNNOQjWRzH+uYPInlETzLu97y62N6By+IlfPDccoSwU+UoZ2cFFCOU2QX5KzPbEHhDeE8AcBGBhCttjzG2+/8tljyx25VkazcmWXsggsaXIYYvsF7yjgZjQTWxceYUScR4rV6J9p86gKvoPWDcCBIEb/COtcBF0XA75pIJfRZ9TgpjZa9nlEku2ytOmc1w8O1LfvIk/LZ3F4hhNRrJ5N8Z8szm2MQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?E0eH109nffSXRUXcwhoshmpovR0dUEA5tTstMVfZFXNw4+4aLNIyn3L1jeaA?=
 =?us-ascii?Q?iF43UPsaz/LbzTOwL4RS7z6WpZgUowQpL6TfLa10dtGJadzpMEcf9iCqG7z6?=
 =?us-ascii?Q?2RcF2R43x1qIZDXtURItj50CKU5z3zK8GALLI8R1TPe/AFWGumvdcxgraX9t?=
 =?us-ascii?Q?DZ9LI+PP0ycrNB+nhr49NdihUmRuMLRe8mHzYTkYtrOmjRSqitKuEhn7P7s9?=
 =?us-ascii?Q?B9ThFYBmPfpcNyiXQFZTEppFOIJCWEjcCXPzYVLVlEj1dMMzhASDOodnvmIH?=
 =?us-ascii?Q?3T7MldL8Bc/2EP4MaIEg2yetQRxLVFG45ftHt50GqrH7cuHxET3llPcvvdov?=
 =?us-ascii?Q?MrDBNtJ8eR6zUT644Y3quBYxQS22XVnxx1JIVqI1CAhHLBlNOvzXWoAODmhX?=
 =?us-ascii?Q?uy0kG+9lv7WZYHQQgBHuQcgHOzzlhj0FS30NIHDn4Af9M6wpZqQGOGiqXLIG?=
 =?us-ascii?Q?ErFtyBAlggaBfH2RQkx6AwXezjWXwBrW4kdaYAwOHG1vv6GLWrEBf3cTtLLT?=
 =?us-ascii?Q?22pg3fxUdWnB+q0WMduSkpRCNu/ej2y0LIW9O4XG9gdENY96B3Az7r+Y+MnN?=
 =?us-ascii?Q?G0DW3ACWX3r7dRpEdeTAZgudxljZrH/eluNWZ41bOAmkScggUNzJ/x6O1Wnc?=
 =?us-ascii?Q?2br8XMwFr6lPStiO2j/MoS6otnRRSFLIPdTrGvUaKCo8jOqZlk2tjfQdGFss?=
 =?us-ascii?Q?iqrUJOWjb3hGuiyslqQ7HjbHzRu1F5RMwR4bDmKicZ7K7YY58kYBy3LR4GIY?=
 =?us-ascii?Q?ITmeqXif29qpHaUthjur8/47HSaHFuRRquFyHok7uaYuxtw7hLAB3Xw5lQlB?=
 =?us-ascii?Q?TbF2WwX7I7Di3TfaLSqvhs8kiTgFA8xZzoDaKCzjz3PnQzjpQPBemAeRN+15?=
 =?us-ascii?Q?0Z8yqn/L7tzD83tL27Os9UXqZptXth+mRp3aGCdC7Ilf/JJwju3sKIHMqe9u?=
 =?us-ascii?Q?fuXmdDFFWz1ubD2skWsjbcm6QExQdMyKpEJXi6NLWcLCO+H0QLMx90KPeAWR?=
 =?us-ascii?Q?dYalBlQgWOa62ff1mRYGGxfnnqVjLj0YqsSV7+M1K4b47YIKc4VOPqMDY88s?=
 =?us-ascii?Q?9M1wa+/61z0/OJ3xGPnnKNN+SdkL5UEqaYLIAbgiyqigrmBwx2mkGT6+moV0?=
 =?us-ascii?Q?2X6rQ0vIB/8uUwld+9hX0URTvad0pdrZWz94y6JNtzoIYgxouRBoa+hjbZB3?=
 =?us-ascii?Q?aXwSIhV74zfJlTdKpa1ikF5BetH5uf6+sGmUlVIp3GxTFttBao1tSTgIk0QJ?=
 =?us-ascii?Q?LgHJ5aTuoFTCY0l/kP8UVinPHliajv6PYrOoaXEe5pS9l0FU6WnA3u1WceX1?=
 =?us-ascii?Q?g5jcHsb/4JipkLWH03makkgIqs+xN2OruUddz0qIumnqcnMxBrmx5q4PBE7L?=
 =?us-ascii?Q?bmXpkYJGaqL3RZf75PWE5FR+gDMkwJlLlKGDJtQF8FQru7nsb/5AzMfCPcED?=
 =?us-ascii?Q?0U+iAp5Qa2boi7KGXSAqMwDZVTs1xRuR3pb3hV8Kr9BXfDuLVZ6PkXhuA4gz?=
 =?us-ascii?Q?dPrKT7aFXQdYcI/as3Sanpp9X3IDzfCJU6L/ByaGSzfVBTpEhV6SKKp73hLo?=
 =?us-ascii?Q?pNGWPk2Wlf0ElgSLRlE2EjlslgDcmsB0jM0R5eBHD+gMPplpkz13l6jTKpD9?=
 =?us-ascii?Q?KMp/L3EBqQagkW7cbqrKpkOEzJoVjNnEv987oalv6mz9zop4iLD4cMaFkIqg?=
 =?us-ascii?Q?QGKEQewK3o+lvXNI6n6lPCxEwbSC5T3vjMKjXcz7rmwIzayM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cc6e3b1-42bf-4c68-7c6e-08de9991c0fb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 19:20:42.1475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ugPUB+427UJ3LZSt8uERTHGOA3ZtyokutYUvNgNe/csoZzqY6Ujn6ozK7YKoeUtt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8444

This check ensures the correctness of collapse read-only THPs for FSes
after READ_ONLY_THP_FOR_FS is enabled by default for all FSes supporting
PMD THP pagecache.

READ_ONLY_THP_FOR_FS only supports read-only fd and uses mapping->nr_thps
and inode->i_writecount to prevent any write to read-only to-be-collapsed
folios. In upcoming commits, READ_ONLY_THP_FOR_FS will be removed and the
aforementioned mechanism will go away too. To ensure khugepaged functions
as expected after the changes, rollback if any folio is dirty after
try_to_unmap_flush() to , since a dirty folio means this read-only folio
got some writes via mmap can happen between try_to_unmap() and
try_to_unmap_flush() via cached TLB entries and khugepaged does not support
collapse writable pagecache folios.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/khugepaged.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d2f0acd2dac2..ec609e53082e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2121,6 +2121,24 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	 */
 	try_to_unmap_flush();
 
+	/*
+	 * At this point, all folios are locked, unmapped, and all cached
+	 * mappings in TLBs are flushed. No one else is able to write to these
+	 * folios, since
+	 * 1. writes via FS ops require folio locks (see write_begin_get_folio());
+	 * 2. writes via mmap require taking a fault and locking folio locks.
+	 *
+	 * khugepaged only works for read-only fd, make sure all folios are
+	 * clean, since writes via mmap can happen between try_to_unmap() and
+	 * try_to_unmap_flush() via cached TLB entries.
+	 */
+	list_for_each_entry(folio, &pagelist, lru) {
+		if (!is_shmem && (folio_test_dirty(folio))) {
+			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
+			goto rollback;
+		}
+	}
+
 	if (result == SCAN_SUCCEED && nr_none &&
 	    !shmem_charge(mapping->host, nr_none))
 		result = SCAN_FAIL;
-- 
2.43.0

