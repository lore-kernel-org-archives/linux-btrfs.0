Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC9528505E
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 09:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788858419; cv=fail; b=ryselkeegq9/10JZzOZGXk0MXN2auThSQ6npAuGFC76xffsEMHEF/eIn3sUS/Qzf8N7mlwNl3NAvRcRO4Wg2HAmT4+KW0jrNXHzlSM46gU97fNXkxWOJCbKGLEXByo/2KAwlwXivkvkGXLM+RpXOV+EMHR/IvCl3SXPr+gPMLTs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788858419; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FWpkID/rdFN+gxgmtuVhEjdhQyQJdrLkT7JikjFTv23l6A+AZYJpiNhhTWjoLLEgig1kcJLp8BLOWMCZFCa8CKOZOrjHY7KihVs2gZEa3h//jy6wjwsmhYknLy00T18/j18kFMdOoXtbmmiPYGfnnNcFucD0NZBc0rgvAMpIuiw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=DxcVjE2L; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=y0d+WVMd; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="DxcVjE2L";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="y0d+WVMd"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788858417; x=1820394417;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=DxcVjE2Ls+Dghtp17MMFiP6qk9z/pk9KaBsm2EG/iKszWeeFxv/N+eMQ
   yCppr2lsyy7IO01G0t4fLEqDaaEzWimCMPKrh0Awve687ubZ9fuvm6Owu
   FHMjyKKj5HQNkYDLM2MDp0y/Y/gZzXZeUVPitCldRnh268jcyCEyUmPRU
   VAN+6ZTj6UMH31gfjoY5eiYANH1yrkvflXqUap15LHwOBw9uD/6mcWgQL
   uc2nLvUVbF1fDeMFR/l2aRiikCxeAFNXwPSkh/1sAwCJpxa84485OsEfW
   1iklQz5j5QqJTRStweLtzATUho6gq2DB5kpBk7wpYffNPEiEjU+hxSYLA
   g==;
X-CSE-ConnectionGUID: /fcVVOK+RSOz7rbkPQh0uA==
X-CSE-MsgGUID: p3MpUNcnST+Y4ozvtWUBFw==
X-IronPort-AV: E=Sophos;i="6.25,268,1779120000"; 
   d="scan'208";a="153598702"
Received: from mail-southcentralusazon11012049.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.195.49])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Sep 2026 17:06:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DDUf6Nq7L0XVd5G7zARCi/H4ODndyt1xX3mazBhEax1QooXUMOam11Zpp2W/1USwIQXWMCmhp03vLrbSnndiSOcvySiPyFP0/1MuxGtkMEPcHwTv/4j4uDM0EXOHLfok1NKXo2T+KNPHGe5pAppR6i2bxyfyu7GF32ywd9U8VkjnkC/mVjV7LTF4KbjAJ52o2F6vtX3vmEOBo1wVUjxQZum8T7MgvC6KJKirxTjXwM3DdQNGfu557lnvJT2AgISWVPo65h1+BveH5Qe5MV46EBsRu7Lq7Kd2hdgvrYCkSKAcA0cCywcjsqres9OlEp0JAOYUyUiNQh57lM5m8D608Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=pVvgQRBaDyBTaGbsBxA61dkIJ8xDRRBJUx2NGD+VZ/5gELjU8/1vW8ttCprSUhnrCOHMtty3iCBCAJn8gdKzg3M8GShY1faMK+3levsWPvEw+aRReRdhgXZn+4GgH/otPTiKZ0qUWe2Vqnx1AU8/fygz/4cCm1M0PyBgWpwfU61UBv4xgAUIpSBW5YjuDy+Exy7BkuEG52ulBrZWWiPMdG1DYQNnqhoPEvCxN0rjZel02Ml+RZt9xRPcm5I1nQS0avMcT4gncCdAWZws/ggo3F1YToKBMUkJ0+Mr1sCtY5JNJtUCQXOxJ0q0uywIYbmq5j8DY8itu2k1zceZDUd7Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=y0d+WVMdhlXAATlvTYw21RqM2EeC3t7BoJ8w1VfImc8998H0o7CTZnr8JdBaAv9HEveXg0GeaMJh4ziATov+L5FKwsz4zJzW+SJftUZcCntG3v3lzDX9VsioMzGiExNnaDEaIIy3C7zyCScT1414Q0aYFwtn1droBVFoJN+iN7E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MWHPR04MB10252.namprd04.prod.outlook.com (2603:10b6:303:2ae::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 09:06:54 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0406.005; Tue, 8 Sep 2026
 09:06:54 +0000
Message-ID: <08d117f0-8b74-4a9b-be02-e2990125b172@wdc.com>
Date: Tue, 8 Sep 2026 11:06:50 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] btrfs-progs: unexport
 btrfs_setup_chunk_tree_and_device_map()
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1788743334.git.wqu@suse.com>
 <8f81fd77146eb7c6ce5e76cdd8b3a9e156e5cc72.1788743334.git.wqu@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <8f81fd77146eb7c6ce5e76cdd8b3a9e156e5cc72.1788743334.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0305.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f6::14) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MWHPR04MB10252:EE_
