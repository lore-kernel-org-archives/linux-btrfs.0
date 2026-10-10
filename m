Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33DD497B87
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 12:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791634051; cv=fail; b=ImCvwdNKJKTc/+fCS1aJTGy+U/j+crIsqaqVOPSBqrE2W4zmcL31pxmSLcv3przFKht52KlL1+xqxHZ5PWLTylnep55ExHrw7QY8fkb9Ag/LZx5/nzWw/ox+ha42aImxZfKxy4mJAjjpglOo7lt8zbUZwhozWt+pTODz0JPbpGw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791634051; c=relaxed/simple;
	bh=180fMnnrUzc6igb4zJbbKzuqKgyHiotu2XYNF6KLHaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=C8xXwdrBqru6r7t/4Xl6A7s7US6sJSmmz5iVw9yhZV16LCdvm9jMh3q6dHuulB6OUS6rQGBg32dCLQizJ3VZYXj0BOp3yM2dsdZMsOJEriRSyIJikiFnvN49HNj9JzPGxKA/4AcdnMdI1Kc2gS7pJ0wgvgYweA+6Rav5efZMaWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Uj3YMJtM; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=UUkkl5u/; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Uj3YMJtM";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="UUkkl5u/"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791634049; x=1823170049;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=180fMnnrUzc6igb4zJbbKzuqKgyHiotu2XYNF6KLHaM=;
  b=Uj3YMJtMO7KMEMRcOZrBc7Tw//wpf2uPgyJDBidVz1OU1gvjgbvngTav
   08HqaUnh2/tGrMiIrIm6IznfPYPbsEQ06Nn4OjmQwskQD6EjWDQmlstHM
   U98Yy+HRGqnKxBd2u/XKnShzzuHvgJrzrbq0p+HvM5pMWeVEY9FSkAx0g
   +BI+sfA1V1yArl7/QYLYSIk34E7TcRsz61M2eKM5ByQbl4dwxW7Gfb/zC
   CbTlI7RQjDoI3fiEJjVqYHyNHaex1lgD/lcOOdr7TNeSZWmiulOXClUdA
   vhhfB6+3bAm5VzScLx0cuqbRDS0aroUlNwV3bEfZGpI8yfj/Ze8pievlF
   A==;
X-CSE-ConnectionGUID: T3f0LBb6S6WPiP4BV5l2CQ==
X-CSE-MsgGUID: stk6hbUJRm6/T0vGEljVTg==
X-IronPort-AV: E=Sophos;i="6.27,150,1786982400"; 
   d="scan'208";a="153560351"
Received: from mail-northcentralusazon11012053.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.53])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Oct 2026 20:07:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b39/EHS0wy+fRH02Dq0SPqnh9ULfoSUI7Tc8ibxhpjt7mkV0h4VPz7mDLjV+OA5jTEf8uBqndd0utv187ZLNOf1LYXKYWIxsneWaS/9at/ztcp+7aUjdjWHsP+1z5hhhU4kBkycr5Ks9EsMLfzxxFr7VWaJU/EI8HBcn+ZPYK/Q1Vo5cPC7msfRwxAcTW52VFCmikVayu5pXoh9rhGGsUGH0dYmg1UHhAdM22fnymJPvF9QgSxzW8ezYrc2CAozDqan2scYBN8DwHvIe1MEHPPO+aEg2yzx8oZArw2yjPElc1WT45MuBn00rw5lR/gTFEFO1BNKc51opYmB0gDqmmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E+/FUliJv5CkEqbLAJK3etmveWPP1GYnkvWVOWUY/X0=;
 b=RpahOakdEFIPloTPRanF8zPKL1dz4AA6ToobvcFtLsQ/iMjg9lCqVEgBT30KAnVdpn0s2ZqIlr1RGCRBm+k7QUKPVh0n59p4WbKf/K5hILMgsRZvND5NCeS1xRDXwPhUL6mOOxbJgBdt+QmOOFIOQoIeKwSjLDbZ79hnFpldNbfjYambimz/jx0sWv6G3D1p4lqI8xJNZbK3h9ZQdfNJdPvrs2LKuhvr77MF9MzyHTeNBZ0REnIxTISi7iZRg4g+TuUDj+VEPjpsUxHhGyJrG35FgB73h+iee1EUluXeY6dEEB+FwyoOH2gR/nBt7hUbAGo1i/JpUW2vCCSxXwsL5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+/FUliJv5CkEqbLAJK3etmveWPP1GYnkvWVOWUY/X0=;
 b=UUkkl5u/aEPYqNGd9zKpRgLI42VmOWoenm/eIcDZ4GDurJqsTrt7K7baGCj+ILece36uHi71YOHvALEohVz8AMZd43XSXPOFMjnuv2fmw1fpN3D5Qf+kxqW/4kX7wgLmDP0cmHqAvNeiNy/1WFKaO9YJV91DUq9Y0jUw3Q77OJA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7886.namprd04.prod.outlook.com (2603:10b6:a03:300::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.19; Sat, 10 Oct
 2026 12:07:21 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.015; Sat, 10 Oct 2026
 12:07:21 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 11/12] btrfs: zoned: remove btrfs_zoned_meta_io_(un)lock
