Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012019.outbound.protection.outlook.com [40.107.209.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64F5314D06;
	Fri, 24 Apr 2026 02:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776999189; cv=fail; b=NOsZuk8F3r7eKF4DYf2sSkGbexHSFB5AzUZeWn2Q8OuRVB9EiulUdBsF/79aEF1O6Y0tA+PQYWeSsORqLpMRtb0v0qQvAy3ybTKr9798J5RPmVrqJ0xCvPrBWDb7voXSMlOSAmCiUICj//yqOHw1+PLrCfMMktxPjcNoxbg32kg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776999189; c=relaxed/simple;
	bh=coxrppTJGXWQDtuSPOtEo3pIE6kGyEkrBqiD1hCYffw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=D5d+FkaKSeehYI74vN0BxMJ/lb/rO8Xz1NNY9biQ3ZfTlUGxBqauki5BvXkHPRKVDUySy+MfsfZ/XcShHCTu5wYAVENH1gg2Mr7i6EwCtHlj+Oo4p8ekPWxLYKsklverhXB+KfCk2OUrD4Nm1lpjrI8DrZoLIyPHZ80F5I23qFw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=s1cKQMQA; arc=fail smtp.client-ip=40.107.209.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="s1cKQMQA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VGlZXHFSW1rXul6JTPpOo1nLhdRoDZCq8rQZ2RwaztJzWYnczZdwvIJx/48h2y/4VQT6IZk9VF9CPRk6Frpv2VAg8tAzFIfd2XNtXLYcaP6WiAfMoW3Y0AEPdK0FJb4myUg3/fhFFFhdAIUDKCODRyr9ITizbQP2cSPxRfr3Fl0mxQKIlF6Kzo3KuOtVUZdbrZcWqz0vFWdjYSW1C/11qmhV2tPMvo1DdnYs5J/zJ+Pfoh2dSgh45s1fGc2A0yDTWEK70HbcedW89n8vhXvNCEMUTV+H7fA5kJBw+kdCV+6vmJRiZFKpvRWTWA3BrudfcZ5klEDchXkOuSZ6uxZlwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZBxyRBoqqiTc/WT41TjhmmTGhmo/L9qXeALUWtsfAxM=;
 b=EPCbg3l/wvRqkAKU5eb4eXJyobGpPxtckQEsSkoTdqkRAxpf1Cs5rArhkUiUSJCKid6wH7gptNmex/Ch+rCdeylwQQw5hpAHy7JJVkSxim/pEILw8EaFbZ2kJpwNa8NSO0ReK7lkKGLEh4+pcTmWFVbTTsaAd5TJBRSQfQTQXrDl8SPViCjHhvTeI2jS3uPrVxAlQgnSOAAOApNsGPZGj3nggvXybRHEQzHAWU8+PUNdE82cblvydOemL3XAKWp+tHAH+AyM1GwPuxHYW6jnAVpJM2DITBYzlRIJcEgR7GKf42TqfMcSQYy2W9bEWz/z/ppXt7PeSttU5QzxQWgwRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZBxyRBoqqiTc/WT41TjhmmTGhmo/L9qXeALUWtsfAxM=;
 b=s1cKQMQAqNXe9JExzsuwMqH12LmOQLrNiTR6mJyro3F5KsX58YM4QiK9VNYcBH4Axfo8CItDzLUNse+75QszWBPJWt402SkrFnJpkD1YzDBMoijsRgucS3p0W7NSMHraDno2vO0WoZ02qVVT4zio5W8VmxYCI6jTq5tYgnUAtzvprY30MVErTNhOgpPdepIHu27zxu6ck7xnUnkvWbEyXhFgy++rxD8soXlbAwucArydgnEFfmuimcUMl9du6DQF2/wkf924WYyvmjsTJ/VJJvlfJkdvb+KOlONwW5c0UNxxevMmuffzdV/OHPQcaVcFpac3Kja4bQIqKe0onFmZJw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS4PR12MB9588.namprd12.prod.outlook.com (2603:10b6:8:282::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.16; Fri, 24 Apr 2026 02:52:21 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Fri, 24 Apr 2026
 02:52:21 +0000
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
Subject: [PATCH 7.2 v4 10/12] fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
Date: Thu, 23 Apr 2026 22:49:13 -0400
Message-ID: <20260424024915.28758-11-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260424024915.28758-1-ziy@nvidia.com>
References: <20260424024915.28758-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: IA4P221CA0008.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:559::6) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS4PR12MB9588:EE_
X-MS-Office365-Filtering-Correlation-Id: e80a77a2-c505-49e9-0328-08dea1ac8180
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	j38B6JutPiEN07CNONu0GooLNvVepR7R8/frFAdy+JPFctOGFcVeGpYIbb+4/N7R38ZggXtDdpiux+Owq5jc6AxbKRYCnfcFofGiaRpAewMlojY4uyy2B/67iWAs6G9P7wl+vyfnmP8dSp786zWq3x4ALUapiRTjGkQBuxnCgeIt5WLGjqjvzKJop2gD4m/E7X5FDUJklAF5RKK71KSoB5ZX/xHW679AK+wwSnyGli5pLa+oFBhuU341xDD4T/2zd05ODnE9RbYXRGua/inOGwR4dF+tjpwSJtxFy+A0qoIpmq+cED5xAMkXdA1TICBkR4aTlI2Yx8/mgyM8cxranYBIIebKeQtn2rxftN06tC43sD03h8H2+sMo9JIetjO/bl+sNDGplsaHmMh4sap4tHNicbeEvJP+Rf7eB/cc5Nl/Jf+ivfsbn8WiWvko6JvgxOtDYLuAtiGwincqaNgsDx8ojvYI0P7gLgR99fZNItS5DCMIPLp9/q5pZPZCjpyjBcO8lvuBJ+bQRcnfUb4sEkcEEnpv2v/4XcWhJGufPm1MwP8+AgUdym6/1GC7C1xF8EU/qlAd+DSvOui65jzokOPQSiuRkv0KMKn/ojlcJZ6tAVQFyli+h2Yh7RbIfps0WBRex4pCWi2TQjbNKgn09KOYzM57qEqhxWfYfQFo06EtBCusLoxDozE2oKUUnxwS2xd6lXZOjOHc+hJtBrcw/dk5KYqevfvvg5xWN/TEF2o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GcnWXDN41Nv62QFMNuBwOe6ZEVICaKwN6lCixp/dNRcer06b7KbuC6DQh9vi?=
 =?us-ascii?Q?id5gnJkaVjunwfGb334omtfDV/kK5kufcU7jtht9cbCgQKL/YE8HVmEdvy0S?=
 =?us-ascii?Q?q7QPodS6j7yVUAEW1cAndwnNmDBIMe5e8iZT7V3i4dOzZjfiK3scXVDYMKHm?=
 =?us-ascii?Q?dgOucf5plpM+AjzaOhTJYXzf/7txAcJQryX/+3GE2pmRs13IWg9tgcNAb8ZG?=
 =?us-ascii?Q?ehT/8ZfxKdcwvcWtHn/uazweb+aBydLFH4KCciBDj32ECLh3jwjbJ8PYJxS9?=
 =?us-ascii?Q?ocX5asMbECVbxamPa7hnDAf1UG9Ia6EgkHdgjn+peH8RiGNp7Lt3F87Z1X1y?=
 =?us-ascii?Q?q3MadLblDWwvAjtIJCWO+9P5EEp8FHTRuHqoBT5TVVfTB8yyocJS/SWaU6EU?=
 =?us-ascii?Q?X0lMqauZIuOBR7zEB8SvZcWQ/FzV6cN9BMAVcFw5CnKa7TGGXSO3DtbampRc?=
 =?us-ascii?Q?vM2fmMyx17f4H1tGw9R8P2/6gx/2BVpSjv0vGHNIjVVIaFrfO5m8FSrBNDwg?=
 =?us-ascii?Q?7XmEwpvtvWwHuVgNlpYYJaGTiAtoMn+qcrMjacG/UZ0Lnrbn5xHV7FYSRpkl?=
 =?us-ascii?Q?AkhAVEwWdgUjtrxsWXqL9alMED1U6w8yIVRhA6S+q3wQyziz51B2LunaYMVl?=
 =?us-ascii?Q?u6ZWtkAZ2zp/ED8aDOigtD2ogT3sdcSi6HOm4VhikmFBeqw6EcV3q0ogtKin?=
 =?us-ascii?Q?LRwQNXy8KG1vkLYJEuaN2gWMZZE0AMatA4d1f0Lt7pmXp1qTkVAdgvePuRaz?=
 =?us-ascii?Q?XIEGXGpIVV0wA3aeG3UiLPfUHANmwKPNxwOrFSocE82OS9V3EPS1WwBjQFkF?=
 =?us-ascii?Q?+IHQCPO/is4oXuYTE2r7GTPhuwUJcz4/tgUkbN5lPFGHu2OBqZ1D/7267w3i?=
 =?us-ascii?Q?6o/ZDxhMC2ni7Q84ZzHggVzQcwmEsT5DlGa0PEGRa+v1ZcKAQOQAtUqB2SFr?=
 =?us-ascii?Q?M3H+vv/eiEHJ80U/30CiIBe6x9XZH+78pUsOwufviiHXjaVwbF+0qp7T3rMD?=
 =?us-ascii?Q?4VFkQUFL7iqdFm72uxh8fJYcHKMHNwGyYmpwzIidTEyeGOIDHuXKkQNStcrw?=
 =?us-ascii?Q?DJ2Oej8vkYKp6JwZnpwNiEabSp8NxdapPgq1vcjO1S5wy4nAimwwCp5IF+yN?=
 =?us-ascii?Q?Hg4tufWccIzArJVdq24pbL5UOg0g4faP0p7UT8bDbG8ZeSX2SD401WlYBxpl?=
 =?us-ascii?Q?KiYlfK7vNfe73VXHFynPRm1umECVlRhbymTMOXvyRbHTNjgyj/2omTlQCLAy?=
 =?us-ascii?Q?M2+9u9uLv6gPOsNviajx5lfy0INgsCMKMphPyhToh8tIYrqgGwcXNrF0Rkpd?=
 =?us-ascii?Q?m08eWqtszPbGU0WJENx3/RvEnKzWyYiqdT0Ma7svIxKGh70mF19SJXSMMnvM?=
 =?us-ascii?Q?2l7Mg1dlbMKsc7Zkiogg6GrQWD7pZZk9hTIKWiJj9TkBlOT42NO4YcZWGEao?=
 =?us-ascii?Q?ejvKpV2kfZ8Ii/TfvZ0LV2vsTO6jAfIqqScp+wjKvJ9HTwLaO7uMJo6b67Pb?=
 =?us-ascii?Q?CdBk+rvEDoy5wQkc4VVXiWGLg0Tm8QyUbQSD6v/xJQXIEsOY0VXpSiMkce7J?=
 =?us-ascii?Q?0P2AM4zRTcJM03NVfRIYehMyDQ33LUZz5OtGBKFdjEKuXWy/jGNKyQJcDjTw?=
 =?us-ascii?Q?4J9rGQg/HfddtaJCnTMZZxUzlIh1itkeartXYUc6AwWMBAR0fbI71hrwdrsH?=
 =?us-ascii?Q?Dv7ylx6s6a9FwFJ/v11wg/S2Qr6wNLjFraS2LxIQ/jM3jHp/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e80a77a2-c505-49e9-0328-08dea1ac8180
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 02:52:21.3479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c4votqpGhgUfIGMSfO7J0HUcH2C2auNhe3rq2SyVXvHEXu9WWpxoyBuPCPFFsZO0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9588

READ_ONLY_THP_FOR_FS is no longer present, remove related comment.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/defrag.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index 7e2db5d3a4d4..a8d49d9ca981 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -860,9 +860,6 @@ static struct folio *defrag_prepare_one_folio(struct btrfs_inode *inode, pgoff_t
 		return folio;
 
 	/*
-	 * Since we can defragment files opened read-only, we can encounter
-	 * transparent huge pages here (see CONFIG_READ_ONLY_THP_FOR_FS).
-	 *
 	 * The IO for such large folios is not fully tested, thus return
 	 * an error to reject such folios unless it's an experimental build.
 	 *
-- 
2.43.0

