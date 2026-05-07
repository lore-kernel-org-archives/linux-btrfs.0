Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011020.outbound.protection.outlook.com [52.101.52.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2101E34104B;
	Thu,  7 May 2026 07:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778138492; cv=fail; b=DY1G2TChKFtb8V/ElcRyYvyDnElQ7kttnzcbQ2OFvkY8dww7MVB6vlruEJFU+qkMkNd4BNK3r/zw3NFCcBAB7CizlMiHcQlbaw8/He5z5ywlDMUL1jWxMnWs7u77HWSBM3ZkvHZwOGXKncPokDaV5TeSX2Hdi0PHyD2qNeGx3ko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778138492; c=relaxed/simple;
	bh=u1ginf7pWv9U/hT+UVchgkIgyPhmaE6sKv2xAqydTwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=q0MAzG5UQS81ZTQVwcWK+NdQkr3OxIPnOg7R42ThAklC8yt6b4HsbzH8FF4xokoTdnWGkkLHgs++7vP+DGqZY7JRqKK6Bq0QWAL6WjQn8hAmaZE+BinibZEjJZFz1FjJ1q3bgTxe0JVrBMHzUcHA9SAHJXw8Ib3jBuLcpmWwHmg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ncSFfcmK; arc=fail smtp.client-ip=52.101.52.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ncSFfcmK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V8UmiVyVGdaPwayjKhZCsAFdH36/189VX9b4E2X35rh4AUOcepKi6Q3jBwzJH+x1C7aomPcuVt1Yzj+PG/dF0cb6583yTATj/aE+F45E/FH3wo+z9WFtAfYZnR6Mmh0kDet+t0r+YeRS6YlCCjsjy+Rbdw0NW4j7YA09RUEIJeebDxE+TmcpfxuqGE4MTR/ezi6dsCXq0B35/idLFvBANFq1MKWIPbYeXnXSWpp72ebCTgDhvNb0OvbQWBr4KLgEeDPb/yYkU6dkpTj5Q/xQzQoM4bRoPjzPEuRagt6IC4IR3zRPmcNbo9fLnoAp8G17upQuvZL4J0okrJVtrxlv/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mvVuTDpY1FkBGoYTM/WV2tV7lFNyk2qBE2NHTsHqYrM=;
 b=bAnS/waNhuW9V9RyOzvFgOUAfcXy6Y7cIKdrgH+zut+1FXFOPET/7SQ7dBmCovEWypmeXzuoKvC7a58PqwyLUlIZviFHSES7mubBdkBvGUrfG5zc/uW/QR7y2fCP2m/E3/oSi2SW2esmvEyoDDfzfr8/GjgHZIJ1ftuqeRvj9nFibhi0pcH0iZZabhq/oX3uOr0B1kWTBORvw51sqr/hvoXLK/HhvNNS66R5ITt7BXXyY4Uih2887qc8H/n2vdkrPIMgQ8qOk9pyp10mqv5+EVeMwELzQPtekG6Sj4b/jUPcxac/eqt9NJZrnZn22ph7J15osF1Gg7efyk72y35GkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mvVuTDpY1FkBGoYTM/WV2tV7lFNyk2qBE2NHTsHqYrM=;
 b=ncSFfcmK67xMlUxABmjAHiXayWxxVVWitLyRl9saq2VnR3wkwRoS1GHt2q7gmlpGdHsIWbsSjYBR9wIcmK3he0r9ThJ0mNHSAGJPK/MZEn+9inVaRmH6EhU+KXldqjBVtTEfZy7BbxvsI6sgiEDOSv1tISYn28PdOPEFY69WCBj9KS8OlMQ7O8nNMgkJktwC4LAaVcTNhqXznIWMVJz/W5/JH7PkcUpNJGLsMVdgDi13DNwawaxYmls3UHXyX4rEzF2neCX3j7ggLnXt1eyygAS0wIJHwMq0VzbFFGx8qqdegI6ghgq3wbUMC4+UHf/HKpPg/qGIjF/yxrwSS5+YHw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9)
 by IA0PR12MB8302.namprd12.prod.outlook.com (2603:10b6:208:40f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Thu, 7 May
 2026 07:21:26 +0000
Received: from BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1]) by BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1%6]) with mapi id 15.20.9891.008; Thu, 7 May 2026
 07:21:26 +0000
