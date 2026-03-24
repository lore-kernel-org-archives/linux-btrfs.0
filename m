Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011057.outbound.protection.outlook.com [52.101.52.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A6C377ED4;
	Tue, 24 Mar 2026 11:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774350908; cv=fail; b=tzk00vngKCBbZVnhNQeFtGNDLazlR/jD9PuRd39CwfzecmtyWqe7B2bP+pZrY0fdYz/CaNIGEopAfY/53HTQQ1gbWmXaavd53ZtFdsLgvkWc4JGD8hp9W9eJONVJr53eVvkDId8CxczVQahUoSvylUFAbeiKjaK2quPE6GSeeSI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774350908; c=relaxed/simple;
	bh=6tlw7nacWLMQ5tVBByiRAKsJN/Trgj+boVkko8b+BX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QllY7+o1HWzu1Cu5hmSiF9tRQKoRwuqV+hS95X0qfIEZJkWTn1EIil6rz99qJroxcaFbeom0pAixXJzJ95feZYKBoJKu0E/C+rhcVKaJUzJFAmu7HlqP6TVCQdFHbqIXEobpIWj6P7mNj3awEA0Unjnuug1z591zZmDUjx+1Thg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Si3hj/c+; arc=fail smtp.client-ip=52.101.52.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Si3hj/c+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wUq0qGnkuS/oMZH2g0rHYUjU1Fee1+kG5tBxW2KZ+5WuTt42qddxY6Aedgt1AxbK38hwEUszzVCosnNqeIH9gMJg/sFoUNd1k/brZMVGp3p5PWhgAKnjPUK5v5rQG4DdZVzhnosSJEzzs6QH/t010ATrvE8uj6f22IeDoU1VuNbHGijVNM7XTTcH4PJpkx47mN19qrgt1Cd+5uQqoyYf15rt+9QXZn+F9vqjsMna+7ydzRwVw89UfZbR35dOs1+EyKK9cXP+RaeJScj0V1jo1JD4iP4J1wiDoEPTYgg7hmwO0NUriZU2dYIIMngxeLDi+BD0T8n9N4wVkjCMYuFKpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=99JSYhBBd1Vxs+NOP5bCyrZ8/P3WQBXd/6wHUcXBPbI=;
 b=cprz5fRzLIUATbLxvzRa9tSubRil5SiQDXxU+a4+PH10IeAI9FrMKobZiZ3sJDgjlL+QARL+8ej+ZxPazJDYQCmPvLGL4FMKaxSWdS6v1/Onv0s2hguKC5KQ1aPJ83qX7+BA9boO8q5WgKQviRm2z0ynVCWH2iMudQjWD2Rna7zlwtfFplR5ozmm8eVNrzdhaLaZ0nuCL0GUuB9ZaFeSKGu9q3kLT+2mvSdtNohmF4XCsZHyim+xG6VGrl1+nyQUYCkex53yTUKWz3oH78MXqe84ACWH3rOdK3dXZEcIZRE45A1qspLe7fKPGAL6pc7PvdPJEhthSt25hCD04EefvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=99JSYhBBd1Vxs+NOP5bCyrZ8/P3WQBXd/6wHUcXBPbI=;
 b=Si3hj/c+60oACD2Y3ISfQbZk2lHCROM+CG6arrTFwpbZEYHUtlDv3aF+NHiRcw5+3rbuPe9wuZBj2uZF7pf4TDUl+4u9nEDI4TN/WSHGjpV+nbMja/nPuUBPTU7h8pPOtnvkuGMPt8vD7AeArgIQ27KDU1RcHjxvpEoCxCk6VXxjzFrNbq9LuY9JzJSgIhfF9WcZWPvmxi2TB6e1gbXqoX0JR1P496FfxidlLo23xkWfhIYEPNtUsNKCA/OKXgHrzyx6VRf4n4dNQXjoxx9GBPUTWOeQ8aTXwHLnHDoI40K+Xan1u+FEf/Zoj+Q+q8r0BqLp701MGf6tvjkkiU795g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB8818.namprd12.prod.outlook.com (2603:10b6:806:34b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Tue, 24 Mar
 2026 11:15:01 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Tue, 24 Mar 2026
 11:15:01 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Song Liu <songliubraving@fb.com>,
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 10/11] selftests/mm: remove READ_ONLY_THP_FOR_FS test
 in khugepaged
Date: Tue, 24 Mar 2026 07:14:58 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <DAD4E4A7-5EB2-46DC-8BBC-D311E252133A@nvidia.com>
In-Reply-To: <e7de962f-9cf9-4628-8272-0efdfd0931b3@kernel.org>
References: <20260323190644.1714379-1-ziy@nvidia.com>
 <20260323190644.1714379-11-ziy@nvidia.com>
 <acGrokwjvIHqDmSP@casper.infradead.org>
 <e7de962f-9cf9-4628-8272-0efdfd0931b3@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: MN0PR02CA0002.namprd02.prod.outlook.com
 (2603:10b6:208:530::29) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB8818:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e81674a-951d-4098-7d29-08de899697a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	8izNJ6kZoNZLOmDzv1HNcCkYiZMbdO8dr+RGLEG5Jik5CoByQgSDM0Ob1WRVPzHozkvOGI0E4OAAhcZs1RsoiBPA7v9zSGgvtGQM7p7ixfIoonBhYd/JHlSCcDdtIBxzQj/3j9Ip7RP0Iv300m6Gp7G5Ng0D2bzbvO9tkj7n39MSjRer+F91+UwXvMoYGkNFY4zIGwpu6yavMVjo5AQ6CgAsV5JuUOjYTEj/yUjiEh9mOb037RCtcaoRdNo9FQ2ifCyxyaqj4qkV/Kd/ScPEFBlXmP4LGP5CdKuE5EUMmaSVZttrvtgFBFKXSLXYgPRhyb3RdD7JemCtHfnogigPlN6MfNoYMHJmqhvfhrGnGFzHLMPuKGJAgMNfMsDE1LX1R/VJFpX2GscqKHQxIEFjH6iElKT5WcrqSbrhwUxMBJWWYCmYEbQmU+ElT47GIT4UVyXlD/ZMK/g8CRcurd6TlPGmkHeb4EaynRIixb9vdFgZNsXZgs5hIjvq9WoEigBOGLr9VF+/FYaYpZ/TzVncMS0g8JXWYRVbdEyJ3EgAI2WTHwPEW16t2fYWbzAgjJFlWcYsnqxDodPIYvxEWulWFZ4dgH4itTxhfE7dlzaG/3FXGKc1R+cNxAL9y4H22w6/UmL3Th1wHo7ER63gHZA3SFdRMGiVmeP3ijoGOKcG8puIQBof+uoo33vVzv4mfpTlN3hrl7iGbzz6rhWaHOaICwE8k9yiSZw9Q7fOYqbuRwg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XQNFXhuuHRYUOPrJkBgkl4UcrOOMNHdZU5wbCRzdCBlLBTx/ZRY+Bn2uwyeC?=
 =?us-ascii?Q?x6qRtgMUOHU7GSCWH1QF5rpOWoKjrwTuSyiYCIIU9q5JmIaF0hSaKxCCAANE?=
 =?us-ascii?Q?tAlNi7NL+eD+g8oxHvG6FHloGB+kMQXs8+5m6RaB/yodIPsK2KSEJnY9UOb5?=
 =?us-ascii?Q?398QsUwFyZrJxgmxvPJ5o6qHt+S5ml3qjkKcMdkFLI2DnglMUgec+IAyf+uC?=
 =?us-ascii?Q?AHLoV/7BigoZQt48UWhaWy9q81dB53g0nXFI6//Y4/oYlgmSu/mTaNoe2+ne?=
 =?us-ascii?Q?jAv2rCL1OkpOFKyZQTVAzq9KovHHM4Ym1kOVpkhVrma2E63CuOpg+pO63yMW?=
 =?us-ascii?Q?yCLKKI0m19r49gxEU/VVIO/02I3mYR5co7Pyo7WMeLhtZcPQnAO2GbmQTo4I?=
 =?us-ascii?Q?eg6ll4hCyH1QT8xzspLl/EtdsJTfV0bNi+OFgzPAKJacb8kMYq6FPFsCu7IL?=
 =?us-ascii?Q?Lej1RNxv5E96Dk4pGTpyTnZX4TjXT84EHvgV4uM1PI8cL7BRISBOXWz3WhgV?=
 =?us-ascii?Q?Dah4XRdFTs16lGQ3Jgxgp+eekli00H7h/na/brH4iA6XLuq7AeEjqbKul65W?=
 =?us-ascii?Q?SLqCixtCzclAfhr0S93cKzahyjGPdmzRnJwE1cA3zLYvwJchT7+rtDrHFVS/?=
 =?us-ascii?Q?qmEHlOHkN/V6N6Angc3FMIYt5hS2Zz2UHe11ia1DdustYkRCg5XKABGWYmSl?=
 =?us-ascii?Q?5QTWkJx1DGjY5bel8eckqIojAXKSeiKiePDtDoiBRKUkwwdcP1Kz1Qp2HH0x?=
 =?us-ascii?Q?OeQEmjJ/ztc5tqXHww8R8/weTT4pqfG9rIc9KjlomqALwX1WpsCftRc9xn5r?=
 =?us-ascii?Q?KCfcwNMbu1lyo6aXFVKf2+FoOrN6NYiUn+bTXsvFbz5ueWgbIvUNkzvV4Jaz?=
 =?us-ascii?Q?Ccvj8DAgz/jGOVOfrzPNVN0Z9wP3GPq0yxZDP60B71VGm+XlDywx2pNso620?=
 =?us-ascii?Q?eYo9HxA8rjS4PNFWVdll77FpNd9+kItdgTG20HWyQX+O/k5U4YrPcolizcYs?=
 =?us-ascii?Q?5BLmKQP7X/QiaNhtx0dpWstQbIzdDVGGJ6lRZ/1Ox287hVB2Pvlj0Limn1CZ?=
 =?us-ascii?Q?PliBZrsBkcy3nNoT77gkXJVWL+d1zwsdjBmYUMPKobrYqbc5vcb9XzgMGUTm?=
 =?us-ascii?Q?MtUXxJDk1ppx3Xjx0ijX2bcZkeVul3myNdTDgZCstuW3UKhJZV06gJ+beKXr?=
 =?us-ascii?Q?EGmxd1iO5+lH3/+zgBGycYzsGImtZg9Xs1JvH737/0GncA56ofgX8oIQoTcn?=
 =?us-ascii?Q?OTbzTcY+EXA80NsZFFB6bUZ5xFeWAQtV4cVYgvMDm1xStp1aO5E7DiZvwNTT?=
 =?us-ascii?Q?cQnAqrWIaYTM3lev2FhFygU4cqVAq6ykzQLU6sRwLc+v7LH1qms+UdgXayXq?=
 =?us-ascii?Q?3j8vJspRZOR5EDv+2xmlBjV+Vfztw9a4aQ5AZh2IJrDp9Z0ji2fTBkqHIxae?=
 =?us-ascii?Q?Q1FDUGnOng0OLBIf7HSBcGePugVNjWu+hsJXxSa1owbDV3W3o13HRpdng+f+?=
 =?us-ascii?Q?Y1Covq8Pu+VYAybiI8FU/BRfopIhTuXNxA6DYtQUzj7Ci8RE2EPdmLcelQIf?=
 =?us-ascii?Q?krauf1WGQWxjUcMYj61K7x4m4PJhAyzbYMiWpBHlINa8o//nSVwNml0kvvtR?=
 =?us-ascii?Q?/LICrZndQRPANXwq0W/H2rf+80ztRr2W8w3JfZrz/kWlD5CiPBoh4AlhKuLq?=
 =?us-ascii?Q?W/QlqWzZj/UiUv7of5ryS5MJsWdnvRogXgkyo4/L5GBllU2QQdnybGUxfwc2?=
 =?us-ascii?Q?r8qxxi0eMg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e81674a-951d-4098-7d29-08de899697a5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 11:15:01.6590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VV42huk2zmtYLEVTjVgt4bTv+cvpcZuuSUcnvex2UUQogTPtRIXeIuVxBK5t8SKt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8818

On 24 Mar 2026, at 5:04, David Hildenbrand (Arm) wrote:

> On 3/23/26 22:07, Matthew Wilcox wrote:
>> On Mon, Mar 23, 2026 at 03:06:43PM -0400, Zi Yan wrote:
>>> READ_ONLY_THP_FOR_FS is no longer present, remove related test.
>>
>> Um, surely we want to keep the test?  It's no longer conditional on
>> READ_ONLY_THP_FOR_FS being enabled, but we still want to collapse
>> mapped files.
>
> Right, in particular this patch would also remove MADV_COLLAPSE support
> (not just khugepaged support).

I will keep these selftests in the new version, since the new one aims to enable
READ_ONLY_THP_FOR_FS by default for all FSes supporting large folio.

Best Regards,
Yan, Zi
