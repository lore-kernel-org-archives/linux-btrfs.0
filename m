Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010060.outbound.protection.outlook.com [52.101.46.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2BF347BA5;
	Mon, 13 Apr 2026 20:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776112481; cv=fail; b=osp0OCu378GP6XMAzjjOHaIIgkDG9m9Prjhcq2h72lk8IfdY6AJlpRKIDaewEvgN0a085k8VP48beou5nT6VNqUyuxLOoard+dICKq0qiN6V8liQMmtMduCcARnhuR2cplGI7iu9UZzbOOCZmv0mXjRyIlOJYGNXoZBt6BnpThk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776112481; c=relaxed/simple;
	bh=c4adWftxCYhyxkRymEwT8++SScyu1yUuJ3rEsdK6KyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sF9rQ9wOBGH38/y9nab6uPCYXd4xERirQOAZiCJ8gvYuZ6mT85MeMKu+8dErKK9uHH83Ukmz4IWjaX4ircx99l59hMiDxvMm2R/W0lW2kUH5qRyW5jV9t5rSpRhZT8ZpnCy1aEiVObLdILvvGY3IQHiT899Q4vfdX46TIeBl86k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=S3e7sjE0; arc=fail smtp.client-ip=52.101.46.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="S3e7sjE0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mHWnPVffqPtrBQve6JWbFAUSoDazmeZ3JfpmXh7kl/z+YceA5xtzlPE8mOTf3j2o1BNtpjJdo8Zf2GZ1A0K8TohhzuGeFH3weEfa4+Ss968SQoRAwU+1yV6t6AZpnT9NEaEIzDQxPyT5nivY+E4weGmeYtbOVL8vRI7aWGIC2n0HqN8hXEbm8ZEFJ+915FiN0wn709/3KEgIPND7/CyFLBVwLNwIZ3obZTYySZt5PSgBjXObc0X2+NrUbCdIFbgNGVbMLYaEgDDfOQYTj4c+k4IHMnyrV2O+MhMstkAVeJWl9AFtSij3/HEjJ8tcvT8ysIUSvZXpD1tIW2W6VChM3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VEXrP4bP5hzNdkxLe4J/bJ6f/owIONzlt83BlveUk0U=;
 b=nmMPOYNbSkWjWaAvQnl91P0zy1SjZqvBqFcxnyQX5lJC+5OpCg+scI5JsceKTKeI69nSdmJPUl9uV44+4oXv24BOJvJOgYPnEvOT2y7o7ITPL0UyYWfI18spVt8ULJVmbC/+LxU8ZFIlHwXbnzHkVRLxry7ewex9OxEABqolX9gWDS62zcQWThGnYfclSSFhpR3YwIYxwgi/6E17JwpQl6Be7A359j+3yOgwK1TbQbP3F8MBTiUAusM2C3j28+pn/5kq4uvMl3Yje4vKC/Q9stmQwG8J7BHXEieG50y9ERIuDyzH8ieE/mEaPS6Lzkqg7qZdG3qgLZIgE0m56rrsuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VEXrP4bP5hzNdkxLe4J/bJ6f/owIONzlt83BlveUk0U=;
 b=S3e7sjE0o4/QDxS2vgTMlASAITnncHCMur4kELU13gyG36V710+AxvgL+rGmWqhF0Qpx9X9v1azKBlRoYBsYFxnNK6nI1S0cZQ22bLJfVuBeIq3VJ3is/Z9kOClo/RFFbPTH0f4DtUvZP5poty3Zv/jh8KiOMzWJJBq1q/Pgu0/YzHtrwVHnrgM9iauWNHnRpEze5asugFuhfdwT0F9Hygwwl2okRb6NeiQRnKaYW2m53YsO+riLis3d/+zWhv2BL7b6d4jKNPLtT8vd5WPgd4w6TO0QXahbt45ZuA2PIQy4BKANNHnwxEmmbJlsNc4C2+QSJCxMVu8oiaM2ST8mVg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH8PR12MB9791.namprd12.prod.outlook.com (2603:10b6:610:254::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Mon, 13 Apr
 2026 20:34:33 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 20:34:33 +0000
From: Zi Yan <ziy@nvidia.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v2 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check
Date: Mon, 13 Apr 2026 16:34:21 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <CD565023-4FA6-44C4-8E40-8B06CB09B59F@nvidia.com>
In-Reply-To: <ad1P-bfr_Vp6VdKf@casper.infradead.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-2-ziy@nvidia.com>
 <ad1P-bfr_Vp6VdKf@casper.infradead.org>
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0150.namprd03.prod.outlook.com
 (2603:10b6:208:32e::35) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH8PR12MB9791:EE_
X-MS-Office365-Filtering-Correlation-Id: 28ade967-9b2b-40c9-4e0d-08de999c1216
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	zlTtEp0kjox50z6TeJ/xnE6fYkrKGGTEHoPLQ5h32bVoKxNk2o1g6vqvNrxt/bK9yCK+3RFJ6pI7CnklRf/V5BMh5f6avPzABrFp6RLisJE6xZogP6Vcjywcx/VGcRRpi2HIaWRU82UWtYAabmW7CZVOmGMZC6YrdPbixmgj1PeRvFM9PIUbMV4tV8yMGy2VF3xeE8CSEV6txs0bmY0UCUvsVOXrooUOkLQ9ppEhKzJw+DGAjCxIbslMz65R3MehDyCVPC5LqGXbegk2KRrQnuRR1DDgH1MF1xYvCtYZZbx3fYgPBPI1MhPasGwPEzvc+atRiDFvKOOQ55CbXWYGvZmQTUi+vXja2BHuMzqw3F9ougp+VUmz3qtkPsNlgc1X9PCxbkMxP+vP4JpgLXqU3ygorKk2tMyXdAQXmSC+pUk9rart0WEahxZys8lVp/QqIAXHeYC9QHbZr3m10gfRzsLveMgfpMI41enRGfdHOc+R3IdbMxG5mRR2ABW0mkpa6rzo2skjO/Zou2aqEa2upy5okrtrh5LU0NFU16etxMPevMkTZATcKkriTdZqDqjbTp9RuQZggmJw9MLFTRu1cev9xkk9MB+3xhQThEIcPDgM1NbDYR5PVde6EN4Qgdh8pdKr35gzaitq+Tn5EcFjwm2e2W0S0wszWHZg1yuMxzC0ygYZowc3EhPjLAJfP14DQzHwyFn8MzL8iAHMul2ZMhH/aVarbyOHgqqoTTzeDSI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0WVkioiaLazCv5qucxpzMu/btl4vg52dakuif7sIg6wdDC6XCyYNsn8o2Cuq?=
 =?us-ascii?Q?sGSmRBy1vhbl63p4KtGTPDvGBoCXMSYexTdKyj74NWNW/6yogfp2DmHPbZ95?=
 =?us-ascii?Q?jmLnxehX9YRNAFJz5XxjymTqRoZNYhOcOhIiCNgf7gFG6mAxWYk6amtumK+k?=
 =?us-ascii?Q?OvzIKXymg/76TDTm+0gR9XvHsLab/EetMdbDrFMS8QC9wA0iVMszPx60KAUY?=
 =?us-ascii?Q?j9ysJhxCWf2ySo38404Wa/mc6pT2MydslxHew66bRc5wEU5uqSwvHstK5eQR?=
 =?us-ascii?Q?KrQLIdA+UR3rHwOnwYc2Z5AlQbkNnmC+lim+vxKVYjeKfPd+aGpLoYx6H9/J?=
 =?us-ascii?Q?ejCvvKpsXs0ClyZtU63mdxBEeEVMaDYCywqnqZxOKYhAtfBI925CP5S8ulVP?=
 =?us-ascii?Q?Vd3uuoUxAwPdKGAoLmRjKGeMgbltKYh+1DjK82vM0pV64W/BgqSIcrqZjaXI?=
 =?us-ascii?Q?v3+7NnTDBDXe/rfM51kiP58TP0AU/OaUQw1Edy3ssOIO3BUNfCzey7noOsjP?=
 =?us-ascii?Q?SMS+D1fMj6omvXa9LPZjovjG0H9Pax+QQRMEtphL5pC0l0l683UDfgKO3BXB?=
 =?us-ascii?Q?POk+giLDu6aQ2h5gU0JOBNFpZjRM7E2Djpwp+go1SvTJ3+rgY3HmK8Pzb2qI?=
 =?us-ascii?Q?/j+rgjhl+32k/YtrS0f4OP0dyVG6NOQs85Fc/bopPQjmbJDheJLtfh08stcn?=
 =?us-ascii?Q?muW4cmUtBR1bnBtLvVmQL7ha9SshM8oWmi63Tr2D47oGvAmf7sDq9uOHqcPj?=
 =?us-ascii?Q?bNzAO+6D7JmZqAFL2Aq96Ey1bFycZz0V5WKUrXyCuAEkRof1x4D1ZmTsBfrk?=
 =?us-ascii?Q?71NXSIX6++aZYHF2WUuIkuuMIGgGkBO7vcxbl9KIi6uCDtSleyjFbkVb2JY9?=
 =?us-ascii?Q?cFXR6KGvrScNkRhYiNJZX7IFgVwA9wqr07kS4ieKuzZAL3mBlL/FEkU2C+KQ?=
 =?us-ascii?Q?NkfpVV8QYuhZXepFSlsvTqmP9rSL+T5kZHAbX6cRF21DLbogvQeRAtg2SrSE?=
 =?us-ascii?Q?CttDlCLEMJ2Ip94w1sVN49tDwveyLXlfVHfi/6SaEpOMgdwabgVIBZyWVx0Y?=
 =?us-ascii?Q?r/ZQ5fViO7zilq2cPt5WCZiKuPSl1CKOBc4NeZkiPcCNBeGEuM1ol6ry91NN?=
 =?us-ascii?Q?9GS6xWikYSG1I8FYEAWmwBLkMuMqqr4g0xrjfHkNpDMLSdAP4gZEWt8KfFn8?=
 =?us-ascii?Q?pyV23AAKHsJD12BDsOTXzu3MKqM7NmnO3ftS+Pnz8cBlIR1ENYrhp8sZfbU1?=
 =?us-ascii?Q?IAwdujHoI/7nlPTD1MM8bfUCCA2MTbewBDAXV2k+6Dcl6Wob9PiaKMLvCk1D?=
 =?us-ascii?Q?zW/MGNnRzajyeUyxgMzfDCSVuHSPnUNCeOmLsgCpGEe7h1ZMP/I3VOdZpdkN?=
 =?us-ascii?Q?m/z1YtoUj6CywmVJbUCODdQ/cjK9qXomIpLY+45DCmOJarJd7w4oCwkjBghC?=
 =?us-ascii?Q?BQOpDcHJFIL9z5xkLr9ZebkbJaCHMjh32YWtew6tcnFsxDmeswTdEBg/Gq6r?=
 =?us-ascii?Q?cl9LTCVUlW0laVqRhwdCe3hYqfq/0CsZB20W3pCxFGUgnsU4bAu3kH0yweym?=
 =?us-ascii?Q?32Q+LdHTs8SuQlS4IaAG9JVTp6q5mHD/H6alP1F4jmyF91vzWBl33OAfknLE?=
 =?us-ascii?Q?h8Ug3lUmR/VBdhUFQSSGp2baGLe+Wx28CSnPCiZqH7sHCNMwtBX/z2rwFWEV?=
 =?us-ascii?Q?rewDmegnLuOCc4ISmAFH0eg9KVwSaBiwlCvpLQ8NRPZgPnejS+b2m2FFdE7Z?=
 =?us-ascii?Q?FPDYhWsjVA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28ade967-9b2b-40c9-4e0d-08de999c1216
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 20:34:33.1846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gBsUZ5VhnRbVw0WE8fh/4hEewW71HqOTY6NXh5Gx8AtpfUiE9kW8CmJf1YtLkuiA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB9791

On 13 Apr 2026, at 16:20, Matthew Wilcox wrote:

> On Mon, Apr 13, 2026 at 03:20:19PM -0400, Zi Yan wrote:
>> collapse_file() requires FSes supporting large folio with at least
>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
>> MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.
>>
>> While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.
>
> Why?  These are bugs.  I don't think we gain anything from continuing.

The goal is to catch these issues during development. VM_BUG_ON crashes
the system and that is too much for such issues in collapse_file().

>
>> +	/*
>> +	 * skip files without PMD-order folio support
>> +	 * do not check shmem, since MADV_COLLAPSE ignores shmem huge config
>> +	 */
>> +	if (!shmem_file(file) && mapping_max_folio_order(mapping) < PMD_ORDER)
>> +		return SCAN_FAIL;
>
> I wonder if it should.  If the commit message to 5a90c155defa is
> to be believed,
>
>     Since 'deny' is for emergencies and 'force' is for testing, performance
>     issues should not be a problem in real production environments, so don't
>     call mapping_set_large_folios() in __shmem_get_inode() when large folio is
>     disabled with mount huge=never option (default policy).
>
> so maybe MADV_COLLAPSE should honour huge=never?
> Documentation/filesystems/tmpfs.rst implies that we do!
>
> huge=never       Do not allocate huge pages.  This is the default.
> huge=always      Attempt to allocate huge page every time a new page is needed.
> huge=within_size Only allocate huge page if it will be fully within i_size.
>                  Also respect madvise(2) hints.
> huge=advise      Only allocate huge page if requested with madvise(2).
>
> so what's the difference between huge=never and huge=madvise?

I think madvise means MADV_HUGEPAGE for the region, not MADV_COLLAPSE.

In v1, I did the check for shmem, but that regressed MADV_COLLAPSE, which
always can collapse THPs on shmem. I know it sounds unreasonable, but
that ship has sailed.

Best Regards,
Yan, Zi
