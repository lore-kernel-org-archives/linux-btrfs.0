Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012047.outbound.protection.outlook.com [40.107.209.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6346E250BEC;
	Tue, 14 Apr 2026 16:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776184246; cv=fail; b=F8aC5Y9mn4cUfKOJlZ8Tn+Hb1A8//ZSusAIcdARdlNXODdXOoFUAtNa6ZbcGVZMjED4UVsI+UfK6QDQaMPjqS/cgsrIqeHDhSWZcsrLlgJyfZlB5ZhHbUCO/FNmPGb6AmUculjidPOVQOehnta1m3EZ0cjXtlsBI8bRBtjVgc2w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776184246; c=relaxed/simple;
	bh=4yjRytFV8Halxj5cXBCn32zXUsRecgyKJw0vJMS7Y6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tOzkEcp1A+e3KTT8w5CQKnZ/SW/D37APkEzAJ08LI8ryh67FrFNzvJe+l13KgJ66QdVD3HAbhOkCM+zCCXu/Xi/YwFNfelzcp8Q1DBeiQO8ZXR0M/0Lb7mhN76TOkEuc7vNP3fOEwuoZXtyv+NtthaSDFp4tVmV5/qxAqCOYJ9Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=W2KcOpKw; arc=fail smtp.client-ip=40.107.209.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="W2KcOpKw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AoiS6oA5ogOAph7H/NEsX3XaWJM/J6lAICUCr5Y6m6/BSYaEtbA71rrv7eryX6yGVB5jnhj+YZhyt8VBM2XTWDz3syaW6erVeDx3VmA3oEytSwssvhNthuZ8m5jxvxl6Wot5pKznzp+Rj1hT5/Hh/phDBYWxfjPVY5wVLNT+svIyq1dXudVEEaZTWH1FEsK4FMf687S1xajYTTnZJ+HqH0ZQ2j7LD3OB//WzXi7vww5/53T0CPbHqAQJEWd9ih5hMlor+SC79qnU+Ch+VwZi1tqtgvEBdZY2VVOIkQegTHl34oMBg0zECZRrHa6EKE1VqWSbs0FxA/8CXHZqVYWYjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vbv2AuIgKbw9jAgPU0tUUOZqkAC6Tmg+2W3XRoH4B6o=;
 b=SkmeOvI5x3n/vo6FIciDhwbYIcqVGeQAKIpkjTpPUKy/YNkeSW8qSJVv3BsibZCChpxIQ2gS2d72oUXq+0+t14UnE22njQCqU6XMil7SP+jb3ccMvSTVQg1M01tPC2isD5ue9APZqwxIfysVRqW7o18eYETf8hvqApX0yqle6fJ8eZSCNkOzPB81vzsjRzVsBU1Nmg86WLZ+e7XB7IPg0YVvo++pxIE9gmdG5ZWZ+o5i0NuXXK/l4LHbGHMUYMownTN8pEu+vaqxdm66QM+nCj4eUw4F29NAt0xhJwZV38ZVEsYE58tpZLNYW4S/pnjFG88dixujT9Tv5S1WBSQ4vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vbv2AuIgKbw9jAgPU0tUUOZqkAC6Tmg+2W3XRoH4B6o=;
 b=W2KcOpKwwPqIC1wFP5YbiAvXzptc/p7a735qKKBhlPDHfmd5OVVKcOuFQ4060rRbH5rHS3KzeeglmxM/1AhCM9cBvikHxI3jsJtSP/3xJ0/HX5YzZXzvp7YhygM8saJGwzGtHv7sce5rMH+32wvvqgJeYVmiwoqIlcz94K6YdSEbiUg7vsspnaU21vtk1bXMRYeGcrS7IVw/bR69V4HLHNfYPZUSHu2vmB6LBKlU6GwUv1gkDEibOwMrHA+9TJDCezYBlk5AP47d+XzDr++5zl/8ia63P6IE5oQx38CiqaLJuTJnHCaSc4HgAhlpj02MkuWeFfXLfztW0cIbnQr3ng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS7PR12MB6360.namprd12.prod.outlook.com (2603:10b6:8:93::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.20; Tue, 14 Apr 2026 16:30:31 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Tue, 14 Apr 2026
 16:30:31 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Nico Pache <npache@redhat.com>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
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
Date: Tue, 14 Apr 2026 12:30:23 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <84B8F641-A3DF-4219-AA57-6BA48E9B4998@nvidia.com>
In-Reply-To: <a4d477a8-71d8-4219-9cb3-153f2c01e184@kernel.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-6-ziy@nvidia.com>
 <ad1TMjF1L3usYIC5@casper.infradead.org>
 <05F00072-7E06-47C9-BC26-FE3736F557FC@nvidia.com>
 <a4d477a8-71d8-4219-9cb3-153f2c01e184@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL0PR02CA0123.namprd02.prod.outlook.com
 (2603:10b6:208:35::28) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS7PR12MB6360:EE_
X-MS-Office365-Filtering-Correlation-Id: e5af9db3-7784-4564-d54d-08de9a432512
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	5SxZI6GYmppoivap7DTt6VK0EzfdepewJjL40rd+1FdNG5/QJsFqS/YppfOVJNg3MfecxDQhfEzOJy3Dns3xHYcAJ1CI3ndF+3HWdEBv+xbRrntsx1fFEzS5dBs7oMrKcG+L/MS8037Ifm9xmM1WYREYRsSXbIeALpG30sL0joIBg2c/vzwVw9m0Yn4aPhxV17jGvQyRvKkJq/41eXS3GeixthcI0Gkbt79MFPHP4uz4NoRBGEdBiJAiNOpV2Su1AuEXgpaOx8niJk8y6RugfwMHPHzXxuFqBL3tk5X2kFEiCxjNLAIZPv7nJrlVrgW5dF0VlXLYeG7Fbx2v8OQJzxe9p5fj+yUXLfoe/doROe3rGeEr5wDiTC5AwaY9eVCVTJfbFWkrcp6FTHaXg4gMMPeJUY2c+RKbcJ+P9BdXosZpPPazrib1b1b2gCbTa8j7APeOYfhGIlxlufAQmB5dazN6HjzYRzV/CU+rSzmF7Q702jXgg85DW8JRO+FD+zauVIkc0S43vdbVjKeGojDO0f9mDProtIfDfTw70IyJnp+e00+EDCSqDqEnoSlbro937sH5nA9C/MhphDmXmTt1J+igYWBzFf16Xy747ml6jh5m3RUqgwbI/kt1N06SkirjDzhYQUsM0y5NPfBKUmyTKCn3kR/yfg3R+FwaULYSTQE/aA8oIHQyYl/KPfaM80OdYBYyjVP4P7VBDqgpupyVngSfkrEaScQyffF41XHdGEQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R2lMU3pCdHNITnlINElDZFp1eTNEdFhTTngzdGVORy9WeEg4YnpMVjBheW0w?=
 =?utf-8?B?bTBRMlVCQTQxaHNpSVUvRXRma1B4RjYzYVV2V0F3MUdqVmZPdmN0Qy90d2Jl?=
 =?utf-8?B?eUtqeWhrK1gzQ3RJdnhBNEYwMVRPZFNzYnVueUN2YUpSNlI1TWpSdUNrTDRC?=
 =?utf-8?B?a2loeC90YzY3Y2h4eFJPWFJXQ0xaVmRjY29HWkJjWEFvbWxHSWRsRXE3dlpU?=
 =?utf-8?B?QnNYTnMxSDMxTDdUa05qZ1hjZHgvS0VHME85WDlzOHJqaDhSMzFTcFBia1NI?=
 =?utf-8?B?RFIwdnpzVjlTN0UxNW5SQXlIU1I5TldUM1REbHQ0bFRpRUw1dml6R1hRL3NP?=
 =?utf-8?B?R29FU251Q0V2bTR3b3RoZjM4alg3dHowUnlnL3BubGtSVVdPZWRaSExCNWZH?=
 =?utf-8?B?UElhVHAvU2M3YWdVbmhMcXBwdEtOSnFHMUtnYzFhRkxBK0lQNkI5dEJPbVlt?=
 =?utf-8?B?TmgzR0ZOMHpiMVcxbkh5c050cW5DbVZ6bTkrQTY2T3FmQkRVdnk5TkNqa2xx?=
 =?utf-8?B?WVpLb1FWa1l0eXBrd2FyU0dzdjdaaUxKdlJrMWpLMkEzSVNnTkVSK1NPQUpa?=
 =?utf-8?B?d01VNkQxbzVPTDJaZGVoUzFFUGNOL09BU2RtZytYTTRaMVNRNDUzVldJTXpm?=
 =?utf-8?B?VzNQcTZ4bWpleTNzWFlJTXFvY09Zc1ZZUTgvU3EyY2lwMS9GODVrWXc3N0Ez?=
 =?utf-8?B?OThzWG12YkJ0RzhQSkc3bjBBamxIWllwR3d2YzRhdTlXYnVFTHNFUmk4VGRJ?=
 =?utf-8?B?cVV4UlBFMk1jbzg1Y3ArajkxMk16Vy9BZUduVWRXN2pwYWZMVWU4d1U2R3JI?=
 =?utf-8?B?SEFnK2N0TE5URzFPcmtSdk5kUTN2dVBObWpER1F6Q25FbXo0OVovUmYreitl?=
 =?utf-8?B?TktPaW9XWUVpTTdmUFJwbURESGgyVFJqRDVSTzJEQXY0NFN6czllQyt4eEJZ?=
 =?utf-8?B?bFV1bVc2UVNpK3hvZnpZaWFOMDFUZ2tlVDdwdlFSam1FdmJpZjJDWEEzZzNT?=
 =?utf-8?B?SUFqQ2x0VXd1bnhlK2RpRTV2QXlSZEpveTdxcnpBUmpwSUVlbm9iRGRKUFBE?=
 =?utf-8?B?RUFHVXZsUjJyVEEyeUMreWlrN2NhbVdaT3lZSWF6SFZvc1J4M01nUDBVNnBP?=
 =?utf-8?B?N2JvN2RLRkYyTTRMSTMwSDUxMmJ2Sks5SjBmOHl3OUtiUjdGcjRpaVV2cngx?=
 =?utf-8?B?a09GS2c4dWoxQTJwbkZjT0I1YlhEWGNESVhSK1RxM2hqbWMwTFNhaWFDQXc0?=
 =?utf-8?B?QS9UczlDUnV0eWVkSFhkaDluU2psTnVpWlBDYTRSQzFrVDBoTUc1WWlpWWJn?=
 =?utf-8?B?K3Q0SkpZQ3IxRGFPVmxWYlZGcDNnTW5rNndOeFJLaGoydHN3Y3hkN1R3dU1G?=
 =?utf-8?B?VFNoM1JrVEEyWEIyWXphZXRzYXFBSTE0T1lZUTdGY09HdlVHUEFONWx4a3ha?=
 =?utf-8?B?ZzVKdW9jVkVKNzNQT0gwTUQzeEJZekg1MHV3VTdKTFB0Vm5oWHF6M3g4WVhi?=
 =?utf-8?B?cU1yUWg5REVIdDBhNEtkTG0reWdOampiWU96Ym9RNUg3K2hkbWJYMlRCT3Zo?=
 =?utf-8?B?SDB1bmVPMEM4ejA5b21jdHlnQ1I3dy9ueDZodkpwcGFqK0syZ2FYMUdWZ1I3?=
 =?utf-8?B?Q1MrcTRmM2JzWjdVdjZienQ3QVZNNHZxMGEyT2JRaGZlZmN3S2lYbmgvcXZN?=
 =?utf-8?B?b25WcEFIUjVjN3JEZjM3QXgyRzlWckhac2dWUGxCSXh1VmdCQXZyRUhnOVF5?=
 =?utf-8?B?clJKNlVEOWt6bENqVUs2bEtrYitIWWk5bXE2N3JJZlNKdnpqa0lDSmgrYVpn?=
 =?utf-8?B?SnE3dzArRGFQS09Pcm5VNUJkeVRDaFdEY1dvRmQ2VEhxWHRkMlhyYWlXSzFW?=
 =?utf-8?B?Qnd3UnhVMVNaYVZtVVZjREZIYU5DQXlqUThqYkd4MDEzODZuZlNWTytzdzJM?=
 =?utf-8?B?dGl6S2JWTnBtMlVDeGdsWEZoQXB2eHN1ZEVGazkyRFJzU1ZlTkoxRlJRbm04?=
 =?utf-8?B?U3lDSGRNMlU5UC9iMDBwakJ4R0t3QkxJTmZOS2lNV1BLMEhUYkZNQ3dhNXdW?=
 =?utf-8?B?Y1U5dnVDR3BwQkx3NC85YWpSZ3ErYlJKV1hXM01ONi96cEdoWk4xc1dWU0Rz?=
 =?utf-8?B?TnBHbjI4cXFucU5xV1lTQmlnelpGTDJvaFgyZjd5NmdYWXZ1MjdYb28vdFJl?=
 =?utf-8?B?dkZ6NVU0TWhOelkrVE9ocjkvUWs1dThic25jNGZ6SC8vWWVOQktwWWJ2STUy?=
 =?utf-8?B?RkQ1UHp6VnVoYjNHL3FRZzZsRE9OY29lQW9YRmk3NTU4TVduWk9saE5aSGVO?=
 =?utf-8?B?NzhtYXpkcUdXS2MwNFpSYllKZjBwTWF0cDF1eEs0RkhNdG5EM25IZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5af9db3-7784-4564-d54d-08de9a432512
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 16:30:31.0240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O0fpaTT0Ps+X9zarf7m2/4UVLCEWib84dhNB8u9HZZAF0qX7N/Iw7Jr0KhY3EvAQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6360

On 14 Apr 2026, at 7:02, David Hildenbrand (Arm) wrote:

> On 4/13/26 22:42, Zi Yan wrote:
>> On 13 Apr 2026, at 16:33, Matthew Wilcox wrote:
>>
>>> On Mon, Apr 13, 2026 at 03:20:23PM -0400, Zi Yan wrote:
>>>> After READ_ONLY_THP_FOR_FS Kconfig is removed, this check becomes dead
>>>> code.
>>>>
>>>> This changes hugepage_pmd_enabled() semantics. Previously, with
>>>> READ_ONLY_THP_FOR_FS enabled, hugepage_pmd_enabled() returned true whe=
never
>>>> /sys/kernel/mm/transparent_hugepage/enabled was set to "always" or
>>>> "madvise".
>>>>
>>>> After this change, hugepage_pmd_enabled() is governed only by the anon=
 and
>>>> shmem PMD THP controls. As a result, khugepaged collapse for file-back=
ed
>>>> folios no longer runs unconditionally under the top-level THP setting,=
 and
>>>> now depends on the anon/shmem PMD configuration.
>>>
>>> This seems like it'll turn off khugepaged too easily.  I would have
>>> thought we'd want:
>>>
>>> -	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>> -	    hugepage_global_enabled())
>>> +	if (hugepage_global_enabled())
>>>  		return true;
>>
>
> I assume such a change should come before patch #4, as it seems to affect
> the functionality that depended on CONFIG_READ_ONLY_THP_FOR_FS.

If the goal is to have a knob of khugepaged for all files, yes I will move
the change before Patch 4.

>
>> I thought about this, but it means khugepaged is turned on regardless of
>> anon and shmem configs. I tend to think the original code was a bug,
>> since enabling CONFIG_READ_ONLY_THP_FOR_FS would enable khugepaged all
>> the time.
>
> There might be some FS mapping to collapse? So that makes sense to
> some degree.
>
> I really don't like the side-effects of "/sys/kernel/mm/transparent_hugep=
age/enabled".
> Like, enabling khugepaged+PMD for files.
>

I am not a fan either, but I was not sure about another sysfs knob.

>>
>>>
>>> ... or maybe this whole thing could be simplified?
>>
>> Alternatives could be:
>> 1. to add a file-backed khhugepaged config, but another sysfs?
>
> Maybe that would be the time to decouple file THP logic from
> hugepage_global_enabled()/hugepage_global_always().
>
> In particular, as pagecache folio allocation doesn't really care about __=
thp_vma_allowable_orders() IIRC.
>
> I'm thinking about something like the following:
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index b2a6060b3c20..fb3a4fd84fe0 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -184,15 +184,6 @@ unsigned long __thp_vma_allowable_orders(struct vm_a=
rea_struct *vma,
>                                                    forced_collapse);
>
>         if (!vma_is_anonymous(vma)) {
> -               /*
> -                * Enforce THP collapse requirements as necessary. Anonym=
ous vmas
> -                * were already handled in thp_vma_allowable_orders().
> -                */
> -               if (!forced_collapse &&
> -                   (!hugepage_global_enabled() || (!(vm_flags & VM_HUGEP=
AGE) &&
> -                                                   !hugepage_global_alwa=
ys())))
> -                       return 0;
> -
>                 /*
>                  * Trust that ->huge_fault() handlers know what they are =
doing
>                  * in fault path.

Looks reasonable.

>
> Then, we might indeed just want a khugepaged toggle whether to enable it =
at
> all in files. (or just a toggle to disable khugeapged entirely?)
>

I think hugepage_global_enabled() should be enough to decide whether khugep=
aged
should run or not.

Currently, we have thp_vma_allowable_orders() to filter each VMAs and I do =
not
see a reason to use hugepage_pmd_enabled() to guard khugepaged daemon. I am
going to just remove hugepage_pmd_enabled() and replace it with
hugepage_global_enabled(). Let me know your thoughts.

BTW, this conflicts with Patch 12 from Nico=E2=80=99s khugepaged for mTHP p=
atchset.


Best Regards,
Yan, Zi
