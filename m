Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012002.outbound.protection.outlook.com [40.93.195.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6195388360;
	Mon, 23 Mar 2026 19:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774295977; cv=fail; b=d44gYDOLA4zqVxPqZkrUpPrIua2hZf4VW1kq0aeSTdRkbVk6qgJmjDPyQWPPmR7PraMULyT3x+t6Q3KQ+Gq7Zca8Xos12sG+nXvlesYCDjxSapweKuZmVTgHQeg0myVPTa8TPyTAqkl/D7JdLA3rPncGP9YnvaYeUGeh3d5r79Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774295977; c=relaxed/simple;
	bh=v4i8RBZgmzk5V3B4hfwZqt0KPdFfmQBJmbTAVXVfIcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qGt7wxN2T5qMzN0HLjyObAFz9HZEvRYclL3x9AzlXfqiAcdPR22qWVwm1t4Y2n3dhx/BBy5UX0OM1HzQQya59RwZJ0iiregz+4osrrRCxcvaZTXs0V21eNcsHroR/zIIm3xWJl5YxEOrkt2zTHPvGE/cvKOMcwGJFdbIJDKDN5A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PmCvqLn/; arc=fail smtp.client-ip=40.93.195.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PmCvqLn/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZO/HuoIBIZiEoh9afsNICqja0DATXXK8JyiXpC3okozC7ReAcFv9QkwPvSX4fgt1B1+vtMDf9AZzGSM+kbG58ZFq0w+svWoLjQ/GU62eEF3aPZvFpCnylkW1tESvZbQkcXQVWZX7eNL7ngdorT1L8xKqr5L5FHerFruTVhLzyKjuDxh0uwXA+bOd+FrTDqyIzKXNfw0E19o/HhACoqVIDUMdIzVQF+fqq2jOa0d71O6EXyGgKN0IWZ2yH9CwoZHIy2na23+qZ1+riIdWLW6mS9MrQ5d+FDvuBu/itwFRnaQ4nXqob5XrXY6v1gIci0E9smTKeqCMBzzwmbQrzjDmvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KCzY+b3Yx8t8QZvoSWx5vNCPjCUMbW4vle+pBy2fhNQ=;
 b=ZXZ3EdqfpOiQVQVbcR1p28QqVm1sZ9mCnWqUDYN0Np5+Qrs6brIndyZvoxwNjQeav+Lg+cyv/DZAuBw2z/4/GrqCtNadgtz0MxL51hgTKXwLH/VD1V5v6p3y418bPQYTu32OcnFUd3IvPK2PxWZ3x4FiTtT912EOiFrhw/R6wz84gNrYYDJAZrpZyv3OzBwgMEFeJKlkaM4Ij22idussRF3Y1rbLmoaU7mEY/uGs4L9LgFOf6DakU4aD1SG8T/cJevrhAjHEictJXVuS3Pv3JS92jZSIRlAKytPElveCuJ/YePLjdiwO00dQPKNO1QE89XswlKL/VuOlB8z9OkZpag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KCzY+b3Yx8t8QZvoSWx5vNCPjCUMbW4vle+pBy2fhNQ=;
 b=PmCvqLn/bYKOnPzp5erTmF1j2eb/35sjyKCmQVCy+UhT2AIggd9TujpsmIUKoadUBtZG5Uk16Sf0u0ah9QzPMHhFv/3q4RYYKO8lEemCsV0NR+hovjY0z+jJoXDNmVm/D0bjN8YOnS0G1hsoroBK1gz0nRGMk84mL+c02/nkuGpInyiNKghqNQQNxcqiQ16hWyHW+y9+C1Ht7LfTUA3eHN2L8aF0yquJccadWYP72PlDvNUlHbTWcjL3L4M41BCqZVOjf5P/pBLQp934y+AIfA22osq+myS0Mxqozye51Znq2ZlXxHzbNSxRaXaHKMi7qk9ieErAeQ7LlpL4dNjZYQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB8498.namprd12.prod.outlook.com (2603:10b6:8:183::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.20; Mon, 23 Mar 2026 19:59:25 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Mon, 23 Mar 2026
 19:59:25 +0000
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
Subject: Re: [RFC PATCH 02/11] mm/khugepaged: remove READ_ONLY_THP_FOR_FS code
 in collapse_file()
Date: Mon, 23 Mar 2026 15:59:19 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <AF9011D6-8EA4-4134-B175-BD2DAB748419@nvidia.com>
In-Reply-To: <c20b7dbe-473d-4dca-a10b-b9f5267ad6da@kernel.org>
References: <20260323190644.1714379-1-ziy@nvidia.com>
 <20260323190644.1714379-3-ziy@nvidia.com>
 <7382046f-7c58-4a3e-ab34-b2704355b7d5@kernel.org>
 <E8D52134-B63E-44E9-BBBC-258DF74B8597@nvidia.com>
 <c20b7dbe-473d-4dca-a10b-b9f5267ad6da@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAPR03CA0039.namprd03.prod.outlook.com
 (2603:10b6:208:32d::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB8498:EE_
X-MS-Office365-Filtering-Correlation-Id: 436a7ed6-028f-4057-4029-08de8916aec2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	YHIAbIoXcx4A4K1R1+eoomcPSYaVbBRI9vE5jrFPkSV+2e7V7+NL7cIg7nKNRQozXOMkdBTRF/EyTG01iDHXKxDfJ4x223uzJLbMLkCVLxzkhjvCSKbQJpBSxRT93YQWV2MIo8Q+USokX5Jkj9M8NVnPKJdwxqUEczpiIfJyDarGo6+SQZgtT6lr6rb2YZiFZJtDP7rLE1NeJHkewfGSQFMY8kAKmmSFWnTdj1IrTf0VN5DFqRLw2piF2qj+B0s8l0+6lzro/cBGF0vcL8+2DQXtQskdZU35vyZy3NusU3Fv7iuI1ZQd0IImnqku562OvDd+0H63Rm0qbp5QjJLeQlukUjSXd4fDZQHc0YfLCiB+e4P64DphuqijBl8dPxRDdKr9VTNyqKv32LXOSCbSWKMDYjuQnx4UhUTfMQq00r5HGySTQPbh1Hc5+u/aEotttMxnZaefIjwYQLp+HZu/eG2ArZ1VWFxbnJZTm1ZfPHs0+d5+rVxUU5aDb+T+rzDE49z1Y1OYDJ9LyYK6EXjvX9FYFinVXYKpkOXbJIdHrUfxdRW6w+JhMHX4r5CyrVRlANCL8IvesoYY7/TmvvvnZW/G/11a0vbRQDS07ZF7U7/6sLQ6WQcev13lazRfQwkrkwz6kHFocAglkubFEcY58LqOrnMj3hzxfbO/7BPJ+rIje8n8FZDINdXKvfkntKlQT08jI/KuB4+NXwT3OD24yJUpe0ZeObuOm0sEI5GNxKoBGIrW4UbPAnQwfvRnsgdY
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mOuPHs7wZVh+z4j1jLauOZogqHPEqmVr+vWkhiC+w2f1p/QQvuEiU2u0SJVZ?=
 =?us-ascii?Q?4S9/bhqYOaqPK/x2K+QYeMzXAZl26XotbMJ42lsxTBYsGANgS/u3zyA2SomP?=
 =?us-ascii?Q?LZHWrn2UZhCHwXxznd6pCOCC6zU9iEd83d8SpB7U1zZwi8611X8UWRwJcc1I?=
 =?us-ascii?Q?VxBHmooi/vBD6cD6NfEbdlLtN1I2UV/CpMlIn/IVsL7rLBGLRSra0HKbKORI?=
 =?us-ascii?Q?fR/ITsdjlp8co17VL/9cX/5bE1ICuEE2t6uRgnDN1JKEjDXQewxIsms4m0cb?=
 =?us-ascii?Q?foPUIgL8p265IrIAh14KsKUoZGufi5JpQJYvZG+p9jZw31ailqXos6AHi51i?=
 =?us-ascii?Q?8l3r2ytc1SljRujDkqiEEtp34RwCsXMn/FBaATeyUJhFQli+f3KgPe++JupG?=
 =?us-ascii?Q?hVxrEyAQca2bu1wbs8S1wyGean0BWAaVmz1ihQYsGqmqp4NibCvG4rriWreP?=
 =?us-ascii?Q?gpcszt3d4MkFpMwiKr/5BIL3D5ARSjz2mUQoa4V2Xql0ZH+F5u2jjlr4yus8?=
 =?us-ascii?Q?uO07U9j+FDtbCO2QmlEsGT5Oi1u0UvkbrPKykWPD6uUnnYBSfAFu0cDPYIEy?=
 =?us-ascii?Q?PRxG9fYfdLbocGy0fy3FjbNVnS9KG3VpgMvNjyyWXBh1NKjcLaqz02XVCgRc?=
 =?us-ascii?Q?fTkx7b3s/mgd7xWaVtbhfzMI4GISGoZXZAgdaOuQGvS+x3SCHSTE6/U8kk3n?=
 =?us-ascii?Q?85YdajTelPJthVulmigfAVGupP3qmHKNkD9YMiCCxqA883Oq1AxrDTB8bVRt?=
 =?us-ascii?Q?X2jvSOu01675f7L/G54SWe5eoyPcPPreqHeb46S0fBpZe6mjO/gkgH0Ycg+w?=
 =?us-ascii?Q?sboBC8Qdxxd9B7RPxbv8fX62fqVOMBaWB4Cn92qudQxpSzzVjc9mR9FPoMSz?=
 =?us-ascii?Q?l/aa/FCLeeJVZkf/YT9nN6XxOQWt1racMTohVoo/MjdAYfI02z0MvHzrASTj?=
 =?us-ascii?Q?bW/yABIBEdt/A2JdcXMwiNrfECStsXfEapLgnW4NVgfkLM6WhlJQ5ZTBv8ls?=
 =?us-ascii?Q?lSd1J+z2Mc7SJfvqMNagI0aRuFxzh3umouXjJ/e8NvnKREoyxEetWp/Sz1mF?=
 =?us-ascii?Q?+6uEhBnxi/GEZEnZdEy4Hb0IXC0z5UrJYZk3zLMR5jT9apsTnh7MIOMHyd8r?=
 =?us-ascii?Q?I4YOj7uy1Fym02x6PXPznssy0lrFRfXfS4oEzIbdvqa2zmTkbifEvy+LdNfi?=
 =?us-ascii?Q?NAEUIZiCTKfTDCQJ+8mrvXEX+v/iHfnxMPEwwjGWDM5V7buo3jKl3aj/AvQO?=
 =?us-ascii?Q?eXjx75wU8GnK9lj2Qf7rXobw5kMyBEOZEeceiotrU/D8m5R6FEkEEPz7FaDX?=
 =?us-ascii?Q?1VOcGgdtWXmUM5Jzrcmrj3dI8TAcwxW5ebmIKf7fS048btvdguCVUUOMu23q?=
 =?us-ascii?Q?S1rnEB7fZmgA3rlflA0wXvHua3nhaSqhziLq2h0eGC9EW1sAdlh16GOepeA3?=
 =?us-ascii?Q?lWyTTt7eEjbj0Fp2igSVtV1od1r/A8yZ8zvRJo1rBo5QJWDoDILyow0MxR8A?=
 =?us-ascii?Q?Q2RS+/8Dmzpq4qrw4SF+bxFmWFhZ2mlzypFmN7GA/l72f1MuPIs7nlyKfR0m?=
 =?us-ascii?Q?LhcgKeZcyU/myb1sP81aBZVybcRYv2gEkQTP7MGSYkoygiIkTUGAqGjDR3+2?=
 =?us-ascii?Q?8GZXNuwwp6w4y4BocqzRDMcSB2TwoJygRsDPh9CrlLGOljJZVwQCzQTCXWSU?=
 =?us-ascii?Q?Lc/AHIU/I3pDWVbbO84r66WxgFeNf8OWW1KEFAPy44CAIrIAytezpMcm6WC4?=
 =?us-ascii?Q?oCUxNUDVbg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 436a7ed6-028f-4057-4029-08de8916aec2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 19:59:25.0001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 62Q1I7JwBAd+EBwlj3jp0/6cg6V5O/opEQD8mi/ZJdMSnX0hZl1mc8ZYMepvFFn1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8498

On 23 Mar 2026, at 15:53, David Hildenbrand (Arm) wrote:

> On 3/23/26 20:47, Zi Yan wrote:
>> On 23 Mar 2026, at 15:41, David Hildenbrand (Arm) wrote:
>>
>>> On 3/23/26 20:06, Zi Yan wrote:
>>>> READ_ONLY_THP_FOR_FS is no longer present, remove corresponding code=
=2E
>>>>
>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>> ---
>>>>  mm/khugepaged.c | 159 +++++++++++----------------------------------=
---
>>>>  1 file changed, 34 insertions(+), 125 deletions(-)
>>>>
>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>> index b2ac28ddd480..39f0b8959535 100644
>>>> --- a/mm/khugepaged.c
>>>> +++ b/mm/khugepaged.c
>>>> @@ -1899,7 +1899,7 @@ static enum scan_result collapse_file(struct m=
m_struct *mm, unsigned long addr,
>>>>  	int nr_none =3D 0;
>>>>  	bool is_shmem =3D shmem_file(file);
>>>>
>>>> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>>>> +	VM_WARN_ON_ONCE(!is_shmem);
>>>
>>> Oh, but if that means that khugepaged cannot collapse large folios in=

>>> FSes anymore, then this is the wrong approach I suppose?
>>>
>>> I would have assumed that we would now collapse for any files that
>>> support large folios (in PMD size), not stopping to collapse entirely=
=2E
>>
>> My understanding is that collapse_file() is only used for
>> READ_ONLY_THP_FOR_FS. If FSes with large folio support also use it,
>> I can replace IS_ENABLE with mapping_large_folio_support().
>
> Otherwise we'd be losing support for THP collapse in files? We'd have t=
o
> cross fingers that readahead gives us some.
>
> So we have to be a bit careful here. We want khugepaged to collapse THP=
s
> in filesystems that support large folios even without READ_ONLY_THP_FOR=
_FS.

Based on[1], collapse_file() only works on read-only fd. So it is not
as general as all files. If we do what you suggested, the function
will be collapse read-only folios from FSes with large folio support.

BTW, has anyone used/relied on collapse_file() on any FS with large folio=

support?

[1] https://elixir.bootlin.com/linux/v6.19.9/source/mm/khugepaged.c#L1956=



Best Regards,
Yan, Zi
