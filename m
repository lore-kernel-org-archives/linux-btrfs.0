Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590149;
	b=NtvQCIk1a0S0eSO/1vFc9uckDxVO2Ukxa51FA1IfYJ8womS0+2aZol3yBGV51uFciwGs
	 ECl/Fwm4VFcfyVnoSeIFlq0M0x8kfWuELsNeAMAmP/c1zLDhAFDJQIA1EFFWvqF5m95si
	 8IWOUUh2QXAaCBBEwsJXUN6NQQF/6I/Y0OndBqhDMeb0/0KnPJiYVtFbZNTmFw5CJF9YQ
	 QIiknyh89Zu3HcIKWF6zxF/IzIF05j0viakjdQcdbZOdW3D6BG8A66ajExZprX/G5WCuT
	 MBnEGOfGWKA6KcwJ2u1BJcmjnP7vQIC2i+THm1zQ9uu72IDS9b+t1uiaTFGKwry2THg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590149;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-LD-Processed:WDCIPOUTBOUND:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=GCTYP+wr+ISsYAq6rQz78EB/GTudad2UirfuvNpJFvE=;
	b=DZwcaOBKlGrxg0F3Idk6zd5QpdvpJOEa4YSBpRak/wZy2Pl8pe8kpoQp9pcTUbDtkEMp
	 SGZvMUNlTEO2N4vKaDrbMB3WWAERc3tVMwuhePstmaSJ186IjN++muB5r4xYYzxrgs+zF
	 lxPs93lEh3JJLfb3uwHtArxGCsOSBG99zY0qJL/cSWhkbg/4FzR/gIJqR+CsrrWzW55I4
	 lTJjuSANpG+mloSI31ilElzPol3JOdYM7caBk3/u2TrH2keoYiHpqci8LwcGRpgXVUEeO
	 esA4rPvtQ8/EO/1Yqu5XwxUMUZTsAFCyX188OGK1H2K7+/RcLHx61AeJXlSMEGsKI1A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=XgWq1rZH;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=nnbnNSH3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84407606A327
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 13:42:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84407606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=XgWq1rZH;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=nnbnNSH3
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792590149; x=1824126149;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=QD2fAmtfSDSK+GiviFbCXpPhquB8RQ5tTk2U31n+Kns=;
  b=XgWq1rZHCgPYBaCdgClunrtRw1HK2LY9X8J2tJTAXh794a5h2k2uHSIB
   ocE03GvkaEYgot81OaM37OYJnzQ8lrI1JJmBt3fsevUX+nREvfWaN4d+X
   /leeRPtWJRWkf3pUOClfpoq5cpXCDh8VwAZ4l5plQoN26DszblDEb60Om
   bWMwTRBu3YhSAEedXBIWKTYcPtq83LL/SC0ZRq8M5axO452cx997BIvf3
   9jc1ZBhR9ulbNH/+h9VWhDYBFuyNPb1MtQ3/1bD2EKFdrWeQ4Os5rlOGw
   UviVEgc978H1Js3WFrHWOUp5Tddq8Q0q25zUGRDYsbO+TVOZomFclog4G
   A==;
X-CSE-ConnectionGUID: I6noZBaYSiCUbhOPmIxw0Q==
X-CSE-MsgGUID: GWGLkHAPQMysLWZkUk752Q==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="157685372"
Received: from mail-eastus2azon11011007.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.7])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 21:42:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kFXP45arvHtG5Z9hL76DICPAtynqmovWD9bW8aWiNUNtemQ1m6dl6Eu1cF+fOYbDpC6CYJaqyUQkfLBfcwxwPa3utS6kclbUF4afIU0MO05Kf+1DcGgsWb0/D4ecFZsSYmw0Y6UC63MpYRWsYJlFGV3sjAda4D5GhSVBb6qN7tHWGAD4n6Wt39NIOvgiADz5DETfjcNyl7xehPWp62f6L4ykq49aJk8LYl/QvnGAFdG3DbJVz8LBl7qQGAduq3fD3FL2b+qnrlceyxNsnurX6uJNeVSY58obDgBW4UY7vLRZ2RSCyc72PHdh42UtDS/Ph7QSD3TEn7SYBASvEmunHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GCTYP+wr+ISsYAq6rQz78EB/GTudad2UirfuvNpJFvE=;
 b=J7PrY119OvXOfYKn+edqD+4PpeyVaIHUYn+DE+yifPYPsI7y7acBpx5ppsRxy0aXHyU+x1wHxAfZ3uD+CXP2v908V2eTc5YyTfIxilJQh3DNH063vdFrBtKZ5MNoHPnB3toRNacgDzJnUKaTdTxEfF0vaixox6QjYv5Oavn4pN65P2686cXp3qSPrvv54bfgcG+h+LzotPftO6NKd0cuCzoAbICbDRMh6x5K2fYVpEtyCp+YSi+R2gORyeTTHGWvFUxQV7xCwo5flE70JGCyyBZJolAtYCENJhXEGLj9X3JV34eSvb1Dg7WOpIAwKuf4DyVCZdqssaYiddCqoukxQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GCTYP+wr+ISsYAq6rQz78EB/GTudad2UirfuvNpJFvE=;
 b=nnbnNSH3WQMFWJzdNZ2EdAkuiaWG5CBucRyPZlLUBOwvczIeGyay2j+yRgJ4p8zJbxInYbF3R4xuR1kaIALGzh+KqG48qR9xhJuDARbgeasnrdjs39OwYl56r2xNQn6wsbaqSSdz9GFGsKFjF7Idw/2peaH4mR4eyeuQk/b5DDQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA1PR04MB10180.namprd04.prod.outlook.com (2603:10b6:806:4fa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 13:42:19 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 13:42:19 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 17/25] btrfs: zoned: factor out resetting a block group in place