X-MS-Office365-Filtering-Correlation-Id: d8796d06-4e14-45ca-ca96-08df0d8886d9
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|19092799006|10067099003|4143699003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 7iiZACy2F8rQ/70bl2zb5fPSJ977GwhcW3RSRuykssm7RGc06cD+CQWPd1KZx0GsH6/JJZ8QQJSMAb0xYEXqCFP1C++eARam4aOnZEFH1V3EOCxeeiB6oEHb68GxbEkkQYSZD9YhTZrJpOfms0stOlY/DOaJlzdxHLU1cpf5fb/t9vYW8ARGwKNXaG03fRcdB5GCPHCQTNeNtaGEU35qLU5LqT1NXnpQ/SVviAQbTU5y8i3UCx2jHulkRSIvxAXc3K4CQX/RMvxe8K70nU1/N5+vphOL10gVIz6Ug57pb3cIFhfvCTpcVZicWDR1HPPnWWMcqLSQxcFD97LhLeHCP+HDU8LMDBABqJ3ntu8YIFjpvEZoDK1aJY4xb/XjEFG7Rf9Loy4wjNF9PCW5hvxuX+108hdzDb1cyc1tjSrWoBpRBF/B862oR5+5RwdZH+8xHgYpkYZyr9Np5HlTYNOAlUB55A+oUFRWLy8Khx0ox2Frd8jCwVIOY3YFmzgl2Rotaj+5u8B8eGslldczLuZ8aeF57iTqtX0LqgwmHr0klfXYnWxinc958Pcni0ukFh6Lhwf+G6+n++3ezo/Wmo+bePzJlKa66Za2NE2VOn55VPVGIVdm7u1dhzd50Kz6sIhVJd5qXdEaI1/Yn/uWwzHGXStWmomRe2gpGbUBlDw2lBA=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(19092799006)(10067099003)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?RWVNNWtYZ05lZkdpU1ZGSVcxMnRPQ1FCVDVOSWZCNXFYUHNEa3hZcHdOWmhJ?=
 =?utf-8?B?bTBJUFZiN25ielYwcG5ZTE0xTHdMUmFQVi9KcFRIN3Uya2F4K3NZdGZqZFcr?=
 =?utf-8?B?d1hTT3E2UWN5Y3I4U3BEZTNXL1FTOEwzVXpFVmxYRGJxR0JEM0t4LytzYWx5?=
 =?utf-8?B?R1p3VEQvdC91SGoxbVNybGsrREUzQjZ5dllDOTBFN2lDN1owQlJPc2VWdUIw?=
 =?utf-8?B?dUVCMlRYOHhHUnlSM2NEdU9pNFpDTk1xdkg5QkZSTk9LUVI4VlhxNDBQSEpp?=
 =?utf-8?B?RU1RS2hFakwyZEc0TWNVT2tJNit2STVCbzEydXZxWGQwZ2Y5STFLVmZNSWc4?=
 =?utf-8?B?Q0tBYTlzY1BhdzEzMkU2bUtMeXkzMDFxRVd2V3N0dytJekNwN3ZTcXRObGlr?=
 =?utf-8?B?NUp0Y3pSN2xwUi8xTVNnRG5aMVpLM1QyamtnRFpDTHJIMjlWU1V1K1UyUFVu?=
 =?utf-8?B?S2FGUEIrY1Z3TXFQdkRPK1N3Mm9FSnQ1U29NL1lmSzQwZ1I1U1J3d3MweEFE?=
 =?utf-8?B?b0l1cXg5Z1ZGbnlSSzJpMk9SeHRvd1JmdFJISVRNZ3FlVG9vSWNmSnJMQmIr?=
 =?utf-8?B?cnh2ZXZXTU84RTY2WThwNHFlNm9ZS1h1djRnR1VRbUZ3cnpMbkNXU01HR3lM?=
 =?utf-8?B?SkJiaWhNQVlYMTlqbUlTTjgyeGdHaGQ5ZWNYZUQybGR3TTZHYnZHNEo4YjZi?=
 =?utf-8?B?OU1kZlFRVVBxVktjemUrV1JCQWtxcC9yUk5KNmZuRmZLVkpOSXFORyszTVV2?=
 =?utf-8?B?Zno3THlNOGhBWU5GM3Q0dHY0NCtqeCtKME1FbnFtaGlzbHNjVTJvNURpUUYx?=
 =?utf-8?B?UUNqaFJvOTliTTlQN2o3Rk9PRGxuU0lPUkwvUUh6UzNyQTRVYzNnalowTU1s?=
 =?utf-8?B?SnpueGtNalRZV2I5RFpiM3JQdGVsdGNEenkxRkJmYlkxQTc2OCtOWnA2UEFh?=
 =?utf-8?B?NTdIZktjbGZ1ZlRGSVp0Y0FNSUxNN3VUYWZpZWtOQ1krdFN1ZjV2V1BpWDF6?=
 =?utf-8?B?cXA5Rm1ibm94MDJaLzZ4ZFR5ckcwaCt0V1kySGZQM1VxbzhpU2hxUHplMFQ2?=
 =?utf-8?B?VncydkRPTFhMditDM2hQSWZWM09qeWkyNUZ0bTlOM2ZzU3JkMGdSMVg5RGIr?=
 =?utf-8?B?TzFRK3dma2x3Sk1PYzFLbmRYQ21mN1ozK08rUlBiOGEzZXpzdEpzclYyN1E3?=
 =?utf-8?B?ZnFkSGJ5VkxLeUREc2dxU0x6K3RzWjlObTliU2QrQjJMVUpiVGdTYkhuZWlL?=
 =?utf-8?B?WHdYbEVSa2dHbExNa3dOWk5XekRwcERtZEx1a21ySzVmTjVVa3UrUlIyWW96?=
 =?utf-8?B?V0JQbjlUNmdDZkhKRktYL1JGd0piYnZ6RW5KREZKNThiMUR3M3dKMU5BenVo?=
 =?utf-8?B?VVJxKzJKbjFCbkFZOVpKMDBqRmtOOXFOYnJOczJlbDNRd1VGOG1Qek5xak04?=
 =?utf-8?B?d05RczE1MXMwc3VGTy9ncU5zTWU5Z1hxYjh4QmQ1bnJENHZJYTZhUlBSZm5B?=
 =?utf-8?B?YjE3bGc0UWpQVEYvT0ZOK3hiVTRQdUxJcXZZT2Q4YkdHNmdoTUN0YlY0dXNH?=
 =?utf-8?B?eXhuQldXTFBNdTN5RTd5Z2wzVnM3Q1NoRWFVRzhOa3BrKzBqQm1UNHlHVmZZ?=
 =?utf-8?B?ZjU5RnNWbzZFbzl4dnhDTzJBekJyOWwyZUNTMkM3czIrTWhPb0dPRlhnZUF2?=
 =?utf-8?B?YlZ1VStoRXFRK3FxdGlxMkFLV0tNRDNONklZVTFrVFN4aTNhdWtGODcrS0dB?=
 =?utf-8?B?Z29tVEw3MnZJQmREcDFhZ3ZDMG5EclNlSEYwSk9waXRnSkQ4TnQ5dG9FMmU3?=
 =?utf-8?B?TFhWcXpUdGJ5OENJSk96aFlFY3FDQXlVSDl0SjJJc2NhWUVvVVo0UHJKTjdI?=
 =?utf-8?B?ZnBncnVSREdtV1lXR2MvNUd5SVFXZzZEdXNiYkJ6L2ZTLzlIOWxpNEoweWp2?=
 =?utf-8?B?ajc3cFUwWlNpWnVwRXdobi9xdmM3SGRuRGRtVWtnWXkrUGl5RVppMWNSd2l0?=
 =?utf-8?B?bWhydTVHcER0aG5UcWtZWkJZQjhLcDZpd3ZJUUszb1YvQU81VnV5d0xnM1lZ?=
 =?utf-8?B?L09MY0c4T3ViUzV5YU5BclhFUnJtSjk5bWFIK25WMTNjWDR4THlwbG5MUjRY?=
 =?utf-8?B?d1c2RWlMSFNXWEhITnpaS09UTis1Wnp5TUxrQ0drMktQbkRxcHV2MHg4eFFo?=
 =?utf-8?B?ZkFZS3RvSERzSXViNFJyOWZPMjNVcGFNMVNJWS9OeVo3eW1BNnZpZk1QbWZE?=
 =?utf-8?B?UFhmRDNINnk5NUxvYndZVElVRjhNa0ZQMGl6MXlaOVFYNkVuQUNKY3QrR0lC?=
 =?utf-8?B?VDNOYlArTUUvRmxWeGhZRFJmRFlmbGJ2dE9vM0lXN1B6Z3d0UTkxY0l4L1Rj?=
 =?utf-8?Q?8nWRZ9nRyXebeeDc=3D?=
