Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AE13859E2
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 07:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791876627; cv=fail; b=fqhJv80EB4+AyN8S5on71eljbqmiRsfQeRw77A9jy3zyXCVI5qJS8R/LWfWXX2PvU2f8HHxOajBVdpBemCHcxFslYGgYXoae3DdAdCNklBUyAfEuk0WFFLCe3SBHQVpZw4bcW6CmG59E9DWRuUuJczfAcpc6rMPW7ppOaomo1u4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791876627; c=relaxed/simple;
	bh=zXm4zsqfs43O5pjg6gtDyfhdjT08qwPZX8gT4X07s/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EsBD6e/QeuN/TVLcNq/T+Pf+o/shRgWBnpsviHl8xFc1K0JzrTJnsGtia+P25r3jOKjmu72hb/TvN8gdI7UkobhBDNGaYzqPuMWdOD2nZXN0wD2hES41M5wwJa6Z2+KpQEBmGdvBSvzDtOgxl9Skd4Vb4qdqvrm41dJV1zlSwoo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Q972Qvzk; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ogMdTQwh; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Q972Qvzk";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ogMdTQwh"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791876631; x=1823412631;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=zXm4zsqfs43O5pjg6gtDyfhdjT08qwPZX8gT4X07s/U=;
  b=Q972QvzkdADYFF/HJLWwUbY6ucfPfBxRC7FTgr/JBKZUWuMjr/XPq1vZ
   JEGnz+ORKBnjJWonl0FTziRk4mzKYIx6Ap7jRjlNClQSTFAzZ8qP7up43
   RRHnF9ETwAikFcUbUc/ggKidQJ2u1eiddXfRyIdDG0jP0b6Nbl0tjCrtZ
   5ZGBWC7fVOCl49kp3Lii+NLwOZ9aFmh0w9IoFI8kVDXfA4DMly7+aM23M
   qb+WwzjqYjyYhL8Mzfzj8G3ObKLQ1GiReE07i3jWsDoOcBU5+ase3sCSk
   Q63KoNbZuw9CSnUJlvOZXBKGrBvUogcs2tIbBjCx93zJAov+CpgpyjcOU
   A==;
X-CSE-ConnectionGUID: 650SRJrfSqCDMBMuDMVvdQ==
X-CSE-MsgGUID: VB+pcoMAQCqIAmmM+NnxjA==
X-IronPort-AV: E=Sophos;i="6.27,155,1786982400"; 
   d="scan'208";a="158917164"
Received: from mail-westcentralusazon11013011.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.11])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Oct 2026 15:30:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=akKsVhFavYkujrXylznFKhu4tPzl44s0K5dfVp15ChHRAgMLEgZljON52yBLPwmv329dVRIhx/cv5oHBeVwCbi73Uqyf9XSvB1da47CokfNLoR6hdlhEpb10nYxHOyOBqLH2bUYcR1Fg8KJlGlkkgQWVUDk+LnRfCgNRrKuNUihuaNTsdGU0BYJhxHp/t93pS/c0+dGY+2PB5+eXfeQNC/db8aVHqTReT3awQ7tcASbjmNcE6DUbSWwVCUvei0uPbZhxXRkJUv+1fsBXLhovRt6QcjqW8Z0P3Ss1UX24eIF8WvpyPdXTD5jY62XrgH1WRG/0JY2qaf+I5p2OWR808g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zSPr+nDJIbYLak1IYw07a/j0pPVP8qOL5C9qP2drIEk=;
 b=Vz6bV42QwqMEWkXB46iHXevTsBV2KUj10ngNdgLKXJqvdpa3WWGmqUnmwklI7osDWmXBGezB6XDStyFMeG1xxooe7KrHMuC8mdIw2cGaZBysrLNOTrB97RJWg+WUEKxkusHgmU8WAt2mSR686hjxGg3ldP/ykriXeDfZfpW3FJ/p2C+MiEDfg5d2LyWtZZaTldsvC53fyPqPxJhMyHZKwq9c0czFmeKewEUE+IxGkpRZY3i1MtYqaL2wEBUvGbRNacSAR0D++Iy7rdP2A5eCV26v6QAlUQTizNALRwr0SUQgwcj3bKM3j96QbdqRSMWAYt4ZPBuk9j68EnlSh8EsAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zSPr+nDJIbYLak1IYw07a/j0pPVP8qOL5C9qP2drIEk=;
 b=ogMdTQwhbpGHsxnMCNvW4EeWO/tOoLx6pwMKWmtYAWgKH8B1EJZLWh8J32do3F1mrcS3/pwp46YGJuhxLfBSnD87S/jR7vDMHQA75PWGPiWrJb2ifsyKd7DOD4UrMUQSyiU6IIRIt5DWCnDU7Wkf8NoM9Cjd2exGbyo1CulJpSI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CYYPR04MB9031.namprd04.prod.outlook.com (2603:10b6:930:bc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 07:30:17 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 07:30:17 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 02/12] btrfs: zoned: don't activate conventional zones of mixed block groups
