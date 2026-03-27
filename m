Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011030.outbound.protection.outlook.com [52.101.57.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAFA343D72;
	Fri, 27 Mar 2026 14:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774622617; cv=fail; b=bS1a9UJkgbF/7LMvYDfFStt0wZTfM0rj+amJOkH1AKHEqW52Nm5wDS5o9oub/hxDOwkyRF7ADEhVX2uXpYd+DD0GSmQbihfbD9TCA+i81dyi2C5x8fvIYLn3FBL1ntytCy7z2e5V1M+Osf1eaVF7PhxVX3Ko3YltpTF+Y4Xzd60=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774622617; c=relaxed/simple;
	bh=Y1bfrcLEcxlj8jvoUAor+cDviw7fZYGTsQFkKuHtRrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Fv15PirqBoI3jel9IIgguAKQJk/HMCSpAQQSDUgncEMj9uyxS8me8ndrdhZmL2V0MDuvQ8iK0EHXpsHkXT2X0oEhWnF5YkfCjsAeBEc7Q0LATXLBRiszRKVhWOiJLVbDHy3VrWR8bEOCnSBU2DeGtuQZ5Y0WwTBTNJ2RspyNj0g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=P37fgApj; arc=fail smtp.client-ip=52.101.57.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="P37fgApj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qk1/Mnazgh0q8PUwrIqpRtkrxHJihhpKvALoiqIcVBxxxDa7jXggzBQCvzQoMTTvOUHQFEPtBrAj02bwJe/fbRK0fnXJ/TvJcOMKGYMGbPAurIJRyfKYa04ghZTVFeBjyjbaObv5OBG3GW7VwrjYTZzcaTseY5d03x+lMBb8p23Hw3ntIKWtnxmMnwmCqpek0lJJfMUj/JjNXnVJCnGINeoKyg+DCxh0aDfmYVdptemLmOoM11FZZoH8cjI96w1pHbcymXcg6avcu08RC2e5xiXV5CvPXTQEWB+egPS1T1GX3f8NEy8SCQnf/IXRau0WwOJNyOSPdECGHKEHkhqQkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y1bfrcLEcxlj8jvoUAor+cDviw7fZYGTsQFkKuHtRrA=;
 b=C0BUo9iBv+mEoT3K9wJPCH3m8o5hDm8g0RSSLOdaOd7XCmrUc9Fabp9ZJLBkhxd4rfNFwAvgSolWPyFX7dVPscTHtkXaLlgOL6FCYcPWgFg99wNvsQG2bGsHu+RHNlh7oc64nP1bAtN7/wVQculgiHtETI3t/hM53hyA6ZJrnlAJTOgpN1m862mb8l6w+cczBNQ8uxAE8jZjEuM14kDv9kLWbeNY+E0PLY28d/TXMxH0WtkR1P6qAhPpGo6caNesdzsFiHYq7BZ2SNg11/gyoRtDw+R4Gn8xC1k8dZbZXITGAWXZHQiQ1VabdcW1SJjkg8NaIEO8b0AIm1LByAS8oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1bfrcLEcxlj8jvoUAor+cDviw7fZYGTsQFkKuHtRrA=;
 b=P37fgApjbfGxWwGkJCDly65EfARyxMphHxdXI49I0knVJ2a5H4D1/VeYNV1y1CaMEafJ7kvvolvDVh6IUtP6pKAF1bHlsp4uEHFIp7jlhA7VuFRA2bA+hkEswkWdTnDT0nPN1jK5DC/tzFWTybjDjU9xH+JRiomVxCicP9PIt0HvNfOma2S+B/GA3zzpHPYG2TCYBy7gSXZpEW0yXRIhPgUYY6jWrNjZNOlI3WDCZH1g4WMDbG7V9Eyjm9zMTU8kChMsX/9EM5i7HRckXVbPpAKDiAXIQYEM41S7jk0u43qJL7gDZFHL/zIZCqBZRTZMenVYlqE8P/c8AA/oE6Xa+A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB999109.namprd12.prod.outlook.com (2603:10b6:806:4a1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 14:43:33 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 14:43:32 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 02/10] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Fri, 27 Mar 2026 10:43:28 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <5AA0D400-B4D1-4223-9A7F-41BFEA176F35@nvidia.com>
In-Reply-To: <f3602a65-69f1-4d80-82f9-c0c5b56afe00@kernel.org>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-3-ziy@nvidia.com>
 <f3602a65-69f1-4d80-82f9-c0c5b56afe00@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0350.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::25) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB999109:EE_
