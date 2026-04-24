Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012055.outbound.protection.outlook.com [40.107.200.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA12B149C6F;
	Fri, 24 Apr 2026 15:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777043287; cv=fail; b=O2fV5Ggf9Cb5OHinmEkOApqHfB2A6K7jHCrrfcW8t+gBUfJ9U5Blny3N/G20ByI4dK2YsnMIBZqowqdjLZmcLvzq4cN6oKCrqWKfyMgWgSNm1OT5QXK/4Gu8cvPZeejr/xctgtOrRrs+erKB9tvSq/I2z5h9TrzGcN4kORLtg7c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777043287; c=relaxed/simple;
	bh=AsD2zjqIFeaWIiWitUWmwOV4aLEwwUfK4MY6DCvTFo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Gt0akC2BCsUrOBhWww0y82oxZG0QCPEEilh3XCKXDO+dLHA7vglIk5lYfETv+4mCxGluoMcVx9fUWqVo2s8Nneo8wCE8BWJGqpJwlBJPBn+nLwM1GlesLprV6vD/jJ7fCXDQeNWBOHkrvbSTZDONH+vlq7HXAKlbbLCpn13DEHI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oqVIIwjE; arc=fail smtp.client-ip=40.107.200.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oqVIIwjE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OazFlueUy4kOk51CrAg/bVfIwxAdp8mI1NiT/bv1z5uw5o5AP26oHYcYced5kzV79NPgwNlh1bPGSD4OmD2QBm1uglxJIWPyszawVrB50eb0fXtGpmB5A4OG6jJ69hmwF3F3wOJNU9TaF2rMoD/U6xgQLeXn095ewMJ9G1UJIKKmFrd+XDhwmcOAKjGBlxg2pAc7qXRNb00ygJQ6U+MkLKpq1xWN7OnGsnwJnfWGV1eWRVMS652LiN0Bp3Vx8g3EsV2gT1GiUE+9Bchq/KZlyH6EWRCvSRMVfS70Qh49rvBWCY0ZxbMeT2Qk+n91FiTHEQKGj4QEJC1Ao5Z+siy5vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AsD2zjqIFeaWIiWitUWmwOV4aLEwwUfK4MY6DCvTFo4=;
 b=Hq+2NbkTdpqoANI4EgFEWo+EXykmrwMwI3fiysk/7lD+/+sVULao+26IKLW0BMQcHzPaIAsvxrwx87Z//8S3iSdv+nhXzMm0Egs6Vssko+WYkbNsYupe4DOPvOPEgOp0+oZVKGsHsLkv6CRSzPqkBLhsDBuwv7IvyUvKs6gKaXmq7Eg1LMQG7XZV8rhUyXZw30tFRG5Mf/m8dNutOP8OvpNmQgrTd6v6kcnKaXIHoKOMj3ZFTZBkJCBq+ozbCGLg97HUQ5GOXla9nCaSmFvgOVZ4kVfl5sTtYHGlMvOaz5Ps2lzk/zv9NC7dM7opOTqjjBbRsGe2t1YiPuqDsqv3aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AsD2zjqIFeaWIiWitUWmwOV4aLEwwUfK4MY6DCvTFo4=;
 b=oqVIIwjEK7MY2bdtqdT9V10YOPohTzAu3IgN+VCuyZaKWAAD1t+kJ0x4QKBdIdKCXnqNM/QnrNJBZiJU0ShPPWZPjYJo4arZeNdfV5bOgub8fc/oLnZZn7QYnfBGHLA8RDyJw9YkRBUmE9bywhq9tWSsNi2hV09neVP96YL0UiEWUn/cEsrRovpf08hsrG1VdWViREAgafg+T7q0047ff5OymcPpS/zYp1DgEmEszXF49LKB7FeK+CnszVGn+RExI8991K/9b5uHmJeHCeTriRmHMuLQmTsKOFiwueAl48Alhb3rsj+rzNdBg9ZCyVYguGsw7VeguHeukp686XDdkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB9209.namprd12.prod.outlook.com (2603:10b6:a03:558::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.21; Fri, 24 Apr
 2026 15:07:57 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Fri, 24 Apr 2026
 15:07:56 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v4 09/12] mm/truncate: use folio_split() in
 truncate_inode_partial_folio()
Date: Fri, 24 Apr 2026 11:07:50 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <B2F4546B-F57D-4EF8-90E7-37879711877A@nvidia.com>
In-Reply-To: <896b3956-3cdc-48b5-a0a0-a3ec35aefa07@kernel.org>
References: <20260424024915.28758-1-ziy@nvidia.com>
 <20260424024915.28758-10-ziy@nvidia.com>
 <896b3956-3cdc-48b5-a0a0-a3ec35aefa07@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0173.namprd03.prod.outlook.com
 (2603:10b6:208:32f::35) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB9209:EE_
X-MS-Office365-Filtering-Correlation-Id: 56917fd8-b64f-45b5-e791-08dea213443e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	bG+BtlKVUmhdlzVvYCy/zUgtBnrXR/HOYEyMgs8vWZdKC9o6M1StVqkgEsikkaS6DXHcwmqubRt5+lcc/f/V3Q260VwmEG8IY7AfZ8J7L5RpITRgymT8IZ0slPeOmsvU8eOWvZzdLSSpVP7KYUO+NczJlyCdDkNbwc6qv7L/NV4hPbykec9jYggzqgcdNsLq4csZnlZvxeDzie7ZUZUAirqxz5RVeJu0viq5HqYpyNxwnFfBaYHH0+DjcQQ8O22/FI6Atqinx/T1zXo9cl1LSR0SMEI5CTsKynNAM+dnsCZGfkeEC3ovlet/uI/LrSnJeYLYC6Uoj4f+yUAhwn4wcuYcgRuLcFBbHiKZLY8bMk0Fajh+sAAep4vYom6tP3+YVaX/HzkKS70PsQ9n0qpoXnmGMWXVwyJcpE6jJMNlUXnHHerBPbtttdJcO4442rz8mpuLLQ5RGOpE2EE0P1PDN5c8oljJ5QARyG1bzbl/e0KG+jj9QCgmD9EV0BjnT8/rrY/WC/98uhyhWUasvoUzo8NgG6+9ZMuGARoZobO6PNuNL42NWdUTimeJGcCtE/sZ5NjhPPCiZChvXBm2Tqk8cE5QMHhqwp1ZVlvMrrhNTgycZZcwuJyZ3PCVMpZ1s1qK9BAlGkQrwF/0Y2zNEDg/RxbuWJNF9Evn1oxsAvWGN2q2JJ4gm0F4us7xykrDqCfsaGfX99UXJDmCR2kXufRY/n4pAJ1sBr0E0D27/UEffno=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?H8VD8+ETLYmekhIRYPNLyPjDKVYEu0RMETAml1k17GzY9eXd8H4MSmiQaWyp?=
 =?us-ascii?Q?nPQXx+J3OoHMPb5HhnL7Weu/lmz3FHEdDKCSYRGnVpvt5ygjXpwQ7tjHgAdl?=
 =?us-ascii?Q?focf69Qw+MzBt2jXV9Zut7v4l5dHZdDQbJ2Z6ANjSK6F3AMkG9RdvoWDc8rr?=
 =?us-ascii?Q?1B0msd9YyBSp8u1u8CZ4KUkhjipkjn8mNGRDGY3PBIlOeE7N/sCTOxbx2cS6?=
 =?us-ascii?Q?xKq7Pm2WL7mF6Xjj2yH10JQWchrdetk8Xv9mPbwrxzccNAiSffYO6+IBiPUu?=
 =?us-ascii?Q?XwC9gc7iPKHreXrjwXWBjxwfZDlDw9IPdnzA2+ANb92BH6mQojV9dvf+WjQx?=
 =?us-ascii?Q?va4QT/rmV5+kY3oDC/kqDztsB7kA08+8SMUwAc6tXAeCLp652PIfyEYfW+WW?=
 =?us-ascii?Q?HkxlCrnTncVfRGQ+bXrdp77AhH9Hh6u7VNG7pLWh7o2I/EZR3ZilqHRr+WVs?=
 =?us-ascii?Q?aNly9RqhmU5ZcIU7UZn22YX+Dm7+1hnwzM6iCrIoiYVmclruSVK/9YAQUqRA?=
 =?us-ascii?Q?Sft3uE45CslbPxCSN60acc8/2W7Ueh784DA4OZHNBK3uDigljnmvFbp5DMPH?=
 =?us-ascii?Q?vNcpgFWpAnrQrGZhVfTSsIZMIsK+wiNG+Nh4Asv/ucX2dJ1ZSSBpxtasEQdl?=
 =?us-ascii?Q?G8ppCifh5GAYBtRTgCQY/q7TD4xB/C4koPO0YMvtP8EKf/geoXP4xcd+t2ua?=
 =?us-ascii?Q?TdbHxtk3/3jfpiesefLRPUgpC9S5zXCy6KXdksEzKXUNRJkWuKt/dF/IKxJX?=
 =?us-ascii?Q?sT8Avi2YEQIC6Jqq0eN0lmoGTBG3TckInTmCIzID9oH+stXDlOgGg72LNTVP?=
 =?us-ascii?Q?HxOuND+IxgVCUT4fAf/4JeuFjMdR6r8My9mv0CzzKwhHy1Rz882k/H1AdWqz?=
 =?us-ascii?Q?KKC+XgubPtjble7mtJQLrhFk0/OMUCVXlwexe7RVOFFfqwpQ7ZmNQuV0NLlV?=
 =?us-ascii?Q?Ooj6fQhhwMjrA1QEjYygfm4bP6A/hKgiyAYS5OFWBzQ3S1WsKW3CdRNIkpi9?=
 =?us-ascii?Q?NyfESPKE5LrtP7W1rMnvDUSRVSukMdHyeML1jARFef/vsmdCTuE9gRv5kvA8?=
 =?us-ascii?Q?/k77ufVWGhy6WF/+AnmXOQgZHaT9lqLHdvdJdqh/BwQ7/8wGxYubS3fWZNAQ?=
 =?us-ascii?Q?ozt9NyTYB1RFOwbY3pJmrVTERu5sRhFep8U5pLB69waiOsOvsnr3Cueymr/j?=
 =?us-ascii?Q?qSjs7CskuWTqEMgfurCZ33ZJMxdKXig8nBJlONWKgq21EbAVhcFHPN8Qojgx?=
 =?us-ascii?Q?CKtSek498Vvt7vdK0ori9mVYAIdaotAldLSZToXNwt2P3Kn2rn/BCapDy1pc?=
 =?us-ascii?Q?aXyW2v+7GjQXqJoD1QnMJU3zxMukLEzszVtC79wzjjlW6mekdErJ+/wpEUXH?=
 =?us-ascii?Q?9qsEsrfxxe0lQ0gey0fbXCXRXvMgPFvei/bCaRuBfQ426qzmLjRP2gc0ZzQ/?=
 =?us-ascii?Q?Gqh9fcleOWpf8NqjmBp2Jcy4mRE2Bfu9UOY+nVjSvLhAD4NBK6mY8lAnjw0c?=
 =?us-ascii?Q?b3U3DMyh7n9eQ0dBvjDR6xnG8Yqn3CI50oA80st7tOPrUx/Kg1FyomLaVDgE?=
 =?us-ascii?Q?zO/R/pV7gVY09Imgl4WLxrOWFsVNfDLTSc3m7+VdxszNpv0kGzUKUfgmYhLL?=
 =?us-ascii?Q?ZoBnfnWb4jBHyzzrTcuXYZf2OHe5Q2CciDrAugkLj+YaK7S5Q8hiFFIhIp+i?=
 =?us-ascii?Q?6IbVD6AmGPRcgZm0FbqiTONZZy93fU/eFnNqi09Sk0hWsJ1nxFjjahxde6yz?=
 =?us-ascii?Q?c04ZaaoNPQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56917fd8-b64f-45b5-e791-08dea213443e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 15:07:56.7509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gikcUvPpI0WTFQge7FUlddtBb5AsbNWmbSqZl7/Lk2XUV7RxDAzU07v48oKcXzFT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9209

On 24 Apr 2026, at 8:54, David Hildenbrand (Arm) wrote:

> On 4/24/26 04:49, Zi Yan wrote:
>> After READ_ONLY_THP_FOR_FS is removed, FS either supports large folio or
>> not. folio_split() can be used on a FS with large folio support without
>> worrying about getting a THP on a FS without large folio support.
>>
>> When READ_ONLY_THP_FOR_FS was present, a PMD large pagecache folio can
>> appear in a FS without large folio support after khugepaged or
>> madvise(MADV_COLLAPSE) creates it. During truncate_inode_partial_folio(),
>> such a PMD large pagecache folio is split and if the FS does not support
>> large folio, it needs to be split to order-0 ones and could not be split
>> non uniformly to ones with various orders. try_folio_split_to_order() was
>> added to handle this situation by checking folio_check_splittable(...,
>> SPLIT_TYPE_NON_UNIFORM) to detect if the large folio is created due to
>> READ_ONLY_THP_FOR_FS and the FS does not support large folio. Now
>> READ_ONLY_THP_FOR_FS is removed, all large pagecache folios are created
>> with FSes supporting large folio, this function is no longer needed and all
>> large pagecache folios can be split non uniformly.
>
> In general looks good. Just one question:
>
> folio_check_splittable() also rejects SPLIT_TYPE_NON_UNIFORM / new_order for
> swapcache pages.

Since swapcache only supports PMD order or 0 order yet.

>
> It's confusing, but truncate would never stumble over such folios, correct?

Right.

Best Regards,
Yan, Zi