Date: Wed, 21 Oct 2026 15:41:16 +0200
Message-ID: <20261021134124.2338902-18-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021134124.2338902-1-johannes.thumshirn@wdc.com>
References: <20261021134124.2338902-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0100.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::14) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA1PR04MB10180:EE_
X-MS-Office365-Filtering-Correlation-Id: 468f3967-d379-40a9-87b7-08df2f791b9b
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|56012099006|11063799006|261009223027099003|18002099003|10067099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 jfys+6oEzfbpfU1jOezu/e4toxLAVCKoEAdmjTPtimoARJX3HTSIuMfEhctk3uWVdNE0ylh2Op+iPYyysavhE1cTDvJdSvpW+gJNUGHGEdd01DdpLiciqx+6uuo1e6yXbt9HLXUrdj2OK934iQwKJalbICB1szoaTu8qaYSuB5qM1dVHT3YCWYb5Whm9K5uK6fFes6tZGGXWtpDnayxv/Ao4n/2tvhZ7BTz+H778QlSiFgsHzHTyKFTyg3D51X9ouljvwWEYP1pOkvYzi3joenxE9aCG/BJvl1TKtvKysHI0ZW1VZzZF9agqnrI9V9O0V2+B4F7MVI09hy2WQeo2gs1apN3Smw+eUxDlcfdTzVvy2QblVws44c3M5nLXNZSCFYfjqT5B3ff0tX1zFMHVkmkbpF1r3XgCLu22gAjkNaUPRrZH+2sH2HF3WadqDnoAQr3AAzmymFLa47fDNVr7ZageTds59Gbs1zYG8gloHpkKh14Iwx3hebnDOVB3N1YG+dpxhvngpBFv9vkpBQac9pRROLTPK79XfR/NnHbNzLppjfQ+7mm+E/gGfOIJxs/Q7UCP/1IOTpcbNoWicgZtJjOy5+j+Sc5uVgrx2tExNnkz6HImrh3mOJYF0DeVlyOOLQW1wB32lzF+gP96XlrHcJF8+lhUENQcZNt8pQVUSF0=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(56012099006)(11063799006)(261009223027099003)(18002099003)(10067099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?Z+lpEdja+ridHNDHrinFr/G6kLkJa+uI47roeSfMU0WHfMGHY6f7N7gNh+WT?=
 =?us-ascii?Q?mNmdm8L8yO8z6zSEzVYzQDkg03TEAJ7T3fabidgSjYTOHCBgWqordh0yHpeS?=
 =?us-ascii?Q?7duJMGvZ6A0yK54BQYLygtLR10+D8zJmOX5197bpmnZTR1gatrGiGNSXxYYM?=
 =?us-ascii?Q?j+0CeK73tkWqDolGKuH2DTk9HLsghnwxM6jPwPQB+zcXYuuLsQ3zNBy8r0k5?=
 =?us-ascii?Q?ESx7wjKkEXjXXeUVJeDHOfZEf1uD2zuf97fcZRc6xc19lu4JE1iqTD2z0PJu?=
 =?us-ascii?Q?Y9h5PgkG0SMmc4LYNikeSqBaUJglgJoRNxOcDU05zAiDpbVQdxhhPavIc9Ew?=
 =?us-ascii?Q?rpLyp5AeL9z84opAZOIDoTrk/gFluDP566xX+8KS9qhV2BA6OXgwvIRT8o3m?=
 =?us-ascii?Q?XBb/IW26FzzfsHDy/rkBqRoWxCn28a7/A2OsCkT+ALGqvM+RpBKfvWQ6Zy8N?=
 =?us-ascii?Q?8GcyAlVwzITJeeBi5IsCxahFTFGYjm6LNNKhf4oy5Xh/C64i5OeeVhnPPnG3?=
 =?us-ascii?Q?OkEHwwb/HotvQqToq/NDPe1JtY8xbPiWY18TSxzlag6OVZ67/gXNUD0pr6oJ?=
 =?us-ascii?Q?1F5JtaHBZx4f91z7RCGdfbTpx4m+blugXpx2yoBtDyRBAa2xvDQWjfyxJ69L?=
 =?us-ascii?Q?8t/ncrw76aIhaDegPJAYIH/C6GIL9SJElMv67JDuZnpKPnfXx5i+DfKx+6U8?=
 =?us-ascii?Q?hI4R9U0aN2hdLlCqEGwgQnAhUaszFEQw5DI+Wzfg7K9NkDQ6/Zm+aj41hcGm?=
 =?us-ascii?Q?XVRQJz0ZJ7PV6Co+K9DDVba5bJ+gyyh+Wrd1otXo5UVzM7uu08zjSei0VuC0?=
 =?us-ascii?Q?aHH5+7xVBVnPQZN7s21Z6QJkm/prOvD15gDohDugZM9takbRoDeD0Sypi5YS?=
 =?us-ascii?Q?qlJhY8HZWTfZ97BpaTrfI+yDhtH0xL6zMpTyQepuSQiU/Zcho2OhAKNmK+W7?=
 =?us-ascii?Q?bEyzWeg+7uNjt2Y+QraX8NairlvY/LoME3CO7Fyl37zSUfMgvSx9riMnzbMA?=
 =?us-ascii?Q?GdVmq1AZmN2srT4tuiKhYl/vN90IBHrFO/6sKgVK8B+HiPjKqTUNew2w/q+I?=
 =?us-ascii?Q?kw4+gvEzSJkmxntuN0aerypl7KOc8rA7BnwJtP3j0Tv6U5VjpL+QJ7EBK/jP?=
 =?us-ascii?Q?HWyqrRUiS54i5sweD4V+3vMksZSEEKGvnuOyVo/4xSQ+1FdSapiNX1Rt4KLx?=
 =?us-ascii?Q?CdP4TNyjv7YAMAgszAM4Ps4gvvFFuVhKypySaIkJDmyVbX6YHq3rl3kUt6Si?=
 =?us-ascii?Q?uNiiUf8oF8tg9+TG2NEWPyd6XJUMzU615q41FlG5VO3WYZt3eNrcFUQ3GfXW?=
 =?us-ascii?Q?w9C7nO7MsBb/Ar+udJ9KuPJ/Y9GnT7TkyEazRCR+zBuZOedP0b+dMSueAQLz?=
 =?us-ascii?Q?edKWgjstFROZvhEg0mjq/67IxeC5eKXcFDATPDScl2tSt1Dri6oCPsS780HH?=
 =?us-ascii?Q?P6I7VuRb84kAM8H1QT9yUrev7tXGBuiTuSw8B/9kTjD9VItYuPFSU4ev+1pH?=
 =?us-ascii?Q?hWM0kD7N8CAiUmR1wilA5el4kVvaKZMo19tzNFj3uurKsNHjhBLQFe9Xzdr2?=
 =?us-ascii?Q?ZwC1Jvz26cSMSbFe5+A9jefZ+inDgxjd1TDDZc9ilasNXREyybCfsN22m+Bp?=
 =?us-ascii?Q?iIQ6Oq6AGvOVc5ujoDCu4qqJdPJzDZyiQcDhcB27EPF0meJfupEOtSbIw03N?=
 =?us-ascii?Q?khjsv14EcaqupIw2cJDQyWSFDwDqFy4pvlWQtzMzg7qdc9HnDmhm3jBoIIko?=
 =?us-ascii?Q?3GxcjaxsdkDf+U7EE1js3jVHnzDWlhXUV5sPn4EqAcptATNQCVTlk6RO7A8p?=
X-MS-Exchange-AntiSpam-MessageData-1: XSolwmREvtttHcenPkFGpymq4YqBuydo3PE=
X-Exchange-RoutingPolicyChecked:
	KUs61njPVWLAfAkersNAv0O2EwzQTEUQFr8UV9Mjh91dnsRPF7y3OCgCE3DFiLJiIfgld0uiIta/fz5x23J9hjgZKnd1i1aPCZ8OJl/cuANL6kaE7lQlRxVeVPDYqd/c7mTaFjbTG1fxT/74kAjRJmMj+N1tyKb+8y7IatIsRThj5+Eteu5zb3+Ul7Jhvwj8FiOIOH/og4RGYdQt85NO5cufRMtjIg6p4pVkFWFktxzILI1s2gSOmj6a6jfngXcYwD08pyDHMlmgIPMdKInLVX68RemfKZp3WPFswF+JIOfo5lD6RkHXeSTRdR93ER+hr+UU72oe+mVi2w52qpPyaA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	w4QIlqg/UVelM8/+lWDnXkMh39W2CF/L+iMcaoj210nIPbG5h9WLUOgvaKtaOWaMTRkpXEKUOfWbh0Q0SY6hRwlp4aiFmRsaq8DxjJeoJDUpyLzy3PsFkv8SRWtLhhgQWnsT+6GO0kIRq3rb/efZpo3BpD6nQgu4VEeyWDgAkT9ygIO4eDd58LOlW9wTK5EP4+sNq6sRMqTU5tGgkZqc4Hojs+4+YzrdWbifgM7jxJDSKmhjPdxNma+8zebJPfk/LQRcrYMXVCwxphMTLvPAQgkI8MNlzZITCMDddkTymtv5Hm5jXC7opNzduN/MWQoydbV05NgYGfKkE8RboEdZLfOH8OfeEyymge0BsQ2bJR9fTJDSEzi2snptpiWRGWyZHmKTAfzrwCErxUzwNQxij2Eks4JN8D5Nu3EmIl5MJlpdzQFaEW5PVyazSvN6+Q7NLT9kwW44WIFfysGfj8IDTjQlMQYcgQv6tE0Y3Ht15OcB5eDVBOJAvdrLRiMxVotHBjMlWDSZbnOU9Ej4xdfO+GLh1nTjm0F2E/18hcUW1FvfEaJJMMv1Zu47TqSJ2klVHKdSy9enSV0oOkNX2uqgiv+1ghC9y/SbotKUKeujCbnkUHy6wxttbTdcraZjm8BK
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 468f3967-d379-40a9-87b7-08df2f791b9b
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:42:11.2473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sh5z0BTTfAjpd2zOQxXA6GoQv7XUhoIDZ5QxZ9eCoBjPbQQr1NBVEMutAWWw0j2f2TTyYTwPiKg4hrEGZg+OczBXr5qodbIPnfGyK3w/PV4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR04MB10180

Move the code that resets the zones of an unused block group and returns
its space to the space_info out of btrfs_reset_unused_block_groups() into
a helper, so it can be reused.

No functional change.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 128 +++++++++++++++++++++++++----------------------
 1 file changed, 68 insertions(+), 60 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index ade2d0adfe25..1bb8716915a9 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2921,6 +2921,72 @@ void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg)
 	spin_unlock(&fs_info->relocation_bg_lock);
 }
 
