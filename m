Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012050.outbound.protection.outlook.com [40.107.200.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F0D346AD7;
	Sat, 25 Apr 2026 14:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777127277; cv=fail; b=jp3DsmSMFiyZHhuzXH0iQNgb9Nhk9J8DKWmo1N/hZVb/x6sNQsFSlr3F5wmAVJ4Qm4ek6w4h0gMgqIoat6XukBDjyebnzGBDgG9zKXNgWA67nWp+8Lg1oUtKWi3DLv0fGTBAhZBpcMP+XxS0NEA8icvbK5lUwa7Vkjxc1sE7rAw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777127277; c=relaxed/simple;
	bh=I9yXbhI+7So4mVwFhSePcNewX8EJ9QVvK3qZiEMgkRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sQ+vNmtFTUY4o9of7uxnHiC5uFGHZI5D/YPuCMIRvcCLxEy3Bofv/DjYctGAJuaAipo5YX+oFxaC1uFfb5epqUVGyQVlX0Q0UwU5TolsVzh8FINZYpP6Fv3qMIWUVyUJ6CThypvTKJJ+/PSj1n7E+twWmKpENdcSw+4j2j/rKxk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qsjbG5Id; arc=fail smtp.client-ip=40.107.200.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qsjbG5Id"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cedXXabQ8QUaXDc6346OKrOUdb5IS2GVzDliOrowmk0HO2OTeQq2QcI8QIOJtpGcFlOcq+JHEte2zEqQ6ahuMvNWAH1YU2MLfOWpaNhHdBr/QXDe0hYCEzfB0bLbaaBoDxRE4qQHrdegyOd2drd38E0M3/pOLQM5gVLofryXeHV7sMUJBrWyI2sqv761YqYWKprh70psql5IgWAgOO3aL0rfUaRxpDkkIMqKJ2cK1eg1+KdDlG4E5WbQy4uyfr6TtaWKnCSsT46vkt5VHTFIIN4EaoLjzZrRfyXe0nICnb1sttksrUDzk/hAgktuxHHc9mbjd8mWZlLLilQoRRh2Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4I7G0gzy28M9M3RWZPsH3WpXWyhbhZOEoZSDRTISK7U=;
 b=OtONey0yQgp6t3YsNjjTAvBZsUqCLUEX+U7PVAXh+sxI99rrFfsMKjYm2na1NaeacvMTYyLtcbVoAiFNlM5StJoJzJw87F+eH6T93WLLXgzVp7ozThfZjAPrTP3nXFaZR/WdSIoTBvu1Xg8Jq93UhVbo+xzmrvYpffd225e6FuDAhTa66Uylzr+XOeHxpna1/h/cVmTsjWBE6qi7q0bgWAiD8pIpYhlR+GV+rDjU3tkG1jdnOcLaFySA3lDicutsu/tpFdv98RxupNwvHlMAnsrxdZ4IYmck2DEbn07xxzGd7N/gzgPN1d03wp+oaz/59kS1V8jNntj4lOaSVkUiEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4I7G0gzy28M9M3RWZPsH3WpXWyhbhZOEoZSDRTISK7U=;
 b=qsjbG5IdBN4s73CRrjIAluHnqkJLa2nwcCJN9HfEug9RPihIWN10qXyo5/WiH66BZSfx0beqvJYCCSu6qvIQPh1JRpsHlshMFlqVfKbeVTvRA2oHRpSpGpebYLd08WvHbrbGk2IxTdfuavNjJ55WgRKHWSXE9NzhjLxDy1ZN0o4UEbh4wUEJij6AeEwrSf+y6JZiNO1dn/xKWVwd/MlBpRUInKw7+QG8rBBLkc8oI9PcTunwt9Lb1MKiu0kzz115+52JdTVoCv6xpEDFrd0tEez+S1RJYG8bxmYu55Skqd30MhUsrUFqJ81yxMrHJu3LNtnsglBt2kjYWLBabO1eSg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH8PR12MB8430.namprd12.prod.outlook.com (2603:10b6:510:259::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Sat, 25 Apr
 2026 14:27:50 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Sat, 25 Apr 2026
 14:27:50 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Song Liu <songliubraving@fb.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v4 03/12] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
Date: Sat, 25 Apr 2026 10:27:47 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <DDB6CEDD-116D-48C1-B558-D64CA2F58F55@nvidia.com>
In-Reply-To: <20260424024915.28758-4-ziy@nvidia.com>
References: <20260424024915.28758-1-ziy@nvidia.com>
 <20260424024915.28758-4-ziy@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0124.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH8PR12MB8430:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a25e2da-e160-4689-463e-08dea2d6d472
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	bfzVzlEa4RbvTF2Bz1fUktR6oeE5IUKi/hDU/8K380w5dVQJ0c6yElwbg0CZMX5/e93lF46EyJGU3TQv4UwiAs5DQVAVxlg1y38RPzvGhd+OWt6xA84wB+LVbwVarZ+UVwRglk1eozTHVU1phDOHJGkB271QBadXLWx9RLpbabCvLbFsyaxITChxinyaB7ECEIKNtb7VzmjNdlsDByzVjkcnNHQsd4VSiIz0QuYjMGekDSV6c4K5dgYOaTEz1OsRMCEEKsz1QHn+TU3KuLZHanUrzXNkQks4w0x70yZ9Liu/15n8EKkzs4jnUF3HyjySq9NA6Too3J/47viGdEzV/xsehiRdnIP5mb61giqaPJcuFVeZRQiB3wUoJYyDSNE+/bEKNq3z6HhQdA3sIxkenIe8jzH3m1oAkBVtV+FuGXjlb9Jy0c9HLBTmC66TcUWyf2ADLaW1nKAE/es7tSTxZqPCl3VOFi/8169TUatjP/YgbU9W5Ua2n+GUObHIPoBD2s02d9/sMev+6TgjDvF5G1acUws6ywsWf06pW/myohBtDK4SgZ/iJWWOxxbnB10ynQRzNtlQkxP3j1PPU6aNSnCBB5BEMRPasQcrZeaNR06M2S/YqESA5aODIekhWd2HRwRzYgAA5IFUFi+Ixqd5Lr0oIHRpSnXespmhpCByhPKgF/yiCgmStSxGa09p/vqoMo2GSWiHrGKWIqP4tv9GHgi6L2d8avAVup9B1+4sJC4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TTMAg4x494vRUiY+0+FGQqTby6tlM66Ytll6qX9q8cMejXqa1Y5uZM4q4Kcd?=
 =?us-ascii?Q?Ze3RB+x8xx95RvG9hhkq0+2A7wRqYzdn+fMl6g4UVe7SafBwH1Gs/HxajvXU?=
 =?us-ascii?Q?ClnzN4XbHPB/ftDsxqE7P9/8B6MQhDto/gZ/GSpxVTz4vyBARETpqMrJ/Xx8?=
 =?us-ascii?Q?JWsvlDwOwy27RQoKR2buOKIz/Oij2seY5cNn4kqKmLqQFJCVx1El4FMRVQB2?=
 =?us-ascii?Q?46BSQoRyyoLMp0IeXBz9WOrDeNf8IHLL7Ykbs5GS+oARWOqtSfvoNFIHtvtE?=
 =?us-ascii?Q?q6VsDWqB7+W5znj2F4OoTeUUiSPPqJcnfoGRsO98/rg1swQzeZNIHvUN23Z5?=
 =?us-ascii?Q?loop4TJRSmWT1V/F4hBcG2N5JqIfPgBV8iy5UKWI2jw0PzpTcChxdDjOrZ6u?=
 =?us-ascii?Q?PkSOtQ2cfzmaBxBs+fxzAMYjryGuhvQ/SjKa9VGDojPE4eNs4jZlGfR3l85H?=
 =?us-ascii?Q?qFxQA+3E+FyjPUmnhtBtK5I9NHFBmZ59rqjNwdBFUo/r0ccAsNZ2gjyAqq3s?=
 =?us-ascii?Q?KoyDX7Bh8BEm+HQo0jQ2nyef6WBqC18rdU/lSkVBFUQoZ27twkfTyos7LNhy?=
 =?us-ascii?Q?4pTLTuubBhwaPfnxUeWKpH/0yxbu8qou3MWTbJZJPb3bsuddjSrgxFvAE5xD?=
 =?us-ascii?Q?emg+LzFjYfjulXTgfBYFfz9ljXabWbhLUhpeAs+Gg+EQWxvzwGIce26JCr+Q?=
 =?us-ascii?Q?Uv723jEIbj1oepkxwmnQm/ZkktizsYen53Xqnm5HQ0P9jOqA1cT3PNOFOkm9?=
 =?us-ascii?Q?/3G8S3q8CtzDQ70bf+nb4TpezttWMaQ9XJFZ8MzQw0vu9SshZ8L2vEfSxiL+?=
 =?us-ascii?Q?dA3MQRZ4wvnpHat6fVKy8+Ds68I8wXUI/ke6hxiGwziUZ8Z6so3kQeLWfI95?=
 =?us-ascii?Q?lU5Dv1Hx+1xA+GLwFFglfv7hqEvqrgZxgZxPn+52+1LN5L+BBLqu5tqIhYUk?=
 =?us-ascii?Q?KywUNdwhoUe/aTO6pSCGV8jxSW660ndtFySYa9rlUVRfFE/PpWHklU9ji4EZ?=
 =?us-ascii?Q?j09Hbzbg1gj7Sodx+IaFR0uYndrpnvWWIHPeSykeMbGzm9hdC7dtGtYx9aC6?=
 =?us-ascii?Q?+3DgIxunZjAOuLtzYr0AHN12WyTHhSjsg+Du92i+L1LQfsC9eoT526+4uy8f?=
 =?us-ascii?Q?YJxHTpbn1V8Y4wBxvfQE8WRedSOeiXtDb9MUADmINWze6EHxRD7pwntDDZ8E?=
 =?us-ascii?Q?EyCxetlNB6nLU/nJHor40sniC97UmBnfXmfpxOjytJ6niperoxkvy0hJiMX6?=
 =?us-ascii?Q?e6Lc8INjOfn8/6RoJGbMkU7W6cHpA0v8ltXmTNVyeX67NSW7dS15aNQF7Uqt?=
 =?us-ascii?Q?0U4E/XQLfcrcxSAJCX50Qj9SOMALwzqpaQMxATn1ZfyAjvd4DAOood2+/7JJ?=
 =?us-ascii?Q?XJwy5ki/DOq6M5PIOX4C2dHZ0/b8hLuol1aUWXuRW6NlwYd3pdH+uh6JJhyj?=
 =?us-ascii?Q?7nLtzBRWYxQ6mHzY/CG9W+HOdAh7L29iRJqeaROFnBhWwMNLvZ2woPW0fnjP?=
 =?us-ascii?Q?7Vy4uutVGv4gjBOrJG5cIMwr986wthpHjpPpQUOt4RQ3L6/+V6IAWRSYRPwb?=
 =?us-ascii?Q?haNm/+d4M3G6sJzLBwgFyu9RSOq3XI653iDOBmUkTdBIIXjvYPbTWA/IXrg+?=
 =?us-ascii?Q?rnsWq1chDAHaYr0t5vFrLFzlQnGPc4ebi7nZiIQRxFFi9BasBqpKJ+MENQWX?=
 =?us-ascii?Q?jJPAPIZseHdaBEDB1w/xxG5V+Dj9fkWvW+YxNldt0r4ymikg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a25e2da-e160-4689-463e-08dea2d6d472
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2026 14:27:50.5048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gidVHB2pNo54iRLERZA+cdXGDs8E9Mj99bqrbrsyBca+reMHUZegluaPrNHDFmKi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8430

On 23 Apr 2026, at 22:49, Zi Yan wrote:

> Replace it with a check on the max folio order of the file's address space
> mapping, making sure PMD THP is supported. Also remove the read-only fd
> check, since collapse_file() now makes sure all to-be-collapsed folios are
> clean and the created PMD file THP can be handled by FSes properly.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  mm/huge_memory.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1f0d0b780943..f0db1390a18f 100644
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

(resend to V4, since I accidentally replied to V3, sorry about that)

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
