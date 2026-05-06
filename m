Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011041.outbound.protection.outlook.com [52.101.62.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A131223E342;
	Wed,  6 May 2026 13:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778073345; cv=fail; b=ivSomx3kMPrhb3Z7DO4nH/0Kq3ukQnlUcy4tZvcN/XEN4PTdvsncoh/bm7newLioMfBgvM9+41wckl9l8RU0fnCmdEZ5SkDxWXe3rqjtTyFrlmH6MaZyRjQASdkfLgIODr7/c579R33ZwnVzvRofahI3s12g4zYWUPL+/m9L7Ag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778073345; c=relaxed/simple;
	bh=tct1lKkh/5+wEh+7tcKoGGyrrqX1Gb5KVMSUqHSuAUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=r6E1mbz+NBZA0dHN770SLjypckXF2P1STPdxU9DwyJ5xj675F9Jhdd0PwtlsZlEE01erMymiH8EGT6+H+KQv4elqlcNwE7OZmHDcUk4qZx93/TxiWCgTKJSNZ29iQur+SDn3uORuaDxI49/9FFZQNyAXZWOzy+NA6cBbt+eqULM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=R3lKYbAo; arc=fail smtp.client-ip=52.101.62.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="R3lKYbAo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PEQ5+GpVwesSGKECG0iYwppvm72cu+KdWcaGXiaUaRmanr2dRxQuWKYfK3me9JD7xGEOsu0rmaAD/oaDCDjQbgR5vgMfSgZEVPujfrqCZNtm5KJj16uZO4/1cifhfCIB3lJ/jEBzuGVe6wBtDXlcG1LpyQK2kMKw1ITZSoBDNvXSID7hsepnTdB+2FugzC7qJVfEtppwwStHgFljfFM/va9aOi3BG3mL9ej/TyvHjXjOGpGsIDq8zpaFgBmjIDfP7lIpAPiGaNe3AbtvyKPTWkKrT6WNfQqjmd9SriuBbUPDgUNlUXoHSw9sY4uywTwW/neW5i3VorrWZctKf2erhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tKm+I75MqLH5FFybicnKVsUpbZee1tWk0U07zyqmmS0=;
 b=r73wRiAofZrvZoifx1D9wA9z6lUoAkh8pDmNN4dBBFSG/5CU/w5LVvSIDNrQFzS2n5GaLgG5TxWQVGfpCFAHiXbTQsee073+QIDy+cxDbQpOxPXKraaAqh7DedJRdJ2ypun1cCEzvVJPncTb0KrHgEoNTAnj/HtUc0NWDx4bFIof2Ys3CuwkMHbOI55AtIgkg/XMuTnoBzp+7K9vqvkT76XQAI/NzdDp3f8ig3YcLJdneuC0u8J5dJO0xznf21E3p754oaqqhErPOv379v5dT/z9h78Rr9ziKUk0dVG4whv4PNhFn/mwjQ5r14ixbjTn0+zdB0A/vz2OksGbsgLO5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tKm+I75MqLH5FFybicnKVsUpbZee1tWk0U07zyqmmS0=;
 b=R3lKYbAoevIWf5Zb2pXKox7i1dvQUBFVu/A0M2kqlzlITvs93DlQod3jOQqocDEpOtvuo4pp0UHTTpaZbAy8bAqpSNuKaKYX//9fgesPKqD68kyOngYCSD4G1FsHypKDTkmlPkujhB7DZQ7JkWkkKZ5yrrpMVbshNM7aNLWTEi3CNfJ6pwjVjliXts5564whVWkZm6iIq4kpIQCFJqzEx6g75aXps7urxc0UTiUK79iTbAH3XQrmxx8+XsoAlgnIb358p+Cx4zxTWSA9JgC3O5ZaUfHwPLeAuppe1iwjZuOPhKaAK0HoWuDEVKYtRp+FsNsOa4zCe+TOxxEojLSAsg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH0PR12MB8152.namprd12.prod.outlook.com (2603:10b6:510:292::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Wed, 6 May
 2026 13:15:39 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.023; Wed, 6 May 2026
 13:15:39 +0000
From: Zi Yan <ziy@nvidia.com>
To: Nico Pache <npache@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 11/14] selftests/mm: remove READ_ONLY_THP_FOR_FS in
 khugepaged
Date: Wed, 06 May 2026 21:15:22 +0800
X-Mailer: MailMate (2.0r6292)
Message-ID: <61FB928B-03FD-4852-BED5-4E453ABB706A@nvidia.com>
In-Reply-To: <7e42faea-9f55-4722-a426-94be7fc3a49b@redhat.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429153538.727855-7-ziy@nvidia.com>
 <7e42faea-9f55-4722-a426-94be7fc3a49b@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: YQBPR0101CA0311.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6c::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH0PR12MB8152:EE_