Date: Tue, 13 Oct 2026 09:29:31 +0200
Message-ID: <20261013072941.424029-3-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013072941.424029-1-johannes.thumshirn@wdc.com>
References: <20261013072941.424029-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0017.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::27) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CYYPR04MB9031:EE_
X-MS-Office365-Filtering-Correlation-Id: ee132a31-15cd-4d6c-bdf9-08df28fbd45d
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|366016|23010399003|1800799024|376014|19092799006|56012099006|11063799006|261009223027099003|18002099003|22082099003|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
 4pL1R/Uri5OZF0Y51qqDS9s5LpICWickjpqZMue4f6sU3zQl2EOFWQ/KMAyud+Ja0hU2VWXLtYQBw/h8rdcP9jlJjgCAJkYszUKVflnBozbnF4n07iHaJWZoxcX6cIkH8jCP1dsCbp2hkZK9RalSCpT9ksBFh3OXu4cVafFaVkaNKxg93HqDxtYBgmddGzW+IHOeJaljgF4wJ1aCJfnIvRix6lQ4RKCCDCV6Up7xG7ivMJqP6B9uCB4GKnmpAg8f/SpAODtEAeIdi6hlvjBjZ/+MKVRAtRk9gXrbmrE0/FHhYOGAec4DnOk8TYN+RbpxNifqjyULsJMrdpmqT1eAHNTfSwCbOX7y1kCSWWrdcn0qnJeNbL/dMlVmETntNUm3gHPT96yJIoYitnj8s+BdlV+E0pbwyVZTPRApaVjvcd49w5h0BxKgJDnlV0VbB1012prum7PgolbWQBkENyx6lIEXRpB9vfiXsJzw6+tg1OQ8bvnTPOyQUdzT6tUZ4UTd8mDde2CDE6f61DVyc9eNQf+a+Hx2BEXehu6Qhr+qBiXi8VHEloO1ZcaUITzZJkpPpuahTJXYAzyHTACUIj2LnTbx8pvngoG/lRQ4t6C8qoGGD6GKPOZ4Kq7xsvtDDzLfdhEU1NmJMqLs95ly84hyzhFzqXmy4G3PB7OrSRe1rfw=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(1800799024)(376014)(19092799006)(56012099006)(11063799006)(261009223027099003)(18002099003)(22082099003)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?h5mUC4RSBZ5YX6jljANHO34BNJ/cDJiLXtJWqaH9UVcDpWrkbicNfYdhW5PU?=
 =?us-ascii?Q?M3CURj8oabVvo+ojPSojboJfh2+AV2seMYf1wfMOKlvhOMkf8xenrzm2OVsu?=
 =?us-ascii?Q?s22Pn9ASlKf2Q3nq9qmRRvPMWU2/DNsM2s2MCZAOmFV7LEdi15y0WlmnmLZA?=
 =?us-ascii?Q?XysmAt57M8u4GcGr1+io9NkoXjC1DA+0SGHrYPiXImCCBpCIXU2X6qXhYlPp?=
 =?us-ascii?Q?8GjXnhHj9Yx8DVzXKCVXZDo5yHicamoGk8Sy2+VF7uHF4WZYalooCxWRMmCj?=
 =?us-ascii?Q?bzyu+/lmMkbKeialHP92/TSYZ7tgE4ZzmUKy2jvUxVV1ZiUzdSDdPUX5bvQy?=
 =?us-ascii?Q?CEr6s2R3wPN/5Ja57lQ2lJzP6mhzpyGoX7ETuaCofRPdu8Kj+3ZfBMEEZcNV?=
 =?us-ascii?Q?8SowxdvyGdRyG2KTp/kr5Pan+AsqLLtHOXGe6SVyhUs+DNnjTUJOO2/ZvdAY?=
 =?us-ascii?Q?8tHNubgAJmE4byOdy6K1feEAY2kg4bCzdc2VdI59erVwNzYkKegQQCsc/3El?=
 =?us-ascii?Q?EtHbXWlubpnAI9NGc+gOV4s0zZ9/hiE5KZ6SLnb80PaKw3DWZoTBEAyjp6aJ?=
 =?us-ascii?Q?dtgbQHInTMLPdeX1fwcts7VwYA01c7ykvTBVH0aJFh1103OVaCfMcWgfu4cU?=
 =?us-ascii?Q?p3D9ZUKVkS82+s3OF+fN0AqSKWiQiW4f0hqYhAA+NDUPTPoTdpD+UWWeFHNc?=
 =?us-ascii?Q?wgG6ubIFQsX/Lfsu/ABcC0Bb8O1A5gkICLkuhQliJpNuvfUGCcR/KHRp8uJo?=
 =?us-ascii?Q?CKz9TW4XUGBjQtHWwUc5Z95ui11jiWavk6W6r0o7496Wm8uO4gpgCMYXvZf2?=
 =?us-ascii?Q?GIFNOrIjwbP7jkJAczOQ/QQezA1OX1RSV41dLoqKOFetzT7f5YqB6IVyz6At?=
 =?us-ascii?Q?dnOevnHofhCzjwo8BC2/A6LHKbvyDimyjQuqRFKoB9oeS1Y3SciiFDcCxvS+?=
 =?us-ascii?Q?AwpOBEYrNIcDC+U0Ae0aZYUs60pepQADduEfXloyz0DP0iOilOs49f/4HCtU?=
 =?us-ascii?Q?y5otT5o2c1CyBE/TSN+G/NY5LLGI0GLGRtPKU1nMzCqT59vcGphsB2GkY7J2?=
 =?us-ascii?Q?qd61qv0CjapXtNiIpk4s8ioYA+ILFvKVd29HiklZ/u/U75q+n5nWd8Xz4LfK?=
 =?us-ascii?Q?UbV+BslNf65wyagUCesslW3Pki/2+ijhCF2AfDadF9vMD5vStsLX53GUnOZK?=
 =?us-ascii?Q?k1ZKt0HTaJjAiJ1mpo+n0l7i0FIUOEcg2TohEBp7lxTBhS8ECWfYT3noLuja?=
 =?us-ascii?Q?fPaWjDkH285tvSYVWyM1zMj3Sphqrpl5K7+A9R2/hbjLjyHAyJ81XIQc8pOs?=
 =?us-ascii?Q?Mbjo/ya/arNMrq0r58P57617IiYXPFJpDeY6l4I6qKzdTXN2td4x+6l9Y/jA?=
 =?us-ascii?Q?D7aWhsMjPZnrG8/hxtkI/7HAheWlBpQ7hoCplCqqDClXCEXyqyCjB2PgcA5h?=
 =?us-ascii?Q?oUljIeeKggIm/rSFnV/RpuZ4SwsOWwwMb2BBrnZbGU7/V/47JrfaBMPIjoFn?=
 =?us-ascii?Q?fI8jTHcgMuPoeQSKpczqRXAGZ22IkogLIHZ70TNIxVfPY1EJavy89L1s77e+?=
 =?us-ascii?Q?JLE8yIxMWN71ACLBzj3cf5w129+nhSRBqvGG56JpWv+989vwHSiDlKC8DEZO?=
 =?us-ascii?Q?UuBBnnZakw/7ytaJVgO9ZCO3rLMcsV8nESyBfgzi7Q8XaIut+MmwVWTG9/xL?=
 =?us-ascii?Q?btSHteR5FfiArcQ0aOonTkF+/wIY0MAfZY8G6RPnwECWXlmBwOrgt6Pro257?=
 =?us-ascii?Q?BbhLhJATB2Sk6wJ79BeDmzMo6JdhxCTQf6sV9d5yXhWMx08lbWvmKUsuzK6g?=
