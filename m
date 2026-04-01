Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010071.outbound.protection.outlook.com [52.101.61.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFCF35A39D;
	Wed,  1 Apr 2026 15:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775057543; cv=fail; b=YFKx6Bf+jO2iYa9Nk6gzy2nOwJLioozBG7qyl/6SkhYjYzMJ8cBE4ph+7cMN8kqSMXIwTT+h+Nx8jcA0O5uJ6XtKbNbgDX/eNyagHmWSGlkn7BqrZSFE1Xi1L+C7FSYgHCZbPHkLNa+gFBHKzU6pUXXhPFMcE9VGivaWN6Tjiuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775057543; c=relaxed/simple;
	bh=IQDvTdXPj1LTbQAFe40woWyN+4S2tzES6BbvEgr/nTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RQdq4xAgIMWAFEBBOFq1HLMVfrMblZZJDIMZkSO5k0iDIhZI0WA/FimtmjFll0p5IkTmbj1uH79792qdgD11LPLd0MNYnirE/Y3VIML2GPLJBZ1xNqesVRpvF83OwoK82ki+Tlbi5Wsyll9MN+sK6M8c9sCvc6QOtbMQHj0c6m4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lG9E7S0b; arc=fail smtp.client-ip=52.101.61.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lG9E7S0b"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oiQyZOJleb8JjGgE7li4jCoogOAI56n7xJmD2EYSLoP6GG6n9rECFvTmHqLd608UsgorPSoW1+rGeKes4i0gQbQGBiZq4p6jUfNvX2/ym0Rrt7B224lsH6OIjaW2GmoB3CQQ7Gx3ofrc+S8QPC8t5L3OKN5/nwBhaXIngggaCSxUTKebfvQHvM70LKf/mzwACFH2kRKHkj0wZz/T9lDx6Mm8BMEf8g/TEwUkwbVaCEumvmJh2EIwwk0FPNmZUBAYqdPTjPHYSI73YrHJWbAEKYIsVB8lD6j0OemhK+R1wrK6ZxLNnDGFzhCQMIWjaSz2AZJMf3j+BdqUU6hBFipLNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tbbB8/9vDn3uyF0HnboXEhS5ovj92evN/4kyReRT2jk=;
 b=dyCo5Tb0eD8HM5+eVgChUy0Z0JGoPagTfvNH2ApF7XwcRo3AhfAjVh4WfTCLyXExTEgZsQyssmbgD9dm9BgmPKWVhZ5G7seXgL0ieucU5t1qtkrvjLYf3N4mXz41a6/HKNRQAaK05661yyUzBJaQPaoYF2snOCsQG1VNFtcsidXP2uDl/wzSvTB2oXn7Im0mNbsa9SXg4DGrJOEisMdKjLq/YnCS50wKENjxQIRhaKxldrAhoR6iiaBwWhoJS1bn1+/S2CrTLkLqQHxzmKJcQwnyatoHU+pSuWxu0bwAJlYga09b4ha3DS4g+1VEln/fjAHpTYStJ29wXj1CnHBZKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tbbB8/9vDn3uyF0HnboXEhS5ovj92evN/4kyReRT2jk=;
 b=lG9E7S0bEGWKtx2P30ob/ZpLU9dZFhygDVRmf5UQN9FRTgEXczGPR6NtQcfP5axaUlMPEJGFoxgIMCIhLHLAWuwRyzQZmkuFYBkCpxC28awmNu0I1PuMd8AJ+uTRvFnzLqM6Uyyp8zJgo3q3PfFgLkaR8+BAschjIqIPtmkhnxLfAwlSZJ6A462fLzwIMtwbH35MuhBdbpoV9MdU5XhvrdXh3RnYt6yeyDnB3VmiSC+qSI9+0cvhGcpthC5GyKiMtzXr8zNY9a7C/uLLUbT9bDLZxYn7ffFeImrRz1L03EJnkQnhgmkLjd1UCLrZ7/lELtdBOGJRaOmCxZNQ4AbmJg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB5963.namprd12.prod.outlook.com (2603:10b6:8:6a::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17; Wed, 1 Apr 2026 15:32:15 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Wed, 1 Apr 2026
 15:32:15 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 03/10] mm: fs: remove filemap_nr_thps*() functions and
 their users
Date: Wed, 01 Apr 2026 11:32:11 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <EF04F17A-89ED-40EB-BA91-7A82713E28F8@nvidia.com>
In-Reply-To: <cd36fe49-56b6-4ec6-8dc7-9c793f939bb5@kernel.org>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-4-ziy@nvidia.com>
 <aaea8ce1-eac6-49d6-8c85-7361977b9a9f@lucifer.local>
 <b098fce7-be16-479e-b9a4-36f0ad71d242@kernel.org>
 <53cf6157-58b1-4539-a276-2486e8796c57@lucifer.local>
 <25899F67-955D-44DC-935E-D7F234BD335A@nvidia.com>
 <cd36fe49-56b6-4ec6-8dc7-9c793f939bb5@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR20CA0053.namprd20.prod.outlook.com
 (2603:10b6:208:235::22) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB5963:EE_
X-MS-Office365-Filtering-Correlation-Id: ee536858-5e5f-4e49-7aae-08de9003da29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	9G67T7LLzb0Nl06OeIQqWDx+y02mdCpY+AFD3Mrt4xNN1PdkggZKQycURKBYid0/kBiAk8YBHPJZl1ROa/g+6glaYT1643RmmK67ZK2RJzjWYPzRqSweLOjcQngXb+dxr9FT9GGMSkDr+l6Py9ucMv64+DQXbwPVwDUH/qlR/Rkj+18qZfSFvBgdM3MopiNYMcQTtyNW5SkdKJKJ7i5UNEOMAy9YzsDDcCMmVR2+W9m59fthJ98HEbzs8gFQzCHQ/IfLQBT5J+mlBD3PKKg5eCy39TfY+x2jgkZxnyBneyuBr9+ATr49FjbrNF2rfNL55ujQRPWa4r1b81AYMOuMwhIZ2kP6eMIrc5pkjvrWJlNh10yR3z17nV8diMBvvSvpEEpCIPtTQBnrx4U7ACi5pSu0QgrU+bLP2RW7EGdW6GKUwPzoWBn2uG3cvSTyw+9kpGHtbesMY0BpCp9tX/wjrOpRZf8nw1wUWlFgmVvjDyA2UfHiUvtl7fQq0MnsC1DvDtahmO+sz/pLNgxK4ffjp0khstiUEDNf567Ha6mkXWr5FkW7H0ZsXb0dsjjJ+2kOdDWnx1qk1Yr4XaMlFJQrrK/fLvy7OCO7f2FKUZEnSyFK2mYOat68HMD1xyY/vv9vzCIX8oVK74crplhnGNaeRLJrfP4rGkjATusxgCRQlkn/IgZ+2H5SM2aNBTrecx1Togx330I4x4WYMGZs2swvnA6OKPQVEnMEYeUmqr0c06k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eUVlRDZMa2J0VG5QN3JQeHdiSGw5QytRamhiVWlFOFI2a2tyd3cyTThWQTFm?=
 =?utf-8?B?b21qUkJUaURXcEM3V1JHY3RRa3JwaDI4WFlJQmwzZEpwTjJRUmZJMXdDM1kv?=
 =?utf-8?B?Z0MvZGl5K29oVWtoRXdYL1ZCTXVYMVVrYWUzS3RzYXZoTjJYRFV1L1hjU3Rt?=
 =?utf-8?B?cTMxKzFUUFMwM2FNbEVHQ2lXeGk5SWZkQ0dKeFRZakFjcjFPaTNZL095Q2xq?=
 =?utf-8?B?eS9pU1dhcHQ3cEpBZ29wK2RHWjBCMm40b2pZczBIU255U2lwYUV1REhrTEJD?=
 =?utf-8?B?UGR5U0dybm9MMkRhRlEwZ1gwb3M4S3BqNTdkWTlqbGVYQXp2QUZmU2E0cGVD?=
 =?utf-8?B?VjF0ZlQ0dVZlK3IzWnlFQlNxWGZUYWt0UnVFV3lCYURpbkQxY2tLSjk0dHIx?=
 =?utf-8?B?Y1R1cmZrLytrUkZ0eDVrN0ZjaXN6aVhuTENvYWRuT0Yvb2t0c2M0YnVuN0Rh?=
 =?utf-8?B?eFZ3ZXY1L2hqUVU1Z1BhWDV5TitrV0Q1VldiVU5SQjJrNkEzMXBickhLOC81?=
 =?utf-8?B?elREbzY2WFpwaVpTQUNmZjlrajJEOFlXQnFHWTFPdXVxREVzRTBxODJ6dHJo?=
 =?utf-8?B?K0NYeHRMTUFHSVhKc2JVcXVBT2E1NXZVOXdHUUFoTVorNWplOTVEZHRzRjNK?=
 =?utf-8?B?dWRvdTBtTS9wVDBjNmdxTllDNjZLUXJ0UlROMFZlb3V5Um1vV1VUT1pwcmdp?=
 =?utf-8?B?dEcvbUo0Q0NiQ3JRdTJ6WVhraEpNWitsanpFcUU1TnVaeDQ2SzN1cWp4d1p1?=
 =?utf-8?B?VzByc3dnVTZEY1V1UTVuYXlJTHNscDIwVnpSZHhyVW9zRGhua2tSemd2TzFz?=
 =?utf-8?B?WUhuWXIrMVpMTVZsRFZoTVhlRUZhU1NrNGR6b1ZlSE9kQnh2dEdVZUpuaGhi?=
 =?utf-8?B?cSt2YzFFUkhVOGxMR3JWMHR0eHNwNXhUVXR3TnR3SXhEWEFtcjRjNjRwbjhF?=
 =?utf-8?B?dG1RaWhJVndGS254b25rLzFnWVdKS2RIK0xGc1pLWEZLOWd0VENadTVZRTV1?=
 =?utf-8?B?Q3lzVnkwNVBxYmNDU0hDb3VJWTBSMzhZeW9lV0lCTldjak5HNGZKazBwbnRs?=
 =?utf-8?B?VVU2ckZXQ0VrTEozTXFWWSs1MHVYa0RsNzhrOUJsejlpV1FEQ21KY3ZpLytL?=
 =?utf-8?B?VFFHOVJhL2p0cXlOODNzWGZINU5OT3dhY0tiU0Rra2JCVzU0Z1pqUUpnWTdB?=
 =?utf-8?B?bUhMY0QrUmVSTnNtRGhJckRadUJpTE12MEdueUp5WHBzOWl4ZHp1QlhOcjdl?=
 =?utf-8?B?NWlkeG5yejZob3dQbzcvZUU5M0ZTN1FVRndrcjRpcjU0SkpDOHF3c3dDV3pJ?=
 =?utf-8?B?bklDNmllMEVOUkpwdFNHYzNPSjhyalJqZDVjS3N4V3M5M0puZUJ1TCt3cUNn?=
 =?utf-8?B?K0NFdzlwNTRuRTRwU0NnaW1NUENaUjFXbWI2NE1BcEV3aGFsWWRQMWd5dW5X?=
 =?utf-8?B?ajcvSWVxcXBEU2RQcXpETlV3ajcxK1ZNY01TcmhmZjk2RUoyRktTNW5VV0pX?=
 =?utf-8?B?emMrWDdZejdoVkhkenJnRGZkb3BHY0hEVXlIQzZISG9tWTRzUTdpdmZNdExM?=
 =?utf-8?B?OFZUM1ZvT1NpTGVpUlF4bmUrVy93RStaYmtMSG9GWHJuS0VxS01GdTVwQms4?=
 =?utf-8?B?SVJxa1hCM2ZIOHZ5OXBUUU0ydjREcGorV1NUUU4zZEdRNURvcjdoV2hlL2Rp?=
 =?utf-8?B?czI2V3ZzM2RKUVRNL2NITVg0T2xQKytJdlozTGhMSmxVZWtJWFlIOGpKZ2R5?=
 =?utf-8?B?L0t3UUFBbkx2TkgrclBCb0I2MlNZVUNONWthNEs3UHBJeU11Wm9vcVpDQ1R5?=
 =?utf-8?B?aTB2T2lMejZ1L2RVczl0NHFEbFBMLzI1VWV0QzVFTk5PTnZUUk1lUzNhUWV5?=
 =?utf-8?B?RjVkaitGN1BhcnI3Y3RmTHQ5OU1kRkJVeWkwT3RjU2ZwTGFzc0lPMDkwaHhw?=
 =?utf-8?B?MVFyRkVzem44Tmw0VWlvRExreitNVDcxd0wvTmZQY2Z5enZZaFpsVHFqZWcz?=
 =?utf-8?B?UTMrRXBCZWxDL0ZGcGNDcms4ZjFzVmV1blFvWUp0RSs3NHVVb2lqVHpqWGhp?=
 =?utf-8?B?N3FNeWdEMUVYMzdkeFJCTmJ5RzFHZGZQaEIrRUU2dWx0THc5enpxQjBWK3h5?=
 =?utf-8?B?bW5tS2Nid0RYNVl6WnZIUkVoN1ErMlUyY2srL0s5Q3Y3QVVvUmd4RGdYSmd6?=
 =?utf-8?B?TTVMWk9XSGxZaDlxQ1NVeGpBcmY5eTdBTXpDNkREUHYrbWx2cDcranNZZm1h?=
 =?utf-8?B?bm1Yc29kWkRqVzdHSUVvSURSTytjcEg0TU42UCtwTkVtRkhmZkNjYkhZUzBQ?=
 =?utf-8?Q?h9PrHjjPAxCwG9rWns?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee536858-5e5f-4e49-7aae-08de9003da29
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 15:32:15.4059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I11Y9nkypJV6MZoPFr/I9K+iy9/53jjKAYHvjem+24+HhmD7WQWKpd17bb/qAR9v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5963

On 1 Apr 2026, at 10:35, David Hildenbrand (Arm) wrote:

> On 3/27/26 16:05, Zi Yan wrote:
>> On 27 Mar 2026, at 10:23, Lorenzo Stoakes (Oracle) wrote:
>>
>>> On Fri, Mar 27, 2026 at 02:58:12PM +0100, David Hildenbrand (Arm) wrote:
>>>>
>>>> There could now be a race between collapsing and the file getting opened
>>>> r/w.
>>>>
>>>> Are we sure that all code can really deal with that?
>>>>
>>>> IOW, "they already had to handle it separately" -- is that true?
>>>> khugepaged would have never collapse in writable files, so I wonder if
>>>> all code paths are prepared for that.
>>>
>>> OK I guess I overlooked a part of this code... :) see below.
>>>
>>> This is fine and would be a no-op anyway
>>>
>>> -       if (f->f_mode & FMODE_WRITE) {
>>> -               /*
>>> -                * Depends on full fence from get_write_access() to synchronize
>>> -                * against collapse_file() regarding i_writecount and nr_thps
>>> -                * updates. Ensures subsequent insertion of THPs into the page
>>> -                * cache will fail.
>>> -                */
>>> -               if (filemap_nr_thps(inode->i_mapping)) {
>>>
>>> But this:
>>>
>>> -       if (!is_shmem) {
>>> -               filemap_nr_thps_inc(mapping);
>>> -               /*
>>> -                * Paired with the fence in do_dentry_open() -> get_write_access()
>>> -                * to ensure i_writecount is up to date and the update to nr_thps
>>> -                * is visible. Ensures the page cache will be truncated if the
>>> -                * file is opened writable.
>>> -                */
>>> -               smp_mb();
>>>
>>> We can drop barrier
>>>
>>> -               if (inode_is_open_for_write(mapping->host)) {
>>> -                       result = SCAN_FAIL;
>>>
>>> But this is a functional change!
>>>
>>> Yup missed this.
>>
>> But I added
>>
>> +	if (!is_shmem && inode_is_open_for_write(mapping->host))
>> +		result = SCAN_FAIL;
>>
>> That keeps the original bail out, right?
>
> Independent of that, are we sure that the possible race we allow is ok?

Let me think.

do_dentry_open() -> file_get_write_access() -> get_write_access() bumps
inode->i_writecount atomically and it turns inode_is_open_for_write()
to true. Then, do_dentry_open() also truncates all pages
if filemap_nr_thps() is not zero. This pairs with khugepaged’s first
filemap_nr_thps_inc() then inode_is_open_for_write() to prevent opening
a fd with write when there is a read-only THP.

After removing READ_ONLY_THP_FOR_FS, khugepaged only creates read-only THPs
on FSes with large folio support (to be precise THP support). If a fd
is opened for write before inode_is_open_for_write() check, khugepaged
will stop. It is fine. But if a fd is opened for write after
inode_is_open_for_write() check, khugepaged will try to collapse a read-only
THP and the fd can be written at the same time.

I notice that fd write requires locking the to-be-written folio first
(I see it from f_ops->write_iter() -> write_begin_get_folio() and assume
f_ops->write() has the same locking requirement) and khugepaged has already
locked the to-be-collapsed folio before inode_is_open_for_write(). So if the
fd is opened for write after inode_is_open_for_write() check, its write
will wait for khugepaged collapse and see a new THP. Since the FS
supports THP, writing to the new THP should be fine.

Let me know if my analysis above makes sense. If yes, I will add it
to the commit message and add a succinct comment about it before
inode_is_open_for_write().


Best Regards,
Yan, Zi
