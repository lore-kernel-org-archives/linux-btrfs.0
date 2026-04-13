Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010037.outbound.protection.outlook.com [52.101.85.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470C4393DE0;
	Mon, 13 Apr 2026 20:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776112112; cv=fail; b=mBeaD/DhyLft6XmiEFL2tiAYfMY0gYmqZm5Vik2Sz05Uz42RTb4Pk6hwZ9c2iJReWr/xiyL8FY+14DSNkeXsEVkfsjxZ/xM4q95MV7EkxxU44kvFerxqA+t+pOYOrcXGaRWWkzc7GAV7d8jHfZNKUxXEthWQiiDAtxnmqU6c2fA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776112112; c=relaxed/simple;
	bh=O47ZRuj09cDuvwf5CV+LV9XD1te0vGSSvnqCl8FMCbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CNS3OFMSPDz1xRIq1uN4viqynw/ZuzroeK6GVmTCHU/IqYbNdLzhXtQpSFs/20MSs/bwtTEkbVQLsLHxYgUAynm1LzdnU+K8mWzhagabKUn4iFS62J1X6BFZUmGFNJX8KACSPa5eTZRNOvHxxqI7DGc3A1PRK8RzQy5/Cs1sm8A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gRSCaz2J; arc=fail smtp.client-ip=52.101.85.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gRSCaz2J"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E7H/V9FWPIVccXrIfDjuZbAAtKPbtD6SkhPp9z+lrtnRyViPrt/TlSIt1l0UYhiEJT34SV0uBxtSliGhbpSKyoPt9ojoovolVBwVCrOu1aW8EHJgYEgwBqNWr5NCVtVkMXeNrySL1jNhIYn8qgaLWiruZjNnRGSTG02tmm5N91uLXhMio1N5/Q6WTXOfS0OAX2663NN3vX6mkmfD7UcsRs/nwrB4/+bwr4whFy8mkfgzequjCqwLM5CaS6SGo90aQ74xel8npMKDo6XMKJ4A1bIobUvPbCnL1DOL5BqAacQg6HhgD6O+MWADnJEt/oBSItx6Q+U+EESvGPm7nlwiDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=03+cnLpU0Mj31rBajfVPC5D+hfAcM531pqo08qdHFdU=;
 b=arDlSKoZZrs3fTQFaRmNblIlyOQhhmG2dQN4IX0CUsuZljST+dVIrmaGqCLG1IDVsJz1BkT4QOfuhYDTw32YeGPaSmn2JdxaJ8bzQNBSDKKL5oUKQkZOZIZybgdekzdFP2M+WWeXXtpPgDRsw/rwxNRha4yEP3DC4Hl4W52srNRd7O9mQnHONg9Ywc41d42/ZSm9Bldz7l6XqQ+s5HR35OFGf04KxC37d+tHb4ofVAGa5i6gPasLUmuwzRCqnx2laGg9qOoLqbirlYgyYH10CNsXbFtUcYpW5s7rgrjnk3bp9qGhNP8ZfgsDpKYSfgPr/S4dhgni+YtqAlDLw8V2kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=03+cnLpU0Mj31rBajfVPC5D+hfAcM531pqo08qdHFdU=;
 b=gRSCaz2JtxZv4zhvJtD2Jm1E9FcBUSLKPSsuvSTjFpPMknKzw2VMzMqGDdTNiiBdG6Y7AgnGx++NiL95XBMbZbhfiTKNf1f9m7TeEeH6mYII2661gj81bRmHwwrpeprCj5AaFh+pu98vl839828p3csSgkqRvHl00G64LwcdVWS1+hBU+fycWR1kPYABhjz468Mvbwg/f4jxoAUEJpDUMDkQd069YhdWtoJWxx+08+uyyoYeUiiWZJJTfmnh1yWQAEIqbaJ6DrAsR0e2IiWnAkkDxDP2/fnTIU45wn0hVE5o6DkU5H60TWze8psp0ZNCt0ug8STSHb3rbHE5yf2ngA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB6064.namprd12.prod.outlook.com (2603:10b6:8:af::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.46; Mon, 13 Apr 2026 20:28:21 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 20:28:21 +0000
From: Zi Yan <ziy@nvidia.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
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
Subject: Re: [PATCH 7.2 v2 02/12] mm/khugepaged: add folio dirty check after
 try_to_unmap_flush()
Date: Mon, 13 Apr 2026 16:28:13 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <FA970E06-5C6A-4EF2-8181-398CF435104A@nvidia.com>
In-Reply-To: <ad1Qz7SClkF1CqWs@casper.infradead.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-3-ziy@nvidia.com>
 <ad1Qz7SClkF1CqWs@casper.infradead.org>
Content-Type: text/plain
X-ClientProxiedBy: BL0PR01CA0033.prod.exchangelabs.com (2603:10b6:208:71::46)
 To DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB6064:EE_
X-MS-Office365-Filtering-Correlation-Id: bf10c7ba-c926-428a-d4d4-08de999b34a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	4ZugB4HSA1qDZoT3YU9FI9BO3LIFevbukxcNNOlXFx6chW0PR2zWOzLbMfHbEVu4KFZ3tzGwFoK0Nju3Ilv4AjWXyxMVEALOgD+jB6gYP4ZHOh3e3XEUXnEU6EbGS8zatZDUKfhsHcIAjnkq3Akc+6/llIpEVU4uqTQJfB6yo5AOGxWd3Tr02H0cu16JWuXzUcOLVzGxheDNB8jA2hiMoKsnvmIrxsLAH1SM/Ms6wkcMeAGPfgTnDVN2uvB4IuNOAR07TxdckjoNngs/gC0zW04Fz9sD91UbpedUhk02hJ16iNlm+wVtEoJbwk4wzGc0FHbVXYHz5I6XDBVVVbT2Hui3581XH6CsCryTa0CSGlc+EvQrUfh+WJCatw6eD9bCvw+tGECQja9EcpAVG/LL0JlUvBx1pZWYX7BLl9223DBgYNHGpptWwT9xY2hrzCUhQlVGnqjYuBI+KeADngdxcOefMou+m7oXAH62O8jMssB/aoJw2KoEWbOPh0xQSQrRdLEN2x0k140IEpFr5y2pUdox6MQfdMs8Nw3sh0Sm5sy9mfIPx4dKgv76ONmYfFpLmCh2XglBT2G7zq4F+5C6B3Y2PHEYyk6c8m1dhdcAeLWHYn6vr73eDcWec5e4WDVggm99KShPrVgT6k/eK7UFloOFoETWqtWWXch4t4GCd0fTLWLjrDCbwOiCKKeVISMOkBW1zjSj/iFP2An94yp4cpGhpXmYYZ6vvj0DlR78Uwg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?avr/5XhWKfNEdx00rbP0s6/4XnKFE1NZ3l0Q8UiCiVYCUDYN/IrA5qbo3Q75?=
 =?us-ascii?Q?7X55hEbRzJC5I59gkGog/l4H7LdZAgzZb8ugxtOqqFfgviaJoI6HeJRzH6Cv?=
 =?us-ascii?Q?nlyWi5PAy7SSFepF11TtLM7T+UPo8Z1GmsY2EYSnElYcu27ouJpI7l/fSkZC?=
 =?us-ascii?Q?YUSpZkHCdS6CV+xMY/wapHkx6Jlx7bbLU/4PpOWampHxCZ8f3WUEFsjU4Ioz?=
 =?us-ascii?Q?SHZtmEJJ0qrcvAzH7iAQkAOg2TNCqL20+tcwpGIVYyDTqvS5PJzf4Zcn2dtV?=
 =?us-ascii?Q?Z8Sdxb+9ahylZk4p++loJaFdMVFiqzWPGqpzzQZ/KjRyNzkOSaQIaaez90cI?=
 =?us-ascii?Q?ZsVCEnx/vJgpNlIg/Y0S/h1EMr1w73urtJ05YyGbsXfucfkxx7LAGFsPDNlq?=
 =?us-ascii?Q?ynij/euQ7qGSmlHrorCTmgn49OTHFNYTCvEy7cZuPE4V2OxpuWGOncGpNWd7?=
 =?us-ascii?Q?la5hNi/YszgmhkplY0P1p+SBNPkbUeddfsH6BrVceQwiedO6s7KwWNHe49wl?=
 =?us-ascii?Q?2uFJXmS3GeSUHNZH4IpJqp/XpYy/vPkRoTqgHaTEnaR888sC+I2GYPfLfeYB?=
 =?us-ascii?Q?kuMPfS136gEOM002/IbgQZ9sTgIsNvpfSUIQHUsuclhzXiy+t275AXc2B2Tj?=
 =?us-ascii?Q?BoKq8x4fVgVb6Myt1ibbPBjPD9Y2tBq5Y5v/HE7LiyMFVbrkgbbVSivPfAis?=
 =?us-ascii?Q?ij2trc5+M2fEmCyEGLAJVxYBKL3CZImtcpKzVb1RIDqzGD85w5Xy2jnbenC8?=
 =?us-ascii?Q?vxza0EzWzzNyIIQYkYRbmZqCgEXk8iHvt7TZAC1D5xVa4D661dd6sRRs9fX4?=
 =?us-ascii?Q?7VHBNGdAOLP1JcuVPYsCtB6sc1hvVlZYPrSA/ovZiYiA0BV78XFeclIeBu8A?=
 =?us-ascii?Q?RfAvPB68OtynzMI76Nt+yV3GNI6rTQKAsRoKBLKoqZXz63tqrGNjjQzlYWm3?=
 =?us-ascii?Q?6gzvezzM3HZc9oWmMhbymdwayFDJAEjfDsL6lHxxeYGS9ldjpeUCaydXHUTq?=
 =?us-ascii?Q?63Hp/bjp83zgm/0+AiTYEJKE45/SNBspIiQ8rAeIijZ4/8Mz9bNWmWf0Yqt4?=
 =?us-ascii?Q?Wb7fdGB6Fp/rF/6UZSCoJh/Wl+75Mg5D9THTFpg4IUSh2xDJQOcQlS/jAxer?=
 =?us-ascii?Q?6Fu0W2m4G8tcRuRaCG7GhasBhRugXOx1GvJi2Pa+5v410PYgrojYqsOCFGOT?=
 =?us-ascii?Q?yi+MQRn96T/dt7zychkbLKV3mj04+gjLOh/7tqnB484+ZKjgbHcNiJVduMNU?=
 =?us-ascii?Q?+N9SYxTW9GAB5X9uID2a2eoAjAuJ1HIYOH66A40wlUFGyR8Ym0JOL4ZQN1nn?=
 =?us-ascii?Q?wW2aV9VHEzcmC7N4N8NjqL6lEGfUAS1HQ/O1gKpGyd61PQb9rWEoShK5rZlY?=
 =?us-ascii?Q?vZprisKTgJI90x/Ip5YGp/yOObr94w/b8dqpQnBRAulI98WFSomzv/NcguIN?=
 =?us-ascii?Q?75AauCWIrCeIKz9RldhyFPbZcYrlyw6SszVn5hRTvRrK/7UJi2/zPTxO7ESX?=
 =?us-ascii?Q?pr5KaEJFC5vUlszYL3mAaKLcXZVmmlQvEzLkniPrhOHinestZaS83yJhWjAa?=
 =?us-ascii?Q?bWF6IqoYmF4gofXjjI8aazu/yqzk4J3T1g/ugaEVGJ7yYGSFgbkaaf3y9X7c?=
 =?us-ascii?Q?UimcsoL4jgPgLzsmRtZ8dkpPNJDdj6TnDzlDMhRfHYIGGivV3YfPSVSvKzjt?=
 =?us-ascii?Q?ZEJBXWaIlYllfXxfcaIQg4+uNh6OcKduk1P2jXPdqhldK4+1k0NTOTzOEycE?=
 =?us-ascii?Q?HZZ5XgX/nQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf10c7ba-c926-428a-d4d4-08de999b34a8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 20:28:21.6734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FlnpOyMrzkkH7VVg0uNaCT/g0CRWdZ0LF5bvm/GbY4fCQveyvY3zS4f/gb3agb+8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6064

On 13 Apr 2026, at 16:23, Matthew Wilcox wrote:

> On Mon, Apr 13, 2026 at 03:20:20PM -0400, Zi Yan wrote:
>> +		if (!is_shmem && (folio_test_dirty(folio))) {
>
> seems like a spurious pair of brackets?
>
> 		if (!is_shmem && folio_test_dirty(folio)) {
>
> should be fine

Will remove them.

Best Regards,
Yan, Zi
