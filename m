Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010051.outbound.protection.outlook.com [52.101.56.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F94D22301;
	Fri, 27 Mar 2026 14:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774622811; cv=fail; b=a5ngn1b1LcUIZRIODlqNL8lMOcQypZ/wx3V4+DNOkklFVLQIQ/cmSbRtlYG+Yc7GepyJy56fXrO6RswenSi5lVGLI2jJfEZC/dXTx058HYMn+cgazjaQ37H7KfHzNAGqRT0/niEa4SGBokChjbevAYZxVVFrnLDmkexdf4MtpCg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774622811; c=relaxed/simple;
	bh=071CPwj3SsZ27/wqJRvZopi11WtNVpryf6WhuzG7HkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FJ3SdlGDPYgKqEQXRkHFIGF2XHmiBNdAtCj4+tySQFiEQ/C/5cAqlleujNOKlc2PIsc8BY4GbfTGsOa/F4Qrlqjt9L6X2ft/5lRy9TrNr0YV08+g8ihpcrRT11dO3nnsFCwBx+giC46LURDBp7NjyqF4LNS9QhHxIwnwGhZMuq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CMaZHwyX; arc=fail smtp.client-ip=52.101.56.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CMaZHwyX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ekRU4zuuVicUeZhdxKhmtk+YdX6lv5qAft7i5VMgkEsBLdqzqaoUZ273HGjWewNpvJNZzI6qasWMNr781WRiovU/qdlLh6pX21wWc5k/d7hdXDpwv2Cov0l0aRFXK/nZlfP+TE054Ok2+cp9uXXKD7iZSnIMUrG0osxYmCpNMSme9y5/M4KGFrEm9RZLMgVbNyHYtz82jDzcg/CIhAq1OwV1Oh6n05BwpegxUhMqXUX8fWBnxf9I92syhtId6c9AjeCKiJL9si6F/+AFLzEZML2GBwiVs98BpS5QeWu1T4Yvenj4X4ZmNBRQFIWgJNOlCChnT/B97lzhrnaRobkqmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UO2ps3LsBuTSzyvMpsObW/Yrh5p2jVNefN7acX0Y9Lo=;
 b=LDLFTJTruDdDaFO432Cyy4YimIQt3tq02SyRfN0Z7Di3uPsuFVUxHQOVPWXtNTqhfTyIBLfQaDtgD5rSlmRenvNM+YMEsq8d0OuiOstFYGBm9JhztviwrRKFK3Hl0B1u1v9bE7HuOU6Rpx4TozdXtwjb6q6xUgK6NeQVUE6vgNJWMUr04tJnGyFSQIYqDks3li79B3mlStJnv0NM55UjHrjlkZXUTw+9d6Id3rAnIRggA9JCp0tUl3bMXy/QxJ6d+5tQwlQh6WEu8/KOvW8rO8L0Xm+38tDkQLqZOGQ2NfZ67eVwzYkdyOAQbAjD/pq0fPYSxilRzHCoYT4fMrOYUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UO2ps3LsBuTSzyvMpsObW/Yrh5p2jVNefN7acX0Y9Lo=;
 b=CMaZHwyXCtbiXNP4O4ag0AlhjDjJzMO6QplgCBuvoUS/6xeOrUyEHklxfAgTwXQigeK3xoHXRvSUigOK8EF4kHALIYWccZHdR7sX4EDCx8o6OxsqawIeAijONKQLNG8NBsm/aiHF0SkTUYb8dDi9Ja490MdYEcDhrHrZZ0797Xj4cC5N1+bJfgYOv3r5e7vuDnf6wcN8TW6r2OCF0efC/nkd/G8SlBkWx3FMPkxpEHlkL6Lve05qKGXGqbdjlvkVQMBMvdJAH1Ra8EospmWnJBLOlifnBqYz2a0OXXnGaZlHrEIXrGaz1ReL9l5hBqUjGON2QabKgeOXINr9JPOpFQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB999109.namprd12.prod.outlook.com (2603:10b6:806:4a1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 14:46:46 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 14:46:46 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
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
Date: Fri, 27 Mar 2026 10:46:43 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <ECEB0ACF-73B4-4F0F-B355-FFC209B3BE6E@nvidia.com>
In-Reply-To: <31d9d5c1-02af-42b3-bc3e-aea151d3552b@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-3-ziy@nvidia.com>
 <31d9d5c1-02af-42b3-bc3e-aea151d3552b@lucifer.local>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0410.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::25) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB999109:EE_
X-MS-Office365-Filtering-Correlation-Id: dcfde492-96e3-44f7-6ea9-08de8c0faba5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	LjXB+tPAAGCH8Pih+INIZSHghrBAcblv8w4WQimvUOwPSEV6MkeNVxmkphWrTwC3bSJKQ448lJZ1O0WuTlIp1QwcooDH+3Oa4aav8BGkdhyApco7e7Lf495bNdgS6mE/1Z7dDSFf1xvL2aep7gTpVs487/UijPLidFSLWrsC67JyDRM9kYBElb5pOMeLeubp57fitQM2NZFTt/KfKEZs5JWJ9SHoZ1ZpROxODPsggO3UnH27pBDE7Pmj1JsZS0gJ5rPvR+fTlrxmG4cymiDEuMJD8jeCplO0jTQHxOg4rBPwdOAZxxdtpNF957Bh253PCjNTf22yFJyjmAcFcISL+qwp4MNNuqW/KustUrSui0jDYfZVQ8fJBL/PGfnjelv0QZJVZACuKLLd8V47ZxdPjoRMXfWSySCMI1u64eoeSC5Znn8Wmzhw0+OnpqBLqWU2SGnA3sX1RRYHTDM+kJarg3fWLGIP50z8RgsTQIJzcGJdQWdAMB5uvLvIpQZniHYqfEfBRNv3+mftUaSacLYq9LhqrrYf5aBWYOKVjt4nhiaeSPofgKySEulGJz6h05FIOsyNuit+Qrb6UJUw8d7VyVuttbhkmFODjnP1XsMYAOVaCASPnzmYeoh2eBFw3TTWrIPgrtvTFupv4/buOrrQiyVZNGoQDHJT7MtiIPd3mlpPq1NDla9MBgXN5MlHvGQnK/2HnnZPbBQactwhYsWgBYFTLo+YbIpAVY2/H47zaGs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lPE1BIdaW7YhVJ34JlDJomizC49lRSF65ThZOGYCw/jmvHHAr3hePdoLSkJw?=
 =?us-ascii?Q?cYFsN+vTVoSEGoMYjTz1uOnxonZ/hclwztq8F69Ur2SXdo4Hkua2TXbI6gdh?=
 =?us-ascii?Q?6s1BlHZfZ9vs5KQ/uHbblfSSOPxg6AwATmtjpOas+/V3ssQsejZgbnHv/LBv?=
 =?us-ascii?Q?XYWYQpFx8BCl+uBCS1H8k5LUuB4qyqkm9lhVkyLreS9zue7k13RCjkwwboYm?=
 =?us-ascii?Q?R5Fb8q07/7lD5Y7agNSkchjFeV89xiuL0FzExIr/55M/MTcStkogYzA7WvzL?=
 =?us-ascii?Q?xruMHoKReXcjRwsRZ27oF/CjhLYmpTQ5Mjf/U/lv+3djuGRPJyKfYBHwDNyO?=
 =?us-ascii?Q?3uQLcEJvsdo2SGQVv5ec3CCyPc7lIj24LHJ+IDGIVEXCUYP45fqd+T1KfvyV?=
 =?us-ascii?Q?0BA0R2TPsEV1EN5XPzS8Fo2ixHineLQ2r6XH49xYtEoMqYDEeTsmGcvwHjZO?=
 =?us-ascii?Q?8AUGTKWO1mgwf4sYiTPN5luZQ+Z++NojvHwN9ylJ4EBudKBfseLoLPwEjvwZ?=
 =?us-ascii?Q?cWnFa/PNCInZoUOMHm1eXMsnzufHLzciZpIdDIjnQDg+HPt/Pjfx6VIcIIiF?=
 =?us-ascii?Q?lg4opCzpH3QmbEsFSlm3Iz3YRotmRy5RktOXkHAFQ7nhUkggT77wfFFNiWQ6?=
 =?us-ascii?Q?Gs9AqHzDO0hu0tfjkkC8Spum5Dw2A9jrCpCdrkbNho5ushwMQVXzAkJ2Kdbk?=
 =?us-ascii?Q?gqQmUYc+CmKq9/d3cAIDbDAEuPBuffU7AGUiQhV+R6wZa19ObFFGCBlP/lLS?=
 =?us-ascii?Q?Oo5tDa1qp+tHeoqu1iwRI3z34ABrEZ0T9l3nUa1Pjqu+yl/WLCu1JJRgJHOX?=
 =?us-ascii?Q?GteU4YQEgLFLYvZEZLZP2FzoFABy6noT8+/jzK4JckPCM4bPqY58OWcyYdU3?=
 =?us-ascii?Q?IEfXPlCTGZlJO3Sb9YH2w92bYXI7iXm2N7yq3NuYv8c9MBTc5FphPDp56RnP?=
 =?us-ascii?Q?aTechgJMg9wiYeT0AqzItwsQDD4BEL/5ziKSDg1LH+ctyg/rlP8OiyekFzZh?=
 =?us-ascii?Q?3ajzbZnezv0nYD2RvnpXLU1XQ8NvM/NFFbr0FQge3amUcpeh7VZnWgk7aLIq?=
 =?us-ascii?Q?R4ILNLC8p7SYEsjBxKYNKL2gUys9lGwdVvFtHOkrgfIVUemp1Rd2ec0dHmRx?=
 =?us-ascii?Q?DLsVDhRGa409somk+37rILr/dGmzqn/ShTLuOluA94qf3ZAwGuMaGhjF163S?=
 =?us-ascii?Q?JErjoj54aqGB136vQbIcuddC3JIm4WGrfe3CYT2+CNVSrSfeVzh6m6AMG9xM?=
 =?us-ascii?Q?tvJEBrXh41o4CjDResu65wkqhDoZWkHGzFGHRhP8rW1QYkEwv0iA2NXvnTCQ?=
 =?us-ascii?Q?sToUKpg8k90s61WAJLmm7KTc9lc4C8xkcnp83PlLCuiROx0nyzDGeB3mbmTU?=
 =?us-ascii?Q?E26M4veoRJyYE86+Arrc2beHmN3bPza+sJx4DCvR4MJBV7JPsicwQ7act0wB?=
 =?us-ascii?Q?3eTIjhvpU5Hn43VaNmADO3A3MzTRx7VyDCSkejRBhbX7pr1H/4Lwq8gZCdQe?=
 =?us-ascii?Q?yMXZp2jxr/GFj1m0cbl8C1D5Tr4x7k3P84xiUOxh5G9iyGykUGcqW/P2xFTR?=
 =?us-ascii?Q?vt6LJSBOPwdVKiDzNwAo2KZUKPzjivASdmLDbkh3023pihMdrOqi20/KqK/d?=
 =?us-ascii?Q?tm5ZOb3I6P15JddiZsbrRxx0dhCXMFgDtm2XJ1CASjDx1Cr4LvQMjAOV9LKG?=
 =?us-ascii?Q?smiC4AoncCpm6UkKxITnoLWHg3Ocza66ei3u9a+iGiiZ78l52ufuUM9TC0hT?=
 =?us-ascii?Q?+WEmdRukfQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcfde492-96e3-44f7-6ea9-08de8c0faba5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 14:46:46.6829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d51+8oRiA7fRza6Y5tRNKxqvXngQECFaaRi9s8jf4ge3c7tOmwcZ/hcejIfh7+2X
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB999109

On 27 Mar 2026, at 8:07, Lorenzo Stoakes (Oracle) wrote:

> On Thu, Mar 26, 2026 at 09:42:47PM -0400, Zi Yan wrote:
>> collapse_file() requires FSes supporting large folio with at least
>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. shmem =
with
>> huge option turned on also sets large folio order on mapping, so the c=
heck
>> also applies to shmem.
>>
>> While at it, replace VM_BUG_ON with returning failure values.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>
>
>
>> ---
>>  mm/khugepaged.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index d06d84219e1b..45b12ffb1550 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1899,8 +1899,11 @@ static enum scan_result collapse_file(struct mm=
_struct *mm, unsigned long addr,
>>  	int nr_none =3D 0;
>>  	bool is_shmem =3D shmem_file(file);
>>
>> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
>> +	/* "huge" shmem sets mapping folio order and passes the check below =
*/
>
> I think this isn't quite clear and could be improved to e.g.:
>
> 	/*
> 	 * Either anon shmem supports huge pages as set by shmem_enabled sysfs=
,
> 	 * or a shmem file system mounted with the "huge" option.
> 	 */
>
>> +	if (mapping_max_folio_order(mapping) < PMD_ORDER)
>> +		return SCAN_FAIL;
>
> As per rest of thread, this looks correct.

Will respond to that thread.

>
>> +	if (start & (HPAGE_PMD_NR - 1))
>> +		return SCAN_ADDRESS_RANGE;
>
> Hmm, we're kinda making this - presumably buggy situation - into a vali=
d input
> that just fails the scan.
>
> Maybe just make it a VM_WARN_ON_ONCE()? Or if we want to avoid propagat=
ing the
> bug that'd cause it any further:
>
> 	if (start & (HPAGE_PMD_NR - 1)) {
> 		VM_WARN_ON_ONCE(true);
> 		return SCAN_ADDRESS_RANGE;
> 	}
>
> Or similar.

As I responded to David, will change it to VM_WARN_ON_ONCE().

>
>>
>>  	result =3D alloc_charge_folio(&new_folio, mm, cc);
>>  	if (result !=3D SCAN_SUCCEED)
>> --
>> 2.43.0
>>
>
> Cheers, Lorenzo


Best Regards,
Yan, Zi