Date: Sat, 10 Oct 2026 14:06:21 +0200
Message-ID: <20261010120622.3781326-12-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261010120622.3781326-1-johannes.thumshirn@wdc.com>
References: <20261010120622.3781326-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::14) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7886:EE_
X-MS-Office365-Filtering-Correlation-Id: 908dbd48-2b30-4e76-5b80-08df26c70975
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|23010399003|19092799006|56012099006|11063799006|261009223027099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	mijqTgx1AMmKIJjLAMbd5JFu/qfx54eSRffkbLdo7yEbaeR/2iSCdMQEB4gQpjTnCUKQ6UyLTtwAlz3JTINec6sTctvpH00G5EKkJIU7Oz8o72u8xscd7sGFfYZgtj20RNMWcQFPFaDfYHTjqukItWQkSzj/ghh/OPwydxuP09XURr/AQeNGezUSmYwaoIoWLrRNqq3anzvCTRdiUmie3tXcIYYu7iLu+zANw2nnGw7RkCdrotfee93/n0LB+RrQmgloDOx6amJNcPT3wyR6qQvHDges5n14IyTLq/5e2iFNBlcAydcrD0G7cDzRTmGN3s6ofM1kmqpsQVBRM6jxy+drKYCk4+sIcmXYgVmHEcEox9kYqmL64EohDamdBC91ySgL248rOsBjZ8zCwAribpIfK+WUDryNvkZbDgmYUOr4AZZLRHg66xqAqzbWktiQu4ucUyDzVVS0Pt3jChvyPsXbx6elLcD2HS1SgpYdxhnjunN/6oEHUsZVlZ+4hkHxWHvrvyI5j3wGSiyJKauN/1vaC8yHKl4A/n7KOesrPz2CfsdD7Sot/pktS8WfTmf188Yv1C7TgiWMuOE4a3N1E35iv9CnEGxiZHVRfl+Yb4JLWp/A0fXpPkAMPUy0PYerB8+kO4us8q7pfAa9C9eLJH9TYEPei+ny6Y6wlxBz8oo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(23010399003)(19092799006)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ddLJIx18c0OJLzxVn7ZaFLanpqPDMoWAJcPDJIFwkIqKvH5NEyHivvyzoe4f?=
 =?us-ascii?Q?kj4EoAaUunY824EAVfqG0YR3EX32brlwtrxiyqA/IykcHliu7PKQrRFe3dH+?=
 =?us-ascii?Q?mA2YAbByvtJG9OXyoCpkzcROwBTkgFbDBG/0nd0NsueVyfny1rmtarPFAGy3?=
 =?us-ascii?Q?JsrfqsEow7+Ax9YjCKqk5pPgO3ma+T0anu19jdO1zUFuXOTqXI4t5upoewPo?=
 =?us-ascii?Q?VbcbKEqHzbZgFLemWQScYfmKAZ9ARMwhzRfc+mzUDg1zYITFITYRN9Et7vC8?=
 =?us-ascii?Q?7SJWze46wE3aMZXgTfMUN5m9J822zpHysYYoWnBePFeJ+wogSyMkbdv7xUev?=
 =?us-ascii?Q?bUs/+wnTRYvl23U96AkIUiCFC2sMPjteqynLl6arWXYe1pJtUu+tpG2vyRUv?=
 =?us-ascii?Q?b5AYC3oHuPa5IjtRi7aWHqIb+2xrkPq4zOQrRiJl/EuwTLZ7CPEV79B4CCFY?=
 =?us-ascii?Q?a+AWIS4bzXPMLCf6KOBUJ0lCnad/DajQejWl9xltnXnBoAKD0GDoWHPu1fyU?=
 =?us-ascii?Q?BWOBNr559UklUMOJ75n4xgPLHfzjBzvIVHWt80ch8vIeJou+hfOMxvbqgfNA?=
 =?us-ascii?Q?GorjPEAIVP7kunJwVdkaYAwICLvlJUG3u//rGIt2CjArjdPa+7Znyfz814Hq?=
 =?us-ascii?Q?/MvBNDwWfE2eNbyNLCDlrNAPoeZV/74veNFSQAtqDaBna3MimxzX7D5Zk3t8?=
 =?us-ascii?Q?uG9FtY60KTjAymvjAdc14HsiQ24umSvpaDp/6HNSB1r3URajSA6L09YK+76p?=
 =?us-ascii?Q?HoLgN2FjAllPJYjAfYrnLl66s4k5c6NNVkDTLXNzUnOJuMy7nUFWy2eTy3ps?=
 =?us-ascii?Q?B5+w+UMn60emdgELkFdkQJEZoLAUvT9Bdbg7XlomDNnFYMRRZYcOn/vVBGT3?=
 =?us-ascii?Q?AHOpbgIdXd+vU0WbItQ/oXxxrsoHou2BvI4WulJWlR+JhwRWV9lmVcKEwla9?=
 =?us-ascii?Q?vRwa1DDSFHu3ZxKYfF+fEvtmTzDaYqPnteQ1TZheSSlYhnCH5Ph8bM0lEA7S?=
 =?us-ascii?Q?g+HlaXZpW1qWmnpGRBuSUWyS0enFfOSPQPGH1+79A9oGRcWkuHpm5uDYQYrH?=
 =?us-ascii?Q?SeiSyjpknjTFKD3HQ1rygQYmNp4xJ/Zj2e+STd8d8YEDvyl7xNTZTNGIsG5s?=
 =?us-ascii?Q?Aylv75lbEolttDdP7lLAgZWwdtvK7/RFAY4+igRWqILGRbQKIlJUUc3ia8HE?=
 =?us-ascii?Q?1XlLZhktyW/eZUu0maE5Z4A7VOzTXqKGBzSxckduDK/NHuqDui2zAxJZMwR7?=
 =?us-ascii?Q?NvZoPpGlpmpTlWKOmi7+AOPfjC9hgF632IC9cRsaZbXqhN5QF8A+Vz8jY1pF?=
 =?us-ascii?Q?0553QmqJ3rbYQ2xyZ63WV9v60kKw3rLwfJud8rKbABG0hqa+sjcEx0Q3qbud?=
 =?us-ascii?Q?Po4GIfdACb2N3xENFAQI6mulpAIFXPKvetnuMa4GEUaCcBp8UOg4HiSmNdax?=
 =?us-ascii?Q?iz3J4lcCuOvI3u4tkS3z0p8hFKOAZSf0sTeYBNAGqFteddurPpupyRDnWp2R?=
 =?us-ascii?Q?+Ub/gYtY/lzUV0tIu0fnQ1ZRXJsuqbf0YaLlmjSRS3q5CNQpKXde+4WaXEXV?=
 =?us-ascii?Q?tRNpqQ0MGOHWV7ByhPPlHRSBCnvGqirQxesktv5z9LNR5BG98XUbEhKaDsR7?=
 =?us-ascii?Q?N4z1FihAGTXUDx46usPb+l0RvYD2pmfky88gtQ+1/oFEcQslu+8r7G9dLJe+?=
 =?us-ascii?Q?vdZOdokzpk7Ha/Oa9z0/98c5xSahDsbVLBG2ohqqOmIAdgpNKWzzVaDhubkd?=
 =?us-ascii?Q?gWMJXCAdtWTi8VOUOQmM/jE4x5bCpZanY/50Ng7RFm8ZN6MQZql1NdPPf0VI?=
