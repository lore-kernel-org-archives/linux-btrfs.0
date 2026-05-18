Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011026.outbound.protection.outlook.com [40.107.208.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700AC33A711;
	Mon, 18 May 2026 23:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779147566; cv=fail; b=EgsYQWxXwhYhlLerQqZQMXjcIP8kdt8HOSOJ956dW1tfCIPS5dgqS8CHL8rJ/oqod16AUhBWGi0qmuPowvHU/DTEzok2pvHP8c2x8PZ0QZjocy0PCAJKLPKv6kSdQsmnAHZCPaUH8sfEQ9wDl7FeHjmvMauUyc4rtageT/amlsg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779147566; c=relaxed/simple;
	bh=be3FZsiJh4FzAQfxFTXec5Bc0pu7tldOKQYcjEWUp1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iCxPCoAOMeOcA1kOXxzj13hm2jsP70qcBSX4FWImpe0rKUzx6/LVScmp2+v3R1DrJoS7QprlmbYeor6Rr1n+vwHqx1VHV98HS94NeYQeHRxkJ2+2rwITw+7vyVXn4LpPmb864aeqsHq2pd7qy017PLMrjMpZ/y5XJCE6NwCYY88=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HpsfYeSd; arc=fail smtp.client-ip=40.107.208.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HpsfYeSd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bm48ASqs3VZM6rppdk+Ixrlgtjgs/rhMUJT34kd9WUSLVRz1vc3Iawmx1ryRmo/qXnvGtHnXrLFO3NgKf1NXt7OwjTLFqKUilVfKQOCCWf4p8DnSIAto7Kx9plvvwiTuHKMcweZTftT+5Pqo0f3IWoriVfsk1GrgJvQgfO00UiJDMRot9eXHMGGXNxSwswPPgEecwlSjPu0wYxJaSRTlurIVxdQ39c/pGjqZdeuC94KTSIFsa46C73eB0GHF2I7BS9dxy6y1R47rSka7koo2w1pGbYIVPKAoskz03khtvm1Azpc8my8/0OhivDpzqJ8ja8r3bfq7THQXR2H4+BeCig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xcDYbidjxfZoLKAtpPFGHME7l85m5uckjklA1ubzjLU=;
 b=SrMh6zqgG6lpPh/XoPDcWY25grRY0clfnwZAuFw45wSn8GVJi9A/LxSX/RO10aexJk2s9hKBWeyWArW25R79v2FADJyYRk9LpbJTCH3ck5vOEp5olViWYMg/yOI7iqEVjiC+DleldmR7g2BzJAwyOc1P2Auna2v1jnp1OmRGEt3JSvtDhBXS6YjzGGIr04940OH1EG6oCYFqTvDf1nlj9hauBVGYt0QNZ5zkOoWhLBUyNxD7C26QPOXjwkY2Si21HNRj/3nWWZfnF5q9HvWLU1ApovqAm0mHoUBKffvMXY7ywSpVr+CnSDXgmX72gqEIGQqOiNnepMbtQMH9snLwkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xcDYbidjxfZoLKAtpPFGHME7l85m5uckjklA1ubzjLU=;
 b=HpsfYeSdAk2W3AGr8OiyI40mVb8w88BQRIF/PTqF17HHoCSOSV6a/moLKXzZzofBr/XAL30nkLRvpIktoraoFwRdHuzOfp+zjpFVf60agni82vCYagSCuaGvpCw++SarNDw2Fh8XLkIquLC0DZTsb2H5IoJ+D6/xgZnxpNpb7DUUA/R1R9QgK1OKL1M8osO/GMsTDpsik5nyZnBu35Pz+BF0SHvO/G9j9D3xFcrJrCrrqmSDvCxmHPnOvbd7UR6ziY00nGzLrt29QiCIAt9KYyL/DT7fwox/NEUlp7Erepn2jw7+2Y9H9bssZad4szze696A1sc0YzDt8if1YnPBwA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN2PR12MB4176.namprd12.prod.outlook.com (2603:10b6:208:1d5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.24; Mon, 18 May
 2026 23:39:20 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Mon, 18 May 2026
 23:39:20 +0000
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
Date: Tue, 19 May 2026 07:39:07 +0800
X-Mailer: MailMate (2.0r6292)
Message-ID: <0FB04D3E-489A-4ABF-BD04-EE735EAD6F25@nvidia.com>
In-Reply-To: <20260518152116.840e926e9992d47c9b3e33c3@linux-foundation.org>
References: <20260517135416.1434539-1-ziy@nvidia.com>
 <20260518152116.840e926e9992d47c9b3e33c3@linux-foundation.org>
Content-Type: text/plain
X-ClientProxiedBy: CH5PR02CA0023.namprd02.prod.outlook.com
 (2603:10b6:610:1ed::24) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN2PR12MB4176:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c410183-02da-49f7-2b28-08deb536af39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|376014|7416014|1800799024|11063799003|4143699003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	so0hMwsRCzPp5cTRjwOdUPTOVn+zTJBIbPS9ow1zLb6Yk2ldVpsS7iM+oKSo2LdS56ti2FSM/YaktLz9DzHw+2TtYN9hEJ2onPEqN8B7Kg61/DbynU7mg0ScqYqx40QLcPCUVwG/7wEl475Qfl5ZqegaoVBxFWkPb2wnRaLa6sJkuoKoypI43+/hG0fPvHpp0yvpI+mxHeIO5X1dqFicglmXtS+igMGQakgPA7nNxQGUITZmhvOy2ebOglQB/s9FK3Cmj+ww7EtqwNH5UE5zKLGpskgjVkwoYdizUo8t/epdqDzLykYBG3zr3ASIJf5rRZXwZt39x38IuOBmk/Lh/7CQJcc1a2BWGVXP+g6qYCq8bI1Y6JZpgR+cAw5kKOrDT9gczsVDil7KijHGOz754Qq4iYjDn3U3eUIT4gPZoF2YBRejHkt54fN2X8PhNcip7eUlSKDLq35w2TMHFxMecqrQZ2k/8rumL7PMM/QCXWoQLhXibVRwHYbM2PZ5H4jWq+TZGiA0pPUaJ1xYlaSXL26Y+hBqX1DESD1M6H88iG5Vsiu/xo/HRiUjJqqSdv+QQmwXKuKtqPplHemq//ECnKEjslmeW0GysUwWR4yvif0ePvkpBemk8k4ndqvSSxPWUwWhXOTKOFBbcC1uNgZyPMurmNUnQ1I+OGxhhnPtxtCDrMhlQXUOH3kiSrPlIrxL
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(7416014)(1800799024)(11063799003)(4143699003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3E3hjtjmDEMWXxpD7eKstQPOkkmmedKJjsQjjjNAwhCsxdq91yTthOnoT6Gl?=
 =?us-ascii?Q?IKnCHrZDV0Z3htYpiWGNiA0JjCp0cphBIgQlj7VN3S555OBGzM2dnvlOwxWy?=
 =?us-ascii?Q?1R59GLWayAHon6Bmprj4vIAN0CtG/BZwJ6a3U9T4MSzgOYta42XjKGvXloTR?=
 =?us-ascii?Q?Mxq1E5u/w6fgLjsSNwlKxcvXrsGvtT2eFfXT+kCRZIJXEtNIb2Skom5Ldf3b?=
 =?us-ascii?Q?pAevtvWjojrS4t8NDi23eLXzuzQ4MRn3hzWF6On+Ij9H3zFiixmo3CgAm6oW?=
 =?us-ascii?Q?TKuUoscGKsoBrBRdV6ewdBQU7ms+2nd4HmVhQg0yNTCbti0aFpg3ZMuvm7cc?=
 =?us-ascii?Q?mmA9PDmwjrkn9mEZdQjtx28NcMq4w+PGPyPTZI4kjmLYh62lDK+N/fSdyCrO?=
 =?us-ascii?Q?0ofBviJc9y8Je87w7K/0O6/PGigRSiZrcBfg1yBgA1hqSY2CfNUqX1c0zC7w?=
 =?us-ascii?Q?tdTqyUhcz0EQ5ZXi0M8x6zgLMYvCMotzEVoRQmn6SdyjmJze2Ir5yRKmF8Mb?=
 =?us-ascii?Q?sehTP4xGyvofkP3ay/czNZRQGSBpep5OwKqYQOrpqIqcVn6dL3TYB9FF/Wx7?=
 =?us-ascii?Q?lMFQVEv5zpdXojz8442tPo3vULwsCXVt8IjpvGWsGOvapEQSaFWxQedmxNQz?=
 =?us-ascii?Q?6XOYJvThqwqz7Jj3dPI0DhgSJFnHWj6iHSL8hzfuPGan39iwm8KA/JKdrRRW?=
 =?us-ascii?Q?NUPMs9RghOpLm2L4xplphaOh08/rJZWKg/jTYwp5mt4WL9KHoM4cRKwvWxSg?=
 =?us-ascii?Q?Yy9JF0QU9glvqw6Dmnm7FZLYB89JN/y75Fb4jI0AZKZqbEtb6L8Vf5l27oil?=
 =?us-ascii?Q?UHhAZWQ0s2cJu29UmvQuqhuOEeA5bKjaEVyr49/rI/RI+3CsesRhtpv76PBd?=
 =?us-ascii?Q?om8BAzjDQxidgvgHPPZ+pkFEx+NhZCW/30vXDp4fgQTuEtaAfanqcRipcCM4?=
 =?us-ascii?Q?q5UWmyclBhmwAZvzr3DFpSv7tgchTXeZUYu/tMrlqgeJbpfPqBm1VfO3hEnI?=
 =?us-ascii?Q?72pOY6DbPINSFs2DbOG6sOTlgUDfpv5BUoCE0bhpsX8ZePljH9r+yJjUIES/?=
 =?us-ascii?Q?gUEqUfaIt1I/VuqFNiItPPwr1sGLG+aq6SVjyPf8l6wc2XcJcHWpLuuvAEse?=
 =?us-ascii?Q?ZGx0+D8M7jApRRGulsjs7hfoYQzO6xj8QfXin/hbLWYnRNMcO3jKTutXWV4f?=
 =?us-ascii?Q?M1Z5Q2fBq+HVOEp6bojoYyzxfKy8o4xZD/O7IHA9IkAtwIWCyhKcKZeg7xAg?=
 =?us-ascii?Q?DfXnTgL1MEnDowbdioS5OrtbTvHRpvMlMw5LGAoUatwhp2go1EfUfAwiPVu/?=
 =?us-ascii?Q?sFBlAfBt5pSO2TGxogD7vVj8OjwzcK6aWB4th9wUweNpAffKgjdsCx5Eje8x?=
 =?us-ascii?Q?66/gbThbysP75kQpU9fF2U+uGo4cawfQedSpXhXC+emRmrhOxjpXX6bTTLi+?=
 =?us-ascii?Q?UgQ6OYgFx0LsRnlHzfRcUXaSHjMaX/7oyDC1NCBkdx+LniQhIVF089njx12w?=
 =?us-ascii?Q?UUvMISqkbNCbyAISckfagWJboKzc1yNATJjge0q69nl/GMZuJlua9F9CGAbp?=
 =?us-ascii?Q?WcHTgWhNicmh96ATOmQooH88BPpQc9e25qFyQBTzRqtJ0gK2coCtojCda6U5?=
 =?us-ascii?Q?n8xVttSoh0bDSEs5zAJN6sZWgaonuTl+F1mMhkB2Oe3Qns7hQYKctV3s6CaC?=
 =?us-ascii?Q?JCCuxZIvuwqXOPCkTIAY9FkTgfVtAXnWsVpXqN3OwUZ+kzuiiQSk5Y0k9447?=
 =?us-ascii?Q?aq4Sd2hdqXiutpEvtskP8/CpyDqYq6hyXn6qbvbpAqpTpfuutjTV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c410183-02da-49f7-2b28-08deb536af39
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 23:39:20.6864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ge3TzgK5O6QkfQBLhMB+dD6P/VefKvLazDdLFUO6YRPcRaGn2ULswb1rj3nZpPHN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4176

On 19 May 2026, at 6:21, Andrew Morton wrote:

> On Sun, 17 May 2026 09:54:02 -0400 Zi Yan <ziy@nvidia.com> wrote:
>
>> Hi all,
>>
>> This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creating
>> file-backed THPs for FSes with large folio support (the supported orders
>> need to include PMD_ORDER) by default, including for writable files.
>
> Cool.  Sashiko wasn't able to apply this (presumably because of Mike's
> CI-friendly series).  I take it that the AI review from v5
> (https://sashiko.dev/#/patchset/20260429152924.727124-1-ziy@nvidia.com)
> was considered?
>
> Also, please check that the below were considered:
>
> https://lore.kernel.org/e9e61132-902a-445f-9c4c-4d405d164e70@kernel.org
> https://lore.kernel.org/22831162-abe7-4498-9e81-7f5aa3526d00@kernel.org
> https://lore.kernel.org/959238dd-2493-4d9c-ac35-6d04460a8239@kernel.org
> https://lore.kernel.org/1895A67C-BB1F-49EA-ADC3-AA4F51A6ED57@nvidia.com
>
> https://lore.kernel.org/20260508074643.55548-1-lance.yang@linux.dev
> https://lore.kernel.org/b8a3c3eb-f241-40fe-9121-4ae5a1097807@kernel.org
>

I addressed all of them, except the second one and I will reply to the
second one soon.

>
>> is an in-place replacement of V5 in mm-new. It affects Mike Rapoport's
>> "make MM selftests more CI friendly", since "selftests/mm: khugepaged:
>> use kselftest framework" needs to be updated. I updated it and put it at
>> the end of this cover letter.
>
> Helpful, thanks.  It was a little complicated because your email client
> messes with whitespace (it always has!), but I figured it out.

You mean tabs become whitespace? And does all my patches have the whitespace
issue or the one I put at the bottom? I am trying to figure out the issue.
BTW, All patches are sent via git send-email using mstmp and
I copied the bottom one from git format-patch. I wonder which part went
wrong.

Thanks.

Best Regards,
Yan, Zi
