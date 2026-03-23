Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012048.outbound.protection.outlook.com [52.101.43.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C620333B6DA;
	Mon, 23 Mar 2026 19:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774292827; cv=fail; b=cWh29ql/OTkNx+T4znZOok+6R48jYBO+5veNyvOY1dQUWTrk6EVlmBBkP3cIdTXWv0CQ9Jn3Kxlrv4PjUUSDfriBTFqNw0oZHv5ohn70uDTX9Gmd4G6qW5oAlFvyV/tbM16xND7XI2YtpVp8PfHDFp7THxu3bQ9cpTBnyEvSQUc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774292827; c=relaxed/simple;
	bh=rcaLeGgsrx8v/60V0pTsze+7Upfx407OJylaby8wOH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rVelEEmJ2mNCTZ+doZ05QASNyJHnN15kVmWbY9j9VHqiv5TRjqWJa9fIzHTBPW2Q/0gHzfR3GCsS4LChx0jt9TWolFhUL2Qm3AgfNPYzFmKPuzuFyZAjBWkP4rKWgX3hFi+19kyluVQmsqs/2w356lmKKfKtln32mE+4zDsOYsY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=k5Gjrg+6; arc=fail smtp.client-ip=52.101.43.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="k5Gjrg+6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TUQHdSdUrSTUbrz0C5Xfaix0kDtC2r3jKfCuzcNSy+5myorLvu7YHdgQKOKGazf4fyAEdkfe2WhHPvVeTmUnz4HMYQ5UZiFJCgtHQITbrYz91ippVAabMqLEz6VT2T6ZAm1fCYiiP3s/D5CxYrJk0YPzGoP9AhnFuGf5DvmSVXELZLXxW4SeFVKU3YTMJuxTsL3ET60NBEM4GryKC4B9DneitXmloGn9fpMUlxp0yWQ2f3u1TQEaFdpDhTKkdPD+nTTpnnGDoVzAc/N5oDFLUyKC8yQTdSoLdROOaNDnx/x1lXp/tMGlxiV9m9dlVdHSEnb+RbXXfbhSBKArN3UbaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c2ko5uCQXzCDh+aC0otcCCj5ZAwemX95pEk7+vX7kHo=;
 b=O4wJTjbbADzD7Eqz0S6Tj/tBJTO04Q6biMkWjpOsUiLb4fW2BQ6pNuShOhEH+zXtfYqYHWmqtvGUEZ1IbxbQWwmIc3CvxBBarlZoQb209vqFrVHeFGslvb4wxD1S5/y0H5ZOqOJ8Lgopl4eu3tgB/FEwSeWxYS/IbMz8Uk5gixpEiHk8nFwRtmRkyK8NDcYANbdgoYawN8F3oS9umyN0k7FY+AJUdVF0RlHok1TuASOzHwF2ZVjXA7Y3MHYlzBLQyE6cTIgVWMxKr4IfVUFnlpQUvNBoDhRUMYvi5nzsTldgKtm6BG/ZN+Yz6G6iL30C960ZeY51F+0KROnCyFVE0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2ko5uCQXzCDh+aC0otcCCj5ZAwemX95pEk7+vX7kHo=;
 b=k5Gjrg+6nuCRWAJzjoLj8yZWIsLNgB4i0cQWcP4v8HRz0wowUt9UaMzPM55b9P0VLgleEYBEyvcRnKJcU2WR8vErZ0nka1p6rJjjmG6B2AmUriQwiWnTwH0Z6twY2Im6M93rlh6KgK+7cNxVtbC9JsvbyEZ0JSmx+DHcHQ/hJnwYKTNVp2M5ar0lR5NAvnC4KI7AyKstmaqgoEjg0vsXJL94fFOnnGNpdxlD/SLqWf4vEpLNH7dCiM13EIENi9ExOjxuqKK+hjUaKFUSdrXj+mff0qOIQ5dXTmwsWNN691FVfp59IK985vsq1H00oehgWk5QLFC0Y2xIG1oGYWgTpg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB7607.namprd12.prod.outlook.com (2603:10b6:8:13f::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.20; Mon, 23 Mar 2026 19:06:59 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Mon, 23 Mar 2026
 19:06:59 +0000
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
Subject: [RFC PATCH 08/11] fs: remove READ_ONLY_THP_FOR_FS code
Date: Mon, 23 Mar 2026 15:06:41 -0400
Message-ID: <20260323190644.1714379-9-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260323190644.1714379-1-ziy@nvidia.com>
References: <20260323190644.1714379-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0309.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB7607:EE_
X-MS-Office365-Filtering-Correlation-Id: b264ed22-4a04-4dc1-544d-08de890f5c00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	UdEofutM3p/YW0aUocogq2sAwyiwuSf7+VI/XleOtYuu4xRVJLHto6OF349E8oSvKzplVpYOpINmRlLPq72xN7RD0fK87VhLjtI/c48IxSIBiEE7szTCu1ltoTT9ZD8BI/wVGJdmW58sRmjezVKDLQvKcrYtSBjKhtuxMorHysismLDogAXS59ZFs9WDuMCrl/IXhg9GyQzZwTHvtxCCjEm85Pb2hdFNG8WAh4x4SsmM1gc+XyKBj/rg/PYdxixuCNIib5YEbnJ1M65OIgf4cYKwPLVE886kjwUU1DKH6CGru7UUMgsyFJjQSilPmt32Ot7ybdy0mfGzuLDdFBQFMvQ5+NgU53YZGpPN81Qyj9odldlMxMi4Xfrc2gnxMar+cBFBUUlxRamEUgAXFeM2oH0XzBCkjp2hPF9K19RXNWyRd2y/RByCNjfnAE24F59TzxPM1vmyoTPSTfZvPDpFnMk9oTMw7XXWPlumY2q6oWwjJH8hdk/13wgQHoeZSBbxiW7uzq/BnDYAdfUbFV2cVaMyaz3PI5s09KdypDy0AC2aTPsgZddjMyF4aIs3tHG2Lcq2TNqTBreBuIQDFAWksis1C9hQLv+VA6fgqmwjXCEXvEvVk75hWEnqtXkDefooi7UvhfPyQuxivOIHBkaPDV65Q7Ue1ZLEMP1CJDcPgwzl6WQJvXtgFXRqV6mCpRJHouDXD9kcqxgpQR8FgJ61fLdGB602NnQzlhvHrBzhudQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k/puz1SoeR9r94KFUB3A2NYEr66uh4zFBjXP7tJQA5eYfwmG+N1L1fTQe9Rp?=
 =?us-ascii?Q?3GVozJKe7KQf2CUY6+wqfI/3FH0q9H8Bymg3kgvSivaVsqkdhehYz0oBkL6o?=
 =?us-ascii?Q?r9E2Lw8ORiRQKAeYHPAE432Ar9ONx2fjQBooq4ObrwRHuxZlpejgyio1/LD7?=
 =?us-ascii?Q?d/9qUS7GTxLUax8iOVPKoI4W0Hxnq9G4tixV1LB7X998WquQh2FJU7DLBYpA?=
 =?us-ascii?Q?Zjtz0xJzOWJCEz86PBe3gyC6SIunel/ZEqjaPyj8/2WTdNENXJYYlPUXYFeR?=
 =?us-ascii?Q?47j2XXxvAZYZ7rYzH5B346dgnEs7LtoRbEXLGqDr/3AzbSHHMJvmw0WR9GJY?=
 =?us-ascii?Q?UqHb/7T1Fp7qGZFey/1x/OW2rvarIXN1CjoSiYeUv7xHR0lsj4mmJAPLTXza?=
 =?us-ascii?Q?/GZjuEm89RHzh6FmIH5QaX699KlCDQIlfcFOJSjh+IbGTUiLEEkF5MnqWX0z?=
 =?us-ascii?Q?VcMGf1ZM+geQYysCo/x6ZuGtW+FsPJWFEeVWMioaINjggaC8ckoSKodZ69eA?=
 =?us-ascii?Q?lYf/CT7H/8X8ujk5+ic9hYJpw+jRmMm5kBeCyuE3btNQCeHyKcxAryy3sm85?=
 =?us-ascii?Q?mC3yf1KDlIeNHOVdi1w0cHEY0OazghQcPTrf3E4E+NLV79st0r9FUWl3kfZL?=
 =?us-ascii?Q?NCgLaFMLibyiB9ut1bq+CG+ydLRm+56Crr5XnteZGIWRoGUzNBKfQ0PzZ/vT?=
 =?us-ascii?Q?WM7jfM24ZLZdRY/9icTZT2w6ItMohYhNBghYImDNWQkRxIFweFn51krFsGHY?=
 =?us-ascii?Q?tG/25e5ePRP/jz8epgqG9ht4XxsSlW1rNryhnRhi203Xl8l5MCBL5tPd9zsO?=
 =?us-ascii?Q?fXWeoxf2l2AhODl7kLe6ZnHcvs+/XuaVcuktlBMkIVveNibOTo2rspEco2dX?=
 =?us-ascii?Q?6cW8XR3zK5cSvR6xOK1HmSnH00l9hLS9V9zqvA9Sjn8kIhIE6hEJohGlqT9s?=
 =?us-ascii?Q?ZfAqoMbxRTCMS++FAGEeWI6YmdJSV6YTf4ZitUTkavC9+3r97EjJFzLwXz/z?=
 =?us-ascii?Q?rv2dplG3M2L8KhUyCsy3itReETnbMai2h8IoX/qqIfFZMFdDrrRTw049/zm8?=
 =?us-ascii?Q?Yr55XV0f8VaO8kPLxNvsMy0/CqLOfKLYcobMerWsO98olNnYNlw4NXEcF0qg?=
 =?us-ascii?Q?HGz6KShfAUKxZyTIRo8DnUwHER/3beNlIYK9lK2UQW3cTupgwJ5uGKJu12y7?=
 =?us-ascii?Q?nYnLL6AqfvQLNNn5sPkuU2CgLAZTCwNriBrkX98A/pKfTIk6PIGrLVL4DztX?=
 =?us-ascii?Q?n1euG91ZrsmoPfwJet3bPtW6d2WwfKMuhAkAmfSFGROZx9iwcuQjtz00WlgN?=
 =?us-ascii?Q?CrnzRzsBX/JgO+LxnpAJPS0jP7YbL67u+zCx0OVQ1hGiTfemVnyCHJZqbi+7?=
 =?us-ascii?Q?hN5vn8IarZXq74i17pgE/wghkm0AWSxDU6/WFn4LlriyTWoCTQ9tivSoHySV?=
 =?us-ascii?Q?//Ww3DD+1shX8F5szt7wH2OeCWixVdXGP2V1GGTlPrWM6h560RIX8zHmx2M5?=
 =?us-ascii?Q?fiVT7w1dIAV8K2Nrm5GqKNWb5DjiR9QlGoHbJfoKZKWxpI5BrTdjkzXbwlrq?=
 =?us-ascii?Q?d8AL40tWSNkSmvZhmcuRAEHiKM9gDjujDN1iCa8+BHL3jJuxKRin49C9xurQ?=
 =?us-ascii?Q?30xyZHTQM0eE4t1Bk9BbbFluC/UkgBAVDJKrmsVLyhitSU5iE5t2TCpsSqNf?=
 =?us-ascii?Q?YVuZVj3RHm/BPZtyk+TQ8ptooJ+cWAVBL/75YV56QiDD1frY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b264ed22-4a04-4dc1-544d-08de890f5c00
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 19:06:59.5363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y2AE/FhMhVYbXMznqXMJZ7LkavDnxi3CJagBGuRNVAxKo/WCFZxaF0ORKg0xqwcm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7607

READ_ONLY_THP_FOR_FS is no longer present, delete related code.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 fs/open.c | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 91f1139591ab..cef382d9d8b8 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -970,33 +970,6 @@ static int do_dentry_open(struct file *f,
 	if ((f->f_flags & O_DIRECT) && !(f->f_mode & FMODE_CAN_ODIRECT))
 		return -EINVAL;
 
-	/*
-	 * XXX: Huge page cache doesn't support writing yet. Drop all page
-	 * cache for this file before processing writes.
-	 */
-	if (f->f_mode & FMODE_WRITE) {
-		/*
-		 * Depends on full fence from get_write_access() to synchronize
-		 * against collapse_file() regarding i_writecount and nr_thps
-		 * updates. Ensures subsequent insertion of THPs into the page
-		 * cache will fail.
-		 */
-		if (filemap_nr_thps(inode->i_mapping)) {
-			struct address_space *mapping = inode->i_mapping;
-
-			filemap_invalidate_lock(inode->i_mapping);
-			/*
-			 * unmap_mapping_range just need to be called once
-			 * here, because the private pages is not need to be
-			 * unmapped mapping (e.g. data segment of dynamic
-			 * shared libraries here).
-			 */
-			unmap_mapping_range(mapping, 0, 0, 0);
-			truncate_inode_pages(mapping, 0);
-			filemap_invalidate_unlock(inode->i_mapping);
-		}
-	}
-
 	return 0;
 
 cleanup_all:
-- 
2.43.0

