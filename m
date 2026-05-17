Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012015.outbound.protection.outlook.com [52.101.48.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE5D3815ED;
	Sun, 17 May 2026 13:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779026128; cv=fail; b=WmLxGzlTOoplFJkf0Yodhu/Ooe/X9b38cyMZbDHKr9XgAkemuRQVF4uAbJtMu+riZOQKejKdlBxNjO1WdypXqfOBe+XTPujoyn606o2Dcy7tJlJw/zoX7aLuhECXlk3tIA1m8G5E+Epd1Q3Hzjaz51WSQw5hDKgayua33zSz8YM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779026128; c=relaxed/simple;
	bh=LXEU5uinH01R+b8fL4Ch8FqlQ/dG06NdflnllsSUd3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=A9Ptqd72Vp08RHYg+zJLbrCnaxSgSE79vi1fVupkkbw/Fvp2IeAr29sqJP3agOvzKfslcI03zQTaCNXrqXGKRLXD0kqVNNwmtloRfAY0tC4AGBr9k2KVu0Ij7zVpwaT8t9EvtdwyR2IjN+WXKUckkiKoU9PtBl8qj1sYJXgTNsA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ywggp+JT; arc=fail smtp.client-ip=52.101.48.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ywggp+JT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J1yvW7Vb/AHyxNpIUROkK9xsyKPNv0XtJfgBf2HPqkxmk4GFqj+dAlRZJiHIg9lhtLH924tvRbFbeq6Co1eQ0HHVuxrF2T976tJoTXGKFHyWgIEA7Bw8Z7UsMzOugylzN4fx03isaZNkPXv+ppQ9G6UgId0dPfkqGWIUxS5xYdwCT1Fnc8PfBMYTqvgmI3dzlJN0zzIchmEIh0/8WzVkVAG3ncQbKIXAy/6Aam8rxvF3FsqqgjkcCRIh3dzUVO7MKvTbQgULMvGoaFxamek0GMGGk8g59P1LUVDgp5GI8pOc+ClTy/OdZ7SJjri3w/AgjdEryK9YdH5sY4IoXYbUhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iTkuVwAayFRgMWDzCX1iXk9uJZuvi7IfRjjsvF77/BA=;
 b=oXRPYbmkaj/OUCjzGso60l8Vui82dU8QXBYZwehi/scyaCTr4xkS//3KSyHuQsI2XbHARmViZFPDS/ZAlaLYVTdJqkw3wVG0DFErDKkXwOVUWawp382DpSaQGQ6mdYGikvmi7brpJPbj6g/ScMB0LOx1mDd2tsYZpTzXggKi1Q2+X1Qu+pfhOF4l9lzPTvXnrUSB6bHLJnXxjUfKn4NAWYB9HH0vNqfoFXylYMxu3Caq0XNkl8f+U9yCoNLUkumBsQ0ns+tYkHppY+CsE9vY6WzZMqF8a6LFoWla/doH5781aHTSGDLEmoRs3qmNzZfFP+5dDf3I5xfAMwi9jCkHNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iTkuVwAayFRgMWDzCX1iXk9uJZuvi7IfRjjsvF77/BA=;
 b=Ywggp+JTv1Oe3pXH6bgv7XuBRXa3mQjeEToSdXJU/qsDysqnFv4bR0oKyxizGfjeIKOVbw2jQrCVTPGSElpWwVJFVNfZ2VxkhwAqYcqfvIulHDAaC9w9VvmqqOiIKXNeU+puu0lNwTGCOcVxhEgva5VYQDjSkbkDXosueoRpIXBDz2jsv0TTW7oUyH76pbFChzRtmEnSqoW9DtvRRj9uvHQfCkqKqtZ+3ApkINduJYsx6ABnl9OooGxdzhPv1bnv+fuvpMYE/oERW2VnvJXX6haYW4XZtPbVCQmffCbPfyAunaFz5hXw1kNBgVxbiilGTdDSRf5PMca2MGi+GCtqxQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6322.namprd12.prod.outlook.com (2603:10b6:930:21::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.23; Sun, 17 May 2026 13:55:13 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Sun, 17 May 2026
 13:55:13 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
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
	linux-kselftest@vger.kernel.org,
	Liam Howlett <liam@infradead.org>
Subject: [PATCH v6 12/14] selftests/mm: remove READ_ONLY_THP_FOR_FS code from guard-regions
Date: Sun, 17 May 2026 09:54:14 -0400
Message-ID: <20260517135416.1434539-13-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260517135416.1434539-1-ziy@nvidia.com>
References: <20260517135416.1434539-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0017.namprd05.prod.outlook.com (2603:10b6:610::30)
 To DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: 7275ef07-19e2-4980-15d6-08deb41beae2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	4k8pw3ZmMTS/JUQcmq81Z/qGHLhzkQR3OPxaIOKzfv4YK/HgEUql11bCtGxgMwkhcuofpfmhRYGcfsIgD3xZDof3e51tudRXUhuxf37jsshmr+FBPuQkh01wpMWWKLIK3sFuHbQCZUu8MUP39uAU3Esq0gY/wYBEe0yswNdILP/6owrgx9V6n4lSSCUw8sTfB1iK5sfAzjO2rxvhYq2+lrq7cizf24KXsXVQjf6IcBL1AY0aB03QLLVxEq2SMDY5zh5dnEvBpmy2n1W6hBTtMM7w6h2YEuPEpnBT6Li9OsEB612kyI5Yrw3QrcJ1J+Da2VhSTq7MYAxSxWlIyDT7E2X5oJBuR7zsSnT8ajcFZkwLikfefwE2vfuRm1FSe9lmkYCUAFF+N6ZZqG2t+qjZ4bHnE7+ltwEEhSa7IfVZDxIp9xuPbZ7oLBNcRVv/BSDb/vSnFlYAIUkW4A0momXc55uNXSbhgGDAL8RrrNWee3ZrZAWPd8vzVBzkkLrjnlQ8SolZ7R0ajdLO23SCKbO8ij65je7KwFLq2ITVR6ORC5/gAfTJ8N9zUtFGJi+yyAUP5ZgFzijrroJTwFfmQF44OzakujK9ifNrAdzgJM6RdkC2qvSL31WTAj4loLRxRR9GfgWNg2q5MQ91natCCWLEvgqFkDcIv/hRyl6PXHMmdlydgb4V9s1G4qPWxF7Dvfg1
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/eKYREkqW9GTZdjOtI/Fz7B3Oox9z2QbdRlp5pPu+W3t7QomTpTeHMxstfNF?=
 =?us-ascii?Q?MESK6WLl2RWvKTvUJvfTcsT3M7nvsusWvDhriTfY2yUGA50OfRvjFWpokPDt?=
 =?us-ascii?Q?o74MvByZYUcEIqoPGTl0etIAH5oLDKu3ZId1tL33ykyT3bmN+rF9VOhQcnij?=
 =?us-ascii?Q?PMCvBrjiFDoLoLG/FEnmYkAMpsYsCzuHe7ADTtB6U3ReCpNduRVVcptiFoE7?=
 =?us-ascii?Q?MPO0Md8J5vS+/zbVU4PrmkZFihkaCr1Zpe3Mv3rQYHogj90/h9GrJZRrZj0X?=
 =?us-ascii?Q?lqr376okN5AZmCst9k+sQq4s03WhFRSquOMM2Heu89mPkDWMN2PcsX2vxIJy?=
 =?us-ascii?Q?oA99+FALxgr2fQjYdQF/46Zq5QrWD7Ce1xUKG39JwQbtU2o14Dpq5U5ydP47?=
 =?us-ascii?Q?DOPcgDTfnSfGp1c+wPhYpuuhEx34ecSBwQ/H154/CouRbsK+L2mfs7Cc8dDQ?=
 =?us-ascii?Q?s+Z6wDDEPVHHIgGbACvVj/eyqRDA0Pfz4x5tRBXlxf1ADFMERpF8VPLuBjHP?=
 =?us-ascii?Q?lktoB7HQsVSfhsFtpF3+x5PSFtauvUa5+GPMwyIT7ABDsWPBgwP/nINfJ3Po?=
 =?us-ascii?Q?bPqOEg4OjDJeaOlO4xioVmbyVYT6e48B6hI4eD8+yPyPAOEpMn/83pF6qtvb?=
 =?us-ascii?Q?kGEcudFZ+lPDsQnq+OiWFulNF4dDIKzhkJw9jvslOjCc8dsI7OOBysecHybL?=
 =?us-ascii?Q?wT62xjwmOSnL9GaO24OveOjinw5FiYTPsfX6C5yoI9oUXfmnj2Fvl+zWb/Zp?=
 =?us-ascii?Q?b30xUKldv8BjQdtVvlgAbOLaHgA4dpu4euf28AAYzYCslS2nsBAkYL3fHFIz?=
 =?us-ascii?Q?dYS52A9yRP+gABJEUGCwUtQgqnOgihRVMIOwinaMW/5W8TgOuqKzyapqACCf?=
 =?us-ascii?Q?Xt6tklH2CxINzr3ql9pw7XnsHQ1LJQLAF+Ys6BdWJEL+urVm8HYgm9rClJSt?=
 =?us-ascii?Q?+7kI8EZLW3dUbaAsGra+MdwPKX4VC4ZNxt/rh8w4Rvs4o5RfBvXPb7iFJtQt?=
 =?us-ascii?Q?Otc2BI6MBt9PAC9C1Ah/XDjGs45y5YJcOQYFIR5iuiCKNNKz0swyVcOJ3QU/?=
 =?us-ascii?Q?mssoRJiauMQKKZHvnTW3kcL5Ko398Zt0nDm9TBLbHD0hQNd8feFqC3JQi9Sh?=
 =?us-ascii?Q?eUW/J2dm+v8YeT4bKO38bGDeU6ErPwjGAqmGcen52gOcikScJsyTowUQcU7a?=
 =?us-ascii?Q?+sloX4ApLdjyazGL1MwZzpI52k2Sch6EzB1akl5is2yp9kYiczXixFLmTwTb?=
 =?us-ascii?Q?vE8ImXXqBhtRZ9lrYqXHQY6um5HrlI+DSnzgVWkqjNGLRcxis4shZWZZ/7xP?=
 =?us-ascii?Q?DcpBEoIhjhIy65HTffLog458GSAPrnCwaK8GfSu11prIzPmnGQRcAwDtppkH?=
 =?us-ascii?Q?vnBKU0705A/sITTmj+pC+4XU387pS5Y2yloSl9Uq92kSDYf0RE51RGeRmyfE?=
 =?us-ascii?Q?Uqwf9kYSauenG+H2c8QljngmyMhnSwvi4BaQQTYNZj/L7MFHuDEl5Lq9SLxo?=
 =?us-ascii?Q?6uCQzBASflRcVUx1Kqlr3sB8bPXqQjZikKDHcWt4ORoonr170fzL0RLe4p5S?=
 =?us-ascii?Q?xpuu3tEoYoB8UAcylo3zLRZwzIHyF4YfK/oQqdxNqzIsDzHRTrNAvWUUqTEw?=
 =?us-ascii?Q?Nmt8i3Lu4Qx4udx/vcA9VeIP0ey5AvSa0dTewVVfq4YDrlHAs1zYaNsNVQo1?=
 =?us-ascii?Q?54VftX1ld3r7O27rldPBlQrg07Uxa6H1ViBYSJ6R1+qQkwcx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7275ef07-19e2-4980-15d6-08deb41beae2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2026 13:55:13.1926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KLawt0Vg1t3TzyYYuDg+vRk2IfQu2hRY739dABhNR0R35o54/ZRXVaOjRmhRYJ2D
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6322

Any file system with large folio support and the supported orders include
PMD_ORDER can be used.  There is no need to open a file with read-only.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---
 tools/testing/selftests/mm/guard-regions.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
index 48e8b1539be3a..1176398919537 100644
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
2.53.0