X-MS-Office365-Filtering-Correlation-Id: 67d05382-098f-46a9-6615-08de8c0f37ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	KUiPwxKJ9XK8u6RX4o7dH8qYORVCzH3EQSi48jvfsE6NtA3ksP0PC4JGTrXNcgRxSuERSIXf0K/WUU09EPp1Y5RrdRZkyncVrX/Df8amQopVKnGkfVEGg3MAg76jr2G/sk86Ve2uKQR2QVfMmpeOeDuCmQhvcykOpyUbFB8YAYle0I+yuN0dxQD+Xju2qYtAduziTFJrj7ejjrqFSXMUFEzobLIIPzsirPwtuaDCpjQsCf1G3GyH3F50sNP5yqfX3QNywX4PotGzk02hq0f3P793iv+0DnJ40aTVoxMbx9dA1vSbpBYIRXKqFEcjAnubzEbCgo2aOaMHvjT9IWZvBGKs0oFQJ2mF9uN4eMXkvc6M8fnM2e9mSEcCbKg1BMyP5ce3Lbn2FRAm9UDwI2ZsdPPqxmfik/Ol/mK+DO9R6RR2Qa2mDboTGZVIUomm/BB4/ikSpAEVVhxNj0Trzuy3VMsTt+DaVP+E9rqb5R6JK23TIjl8TCqS0An54fFtclQUNUcAlzWtKyZw0DrCzOna3b7fOWpW/BLNQhteyFizitEdJx+dNTZHJmYI2J4Mlu/pmzktpuY0ZyV79bLK9u/u3uTBpR8yBYmvM3TGjKsN2TD3NVbJ/AUWShrLcAbFDTsEcTk10RkFMmaxxBl/T/xPFPTYjjsM5Au9ZfmH1zbpXisHvNQo7yRdIoMxSynfXiokg4SrYCV5El+AwR0bbdom2WbFrNp1QR+2T7dgNAyBSZ8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dbauky83FRQj2eqhvu3aRsrOUlGCP95pFfxbRZx7sRFmesDXOy4fy9xk+Owe?=
 =?us-ascii?Q?V+6lrz8y2ie++o064NdoToo/FNhPu+ftqTO5D0xjL4+mlrLS00s/+K3YFx65?=
 =?us-ascii?Q?vg54movRvdNDGrfIZl4I4p4AkCPKwKEe8xnAV9MDb+aPdLXfgl+hiNtiriji?=
 =?us-ascii?Q?twprn/wy4aw9CLGLN3tL7Mlpaff9GWmj6GCy6svbEmprT+yCcBoNsQZso1cJ?=
 =?us-ascii?Q?QX9ulNGxebWrIdNCp0Sd7JRIJ5rOTAh61huDDcheu/Ji4JGj7lkHkaUyVfPx?=
 =?us-ascii?Q?lC4p99BLr5LBMmu80Nhdvny14gjPAwlU4ow7vss7tdqwUdVVay3fmPFKhTdK?=
 =?us-ascii?Q?kp6jba/x9BQ8dK/61kOfsGTZQ3JB7mcl+VVCCe777FhEI4i693ZNHO0LrflH?=
 =?us-ascii?Q?MyrPeh9Qednks4jJ1r5Av+5pHRaN32860FIJrOBKD0LFf8IY9HAdRXstNhPr?=
 =?us-ascii?Q?s8H/Zr4UoNysL+fPEsIcdtX0EoCvc7Yj58s7JXtpZ2U2DU512DeVJBxN/v11?=
 =?us-ascii?Q?fyjDgKbnY2N0M0kyJRTje8y90N80CkfzgPtO3+OLnBWBDaFvkD3io3ZakVwv?=
 =?us-ascii?Q?679Qu3UDOqdOsrf9w6+2Z5EBi7sLC6fowm0QkFUvKZQEEzYVrgVl27gahMzf?=
 =?us-ascii?Q?QNMfQUt2ce8uePGelYkE5U+WnRfu6/8zH9CYopB+LSsGI/AHv2H26SVaB8rB?=
 =?us-ascii?Q?xrPSpiDEwUcRdHfVuEjQ+NqCW46+i8hU4WFlDi47jyQf+pw0/xoNU5Y8O/TN?=
 =?us-ascii?Q?MGC7HLH6nBDn4x7vV+MtD+4BdKanoyt1oedfiy+GntA/771o6o+Ql2uprikl?=
 =?us-ascii?Q?pATPThUln0Hlk1ykpaJfmiz8YI49RmZ0F/9B3Hx+egRaIEnPE+Bl69EOtCS/?=
 =?us-ascii?Q?oxO1s6pBiMKd8J/a2/XQR5JcWoah9+7rkiOTb6MVbwuDUq9094EmyQtjRRkj?=
 =?us-ascii?Q?+FpOIn8b8l7DlHyNzRr6toCpY6zEH/bIYSWRrFItZSKhcCNHtRQMms44+Bnh?=
 =?us-ascii?Q?TSMIVUFL6AN/PfgcyhjG19BWO6GUSs+ElFqsb94X6BUwaOEIWUE9oV1x8hR7?=
 =?us-ascii?Q?GNE6w8ez/xlifIoUwyLUO8Zv68c1T7Zx/Kzx26bnFu7Nz8rDfxFtwlJIVMkf?=
 =?us-ascii?Q?MO2lDx0OQYDE5mAiSWKakgsg1BY01jibk/QwMGKxIRhUIlSIUhWO6t65knfC?=
 =?us-ascii?Q?L2VMDCygdGZjRFdtwmB3xV5WrRG29zLeBqgmWTtHUDF7iBG6U+AUq1oVAgAX?=
 =?us-ascii?Q?USn8y6kcM+5R/5CmneSy1uZLQZ6wNyBWd4U8xDWHVY7IFYZFqyMd4IW2u34C?=
 =?us-ascii?Q?lkAITAR3nlz0RraCd6fuo6INQNkZ/vhgZhp7ksINb3PqhNYyycLVOo3hnRpO?=
 =?us-ascii?Q?v4RMe24QyzyFKCoW+A9fXwfe7Y7QpdPMMp+Zc5/9BgAZnXDDQ7Yeh4XUf+XD?=
 =?us-ascii?Q?1EpoBzhOEviZFT7UJB77i4n4Aa6uxRmE4m39L7JBZYXwOu7Uzap4tSFiDFwo?=
 =?us-ascii?Q?8joHEaRwraElRHY/qDggf0oGFGHh1dUGwrr8X9aUoUQ3qrltN9PHdzRWgHCd?=
 =?us-ascii?Q?3ei6FodXU8OF+/jImqUnJmNokjo3ydSbBtLU7zR2leYqAT5rdGqCvEyadIwf?=
 =?us-ascii?Q?qfr1YgoAd4JgpgagEjuUvwYZurYh70e1K0iTN0m5gX451zK87v4qF931g3ci?=
 =?us-ascii?Q?DOkvtJ2WJE2qEdGm+82lBnbb46LkhS0TPUE6rOtbjsqHcpUcCeLOhPNPRdHG?=
 =?us-ascii?Q?0dP5d8fBUA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67d05382-098f-46a9-6615-08de8c0f37ae
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 14:43:32.1286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BtmJnp/TaSb1guCAA51jQ+b7KiRpyudtiM0g70P9RpMB3eBv2GI2PwkRxOm1XFo5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB999109

On 27 Mar 2026, at 9:37, David Hildenbrand (Arm) wrote:

> On 3/27/26 02:42, Zi Yan wrote:
>> collapse_file() requires FSes supporting large folio with at least
>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. shmem with
>> huge option turned on also sets large folio order on mapping, so the check
>> also applies to shmem.
>>
>> While at it, replace VM_BUG_ON with returning failure values.
>
> Why not VM_WARN_ON_ONCE() ?
>
> These are conditions that must be checked earlier, no?

start & (HPAGE_PMD_NR - 1) yes. I can convert it to VM_WARN_ON_ONCE().

For mapping_max_folio_order(mapping) < PMD_ORDER, I probably should
move it to collapse_scan_file() to prevent wasting scanning time
if the file does not support large folio. Then, I can turn it
into a VM_WARN_ON_ONCE().

Best Regards,
Yan, Zi