X-MS-Office365-Filtering-Correlation-Id: a5ecec89-78ce-4ec9-682b-08deab719137
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|10070799003|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	keEp3pXRmMO2A6imwdN7WXiyvKurWZVaNGv70G0/M09hVKXWGjlc2RIx1OApWoNy+q16vRLddCYEAD7vxPhL5NcgM3CuF9K5SgnmaX3xI7lRmcxDSIF5U7ybIK1Vr9Ta06uNCNAIep0FSLI7h+3s1mY6ewOjDux4+Cis4y8+aIa+yLM4y2iT9FcLwM/wUFTX4J1HUh3ASkMBtfHah0XR1XmjT+7uavvB5EwIRSUB1iajJrKm79JOnml+eC7mHxD6pfHdAsRSSo7VqAUL7oVI6TKn6HJzeGWRNs9U4PhA7nfsgcJ98zTPXF6M+CmjApvtkaf1JMDkfpcGoEyWh/RZljkgROwS6iiCg+Q02OBH8wczu//GI9YA5PvqisenJbg0YNibEdU0fCxXODF6nSD6eTfJDMatD0uk/lAgkzcQ0IDgYE7PqLGbabPPOh1/l+w4lQmTJR+VX9ic/tTzHni0WiZqSHLAU47vzsvVqV10KsBf/UhFm/2AtcYzvXan1X1kohYzwT2p7KzD2enndt1IrwqFbhH8lBWr324K8els/Iij+Noj0hVSUDabVzJthz0/RlhjR1pnQiu6bCPlAca/rw8aa0qOOrO7M4IwwYfqc7yQJwnl6bGjxVmhTJ7pDDHjhRtVYCv8r+5q/x043kkcNcT0uW63gCgEsHWQI8f1jj4LMpcyuJ9KHxxwDsafu7g8
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(10070799003)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xPq8830KIRgTBxsfJ+PtNVrXXma37FQwtLaCVvJ97ffalrz7Lptb0sSzGb4U?=
 =?us-ascii?Q?hl949MA5qnCP1kxsFwNr2ug1PLeUYXzfxdSfgjCeS/phIwu/Od7h+0EuKTbV?=
 =?us-ascii?Q?TVxBhGmp0UhuqOhV05IgtxIGQX/sO+kDa0QkJ1hk1gH4ZbU3Uok+FakBw8o6?=
 =?us-ascii?Q?i4Q/1PaIYgxFI+7l5t5IcIl0LL5Pr/hYca7aIA2SO/SGE+nrqcifDRnl4Gab?=
 =?us-ascii?Q?xmPRKhYM5v+9hQm66FYqyTtq4lZWxJONHAir/ydfO4c6XrkyG3glC2yGt7+j?=
 =?us-ascii?Q?S0rundVAB3j3AdIgFwYk47l2vGPUn3WAy/ZRfla4bYqeJo7s4skFk9SEcmQg?=
 =?us-ascii?Q?If6hUHH9LZQNgVbhgZJ52Snb5lz11UyMnrKa9AJMu2f/z17mVcamvagAXnY3?=
 =?us-ascii?Q?CO4I88ZElbmyTFvZqfV3J3Mw7QOUCq72iv5zbxS0xBhOmrVcQnRpRvEws6RN?=
 =?us-ascii?Q?rQkd7CHVgMIgyLy0cTZVCNnR8wTNuj2y1V5KlzsAmVRqwEvle93tCLJuMaCH?=
 =?us-ascii?Q?7CrdHNBE42IP+IGmGGvo4tBk2mAn+54PBezXuyKLNY2zE/1p7zb16iB5OKJt?=
 =?us-ascii?Q?eWJW/hFxORMR0QLFu8SdnPv8X56yRsb31Ay/nIvBiupk1QvkpEb9/cPLWwL/?=
 =?us-ascii?Q?vB3tvrpLOfz6OqJV85V/xiNnuvayn70qbW4MVgAuWcDxiq6G8PWXXNtJ68vb?=
 =?us-ascii?Q?RgKiTBgzL3GKVUXuGTzqYuOZNNSlSxcFFeh0bBZHNIGX6oU3RiT8bOM5HrKb?=
 =?us-ascii?Q?gh0KL6C9Dey5+pz1uagKpqhDl93ris2gFQ+Ny/dca6Osb3Tp6YYXxzBnph6A?=
 =?us-ascii?Q?5M0+qUGeQAVhToeFh6pPCvmNeN+Al7OBiqwxNpstPL9Hlh6cmm5vCkatxGUK?=
 =?us-ascii?Q?Yg/yeTzG7Fg60+ZI6x2EdJfLgYuvgKBXMkKfTQy4Wnd5Qx60qpYhCTpFn/5T?=
 =?us-ascii?Q?1eWlqvi+yhyKzeNgqbWjPU9iS6EZmOV+UVxokr09ppKe+J+8KMHYP6toGOhc?=
 =?us-ascii?Q?SbW1YsRieNBh0RUN4aczrgbyM8WzWHfVMBEo4/ngZqZVOTU439Y393EqPE7j?=
 =?us-ascii?Q?bsGhVSmj8bgeQdwj5B8PuBIpH3Yb0uIJYXQcKx7cpdE/aGnu36yeG8oD8Xnl?=
 =?us-ascii?Q?nFGqthMZDr7/wMM4xTut6Drh3Ua2yOkrS5ugrNd5OKBYxPMqJprohpn2W0PH?=
 =?us-ascii?Q?J5RYJRVTTB9+L1l7s5GzKgNKTlsWWS3iNuVuHk4A/50XYQY/FmXiwFfb/Tl5?=
 =?us-ascii?Q?EmIiByt1juSkH3SmUF76oQcv/HQ2lsJg3N7d3g/j7E60GRbhvvrp9JlcSV92?=
 =?us-ascii?Q?ntfLGCkl08sokngU8nAvF4Q7pjEJFJhMbM5vF/DEE2PSL1VONOOhInIZCBVt?=
 =?us-ascii?Q?Tjvwh3BFzPYi9Dv52pJAaJOh5tmKgZT7KuTttA6wBWl5ROto+/9V1TPDEGky?=
 =?us-ascii?Q?Fvc9vh13C1+W/oJImE41sEMloi7NshhbuOqNDHTWGJZj9olXFmYqgB/3ybV+?=
 =?us-ascii?Q?oUPsMFqR7liHIHegss+UHRNM6TF6F9q6oHvqymJdIz49sJKROcYVJAaoFs5J?=
 =?us-ascii?Q?uyeujNvNxTwhpsmEdQlxcQqprHgMqzdS/4WZp59NfiSamkjgTvp7LwBCn/RG?=
 =?us-ascii?Q?dSd32Uqb+Dx3fe3rox58kWJZDvxOSeeX3DG3TpFEWVmT+Wb58YGXpUzO/PMF?=
 =?us-ascii?Q?ZMi5gs+690tPbg0Hh3k+CYPr1tew57qSiOel1BUMnMtMr5heuuczU+Q/JuHD?=
 =?us-ascii?Q?xxHx6bOajhnP5LcMhOgpL80HqoNDiGqw2fDmPonnvFnlVsogalg/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5ecec89-78ce-4ec9-682b-08deab719137
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 13:15:39.0410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tYV/j14PttpOj/WVfhvJ0Rb9T5Gjx3CDKGj2vc80dX369dWC+Ca7EHpNhRzKtMr8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8152

