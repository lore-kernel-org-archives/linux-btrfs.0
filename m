Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010065.outbound.protection.outlook.com [52.101.193.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F773254A5;
	Mon, 23 Mar 2026 19:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774292817; cv=fail; b=FYTXXcdf6uHEPEKPm7eu5JpcHyfIWR3GENemOVJESOaE1ZdDTPN7OETAjNJIJaz8YRglKefcjjq2/UsIJJxGsgB6e2ZLZSdLEEdxwsxbti+AHy7WNpe+7Xu/+aLkGHn3XxMUFEyU4PTdnwKq36jf+n6X8Uurod/j10a/CbYDNiM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774292817; c=relaxed/simple;
	bh=vSCDBY6/SxvHncb7zk/bJ4fh0wuZTOhH3imjQJon4Mo=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=dlNqiMB7CtQrH/8Ge3xHgn0W/RNhF3zfWoaKdDFdJw8NjMiYCOpHjhJI2M+NzNvLg7UOYpJpiyB+VoXgP3/a8Ypbja7PhL+WFbgtkW97sApwYMA4l3v2DRISJqXH2GQMUUHPvLlajSDDcHNN8nZRDcx7COxz1nqwtEnLhBIJVNI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cGpi92jc; arc=fail smtp.client-ip=52.101.193.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cGpi92jc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nbE6qzDgRcYGueNLAOzJNxdonVLXg6FqTqTguuLisO7xJSJRm/SXhAEsSoKURUaW5Qkhmr1wdsm48FjOCDy3jCb5plAhsRQxSLaUaS7VO7lxDRIoLtS++pvlXAoXAINrHjparR27QL1n81dsJSo853tb2L8sQ/mI+h247TPGEFhSFpijMEYYGUh3aRKm2ojSiXnBNkJ376aOZjyqPlTnppkfJLphoqhtle/CU6tLBSBF6XTv6WFECo4PzClSp27DhEU4GFkMdelbJRbkVkCIHCVhPlOxuFGsVqWEjlPuzApTLLqtKSKak8f4NpycZmSO6jIPmXsfn2fqCQJXafzElQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tJfEdB2M/11C8UMkQcswqZ7WDv+m5n1/16bUw+0KZS0=;
 b=m6UltTaAOlNFJKajom6aPg6XwLXs0ncZVAhbFim6fodelXgKhLGhUmSOaW27B89EuIjeON4zxRon9A+sN49LFI4yQH7ZdJpnXsH0dLRJwIt/2UlalVJAoAbaMdJceqMYkTXw4ZAvV50YEqhpl2u+YwpvhEZ+emaTw4lxLGIO9dMRpa14DVAWw27YRnYN6Br+/86e4ubc92msb0kIk83CMX1RHNMUR+NuggDxyKfHnRQwBoJlDBNAjrVnRQSZpAu5p8eWa82S30Nqx4NqaIb5iIwjXotxUGdPjEUzetv7YElnGP3z1l7L8mexRKZHLeXXwi9gOZqh40DFRNjPt4OZ8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tJfEdB2M/11C8UMkQcswqZ7WDv+m5n1/16bUw+0KZS0=;
 b=cGpi92jcq1oDVL/UI2l12PmxWmNk1Fek+bgtQ/7ZUwTZbc7Y6iYEeQn6P39Cz0b8+Mb1gmomqxiEWUmhFDLY1KamU3LhXGHJf2r/+hEvJAPTjccRCFrOJLq75Ud0I1n9TZlIQe3W8+A5sF6GTQDz4uIx1ESVXisCujsGl88Ogoh1pBvjB77hhEOu0j3uj54pUqh4CheSn8DoNduuBIfvx7UZjtqD1S5Apeu0+/B294Y4wuIKSHnPT57R/QmG2pGBD11kLWcLewLomftVkBbwnu0TI5OdQUgeu5LQ7sJ4Kn2yPLAhpZE+RKJ9QjO1LLam9eb/VcUbA+WgN2OS9zN5bQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB6813.namprd12.prod.outlook.com (2603:10b6:806:267::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 19:06:48 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Mon, 23 Mar 2026
 19:06:48 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [RFC PATCH 00/11] Remove READ_ONLY_THP_FOR_FS
Date: Mon, 23 Mar 2026 15:06:33 -0400
Message-ID: <20260323190644.1714379-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: IA1P220CA0019.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:464::6) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB6813:EE_
X-MS-Office365-Filtering-Correlation-Id: 162ae1eb-3084-488c-acec-08de890f557a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	W76a+pFMaukzb73SsML4mfCkkAnjbl/LdGi59DMVrbopHI/OroqgFn5cc7XtWcFdgWLxuHqSehnRSK4+2zcat6WhLt9iAAyxT4A1pAhPuH4ie4MTXUfkPpUy31YbOUvoVxMIDglRTjvfD+EePIaFRwq3jmG172I3D8f+lIUEEgZlcGIN4/4dFoK3e4EBFl6Brk7b8abEoSYc3EA0cyGefKhcfcUHoeBhHgNi9kjrLDe9n3Ywe1gR6XV8uBEbM76RON7fv1uhhRWNQfXhjb0XbkIPQ6ILbaPS/joXnzAGcjkcquLDtAW3rYhXA0rfHGd31vrPO+VL68ewswGSkgQPlQNl0QOkxSRyGAz7YqzFrRbO9N8IP/UzD7AIHloi1tTGOQlBML1L3xCkJPlLodPlW1yAQhy6FxH36p1wkyTsMREPoiTY0OsBtC7usLSR6s4aYYTmXJuIcdzJmSYBMJEwNf7O4e7y59v1pgD5shggMA/b7xSqNbtRkqae5kNbQG0tDkHZzmq0DGJfFGa+CoiAtU/v0tR112E8JmJl3VKzDKbwmT2DOVR5WekWyFyrN1TVcb6pq7RR92u1OBh77wqzS8PRVnw68G4qC/taonIaYMYvbNkjDbYFE9SKTGckFd0gwXAXQIW9M9F69/gtJRldaVIFVsgsVaUSpF668WgNDhcSD7mm9tQ5in1sy8e2RjECymS7ApZz+iuFWrYPvvyqD3MF+8Fdt5ULJ2duT+iddGNHJh/EVRYFxBtMn426a74l
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1Blakp2n4QLpjhb+1hFVYeIRLZokygiTCES2BByyWVIQiOex9VbkC9qoLTdk?=
 =?us-ascii?Q?HttSVuv7k5XDfUhgIfhP4O7UExSrS//ctUrz+E9GISMzaN1jR+zk5Gnb+LuH?=
 =?us-ascii?Q?6+jEeh5woRhWzpFDjOtw65cjoFiMA9tQ7C/wlKr6Z4VjwXEadydYzUTiUT7t?=
 =?us-ascii?Q?W49UZZYDzMwUSWhGMpX7Ew8MsLdYlbmo/4TsaTz4F0FaBjKiBE+N4AIZ5uII?=
 =?us-ascii?Q?70+brpUup4/dgeAYgT9Ao94lFDEjr6daDAcBrZbNsnoA0pT9kbiYOJFkqN4G?=
 =?us-ascii?Q?deNRInrDz3ooCDlAMxK01eNzb+ltsW+PKTB6xtegVQ0Ql5ols2lL5eWNSzqz?=
 =?us-ascii?Q?bv+Uh/NmaWjhIHtburStrQ9hy2Zn4cwJFs6HwwZ6fPcRYUugquFAqHrhiM9x?=
 =?us-ascii?Q?NOezjAmevAReWJNcRd0rxUeol/uzgKXKlaArH70UDFQRjne4JEFPPcpbtgZy?=
 =?us-ascii?Q?+mBp2wVUeqFf5QnRAbP+TFDaN9rTrtmC+Myd6YjHr5k3GUcxUoSDMyk1ajFi?=
 =?us-ascii?Q?EB4eobCDkYKeIDgu5I5b7UIBa9j8XyBekVJ9qhliRxyK91cECVYHHC4CbOID?=
 =?us-ascii?Q?UFlblyQIetOjGSSr1O+D9B3tzgv2U+na+s/8nwcX30z+qbD2R7BRxTRifVz0?=
 =?us-ascii?Q?AeznEAIE3+gp7I2h62QItx26dELhV9f1kAVnYCIYkPpLI63MiGClIMhlwkHD?=
 =?us-ascii?Q?OdElzVJUGA/0M+3NR/I9KODjPmmV6+oRTLRLUWeHLrgblE0+nO4Bg0FhybXS?=
 =?us-ascii?Q?WW4GKj9M2Z3hhYztBHKFSN1Y9NNrvndmNZYyFh7rFGM/KJ3jfMztrmnZnSG9?=
 =?us-ascii?Q?BF7EfjA4cflaMOy7bDHI5pMWIOm759q0U3/+JxYgCeUdc7jYqL2nfnShTyg8?=
 =?us-ascii?Q?K1lJcJXIpyEd8lQKDbFJ+HXyezTrnviYxAKIUnfEjS5WVf86ulmbo0dLccZj?=
 =?us-ascii?Q?wSVq/mWgPiFidcekw84QtRR78EsmozSj1ouUyebM7feHHmlG21+ZPE8w/wiI?=
 =?us-ascii?Q?l9wuj3u6Oep5g/MnounNQ4CxvKZxKaMKK24DTmlCfVNrgvQ0FoqiCXvlicXp?=
 =?us-ascii?Q?cszeA+NaKu+GtZ6XLmDc71bpjcoFAPsK6aiZHmgIZ6Qt/OI69kc2z2Dgayet?=
 =?us-ascii?Q?Uue9QMmPhg39VwA2sBpwSHnAUdBNUs0gsI9ybt4pnV1xh5eV4pUimEWpfYdD?=
 =?us-ascii?Q?eyoUYWcL5Z6uKtHLt3auCsQy6Y+ujfcrPhtlQsUwWiUvDMGZgL91p56e9ulE?=
 =?us-ascii?Q?t2KGTb4jkr07WGP+LJQak+Avl3fyi7rAb2rUa6VdfI5Oo72JXfhv0tqfyOrm?=
 =?us-ascii?Q?yY73X3LEcBc+CqiHZN11t0Uq+h7afswJ9sjKq9Esn78wOxBlz40RVVCEiWce?=
 =?us-ascii?Q?+IcEYK0izh3XvWJ+9iGrqv10qsBMsCSm4BI51ampbDly76s5/oOzC7jIirvh?=
 =?us-ascii?Q?8b5FF0CSZbI8DaLg2xuIRH65zaXp8zcUFbjQ6a1uLLP3qtHVJziIWsZpuIUm?=
 =?us-ascii?Q?P+uoZxRxxBPRL0slA+MF0BXWO7/cv1/4XGkP5ICf9H8XfEZpFeuHAzmAcGWc?=
 =?us-ascii?Q?Sko1W9LG2V1Pj36KMH+7hk7JI0tqpQOGkVqxYTNSTObsdp6RtYhruqP9qNUi?=
 =?us-ascii?Q?//vxlGuEXIRCPhhSEPXXKfxI6e+aqeu6Wl2iKSlOdyiHjKohu1J744KW9ACg?=
 =?us-ascii?Q?eoYn1rxh561N1Yg/X90hO7b9y+bt+K9zjEyxwOjEnURn/0Qv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 162ae1eb-3084-488c-acec-08de890f557a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 19:06:48.6068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GYWYSKexxkjXfeYumh0YFQHGdQs9CFpOyM2jhqjUjIy8czw0BSPFYWarJ0mVg1Eg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6813

Hi all,

After Willy's heads-up on the removal of CONFIG_READ_ONLY_THP_FOR_FS[1].
This patchset is an attempt of removing it.

The patchset does the removal in the following steps:
1. remove READ_ONLY_THP_FOR_FS Kconfig
2. remove collapse_file() code on READ_ONLY_THP_FOR_FS
3. remove filemap_nr_thps*() functions
4. remove file_thp_enabled()
5. remove related folio splittable checks
6. replace try_folio_split_to_order() with folio_split() in
   truncate_inode_partial_folio().
6. remove related fs code
7. clean up selftests code

It seems that NR_FILE_THPS is also used for fs with large folio support,
so it is kept.

Let me know if I miss anything. Comments and suggestions are welcome.

Link: https://lore.kernel.org/all/aTJg9vOijOGVTnVt@casper.infradead.org/ [1]

Zi Yan (11):
  mm: remove READ_ONLY_THP_FOR_FS Kconfig option
  mm/khugepaged: remove READ_ONLY_THP_FOR_FS code in collapse_file()
  mm: remove filemap_nr_thps*() functions
  mm/huge_memory: remove file_thp_enabled() and its caller.
  mm/huge_memory: remove folio split check for READ_ONLY_THP_FOR_FS
  mm/truncate: use folio_split() in truncate_inode_partial_folio()
  fs: remove nr_thp from struct address_space
  fs: remove READ_ONLY_THP_FOR_FS code
  fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
  selftests/mm: remove READ_ONLY_THP_FOR_FS test in khugepaged
  selftests/mm: remove READ_ONLY_THP_FOR_FS test in guard-regions

 fs/btrfs/defrag.c                          |   3 -
 fs/inode.c                                 |   3 -
 fs/open.c                                  |  27 ---
 include/linux/fs.h                         |   5 -
 include/linux/huge_mm.h                    |  28 ---
 include/linux/pagemap.h                    |  29 ---
 mm/Kconfig                                 |  11 --
 mm/filemap.c                               |   1 -
 mm/huge_memory.c                           |  44 -----
 mm/khugepaged.c                            | 159 ++++-------------
 mm/truncate.c                              |   8 +-
 tools/testing/selftests/mm/guard-regions.c | 148 +---------------
 tools/testing/selftests/mm/khugepaged.c    | 197 +--------------------
 13 files changed, 42 insertions(+), 621 deletions(-)

-- 
2.43.0

