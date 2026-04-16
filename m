Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010044.outbound.protection.outlook.com [52.101.56.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C52329C48;
	Thu, 16 Apr 2026 13:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776347827; cv=fail; b=qU/ot8z65a+aW3c097aVqvGwOFDM/U3h9IGKRR0OdlkSP8DWEWJczZrz0vbL6UAvtiu/6mteXMynkBVxUTfCn8mD16e60O4v+JI8rwRbB4JL9/zAZApmg7J4ZKu3R90nnzZDMIeW6OTDL7AkEQk968jPkzby5uUlhFcwseoB1A8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776347827; c=relaxed/simple;
	bh=c7eC5RqbtDbb9F/tBCBMc4uI08dfx4gk8eZdNG5xnrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VrwFEldGYGNgaCGy/3WmVYx6Velz3BgQJtuthyFHVeIFTO2i3Kc9tHA10arGG3iBCRPBFd80tT3h/W4uB5Y1XzywYGHGNbBQ4/91yslvaQlq7LQYqQltEIN6uFbQToG8FcZFsfl4QwewvDS06fwmhMx8BWe0/al947mF9Nx6AgU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dJp/Vw8h; arc=fail smtp.client-ip=52.101.56.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dJp/Vw8h"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J/mlO5mYVa6kk/svTly/ynt/RAwTx4kiMiHSGTMjkqrjHT+4oxUiXnSvNK+qgvhv1Tx6cL7v/hs8VBbFk7q1Yd12cjder/2FyyBReRLtk+5G9/N8pUf4VeQhg3enZ5MpPQ11CVn1ACPqLYSwf1uQ4D6QTCjJa5ClbqjbYXAxuBwN0yIbu3IN5X56vdUxHtfe1E0vOa8LQ9mv76ypmpKVkNVFVnfWXXxWi4/OybYl8ZLSZPe7Z0Mrq+B5Yn7d1Z7vdOLAGLfKmgIiEgwgtSqeStAT1mH2nIj0+k9Z+rnZSt0QdeWlN58BDFjqvkl9ggrUQp9l+Yexvz3RzioSXYPQmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bdepszNcjxM6RR+RmvKieMDmDfCnzB92TJIjMk8oguU=;
 b=AOiX5ueHuFS4xe9wEvjhJ+vI9dWDXAXAaDkZcNTISAM2FZdYQwqzsHXFQ0PkfDaiwUoYPm2o/kkIRbhSGK8tvx9bBYUMnumrFB9lB70gbZTCuPqXzV0dcXWIb6tjhbhOVX0dcQsiqviDdRcglT7rAeQlk5IKZIzaecOLE1HT/oglKFa/unKcu8pCGA4qjQ8ZWq6oH/tgvWsDJN92YZuxSJY1h56SeX2qVJvfDA+/oLtMqFZddwE+1bIg1IvTwFLCW1Gu8aUTMwDPYNjVUQBjjmW1Mi9c7+sGBcv+i/6kY26rCrvnMFiTSkSQ1TH0oDq6a2bv1dUbQBcCYGIwpgGKNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bdepszNcjxM6RR+RmvKieMDmDfCnzB92TJIjMk8oguU=;
 b=dJp/Vw8h7ra6ftHzMuWTPFn6kNqFCKUlJlFa9e5f3rOj9BS9k9ym9Bfsy5F+T77KD77T81d+cIoyQVTNsUeNuDXW3SHf6pMuDmHlYh/UjHgcajSwJzuWj2zCSGfTMq/SCzxuENZBAozObhpPZsUM/MlEGbo2lwfnyvzyPpBpbcao7QcWNisiA2bxRQXz7Mfqm/3VVjXzzjbeX8bxzZasDWnv/Y31/zcXilZUSFtGBzU6zUGSrUohLN1jOjXMPrJhqIhcYy3TJDGJ12bRMdbRDOa+ufih3HDFcqJpocOX3SLd4lP4cXjV/xSqdopY27/Y78+vtz2v09RQWFqfnOQMjA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN2PR12MB4175.namprd12.prod.outlook.com (2603:10b6:208:1d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9791.34; Thu, 16 Apr
 2026 13:57:00 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9818.017; Thu, 16 Apr 2026
 13:57:00 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Matthew Wilcox <willy@infradead.org>, Nico Pache <npache@redhat.com>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v2 05/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check in hugepage_pmd_enabled()
Date: Thu, 16 Apr 2026 09:56:56 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <7267856C-FB66-42A8-AF5B-F31C0DB1F581@nvidia.com>
In-Reply-To: <8d95a9ad-4c85-4b8e-8724-af843e1b7859@kernel.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-6-ziy@nvidia.com>
 <ad1TMjF1L3usYIC5@casper.infradead.org>
 <05F00072-7E06-47C9-BC26-FE3736F557FC@nvidia.com>
 <a4d477a8-71d8-4219-9cb3-153f2c01e184@kernel.org>
 <84B8F641-A3DF-4219-AA57-6BA48E9B4998@nvidia.com>
 <998c02b6-2612-42c1-8099-d65ae275d1a2@kernel.org>
 <7468C68E-FB09-4714-94A3-4BED63453295@nvidia.com>
 <b7aa5515-6908-4ec6-91e9-eb79d5ef70b4@linux.alibaba.com>
 <afe0dfb9-feeb-4243-bc4b-305e5e33b581@kernel.org>
 <38697379-cbba-4c64-ae65-6774b01021d9@linux.alibaba.com>
 <68F85F77-8EFE-449D-B643-AEEB38CB50B2@nvidia.com>
 <8d95a9ad-4c85-4b8e-8724-af843e1b7859@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9P223CA0004.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:408:10b::9) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN2PR12MB4175:EE_
X-MS-Office365-Filtering-Correlation-Id: c7a1b7ce-b2d4-4f15-214e-08de9bc007f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	bw3vylpVxyRJoJAwPKLb2YKXr36YTyO5Ue+EOTzqclEI3TRBm3LfGdYz6sGmifReYQkKLXhst4ZS0+AgbBSqrcGcgpmCDoWM2B04dajDL8Sng/QIWNDrd2ACLtNfoOx/1pXNne2aMG5ltotSDQlGbJcYua5sKe6ETXTMME5KK/ANgn+YnK+1sYnU0KEvjBFIta3FckOidSQtfZRzf8dpvBJ2Y3p5/q825/dIGWQ7z1xQrYUtqFczTMe/qIBXt5k8afG/DFFZ6kniA4JM5bhv/LTilIAX5HTCjExPuwgfWKbyjznWN7+2zYOwIZ/juw8jcHzwyeAjUp9KCBp1OVsyen3Jh6dxld/a2DQloDlHgOzdmqPlZDthWwmoTGx6HbkDnCkAtHaNHCwbyJ72BcL0s63268PICszVXyWUhmSaGcmAkbWTfOg2DQIWB21dVyGVTfM6PRuGJOpQlYCl/OM3x05Be8f6A0zY4OKbVEshYFpF9sWN3xjWxC8r5wIMvao/BWWScHfbKJBVOUkdOPkiKVA2w8I4BiUgz1HOV9ouI3kI/vRDRPUc75TjdAL/H7ny1XA/BRKKu4tu0n6vtRVe5Fc25IpjUQ6S8DQ+wIdjFzhj0Ob2UQMOQJRIgC5ajNVl75pu/QfQZ7tN7l9pmmaCEp67D+ypaNUwZdN3d/dvSn1QyX1AGQMAno6SZ1PKyIOVlw6QNMPxniCAUtZEoQjjBJQgdjIm4AiYeFiCx9OUJpM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q2IzcjdtdzVkcm92MmU0R3I2dkowdVJrVU1uUHk5eDdTMHY2UDNQcnIxN0tW?=
 =?utf-8?B?ZGVXWmNwOEF4WkpzNjFwbnZ1ZDBiU05zOVRSZWRBejhpMGpaZXZQTFZld21B?=
 =?utf-8?B?T2oybk95WXlmWUJtK3YrbDBhSFBYNzJqK0oxT2ZCRCt4ODdIU3FOS3dvS0xi?=
 =?utf-8?B?Y2dMWk9iSXFscnB1TXBwVktKdmRiODVNU2Rsd1Q5ZE1sNHpUQWhOUUVSZkVr?=
 =?utf-8?B?Vlh6Y3V3U29ZZHliMzhYQmJpNzJkbjZxd29Ed2NIdUovTWlqaGs0Zlpzbzdq?=
 =?utf-8?B?K3NUMFhsSWt3dUYrMVFtTlQydlFMMGxPalIwRElNSy9GWFQvRS9lWnNOV24x?=
 =?utf-8?B?RTA3M0hSSm4wYUxnM2krbVJuTGpxQkx3K3BCS093Nm1JeEg3WkR1ZXpUVnJ1?=
 =?utf-8?B?a0x3dENkdVNna09yTWFJMEZHY0RNNWZyRUozNEYvSjVjczdtSE4vUnRsRVdS?=
 =?utf-8?B?b2NvN2k0QmpxZy9zZFJmVUduVGNDVVB3WnptaS9zbmo2Y29xUkxjZVFIUmd5?=
 =?utf-8?B?NDZ0WXRFYUFndC9EY2h0dVI3VW9LTE0yL2ZxSmRCYkZIeksyK09XNXdWYzdz?=
 =?utf-8?B?THIwUWxqSzhKMVc2blFqU2xnNnA1ME1JUzBMbTZ2M3RMMWM2bEh6U2lHbTcv?=
 =?utf-8?B?Q2h4TXlXbWQ4dEdTQTQ1RXR4RmZwU0gxNlBseVlTZ056a2hpQk1DQ1l6R055?=
 =?utf-8?B?SmlENHpHckhJWjJ0WVMvRllvNWpGUEsvYVNCQzBoYXMxRjZreWRkWjhCSlFX?=
 =?utf-8?B?RjJqUCtNZFlUSzRMNldoZ2VzVHBpRXFvZTA2Z2oyVFVFUm9WR2Z6UWozVXRM?=
 =?utf-8?B?SGw0enhZOVlHNFZRTjQxYmo5TGtZS1YxdEp4ZjFXSkxtZXlPZWExMHcvcVl0?=
 =?utf-8?B?NjNtanhqTlZvZUhJWXJRWVhkR1lJWXJnOTNGR3dDRjBhVUxuNEtmckxvaHZF?=
 =?utf-8?B?a3JxTkdsb0VWVWlISjV4cVErRzgxeU82UndwbDdqMFl2MGtIajJSZktiNlFn?=
 =?utf-8?B?UDlVMjFCeWFjTDJVd1p2OXJabGVwWnk3MGJ4eVcySHpUZ1h0VFozam40U1FG?=
 =?utf-8?B?RndESWFXbzBtcXVMU0lxaCsvZVFjSTlMN1NXWGlxZzFCTmlaUmJVT0Vwd0ti?=
 =?utf-8?B?dWRKZ2dCZThBVHRLWTJuTXNENTNFeVlZVkM1VUxQc3l3c3AwQTltbk04MUxI?=
 =?utf-8?B?ZEFURGpNV0hKZi96b1ovY3lxVmJkVXpwdlhsb2M2OUM2SHo4dDczR1IvSHdh?=
 =?utf-8?B?M3o5YUxSQUVTUXZPNERZbTBlUjh3MDZ1eFNJNHpyc2M4dmtEb1ZQWTFEMGFL?=
 =?utf-8?B?WXR5Sk5CT1J3WXdRazJZMVZ1ejRmVTdtSDY5RmVaV05FazhMQmFtZ0pkNkF5?=
 =?utf-8?B?ZGNIQjl3dHhIMUpET1ZCY0V4TjRDWWJWTVVuMDhpNmFscXJuZG83eU5ueDB1?=
 =?utf-8?B?cGRHZUFtYlFYUlRCcGJ2bHVlN2ttT3BYSlhuWmU0QkpZRkNsZW9hS1ZVdkRi?=
 =?utf-8?B?di9MUVUyb1ova29RU3lwNXhCaStzaGhHZTNkQUlTL3FNaTNmeWRqbnFxVzl1?=
 =?utf-8?B?WVJ0ckdGWThkTnprZENldE9HWW5uY2xJRm1wWHhhRXVwV3NuYzlIY1BVYTJX?=
 =?utf-8?B?TWZVTlhwU3FPSVNIblhJcGs3cEFGVlV5aTBFSkxQQXU1b0pDSWxkTVlUbkgv?=
 =?utf-8?B?ZEZUMXkycnJ3THVxTkpCdmEvZ0t6TjRUNk9kVnpobWpsVFIvMDlPeGpkaUF1?=
 =?utf-8?B?c1VHUjY4dDVUeTk1K0E5MWExSnR1WVoxUnE2aDZiSHZ4a2dLY3JheVhlMUxD?=
 =?utf-8?B?eGR2YkMraWdEdml0OWdQSmYwWEtqcHVsN2JxbjhRZFdZMUJZd0h2M2xKREJP?=
 =?utf-8?B?K3JDTCs0VUZxUXlNNVM2ZlBaNWdNbjBWUFhyU1dRTG51QkFjUzRMRnRmUUlz?=
 =?utf-8?B?aTNNSDBMbWt6MVA0blphSDFTT3NscDNSdWtDaFRTS0M0Z000b0hRUSt2L2U1?=
 =?utf-8?B?TjNJaGNhUGlrckIxbTh2TnZNbkwyMmFPeVhMMjlNR1V4RG9tSFgrL0NWSWJr?=
 =?utf-8?B?NUFtNm9TR0xrVy8yYzhobEdjempBV3g4eE93UWZIU1BkWGo3QVhCbURRS1JN?=
 =?utf-8?B?VTNMK3J2cDFIWG9ya05TaHZNa21mTk9GTE9KQU00VVd2aGxuQzZEZi8wL1J5?=
 =?utf-8?B?WFAybitOQVh4bXY2N1g3Ty90UEFOK3JRZTN5N3ZCaGpyTUpGOXlTazUzZ29r?=
 =?utf-8?B?RnNUSGZ6NnhLOTFGUWhCZGRZYlBrcDFReU9PV2EzclhlYWlyZTQxckN0RUdl?=
 =?utf-8?Q?n7GFRFmUp4V7iSt0YL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7a1b7ce-b2d4-4f15-214e-08de9bc007f4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 13:57:00.4033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yaWKieiXfYphwfVhhjAylmrXz5jicLWfhHM572pKiYOyM9NZGBbMLrOHjWFkHimD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4175

On 16 Apr 2026, at 4:47, David Hildenbrand (Arm) wrote:

> On 4/15/26 20:01, Zi Yan wrote:
>> On 15 Apr 2026, at 5:21, Baolin Wang wrote:
>>
>>> On 4/15/26 4:00 PM, David Hildenbrand (Arm) wrote:
>>>
>>> My comments are in reply to Zi=E2=80=99s comment:
>>>
>>> "I think hugepage_global_enabled() should be enough to decide whether k=
hugepaged should run or not. "
>>>
>>> I=E2=80=99m concerned that only relying on hugepage_global_enabled() to=
 decide whether khugepaged should run would cause a regression for anonymou=
s and shmem memory collapse, as it ignores per-size mTHP configuration.
>>>
>>>> The question is really which semantics we want.
>>>>
>>>> Right now, there is no way to disable khugepaged for anon pages, to ju=
st
>>>> get them during page faults.
>>>
>>> Right.
>>>
>>>> And we are now talking about the same problem for FS: to only get them
>>>> during page faults (like we did so far without CONFIG_READ_ONLY_THP_FO=
R_FS).
>>>
>>> OK. I=E2=80=99m fine with using hugepage_global_enabled() to determine =
whether khugepaged scans file folios.
>>>
>>> My concern is that for anonymous memory and shmem, the per-size mTHP se=
ttings should be considered.
>>
>> OK, I misunderstood the meaning of hugepage_global_enabled(), since per-=
size
>> mTHP settings could also enable khugepaged if PMD_SIZE is set.
>>
>> I will take willy=E2=80=99s original suggestion and make khugepaged on i=
f the global
>> setting is enabled. The below is the new version of this patch. I moved =
anon
>> pmd huge page code to a separate anon_hpage_pmd_enabled() like
>> shmem_hpage_pmd_enabled() and cleaned up the comment. Let me know your t=
houghts.
>>
>> Thanks.
>>
>> From 92b92f2b2ab41c70b41dd304ce648786ee6a1603 Mon Sep 17 00:00:00 2001
>> From: Zi Yan <ziy@nvidia.com>
>> Date: Wed, 15 Apr 2026 13:52:50 -0400
>> Subject: [PATCH] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check in
>>  hugepage_pmd_enabled()
>>
>> Remove READ_ONLY_THP_FOR_FS and khugepaged for file-backed pmd-sized
>> hugepages are enabled by the global transparent hugepage control.
>> khugepaged can still be enabled by per-size control for anon and shmem w=
hen
>> the global control is off.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>  mm/khugepaged.c | 26 +++++++++++++++-----------
>>  1 file changed, 15 insertions(+), 11 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index b8452dbdb043..586d27ce896e 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -406,18 +406,8 @@ static inline int collapse_test_exit_or_disable(str=
uct mm_struct *mm)
>>  		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
>>  }
>>
>> -static bool hugepage_pmd_enabled(void)
>> +static inline bool anon_hpage_pmd_enabled()
>>  {
>> -	/*
>> -	 * We cover the anon, shmem and the file-backed case here; file-backed
>> -	 * hugepages, when configured in, are determined by the global control=
.
>> -	 * Anon pmd-sized hugepages are determined by the pmd-size control.
>> -	 * Shmem pmd-sized hugepages are also determined by its pmd-size contr=
ol,
>> -	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
>> -	 */
>> -	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>> -	    hugepage_global_enabled())
>> -		return true;
>>  	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
>>  		return true;
>>  	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
>> @@ -425,6 +415,20 @@ static bool hugepage_pmd_enabled(void)
>>  	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
>>  	    hugepage_global_enabled())
>>  		return true;
>> +	return false;
>> +}
>> +
>
> Works for me.
>
>> +static bool hugepage_pmd_enabled(void)
>> +{
>> +	/*
>> +	 * Anon, shmem and file-backed pmd-sized hugepages are all determined =
by
>> +	 * the global control. If the global control is off, anon and shmem
>> +	 * pmd-sized hugepages are also determined by its per-size control.
>> +	 */
>> +	if (hugepage_global_enabled())
>> +		return true;
>> +	if (anon_hpage_pmd_enabled())
>> +		return true;
>>  	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
>
> BTW, can we please provide a stub for shmem_hpage_pmd_enabled() in
> shmem_fs.h such that we can remove the IS_ENABLED here?
>

Sure.

Best Regards,
Yan, Zi
