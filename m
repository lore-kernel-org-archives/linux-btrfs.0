Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010036.outbound.protection.outlook.com [52.101.85.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F4F2DC764;
	Fri, 27 Mar 2026 15:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774623929; cv=fail; b=TepMf0LZX9guvlLgVdIydkU0dqhr78sMUafBEN+Bpos8H4P9GCO7E+R05HvbdukNwefcwFwYMQlR/eWS4PD8wtPNnz/m7Q1adoxmb7wMi9CySEMjDATAMBRIcddrcxg59/7B4Ajjh+TRLOYni9YHXHLC3pEgWlFiKZnGpSf+Cy8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774623929; c=relaxed/simple;
	bh=mCT1VKKxbPFG4e4HYrLwN+CY1cJSgPfXkKp0RR3C5qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZMab575idKh+gQwYHgDDCtl2N2FlZ6xykH81jtmjR8Qh6gmCwridjv9moBWVi4ruY39arYKhYfyB3ViNZMeNXh5Dmt9qzpSPLjJXWHcEwY71cle2Rc0wHRADSxLgEcem7d8zatFFVJWOCcnWlvIaedaQua04jtj4Q9wbeMZIJKM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h+HuGoeJ; arc=fail smtp.client-ip=52.101.85.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h+HuGoeJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R8b58pw/l8IWrNF+7IvD2XIt3PXeMqP2a/arUF/db/z9n8CktXMV213mMIgPvveCSelTF46umEicQXsnwX6ltyqeRRXlmiLRpSru218HYVUmhz8onapjFz7/vIDtbbnIucsmLFW1MMm/8YPRu413WYVHpuKh64Vea2pyAEFAykocDHWNr+VHHAWvRjjXcTG9m4yc/ED5/X+KoIYXF0H38yuSiYeJ9MKgSfjbEnQ1LqpYjtwXUZp2wPDQHRvWiyKMk80fuziaM13W02P0cgQYUjDn4Kd5ySifvVGn1a8k1yA2VIWP5rWNV8oP6TV/Vrk+l5V9XyXvXeMfOL3PnTtG7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W0ciC1AlcfKRbNPtpKYnAFqvMtu+WSOMz2V/s6otaCY=;
 b=pgvsjEjHc7O/fM6WZpBTw412Rz6+YOpRs2zF2G8JC8RtOGvf6jxt4U3iWL9D+w9R6dogcPfVyHacXdjGsU1elII1GlX8uvQU0Ze0ZCyfvXA0rR/Lil0biXKtlzUY+Yq3XOMxqEsaIuNXnxpVcZgepDTPzxa0ldJ5Q7Wxhq3tCNxLlI5bZehkuJ8HZ41k/RWitmTt7Zpqy49VGrAqx9X3f5bSIVBJls0Rhk4LHiOO3YzTkiAqcXM2n2x8dyJkVUE7Jxi3OskWCdmUIAYMy/3PLXslZIPoOvmILa9kbe5fZh3wliRLLGwzFqfPG8J8nSp3qm/8obGY3BWpQ39h4r5L1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0ciC1AlcfKRbNPtpKYnAFqvMtu+WSOMz2V/s6otaCY=;
 b=h+HuGoeJtEryX/vg6eLQD/gxjSy5B9zAgIqYgIu8L+yBV3I7BogeGAkKM6lQabp6oifI4OJU5wFTupvuNxSHao5/7BiUduKCem+BS4oKw1rWyAfhpLC+UaV/Z8eBSl5aHdaSdNx92RIhhNpBIY66LtfyipIwcmelo1zsDSbQBWMCLhqFu73VBunTUYAGfLTLqFAsDS2tQX5x1xifpstHgR7HrkDA1fYLjAZXOTMumVZw6ZGAttLbZsuBiwq545qLbSsGee/i1fLTkbPIHkRbXvHAeVOydI1+jNhqdIySrikvksNrr+0Xp0PZKHToo/gkLuzMYRGqhkYfKDWrBqLHAw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW4PR12MB7312.namprd12.prod.outlook.com (2603:10b6:303:21a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 15:05:22 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 15:05:22 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
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
Date: Fri, 27 Mar 2026 11:05:19 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <25899F67-955D-44DC-935E-D7F234BD335A@nvidia.com>
In-Reply-To: <53cf6157-58b1-4539-a276-2486e8796c57@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-4-ziy@nvidia.com>
 <aaea8ce1-eac6-49d6-8c85-7361977b9a9f@lucifer.local>
 <b098fce7-be16-479e-b9a4-36f0ad71d242@kernel.org>
 <53cf6157-58b1-4539-a276-2486e8796c57@lucifer.local>
Content-Type: text/plain
X-ClientProxiedBy: MN0P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::23) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW4PR12MB7312:EE_
X-MS-Office365-Filtering-Correlation-Id: 6952ca18-a873-4abb-8c9c-08de8c1244a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	BvmsdS0hRzeetJ5oMyP/1ugog7kIl0Dnfzemv83uQVC51NGBjAgWaN4R72PgWkcSm3up2sNS4jJG1Gc2KGK9CZ9g3H+6ZR0GONU1NCPiVv393kgbkz6trPTlz6UQkP5POWxkniBRPHRSKWlY1y7PwBjUQ6iCv4hsFSpup1hxqyjqK+bxfbAVYf20bINabByalqeja27pG7p7GGumxFD8+PLjihAr+4K3VLZwvjFzLNZ05XPEhNf2lA+odGGiWwhRrM+eN9JTCovCCYSeCPthzuajqYhZrqTzJDomkTuZ7XqXdUumz0sWJC+usU3Qncudrl5QR8Ygwb79aE4Ppw15a5AhAccanVbi7w0f9IDe5veH9pBl+Ik1MuXDA+VMqTm/Q5szoGxAOROCtLSUiauCcCsp22LDMoQnAjUAj4k9JP12bMEr5WUeFNNVi1+ix+OA95fHu1zVzMj4TgRWji8CyHjNVhaH/n4ev3pH5LXXIokf0OXUT72CaG4YaIr8uvCRTpPfTZI/yp6hrsvBd+q9CN4z3a0e4PfzsvAnFIGWv7u4at9Aps/R5pQrwlT1AvojaWGUREScOEA2AfnKsA0ciVITQKajygtTjEgt6R1s2lgNFspL2XEHS2cy2Mg6MXKi0wzCBlZ04rm2v4hu3f9C+liXqd6+ckNZ3wE6ol/FDBoIXG8DfmVERT/v1zvuFn9MbNUipgKD9Ip5F4yMn0kneodsSvyql/q5YtoOi2QOsts=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lFv9O6iXyZ+Aq8RR5z7y1tSgo5OpudlTMUrHR5srdVagb3PsZF1J+My9o77T?=
 =?us-ascii?Q?HSimyCVJF26/jbQB3GgEd19E3zynpNvH+OHpK6p/3vfpHyYmzIQO+LMWZNBi?=
 =?us-ascii?Q?HIhDFctdLVIib/89P8L2dOkC4NgDzcbXlYRa/eoGTynClsjL4JVnkYg4rHeY?=
 =?us-ascii?Q?k2/GGa93MLVcEexN0YRAltpQQuEPEtIJmJV9ywPz89JJ/EHvmIqAVWDDKOEi?=
 =?us-ascii?Q?pE9Z3kqhqTf3FrT6YGqXcPnKk8AFzokUK3iunzsCYy74pRsLckfl8cyd396P?=
 =?us-ascii?Q?eDai/MGsmUM23V04vfNz0h2GsFvg0jYtAN6F4j39CPf6y0nUuDyIzUlp9khs?=
 =?us-ascii?Q?kaDQ/mWgWRWRJ4es7sXFzoF4wGuUoTs6XFFYD71p6HENV/w7Uv4zxZG+MWzr?=
 =?us-ascii?Q?6rmyZ7sHm9O8yiUuKAM1UUyZz9Qifz8ErEsx0JOfC0nwk7g1/2imGHJUMVZI?=
 =?us-ascii?Q?DO9kxVdXN8JUi3UD1fUuvfJs4IdUISoUkowWdncZVG27mLp+ehabBWVuef8s?=
 =?us-ascii?Q?LOQHOv8/3lIz5ziEssw7IbpZiPXMtKbJ0DF2n6unKIv0TogVFdrVRUXew7IC?=
 =?us-ascii?Q?dHnG8XFui2og24XjARMxa/aIn6rlRIBHDJsBUA8JQOagyR7fMrbQDDa63JnI?=
 =?us-ascii?Q?v3urJUzchO5Cm9E99RcSzohVVmNLwGNEFthE06KsJOcuG7vO4Vm1hHinKgOG?=
 =?us-ascii?Q?Auw9z4TPYAypO+wY3tczWQkLWGWim2+bkEC8chSvw/0fojYqvpLWAwvWt8eO?=
 =?us-ascii?Q?YbER50ASYgl6OKhuUUtoGlUAtEUUGqBIOBOnMdjkOpNnLUv0Z33hCWHmjFqE?=
 =?us-ascii?Q?rIxJt3R1viMNfhN+ihYozXib/WDR4WGxTVNa3t0dJ7B0johjHhqxLgMKd1y/?=
 =?us-ascii?Q?vF29LWSepu1WYm/enZVBbXfWyzLT+6tSyQ3RmsE7+w1+iOq53EOlYZQKxf4V?=
 =?us-ascii?Q?Txio3G0rtK/0Tdwe+mGje7tC8p0jWD2iFiCTzze7tSkE3KmPdFOgZOQKCU2H?=
 =?us-ascii?Q?ueXCt8ggQOScs8HLZr0Gp+FbRkcLNhV18+e2vxAglVEL8ZNt1Fy2vygRaphZ?=
 =?us-ascii?Q?9Rn5AZ9U7tZYfmAleqbAfcxfAd4TiMviHf0/xZuwYECVIuinuax2VS1RpCty?=
 =?us-ascii?Q?fuCcviBHvBQPpKaWxafM6Gz5To5bfSQf4hif/f18GKlG1M4nn7BYkIUNOyGQ?=
 =?us-ascii?Q?wjBZ73TPSHNoNSj+/x8Q3SM2pFEg4xfYFrQ37XCd7e+VsAWRuM4XKRq0KvXz?=
 =?us-ascii?Q?hSbZ5gGgh7jhMvvGBLXFogbHE1qPkUwLx/vcmPEdxntOyoBvB2vhtRsgYJpQ?=
 =?us-ascii?Q?nSguUqYOCPjvrzMz8DjBsAsuebsyz7w5Q9D+Q0zyU8d6GZYU3Pz1K2RWEnoJ?=
 =?us-ascii?Q?BufSq+z57OhPlKXgKJefP2ImxVoICwWMkLU1U264w8q5UeHO4MkJ832Oz7J3?=
 =?us-ascii?Q?RNX/tjyT63pkAeoTN063RcX0S8zh9teRUf8I6wiV2Rrg8JfB3jJiLuH3ERsS?=
 =?us-ascii?Q?XwYpVqKUfUVJpkZrixz4HE2sDSDTPylGYHUB9y6bbLrxKC04QmEe2SZEBHKT?=
 =?us-ascii?Q?FbUgIIMNWGXZV2CywMrSFmimd08CJr8PmNXYSkEm/P9Wqt2MgsjGjozeY5Lk?=
 =?us-ascii?Q?jBKQeGsPb/bJQdkwrofZnPvMlJ4NmdOL5YYS94nJ++uqYKE5bOSQT5CVUj8I?=
 =?us-ascii?Q?X6PXOmGq8VTZb66egIPaCKgeuEhQHseltEJC1jKycntCEJowaIFFPpZxryGt?=
 =?us-ascii?Q?52HKPW84sg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6952ca18-a873-4abb-8c9c-08de8c1244a0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 15:05:22.3786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ak/8TxoZzlOCxt2vKyis6qFhn/05zLYGVqT7Zzj5+09VQ1gVwhZvl9czDqgkM1cC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7312

On 27 Mar 2026, at 10:23, Lorenzo Stoakes (Oracle) wrote:

> On Fri, Mar 27, 2026 at 02:58:12PM +0100, David Hildenbrand (Arm) wrote:
>> On 3/27/26 13:23, Lorenzo Stoakes (Oracle) wrote:
>>> On Thu, Mar 26, 2026 at 09:42:48PM -0400, Zi Yan wrote:
>>>> They are used by READ_ONLY_THP_FOR_FS to handle writes to FSes without
>>>> large folio support, so that read-only THPs created in these FSes are not
>>>> seen by the FSes when the underlying fd becomes writable. Now read-only PMD
>>>> THPs only appear in a FS with large folio support and the supported orders
>>>> include PMD_ORDRE.
>>>
>>> Typo: PMD_ORDRE -> PMD_ORDER
>>>
>>>>
>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>
>>> This looks obviously-correct since this stuff wouldn't have been invoked for
>>> large folio file systems before + they already had to handle it separately, and
>>> this function is only tied to CONFIG_READ_ONLY_THP_FOR_FS (+ a quick grep
>>> suggests you didn't miss anything), so:
>>
>> There could now be a race between collapsing and the file getting opened
>> r/w.
>>
>> Are we sure that all code can really deal with that?
>>
>> IOW, "they already had to handle it separately" -- is that true?
>> khugepaged would have never collapse in writable files, so I wonder if
>> all code paths are prepared for that.
>
> OK I guess I overlooked a part of this code... :) see below.
>
> This is fine and would be a no-op anyway
>
> -       if (f->f_mode & FMODE_WRITE) {
> -               /*
> -                * Depends on full fence from get_write_access() to synchronize
> -                * against collapse_file() regarding i_writecount and nr_thps
> -                * updates. Ensures subsequent insertion of THPs into the page
> -                * cache will fail.
> -                */
> -               if (filemap_nr_thps(inode->i_mapping)) {
>
> But this:
>
> -       if (!is_shmem) {
> -               filemap_nr_thps_inc(mapping);
> -               /*
> -                * Paired with the fence in do_dentry_open() -> get_write_access()
> -                * to ensure i_writecount is up to date and the update to nr_thps
> -                * is visible. Ensures the page cache will be truncated if the
> -                * file is opened writable.
> -                */
> -               smp_mb();
>
> We can drop barrier
>
> -               if (inode_is_open_for_write(mapping->host)) {
> -                       result = SCAN_FAIL;
>
> But this is a functional change!
>
> Yup missed this.

But I added

+	if (!is_shmem && inode_is_open_for_write(mapping->host))
+		result = SCAN_FAIL;

That keeps the original bail out, right?

>
> -                       filemap_nr_thps_dec(mapping);
> -               }
> -       }
>
> For below:
>
> -       /*
> -        * Undo the updates of filemap_nr_thps_inc for non-SHMEM
> -        * file only. This undo is not needed unless failure is
> -        * due to SCAN_COPY_MC.
> -        */
> -       if (!is_shmem && result == SCAN_COPY_MC) {
> -               filemap_nr_thps_dec(mapping);
> -               /*
> -                * Paired with the fence in do_dentry_open() -> get_write_access()
> -                * to ensure the update to nr_thps is visible.
> -                */
> -               smp_mb();
> -       }
>
> Here is probably fine to remove if barrier _only_ for nr_thps.
>
>>
>> --
>> Cheers,
>>
>> David
>
> Sorry Zi, R-b tag withdrawn... :( I missed that 1 functional change there.
>
> Cheers, Lorenzo


Best Regards,
Yan, Zi
