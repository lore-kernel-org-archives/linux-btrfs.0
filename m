Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011008.outbound.protection.outlook.com [40.93.194.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC90D3DA7F7;
	Fri, 10 Apr 2026 15:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775834320; cv=fail; b=ZS/S0rChRpG4ar5nojQ8YOTDdBweFIl4R60OKJzb0oTLYAWF2609eU1sHoAqmJjLb7tFVpOLj49LTNH9nMyRqTn8EgGsY1WkMEMlHqezohqJu0WdE8t1peVMBq/W6bJjXyhErHKg362EjvUaCvllmDbXq77DC/okydrvkxdgBWA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775834320; c=relaxed/simple;
	bh=W96iObaU8ZHISoRxY5MArMOrG7b3TH/6ACemk4v4yOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gwZxY+bWpa87mdsr3f+DLqXeRCouj6EMIAQwWV4MvLoec47NfoHtiYp2y9JafhnIwF9nwxd7mFJETgicbONLl2a0GdZOaSnd3vnipnSdCOtOXX6rQCbhUkFbbuyODlOiyOC86ER88J2MbmrnfEaIqE3kkyF5kUJrM/X4DcJi6QY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CS+AR1nW; arc=fail smtp.client-ip=40.93.194.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CS+AR1nW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ryhuj1KC9KoWpO4jl5TfuWN3ViLT0qT0j/uyRpfaVpgT4x/5piOM4gNrIV3Fs/PLoCD7anBEMdjOYPZqDNgyqFeQAjtJtVzcb80lJTXBsilAi5dlwdUUNVjbMmUqybw2PBjN7uGt6SUKixqYPGjRsLP65OwQYLPwv3UzRJ5f5As0MT097/aYJMerQTgMJlyYntS31OFnh37TIt7Ou/W2HdUO+kEC0MXHsLfu4UtSwAenwk5SjRvQqVcYbKbPHKaT+Yzub5jeEsgHQrk9Y4XxLpvZm/UVnrNG3/U4WtA4X1DsbMrh1YQszEaGU4dohLxzDUdt1nU1SXw4kaabu2I2Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W96iObaU8ZHISoRxY5MArMOrG7b3TH/6ACemk4v4yOY=;
 b=IdQxQlvO0uDWOW+GllZJY5LKu4X83sQA8ovVXA0LAqOhLCYFGCyqlb632aRhc7AAeVuNf1zEi8igm6il15dklXghnEk7a9R1QJzYLi0oQS6Dh7fbKaxMgLiz7MZCV1vitLcplzk9vIXnHuwj1us99GtillhYvOnwDL3AP5h5jRkW40E8C/hrBOjYRZ8Gd68XJvMbaZspEPeZZuNcMmFDt/Y1Y/WrJY+I5zJ8ngm1z6K1jyAYPjdQmE/hrCUX4UvbDhptefLq2jCl62ZjSann2iak44J4nBMIPLT7sMF73GD2780CDKG4FpQ2oz7ra1uWEXFlpG2Q8mh7q886FQGUGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W96iObaU8ZHISoRxY5MArMOrG7b3TH/6ACemk4v4yOY=;
 b=CS+AR1nW60NKKYvxAklyZtFyGUhW6IkiCise4X49w//R5Lm2FNcHdg8+XoRE3AGTFuqXSsTtvjWpmk7KccZi2PCVO3SpOr//55OxDx3tQV2F74zh4gk16YLM/aglQE78l21AI3MrzmPuGAXaLXnbBlglxZQ3SmAuMOYWh/ZqCSDzXByN7WaL2ot3LaEt9p8swHWtEviIk/2hVFOH3Uhu5AQAWlhyrpvDUOvecFRU73dWVn6AguSb+w4Naf/IP5h676oQU1XoAFaPUxmn3M9AE08c0RxVlANacDCaw6PFvv4jWBrBWHaTL8vJA9jgR6f5LUyCURNTs8km0U/WfqwBwg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB5868.namprd12.prod.outlook.com (2603:10b6:8:67::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9791.34; Fri, 10 Apr 2026 15:18:31 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.041; Fri, 10 Apr 2026
 15:18:29 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andres Freund <andres@anarazel.de>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
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
Subject: Re: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS from
 file_thp_enabled()
Date: Fri, 10 Apr 2026 11:18:24 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <F4DE9305-8D16-4DD5-B988-FBF5C8BB7B57@nvidia.com>
In-Reply-To: <s2dr4cedsmqby6e3ijauv5p55vrde7c4ldyk5gxdw5iku66rbc@x3nipjpgqjh2>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-6-ziy@nvidia.com>
 <s2dr4cedsmqby6e3ijauv5p55vrde7c4ldyk5gxdw5iku66rbc@x3nipjpgqjh2>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:208:23a::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB5868:EE_
X-MS-Office365-Filtering-Correlation-Id: be8c2c48-f030-4886-0553-08de97146b37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	GAsb1THpkqvYpAJEvKdjYSbhlJ2xkvYBu3IvC/RXG5lGPzxioWt6/Iw86DdTUAdeb2CO1BBYs2BmQg0CHe4uudzc/gVREf0h9+ggLuAlbm5axbGJOlDpEmhfl70P8yKImYIkiQclNr0D65uS80qct8uNDm+2VzbbIBKlkod1wXosXau49e2GaQlZh1KvulBl5aKXrwkBVI5vQxDzGl9adT2qIkVQOvyyskyQPATbTh5ObmAB3olPkAA7QKnh2OZoXpKZW+acirw/k6cwZpO8v69PKoKiLeOLsqU9swsJ9cDMSBozoxog6H17f+rtj1hqk0a/VNXXr6juNRzrwPBn3jpD+88HQN9boFe1UrxiPYxQT/eVdJlFhwExdPYhPJ9nTP/S2PRCi2zXdyDnJBlVFCkZH143RtJRHh31EQSB/XI0b7DwU16kEI/izCyTG4qjBbbzC270POBcsnbzSFG42hWS1Rd8L08fsjMLYNJeDGQNYsUu0Q9fIwo3QPwMrBPtdRmQjrsu/00228MHmQAV56KQi6dF+MNlpDNIzhJAlG7mHTApranwZ5buS2hJP9eBXBMTKquNkal2ZEM7o41j93VAzOyV6XT5DmsKRG0yx2mnxg8lXJMdce4N0m4VlrTUPzE7hIo7OzdrhL/ilRGk7aquii0FeRksMYb6BJMZGygOSyEfgShTPeWxzPnR1f3ONrTNfWk4aQF4ivpZBYtT3AK9VMh+LyD1+f6cHVGQvGk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Vq/XAecwvZ4mFVG3eAebuZs1rOdUwPcPzvKJTaqtS+mldN4seMPZKVTfka7+?=
 =?us-ascii?Q?FcGu5+dmWEeg3S1xgN2S9CH8Ye5VQ+zr9ZPK/lJYD5WClwjfQ2SiPPlGqGPA?=
 =?us-ascii?Q?Jx5wrSNH4T8oZ/+Y6GACQ2U0UI3EFwO7cHAeOH74lozyQt+fnrlI+uhiO1Ap?=
 =?us-ascii?Q?UsyQAMM67CdLqjKeGHMI11OAgDEo5lZ/3bVCVLumCA+D95i9nm2bfaEh0Ijr?=
 =?us-ascii?Q?U5uIr/1xkOrS6r7NxF/YuzQOHrCnBC6OOACEZohRQ69EgukPXsghSgB1lO8m?=
 =?us-ascii?Q?hDZqhGks2ZGsn1wAUPKnpkT5KMEuBbg8iTPvclBiwjbrVqec6didc9nDkVGL?=
 =?us-ascii?Q?gshVwx7TAyocNbEfoVXoFG8VQo9X/pOftdxNRr3oyg356USMHQwUmruTB070?=
 =?us-ascii?Q?j5fp1O2qdIXgfd2vngQg3rDPRDhrG4/O/PhckvMv1E8a2sFVsLwCUEywKTIi?=
 =?us-ascii?Q?nGfG5nT137LfLkXP5xWd8yldILgnytmnBPqz2MUlSLPK4VIldish2JtTLZ6n?=
 =?us-ascii?Q?mraKWHk0+aeUP59L6nSJCrIizvLTLRXcs5uFMVxrpyW0hm41Gko7rT7exrGk?=
 =?us-ascii?Q?y6TUT5RH6qg45jlAl9klLbXt33tpmjmfK6PC59J8XLEuG2bPviI8wBe0nHx+?=
 =?us-ascii?Q?LpEkxiZ9v1kt5aAPY8hPfqZ2K2fxPTS3BnUrnUK3bQKqh53Z05HSdVyjByGS?=
 =?us-ascii?Q?d52Cjbs6URYZcrcZO9ysmrY9jpSPLXdUIqUAesvXTarsvR94oBN0/YvRSiRg?=
 =?us-ascii?Q?oJP9SG5zML9DAiByWBjUGYN2jSgWgtNLsTCnCFizt61lWdYdz9DcEnI/5kpY?=
 =?us-ascii?Q?vMpFPrSRwxrzM/9GBxLI+4VWH1MLB7LJ6didGSz7Xfd+hqZdLu97Busik56J?=
 =?us-ascii?Q?8nel/wwvBgsqFZqbySMJU8y+V950qFSISGOcUB9QPhUqXEEzXmDmJf6Mnc7T?=
 =?us-ascii?Q?DzOiDrY0JDs8rDwM7+NiaGNPhH2szdu0/513vBQIh4+9B39agd9XCY4obYcV?=
 =?us-ascii?Q?aGg+9B314o0Y2I6usReOX6U3fL91JCFR7K0mjaQoPBBxpUmg/rkMlg3PV8oi?=
 =?us-ascii?Q?+1Ha1FNyXErLQS2oy+YfgPKnEaudYCD365A2bRa5skgmP92QfNpX/oZG4CVF?=
 =?us-ascii?Q?ERJ3/+DNAwWIHqw0Etb7pizFuAQIkEJ44u+KYpa6vTUM3/IxRUYS5ELqjs2n?=
 =?us-ascii?Q?YMGqXn9rHxFIc/yrLHaXq5CZENyDTHcn0tinEW5RyZJT28nF5ZJ2EaMdQdqT?=
 =?us-ascii?Q?zggL1YSQxBOA57/qv79dJ5IZyDYHS/R/yq4iTPVK1Ex8PgPF8LSHpahmMXbr?=
 =?us-ascii?Q?emQCbi3VaBRuJ4tThtG0p/o6NTcfENUfCCTT4Ci8dMnZEzynlVLF0XEBSz75?=
 =?us-ascii?Q?gMI3fR4ZZEg0XZEICbk23fSiMeBNKIOyiIpQStLlAtfNZOkRmo3jKTz8vUGF?=
 =?us-ascii?Q?DQQWcNq9oR6FA0vIiybrE9cKbQP4v7aHymtSAhbuElo76S181kFpG52cRmJG?=
 =?us-ascii?Q?V05dJ00aW0tGGkrXt0dP7ZVHHALcyFJDrEb8x24c6Iwmo2hHI0nXIkW5+BCA?=
 =?us-ascii?Q?bFXa6/qvcgpmu3P02XpX/7ZJSc8Oee9Mq+pdoP0W53xOwwIPbUcgQiyz4+2p?=
 =?us-ascii?Q?MIoWGfWIZ5Z1tbvE1fgcYcbFmQd1Ur+LpC/RjnKlxZu+B1X40nWemJX946jt?=
 =?us-ascii?Q?OLH24Je/Zz3U1ce/umxsDvkpJ8UXioJj98NpKnQk6is+VeEM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be8c2c48-f030-4886-0553-08de97146b37
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2026 15:18:28.9409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EVslQhxvUhOBO03QJ6yCv8XFXxyl/TM3S6MpPcoR1RpI2k3xDpsDM7VgQmeYFrO6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5868

On 10 Apr 2026, at 11:06, Andres Freund wrote:

> Hi,
>
> On 2026-03-26 21:42:50 -0400, Zi Yan wrote:
>> Replace it with a check on the max folio order of the file's address space
>> mapping, making sure PMD_ORDER is supported.
>
> Question from a user space developer (who learned of this via LWN [1]):
>
> Right now MADV_COlLAPSE on file mappings appears to only only work with
> CONFIG_READ_ONLY_THP_FOR_FS.
>
> That's pretty sad, because I see quite consistent gains (~15%) from doing
> madvise(MADV_COLLAPSE) on e.g. postgres' .text - but because
> CONFIG_READ_ONLY_THP_FOR_FS is not enabled default (or at least not commonly,
> I think?) in distro kernels, it never quite seemed worth the fiddliness.
>
>
> Do I understand correctly that by replacing the check here (and the
> predecessor commits), madvise(MADV_COLLAPSE) on file mappings might actually
> start working in more situations on typical distro kernels?

Yes, assuming your file system supports PMD THPs.

Based on[1], ext4 and xfs have the support, btrfs supports large folio but
not up to PMD order. I have not checked other FSes supporting large folio[2].

[1] https://lore.kernel.org/all/20260330160942.173324-1-r@hev.cc/
[2] https://lore.kernel.org/all/aTJg9vOijOGVTnVt@casper.infradead.org/



Best Regards,
Yan, Zi
