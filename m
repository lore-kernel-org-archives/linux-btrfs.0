Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011044.outbound.protection.outlook.com [40.107.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5347E48CFC;
	Sat, 25 Apr 2026 12:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777118451; cv=fail; b=OnzfNy5n1yILQQNqYfx8JX5EDxmMA6zh1NDMM/YupyzbFHY50Dz6tWE+jFQoOYEHRQ2yCx8ZlU82pZB5pghivhqDNUlZxPQHp4UPaak2E9eV19+ZoxL7b9lkH1IKp1WA4euiXFZ+vnVgcJ5mVd87tzJ4QIoiGrwo8nNJVfyowoU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777118451; c=relaxed/simple;
	bh=2zWgXf6bJSYNOSOr3HzyoAmgGdd8J/ZYABWvmgzePOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NPYOzZkZwUP0hTbLkswv2VumQFVVsIKt7qE076xRDN586XcWaHbufRb3w3gaM54XJbTB5UzYX7vKkIjhkyQjRSIZKZXb+yNykAl3FaK1d3O0si9cC3vpgMJPsTs9CkxcayrK7QpOrxUVNiRXonq4LZ2N+enRXizL+0UICVRwe3I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cG04i6H6; arc=fail smtp.client-ip=40.107.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cG04i6H6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ihNgSU4d5RkozeIubLGYAeijB1N5ZAR0ZfVCJVaNiOLBO2luuGNvFj4s0pJ9MGCX0QJ4qKAch4vybnM+JxzHTjRd9oPwXCH+Rmt2pqew7iTHmJnc/6NUJ6kJqMvsQyUc/LUOy5WGqBobHeJSndlWkO2Foclu13YvmdDN6D8Z2Tc8JBrBXCTGnnVWlnBP6UIz8aMsYGETUa+lyX1AX7V0XbgHAhe8i7ph2JGs8i+QkxEwpfLufx1S45Y504eaCXMPeDVr29HP6jU0LaLtaqt0ecpkkaqLqFQ91NcEdfMb0m75EB4SfYOUDgZ1IpwJ8hxmMwVYRxWxquyFr2w3+rxm+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fHtdjaGcbUjrQWaR2bse8uIiTCMPzar0l7abrB5l0EM=;
 b=RmnO5OOn38oGjDbtUwBNuZnEv7lJntWYEa1I67aWnXL0tr26BE5XLvzp3uBEw+mp8Sto90xaTpgqxRFbFuKF7YXpsFUxBsVcVCk9I8gDuRmIhfrq3tWqrKEbco7bopSynQi1Dyde5yJTVyzBqDIscJwMXOq8kfCu1uwTQX+pQA0vRqdnXxwYbVR+IF1vmN5wk39N1+ecHjtxPI/Lxacr4UmC1hoXtY5I4PZUuLDV/HQI9H3NRM3v4mf4otVnQtwY0KDHiGX9pe0kgXL7Qx+aLiflS9yuQ4ueXPDk1nhrsDbxgIZ0Tlq3NV5TMhZZYwsJmxikQacQx8muOIiMnp2VhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fHtdjaGcbUjrQWaR2bse8uIiTCMPzar0l7abrB5l0EM=;
 b=cG04i6H6p+KQZaWgSORm/HrJloWz2Xy5OpwuPoNvyxBUSV0T4cywCnaN/fCChjzIBBFY/GtG4dZsEoNPKSTSca2zZXS+cwXcb2/kuvCK68zak53cqApI/H/IGZNnQLQ8nApZPk6TXs9ak8IMnfhyft38YROMuehaGjJVJs+bcrn6dO+OzijLi6L9seNyBTTvp/CRQnLd/4bqNB/dg9xOFkKyUcByOoUepa9JBBqDRRE6FKH/uNI6DfQ4KG9YwdAvbcGufZ007tyvYRT5kMOiX7TYuNkVrS7lR9hvSKEemhwa8eU2xDS4QsQYMRXc5vERPgxLmsRsirhvvq3l1JC+dQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA0PR12MB8376.namprd12.prod.outlook.com (2603:10b6:208:40b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9870.12; Sat, 25 Apr 2026 12:00:45 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Sat, 25 Apr 2026
 12:00:44 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v3 03/12] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
Date: Sat, 25 Apr 2026 08:00:41 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <74D4C50B-CB20-45B3-8E7E-E9A499701F61@nvidia.com>
In-Reply-To: <20260418024429.4055056-4-ziy@nvidia.com>
References: <20260418024429.4055056-1-ziy@nvidia.com>
 <20260418024429.4055056-4-ziy@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: YQBP288CA0037.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9d::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA0PR12MB8376:EE_
X-MS-Office365-Filtering-Correlation-Id: 479d07ff-e8ed-4640-1400-08dea2c247e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ze090QUzkOXdc7WgHm4XPX8N9pz7/I8f+Z/4SXZkAUee7vuiYeo8janGCH/z1a2N0IGBb5CC0u9CSG+Wrvl8kzRepCvH7W1x0AIRAtIiaeg4rcAW00lhwHNIyBLMaIj34XE7rXDfd5qpT5ds+iBDegRfYAnfjxiXlZeWhYaysZTNCUU82rvnHNii4K98kTRBB18M0bQgp3Ws4kSR6ZcehE4SiOjPHPL91hovFRb+Q/w55BGaqNFQwc+rwIoBZ6/xvJzgstiAWnxn8UQOBTkvALOi99Dv7DyWoG1StJScew1KoCdra0G40s7gojVjDw3exLwJrFf8xmwVbHA/w68LzAm6GAzz57SfQ2ds8oCN/8mz73KX/vPP6bVf/xxu0WvZ/UmkvwyLzNnPXSsGaQEoMvwKSqWJHfiQ2Z6jHe6BqsSfKMoy27VUTOvjww9ogY0k1BYLAHMz7rGE++L0NAAbDXpFNXmv/qdf2WFKCSa3FjmyGn3vXWpED9yuFutvzZjDv2qfUomG/cQ24DerVAr/XA2oEO0lxM7thWE8mihZIS0bJW4jEX482Sdmt59FDqmNF4lFQ8KJ/8E18Pg2XfYY1bdIqTCcTN593YP14jtrGXPC7yaY3HaGyxgM8gZqD8HuYHVndnT64fqVEIxY/yuw466mWHcjuSqunXYgoUoB+SVUtc9kW7YZcM/x0cRzdll2yoCpgWNIDaYvyJVmzYQiPXxEONZphzx3AIrvPFg5WF0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eQE7NXC5M/d6SkFus6k7pOzf+zitPSSaYT97ssa0WmzOynMtPKVjATLXcbFT?=
 =?us-ascii?Q?Uu2FEvIOIULiibxvxJy2GIqp0o8XwYC6ppT7UAS01DnBD7RN2iFkwvYB2gXU?=
 =?us-ascii?Q?n05siePvPeHurAJ3f4nXwiPF8+X47B09/PSh8ubhSru3ydH4ETaBXoY2kr5Y?=
 =?us-ascii?Q?wbX58DRdtH8D6u5MW4cYemJ688bxjIYFQR9PDnJD9TGqR0JfOInFcB6Wep5j?=
 =?us-ascii?Q?P5NMDCN7Q+u1z6F2MtOMIVokRWoHpKEIPY6wvXb1GP9vw81pVahsIU5zp6fx?=
 =?us-ascii?Q?V4FgHU3h1l2eqJN8yEMnXfoCPUNLT5ep+buzPNLQuU/nR3M4KRWl+bPwUX+p?=
 =?us-ascii?Q?6K3iXTQlaZEGfgGwEeGrI/IPPoKFW/hK7YtpA+zTutDQnh45wBcqRKYngPI2?=
 =?us-ascii?Q?j+6KMHa7o4QxKGiwMWArizxUcJTg1qrAYKR+sWiV8/qgX9XhnRS6ObrIl/Gk?=
 =?us-ascii?Q?vfnFtXEYVhXxrR0KQxgvvkGFYB9LLx3XE7ndswTvnAtEsGgZP2oru/BPaXG/?=
 =?us-ascii?Q?AaEugGzvK9wtATl+00LbOs7Oh0D/yNICuKbOsKuoauHmq6TyA48kVlCuKJgW?=
 =?us-ascii?Q?vCmJ8lFa8iCU52duZUUF8J0/spWzlrEAYB74ZmKDMF6A2TOLM9QzZ6PlJyTa?=
 =?us-ascii?Q?r30kVHYRBTlyiPKEFndzaXZrWidKsrFqGntlIMA7TnIx715wDRJh2iKYsoCO?=
 =?us-ascii?Q?/esGHOQLdSTpSBmmQw6cYMnWjCzaoCDEQi8dcUGf21p9lQzLz+c87D8UvaH8?=
 =?us-ascii?Q?SqqXmxbVWRdKcU9GQZWIwWDhAZSkCf+y1ssvzXRoUSBC8m6Sq75gQb1WWjsm?=
 =?us-ascii?Q?QZCqnOgTXsQw2FE9sIcdKEMct1uEZMWukarNpSPm/u8VzghXlad/s4n89Qkl?=
 =?us-ascii?Q?RC1cqF3rsJBBdAbmQ56iKzgrW1P39bhJw0GnmPh7y83EFEHNhYZ6h+A91Byj?=
 =?us-ascii?Q?gdr7T5entrO6rJDPz+g+P7TThh7FtbrOh9qG7Kr8JzbtxCzOFBZ4tUebs0Oe?=
 =?us-ascii?Q?xv+2iM5JzzXI1sCn6HpJHzPf0mGV1+SVKWIGOoQghA/ezTcsEFWfezdAEo/v?=
 =?us-ascii?Q?sd6UKWdR5N8FjqjNKUJ512Pq78LERIt39qj05HWydij7iyisq4lTXxNYDrya?=
 =?us-ascii?Q?Xc3ySJJTx04evijrAkvuN8cW9y+OzQS+mr4iYd7HFUfwDOxnjHv3Up+UMCu4?=
 =?us-ascii?Q?5jNhs2nof6Aoy3uMw7TvtMqefYKv6WXAAkeKfusmZ9IO/phIGgU7QgF6Iz8k?=
 =?us-ascii?Q?nP6QXt7sgshqoCwvuvQpQd5kzZI5OIwR6lD/ceJ4ipjJcq0EsC5ac9Q8p/Aq?=
 =?us-ascii?Q?UaPSCQdL8k9LdljbDCTSQd49/yPuXYDGxW+sYg+XNKkX37COdyk7FVivLSEb?=
 =?us-ascii?Q?besdKumxumIIVN6JKz6g3/521YgrYDEQ4uezwiXOx43QFIVu4y/40RycDRhS?=
 =?us-ascii?Q?0ofg9ujxWoFH9KDAumBztQJ17yP/2Dz1o61hNHEn9vGRURIfk48g9lYF7dYN?=
 =?us-ascii?Q?b5otJNSwiy60q62l83s0D66s+lBLHVKwr0aZRKWi2C0I9AW9WZHRAbTLDElJ?=
 =?us-ascii?Q?DLPxLzUDgJEpFRjoU902II5PmLpp9qkuUCDUIECcWG+iJTKyHw3Kna3KJy7d?=
 =?us-ascii?Q?bl1tem8km8o8Gf+Znpr7yFXXTzpFZt3XOEP9YGbtrmkEiazam5ufB5E0TPJW?=
 =?us-ascii?Q?shp1Vl/xvnvFrC5bDGADs7CILMtyZxO2fScG43BFIElnuPzN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 479d07ff-e8ed-4640-1400-08dea2c247e2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2026 12:00:44.8332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DxjH/k6dtRZPNhiQyHCblIHpahliPXtj7an7Kyf8ozBvDOk8t+wMjeYj8rQRIK3Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8376

On 17 Apr 2026, at 22:44, Zi Yan wrote:

> Replace it with a check on the max folio order of the file's address space
> mapping, making sure PMD THP is supported. Also remove the read-only fd
> check, since collapse_file() now makes sure all to-be-collapsed folios are
> clean and the created PMD file THP can be handled by FSes properly.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  mm/huge_memory.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 970e077019b7..7e9cf8c0985f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -86,9 +86,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>  {
>  	struct inode *inode;
>
> -	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
> -		return false;
> -
>  	if (!vma->vm_file)
>  		return false;
>
> @@ -97,7 +94,10 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>  	if (IS_ANON_FILE(inode))
>  		return false;
>
> -	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);

Hi Matthew, David, and Lorenzo,

After some discussions on irc, I feel that we probably should not allow
read-write fd for PMD THP collapse at the moment. Combining with the
filemap_flush() under folio_dirty() check from collapse_file(), khugepaged
would become a kwritebackd that scans pagecache folios and writes them back.
If we limit it to read-only fds, at least khugepaged would only write
back once for the pagecache folios from these fds.

I am planning to restore inode_is_open_for_write() check in the next version.
Let me know your thoughts.

> +	if (!mapping_pmd_thp_support(inode->i_mapping))
> +		return false;
> +
> +	return S_ISREG(inode->i_mode);
>  }
>
>  /* If returns true, we are unable to access the VMA's folios. */
> -- 
> 2.43.0


--
Best Regards,
Yan, Zi
