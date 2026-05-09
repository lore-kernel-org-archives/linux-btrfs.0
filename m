Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011040.outbound.protection.outlook.com [52.101.57.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE78374E67;
	Sat,  9 May 2026 22:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778364666; cv=fail; b=q/DdmAhTR8X7xaVdW50eclcoWG9WlQYPiD6SC08r0UbtnT8by58IrfwOmBZ8htf2kKjTNC2wE5eajDV5BJzdayU0dh1Q1V107j9cO+94Dwx0zkcf5W10a/nU9ui9A+IW3QkoEEsek75QRThHw4d4KhCkgTQVITFAUk54fL5QMTM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778364666; c=relaxed/simple;
	bh=bhqOypLJ3aIdN14GQ72aEslEPsQMPB5acMC8jx8tKx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pauh69+E2Tq+xMgKOu9saTZQuBaKg0RGJ5o3aMBiT2Wz21esVDyLoiqIxE43Qq1GmZXqU8WQ42VBFJW5brlRiR/HVApI/5D/7XaCy1pE4ZO+gCp+J3V2oqR9/2EldUHYK0nBUSkocyYtB21FslDXX0d1VX1JmZdoaqxki+sgodk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hTqfpUHK; arc=fail smtp.client-ip=52.101.57.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hTqfpUHK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K3SaSy3emHt0YlunY0W3k5UK6KOiJi0vnqXtNBH6JKpzz3GkIz/4NItMHlTRxUQNNoR93AD5E1fx3i4dxezgCJglYrpHSxd/ehn5IvrKT1RjorXt/q8+PG+H5voMBMn0WgATb76KkviDg7l/uK49JARmnbfzkiiA6SeZytC6dgFn2MFKHf1tedsM0kxrszCzd1cyArJOBSBYolre2UtZJQcYNx9mBfT0mlHcxMPNGdbS61qzAD7Prdo316QOKBitD5WJekAKFARwLpCJidWM6iRtOckz9imbSjfrVrAJDcOyMLmaOdJ1hxK+tkQWFZV5wA7lREXpEt8hUaEOz3WR7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bhqOypLJ3aIdN14GQ72aEslEPsQMPB5acMC8jx8tKx4=;
 b=SuW5iEi8iNIZKtu+RmhF7B6codrtZPJnY0+vBxupV/sblkeopvd3x/r6K5lLpPygvDvj8S+e5QtmYN/V4Rkzc8vCq0OriBqd25SfkG0nco4m9Pc4+w6tUrBUf5GPeXCEwiJ8o3UvAubLW+EsNcopPvnGOpLrwe2XLxod9PZ94FkHCZ9fyUDi7ptveVvBd+pWIwHQOiczCX9lVTG3jD4pwU1aOfNvVs1eYjGmHkX7uLJ9YmOPYKs/d1kcOjMmFAuyAGSz/wZahPtVdiNLWM2xqE2n6l8tSVAPK56YcfDk21Y6QRD1sXxgDQ7Anc6Lhkla6WblFZEV4xTqHM22LKTORg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bhqOypLJ3aIdN14GQ72aEslEPsQMPB5acMC8jx8tKx4=;
 b=hTqfpUHKDy8FvOJ/2MGAAgxcBnHZd7sVVFh7c5PAYSpXi9VqOLMHNsZdH05vqF7lfqIm4A2ucpZESBFFHgb32JGLs5L+2OEuwD4fEG1YHaVG7Qep4IHHD4oL+3oNR1BudXVE+I5yJqiVzPL1UbSBsC2mc71U32HPiXXyLuCQ54bDKmXiQSM0wYXAkWJY773WsXZCsG/8wu22OubUI85+IZt6Vo5dQdTaZNhgrirj+lTxeI2MnqmlLEdyxB/qQoHUIchWfjXAk4xNuqpFaC2wzI5F6P6jlS+EkxLxZdYS9WDribpjSd1CLdT3RtRBoy5xXL5NHqigE0gGlJNEmreiOg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW4PR12MB6683.namprd12.prod.outlook.com (2603:10b6:303:1e2::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.18; Sat, 9 May 2026 22:10:59 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.20.9891.019; Sat, 9 May 2026
 22:10:58 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lance Yang <lance.yang@linux.dev>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 00/14] Remove CONFIG_READ_ONLY_THP_FOR_FS and enable
 file THP for writable files
Date: Sun, 10 May 2026 06:10:45 +0800
X-Mailer: MailMate (2.0r6292)
Message-ID: <82DBD42B-AEB8-42E5-A31B-B6B161045394@nvidia.com>
In-Reply-To: <20260429091305.fd5a1c8c986c111527c2b024@linux-foundation.org>
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429091305.fd5a1c8c986c111527c2b024@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; markup=markdown
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TP0P295CA0029.TWNP295.PROD.OUTLOOK.COM (2603:1096:910:5::9)
 To DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW4PR12MB6683:EE_
X-MS-Office365-Filtering-Correlation-Id: 6734aca5-7b04-436e-4018-08deae17d95a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|10070799003|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	4rVB0lcBgk0gqWhDp76b4ZBu8xoEkDN3EJ4eVpNax54PJzUEMexBVfGFakj/7qIq8AsCsIcIufLVzB9gtEl8YkyEgG4P2U7k957SFS4xr48mXLpyRpJeo4qgpmRZ92408ntbTzMQEpph8kuxW8EGG3FtuCx37jBUa1Z+NngQiMTwbdq15WKG0I1vBFEov575u3PZntbndg+WVO1gZcfY4QGV57QCwuKz8OSZfAICE64etbjzhYzWL6I5M1WUhj0kIMQelaeKJNkMljSc7L1A6ZfemHUpBy6zVi9A/Bu/A3B1jgTbGufirLu4Nl75lW43ps1nviqg17gsUKm6siytnCjMfwQvD94RzGb90KlRJ0zWt1cSKou9BB6lX+WMxS/4yfaZJgKIml5S0WJPERS2R9kjl1EYqNJXDke06hj4XcITeyHC+kHWA9/lGvyONUhaqSi/oc6R+YBjzeUUlj1fGCQEa2UuAuEKZ4Pz9LY/2UYasFRtAD3PqqRaC9+k0/QHSTtLwIrw7hb/vqBeTm0vQ3aBzpEqp9LT62+L9t/jjF7zErQhD1zz21djLHWspl0pJt8PT1nDErNMx/FbV1y5ZlLwhSqrbFwT1PxFdFBMHfD4SUwllDl9S5zIwI/3XKAkGP1RySb4uMpX8yubpawOUnuxhCc43HXP5hR846Gp1XCpld1o1VU0aJh2+5OjQAjr
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(10070799003)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WnVaNWtSd3VrRDltS1l5aUdMS1VjVUY1ZHlXeWJ5MVVTeUpOZEJadUl3ZE41?=
 =?utf-8?B?Sm9vUzViZlNQRjRFSS9iRnRjZG9UNE0zQmxybTNvVkJKUXViVnpqaFE5RDRy?=
 =?utf-8?B?T21vS3RhWTNVWDJCZUw5NEtyOWE2ZitJMjhqWit2VlpReXhkMEVicWZ4MERM?=
 =?utf-8?B?MHNPdE9kd3FZWUdKQjNZRDdWaXRxVGxpajVMSHJibGV4Mm9hRWk4ODhiNXJC?=
 =?utf-8?B?Rk1jSmlHVG9LeHp4VS9CSHYxemtDTnlMOEFmZmNYSGRvQkduZldxS3B3SmVF?=
 =?utf-8?B?R05OeUV5VmhHSEJQMHpLQ01BdEtCcndWSG5UMFFUUnU5cUp0M3BHcWNPN1Vz?=
 =?utf-8?B?SG5WS0crb2ViUk9iTnFpSmVlbVFROTRlWHJYMjRBbVJjRWs4azVLR3hCdVg4?=
 =?utf-8?B?RXNEenZqRHJBYzYvRGJCbThxeTdTdHdxdTdyU29hb1Y0dHRBUmVGVkk2WU9k?=
 =?utf-8?B?MTluaHBMd21XNUZmN1hpUEU3Z0hTaEo4dzJwK3N5YVJDKzk4amJmRGJVRFha?=
 =?utf-8?B?d1dvMmRMWFo4YVhNOWlzdVArYmxiMTNoWEsvU284VFZCbFZzeTVjMFk4SkJD?=
 =?utf-8?B?T3NzT3h1Y0N6UW5jNlQvdDJGTEZCSnJ4LzU3R3NnSWVhc3QrMDZuS3FVZUQ4?=
 =?utf-8?B?c2haZmd3bGVMSG5mQ0lLUk5zMXBsRi9lUE1NeGIrY01jd2x2TithbGJjc3FG?=
 =?utf-8?B?VDFJd2lNWHd5M0ZtU0libDIxN3lqU0d3VzJhWEQ1Um90dVZlK0dLZEhjWnBk?=
 =?utf-8?B?R2xsaTVGT0QvaVFTd2FIdHQ5SzUyT0NiSHNnODlDckpkYVJSOWcrQ1k4VTMz?=
 =?utf-8?B?bWVramJGRTh4Y3NQZVhrbUZoQisrQ0FVcTltWWFvUDh1ZS93MEswdkFQN1ds?=
 =?utf-8?B?VjFvOGFDelVCV3FKMHcra2RMWGRiRzY4NzNiVHg5UHMyQkE4WmZpbWpVdmZS?=
 =?utf-8?B?MmUyTTFHc0VUclVjaUpsMm1paWE3VHA1bVhYTDczTWNLQzlJYTl2MGtBUDRD?=
 =?utf-8?B?dWZPcm5FbFRyd2dJeTBELzZ1ZWZudnpRR1A5T1pjSHVRV3gwNnNEK2xqSUFm?=
 =?utf-8?B?YXdJK2F0TStPUStqOThJclBNTE4rMnVNeGRRVjlPNW93TjB2b29lYlNIaENp?=
 =?utf-8?B?TEcxQ2dTSFlvakh1U1pWb01yVGovSWhxNGxVZXVuT01ic3UzRGhUMzF1NzRK?=
 =?utf-8?B?SDFJL2w5ZExpSm1ETDgrQlBKdDFGd2NuQTFwT1Y5OVk2UW1CcXp1SkR4Zmdv?=
 =?utf-8?B?Nm4xZkprL2ZKNXVoQ3Q5SGZUUVYzYjI2VXZNUnJKNVA1Rkx1cklZY0lsbk5R?=
 =?utf-8?B?QWxGRjVkQjhMbEZWWHlsVEJ6eEtsS2VvTERxMzY2OHpsMnhtSG9FS0F2Rmp4?=
 =?utf-8?B?Rm5SWnFKbkNXZkZoZkZ6NEVybU9BZ3NROFZ1LzAzUFpMOU4yYjFTN1J1aDNu?=
 =?utf-8?B?RjhvUWRSdnBrL2gwZDF3UUhwTDkrOGxvZys5S2xVWFdYcStTQ2htdzUwUTNR?=
 =?utf-8?B?dWxmaWFHR1dGQjU3WGdYN0N4dDVWRlNlU0s4ait4andWQmJnZGJHUTZxZmVu?=
 =?utf-8?B?WDQ1MGdMMlQrV05sdmpiRnc2MUk4Z0dpT0wzanNUcy9qbXNXZmxra1kxa0sw?=
 =?utf-8?B?dmtQTTFqMjlmVm13TlVmUk5Sb2NyNlhrZ251U29wcnAzUW1sSmNleFpYUlFo?=
 =?utf-8?B?M0dEZCtJSEJoSVl1UEpHWCt2TWpWYU5VY05DTHRzODRXeVdJYVJ1OS9LVnA3?=
 =?utf-8?B?NTZ6WDAvWVE5S2lSLzR0bVF2ZUtWNVhDSFBFNGZsb0s5QVdkcE42NUpRTms0?=
 =?utf-8?B?ZklWY2VHTFJ0SGxoSzNZZlRwSWM1UzNKYnFUTWtGSmx6RW81OWxTMitwM1ZE?=
 =?utf-8?B?dVdrSEpuRHZBOHdyMVlyMy9IYjBMbE9naUxkWE1kNXIwOFJZK01kSTRFR2lS?=
 =?utf-8?B?TjhORHA4N3pMU0d0YlhzcU5najNzUmRFRjBGYmN1V2p4SzU5NjJrMXErUU1Q?=
 =?utf-8?B?SUY0YUkyMFNnS3RKaVNKb1kwR3RsemFMVno3K0xiakl1NXJmdWFKS3RHVGZM?=
 =?utf-8?B?QmtmczhybFg5YlBkc2RCeUgzanpCSnZjMUdsTW0xUzUxSS83RytLdXhuaS9u?=
 =?utf-8?B?dkg4TEwzZWIvMTdlUVdyRlRpZ1ZJSjF6TXdsbmIvSExzbDByR1B2ejNINEVl?=
 =?utf-8?B?QmZYdlErZU9weHlqTERkL1hLZnRZS2JJMkl3enczUzFlRG40S0xIam4xS2w3?=
 =?utf-8?B?ckpmMEpvaFNzK3o4SC95Tys3cDBib1FwVUUrNkZabE1CTGdVSjVMTFV2TmVm?=
 =?utf-8?B?Ni9tbDZzTEJNYXFidHVkWld3YmNxc0xvYXVoVXhETStiZTBOUjlUUVBqYXVj?=
 =?utf-8?Q?L9h38cc2yysZwKpSsqkjBRGojjyu6H2JlHE5R?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6734aca5-7b04-436e-4018-08deae17d95a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2026 22:10:58.8652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FD9jxbrJr6oMhIE+f/HA39jL0KTQnm9mK5XrlS0d/b3QHdYajAKlUUPEDVgrIAMx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6683

On 30 Apr 2026, at 0:13, Andrew Morton wrote:

> On Wed, 29 Apr 2026 11:29:10 -0400 Zi Yan <ziy@nvidia.com> wrote:
>
>> This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creating
>> file-backed THPs for FSes with large folio support (the supported orders
>> need to include PMD_ORDER) by default, including for writable files.
>
> Thanks, I queued this up.

Hi Andrew,

I am planning to address David’s and Lance’s feedback and send a new series
after next week (after 05/17) as I will have no access to computers this
upcoming week.

Hi Lance and David,

Thank you for the feedback.

Best Regards,
Yan, Zi