On 4 May 2026, at 18:11, Nico Pache wrote:

> On 4/29/26 9:35 AM, Zi Yan wrote:
>> Change the requirement to a file system with large folio support and t=
he
>> supported order needs to include PMD_ORDER.
>>
>> Also add tests of opening a file with read write permission and popula=
ting
>> folios with writes. Reuse the XFS image from split_huge_page_test.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>   tools/testing/selftests/mm/khugepaged.c   | 131 +++++++++++++++-----=
--
>>   tools/testing/selftests/mm/run_vmtests.sh |  12 +-
>>   2 files changed, 102 insertions(+), 41 deletions(-)
>>

<snip>

>> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing=
/selftests/mm/run_vmtests.sh
>> index 3b61677fe9840..854c5c3e3a6ae 100755
>> --- a/tools/testing/selftests/mm/run_vmtests.sh
>> +++ b/tools/testing/selftests/mm/run_vmtests.sh
>> @@ -490,8 +490,6 @@ CATEGORY=3D"thp" run_test ./khugepaged all:shmem
>>    CATEGORY=3D"thp" run_test ./khugepaged -s 4 all:shmem
>>  -CATEGORY=3D"thp" run_test ./transhuge-stress -d 20
>> -
>>   # Try to create XFS if not provided
>>   if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
>>       if [ "${HAVE_HUGEPAGES}" =3D "1" ]; then
>> @@ -508,6 +506,14 @@ if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; the=
n
>>       fi
>>   fi
>>  +if [ -n "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
>> +CATEGORY=3D"thp" run_test ./khugepaged all:file ${SPLIT_HUGE_PAGE_TES=
T_XFS_PATH}
>> +else
>> +	count_total=3D$(( count_total + 1 ))
>> +	count_skip=3D$(( count_skip + 1 ))
>> +	echo "[SKIP] ./khugepaged all:file" | tap_prefix
>
> This leads selftest runs to always litter the output with SKIP when run=
ning this with the wrapper
>
> make -C tools/testing/selftests TARGETS=3Dmm run_tests

Yes, this is intended to let people know one case is not tested and skipp=
ed if XFS cannot be created.

>
>> +fi
>> +
>>   CATEGORY=3D"thp" run_test ./split_huge_page_test ${SPLIT_HUGE_PAGE_T=
EST_XFS_PATH}
>>    if [ -n "${MOUNTED_XFS}" ]; then
>> @@ -516,6 +522,8 @@ if [ -n "${MOUNTED_XFS}" ]; then
>>       rm -f ${XFS_IMG}
>>   fi
>>  +CATEGORY=3D"thp" run_test ./transhuge-stress -d 20
>> +
>>   CATEGORY=3D"thp" run_test ./folio_split_race_test
>>    CATEGORY=3D"migration" run_test ./migration


Best Regards,
Yan, Zi
