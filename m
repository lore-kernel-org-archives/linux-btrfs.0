Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013055.outbound.protection.outlook.com [40.107.201.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE2D304BB3;
	Fri, 24 Apr 2026 02:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776999147; cv=fail; b=t9yLh5mpPJnfjdzZrEYy0L2kKY0GIl5WZcRaiZa90rGZoZHhmgvhKciAlugQ+MVKC8X6VUwJwWlXwBYOGjE4A958KefE2cczc3O7e4Bw4zN9LW20TlDrD/CtOCnOUuNPaHsBzKTxCDbfJo7YOzQDMon2a++eJ9Gsz69I17OJBJc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776999147; c=relaxed/simple;
	bh=oAKpqr2x37ZtjOc5sKMHy/Xd7zMn8LbePVFg+WVYWPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IOHymCAb+R/TjAQtlKXHlzhH84it1Kt9O2Eev99DqMTHMwpHMwWjbKfpxjoRWmw2vYPSRvZ2Ayl0KpNlrhGwbIezHVluLarlFifhLNXCq536/cdjngLgBCHvxgzUXQIrUOfM27rVKkxxZU2BjToGsCH2TlfEceDuSQQQjXf6Kzo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OS8CIuM7; arc=fail smtp.client-ip=40.107.201.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OS8CIuM7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wwnaiu3hKks4cLQrdTgsuFoDyGWD2+FkOihNu8dkL9vUGnjtJrdCajEqsbvkGdgOp9emWEGpRFgtS5gj1okjxB+j17j2pANhH49lrpZ7LKiCQpC4pGb+mFXuWkmufSGPk8sqMBwFDd9Z1KB00tHXu6uiVzO1PZpdfBFgWnNdG7wl4CYziiF83+A0p05H54gzfBvZj4fPgMyuyFV6TgYOdwK2kBwRVqE1O4FcC3+TSpITcmST409CvGGuLR0q0+yG1T+GJLUj52EQroxlLjTdbhd/TbgNX4NIkpKEfxucaKrp4Pp/VpYIwO9ZD2ZXGSQNvWY9lyGyeDljgDFNyfzIDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VM38sIiJ+95s8TB0Xa1MicOktvPKZBg8+L1E50XHlRk=;
 b=J4Utj9UeKsR4qerFhlzBQj+F1V/ZRXlhEjlfilNhUTR0R+9mBpgYxrugE9GaY67IPmBJW9Zrq1OI6WI1WF6mqa7sauFn+lrxIsHb9dqk5zm19Me/BHUOKqJdy/NZAyWvwD9eymc48L6HPuEE7wvWlH1PbOFBy+1Anoe53vyfGNj9+cDSDFySdx2K4FqxNvOKHpVAAYtBk0Ip28iPC9ai3Tg4W1cHkS8vJBEztXsDNTi1oMsJBoBunuQtOUcq1MXlVL47r1cvwUaZcwTxkulu+Xs+Y3vklwY5DMXSGhIGABFAwDZmA+OgLMFXnl9sPzTcw+C0Ph2GWLp+G5vfI3BvEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VM38sIiJ+95s8TB0Xa1MicOktvPKZBg8+L1E50XHlRk=;
 b=OS8CIuM7sznXcPmCkDYnJqkOKfJvCq7/t4+wyyY15jMwH5h1jhj+aQEIZx9LKW0gwsAnV26hhJNmdiM613A7nllyYb/T7Ggt/53eG+IHcT0uctWEyHNmYpzfH3/UoYcd1WvwDjXfzdtUZvFjhFKV/bjRu/dLgmUK2964S5983xZy6drVeLpEreBD337wi8ZkRpl9BsHJhE61n5OFPT6JAudx3XVxDG4IsuLdT8/kkjcWimxMeuanXVcyisASHV/gMWbR1zYXZikLKWCI1NLza8kzR4QpjG1/eMxoOY3rF8s263sfKyZLxd6RdJdUPZgKVXR/6wx5nObST9XM6l29gQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS4PR12MB9588.namprd12.prod.outlook.com (2603:10b6:8:282::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.16; Fri, 24 Apr 2026 02:52:10 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Fri, 24 Apr 2026
 02:52:10 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
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
Subject: [PATCH 7.2 v4 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Thu, 23 Apr 2026 22:49:04 -0400
Message-ID: <20260424024915.28758-2-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260424024915.28758-1-ziy@nvidia.com>
References: <20260424024915.28758-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0157.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:7e::26) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS4PR12MB9588:EE_
X-MS-Office365-Filtering-Correlation-Id: 03940080-34d7-44c1-6dd3-08dea1ac7b21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	J99AAubYhXHOpN+6eEUTscwDRg/rRmd22X64rvUWRIY7eMNCKg3tgViUjPLIq++qI/xmNWILAiP9ZyY6MPPMz5D8mlltv6EEKIj7eri3WKuiHUGGa7CoRbLSqL3IKTtUQTPbzFJcG9EHlCObry/XUpSHiR8s3l8l3KqxrYM9jlzU1TZcqYdsdAoHtEas1nH/kiEaFL+6m+atQxxub36VvvE32zbtl48XwZFh1pUehwuMyWl2kvfneVmWWs/5AxSz1fsFIJd+E2KslyRd5HiENm13eGQQcRuom6M8iKzCPFTLGihivtTzIlWnaEemcoZhB4z8Xd+U7K9vAr+PKcUJIZ00AK9JhSIOztzCcKWLdJqxET4dwN5oq1JZHGCZvl232zu/d03AO4+TvW4LaeR+nU+bYRn/g0hHv+w2PC7eFergPky6FJM1wn9T7gYFqZ4c3L+b0qxRskLPFRGybAbTQl1nw/QnvD1yVivD4hTeyvqGC5o3etFsMV33z9gz99Q5DPYkxyLY5USDJlK+LhjY1d/jhanAV0lrQXu8Yu8wsGscBgfEtqIjTxB5PLausVbPzR600PDzTUqR0+JqbhMLf2cmhmBXoPO79Od+Af4qFMK4mxRe96MRT2Fp9ISjgCmnzaD2c2eHKmRWbbvdsUT7tp9OSQPEpo8O3RC3TVgV9FzRpkjvyPD15Gi0uX0udSjqhY6MY0XZpzyh9oy79oazZe4SVWFmoWWIZrwxIZACSCs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kWILnIspuzN+wDGpXWUqCE7hUzhEg4mMiWS/TCdubcZ3OJp5cClGTd/DyQpI?=
 =?us-ascii?Q?/xijBmiwZVDgmoMQPAL9foOA8QLAD9gtxLyjlLcxjTEEfNwQ2guA8slOdBJ6?=
 =?us-ascii?Q?EJf9obxRaJ/5NZec6gzYYCXBs8MhJFzsREbWhc5dUMKi1gOayjCa3b4wzZzD?=
 =?us-ascii?Q?P8vBc9NtF4ZzFAQSBbFy0FRdlJqPSslffABWE3sMrB+IbAeBSUl14xAAmiVW?=
 =?us-ascii?Q?QZUNnPV9JqnOk1/5mPL5yylVIRSpm7OQaFx6yhRmnwvNRT25oGFulPFVZYQK?=
 =?us-ascii?Q?S0ccoZT9smAjxe3adj5FgwHWuKg+YT/IjhbQAQzrz/NhOm+A11BIje2mHDBP?=
 =?us-ascii?Q?srGoSxQxXnEWsqyYQdny7JDwH8Hif/RoClY9fgIVIj+/uQnDyJa9/xDhv3PT?=
 =?us-ascii?Q?9ZUbd9dlouWh6uts2l9MAt7yDJf/86Cb4dHLHI+/5T8NOjlAAewvaIQUWQvM?=
 =?us-ascii?Q?VDllL4HZt8iw95jO/TmEfpE0RUSO0TPC762nWUnZ6Tnhdue3zGNEuCMw8EVW?=
 =?us-ascii?Q?Y8HqFcvpnjZDTpqV7wYJ1VPwVUeJCfFeT25pWf6GXXkLOmY4/0i2PmPsugbh?=
 =?us-ascii?Q?+uUfgq5h+Js9TFH7tGwQ30uTGjH62yZJ/TQEDET645LpZCSe8XFMr3YhuAU8?=
 =?us-ascii?Q?k31iNpLm3FzTLD+jgstc4QxdFQY+DLrqLMyBZwZsqBGZVPI6nCFA/i49jQ49?=
 =?us-ascii?Q?DoZPfjP7gLm9iW7jui88wigv2/pvsQOFGIRZKuIPd9Ppdw5HKa9geMjhw4ei?=
 =?us-ascii?Q?3yJ/RXOJlM0NmEhTQTJkpFu9QtBajoB/VGGUwKBFb2JJdGTlk/SgFl9Hl1ti?=
 =?us-ascii?Q?7ajM6zB8S3eslAcv36ewaRuUcmdeMim8/K+FtzZwBtt28ZHjNa6argaojo+3?=
 =?us-ascii?Q?54gw417PcedjdMtfcgTV/Qcbo70a2ISWXJ3dbrcFueoo9ZX5eNzz0DShZyxo?=
 =?us-ascii?Q?V21h2o6L3pKQozQM1Fn3JFrCZY8IslctHfX3ZLTWrHpL7Mg+ad98rY8h1bCm?=
 =?us-ascii?Q?xLr5NSsi2P2l9ENTS4xYYTtUIwFsq5xYH10vfCeqNyS4tZc+fW4emHVWoavc?=
 =?us-ascii?Q?+dLWeCsgwTMW5Ej/UY0eeuhJG8DeT8kbVjja09eKhY0zIGMSK/TF69s0nNqN?=
 =?us-ascii?Q?QaAB3/KZ/kC+TMwx6Ng9Z/dc0BQ3pxdXM9f2mtspuSFprVCX39iBRGBFwoGE?=
 =?us-ascii?Q?st4KSXl8E9TfjXgvA+b5amoup/njsVwpnOzDyoOUt6/W/YmlFM8W+2/0gwKn?=
 =?us-ascii?Q?ECzlOGX0MNJd/4N2Q57FyjLb702nhysN1TkBjgDbT/OpcOcjZYxwxp6gFw7u?=
 =?us-ascii?Q?NuMwx7p7DCGY1/ncQBP5PxJHuGUbwOlMERiQ7BegUqtnQ5wL6z11c+hR0kzh?=
 =?us-ascii?Q?ohrmPJii2aziwHHmsvQ+TjALW6Gbg6tDo2zIarLh3s9TGUYfyI7+yWNf5Mxf?=
 =?us-ascii?Q?YWzda9vqdK9mxXA16+JPPvk4mowb65JKXMSSkjb/U+woFUJQlTcHazoIq3+3?=
 =?us-ascii?Q?2UvxEJ/TTem0CEvgoo6Rk9xrGTyoiKe3gUIIBqz2mGMd4HrU0AOC9ub60MEk?=
 =?us-ascii?Q?K/hbnwxgwO2yZA5vVbNjAwKy5ZfQfwSQtwa0Osc43494tKoNR6uJRJZl2rCv?=
 =?us-ascii?Q?V59Tk9CNGsAALoYtUT9iDu3iFDQm/UnX8aM+6irSda81JSSHITE4h5DChyLH?=
 =?us-ascii?Q?2FgsxtpNNojgsWbrR4HaRWE5Hdl7GaciN2ZFn6xLanE6qDSM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03940080-34d7-44c1-6dd3-08dea1ac7b21
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 02:52:10.6245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MuQ44fedzJWLZbYLCajhHwG/zpHgbgdIjwJ0uwTwSkF1dxQpngs3l3Fzs3W13ChD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9588

collapse_file() requires FSes supporting large folio with at least
PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.

While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.

Add a helper function mapping_pmd_thp_support() for FSes supporting large
folio with at least PMD_ORDER.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 include/linux/pagemap.h |  9 +++++++++
 mm/khugepaged.c         | 10 ++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 31a848485ad9..5b4313d91137 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -513,6 +513,15 @@ static inline bool mapping_large_folio_support(const struct address_space *mappi
 	return mapping_max_folio_order(mapping) > 0;
 }
 
+static inline bool mapping_pmd_thp_support(const struct address_space *mapping)
+{
+	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
+	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
+
+	return mapping_max_folio_order(mapping) >= PMD_ORDER;
+}
+
+
 /* Return the maximum folio size for this pagecache mapping, in bytes. */
 static inline size_t mapping_max_folio_size(const struct address_space *mapping)
 {
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 7d48d4fbd5f3..79f051eb6195 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2235,8 +2235,14 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	int nr_none = 0;
 	bool is_shmem = shmem_file(file);
 
-	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
-	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
+	/*
+	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
+	 *
+	 * TODO: once shmem always calls mapping_set_large_folios() on its
+	 * mapping, the shmem check can be removed.
+	 */
+	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_thp_support(mapping));
+	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
 
 	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
-- 
2.43.0