X-MS-Exchange-AntiSpam-MessageData-1: fzmsFJ2XBGFG3iY7bHHfLljqB7NN5oIPxYA=
X-Exchange-RoutingPolicyChecked:
	bfAjEpwEQhp9NnUiYQN5aazNwpTVx3vcu/7Zv/D61/AShHX6Kwp2t5Z27AHD2/M9h5DHKGyI/7SYTfSpJ1ivFSGL5X3m/Tl0YkKO5M9NmJv6ctLZSd1ZvA7FUkEqNteJGqzGJKf4DfNwAEPxae2v18Xb5LeCY74+wTfkuqIOhg0nOPlzntqb5HUKNh/rfZ4u9Z3cnjbpB/vvDjdInrDkUjBFa5bFLHrTFRYbAbBiCxkl3R07GQx1YIe8BzxKiVUHOfQ64i7Ddi+h/m7A2zRCvFtq9UxlNcQ+McgLo6nCqIUCIwRmKkao8J8XpL+KaK6+jesgAEgTIdGdS2/i1PENEg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tbMoQ3W6yVoJvBp+vAt8zA6Q8knD4eJqTdpEq71f3vld0Zw29NW/pvKMfTV2PFnAfwEipwkZDTwZtRkcjZPoEghrbw1O3pf3phpzCUg1echzZGz0mlcgjK2f5uz2NvVqZyMBRaZ2WqAdU3qigchx2UU6/P7OzYmFV9yqMjRFxszjhbNccxXaDesYvGhcM9ULoh9J7kYdraKe6FhB4P4S2moncktmXHtmd+bO7Hf+W4rWcbhy2lbyCUbHcubFaC37aXf/19frwBIPUqMw6XJ0IFLq4ID2j2VjnAGxo/sTOyqSshYoWNL+FmKMstzdCqXkX+G6BwgR54kUce3/g13xfNH3mtb7snZhEl+wCxtWLbAM/ceQKb6H8Zu4+wKvzkuXWfpbhjncXDWZn2zFNxSUoDlAThlFDJzoSVz9WP/Pzc2YPXhwA07WasyHWMeIsXUsH1SfHgJcP9VGmgiCm8r9WYckJeJkxEixrqfAxJJkA/T1vnff27i4BQi5DRyPAFblByoNWVN+XK21Nz87bfENaqrwFkF5p90W6louPNl4YZ66bTq9ChL4i6NmlCeuxve0lqJ8DUt2D6iqpiHwNjXhgzqLYuD57q71IbNxOk6FCwB7pSxt7PpwxrPXGcpU/5xT
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee132a31-15cd-4d6c-bdf9-08df28fbd45d
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 07:30:17.5500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0wn5nSXjTViD6KXk27dItD9WdIeblhB+YoZw7Ims8ziPY1ioL5rBippf1D7rpx/FRhZmCXuBS+4mJ6XM5jxJtAzrlWnQuzKQe1wYhIj0JOQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR04MB9031

