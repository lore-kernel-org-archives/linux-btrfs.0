Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010053.outbound.protection.outlook.com [52.101.61.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7B586347;
	Fri, 27 Mar 2026 16:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774629031; cv=fail; b=WTrB2Sw98FhOKJinyzOrwnP/cJsHFiCyu8SRC31h8LJbCMerxVls4zCjCSz2agPlUYmPxl00sckwaNvsrx3qUzEdxD6EHdPPvbAaYzmzFLQRQvWk56QIGzrLg7CiYZZ6jrn9DDz84+K/+mlDIcLS/LA4AdvPCNx1oOMow06nyps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774629031; c=relaxed/simple;
	bh=G+mOYU0LT/8iA+jb2T6Uzq62voo/OFo9moQrFVUdc0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hLVsT7NNqCWUAch7eEqaafuM5t2us77x16unXj5uqxMBzie6+9E0z4OYJzmRcJIlcSuieu2qFuWxGbYoPqlbh7OLlTa2tdiJVCCiQ0/yPJciZ0RM/GN+lA+mqLloyDdA/cCJdKD3aLNpdFmlqbBTFlKNWdQxNC0O/iDssQYviFs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PM7K5lLk; arc=fail smtp.client-ip=52.101.61.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PM7K5lLk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=es1OcFA/CVxNjzPqybpWWdV7kG10scY+CM3nUo45wOGSKVUo83HjhPP41gka0qHKdK2rMzfnUhi9CuDk/VfBg0e7dVpF30jcGBIP/2lXE8cHdup1J7S7Oa6D+1oCbLqAjMRw4A3hAJ23qjdBQJgBhbbfEAIBGtVRIOAAm3aJjpVzLs+e8YsxDMlKs8ry4SrCoi22xT4FcasuDRxgA74qbQTDVBGOZFkAm0x0B4ubMcEjfsI+TNZGlsHLN5Mpe2H2AAHPJEAT96i+us40xtvQsxBkR80ngwoafI83/rzS6aX+HwEC7x/v1NH/iCryUyQsyHxdV8Zd4o9VGmPqssw1eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y7VFkpmDXgvGuurPOWQvkSQM2TK83GfxleL9+tWwhZc=;
 b=X2CnRzB8p5w/zT+KHqUiOt2sQ+du3RhCTtJTY+D2fgaHuLdXa8f9oMlyGYbMNL2suuTLLpvZQaxvwMEfmyvErFAPEYmnUF7sUyNJ9/sk1T9h2V2wvULW8sjPOSzfY8kxm1zV5XM9D2T+UzaqAOQnqfqKhkMympy9sGs72A3t56lZXuJQPCNFH41J7qw9wOSWwy4QKrsZ+s9wP4iCmC+PBauaY3QJaG1Om71gaT1YPQxa0k8kOu3ja2W13KQRafGqtR9vFmz3wubsVtbGl+f7POo5wcOywLYiEcHwfn1Jw/tiUnezmDrQaj9N/1kXg8fPOZ9ZNpNkkmac73pV8MXdGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y7VFkpmDXgvGuurPOWQvkSQM2TK83GfxleL9+tWwhZc=;
 b=PM7K5lLkCREb+dJOUoJbA3PL+PuSmN9ioQAQ5aUDYXLcAfBgFgr9IWda4aKQs8lAMzeeqD1zIpEbHGYg1hQRSzcq1R4Wcmxcke0VGXo9BnBkbmFkNilLqsh/2ThzwjG3ROgWX42kfqp8863wEjEGjEQkPFPbv1ekduwZKaHBfUWoQnu76hO+0XGjJVfhxcta9Qc0vO38wTlVeERsefqLywG77/OQXDFO7rX2PKjaUnJhOHHAmvMI9ujtB/DyxICQWZ95wqaDwgbdU6ezz9T+2fDYfuNGCEQ9qg2pVNHntMyToAdHDHiczoLkHEWsxgU+HURQMSJGE5d0WQwJ9kW6Jg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB9251.namprd12.prod.outlook.com (2603:10b6:610:1bd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 16:30:20 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 16:30:18 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: baolin.wang@linux.alibaba.com, ljs@kernel.org, willy@infradead.org,
 songliubraving@fb.com, clm@fb.com, dsterba@suse.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, jack@suse.cz, akpm@linux-foundation.org,
 david@kernel.org, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 02/10] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Fri, 27 Mar 2026 12:30:14 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <79053B0F-8A40-41D0-8539-0CC30C903B48@nvidia.com>
In-Reply-To: <20260327162252.57553-1-lance.yang@linux.dev>
References: <6FCC0430-C98D-4D7C-8C53-F7722F1BDC4A@nvidia.com>
 <20260327162252.57553-1-lance.yang@linux.dev>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR01CA0040.prod.exchangelabs.com (2603:10b6:208:23f::9)
 To DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB9251:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d5d0854-3959-489b-4e9f-08de8c1e21d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	2zH6Dos2UbMAy+Ng2eiRE3oY/AJyY+Dafy1UoVmmcs54+Mhh4rSw74URQ+v4BprnRHG0oyegIyTinTPxbkQUUXCTc0DRjP4fLhTAmHh4DMopO/4ZVRFFUn175y5tiYPPQNS4Or++xmjJ9Yo0oJq3XVTYSbqFHJDC1/qetwoJXsnSN/F/814/X3Upnn86TVxGvw0gRTKmG9WL4l5NWIcLcaZhRJmRHEkYQM4aj+KgNXHGdiemnI4CqKwsn1htXsy3KJO2GQ5IiD4+6RdZG473Vl1tf3r06NQ5UPkrNDpi3G1xHjNPX0ZdyXaHuh0jwSOtfVDqT2Ds0hfrXLSXHTC85hxfwViooJt5hBiW9UcSIb5Vwmc5QCDKLQrw/hmc91KF0XoH2i17A8hSLFQ8pYxw3dyrxu+pTBxPPdqo+GNfpdaP+qhQMNOq0r0otA7bGXXa7aa0i/0Rk5k90N5kbVtq/OqGBbb+XBAzFl+6pdpRavllaT923+h5be8xK5xE48LVYJTr5xUoXj1ZF9wJRfr0FuaOpu40jR8tret0ONO87l70wgFLwiWyDR+9CZ8KXQ072l5RXhU4ZanTVptiQ6lhCjesqOVN5E1JgPkHHcSt7sHsUNvAAIkGhy/RVwit7q1KSI8cGVUav1UPLpgoSb9WWQZBh3P3qjQ9Ma5tIhTUvPIYe++oQqXAJ75tzpVkVmd5o3Jl9yqnOJC2ZKzMIMniEaEbwb/CcbfskkcYfJg9MsU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lA4SGgZBMiTqijBi/R2w28RsV6rugztVVo91qmdY01STt9F6gJB/i9Fotyyt?=
 =?us-ascii?Q?y9EXX34/VtHcVqLEdN9b2r95+ZHBLuZz6wgiiZhSz24O19wgbVb9RYgz7aCf?=
 =?us-ascii?Q?4Q+1wa4nvG7AnJUFkQqI/vedNxwAFF4EWmj+0+B4jWEipf9/XVnrB6Mk/z6p?=
 =?us-ascii?Q?GfFR9N5/FC/mhJVDG10R7uip//01jSbvwl+udtt1eNY5ncfnRbDvnanV1vPW?=
 =?us-ascii?Q?2k3INoeM0gz9K3fOFrXpilcH0JqomIZJ+GeXEbo5biAGBOWXKuwavNmoTBIH?=
 =?us-ascii?Q?mM0RBuf4j0WDWTX2CFczZyAAAopL/ZKpDtd5DV/sJ+uV7wdUMV1czsHw6t84?=
 =?us-ascii?Q?+dKvCxQX7IdFJOnM5nY0TAUYdu3uJ2hnWz2C/yvs8btXhzFfjfp1Fd3BztzP?=
 =?us-ascii?Q?VMR18+sQsJai6YX4LhrISHBeSMWteQEMd68kMVwKuNZ/gEVI2H6gm1zZgOIW?=
 =?us-ascii?Q?atX/Q2spzM6tzPh6V31Aj5CwLq1lo+bym+hsmeg0f8VAn40Qr5eUKzr8Yj+o?=
 =?us-ascii?Q?JnVci8YlvRykp43w1SAh04dSWgz09/BBlgd9apXny+hQUiCu/qZD3lgKPNqi?=
 =?us-ascii?Q?xF0caUNwKusTWNOo+usHUxeZCeEa48ul5wYuwwpZcnlVVdilcVuhTzTBEwYT?=
 =?us-ascii?Q?2ieEWxIgjRGBwhToKvOEelb6azDRbBr+13VzeXUDLkQMoB2SDYIWlM1juqM/?=
 =?us-ascii?Q?M0wkguNJAa8A2ib67VBPaMTWkzjbPaiqhhdWxt9JlQz0kM49haonjCWWel8W?=
 =?us-ascii?Q?sl6URxgNIK6aG0+wETDETC1VMJAW+n+GU4XTT1YiAlJ/BSDZAQmr6m6aq9bc?=
 =?us-ascii?Q?QH/BOuA5UKrYiHaFWoJGcXZa17HMQYiiB6IlU1HnWqmNeEM7aTYmiYEqtLCj?=
 =?us-ascii?Q?3xar7jjSGVESDkYvh93UuQC0AtKgD9lWnwNcybVLzDcq1+4jcnc0/jKyNF7J?=
 =?us-ascii?Q?S4hxoHXJmF6KDTdxXjZy7NbYQN+IijB0sggbK/Zt/c0+6k07WaT5rJ+gYnfy?=
 =?us-ascii?Q?iEqsJmjcKURfT0ZswnqSOs1huOaA0uxKEa+l1OiNDxEwX8snirjmQIZIw5US?=
 =?us-ascii?Q?+/A3KOC6VQuTVC7R22cMbv5zJW0QPX94YBVGA7yBCppEp/3o/Yeul15ldBfz?=
 =?us-ascii?Q?UoG1j3+nBz+VvUQ7DHVG6Ol2wGYOHSUrte6HUv2Dcuz2UBFXU5aMWHYk5w8n?=
 =?us-ascii?Q?NXxdNlwCooNg/maxeUMhlya48Vh+30sCxsR+HwH63jnxFlQgMG2mQCH9Sj8D?=
 =?us-ascii?Q?j4YAclbP5aTg+iiUfAk/6aYFY57MV2R6Xnl+oGCk7ujQVuPyouvHe5Gd76H1?=
 =?us-ascii?Q?Lp5TNd+6rXERNf1h8cuVvWC5o5LMhcXQu/Adqrra+zqaMsNk/Z3BG83/moWj?=
 =?us-ascii?Q?bSprbheREgjl0SuGLneS9NfyR7+fd8dpnd/2s/WfkbTa04zHrCY9qDvqdf2C?=
 =?us-ascii?Q?1dV8zKPqagwAvwphFE4pM7Nvz5z8+56BsEev2KasYPcYMLvugKzbY83rk3rQ?=
 =?us-ascii?Q?I3F/ptokIp1KU7GsclVPBIvl9tmQnHfh2KsgjAKR9Jx4jGsqO3A+lVgxWJhD?=
 =?us-ascii?Q?EcNj0Rz/6pCwsJrKLHAEdJOpmaBgdwJSyJyVhe4FPH0gbolR9eOVf5MTG8ja?=
 =?us-ascii?Q?a+1i4hATVhXNL8w9BFNuf2UB3d0Af1zjr0/hk80xjEl81vMC+8A3Jd3TFf0X?=
 =?us-ascii?Q?ZQcl59FSUqr7A1fZ4lxJ+QnEh+gZOGDAE2nk5Evdb7vv82dDYcXiT4p/E1J+?=
 =?us-ascii?Q?+xsozaAG7A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d5d0854-3959-489b-4e9f-08de8c1e21d9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 16:30:17.9527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y8EGAuRc5TR8ENjTtToDSGkqjADghWGB+QyobHvsrfHn6K1E/sHiotsIxF9Yyvs5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9251

On 27 Mar 2026, at 12:22, Lance Yang wrote:

> On Fri, Mar 27, 2026 at 11:00:26AM -0400, Zi Yan wrote:
>> On 27 Mar 2026, at 10:31, Lorenzo Stoakes (Oracle) wrote:
>>
>>> On Fri, Mar 27, 2026 at 10:26:53PM +0800, Baolin Wang wrote:
>>>>
>>>>
>>>> On 3/27/26 10:12 PM, Lorenzo Stoakes (Oracle) wrote:
>>>>> On Fri, Mar 27, 2026 at 09:45:03PM +0800, Baolin Wang wrote:
>>>>>>
>>>>>>
>>>>>> On 3/27/26 8:02 PM, Lorenzo Stoakes (Oracle) wrote:
>>>>>>> On Fri, Mar 27, 2026 at 05:44:49PM +0800, Baolin Wang wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> On 3/27/26 9:42 AM, Zi Yan wrote:
>>>>>>>>> collapse_file() requires FSes supporting large folio with at le=
ast
>>>>>>>>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.=
 shmem with
>>>>>>>>> huge option turned on also sets large folio order on mapping, s=
o the check
>>>>>>>>> also applies to shmem.
>>>>>>>>>
>>>>>>>>> While at it, replace VM_BUG_ON with returning failure values.
>>>>>>>>>
>>>>>>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>>>>>>> ---
>>>>>>>>>     mm/khugepaged.c | 7 +++++--
>>>>>>>>>     1 file changed, 5 insertions(+), 2 deletions(-)
>>>>>>>>>
>>>>>>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>>>>>>> index d06d84219e1b..45b12ffb1550 100644
>>>>>>>>> --- a/mm/khugepaged.c
>>>>>>>>> +++ b/mm/khugepaged.c
>>>>>>>>> @@ -1899,8 +1899,11 @@ static enum scan_result collapse_file(st=
ruct mm_struct *mm, unsigned long addr,
>>>>>>>>>     	int nr_none =3D 0;
>>>>>>>>>     	bool is_shmem =3D shmem_file(file);
>>>>>>>>> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shm=
em);
>>>>>>>>> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
>>>>>>>>> +	/* "huge" shmem sets mapping folio order and passes the check=
 below */
>>>>>>>>> +	if (mapping_max_folio_order(mapping) < PMD_ORDER)
>>>>>>>>> +		return SCAN_FAIL;
>>>>>>>>
>>>>>>>> This is not true for anonymous shmem, since its large order allo=
cation logic
>>>>>>>> is similar to anonymous memory. That means it will not call
>>>>>>>> mapping_set_large_folios() for anonymous shmem.
>>>>>>>>
>>>>>>>> So I think the check should be:
>>>>>>>>
>>>>>>>> if (!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER)
>>>>>>>>        return SCAN_FAIL;
>>>>>>>
>>>>>>> Hmm but in shmem_init() we have:
>>>>>>>
>>>>>>> #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>>>>>> 	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
>>>>>>> 		SHMEM_SB(shm_mnt->mnt_sb)->huge =3D shmem_huge;
>>>>>>> 	else
>>>>>>> 		shmem_huge =3D SHMEM_HUGE_NEVER; /* just in case it was patched=
 */
>>>>>>>
>>>>>>> 	/*
>>>>>>> 	 * Default to setting PMD-sized THP to inherit the global settin=
g and
>>>>>>> 	 * disable all other multi-size THPs.
>>>>>>> 	 */
>>>>>>> 	if (!shmem_orders_configured)
>>>>>>> 		huge_shmem_orders_inherit =3D BIT(HPAGE_PMD_ORDER);
>>>>>>> #endif
>>>>>>>
>>>>>>> And shm_mnt->mnt_sb is the superblock used for anon shmem. Also
>>>>>>> shmem_enabled_store() updates that if necessary.
>>>>>>>
>>>>>>> So we're still fine right?
>>>>>>>
>>>>>>> __shmem_file_setup() (used for anon shmem) calls shmem_get_inode(=
) ->
>>>>>>> __shmem_get_inode() which has:
>>>>>>>
>>>>>>> 	if (sbinfo->huge)
>>>>>>> 		mapping_set_large_folios(inode->i_mapping);
>>>>>>>
>>>>>>> Shared for both anon shmem and tmpfs-style shmem.
>>>>>>>
>>>>>>> So I think it's fine as-is.
>>>>>>
>>>>>> I'm afraid not. Sorry, I should have been clearer.
>>>>>>
>>>>>> First, anonymous shmem large order allocation is dynamically contr=
olled via
>>>>>> the global interface (/sys/kernel/mm/transparent_hugepage/shmem_en=
abled) and
>>>>>> the mTHP interfaces
>>>>>> (/sys/kernel/mm/transparent_hugepage/hugepages-*kB/shmem_enabled).=

>>>>>>
>>>>>> This means that during anonymous shmem initialization, these inter=
faces
>>>>>> might be set to 'never'. so it will not call mapping_set_large_fol=
ios()
>>>>>> because sbinfo->huge is 'SHMEM_HUGE_NEVER'.
>>>>>>
>>>>>> Even if shmem large order allocation is subsequently enabled via t=
he
>>>>>> interfaces, __shmem_file_setup -> mapping_set_large_folios() is no=
t called
>>>>>> again.
>>>>>
>>>>> I see your point, oh this is all a bit of a mess...
>>>>>
>>>>> It feels like entirely the wrong abstraction anyway, since at best =
you're
>>>>> getting a global 'is enabled'.
>>>>>
>>>>> I guess what happened before was we'd never call into this with ! r=
/o thp for fs
>>>>> && ! is_shmem.
>>>>
>>>> Right.
>>>>
>>>>> But now we are allowing it, but should STILL be gating on !is_shmem=
 so yeah your
>>>>> suggestion is correct I think actualyl.
>>>>>
>>>>> I do hate:
>>>>>
>>>>> 	if (!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER)
>>>>>
>>>>> As a bit of code though. It's horrible.
>>>>
>>>> Indeed.
>>>>
>>>>> Let's abstract that...
>>>>>
>>>>> It'd be nice if we could find a way to clean things up in the lead =
up to changes
>>>>> in series like this instead of sticking with the mess, but I guess =
since it
>>>>> mostly removes stuff that's ok for now.
>>>>
>>>> I think this check can be removed from this patch.
>>>>
>>>> During the khugepaged's scan, it will call thp_vma_allowable_order()=
 to
>>>> check if the VMA is allowed to collapse into a PMD.
>>>>
>>>> Specifically, within the call chain thp_vma_allowable_order() ->
>>>> __thp_vma_allowable_orders(), shmem is checked via
>>>> shmem_allowable_huge_orders(), while other FSes are checked via
>>>> file_thp_enabled().
>>
>> But for madvise(MADV_COLLAPSE) case, IIRC, it ignores shmem huge confi=
g
>> and can perform collapse anyway. This means without !is_shmem the chec=
k
>> will break madvise(MADV_COLLAPSE). Let me know if I get it wrong, sinc=
e
>
> Right. That will break MADV_COLLAPSE, IIUC.
>
> For MADV_COLLAPSE on anonymous shmem, eligibility is determined by the
> TVA_FORCED_COLLAPSE path via shmem_allowable_huge_orders(), not by
> whether the inode mapping got mapping_set_large_folios() at creation
> time.
>
> Using mmap(MAP_SHARED | MAP_ANONYMOUS):
> - create time: shmem_enabled=3Dnever, hugepages-2048kB/shmem_enabled=3D=
never
> - collapse time: shmem_enabled=3Dnever, hugepages-2048kB/shmem_enabled=3D=
always
>
> With the !is_shmem guard, collapse succeeds. Without it, the same setup=

> fails with -EINVAL.

Thank you for the confirmation. I will fix it.

>
> Thanks,
> Lance
>
>> I was in that TVA_FORCED_COLLAPSE email thread but does not remember
>> everything there.
>>
>>
>>>
>>> It sucks not to have an assert. Maybe in that case make it a
>>> VM_WARN_ON_ONCE().
>>
>> Will do that as I replied to David already.
>>
>>>
>>> I hate that you're left tracing things back like that...
>>>
>>>>
>>>> For those other filesystems, Patch 5 has already added the following=
 check,
>>>> which I think is sufficient to filter out those FSes that do not sup=
port
>>>> large folios:
>>>>
>>>> if (mapping_max_folio_order(inode->i_mapping) < PMD_ORDER)
>>>> 	return false;
>>>
>>> 2 < 5, we won't tolerate bisection hazards.
>>>
>>>>
>>>>
>>>>>> Anonymous shmem behaves similarly to anonymous pages: it is contro=
lled by
>>>>>> the 'shmem_enabled' interfaces and uses shmem_allowable_huge_order=
s() to
>>>>>> check for allowed large orders, rather than relying on
>>>>>> mapping_max_folio_order().
>>>>>>
>>>>>> The mapping_max_folio_order() is intended to control large page al=
location
>>>>>> only for tmpfs mounts. Therefore, I find the current code confusin=
g and
>>>>>> think it needs to be fixed:
>>>>>>
>>>>>> /* Don't consider 'deny' for emergencies and 'force' for testing *=
/
>>>>>> if (sb !=3D shm_mnt->mnt_sb && sbinfo->huge)
>>>>>>         mapping_set_large_folios(inode->i_mapping);
>>>>>
>>
>> Hi Baolin,
>>
>> Do you want to send a fix for this?
>>
>> Also I wonder how I can distinguish between anonymous shmem code and t=
mpfs code.
>> I thought they are the same thing except that they have different user=
 interface,
>> but it seems that I was wrong.
>>
>>
>> Best Regards,
>> Yan, Zi
>>
>>


Best Regards,
Yan, Zi
