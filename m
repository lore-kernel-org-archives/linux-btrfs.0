Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010063.outbound.protection.outlook.com [52.101.193.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87A92E7BB6;
	Mon, 30 Mar 2026 14:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774881358; cv=fail; b=SsZmKa3HarrUNL2GYX2PC6b5Op+NsleFIhmGrSJ1HIuwrgUPsMjZPFJvtVx7wi1d5xN9VXlk3oo7Xyo6N5yR1rKKqhxNO1cJqG+HK2M2cwKPsdWLbFDFywZMaKwqZbqeGIWoS1pzG3Sx3eUlVRgoSlkYDnnYHCxPTG0I86kj5yM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774881358; c=relaxed/simple;
	bh=YTMkxkhbOUpq2VSzA4k+wBJJvJbEEyCqr3C4+zVC1cY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Nbu5qVV5QE7qccJFfU3i3chs8gelC/b+zFNI9lz142n8IXs/Dd+M7D2chd0CUNUkLbTRbrh8eXCY+DvOIEDr02QD1Mgm+DTRkHX5zR0U07gG9wiOn0dxmnojkGshRs6On6nq/S4gN7QE5L8anoO1laD++gBeypDZk+SvXUYzSLg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NnQ2V4cN; arc=fail smtp.client-ip=52.101.193.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NnQ2V4cN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IzAYBYXPFiyQul6qzykQzD3ADOcN3d9OkXDKMlk9uCCAeiw9XaIwtqBAOmIucvHUV0kTanq9jTOf7wGbmFYHUlt2VJFlUpRpz0xnhP6vLWLVONPtJskMNCqmlltM0hdaqdRIAmB6OyWplW5lhSMEGHulU4w0vRRczr8vBuSsnaJYd6dmeBAqZNQkYHhcZUv1H7HRoG6NWsufGtfW8LedQyeIdHaT6Hrrav0w0eDLAAICqYXsTXm20Jsns4a5oYlnd1T2gWzEI2M8CbF9jI052hEZPwlOH08Aa5WDtybHktz4nlCPWHu4TlqpgLXqBO8hYTjVJBx+tkW35q0XFqVkzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MTErkZp9JOLe2ljP6FkXRd3RM+smjuwhPvBXlr7H2AU=;
 b=HYnCxlI04fY066k3Cr6SGftla/hAz/Kt+qma5fcbLiiTYbyRVoZLGGl/4dGq6loNQKJ3OWVY2P5lU2A56o5hp42upoEE+GsetwNtbBCzxsK+N3yXRf1dCrZ0zfsIMyzmdKE+mXOK8lJFidnrMw3POKHQdXWCuuWn/OHTsU8IEWalSIzxHbCsGzLVCtckJg7PuNoIlZf50t0JKnusZhkKav62Sv8eBNkU1g7sMYJARVJhc9Jt+bRKnbYElD1+thP3nV+zCW/ApE6bGMnNzD/jBQGXJMW1Vx2pLg3behEObQ6RCg93iFZWjzYrGYv6Hvnpis0doAfMZJa9ZpiPEmGfiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MTErkZp9JOLe2ljP6FkXRd3RM+smjuwhPvBXlr7H2AU=;
 b=NnQ2V4cNxiMQpKG9DybsGd6B22GOnqPmFXWjncTzP962Po8EQlEDlaZunE0h89Z473zQyzRB8bjVxeQ3CtfWPFnOlJLIcVogIBK8zcEkVmeQ53Tv5bS3QK8sG74KM7tjSe3czmFECpXm/n1LRfFwsEVLZWNaRE9P9Voo5YHYgJoJjTBzGewziYeVI2gZBQ3FkyvWu58bSMYtHD1gKj1ex3gkRrtMpBPkp7fAHlyplOb2TYHhXwc3Zqgm2gFIM7jLn+Ogn3jzqG7UfLcOaQ+ydPu2kxQsBsgoV7CmE4ueJFRYFjYmkpdAY3K/1yb1eKn7brzwFttWaAl6n9Wb/xkLxQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN2PR12MB4047.namprd12.prod.outlook.com (2603:10b6:208:1de::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Mon, 30 Mar
 2026 14:35:52 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Mon, 30 Mar 2026
 14:35:52 +0000
From: Zi Yan <ziy@nvidia.com>
To: WANG Rui <r@hev.cc>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, brauner@kernel.org, clm@fb.com,
 david@kernel.org, dev.jain@arm.com, dsterba@suse.com, jack@suse.cz,
 lance.yang@linux.dev, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
 npache@redhat.com, rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org,
 songliubraving@fb.com, surenb@google.com, vbabka@kernel.org,
 viro@zeniv.linux.org.uk, willy@infradead.org
Subject: Re: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS from
 file_thp_enabled()
Date: Mon, 30 Mar 2026 10:35:49 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <DDFEC0C1-3ECF-41CC-9630-A4A742F2B842@nvidia.com>
In-Reply-To: <32679321-b2d3-44d7-be2e-f7a6a166a510@lucifer.local>
References: <52CACB9A-A782-4D11-8B6F-66DA8D345C78@nvidia.com>
 <20260329040742.17269-1-r@hev.cc>
 <32679321-b2d3-44d7-be2e-f7a6a166a510@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAPR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:208:32d::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN2PR12MB4047:EE_
X-MS-Office365-Filtering-Correlation-Id: afc1af38-5677-4ef3-f058-08de8e69a4d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	vO2UnCmXsZAZKs60p/m22LTpYYa823xp+EgCA+ZnHevXgrJjxr7ymMG68pkju0lNHHhyHmLxfj01qjUCaWRNqR8PUBX5lXBst2i8pb26ejrIDKsjh7kvhhGyrGPCSY4/h1/qo7OB5IxGSPszV3gJTU34rXK7gWrUYu/yu8h+P5InBVw5LYoTQusP3oSS803MNTeZTiHHdCpG7lL0DCPQd3X8NM8CBHePCiCv+JxZJNrS1AwgZSEWnIjWjl2wN12R0GkaCgWv10CzWkq9EBsYNh9A1tTRjyz65WIxGd/KE1pgtrNW1mAWG68gmOnnoDD9rvHjb2kQMjlOB27LAHlBH/GnwIK5WsTNwWFihF0VA1HdW0rkVJb3DfK1rwihQQTg60ynNTGe5KdLKyNrJ2JcaKWA1hCLL4HFKUvMJ/tQgrARx/JYXNf8FDt9CyCdJCtm+aWhFqSneBtnMqXdVLT72iRPFtOdcFV0jLWdPvIhuUAMHkmTm1hbOQZWdSY4jZ0gYy2JgyvEtWr0ysE20MUC/NamyIz111hAxKPtlfdKoF4ZccFOWovMGsDcUVTGlrPC9tVduNYxD+0Nltq0LR5flPSK+DzUYonL7ZDEBWynH6fw2vjsZXNWhU8VuLSJbStVyyy635uMYdzbw/AGoP/QBxJh4a3LUlmgd/IjRojAfB7VEjxAvb9zhY0QgtANeUvXOuOCc8xWetTZ4neeliVXX/idz8nyp8D/C2v/GfxIV6a3wKhLduVzvfhNWJp5IU9B
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VktjZ09tQjdDdGdRYitFLzFzZXZwY3FMaUlvMHkxT00xUlB4TnltRk5HOEFW?=
 =?utf-8?B?NityV29Pa1dZY2dTc2krSWdSWlN3M1p0cTNrYXVKZlgxazRyOEtpM3owT2Qy?=
 =?utf-8?B?ZmNSRHlNUlNlcVFtbGo3bk9tSTJHanRCaXg1SU1MYk5nRzRUVWpVejVsTGRF?=
 =?utf-8?B?N05HclVXb0pxMGN1RlF2d0t0a1o1Uyt3a09FU3NKRHVOMUlEaFRWZ1gzTi9K?=
 =?utf-8?B?b09SYTdPYXhFclhqbG80T1ZTdHQxdDNDRk1GT1c1VlczZTFKSSs4a1VzblU5?=
 =?utf-8?B?NjloZkIwamdOdkUrSFN3Qk0wbFljODIvVTY5R1IzZk9wN1U5Z1RkdTduK2Jt?=
 =?utf-8?B?TU1SaDc0NG9zWHZ6L2plMVVQQ3FqOHFaUDBpdGMyTExtbG84NTA4SGtWc1Uv?=
 =?utf-8?B?NzVjeVR3dmxuQ0tVVGlpelhicjB1c1RhcEMxVVFhOXBlVk5EMkFDWFB5Uzkv?=
 =?utf-8?B?UTNDQVB2WkdrNTRsR1hHZWdSSzdIUHRmbzBVVTJRL2hvaEFGejFKU2g3WFds?=
 =?utf-8?B?VUQzNmlNaXRKU1ZzNVp5OTN2TDE3Ynh2elhCMCt3cUxYRzNkSkQ2aTdPMjBl?=
 =?utf-8?B?dGJwNGNOeHlqSmRYU0NrWlRlNndGMUoySy94bU03V1NPNENmaW9rY20xME9y?=
 =?utf-8?B?V2F1ZGxUd2lyZ2U0MWtXWXg4bVorV0ZuRHNJRFBoNlZKcnJVdVhNUStsWVpl?=
 =?utf-8?B?aEU0RTJhYm1OZldIbnFBRmxJeE5RZFljSFROeER3SldSNGlUQVY1a0ovb0d5?=
 =?utf-8?B?YVNhQ2sxaWs5bjVkc0s4RWk3R2hzNnJkdmJ2MU9waGRLNmhTUDJoMU9ZZVpK?=
 =?utf-8?B?SDRIK1dUZ0ltU3lMS1d4cmowc0VEalVPME1udFROQ3lZSEtjSmM2c2V1TC9M?=
 =?utf-8?B?N25qbUlkK081b043SC9BRXJ0YVNOR0F1L2JQT3hZZkJvVTNpRDQxUlluU2VO?=
 =?utf-8?B?MjJnM0ZRcDlYaW9EQlQ4U1p1SElOSzVYMTFBbXFnSXR4aXQvSUNwU0JieE5M?=
 =?utf-8?B?THNLdTNSR2ZvSGtVaGoxRmdBTVlmSWRXNGJ4VERYbmZqWG1zWUhJTm16bVRx?=
 =?utf-8?B?SDBpanZXRmFQU2ZMR0xaM08rYzJ3blMyb1UrTTErMW9JQVVTNWdsR252ZGRt?=
 =?utf-8?B?SEpLa29nckVRcUpMU0R2YkhDK2FBV1FLU2NJSGRNQmxtSG1WSDU1N09md00v?=
 =?utf-8?B?a3ZRME1RejJhMTVDaVNQUWx3WTgvNEYvVTZ2YzNIRUlFNERrc0txYnZqNjE2?=
 =?utf-8?B?ZVRPR3NXZmdCNXRtbTRuTHVWVjNKTWRyUCs1eUpKMVZtSHRFVTFnODJWeHBH?=
 =?utf-8?B?NXhGSjhJNlh0cnpFbS9wbXE4d2dURjRJSVNpTEpmaUdFWkxLSTQxVkdUN0JB?=
 =?utf-8?B?UzArS3FaU2xYK1pYZkxvSDJIdkNYK2FPSVBUNThHaVhkSzA2Q2c0UEJiLzhy?=
 =?utf-8?B?NGhYa3JKbTFkRW5Pb1dUdnB3RktuRWlTSmEzUTZXVC9BQ0FpWFdUUnhma0lz?=
 =?utf-8?B?VWVpazU5bVhFQnkxZDVqWE5mcTJtOXpoaDZ6WHZIaVBSQmlWVktMMFVFc28y?=
 =?utf-8?B?TmdkTjFlaURMTXkzdmFQQWdBRWhrbVRSMFhqekdSZHFmTlVUUWpCN1UxU0g2?=
 =?utf-8?B?R0VDb2w1UytYMm83N1gwWkVvK1JPSklFTWxOQWgvaXRnMFZOWDJoR3k3Ukxx?=
 =?utf-8?B?b2cycDBHVktsZ2N0d081V0VCUkhNNUozM1FXdUlHL1htZWp2R3ZwYmVXZEZO?=
 =?utf-8?B?MG1jQytzbWIzVWQ0aUUyYUZHd09Ka0VxNXlEWHFNV2FBb2h6NS9BaU9mRHEy?=
 =?utf-8?B?OHBpSzdqQ3BEMTNXWUVMZUU4TVE4c2lGOWl4dWV3d3phRWZwSlVzNXR3aThn?=
 =?utf-8?B?NTdFK2g1WDRqbklkNVpPMDdsSlltSjBxUHRGZVlwbjUyL0xoZDlPVnQ0K1dx?=
 =?utf-8?B?Ri9xV053MDFNM09MT2tqSzFVdHlQb0NjNlZqMUV6VE1tanRpQWdpRkl0Z3Fs?=
 =?utf-8?B?RURGcFRBQWU4UzVkUDhOQVVDbkIzWXZvVHp3SjdzSFV5TDFNQ3RCUE53NzV3?=
 =?utf-8?B?eFJxeGdZdjN0NHRWUTNlQ1FzUXhjaFJpWlNWNnU5ZkF3UDFvSDBjZTVXcUJW?=
 =?utf-8?B?YnhwZ3hGNG1qN0ZScGdrenBkaWJGUGozMWxxVElZMkdvdzhNUWEvUVpRVkVp?=
 =?utf-8?B?WGppd2ttcXlHZ1p4NXpJTXY0M2E0ZzAyTE0ybi9DZDdrZ1Rkd1JBYURLSnZh?=
 =?utf-8?B?ZnFmdWlVZDlzMmdJUWNvK0VwZnk4MXNGa2Q3WjFPZzBWcXlkbnhYa3UvQlJy?=
 =?utf-8?Q?BBbXoj/jEsbhGV/dVn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afc1af38-5677-4ef3-f058-08de8e69a4d0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 14:35:52.2854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ftYMZYclWaWuLrKa4MTX84e1SXtvemjBguiWUzjfNtbxVA1XZjtI2Mznsu3qGGWz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4047

On 30 Mar 2026, at 7:17, Lorenzo Stoakes (Oracle) wrote:

> On Sun, Mar 29, 2026 at 12:07:41PM +0800, WANG Rui wrote:
>> Hi Zi,
>>
>>>> Now without READ_ONLY_THP_FOR_FS you're going to:
>>>>
>>>>                        |    PF     | MADV_COLLAPSE | khugepaged |
>>>> 		       |-----------|---------------|------------|
>>>>  large folio fs        |     =E2=9C=93     |       x       |      x   =
  |
>>>>  large folio + r/o     |     =E2=9C=93     |       =E2=9C=93       |  =
    =E2=9C=93     |
>>>>
>>>> And intentionally leaving behind the 'not large folio fs, r/o' case be=
cause
>>>> those file systems need to implement large folio support.
>>>>
>>>> I guess we'll regress those users but we don't care?
>>>
>>> Yes. This also motivates FSes without large folio support to add large =
folio
>>> support instead of relying on READ_ONLY_THP_FOR_FS hack.
>>
>> Interesting, thanks for making this feature unconditional.
>>
>> From my experiments, this is going to be a performance regression.
>>
>> Before this patch, even when the filesystem (e.g. btrfs without experime=
ntal)
>> didn't support large folios, READ_ONLY_THP_FOR_FS still allowed read-onl=
y
>> file-backed code segments to be collapsed into huge page mappings via kh=
ugepaged.
>>
>> After this patch, FilePmdMapped will always be 0 unless the filesystem s=
upports
>> large folios up to PMD order, and it doesn't look like that support will=
 arrive
>> anytime soon [1].
>
> I think Matthew was being a little sarcastic there ;) but I suppose it's
> hinting at the fact they need to get a move on.
>
>>
>> Is there a reason we can't keep this hack while continuing to push files=
ystems
>> toward proper large folio support?
>
> IMO - It's time for us to stop allowing filesystems to fail to implement =
what
> mm requires of them, while still providing a hack to improve performance.
>
> Really this hack shouldn't have been there in the first place, but it was=
 a
> 'putting on notice' that filesystems need to support large folios, which
> has been made amply clear to them for some time.
>
> So yes there will be regressions for filesystems which _still_ do not
> implement this, I'd suggest you focus on trying to convince them to do so
> (or send patches :)
>

Thank Lorenzo for clarifying the intention of this patchset.


Hi Rui,

READ_ONLY_THP_FOR_FS is an experimental feature since 2019 and that means t=
he
feature can go away at any time.

In addition, Matthew has made a heads-up on its removal [1] several months =
ago.
We have not heard any objection since.

It seems that you care about btrfs with large folio support. Have you
talked to btrfs people on the timeline of moving the large folio support ou=
t
of the experimental state?


[1] https://lore.kernel.org/all/aTJg9vOijOGVTnVt@casper.infradead.org/


>>
>> I'm currently working on making the ELF loader more THP-friendly by adju=
sting
>> the virtual address alignment of read-only code segments [2]. The data s=
hows a
>> noticeable drop in iTLB misses, especially for programs whose text size =
is just
>> slightly larger than PMD_SIZE. That size profile is actually quite commo=
n for
>> real-world binaries when using 2M huge pages. This optimization relies o=
n
>> READ_ONLY_THP_FOR_FS. If the availability of huge page mappings for code=
 segments
>> ends up depending on filesystem support, it will be much harder to take =
advantage
>> of this in practice. [3]
>
> Yeah, again IMO - sorry, but tough.
>
> This is something filesystems need to implement, if they fail to do so,
> that's on them.
>
>>
>> [1] https://lore.kernel.org/linux-fsdevel/ab2IIwKzmK9qwIlZ@casper.infrad=
ead.org/
>> [2] https://lore.kernel.org/linux-fsdevel/20260313005211.882831-1-r@hev.=
cc/
>> [3] https://lore.kernel.org/linux-fsdevel/20260320160519.80962-1-r@hev.c=
c/
>>
>> Thanks,
>> Rui
>
> Cheers, Lorenzo


--
Best Regards,
Yan, Zi
