Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011049.outbound.protection.outlook.com [52.101.57.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373C7238150;
	Tue, 19 May 2026 00:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779152386; cv=fail; b=hofMr28tIhmrltUNNuW0goxs28RmwYbXWw+qKLydTyDJO4oJT39eoZzMkyY2raUFNJwUYlnB8tnFvcJN7oqap2gNQkx8Ui7cOgkhUaypKlYuWMmkXIZOHJ/0XAqheQi+xgYoFpCJfjxWZ8GyyfXdnLxT6uME1vU3Yt05UgB13Wc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779152386; c=relaxed/simple;
	bh=AfWMUZaBLYNkZ/aowqFHI50UfmtNnzn8zHZaWmhQJeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Eu+WN4UDqbvIumRjzaPJw0psMTY4X9sfzKWEiHiRKZEEuenTwmdmz7frZ+hiyr7KYy4h8F1SjFtJDAodnREh7m7k+xRUm0VIotAcZA1ugduKZgMq5AN7iCgwSZHjmQ+NUV4wzQwotG5NZ5KW12ja+CvNoAyaS1ZBS3R4/YLqdA4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=G9YdFQxx; arc=fail smtp.client-ip=52.101.57.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="G9YdFQxx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n2vrFcreQ0ZoUu06PO/m0O1LIaTKogQlWwwOzwGOYaXoDMfKmKbH+3+pvzcYJ4Kye+9zSCy7M3DSBBPy0OuTx7DeE4ywnhm9/HgcR/14EcGrXa6pWg3pPEj7uuQbdGlrh4sEFSlIu8U9CHa2nBLyVnwltJqYVnDV4uegdUTiaUeIZk80ugYm80bUP6xerSWoHhd4KJq63ybhwO/82jiqvS5tHTYfyOlB8QKChiykDlmPBmsi8CfiqPWKopxNXZI3Blzd/+ZNE/qTgLAlPBbtVF2ZwNaNwsYdmVA2mlHShN3bFDfygF2V5iaCaIVnrpVCUb+wddP66I8JCLrPf8IZzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o/i4j4D8ugBKWs5L3/IVN3POPeJLMdd1POFNDCSpxPI=;
 b=xCzRlv6+Ol0VBI2laxX2tpGxz5kCefn/aTlOAomozxAVNueeJUmo8zcvj/+DpzrNocNR1SuO5Z4fJgwGRZU/jq7yOr/x7NJ3gMoThqUql8YgPr97Md+LUmYtFC8zhCU+WMctg8k7xtmLLwteBbTuqyvBPD+hzc8SotLY2YkxDxoQKzNiTlu0YIjmKG8iVBmDt07bU82iG+cVqXoDwqTAVbXI2jUn4d7UP51dVm9B6zQc7LRIs11swj6OjhuE5Ghm96xz1Gkym9JC5Dysup8urT9npVj0xnFhb8CG8MupuRruJKOXfzIEDRMrO2xUVqcBDZyamAm8zDA2e9raOlnUxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o/i4j4D8ugBKWs5L3/IVN3POPeJLMdd1POFNDCSpxPI=;
 b=G9YdFQxxiusd/7uDaoZZIEg3wY6aZhDghLVI+0a33EisMw8G7+ZKKmXUe3oCN5cc3ukONENZc2VEtHY64kuep1IaBfRzUTfZyB7l+C9ZVOXdxFY7ouQsNh00hjb7Ors4awUOSOhbXTWXOqkqKYE7L+hekh21fXBIaEfMoUJgXeKutd9sLZUJQRNgUnJrrfhOkkEuaIwElP13dvNu7IkyFdmzJMP6eB5CQTfWK8UJFNVtw5RK8LxF4OjeLihOtD+GbLsVBiIkBxEy1/0RlrTaweciVy6a1VLk3G6BQhKXe6jixC6YJB6DVB92r6Ryu5VOTUVZXgMNXQnWJ2R/AOcxDA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS7PR12MB9550.namprd12.prod.outlook.com (2603:10b6:8:24e::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9913.11; Tue, 19 May 2026 00:59:35 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Tue, 19 May 2026
 00:59:35 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 Luiz Capitulino <luizcap@redhat.com>, Donet Tom <donettom@linux.ibm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Liam Howlett <liam@infradead.org>,
 Mark Brown <broonie@kernel.org>, Peter Xu <peterx@redhat.com>,
 Li Wang <li.wang@linux.dev>, Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [PATCH v6 00/14] Remove CONFIG_READ_ONLY_THP_FOR_FS and enable
 file THP for writable files
Date: Tue, 19 May 2026 08:59:15 +0800
X-Mailer: MailMate (2.0r6292)
Message-ID: <796371B3-27A8-4600-A9D3-F519092B63D6@nvidia.com>
In-Reply-To: <20260518174543.eb80758a66e87631b3a4dd14@linux-foundation.org>
References: <20260517135416.1434539-1-ziy@nvidia.com>
 <20260518152116.840e926e9992d47c9b3e33c3@linux-foundation.org>
 <0FB04D3E-489A-4ABF-BD04-EE735EAD6F25@nvidia.com>
 <20260518174543.eb80758a66e87631b3a4dd14@linux-foundation.org>
Content-Type: text/plain; markup=markdown
X-ClientProxiedBy: DM6PR17CA0034.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::47) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS7PR12MB9550:EE_
X-MS-Office365-Filtering-Correlation-Id: dfa6d4c1-9c45-44e8-1685-08deb541e4da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|10070799003|4143699003|56012099003|11063799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	IFiDoMpBhlXJ6a8ctbQGur6w4aCyolsLY1PFXy/AgzsHKITHLaO45BYgg88gwFT7lOTkE93NrefWsjccuHHmDj4PvFkW4PQG5PIzSsFNbFFzA6ufMr/CEs96vRI6/N0xAHQ6AizvIuO9yOggil6/aT8myc6dzf8WbZ55TE5utPq7UlEgL//hNENGWni0pandYz7KwWoEmVAapgbh5WBfjtHDRkOrRpSYF9Dte0gi9f2Oc4KsygtsZHKP2+YNqwBjiBGCLr9arWPDzoJIYmZBD0j8Pw0MwKKkE3mjz0VazObXf2DBW4SZdZC8uzXmbHcs8Pa3n/FKPTPNPYHZas0l9tXOwpPdkdFApeXo8lRSGAQButKUC2JZQNBsvgrY+yOybf3lVYn4Ljw2r1kGfuRItiqjpQCrwa/Gzw2/f5l0hNvcBA4GI7hLYFGClUHuDvOSUJMTotv5D8tse2djaUVdnQE15mHLJRwMsRfObggSMsoBikHlvIW/B2KdaiQfK/owdO2UzWdRDtMbHlj1nCTxe2r6TxwHtVJqngJGfmXS5Rg6GdyYY3VG1grsf61bpHohhjLrUwVY2XcC8eK7QEQsl+sc2y26Fforz19p1ZSd6RmhvmGLYcmjDJoN0dH1E5B1ImzGolkDghYa6hjNDEJAwXY5/c+N/BFLRoJawIHgM6iNdtsECzM1hUetjJUy2vHc
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(10070799003)(4143699003)(56012099003)(11063799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kbqeOWrGyWT+kMcs59NE0tZQBiY1KAElyrnGZo4YKX8+FRDis5YW0mODySKV?=
 =?us-ascii?Q?/8Kre363y4VLia+uQ651MjWfEeU64V278hwJVrUEAS6SKGO4naozHBl0bEFO?=
 =?us-ascii?Q?RFYex/CjOVJVUGKIzA8/ZQETVDdDzh+glc8W0DHZbNbVMj7pDUUlEa8rt6I9?=
 =?us-ascii?Q?/nk4tq9uZeWi1TzfiskGf8QipTILFCP2EPzRSrCMvahUiyHNFOLjV9FEHZtG?=
 =?us-ascii?Q?W/FxI4fFVE6lfIfU0Hc+Zg5vOR9OuZz4kL/9zdu8Ve0iBNBk+O/i0cAnyOgT?=
 =?us-ascii?Q?ay75cczGsy4uZbWYKsSujBROhFnRyRyK8hIfzlu+YckLGu180FT2czrGcGht?=
 =?us-ascii?Q?744DsPTP0zVEV8TteynyVXVIHmDGxbfdlta/SrdMU1yfe0OX7eKzvbSe3FgD?=
 =?us-ascii?Q?X5flpi102qClc9Kp2ZznKqlaNnJUgr8kfhrwsZem+Se88uJBJhxaovGMfVyw?=
 =?us-ascii?Q?0RCQlXtaTfx6hCQMt/57/YZ2vRuQr/wxzmkCnMJdNtvrJBaz7lxZLT020tX6?=
 =?us-ascii?Q?DHu2RJnhAtx9qy6CnhF1JiWE8eOI8DCGnzPgFhOFPJMMQYUwULLnyBEFflD+?=
 =?us-ascii?Q?aYzUAtfEN21xqp3JT10SCAMfElXIjgIfI2PbmgMJ0wavAF3AJR6YxW3NpneC?=
 =?us-ascii?Q?2NPpjIZawK5hEBSDSzd+N8xXtosrDPjE0ETNOBKM2rCNovR3ZogwngCRYpjw?=
 =?us-ascii?Q?4qwL9TVYbg7/e6l5y8rvoa7G3lZvMURGPYLC14xD4VjQf6y+zLYK2uCAOo3K?=
 =?us-ascii?Q?yTtAOGF1pmQe7/PgqIJgApQzYpDTCSszjZlnyv004SOolyAf7s6QQ2uOsmbt?=
 =?us-ascii?Q?edc3n7aN6A1Og38WG3IIjZ7nR7jT4MFDTJBAwZjDnFvK9iOqGTZJ9x38ZLJA?=
 =?us-ascii?Q?u5Lcth9X217F5SutGhppqUaDpJSHmO7VpvNbodD98SE1zcBQ2r79gCAO+1+w?=
 =?us-ascii?Q?xas5GU8Kz8GT0z9f4gd9p2hTBKMi1nG4jthhy4ereTWGX/e3QuRJl45OLDfp?=
 =?us-ascii?Q?iR1uMIE+TFSoPKmprfgT3y6U7CTSwJxCS225d8rxLZJ2mOwuDB21ow/FP4fX?=
 =?us-ascii?Q?+Zttc1lx9VD0txR4zyRpPpI9dCIyerIkmxxZk9J9S2oMZRlrh5pMK4gWJzI4?=
 =?us-ascii?Q?pmobHAhXfZ+ThEMQWkStMPZD6vRjn4OfVV2Z8/WBCEkMItfk5TlkqzsBTg/b?=
 =?us-ascii?Q?pMYN9Phv0dpSY8HhkI3bpzb0FEQxIVFSl8Bh3qnbzqZAeRsGLvYCAGQufoAS?=
 =?us-ascii?Q?fXDCgjJtG43FlL4/QAA2xxCdrzg/GtwsJdWQ3tZgRFTe8zQLG/9gLSlVQRk/?=
 =?us-ascii?Q?3qmMSwM5654QT7uNNwtTiRT6a0P+RJpB9Tywohe+iG9MLNlk8t4MlpgO3wDK?=
 =?us-ascii?Q?4WQLoWwNRs0Jrq8Mw6vfcdt+EN4a1ljI1yLWBtSKycE9/SKDilOON+NZSlAI?=
 =?us-ascii?Q?oVpXDab3kM6o4p6B6Cfq6biAl2ZoVYBzA/qq+aUVGk42QRrn5APZjS/jIhQb?=
 =?us-ascii?Q?QI0WP7ua9Vp0JOjH/ZYaI+/3OsfT6YUpoi1GtT/NK05sQ7pJQ4J2bpWb7jmZ?=
 =?us-ascii?Q?wW6nX60h2NGtHuzCryWtoT8E8oJf+c8h80vVR3WzcutKDm6eEriAps5JtqsN?=
 =?us-ascii?Q?yZ3IO3j6j3GMBP2vDJ+n+1IMcglIQG6GuAgVJMoFyWAcDX1ahUw9JHIha/g4?=
 =?us-ascii?Q?9fJzTQvo1utuhxmP/WU42s5rR57a5HjOaWKcwxE7TqkE3uA6xS9wp7s19jjo?=
 =?us-ascii?Q?1TIj2dtuIGL8vKjVQcmGR7nF2WVZ2PuzrZzRQfVLw14kIoqmiDLP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfa6d4c1-9c45-44e8-1685-08deb541e4da
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2026 00:59:35.1691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HQpE2PXbt841wCwVdMvRSxQJao1O3LzlnurNvK8GG2S1wuTJFUY3TocSXyYp/OGW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9550

On 19 May 2026, at 8:45, Andrew Morton wrote:

> On Tue, 19 May 2026 07:39:07 +0800 Zi Yan <ziy@nvidia.com> wrote:
>
>> On 19 May 2026, at 6:21, Andrew Morton wrote:
>>
>>> On Sun, 17 May 2026 09:54:02 -0400 Zi Yan <ziy@nvidia.com> wrote:
>>>
>>>> Hi all,
>>>>
>>>> This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creating
>>>> file-backed THPs for FSes with large folio support (the supported orders
>>>> need to include PMD_ORDER) by default, including for writable files.
>>>
>>> Cool.  Sashiko wasn't able to apply this (presumably because of Mike's
>>> CI-friendly series).  I take it that the AI review from v5
>>> (https://sashiko.dev/#/patchset/20260429152924.727124-1-ziy@nvidia.com)
>>> was considered?
>>>
>>> Also, please check that the below were considered:
>>>
>>> https://lore.kernel.org/e9e61132-902a-445f-9c4c-4d405d164e70@kernel.org
>>> https://lore.kernel.org/22831162-abe7-4498-9e81-7f5aa3526d00@kernel.org
>>> https://lore.kernel.org/959238dd-2493-4d9c-ac35-6d04460a8239@kernel.org
>>> https://lore.kernel.org/1895A67C-BB1F-49EA-ADC3-AA4F51A6ED57@nvidia.com
>>>
>>> https://lore.kernel.org/20260508074643.55548-1-lance.yang@linux.dev
>>> https://lore.kernel.org/b8a3c3eb-f241-40fe-9121-4ae5a1097807@kernel.org
>>>
>>
>> I addressed all of them, except the second one and I will reply to the
>> second one soon.
>
> Great.
>
>>>
>>>> is an in-place replacement of V5 in mm-new. It affects Mike Rapoport's
>>>> "make MM selftests more CI friendly", since "selftests/mm: khugepaged:
>>>> use kselftest framework" needs to be updated. I updated it and put it at
>>>> the end of this cover letter.
>>>
>>> Helpful, thanks.  It was a little complicated because your email client
>>> messes with whitespace (it always has!), but I figured it out.
>>
>> You mean tabs become whitespace? And does all my patches have the whitespace
>> issue or the one I put at the bottom? I am trying to figure out the issue.
>> BTW, All patches are sent via git send-email using mstmp and
>> I copied the bottom one from git format-patch. I wonder which part went
>> wrong.
>
> Your regular patches are OK - but when you informally paste a patch
> into the message body the tabs turn into whitespace.

I did that before, since I was copying diffs directly from a GUI terminal
that converts tabs to whitespaces. Since you mentioned it last time,
I always do git format-patch and copy the content from the patch file
and it should work.

For the patch I pasted in this cover letter, I copied it from the patch
file directly using neovim, but somehow tabs from surrounding code are
converted to whitespaces (tabs from +/- are not). I noticed it when I
checked my original cover letter just now. So my email client does not
cause the issue. Anyway, I will be more careful next time. Sorry for
the trouble.

>
> You aren't the only one ;)   I usually don't comment...

Thank you for reminding me of the issue.

Best Regards,
Yan, Zi
