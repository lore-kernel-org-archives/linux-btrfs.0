Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012028.outbound.protection.outlook.com [52.101.53.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F42937C92B;
	Mon, 13 Apr 2026 19:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776108076; cv=fail; b=sEeuHe+yUsissO6WN8aAJIL0Z/ea+Ra7XcnXk13GV6jdhxyXIx395u7mQ4UkVgOh5FveSB96qCfwhoGiPaTlpZAVZxXFi+gfFmfs1EUYx4uypARBu8AD+MCzqrZQNNTahWQQeVVyRV7gF2ZOAAvCa1q1ojqq6MoyumS3S1Vtysk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776108076; c=relaxed/simple;
	bh=kl+nhqAgppA1Mp/gMWSttAhKOmjMPtelEgmQnKlvprQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BScsusXeof3h2Y0Jg99l9bKcWOUhh0i2SO/95Ru+N5kb0fy91NDxvkWXoLRIJSwJeGfNUHuXDOE1NfCOgX9ql1rFImZqEFvW4GaU5ePD6edEwBCEJy0deAl7z7u3FaaMzz0SMyI9le2DvvPCcJKCc4M4etdQopsEUpg1uMFAnXQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Sm8dKinC; arc=fail smtp.client-ip=52.101.53.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Sm8dKinC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XmmwKCVbf/eqCyx85R6zhWS8BcPicKA0TdM1lwYll3MQreRIV8s925tbuUgyCp0ePUj1wz9wh/0l2jstCn23Ddlj/4QmCfJx7LaGWiUM68nFxwI6vtaz22nl0/4Ix3OvdS0hM5O/IqwQDDuI+w6KMs8813mV85YBeFYRCv0/gEueze76+wZKT67T5TgbFKfGOcT+wBvvKTyCbLaVTVIeSzBbUcM1jxuyrPa01KJcESQ+Zgjxa6ep7P2j4L3PK2tMtFxPRizTz3pNx7HzqVIcJst6Vj/K93UG/43ZlV/QOuk4+4MlrST01reMOenYqSMS97FxbekMgR60SQgKkC4p5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4pPDdKDPyAnyBEpPwSyNQ9WAtdgTQNUESex29jy0624=;
 b=dJu8rUK1Bqy5I8vGx+4onBD5CTQo4B/2wKFyDO4XWG5kTh0fa5eQ74V0JlhKkKQ5EonX8yRoJLiNFpMtYPqDo/rgCUpvCo8ITl9oSWtsdgepapDEtk/aQW7gg4H9go7F9bMgZ1+z+blTVwAImPx5RfIX3uRaxOyDamvfQOubEu+17Ezf+fyJ0oKo5XBzSiw3EGbbm4pTI1k3NehQiQw8IbePJsLyAlufTqmR1HVeAnelisA8Uhd/iyKSWvf48q3ox9N/NCx+ZsKBvkzDqOZpq1nlxSYQWWqogzRVa6gBp9keHw9yLQW2HtmRs4u2ti61chtutVInqEkat7XqdyfRkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4pPDdKDPyAnyBEpPwSyNQ9WAtdgTQNUESex29jy0624=;
 b=Sm8dKinCXTEqnk1bS0CpcWQTBARnLna+zo14A1BP4VptL/z4Gw71G93V5uM7VK8FbNYYRgTPAp67Zk5IXRph+wQRK3m4folu+eUuppnWTB8lqg2Ie+VUAvh8L5oshtYXQ2o2XQgtFhjQHwe8XkLy5j0SydGb2Em6SjKcfTrKJJJ3oxYa0ubBIyc2eb0pv6agwhmc6Jojelwj2qj5aPUvsXHFwXgRW9O0ibox+edESsdpDkH6ip71PHIFS316wrUSk9bsY2QybRofs612mc6AKkNS0rGB5OsAt2/wg1BxJLMkQ+1A4YY56UOR+W/FbWTvXqV6bkpxbf9nP6SVoj+nkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB8444.namprd12.prod.outlook.com (2603:10b6:8:128::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.20; Mon, 13 Apr 2026 19:20:55 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 19:20:55 +0000
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
Subject: [PATCH 7.2 v2 11/12] selftests/mm: remove READ_ONLY_THP_FOR_FS in khugepaged
Date: Mon, 13 Apr 2026 15:20:29 -0400
Message-ID: <20260413192030.3275825-12-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413192030.3275825-1-ziy@nvidia.com>
References: <20260413192030.3275825-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0294.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::29) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB8444:EE_
X-MS-Office365-Filtering-Correlation-Id: afbe1368-359a-413f-acc6-08de9991c8c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|18002099003|56012099003|20052099010;
X-Microsoft-Antispam-Message-Info:
	46vxjgrlBFZ2ylFmQ6x5dgvRSfx18KU3gYv2z3xrKGD4/M5sVyiytlW/6Ftc0GL/KuBLgVMnGCz4Xkl01+KGNJNkGKsq8847mm8e5oqVJJS1ggsFBIO+1YmWIILKMTQ0WBn1QCPyHHRH+Q8fDbXUWjPVmH7fjbBdgSbo73EQQcwwJp1JHsQTMvW6KXAJ4zwYLV+v0/eCuE7eJOmrhKmgrx6clCIHohJRtcKDWyKVgmkYFGZwAnHdcnWlw+d577qh7oGRZEe9LX11BspGvnPKxTHZCg7gphRQvuM0kuHuy4jEqABTVQcs2SeNqXRS6LhRwtToWvUgsjWFCvi4YSj2hHPyNj0k131UojtOG4gxmLcboT655vVwjWXkLdXJDiLyei8vf0kE4FC6rmUsl5TWeFYfsRGsDDq/qbTZWGZPdzreVy9leH44OnZ7tz2XDkGvVZGtxp62tfePUgEL6Dl+/tYmbuSsqJDzjP4K0nTrLkz/EcAdKS/EZ3OoHUjyDSqeEewVwegmGEMVSwwLWa6fB8NrY4F3rH39ZkGIzT+7KzGbp6I4gUj0qc9uOYdpy9NBI0nNCkJEzPV1Zt6n8Bzo3DfrfHWU6+0z3heAUZxo1kN+sB91uPsK0nEXhk25p2QaaPBl9Bl5hhSFKa7fQX/ddrM4LcxFBB4BOUd7PsLFhywi7dtM8Qs/Z+fjq9mM++GnVUR7GmXhrptWB6FtE0L5TZSmQrZkDUXpQP2iSZ/Ep+A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(18002099003)(56012099003)(20052099010);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PRuqDMnll0vZ8s7uEOG05DjVYdQ75Bq1h069S17yC4nB2VsZh9BkNUZ8iR0X?=
 =?us-ascii?Q?zniRfT8vbSM8adWFeB3FLgvFHGiCZsw8suNTxW5ehvojABYu287TEViGkBgl?=
 =?us-ascii?Q?WTNW3Z7TBGcNsIZ7D01v23jk1bN5WXny8A76tjhAxXSebSPtIE0Y21vt1DuI?=
 =?us-ascii?Q?uiehOhhOhvQqv/rjs/OEo411S36DqHzADpa6jS05wVFzYkOoTbI8acJFzBld?=
 =?us-ascii?Q?NPD2yaUthjilXFK9YuecrKkd9PB5UlZjuSTkwmgQ+VDv1cIN/BulfrUGVFe4?=
 =?us-ascii?Q?YUs8luwuANEV9Bj2r+r5pznXNqut8ZANYGY701joRK1mmMrm+5mVRb6/PFH6?=
 =?us-ascii?Q?Ken4ltDvXVZRt3LQ9h1POKk3y0FMl83/97Y6U26J7m4mPa14CYw3Ot2ceiji?=
 =?us-ascii?Q?XUC0iCi6581bzwsDrDaVvTBUnHQWRxhTQJ6Hcud26Ma49+lrFaPzP9PZRpaS?=
 =?us-ascii?Q?z9puk7Nel2uqxfeAA3Y4H/qkQMjOnjTbAMhBhyXRumDrPpT520JgEXWXuZeo?=
 =?us-ascii?Q?+hDiN5GLN9+nois0q6H6QJHSkvjr17iWgu6cW2PNUJHh/58NWhPCBINHMd1v?=
 =?us-ascii?Q?6Pu9OFP9aDPGkDD11H49yGn4c6zIBH8SEOd5KleVLsVlSmhBEtPOABQGGQyK?=
 =?us-ascii?Q?wSFy7wB1JSHesS/TkGFS1quH+NU7eOUFTWxykTc+FHnvhDcP3NSXlHv3/mDi?=
 =?us-ascii?Q?lVMtjt56Ul4/1kAanx4eqD8uxJ7HyJqwVkFZuQfaB70NYHx5tSkFsZ7GJXoJ?=
 =?us-ascii?Q?jEQOFEKOV9L451nJG52syoH1j/CUH4H+Q3ZLvtBzoRs97m/z2u3AwoejDVUC?=
 =?us-ascii?Q?b0LkO0WD0F/mif7DruHh72rTTVNZ/kpvuswF/Ux3ZAH8koobCr10KNacjwKH?=
 =?us-ascii?Q?aWFmsbggYDJHDjge0mu3nT8fabrra9s4YQJpTwD/f0Dxd9NlwbzrDBkf+sc7?=
 =?us-ascii?Q?D78qyh0a/dQAvbFKnLrIw84sQrQSZThk6jjGKzGuP/ydegZh3/ZJA3IZTUC/?=
 =?us-ascii?Q?BH6IWCIhTqrCTVtvchNw7G2+a8e8Gu5A7Ox9PhJYY7uPeWS7zGcRZcGWNmf9?=
 =?us-ascii?Q?GOEiPBQBaPLJ5fOIoI21sNIHAzcMDoO52TcFIOIaAzsPFJrE69c6U+SDILIt?=
 =?us-ascii?Q?cm7a7nZnNMijK6VMFTlnQrE4dEfN1TpwU2Abojema8ZVUslHQMiQnzEQprlV?=
 =?us-ascii?Q?JLXdz3fUMcABYsipb0CsfjU2KLbebcZAqX8zqsKVgZ2Njb+3L+tnq9m4Fhk4?=
 =?us-ascii?Q?5T9QpNrgthZ3KpIQN/5K7AQFX1vdqNed+12hXHq0OyKy6L3pT0s2C2Scrk/4?=
 =?us-ascii?Q?+paCnURisOe0JbFICc+qALAl/lq7I8tksiq2WoQdUKz5waSyx7sxJ1s7HUGo?=
 =?us-ascii?Q?zo0il0pDfUqiPQgsEIPE/uEsiTsaalgqRR+T9wY2g7B9YdFk5VOZ3s7cv61Y?=
 =?us-ascii?Q?YdXtmUrhOTy2+HIOGCy64IR1MW1rh3MvBKzszx5a+cQrgIRaFYrx/8eVKZmn?=
 =?us-ascii?Q?ZgwojjLXXPj2nWqxGyHf3QEiTykoCsI5AhOXBIYBqlymnldI9zb8InFj5EsD?=
 =?us-ascii?Q?yJeU88F9q84cznO6/naRzB2Pt057PXKw8KyDaFxzNoasKMNTywXhY67CkXc4?=
 =?us-ascii?Q?45DOYfTPK58c0OAgaSvH95Coc7CsXVQgv1INZtce4p9OmidKVsdUHFpcKBtz?=
 =?us-ascii?Q?KCDxUVEXlYUAHzepyKaahSO4HGBoe4abrG5RbWcTh6z9eSKf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afbe1368-359a-413f-acc6-08de9991c8c1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 19:20:55.1812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9NjVIBapyPe9fbMyTiJ36pNKcy+48W4kMjXYKYoQvYGBa6bmVdqK3PB+pLEof5Il
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8444

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

