Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010067.outbound.protection.outlook.com [40.93.198.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E3A33C50D;
	Sat, 18 Apr 2026 02:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776480317; cv=fail; b=biZXn8qF7IPo+nz5y937Pjq/wuoofAfibo6HKML0paJNBY9qjO1T9cA7BYA+tkcTYIJdK/+3mQPdlTIL/T6RJDFFJW6S4+CBLRe3GuMC0gOeB2dhoPPRXtiaLEcUxQDI/pVF2OUvYGEgBTF9BNUBxStQ5hTV+03pPKrLMJrEBS8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776480317; c=relaxed/simple;
	bh=sqFWmK64rhOuj/yUi1KGwYJBZg8haqrbt9ClnXMGbu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Kj4dXdn/sfDhGGiYz8Xd6Z2dp2cWPDg+VCe48YVZvSSFMtch96Or6iy5gkDKaIm8kOMI8rq+hiti+HYuU5stE936108GREplpsSLS6eK3wyIpOOelsqyQAy17uFwDpInBtOo/w4HkCNkv3KTfre69gwPKhDseKuLqPDtO2gW1U8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HDQ97ZoM; arc=fail smtp.client-ip=40.93.198.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HDQ97ZoM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eIxquLE57AYl2OlCKgmQdAX1ATBRS+Br5h7dXejgeb8UNSvLXkWxY5J9XeKzZ9j/GXPnQsvw5aMXLrvaHpEuqtOsMNXYaCVxFt3l9XwsUchu8W5Qh9G+kFENffsaVSoUfKXgZbJPO/3rI/ZdvHmgDSnmuHmVEh6RQHcK0A/Q0fqv4WO96urRaZJYrFzihGg+YP3yTC4Ia2B6AGCpVm1Ih+IhKLq3V6LZl4QTu4Nsji+Ipr/6HvFfdhjXT13R9+JcfS6DohZ/+1gdKHczeLBKpsQZO4i3jCse2yZY28cbLw4HhQV2/KHox7CxH/Eu/csPT//ny82ApT/nlY5FcALCxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HUWPNMI43CMSi5bx25ldmPlNHdWHEBHgCa3pBe81r3c=;
 b=UT63FWzR/EnYd8RzNrMuBL/K9fG/dtWpYn4T+nXtKvqqS11MFD4XZAqGl8G9HokKdpRwtdBdMz7vBBpnH+6vNI124JT1LsGuyA2C9/IfgEJGQIF9pEg4nGvxa1uETUSithjly+9iYgmtp5HThWxH0+FEMrHC1tTenqHuxQQCXX6ZoMDzIZbbxcYLuXe/KymsGc7yxMfn+HZMcnV/joz0MPR/4eg9Q01zrLeyDGp9vyNVkT1IFXCEqnRdWES2e1Qw5/GjDpkVu+Xy1TGjWwDgq87sNIu1qhbBwtW89ouZmDEjlVePBj2gqYdRXzShwJ276yYVZliQyJg3CY4Lpsu9KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HUWPNMI43CMSi5bx25ldmPlNHdWHEBHgCa3pBe81r3c=;
 b=HDQ97ZoMhE0vXMR6Bob905ThFV9B9Rft5ny7mug/WCBWj8RxZ/V/0C6g+c5gX3giHAIChCoReho7pTzaT/D77E2p1v7HyqyVGPymd/9e+2NU4TG47OrFgjveOKuO90rN4ZrehJKgV3/s8J6AvLxruyLFwKG6Ttnx0X9h4N3KcC7jhO/3v3oDHH3USCfDjX8/nXInJTJ4zz0nmF54Y/DWyBZ2HiWdP7XsDnLVt/iXZwu6qncsZTpoqtFWs3dutF8+o+EBmTI+/O3mIBb72HFqrMxVS+8zrYTlmqF0MmgiMcGCU7QwoNGlPTpJG2l2FMy+bUlA8oG4uHABQAPg2mQyXw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB6650.namprd12.prod.outlook.com (2603:10b6:208:3a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Sat, 18 Apr
 2026 02:44:49 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9818.017; Sat, 18 Apr 2026
 02:44:49 +0000
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
Subject: [PATCH 7.2 v3 12/12] selftests/mm: remove READ_ONLY_THP_FOR_FS code from guard-regions
Date: Fri, 17 Apr 2026 22:44:29 -0400
Message-ID: <20260418024429.4055056-13-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260418024429.4055056-1-ziy@nvidia.com>
References: <20260418024429.4055056-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:208:32b::24) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB6650:EE_
X-MS-Office365-Filtering-Correlation-Id: c0399f6a-f918-41cf-943b-08de9cf47530
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Q8QNJ1fTPtZaA7RqgU+ZFgKUyTGoyC1enopigVt1oL17A1IV8ncmdVRVfVFZi1HgCsP8oCy5CvyiNEs8CttNhtCPNTwM+EX0HPgf+c3BDhFaSOAXAlBbDfCn9z1PS0PQUCVd8b/UAxSLVPcynBV0HR4EojzQ6mrnDQp8GIpnVQKfq+oH9hpBDJ/cC8wRZ5Y5D8OOGqgBzVI2uHgeKoOkFrRA6+qAc/VZfrC0OrfQPBYt3k/RLoX0SjQ9POgYqmm3NzX2On+suBp6SWEm1Jj1PK3Hr2LgY+MnaaTvELn9LFy/nuFywdZGgQn91XmBvjYnUwOvwR6Gog9Aj6G4+hnU5apdVX8W7PXyv9SX+WzEuvjorvJntHTOvcXTbM2vsT1YDo0QGkpDuwFyL2KXFqH2ZJvoQTWrbTnKu6CHxhFMNPa7j8IYzJ4vqjx7oEBfnUdvT++rPSvft97V2VTsB4af4j9GdLtqy7DSIingQQycj85kWdvJrM0JuGi+IO3h17+oXD19x7EyAXGJstuwcLx2oPOoJUXyN6hNZpbDEo9GTRs58cH+FwRyLcZTlJMxB4o7mjhq1XmZNS4lGtcKHePL97JxXvni2IZv5qAV9LqYFhweV/GjFIL1PTZoNT1I0OR4v4vxq24coo9PGF8v0YSN5CO2RKU3qy5UrWFM2rBhJ/ABFCKdMGyReNxLO4Iw5sPODRuUh341CFq2MnaNpACbNBudcR8+0qoN3u2AS7fjSB8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3NlDfnyH7GIPRJMrhnuoLthVLRRoTCeB4SnXUNBBwbJ0BMqoQQO6wbIUT9EI?=
 =?us-ascii?Q?cf4B3jms4MbirM0BrjCofrrYhtk5+7gL++XVYEm2GKTw+qp0s7U3Znj61Dvs?=
 =?us-ascii?Q?hJCSwAUOe6dAyjwAkE3ia/3NJp52+wKAdYCPxIH2ga5f/F+hSQRpu5OpSevt?=
 =?us-ascii?Q?5j0orZ2Z+ywGpTX+vcuAfP6IWPvLhHMFJ4AuzqesfasqZHvjxEjWHMpOrtHR?=
 =?us-ascii?Q?AKRJrAhpnhzVHI2v/7dxrZIrqT9dJ/eySgjAK0xB59E2xWhNfnF+2rlNWAjW?=
 =?us-ascii?Q?3rHoPoRbjy73h0Iw5eyJRxrd0I4hj+oM7nWdD86Rs1D8sUrb15iytuk8Lv8J?=
 =?us-ascii?Q?NyawlHxoKKMlshIzgZLSIeoU13c5ARoOqbh62pM7jSM71oMS3bwvkMh2wNPZ?=
 =?us-ascii?Q?X/1AEUbXk265kANBOS3WLLlq5PK7CAgZhTWW3Eb/FK9YWCFATHB9dYvMeaXE?=
 =?us-ascii?Q?NpodJlQTOdFZezF3v3Cmslh/p+N5kuH5Pes0jw4RZW+jIcbohuYCehNJkoVm?=
 =?us-ascii?Q?dVP+Gy+WsxHFU3563BTPqwDF3CqtCOs1Ry944vzoqtNDujWrnxejjyd9wuKR?=
 =?us-ascii?Q?uVLsOOOGPenC1mGChofrLPaaC+rpQDp8NAhbmRRrsmMqvXx8JwkViaDWyQXB?=
 =?us-ascii?Q?B5/4HvbEPoJu7sFfY9ukjQwVD/gHf7lRb1Mfpgt4lCyhnWOONc6ibuK9of4g?=
 =?us-ascii?Q?ZXQdCDZ0Ik2dOXoYuO79kVAZoiB3U8Vf3XCIIOM63azNQ3BvbJyWKQNnP+0c?=
 =?us-ascii?Q?G+Suz9NuLq7n+7EaPVqedO6lAyiporw3tycu8Y405O7+ctEgNWdxj6sh6Sqn?=
 =?us-ascii?Q?47VaWHiXDeKLDoaVPODIiK/cBJ7BMaVzoyzBeClHEI+GyUdtq0pN3/d0Uo6e?=
 =?us-ascii?Q?icVmZ2IwE2wFvw6NiVCGH6k2QB4a671q/onyVg9CZCWcQkvFxxQHeZwAAfx7?=
 =?us-ascii?Q?ikT64KMb9H6g0CKKOQKCfEWZLNrQZ1FC2l0jSA9SJXak1K62SR/bZbhrccXQ?=
 =?us-ascii?Q?esFX/nU/TvW16oa4xULJhRWgcBMS9uzbsKy19FEHnzsHuAWX/lzzYDOwZ751?=
 =?us-ascii?Q?jMXv5jQ1b5ARJ8J0DXDP5pNAJwTgM6fZmgj+kajL7qN0c5bHBqQcilbQMF2k?=
 =?us-ascii?Q?vRioBtHrcJt7TrMZCFTIQ4VUvlPXu+cm2S2fqVu3fACi6tmcc/v0eZ8EpyIs?=
 =?us-ascii?Q?frU5XSq14mCAZ7vTkRtcOEOjX6Z+Gm6NQFQsjPvUwx+G/e5WGmEivrz1lX7j?=
 =?us-ascii?Q?ANFaPys808ENZrostbq7HhAsItvXzObdtJDLTXahcxZZHTtGlC5soUDQveRp?=
 =?us-ascii?Q?7MXhYQtQGneA7IudOibWO/zTw1CQTbt1hlGzmMbzjKijh5uKTbiQB47MBwP8?=
 =?us-ascii?Q?chTLixZgxslOutE7OaxwuUcLVJdtmZdOdfgbvanBCo7v8+opn1UbCAdh9YlU?=
 =?us-ascii?Q?oBmAfObx4Frw5/T4DsA36y9ije5YgI+66fZydsB7hpPj+ghJFBkQwBbx6vAO?=
 =?us-ascii?Q?wDvNEmysbhWUCI7tHD6hFXG2Au+Zkt1S3wgKYl09Keo2fOQxoTh4nyvnH5ps?=
 =?us-ascii?Q?LYL15PxqNx58gJdAPALVjX+oSyFHBqTRoY3PA7HLga9WFa7XbN04khyd/j4b?=
 =?us-ascii?Q?eZXfC/rb29fiVam51eP8vcY4XH7Gc8Kg37c5CF+t2r5pXhe5qWLFOXjZ3/bM?=
 =?us-ascii?Q?gnjahvR+BuF4RSxN2xMbYb2q7b4aMNJvNY715gsfT3ibLNES?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0399f6a-f918-41cf-943b-08de9cf47530
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2026 02:44:48.6561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IZrHzOIMXYTSABdHa+v/b/y4VXOoavdUFi7oHeCAYnHxST5behJblVf503TYdPrN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6650

Any file system with large folio support and the supported orders include
PMD_ORDER can be used. There is no need to open a file with read-only.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 tools/testing/selftests/mm/guard-regions.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
index 48e8b1539be3..117639891953 100644
--- a/tools/testing/selftests/mm/guard-regions.c
+++ b/tools/testing/selftests/mm/guard-regions.c
@@ -2203,17 +2203,6 @@ TEST_F(guard_regions, collapse)
 	if (variant->backing != ANON_BACKED)
 		ASSERT_EQ(ftruncate(self->fd, size), 0);
 
-	/*
-	 * We must close and re-open local-file backed as read-only for
-	 * CONFIG_READ_ONLY_THP_FOR_FS to work.
-	 */
-	if (variant->backing == LOCAL_FILE_BACKED) {
-		ASSERT_EQ(close(self->fd), 0);
-
-		self->fd = open(self->path, O_RDONLY);
-		ASSERT_GE(self->fd, 0);
-	}
-
 	ptr = mmap_(self, variant, NULL, size, PROT_READ, 0, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
@@ -2237,9 +2226,10 @@ TEST_F(guard_regions, collapse)
 	/*
 	 * Now collapse the entire region. This should fail in all cases.
 	 *
-	 * The madvise() call will also fail if CONFIG_READ_ONLY_THP_FOR_FS is
-	 * not set for the local file case, but we can't differentiate whether
-	 * this occurred or if the collapse was rightly rejected.
+	 * The madvise() call will also fail if the file system does not support
+	 * large folio or the supported orders do not include PMD_ORDER for the
+	 * local file case, but we can't differentiate whether this occurred or
+	 * if the collapse was rightly rejected.
 	 */
 	EXPECT_NE(madvise(ptr, size, MADV_COLLAPSE), 0);
 
-- 
2.43.0