A block group can be backed by both conventional and sequential zones,
e.g. a DUP chunk straddling the conventional/sequential boundary of a
device or a RAID1 chunk with one stripe on a conventional zone of one
device and the other one on a sequential zone of another device.

On a device with an active zone limit, btrfs_load_zone_info() never
marks a conventional zone as active, as there is no zone condition to
derive it from. If the sequential zone of such a block group is active,
the DUP and RAID1 loaders see an activeness mismatch between the stripes
and call btrfs_zone_activate(). That takes an active zone from the
device's budget for the conventional zone as well, although conventional
zones never consume an active zone resource. The same also happens at
runtime activation of a zone, not only in the mount path.

Let the conventional zones of a mixed block group inherit the activeness
of the first present sequential zone.

Fixes: 265f7237dd25 ("btrfs: zoned: allow DUP on meta-data block groups")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 50 ++++++++++++++++++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 51699136405d..3af234dea6f5 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1959,6 +1959,23 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 	if (num_sequential > 0)
 		set_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &cache->runtime_flags);
 
+	if (num_conventional > 0 && num_sequential > 0) {
+		int ref;
+
+		for (ref = 0; ref < map->num_stripes; ref++) {
+			if (zone_info[ref].alloc_offset != WP_CONVENTIONAL &&
+			    zone_info[ref].alloc_offset != WP_MISSING_DEV)
+				break;
+		}
+
+		if (ref < map->num_stripes) {
+			for (i = 0; i < map->num_stripes; i++) {
+				if (zone_info[i].alloc_offset == WP_CONVENTIONAL)
+					assign_bit(i, active, test_bit(ref, active));
+			}
+		}
+	}
+
 	if (num_conventional > 0) {
 		ret = calculate_alloc_pointer(cache, &last_alloc, new);
 		if (ret) {
@@ -2450,6 +2467,9 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 		if (!device->bdev)
 			continue;
 
+		if (!btrfs_dev_is_sequential(device, physical))
+			continue;
+
 		if (zinfo->max_active_zones == 0)
 			continue;
 
@@ -2516,6 +2536,7 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 	struct btrfs_device *device = stripe->dev;
 	const u64 physical = stripe->physical;
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
+	unsigned int nofs_flags;
 	int ret;
 
 	if (!device->bdev)
@@ -2524,18 +2545,17 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 	if (zinfo->max_active_zones == 0)
 		return 0;
 
-	if (btrfs_dev_is_sequential(device, physical)) {
-		unsigned int nofs_flags;
+	if (!btrfs_dev_is_sequential(device, physical))
+		return 0;
 
-		nofs_flags = memalloc_nofs_save();
-		ret = blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
-				       physical >> SECTOR_SHIFT,
-				       zinfo->zone_size >> SECTOR_SHIFT);
-		memalloc_nofs_restore(nofs_flags);
+	nofs_flags = memalloc_nofs_save();
+	ret = blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
+			       physical >> SECTOR_SHIFT,
+			       zinfo->zone_size >> SECTOR_SHIFT);
+	memalloc_nofs_restore(nofs_flags);
 
-		if (ret)
-			return ret;
-	}
+	if (ret)
+		return ret;
 
 	if (!(block_group->flags & BTRFS_BLOCK_GROUP_DATA)) {
 		struct btrfs_fs_info *fs_info = block_group->fs_info;
@@ -3098,8 +3118,14 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
 		      (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)))
 			continue;
 
-		for (int i = 0; i < map->num_stripes; i++)
-			map->stripes[i].dev->zone_info->reserved_active_zones--;
+		for (int i = 0; i < map->num_stripes; i++) {
+			struct btrfs_device *dev = map->stripes[i].dev;
+			struct btrfs_zoned_device_info *zone_info = dev->zone_info;
+			u64 physical = map->stripes[i].physical;
+
+			if (btrfs_dev_is_sequential(dev, physical))
+				zone_info->reserved_active_zones--;
+		}
 	}
 	spin_unlock(&fs_info->zone_active_bgs_lock);
 }
-- 
2.55.0