+static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
+{
+	struct btrfs_fs_info *fs_info = bg->fs_info;
+	struct btrfs_space_info *space_info = bg->space_info;
+	const sector_t zone_size_sectors = fs_info->zone_size >> SECTOR_SHIFT;
+	struct btrfs_chunk_map *map;
+
+	*reclaimed = 0;
+
+	down_read(&fs_info->dev_replace.rwsem);
+	map = bg->physical_map;
+	for (int i = 0; i < map->num_stripes; i++) {
+		struct btrfs_io_stripe *stripe = &map->stripes[i];
+		unsigned int nofs_flags;
+		int ret;
+
+		nofs_flags = memalloc_nofs_save();
+		ret = blkdev_zone_mgmt(stripe->dev->bdev, REQ_OP_ZONE_RESET,
+				       stripe->physical >> SECTOR_SHIFT,
+				       zone_size_sectors);
+		memalloc_nofs_restore(nofs_flags);
+
+		if (ret) {
+			up_read(&fs_info->dev_replace.rwsem);
+			return ret;
+		}
+	}
+	up_read(&fs_info->dev_replace.rwsem);
+
+	spin_lock(&space_info->lock);
+	spin_lock(&bg->lock);
+	ASSERT(!btrfs_is_block_group_used(bg));
+	if (bg->ro) {
+		spin_unlock(&bg->lock);
+		spin_unlock(&space_info->lock);
+		return 0;
+	}
+	*reclaimed = bg->alloc_offset;
+	bg->zone_unusable = bg->length - bg->zone_capacity;
+	bg->alloc_offset = 0;
+	/*
+	 * The zone was just reset to empty, so alloc_offset went back to
+	 * the start of the zone. For metadata/system block groups the
+	 * write pointer must follow it back to the start of the zone;
+	 * otherwise it stays stale at the previous (finished) zone end,
+	 * and metadata written into the reused zone would sit behind the
+	 * write pointer, could never be written out in sequential order,
+	 * and would be stranded (pinning its folio) until unmount.
+	 */
+	if (bg->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM))
+		bg->meta_write_pointer = bg->start;
+	/*
+	 * This holds because we currently reset fully used then freed
+	 * block group.
+	 */
+	ASSERT(*reclaimed == bg->zone_capacity,
+	       "reclaimed=%llu bg->zone_capacity=%llu", *reclaimed, bg->zone_capacity);
+	bg->free_space_ctl->free_space += *reclaimed;
+	btrfs_space_info_update_bytes_zone_unusable(space_info, -*reclaimed);
+	spin_unlock(&bg->lock);
+	btrfs_return_free_space(space_info, *reclaimed);
+	spin_unlock(&space_info->lock);
+
+	return 0;
+}
+
 void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