X-Exchange-RoutingPolicyChecked:
	r6Djwg7/AeJt0HJDS0+51pVMqdJl4GY9j/o1WiDCRSNrvtNB4H6Upw+Cl2F0H4zdfX7/P6Py0lOca+KD9CMv7S8ScgGobkcCP5gC4y7pQvtbfpSa/lH+V4XLOfjKgv/mv1iesvQL1nKhXGhkfNCmfkpJ+/ZC9aaSrgLJWYtmLKdwlQiw39OPqJn6PMi9JguTssB2PeNeSnv5R+1YnvCMTf4xy/pTtgXbNA0RV6ZBRZi4RKOQkf5kfaiVm1CA2jakloJ123hcNHKUVCENuqJTb3EeBVIrDZletZ2KNbkYYi+hfiFMpvv6nmd+hYMvxMsbMXlX+ixwxrT31EMDtGUBSQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yaLlGangqM+cZzT/XUSx6i3UFhyJ8AzSOm05ESLoVfCqxT6/5EgUkWIp1ST068f2TnX5tkqNBilaBjtHLwJR6uEEfilDrQWeNqAa2aXyA/ablCVqoWPgVE5UNNNcr/sN1LYZFQtQbIYCPYb5d3TCQ76BSq1uDhLF1MGSZ4/qvl1Pws60OYtcfRjgGdNEn/SmesjFr+aEIPrz3X7iBL+G3PqcnkGm+8ScccbszwpFyoz9YIQ0mCA7iKKGmVr5ezh7qYY0cyo1U2SkGjjPYCOlthPkV5EHhIT10Y2qq3uowpYT3LftYBiZwEqLZ+/MSJWmPqeA1Er/lytSqwqUCNhXCnkaEk6FwgYmYTzioCq5WS9orR5447wAK7Tb1jd1NDtebQ3WoA74dj4JYz9gs7sqmzeeS7leO4OZQFhoP7hRW5ssaPkGlAn/rBf7NnlD+tNgMvJVbjEfm9oB2q3fEFEfGJab616pDjmZ9kxl/4uEOR/nWStMAui2QwY+Ryo9cjlKGh7oK5ZOhvLJMgF6/ZsCV6iANadSi6kwhvezeKgV4sas9+yehw3hUfpI0ma149QVKsiXYqznGaHn7PnNCcXwQSRjfpbD12TXicl2jm/INHU6Ul8nh0x7GWLEdzJHRid7
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8796d06-4e14-45ca-ca96-08df0d8886d9
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 09:06:54.1289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7jXxlaQaHUddSF8enJ7CYtUUAdPd8Th9NEvVdaOUZpPVQuoS4Q/5mnAAx4JRdFerrel7R3idGl6+WBlHSAP36qpAPxt8yyzeW7lmtx4a64I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR04MB10252

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