From: Zi Yan <ziy@nvidia.com>
To: Nico Pache <npache@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 11/14] selftests/mm: remove READ_ONLY_THP_FOR_FS in
 khugepaged
Date: Thu, 07 May 2026 15:21:13 +0800
X-Mailer: MailMate (2.0r6292)
Message-ID: <1895A67C-BB1F-49EA-ADC3-AA4F51A6ED57@nvidia.com>
In-Reply-To: <CAA1CXcDj7Y7Z26f2o211fYewgrfBNOS7SfZ8Xroiv1ObC8dDRw@mail.gmail.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429153538.727855-7-ziy@nvidia.com>
 <7e42faea-9f55-4722-a426-94be7fc3a49b@redhat.com>
 <61FB928B-03FD-4852-BED5-4E453ABB706A@nvidia.com>
 <CAA1CXcDj7Y7Z26f2o211fYewgrfBNOS7SfZ8Xroiv1ObC8dDRw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAPR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:208:32b::31) To BL4PR12MB9478.namprd12.prod.outlook.com
 (2603:10b6:208:58e::9)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9478:EE_|IA0PR12MB8302:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d119ec1-a943-44ea-a745-08deac094036
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|10070799003|22082099003|56012099003|3023799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	3k59F/7IoPCD/Zfd+tpOnZNl21WHADI9l+xPZa+mqbNNGWF1IYI2rXfz9E6oklvHuIVCZ3jgz44vAW69U1rFLWge2hugibU3azZbmleDXovILtz4iDx6qY78N87s+4rhY7FUUvU1lZacakeLbNDW14ONIXcLYTIn/XNA5hfjRXEPWtzlRZvnrtMk7YsTgxK9SFFJSnrqq+Amo6Fut8K5clSuoVKEO2cvbU1Jkcuuxfz90pBCpl9jPRkSS/76JEj/7D51oYeJq5JpxmW4M6bryh0XIYqDnhcrdAtWP1dpRdydn3/fruyBPEUD4iPiLu1E2IrJdiCoLrhjjhEq9ipnAXuM5lzEcodIJnoi7h+ei3Nf1Ong0WqtaNysUgrp4I/sHNs6WlHCvqQaOroVbRGZLA2TzDJNpm3fMKWVCrsVnLRCiUpI2tb/9/ZVWiUilBgnu+XLPR81eIxWEWHkFTBCFpjrw6wkEf7Sc5LY4f2Y9M6l88Dd8s0mz6wxLHAuhe6/QXlwkieJP7NGMaX3r3ruG0vjbfP2RrR5FbU0cYHlup7ZDZIHHG0f6A0aNb3fSfwVwYBEOLbamNPEi3LnkQVEaCATRvdS7SFI0xX3u65plb9bAezt/Zv0So44ia38/xLYMaZ6G4/yDyiJCzHzOnjFLHD2BQlKKQM2mAEwkxjmOGSgZmwdgRJSkYeTI0HdMd69
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(10070799003)(22082099003)(56012099003)(3023799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c25jQUhyTVpGQUZpRlc0SFNEbTgvVkM3QVVLZmhzUkZzdDMwdXBrdm1kdnpB?=
 =?utf-8?B?Vk1HZkowZXdkZXdlNVo3NXg1QmkxUFBZNlNYZUtxN2xncFBoenhEZTNEb2hJ?=
 =?utf-8?B?VWNjd1d0RWlqM0pFRC9RY21iSUh5Yy9jWVV6Q2ZoRHJlMDJoQWs4M2dwRk5w?=
 =?utf-8?B?LzlLT2R6SjVRbGNFOHNOZS9ocytzSi9CM1M5UmI0VVlkb1YrUDlRZE8wc3Ux?=
 =?utf-8?B?dW5nUGsweVNNdTRrc05LazhpaFlXV01DVmlUZ2NNaFBTclRXZnp5dm10UW1o?=
 =?utf-8?B?bkNsTCtMQ1AxWmMydFR0U2hJWnh4a2x1TldFeStZeitNQUVDWUpFWDdjLzg3?=
 =?utf-8?B?ZjJXNloxMld2QjQ1QjVaSytsUGtVN1FWV3htdWZSZGRzMEorVW9JQTIxMERa?=
 =?utf-8?B?NDRMLzUzenBBUTlMWFNsci95elpTQlh2L0V6RElHbnkwZTBScWpJQTJ5ZG1a?=
 =?utf-8?B?TlRWOFBzU01xbzhpQ2luOUl4WE9RaG5yK0U0c201MnRROW1FNExEVS9NTDI1?=
 =?utf-8?B?K0t5Z3doK0lqR1pEQk9sT0lOTGNXNjZLOTI4MHJ1ajRFZ3Y5N2NKVXlpdlMw?=
 =?utf-8?B?NUFBd1RlWnRLd29FZHBucmY2a2lqeUdVbldSbUVQeDFKdUJCUnQzYUgwZXgr?=
 =?utf-8?B?YjE1N0I2emdRU1RVOTAzR2ZHZE1Zck9ycVFvMmJUMnplOHpJdElydnowdG5G?=
 =?utf-8?B?ZGRRM0hPZW9yR09XdG9NU3FYODJ5ZE1wTHBzUVpnY0pPcjVoci9DaXlaU255?=
 =?utf-8?B?YXkvZU5WYnNaTEwzU25NZmoyWEd6TXBmWXVlZ2duM2IxZEQxWmFtU0hlSVln?=
 =?utf-8?B?UTkzUC8wMHpZOXRDRFZtR3RKajVIVzFUdUwydGpTci96ZDJsT1B4dS82djlL?=
 =?utf-8?B?c25adVlMcytmakhKMmdxSDd5dlIxNUh1SC94UXN2Tklzck1Hc0Y5RVdRZGFH?=
 =?utf-8?B?WUc0VE5iR0Nnb2cyOUN1c3JTTVNlUmEvQU9rZjVMZXYybXFubE9XWjkyTlVT?=
 =?utf-8?B?R3JYc1BHb2ttQ2FKeVBtWTJFTGRlSGI5YjRPVCtjdWVQbmZKQWw3L2hGS2Y4?=
 =?utf-8?B?K2xraUZoSllJc2tuTnRmcHRPTUJzYzA4WnNSN3ZDT0tPUTd6NExSVGpLTDNp?=
 =?utf-8?B?bEgyeXJ2eUhOK3NmSlZ5MjZjTnFycDhhK3hPSG5RMnlsY0Y5VjA5UnhxVnNU?=
 =?utf-8?B?WWhiSDhGQTVTUUxjMzk0SlI0MWRYTXd5TDJiRDBvd0RGakR3VG1YRHN5WDFj?=
 =?utf-8?B?YS9ZdzFOalRJV1o1aTNEREptMGNHbFVqVzd3akIyYXhsd3JZbC9VREFBQlRE?=
 =?utf-8?B?YTVQL1A4YWY1aWZhY1g1T0s2ZjF0cDYwZVQva2lYRzVQSlRJTVVGRklYSjFU?=
 =?utf-8?B?K1VrTzZ4VTZnbFFmR0d1ay9MT1Y0Wlo1TFpaMUd5b2l5anBjTUMvdytLSEZR?=
 =?utf-8?B?cHdSNU1MM3A1L1VBa0R1djJEZ1hhOC9LL1dEaHlKUGFqa1pFRU8yQW5heDNm?=
 =?utf-8?B?L21HN3RPaWhSajU5azhYVUw5UWlMcFpqRkl5OXRQZUw2OEpBeGk2OUxQQ3NN?=
 =?utf-8?B?L1pNb2xWeEtnZnZZN2U5Mk8xME9zWTN3NkV4ZFZkMWdLRFhjeVhWb3lSTk0z?=
 =?utf-8?B?TTF2eVR4OUhwZW02YW56VGl6ZkFWNEZ3aWZxajRVSzNnQ05LdVJocnZFTDR4?=
 =?utf-8?B?SFJVYTBvUGJ2aWhkaGxCcUpwbnhkZUIwVFNoTG9VTzZWWS9RZUpLVkludktZ?=
 =?utf-8?B?dU0wSjdoRnZTYzdSMTRLMHBwRFBaRXpMUVNUOUxNRUxqQnRVRS94cGpIS1hq?=
 =?utf-8?B?T0F2ZnNxTlNlYlpJVkpJb1ZXOU9ibkhZeDFCOEVSNlBTcitMOVZyLzEya0lt?=
 =?utf-8?B?TXpyT0NESVd3OUI0QllycmhWQ2E2Y0xyUG9BQmtPUXNNR05Wc1Jnbk1XUGY5?=
 =?utf-8?B?ODJtQlVWMnVJL0NjS0NqWVA2d0tBZUgyVWNQYVhiV2J0cDB2TWV3dWtkeENt?=
 =?utf-8?B?bDFFSVdsY0hUSWFyZFRQZWJseFdjazBvZGdYM0ZGeGJCSVJQOXA4VFhpRVdP?=
 =?utf-8?B?TnhJN29RYmFGcnBSUjlXZEkyMDRid0FxR2lRMkcvYU9TNElZcmZKL2JJVFE2?=
 =?utf-8?B?VW53bUkxN2NRZUpJbm5tWWxqdWF6SjRKZXVCZHRrWkVWQjJDQmZkKzVUb3Rv?=
 =?utf-8?B?cS9wTnVZMFJRbmx2dm1XUVQvc0g5eGVyeTgveC9uUVhEVTB4Y0ZydWtkZjhk?=
 =?utf-8?B?S1Y4QzJWdFV1L1BVR3pnOStQSzlNTWtQV1NST002ZVhWcmVobFNiNXRjbkRV?=
 =?utf-8?B?ckhuVHc2WGJYM042c05iU055aFZGWVFHMERkUVFtekJKSStFMU9DaEovbGtC?=
 =?utf-8?Q?RrVfK3/PPjB9DjfpC081svpPO4O0KljK7hDxi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d119ec1-a943-44ea-a745-08deac094036
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 07:21:26.6124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9IIKHCK4pK4ZZ3fZ9SqHNAV4lEtmDLqxnKtT/OiASWLIWHH3mTim2dn4of/TE7uG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8302

On 7 May 2026, at 14:35, Nico Pache wrote:

> On Wed, May 6, 2026 at 7:15=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>>
>> On 4 May 2026, at 18:11, Nico Pache wrote:
>>
>>> On 4/29/26 9:35 AM, Zi Yan wrote:
>>>> Change the requirement to a file system with large folio support and t=
he
>>>> supported order needs to include PMD_ORDER.
>>>>
>>>> Also add tests of opening a file with read write permission and popula=
ting
>>>> folios with writes. Reuse the XFS image from split_huge_page_test.
>>>>
>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>> ---
>>>>   tools/testing/selftests/mm/khugepaged.c   | 131 +++++++++++++++-----=
--
>>>>   tools/testing/selftests/mm/run_vmtests.sh |  12 +-
>>>>   2 files changed, 102 insertions(+), 41 deletions(-)
>>>>
>>
>> <snip>
>>
>>>> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing=
/selftests/mm/run_vmtests.sh
>>>> index 3b61677fe9840..854c5c3e3a6ae 100755
>>>> --- a/tools/testing/selftests/mm/run_vmtests.sh
>>>> +++ b/tools/testing/selftests/mm/run_vmtests.sh
>>>> @@ -490,8 +490,6 @@ CATEGORY=3D"thp" run_test ./khugepaged all:shmem
>>>>    CATEGORY=3D"thp" run_test ./khugepaged -s 4 all:shmem
>>>>  -CATEGORY=3D"thp" run_test ./transhuge-stress -d 20
>>>> -
>>>>   # Try to create XFS if not provided
>>>>   if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
>>>>       if [ "${HAVE_HUGEPAGES}" =3D "1" ]; then
>>>> @@ -508,6 +506,14 @@ if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; the=
n
>>>>       fi
>>>>   fi
>>>>  +if [ -n "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
>>>> +CATEGORY=3D"thp" run_test ./khugepaged all:file ${SPLIT_HUGE_PAGE_TES=
T_XFS_PATH}
>>>> +else
>>>> +    count_total=3D$(( count_total + 1 ))
>>>> +    count_skip=3D$(( count_skip + 1 ))
>>>> +    echo "[SKIP] ./khugepaged all:file" | tap_prefix
>>>
>>> This leads selftest runs to always litter the output with SKIP when run=
ning this with the wrapper
>>>
>>> make -C tools/testing/selftests TARGETS=3Dmm run_tests
>>
>> Yes, this is intended to let people know one case is not tested and skip=
ped if XFS cannot be created.
>
> Yes but it prints after each test case run, not just the khugepaged runs
You are right. Let me send a fixup. Thank you.

Best Regards,
Yan, Zi