@@ -3257,7 +3323,6 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
 int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes)
 {
 	struct btrfs_fs_info *fs_info = space_info->fs_info;
-	const sector_t zone_size_sectors = fs_info->zone_size >> SECTOR_SHIFT;
 	LIST_HEAD(retry_list);
 	int ret = 0;
 
@@ -3265,7 +3330,6 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		return 0;
 
 	while (num_bytes > 0) {
-		struct btrfs_chunk_map *map;
 		struct btrfs_block_group *bg = NULL;
 		bool found = false;
 		u64 reclaimed = 0;
@@ -3307,65 +3371,9 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		list_del_init(&bg->bg_list);
 		spin_unlock(&fs_info->unused_bgs_lock);
 
-		/*
-		 * Since the block group is fully zone_unusable and we cannot
-		 * allocate from this block group anymore, we don't need to set
-		 * this block group read-only.
-		 */
-
-		down_read(&fs_info->dev_replace.rwsem);
-		map = bg->physical_map;
-		for (int i = 0; i < map->num_stripes; i++) {
-			struct btrfs_io_stripe *stripe = &map->stripes[i];
-			unsigned int nofs_flags;
-
-			nofs_flags = memalloc_nofs_save();
-			ret = blkdev_zone_mgmt(stripe->dev->bdev, REQ_OP_ZONE_RESET,
-					       stripe->physical >> SECTOR_SHIFT,
-					       zone_size_sectors);
-			memalloc_nofs_restore(nofs_flags);
-
-			if (ret) {
-				up_read(&fs_info->dev_replace.rwsem);
-				goto requeue;
-			}
-		}
-		up_read(&fs_info->dev_replace.rwsem);
-
-		spin_lock(&space_info->lock);
-		spin_lock(&bg->lock);
-		ASSERT(!btrfs_is_block_group_used(bg));
-		if (bg->ro) {
-			spin_unlock(&bg->lock);
-			spin_unlock(&space_info->lock);
+		ret = zoned_reset_bg_in_place(bg, &reclaimed);
+		if (ret || !reclaimed)
 			goto requeue;
-		}
-
-		reclaimed = bg->alloc_offset;
-		bg->zone_unusable = bg->length - bg->zone_capacity;
-		bg->alloc_offset = 0;
-		/*
-		 * The zone was just reset to empty, so alloc_offset went back to
-		 * the start of the zone. For metadata/system block groups the
-		 * write pointer must follow it back to the start of the zone;
-		 * otherwise it stays stale at the previous (finished) zone end,
-		 * and metadata written into the reused zone would sit behind the
-		 * write pointer, could never be written out in sequential order,
-		 * and would be stranded (pinning its folio) until unmount.
-		 */
-		if (bg->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM))
-			bg->meta_write_pointer = bg->start;
-		/*
-		 * This holds because we currently reset fully used then freed
-		 * block group.
-		 */
-		ASSERT(reclaimed == bg->zone_capacity,
-		       "reclaimed=%llu bg->zone_capacity=%llu", reclaimed, bg->zone_capacity);
-		bg->free_space_ctl->free_space += reclaimed;
-		btrfs_space_info_update_bytes_zone_unusable(space_info, -reclaimed);
-		spin_unlock(&bg->lock);
-		btrfs_return_free_space(space_info, reclaimed);
-		spin_unlock(&space_info->lock);
 
 		btrfs_put_block_group(bg);
 
-- 
2.56.0

