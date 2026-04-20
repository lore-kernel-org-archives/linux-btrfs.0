Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010017.outbound.protection.outlook.com [52.101.61.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6106633C52F;
	Mon, 20 Apr 2026 14:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776697089; cv=fail; b=O7vkmhiSeuLujb9UcuN1QJipOH8fbjmsNX9DGqr4bq5I7amZ7MA10o6pqQoZfKriZ3FFQ5L+5m/TVgzDc5JTcZrDi07RHx0s94ZEgaCTRudVUjQ2MlcE8IgQ0UkBj0+oUAlSCotpNUAReoQ7UU2vl/KYm4wsU+GExNzcP2cnUdE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776697089; c=relaxed/simple;
	bh=JVBYiGlyO9kZjFf+7YgZ9NB+fsedMh0KqtyScdgZ4iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PCjKkXmQcRc9RFe0Kc3FZ8AEjmYGVH/5dTSNFUwetDEMZ/vGWBCJUbd3E6eKA4u20J/N63FlwbaAmR11GRg8Zb+23/V0Mg4pgUlqVpE2CzkZxeh/sxhB3c5ToWnbryQB+4iq/tuSlyZz23K7XUnCz25nXJKa/kpQzHzpSYUO2b0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eaAgl3op; arc=fail smtp.client-ip=52.101.61.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eaAgl3op"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tp38ERwawBYzQmFGHwj9QCY2efsnu1AKpOAGi7JwjRi+dozvIudbujlETlYlzgiH5ukewLzjbjP5Ys62FUloLcNcoQsuhlvshUrl8yATjWS+EsuCu4t63BAMibTTy/w0+ucVLto4LuMc/vNrZpWD5CZQlsUIUhNKuTApXqMomRTvLNIAWqw1biY0fytO951s9sL4xCfbcfhMxGkUsOwFWtYYZgem9CpMxjerYy9aBKkYq8pvnrmmNXg22377nlNGFP5V0o587HL6KxQWT8mrBL8L25a2GGhrKCNMFqEMpkteYjkGFyz0Ubu33/YqG5p3P5n3k2mgOjPZoXuWoeyzFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rV2ui5RiwbqnqhAG/H2cKfmgsW9iYVPlP17qHeTumio=;
 b=V3HKJoUVI5rX9mUPiwA/RGSUrxTqPaMatf4D3MduI+ahDcIUndHXTLXQEPkORM4sKP4bu/qMYKbc5iCc6swR3lIfZ8rPXi3sGcGy7ozx+bdvd7vu0b3POTVILZ5rX+yJebDnnzyVRfx7VGoMybWyRMEt/peVJSqgR1ckNqCl//JiWmHqfKuSFMLvR6hAxeh5SJjkmFgeUzopYZNkfsXd7Js+i/t6V/YlS1tf+Ls/JXEK5WCO95Ucewwrf2no2VYrypQD4PpnkDbH+BumbaqeZjQa5ul2cbnR7dsyuVig8d/vD67Hxeegld//jdRW9o0hxfAoQ76+eRizSZzhNjHZuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rV2ui5RiwbqnqhAG/H2cKfmgsW9iYVPlP17qHeTumio=;
 b=eaAgl3op++ngnocs5RRBy0PYUEyirCCgtU8WhUS+XoGAewgf1Fwpx9p++qiy8Zn/+QuYeh5kZhVMxutjdTBeLWP7F2eE/IauuS3F/xwfMUE4Zow65CjkFDr5qmuMS2Reeaxs3UuPQ27DhieNa8GBs/l9iQGh7AVtTsbHFI3qaKXDIODBP5FdofRj9LEs5FDyCn7OE/BH3fSDM7gbaP8dyvcLe6mqzB1uixb1I25Kp69ubXdonN+HNW9wk0KVAdxPEKwrmTO+Ycm90NUf6w6bwbn0ZgYiA2nCNmB+jdfIv/1hpKPBoXCSGbt6gokK0MmYWGLnUvfoun+peDCEOmVDNw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY8PR12MB8065.namprd12.prod.outlook.com (2603:10b6:930:73::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.15; Mon, 20 Apr 2026 14:58:00 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.014; Mon, 20 Apr 2026
 14:58:00 +0000
From: Zi Yan <ziy@nvidia.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v3 04/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check in hugepage_pmd_enabled()
Date: Mon, 20 Apr 2026 10:57:29 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <E7EBC528-C511-4166-89F3-654171383646@nvidia.com>
In-Reply-To: <b228baf2-0dcd-4135-bab9-04d979b6e617@linux.alibaba.com>
References: <20260418024429.4055056-1-ziy@nvidia.com>
 <20260418024429.4055056-5-ziy@nvidia.com>
 <b228baf2-0dcd-4135-bab9-04d979b6e617@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0412.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::27) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY8PR12MB8065:EE_
X-MS-Office365-Filtering-Correlation-Id: 739a8025-12cf-4cec-64d7-08de9eed36d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	1zx3+u5OeTfU7z5v9ZNQGQITBtUPTwvtFVEgNuojQg2bT7GEmfUCgRPrBmQ32LxY7Q91v2xp5JxbBO2cvIGRajbcSHvl+QK80FkmKjqrCXlikBbXcfsbbB1sfzPRh7nLVAVns5eT2niSAYBTbg6mY/8gCUyird0dzzkQYCWan2sqWeYgBOFNS3GV+NaNvEGLPR11/Kf8CmyERNCRYZLDGFF2dktxWk6ZJaB5F88a5rMKbiNdCO6anqZvwgRXaP7ERZKmZla3p+MBOLo7vg+kDD4xZNrh76IA8xRYuYU2HqfWYT/r7vpqROukhxRFayRLQgZ0AYI4Me8m0adEPDwpl6jYdgr9cSecU4nVDoRxOFFLBoiLEDzOlRMGmdxtAarJkZAekdWa4uxq41kYgIv6CEfXzQyQxmdJXI2cpQiCtTIHAxPyKkFUPO6W6enN8BuWiCmdvomtqXrqAkfJHl3ro/R0juQlII2+Am+HxHitZjWkZ6g1QAUIotZrkx7g+2LgZk8NVC/pOjH7t13ySu3ccagDWZokgBD6sxBCZTuaMIgrgIJ/Gq584h1FuP6GtRn6E97WanKka7PIZ78QBpcS+PPxUBRBRffYh4ilHTrcJsLjSB0Mxl7DffvQoxz8ysCQrFnlrxFGQwXW4mVErf4F3G6NNTbYSbjpFNqXVx0bqabdW0mXrHHqU+m2VBTg3RqO0Nui5cn5HU2PT1Xgm9FNwGaSNIHB+51yvpoio55v2YA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K2pUSGNLdjh1QzNUMVJvTDk0WHBZbUpmSldiVVArUDMzL1lXNDN5a0N5NHlH?=
 =?utf-8?B?clg3VHdnUDlwT05EZWoxNDJnelROWlpZeUF0a3FtbE9XYVV2OVBMYXVub0xl?=
 =?utf-8?B?ZUQrRnE1SThDOFA1WDF4djFSMjR6UTNHbXE2K3lKQ1UwOUJzNU54M2wwemc1?=
 =?utf-8?B?bDBnWnFYZjIxbC9hUnpZM1R6cEd5eHdiQmY4WWhKN0VkSDRYWXlYMGIxVEZa?=
 =?utf-8?B?blNUYUZJUjFQSi9aSmdaR3BEYUo1QS9CdjhtSEo1OWFMU0g5SEx6R20xaDhL?=
 =?utf-8?B?VHgwdHlSZzIxUzQ1VW8vZ1lYTnhxZjZuTlJhVnF0YndqYStENndSd2t0WUpu?=
 =?utf-8?B?SWg5cEJLRlpFYmFCaVQzWFlNU09pQ2QzelVNUmVLQzg5V05PSnRxYTkweXhR?=
 =?utf-8?B?N3NtMnJzY21lTk1CcTZmVGV5OE4ybTRaa1dYNWNPK1d2KzVUVTBLdUhMSHRm?=
 =?utf-8?B?QUt2SW1ncVE2Q0d2R3lva3l3NkptTTkwRzQ3UDVPSVMzVnNvdlVmQ2J0UzFm?=
 =?utf-8?B?OGdwQ2M4dmhFTHJkN3V3a1RiYUlxeXZPVFYwN2FyaFNoSmJtaWZSc0dHQTlJ?=
 =?utf-8?B?UE45R2tTSVFsbDFWaTJnUmhwcmVzLzlhWVhMNUhld29jN3ozRXU0YStXQXlP?=
 =?utf-8?B?SG02WmtHMlVCK0kzYzh6UzgyeFE5cGk2ZDFyQVlxMjYrdDcxTDRtZ0pJM3BG?=
 =?utf-8?B?c3d1TGhXcWZ6YWVXeUdveHRydnNCby9nQi80NHZUcjNqTWkwRWdIQmdlbmpH?=
 =?utf-8?B?NjRJWW5hdDZycFJ1dHZmM1BjOVhMYmlqZnVxK0dGcXNYc01mUDhVUUwzcXhl?=
 =?utf-8?B?RlBHc29xWHB6MFA2WG9wK2xHUmxXa3JmVGlxQ21DeHJLMzZzNWJ4WVA1WUlF?=
 =?utf-8?B?MnpTYXRrYUhxR1phd1B6RGs5NTJ6V2NyKzZvOTdSVGFZYkVlV2RaVHN0eHZ3?=
 =?utf-8?B?QmdpRElHeDczc1dGRUVOUkhFYUVVeEo3YUVJUHRsa2d2NitKNFBmeEdvWEZF?=
 =?utf-8?B?aDRsT3dTdHpjb081Y2JSZFV1VnJoNCszMi82bEpQTkJZUDkrTUpuUUNMVU5R?=
 =?utf-8?B?NGhodzVyRFRlNHJwbHhaYk5IdlAxNlhKaUgwMWNHZzBSbCtLNkdpY3huNGdv?=
 =?utf-8?B?NmM1Z0JmT2I0bm0wcWQ2NmE5eW1VbjdzRXl2TmZvV3RYOEFTekVmY05Ea0U3?=
 =?utf-8?B?R25qYytqTnliSUhnSHdCUEtuZVlsemQzUXlaY2ZkdFFsL0cvTStPSUpoSEpS?=
 =?utf-8?B?dWg3UlhMaEFwVmk4N0J5YzM0RXd5RHBhZGQxUnZEQS9UTG5RR0RJRHFEYjFi?=
 =?utf-8?B?bjNKN2dWN21JNU8xRGFXUnNhSDUwM0RLVDlMVFZackRLVjRJZGU3YUYzbW1E?=
 =?utf-8?B?RnpacnZqL2tsRndIejE1VCtsMm5KbGE0Tzc2WlJGN1oxRFlBTyt6ZzVxbEs0?=
 =?utf-8?B?NnRIZTZQSHVWTjZXTW1JaVA4Wk0xanBMZzNkWkcya3hFeVU3VzRBa3RITkRz?=
 =?utf-8?B?ZXBGZmc3eWFyUGFzektuTzVNNXIySmd1bXA3L2VkM2FnVHV2RXIwaFA4dEI0?=
 =?utf-8?B?Slc0aFBLZE9ZUW1QS282VFk0SXhHbHdDYVdyRFh1Mm9kaUhpWUJueU5LY25m?=
 =?utf-8?B?SVc1THpNbFRKVVpFL0NkeHZqdzdIREk2cW1yaUIxWWRWOUhMa0NPZHplaGZI?=
 =?utf-8?B?UjF2WG16Vmo4L09yOVlqQm1DeTdjaE0ySVNrL0xzeUoyaUQ4eDU1QlVneFlo?=
 =?utf-8?B?MTR1bXpBWDhwVXczaFBmbDZKelNHUHNGdFR0dEJnU3FBTVdsdy80Y1dWK0JB?=
 =?utf-8?B?bzZycm5JNHFManI0Uy9WbDFUNzdDeGkrcm5GVElpaWNld2R3TFVwQVRiM1lz?=
 =?utf-8?B?RWNXeDYrbzZoelJNbHBuTnlZR1FNeWtMWElxY2pjZ09ta0prQWVoamxnajUr?=
 =?utf-8?B?R2hmaGVzR0xyS2NYS3R2T1RqQ090RlNxQVR6OXFKOXlxc3Y3OFFZZjg3ZWZY?=
 =?utf-8?B?d3Y2NStxcThFZEdXSURzdjEwWExrVVNma0V6VHR2bXk5azFPbmhocUZTZ0F2?=
 =?utf-8?B?Q1lLUUZCTkk0QUJFeUJrVFRLOWNseGFaZU9yUXYySFZLRzhMSXplN0R4OWhw?=
 =?utf-8?B?Vy80eS9HbHRhWWRRUW90dTdoVlNPa1FUN0hHNXBCL1ZBWnpyN2xoS084S0pq?=
 =?utf-8?B?OFpYMU9zc3pvRitzYXJhckhLdE56S3NnaGwzVlVSZjNMU2hpTTh0SnJPaU52?=
 =?utf-8?B?STc3MGJDbFpSM2g0TWR2WVJ2anZyOTVseTVPZVlMMVBMYmdIa3h1MFF2ei9H?=
 =?utf-8?Q?PrjBiEVHWDiYn34YCP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 739a8025-12cf-4cec-64d7-08de9eed36d9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2026 14:57:59.9889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jOwWt+nwr1Zvu6eSNsWyU4NHYWW5tf401AU2djEYznYR05953FvZxjlS8RCW+T7N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8065

On 20 Apr 2026, at 2:55, Baolin Wang wrote:

> On 4/18/26 10:44 AM, Zi Yan wrote:
>> Remove READ_ONLY_THP_FOR_FS and khugepaged for file-backed pmd-sized
>> hugepages are enabled by the global transparent hugepage control.
>> khugepaged can still be enabled by per-size control for anon and shmem w=
hen
>> the global control is off.
>>
>> Add shmem_hpage_pmd_enabled() stub for !CONFIG_SHMEM to remove
>> IS_ENABLED(SHMEM) in hugepage_pmd_enabled().
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>   include/linux/shmem_fs.h |  2 +-
>>   mm/khugepaged.c          | 28 ++++++++++++++++------------
>>   2 files changed, 17 insertions(+), 13 deletions(-)
>>
>> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
>> index 1a345142af7d..dff8fb6ddac0 100644
>> --- a/include/linux/shmem_fs.h
>> +++ b/include/linux/shmem_fs.h
>> @@ -127,7 +127,7 @@ int shmem_writeout(struct folio *folio, struct swap_=
iocb **plug,
>>   void shmem_truncate_range(struct inode *inode, loff_t start, uoff_t en=
d);
>>   int shmem_unuse(unsigned int type);
>>  -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> +#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SHMEM)
>>   unsigned long shmem_allowable_huge_orders(struct inode *inode,
>>   				struct vm_area_struct *vma, pgoff_t index,
>>   				loff_t write_end, bool shmem_huge_force);
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 1c0fdc81d276..718a2d06d1e6 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -406,18 +406,8 @@ static inline int collapse_test_exit_or_disable(str=
uct mm_struct *mm)
>>   		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
>>   }
>>  -static bool hugepage_pmd_enabled(void)
>> +static inline bool anon_hpage_pmd_enabled(void)
>>   {
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
>>   	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
>>   		return true;
>>   	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
>> @@ -425,7 +415,21 @@ static bool hugepage_pmd_enabled(void)
>>   	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
>>   	    hugepage_global_enabled())
>>   		return true;
>> -	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
>> +	return false;
>> +}
>> +
>> +static bool hugepage_pmd_enabled(void)
>> +{
>> +	/*
>> +	 * Anon, shmem and file-backed pmd-size hugepages are all determined b=
y
>> +	 * the global control. If the global control is off, anon and shmem
>> +	 * pmd-sized hugepages are also determined by its per-size control.
>> +	 */
>
> Personally, I found the previous comments clearer to me. The statement "A=
non, shmem pmd-size hugepages are all determined by the global control" see=
ms somewhat confusing. For example, if hugepage_global_enabled() returns tr=
ue but the pmd-sized sub-control is set to 'never', that means anon pmd-siz=
e hugepages are not allowed.

You are right.

I will revert back to the old comment without =E2=80=9Cwhen configured in=
=E2=80=9D like below.

	/*
	 * We cover the anon, shmem and the file-backed case here; file-backed
	 * hugepages are determined by the global control.
	 * Anon pmd-sized hugepages are determined by the pmd-size control.
	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
	 */

>
> The code changes LGTM.

Thanks.

>
>> +	if (hugepage_global_enabled())
>> +		return true;
>> +	if (anon_hpage_pmd_enabled())
>> +		return true;
>> +	if (shmem_hpage_pmd_enabled())
>>   		return true;
>>   	return false;
>>   }


Best Regards,
Yan, Zi