X-MS-Exchange-AntiSpam-MessageData-1: fs+6CdhatikbSJ5o393XdarCg7DFhlu5adc=
X-Exchange-RoutingPolicyChecked:
	El0o5YeVh6I76YPpSqUxS49rzpD98LMNnqY295RTH1nQ94/e3u5BG5cEUmiZJx+KgRB04vWn0/LgGcNuDH67p/UADpmegUEUYo254ZhrJmC+UI7R4Usb+YWHp/36CpM0IAFNktnfuJUQj+1xOB4/tgdSA0jKCE/eopePpzJhQur43EW/3IhWk/LwRJzRJV+kVDDKyoYDc63uHKFarUQ0Eyj5vaMPpfkJ22mcbZlpdi3Jd/cZJwBq9B06yJQkXlK5aAdb0FMjBlFJsikdvXLGQTpyKXaLLo7BV9zBq/3Txs+jpysZip16aPrvN8cXHyWF9XSD17RuiAUARcvUm4qKfg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IEIl+VCyvAVbGS4ZgkeEBrhDHQWf/kUUvH132qBgNkRtPunpEBPDzxeZSfT9NwH1MRrzm0xlNAA4peijXWLxLAmnp5gQiacKrkPTuA1FSAyOjVZBlVCQFP6wWDJlEOr0PJjDUyXrlFn4UWRThPilosH1iCBigh1r5tGsQUqEefFCTPbJSrSaCh1oepj5FIqPFsowzTtjZpOlYeZd/KqRrnaVf9GeMjBLxaBGQEtijMbxU/2r48JkspgNZWwe6v+Im8Z2eBymbNEolOiUE04o2Efm5wycmLRN/RTkODTMHyW3qtOq31VdmMljkuK1HdGOgTv0LF3OW5n+6vdhet6c9X9HlSkKcSs7h0m70Qdnu7w0nSJFtM3ProBY4eOdN9IlIymj5Eo/R2QA2Al9VkR5FGzydn93zUVSKLiibAusfUzsqIEsOgc/Tg7br0ugfOJE/dyvuaHDfNk6NW4mYiSFjqD8/CJ+vz/vKt+hSzveMhLqylBqZiQ8/ZWUSV3YResezttGXVRVHtMl37R76rCGVHZgl79Tpzcr2Is4PfGrjNd5AmOBpD22e/TdyPdzy/voYQ5kFAGz3w/Ndk5JlyBx4eON7WPrvp7pKP6vNTks5bvpZkhN3ZZzSCrlmQn6JJYv
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 908dbd48-2b30-4e76-5b80-08df26c70975
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 12:07:21.1177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: it8PC7VnLh4H+MGaORPjVrRN5sjDxEXub5k33BWQr5mIuwd54xsbpGZmP4Vnn+Kw4Js8WOQK8O+XEEd57/Yb3vV/UuhsU/XmidB92Euu39c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7886

Now that all users of btrfs_zoned_meta_io_lock() and
btrfs_zoned_meta_io_unlock() are gone, also remove the functions.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 26bb562165f9..20b1d3bf9b96 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -431,20 +431,6 @@ static inline bool btrfs_can_zone_reset(struct btrfs_device *device,
 	return true;
 }
 
-static inline void btrfs_zoned_meta_io_lock(struct btrfs_fs_info *fs_info)
-{
-	if (!btrfs_is_zoned(fs_info))
-		return;
-	mutex_lock(&fs_info->zoned_meta_io_lock);
-}
-
-static inline void btrfs_zoned_meta_io_unlock(struct btrfs_fs_info *fs_info)
-{
-	if (!btrfs_is_zoned(fs_info))
-		return;
-	mutex_unlock(&fs_info->zoned_meta_io_lock);
-}
-
 static inline void btrfs_clear_treelog_bg(struct btrfs_block_group *bg)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
-- 
2.55.0

