Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010065.outbound.protection.outlook.com [52.101.193.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F67C32BF4B;
	Mon, 23 Mar 2026 19:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774292818; cv=fail; b=SoVJ16LiUfNRYRtTNYXxU2HT2ONNlWSy9tTG/dIfdEuV6o1+F54383rhq0AnorJqtTnr0O4duS3/KePwKlwJTge6/hEBxyjjBagkQ2jedprtxVdYIGv6Yuo+e2+YkMyX8z5M/w8T67D0umMhDfH1NzgC/QT4BRyRrRgw5di0BCo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774292818; c=relaxed/simple;
	bh=2ZK+I1QUNlvdXZ+KuPfOpRDbCFlsmezOhD8RTWnqbPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GhVs8KQiXex8wlcjN1QW13LipvdpS5EBEbkbj2ejuRaMX7YstY7PG0J2Tdoku6GEfT1X96lkTFizoX6wwyuGOYaFjVUiq+SlZjRH6sWVuzq9XfZTpQZTlWcFtU0HOilKoEcy/VPX7XuxCiUaZhQPWycy/WnGNj77xzsi/YSr57Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Vvz6Sz3M; arc=fail smtp.client-ip=52.101.193.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Vvz6Sz3M"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yt7yUuePZi975Knw3jCXWzJ4p19r62AGxGYlZYj3ZNvwRrW4K81RMILWtKV0pBcEo6d/vIyzkSjsFo97drB54pB9uKCjIJwcspzoyAofyylunuB3XG3fehHpcwi4tbQEfEiV1COimoBhVNLnTW/l0wXHt2g/I7Dr/okdUYOIVFNkb8HwKnp9N0/3Ru64oVhTZlhXk1bys9/07y3QfZMDgMCytTia5VfuwPfDCinOCq1X7bQrcAogq8kWNOk++A8rdDueE4R+OtUmFQEHgWIysmi/0kHHt4cfTBmO7l9cl/ttgZ0uBoLe6PbHoGZrtglbueFUeeXMVL3p4KW87gNcGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IHrWTxcvcz/ah0eCjmkygDNgSOCoI0wu2JxMZZ29qB4=;
 b=tN+ffwmLAYYNiOqU89EJki+BggLqLStiXNUHFxRhpcPWztc+G71tXnhdf9OeSMBj1d7i8GDDwM+c+RtoF2G9qzBv6LHj20N6RLPvsf2Z9gw38NDERHlztmrjxmc/MbOedXNtBQ6C4kCwB2wpBLxIAVyW0GUtgih8J3zRxPl/4XOfjYDzm92rwoWfG4C+F5HxN27L8uxfZ0/9ZyG7000aggjXf6e+7ZEqnOetWFp4kfNnjNU9jFsvg1BERmb2hhwBvzrNQf6DEsuGAXPvEfREz7UqJjw6eQLkL/eZEsug2UZP+z+RnFAN5fUN+v9wRXSZ/0dC8UeTfVh/vVyg+TWLiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IHrWTxcvcz/ah0eCjmkygDNgSOCoI0wu2JxMZZ29qB4=;
 b=Vvz6Sz3MQdoz8Rmg4hcAQ/XPOOG/0A4FiSt+zpWYjiIwV7b8WLWl3arNXpPm7/sK2BOnOTP+yTOWPrzt824EWyqux1tMdxbd49vqti9PYi4MK5nOlDinz0eC8PhrsxPnDGFo0OUji1douXjwjjJq4JYXksIkKfwiNibri8LtOr/7nocveV0EEwSzX1ZOTgtBl/BbSrR1gXL42fckrjhZ937wqN+AVHHhX/WP02Da2mZnit3/3OctFXOIF9xY/EfYfu5wbKNQX7sC7mo6Lop2SFT7jZJMtN3aijbmq2+PjwmoCraGGWUqNNpmA04SBV00sV4ukSbuvR8W3bLNiRcvKA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB6813.namprd12.prod.outlook.com (2603:10b6:806:267::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 19:06:51 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Mon, 23 Mar 2026
 19:06:50 +0000
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
Subject: [RFC PATCH 01/11] mm: remove READ_ONLY_THP_FOR_FS Kconfig option
Date: Mon, 23 Mar 2026 15:06:34 -0400
Message-ID: <20260323190644.1714379-2-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260323190644.1714379-1-ziy@nvidia.com>
References: <20260323190644.1714379-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0087.namprd03.prod.outlook.com
 (2603:10b6:208:329::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB6813:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bced937-01a7-48f2-ee78-08de890f563c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	mNX5bsjlQV20gxM+S+LJ+jgUE0d1Ym+GGujM+YBWTPv24IKitHjzmWTpRTBcSkeHHlzG3LKIw6LBrGiNcllMiXbo7Hg6oPbim9JrDro2dEOSjtTJeIU0LtMXJf+tstx4Fl8MvfTo5dsXg0f0Bu+Rv8vKStvH/o02a5kASb5erDvUiqTbKQqMvr5WONk1GDwLQOttSc+KFPCCIuQGvBeJH8PNeL/KC6QYSf5ZcwDJXQ/AKHY3K6vUS7c8jeFe6lXsfbCFs4K8IW3sd7G8aAdYoFuIK0nSGYfJmoFHG/w6YczjZMUWmSEDUShJWCqqcxb0Sq8jm9e2J/8+GnJIxQuL0mVFivaiFpc60mNipNTuEwQNycP1yMtDFVgDpM0ci/E5baMKgo5dQVx2NHwYiDdAbUDz1+pjXFv8J7bh/jghcW/F0y/ciM+UP5xf8HDMW3d2TDjoxstyiU/dOGJkp8TOPwc3oMSvS79RS7Krd8DFEuhRFUMb9bGHuo9T/Qpr+67aNwswzE4RxRXXod/Ywn0EFy2syr2Q/nsbquB30+7+bQSzq7WQHRteMfyVvulyuljorUR3GD4cLGW+SoE5eYp7MezefEQT1jUVl5YcBVmwNwlJTC5LjuLzersRBxV5SUoaZUEXdMFt+FgGtr3fz4GGfU8h9EiUvB9pW9L0ew6fYruFfrd+oJzaw015CQ830EA1w5tWi/ovfSNfSZ3/9WWwRaMNrp0/zlcUvB9Z9+LtJwg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1G2L8E3bZ2u73mw78riuUfO9OUJNdxWJD+4Kk3+t+y9Z+fEUJtz+C3F52PJ2?=
 =?us-ascii?Q?5QuSK2c2KkFkhrtwiYmsCQcrj02QfMCaDE3r9a7NchUt+3DQ8PJ+ot/MyxF6?=
 =?us-ascii?Q?DWVW1450jgDfKw4vrCBXjgD3ItEamrIhmDo1ZKs3PJZV66m50Ap3Q3DvdCKM?=
 =?us-ascii?Q?oiEk41xd4oaBuu8EQEoqDUUlUTgg6NWQVk5pRd851y4moJqQ5zcjWXdzq3bC?=
 =?us-ascii?Q?dPmC9m36HrsWour+bQ3yIg9FOpmHt9PwB/d6SRK6kvAs9G4xQX4TbSo7f8j2?=
 =?us-ascii?Q?1buU7KvC/8Zp9fvdPDSmI5X/eISwDEpZhf7T/FgdEoQz0ggOfrtBcgWJ6VRw?=
 =?us-ascii?Q?vJPKvHcUZ1m+zXKxT2uwnV2VDVdaK7XfLdFsEhxytr/0VmYf53XM842Dnjdt?=
 =?us-ascii?Q?y334/zKmBaVYo9v6IbYzSVVv3KPJBXFsVByFkdLAaTbapBrUTHV/ocuNbi8o?=
 =?us-ascii?Q?1HRoQDrDq72Uq4IQu7xg9+uvli1qrTXeCb1q5O3U2ACBWRuVjvQlYH2Eg2n4?=
 =?us-ascii?Q?s0PdHSdm1kYCUWptkwC249g2UR2rQ+M6zo3K7iH0suoNzR6NI+BQRIEvvB8I?=
 =?us-ascii?Q?FGll/VjvS4WTpaIRd9Vg5to8MCayzzZEzNCznQzocdJHPln3E6oBtQfWrMwo?=
 =?us-ascii?Q?T7KIxOLVmM+oVKWyOa+LAS3jU01ysJgqOOhKadLlVBEquqZafn3GlN2mlSlx?=
 =?us-ascii?Q?BL4dMtLJCRYDPSolZFDxT2yhqoRpvImrWbwDjp8n9RXTQGGNyIsB7KU+gEjY?=
 =?us-ascii?Q?5jwe8Tgd5K48QUIYI51WES83D6hUT/VmmttdG8ezdyT68DLdqtBaPf7JFrmU?=
 =?us-ascii?Q?ivX0c85b3AXxPkU0P23zUleEGxELN5WDRa8U5aLmVCSfpRj45mw9i8OqhEMh?=
 =?us-ascii?Q?chf7PEasyNjdA7dbnQGX08CtHyzXLFEXZ8iQceOKfqyQIXy4XJ5w6Eq74sWp?=
 =?us-ascii?Q?rhpDkuvuZvPaGaHoB4hDVJ39v8toxSzisXIsveesoJxCXdk/Xyqp6qEuRhkN?=
 =?us-ascii?Q?iA6WmyyOcHsvfJSpM4zxtMvPqvhkMkZLwg598rikq2l4uBeWP3JfxsCc1QbB?=
 =?us-ascii?Q?YtaQafwRAn3dkudpWsE56/H1G1JQ4/3NhDHCONgf737Vbbzx7kAnjmrGVIWt?=
 =?us-ascii?Q?gcNsFH0M3tKWJMhLfy/N5JcV2gfSt0ln/KRgpGm8hmJ+Fj0zgh/2jr5Ku3By?=
 =?us-ascii?Q?0RAhpXHZBHGBWceiWpv/ah87yfiFmFyOSwNZbwNi8CsSJxBJpEGUwANBux0e?=
 =?us-ascii?Q?elTfOrUIgPE2mK/adZAIECe9OyGOscKGOOnBlUpRw3vCOhUUk10fG9anZdbu?=
 =?us-ascii?Q?+2jXVkHUKmJhkUBvCtyybKg7V7Wm4DwuJjSmY6BDbmRtUkxkq/6E63U/9W5n?=
 =?us-ascii?Q?c5QgaCWMhUrqQbT3E0CDVldotIXUnbdUDT9bq43gkULpqlj5XXb7sz5VP24s?=
 =?us-ascii?Q?ZPizTj4hETw0YuB+UH53TIRE5y5WoOQeHpAAIYtdU7XdATs8BCOdXGNlbigA?=
 =?us-ascii?Q?1bD0e0SSgE1SttfLMxXMhMuyw1QIQ1dQcqUtF3AChqp/fAFqpg38nZO0EGfM?=
 =?us-ascii?Q?R3RNedrwzSPDj3CBj3iwSxj837zSO4Bkg++efOgeyrvzUTZts+avUPhDfwpZ?=
 =?us-ascii?Q?BORcdjKeQZZYCxY5ZS366MIx4fZZa8UM/cYujfrN/iiqsQHWPCRrhklZezKi?=
 =?us-ascii?Q?3EW6t9agme+Kqo+qb8drPr479EDN4fxFtV4nFkfzchN8ERfm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bced937-01a7-48f2-ee78-08de890f563c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 19:06:49.9293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rt0JKUyPrZY9yv3QdGxAQgBss4rXAYcB5gOIfpDeP2Cpr9QP3vib10L0u5E3QNo0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6813

No one will be able to use it, so the related code can be removed in the
coming commits.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/Kconfig | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index bd283958d675..408fc7b82233 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -937,17 +937,6 @@ config THP_SWAP
 
 	  For selection by architectures with reasonable THP sizes.
 
-config READ_ONLY_THP_FOR_FS
-	bool "Read-only THP for filesystems (EXPERIMENTAL)"
-	depends on TRANSPARENT_HUGEPAGE
-
-	help
-	  Allow khugepaged to put read-only file-backed pages in THP.
-
-	  This is marked experimental because it is a new feature. Write
-	  support of file THPs will be developed in the next few release
-	  cycles.
-
 config NO_PAGE_MAPCOUNT
 	bool "No per-page mapcount (EXPERIMENTAL)"
 	help
-- 
2.43.0

