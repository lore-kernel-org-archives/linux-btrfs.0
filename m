Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012005.outbound.protection.outlook.com [52.101.53.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B20A2DB7A3;
	Mon, 13 Apr 2026 20:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776113238; cv=fail; b=Qa3zJPkOatYLcK7Emk6FBOoxU8MYDyTgQGSYmTlrtejNk2z6wWZH6AUVczVQkyC6WeLwx8HMqROKiGn/Kw58cWYY+PSBFGOUJny1Jw6IH/mMikj5k9C79I1BLR77dr4CZRpAgtdmWHo+k5CaLX/rnwrs0S7/SFJRY+4ifoDhlt8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776113238; c=relaxed/simple;
	bh=VoCg/bgzVFpIRu5LNtzU1cVRuA/IKKSYtVgFt/W1zMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JFDy1lIIZTQL1B1d/9UndhgTiG6HhN3XmI2SIfgUdTKd1OFkxYWqaKzlms6qWXB0z3mPeT+nl0XWdMpeIeecZaXV0oHw076JEAocKUIx4F87YOcxlBJE5+Sl9EOinefwiR5m/6CNH2j5gZs2Q2Ho7+8nw66CiS571wd6gpZ86mU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=re5pxMrt; arc=fail smtp.client-ip=52.101.53.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="re5pxMrt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WpVSHwzDyXWay2UlBxCMD5t+gTt+/X+JJev6NPX8DDfeKtyP5aGiFlnOzQ36ds0tyuz7To+rleMTxiZQaodXE8NqtP/lqtXAAJzkCfgKK4Fa8dEdy9HWv2Qvln7khp+EySZpOgS9QLafZwwTqC8bfoKHPFfcbhXS4Pld/GL+mm0IbNnOpdiCFM4tzIQoWvrWynGM2hiydQ7TYTbxm9uCbTY2a2qS7hHCA5NRNM1MNWpOMuSIMQXOHb+WPAVIrGEjXvzy0RZVvTDlSKOTHUavKb7fN0eRT+0H9OH5VVjy7wcCwDHDVkuczOl0L2uu+PHL9VxWvriGjsWjH4885peFfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OqSuNIn3GBzPTv54DW+EF0VllsrE3LYgcvBFJOW2R5Y=;
 b=kTTSdjvSXn541LEVAjwurGPf+dRYwr1dNW/6QpQwb8BKviDj5mXqCZYnLJR+JE1ERTS4uvIHGLyNB+TovoIuRm1kCMifHvEOcCGxwj+EqJUvw+ajS4gbWTZ3CcZbaCkSzaS+GnD98W48QaHkUOfw3cysAaRYndbiiChBc4GIegJrmTpaX8+t2LGu2HHhSK0hWH/uLW6rPTbudEhZlbtBa4bjSflqPKcQZyP0priIz90CPj/LfKd/H5oRE6PZ/9dDuJL4w5Xgyh+vacGBGr43J/na43XiJFQbdl1wxCu0aJCgcdZr1Y0lrWJnMRzLL3gA3oYdqfH7WkBqt/kcm2SnOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OqSuNIn3GBzPTv54DW+EF0VllsrE3LYgcvBFJOW2R5Y=;
 b=re5pxMrtnpnlfLl9XeersQdC3wVnDQri1bwVmtrDx6m7WiKo5GbH/PDcsVOC4B4EKUBE0/XrK+eG/fEZ7Ipw8vLaj3YdBnPM/9cIlkcz7JAtZDB7SqhIoaxBDaYFoN7gfTLWc6Qc3nHh9in7jHKCf6OOuYVz4llOqvQZCzqr9ewwGiXpfpcurJ1jId+FDTYVVmtdcsKIWVCzmunqjBTS72LYXVS2I9dfhk0UUskNsDR+xzvqYDXM7c4ji90gsibgSDWpy5+jMnYVhiBUcJ2T1kOwl2XU5TSyVdMVIvx7syZj5Ipccr9OzIpamkVfnWHWM/kWZPOYl1gwlMMW4/B5jQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB8727.namprd12.prod.outlook.com (2603:10b6:610:173::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Mon, 13 Apr
 2026 20:46:59 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 20:46:59 +0000
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
Subject: Re: [PATCH 7.2 v2 08/12] mm/huge_memory: remove folio split check for
 READ_ONLY_THP_FOR_FS
Date: Mon, 13 Apr 2026 16:46:54 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <D29AD8D7-CEE9-415E-9218-87F07F3F9EBA@nvidia.com>
In-Reply-To: <ad1U_Z1b7hKlgnun@casper.infradead.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-9-ziy@nvidia.com>
 <ad1U_Z1b7hKlgnun@casper.infradead.org>
Content-Type: text/plain
X-ClientProxiedBy: MN0P222CA0017.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:531::22) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB8727:EE_
X-MS-Office365-Filtering-Correlation-Id: b16c8b50-d26b-4b46-5b94-08de999dcf03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	B7k5ejtWlSj372itvXYE1DnihvAg6f1ucIoliaI9Qgh38r3nsDm4FnGzjob2CT/F52iwHMelK75vXlMSS2l5EMcTTLd4yWOjI0uPTXIIO1XO5QsDxXtsoBDBX1h8fCzvh0Eo1ghCcegaxWq+kmOx62M8rTrCVORXvDXkzNUNyZHNxF4x6OmTceK9WAxuGH9fb/BNrZfsKRgVf4KpESOEP2cIuoQam7xXbog7OQnjLF9mdHwOpurreeal9Xob/I8XVyyxkztvvHcFcVOG5H5ZwMATkg4OcxDFirWq2MLfcrVSQiSpFzPyMXnkukyPf/uOZ66yXkkw4wq90/iMkYmarGeoTN15gJb6YaPHc5c3Hu9IDIliXaozyhBEI1jnTbng4qz8uJalXhe7UlqQyy8YjIyW8T/F+mWC+I3+znyItxnJ9TbGnkqEwbUYu7HMGiSqOdLT3UDzIFskyZPxQELvO1Qx8Q2hPVNbvQCd457J0F7FUWI/Ul0d87Qw5UszMTcWbjsprJ8C7+T1SxW97KozmfTLSA5KPz9n3e2NFkLafQ/csTtk3FyJ01dQVOFKSjEmcPknE017obEmvyKeMJOf1rgZmFuf9Sog4bQffuysfAlG8sL1Mjzgvy54/u4Bi1dgDnCpiaGxd44vWCtznkPPjQTS0Pd1w6LFeKbr73IKj0FLf0Msuft0qMa57bWeyx2SHnr9mP8Ord1F3CjZKliqzbXGixlBBTG1Q3FCpB3voNI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?B7zkXrNe9C+GNWNnhsImn0Cpdg/xB4lCpI8pq7QHuIsi83wwGpgECdC39sZW?=
 =?us-ascii?Q?PkMGzPZyYTsWbJpKr7mGerokhdeRBGw7+mSjNk8DC/v4FqZmejwCOCUO4f/J?=
 =?us-ascii?Q?JW0M9b2UTcwUZmwPrzmHBZRKlJ4ExzrghjmH3z/fM4vywaUUDiV2EwyrJAG6?=
 =?us-ascii?Q?9vcb7cHtnj/ITylJ0EJaqtNEfWBt/osfSP3vuM/SM+ApD56mqRtWq23Hmcug?=
 =?us-ascii?Q?cskOn0yFyxjYEVCWRoygNZZeW7fONiPgV237B/wNJr88YdAdCPbrvlByCamQ?=
 =?us-ascii?Q?0FY070OPFB2k6bHgY7mr0fIvMa2paUk0M9yk2uiw9g6z24uHXUS3BEfJd7e5?=
 =?us-ascii?Q?MW91UlJRkTda7/mGOCEr2YVBSjYTfi7XaRuQALP4OiBEEZNhtpDyhwNYMK8H?=
 =?us-ascii?Q?O0ugVHVXFDGMbG//bCL4NF1cfurWuIfajaIR/m4Rbdm4huLERUlvkHYCznKm?=
 =?us-ascii?Q?TwGe9v89vGZ4PzhWB+vxz22/iI5wcUH0cgasHilYl8MswohcoUk338xCiAtg?=
 =?us-ascii?Q?llp9DRT31lgGKTpy9i+HbjfQUi0Ot7HGtlY5sIs9ufZQmM8F2cqTl94v/SyH?=
 =?us-ascii?Q?HbkADqE6hFp2OQSvFzbVn4sM4l4RLWTAJthGpahQEZkzfgdqvHFqxjvdFLzm?=
 =?us-ascii?Q?NuO2HB4JaNLYebh1yYEZqRhfYNKC1Ij4tfCpOQPOm0S8wXDMfslXZTk5bWoT?=
 =?us-ascii?Q?DMvp3CgdbtPk8pmQsZZyXLOt9zI2Fs7jatC2o/WpYOhLXUSZI9pTtTGJmMEo?=
 =?us-ascii?Q?YrjwysGiKcRhkjzObWQdi2R0nJfzVuE2RjfF1rm3v7khA0OY2nT/HjjFyV5b?=
 =?us-ascii?Q?Nxd6LClea2Bsnc6gna9swNhXFLW6XtyDmXZnJk3HVStCKU8yKjoAodiJDYRC?=
 =?us-ascii?Q?X7pNFkVxHnTuuVaSURRH8qnGVkbLtdQ/aJzIoaVTtgH4tVf0DCfMQuq/4leB?=
 =?us-ascii?Q?oaB1d6BxyUEwHToE9NEwUi0plZi8w2xWVKF3LdNOE224LPH+YAUH3WNzDVVJ?=
 =?us-ascii?Q?SW6v9GNFoFbG9tr6O9Ic/Oql4jpr7vTzdjAiEZoCLnvnheh5PepHxrilRgVF?=
 =?us-ascii?Q?vDWqZl7Sls0qng8LLltOtxl5rtn69NarlOfP2ibuBEkzmRl8ny7PLLOvpbaC?=
 =?us-ascii?Q?7XXF9Zz82NdWxrxRfcCEsBu35xx9Pu6q6XR6Lx3gVPOD4e6xEBepOSwJnTZY?=
 =?us-ascii?Q?q4pJyxhxiKMe6iHFnVbhdd59ufi4IWjwnqIFrvP3P98Ti59+s6iTKcIWxvp/?=
 =?us-ascii?Q?T8KhY7OwP2iRl8DYaY+jDUVVyBwwY+zw/MxXGam2tMFWPP2rnpyYnAll/8/Z?=
 =?us-ascii?Q?0BBGE3TAxSOdRoB6wqqXyRklN9hCpneKQtISfA+GvUhtctfk9LKNTTE7j5yR?=
 =?us-ascii?Q?5sMezJ2KYez2+Qces0PB0PphtQtv33Nu2PTmhUWxtgKxErjDa7+d0QEbYu3R?=
 =?us-ascii?Q?AnF6Uh0nBuGwWj0jKE9yUWS0X22zwRXNPNJtY2Y7AP6VV7nXUlLhlI0WSL1M?=
 =?us-ascii?Q?+snIzky62/2wAW2TbzkygfV0R8rxeUnbUxHhqTN2safRPnESy24SzvtT949a?=
 =?us-ascii?Q?x3UKqyVkS3TkZQnhJ8LqKEFArlbsDS0rBjx61xsOogdtVjvotaKRupmmKue8?=
 =?us-ascii?Q?ZeQucCzpxCp9jI6pUvAVutLmhcPg2CodVeuf/zXYhJQI8fsPy24hE2G7a+sz?=
 =?us-ascii?Q?Wwg0fqLicIieTRxA83exca8Si3ZzChl4AR1evHewDy2CgOpwVNIFFA1JH827?=
 =?us-ascii?Q?xFATTQwbdA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b16c8b50-d26b-4b46-5b94-08de999dcf03
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 20:46:59.6258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G7iiL21lLdXMBdyWOwrGrFvPn7ibD4tPt8VZ9LnjRyHIF76DTGbFZf+WOPxOWudp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8727

On 13 Apr 2026, at 16:41, Matthew Wilcox wrote:

> On Mon, Apr 13, 2026 at 03:20:26PM -0400, Zi Yan wrote:
>> +	/* order-1 is not supported for anonymous THP. */
>
> It's also not supported for file folios, right?  Or do we just skip
> adding order-1 file folios to the deferred split list?  Either way,

order <= 1 folios are not added to deferred split list. See
deferred_split_folio().

IIUC, we have order-1 file folios but not order-1 anon folios.

> we need to correct _something_, whether it's the code or the comment.
>
>> +	if (folio_test_anon(folio) && new_order == 1)
>> +		return -EINVAL;


Best Regards,
Yan, Zi
