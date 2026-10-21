Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590141;
	b=v7svJ0w+VudxSaM2w6e0e99buwseIcrfjD3c4380XLq+tE8yeAb1IFLPS14Hx7CaAjg/
	 +QpR6X7a+SyIcEBrLIlF9oWufAPklX6HuA6NGHNtHAyuXZxmYpDCQN4gVSXdyHsGPZSRd
	 /5+AnWTd7yr+m/LiNe+MTbDgKI3p9/qdvSjm2AebJHDnU4EvinJkOHTNudheV6SKRE14K
	 VN6one2cKNRSHWXA6xqdAGJMfR+5qzx1LD0QQFLyWbnG9V4WBzgxTlMN8qsTiTPKSssqo
	 lgYoqW1RgpIRb+5uH5U1ZWMC7kLqDAi8X9LFiFwYDPc6ttkkC50Kwn6sV8BTYqcRYNw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590141;
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
	bh=TOATf0AH+tueX1eDCYf38XxdNhQYuSsiqNPy6b+UD2g=;
	b=bbHihC2SyqYslRQgOc8KJacKVPEAWyNGoGLxVNVzpdHwUfF0mnIn/lyb+4yQ4fmODpNq
	 pa6Uyj8Ir67/VYhzHz/UiVd7Xe60JqGRqBEn0Ntgu5GXfphWfGcodhrt+juPqJ93Ehz/r
	 QrGkJbh5Sbe/Eq/9JBrT8pI+Ec7oZdJh96fAEoCASUR5z69Yofi5bP318GKtfztki4XEG
	 elnRLU78GV4m+hTemgFIzn6jT21DC/hJw/C3K0lSzVutk9yHHAA4AaHUNAnlE8TfgFBOs
	 m00mHGGuzke/JElyQ60TL7Q/p+sxqRntQ98MVwU1LrOuvrCuYPJYn5QK2nPEzvg98eg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=CN63n48H;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=rwP1DoON;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5CE606A31A
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 13:42:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F5CE606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=CN63n48H;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=rwP1DoON
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792590140; x=1824126140;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Gmt6Z7tg9cy9/utROhDKSwrznMwCMvUDsdVYfpkloc8=;
  b=CN63n48Hr1iPALI3YRdkyZebcICTBztPm64f8FmWEl/Etv/YYSQkz+jh
   5kHYH23GTPivTru7TA8jnRAohtNxfdWZeXM+pdtaMDoUx2v8Lf2lWvged
   NW82w9vGpzxctVo2CvJjau/NUS+C7VS8xXJA2oMC1vBhvSHjt8ar/ja37
   5FE6kddwTyGSjr+4ijdSejx1aQD2ZHJW7ul9pbobXPN+P1/azfhW/wuuW
   b8yNCF7lU3b1RwUzeVb8aqfeqxs8FW71GYxjPX0quup4QqRWA4ZaCHypz
   xc3zJNtHZLJUXHUORFL08XVe7HDNkmJYRmAxC25rnfGREPEFrzQifahIC
   w==;
X-CSE-ConnectionGUID: 0RBGFS75Q3ivwwu+YzwJKg==
X-CSE-MsgGUID: 3TbIf+nDSEO/HyYb2yEk3A==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="154422359"
Received: from mail-eastus2azon11010068.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.68])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 21:42:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bu7SJIKFwgIzosw0G8hEYP0+psF0rQBrqbjbQDcp5Kj5bEDJQFMMoJewwHkClin4g7dSrUovyyP1Ym1bN7QYSvCJ9a4dNlhz8znl5twqirnYhK9d6e5kVC8Vt2OKUH0payjDlF5IIny9rTi9HdjGSG12BN4D+UUXjrakiaLnaD65j5l1ivtsiePjbS49STNswKQRD+ezqPqueY46Wk2NHNonE3+RmQWlsW0hQVwIt8rHye4wd/FKZ3Uq7ghrU/zSGEAT1EldTDbny045sTB466Ql1pm9uWAwqVEqlM3F7wOi+yAvmtJoykafrbnusNxBCMtzBMcR5xq0JmF5rvVX8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TOATf0AH+tueX1eDCYf38XxdNhQYuSsiqNPy6b+UD2g=;
 b=mt4+3TWUsDh5Z894ZkxyW5w9xqY6M+gl1lfqQLRobwe7ePfmPKclVGQZrkJGM8ph1CCGXaSRiMlQL4FgQLBJMtBy/lutKUK1ToY0XOz/CG8S3T00XG/Yhi71LJ3EilJ8vzI6ptBrA9d6HTJm8odsEQQ8Rq6BvMyJWFnWKxfCvPlMgxV3086UxxEaD2Plf60xRwFqzTmhceIGeUGBLhYnQY9pm2+WMip4OC+MBZptoYr8xSxX+h/mSDYb6z5zWArEqqjGV3ZAjuJP5kxhkY4Qe6r3S6Mjpy7pZiPHYsGeFqfLU4rqkf7dPYq3z8ewqFZoVklewP9DLzygbsQENT/svg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOATf0AH+tueX1eDCYf38XxdNhQYuSsiqNPy6b+UD2g=;
 b=rwP1DoONIWULjxiZU0jpU7Xk+ckLwSVVj5TLp40eUbbijvbrCK57jzEeuOB5DasRe+fQ1RVd3eiGm4DwVo2/lbloeknz0nPUEURxefFZb0BGQgHGgClb01+SyINxCCqtx3MIJ2zPjxUgtSOVaQkdftSWrjTJdUL/95herMFvWf4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH2PR04MB6507.namprd04.prod.outlook.com (2603:10b6:610:6d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 13:41:58 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 13:41:57 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 09/25] btrfs: zoned: use plain mutex lock in check_bg_is_active
Date: Wed, 21 Oct 2026 15:41:08 +0200
Message-ID: <20261021134124.2338902-10-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH2PR04MB6507:EE_
X-MS-Office365-Filtering-Correlation-Id: eed26b3f-0da3-458d-dca3-08df2f791348
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|19092799006|10070799003|23010399003|376014|1800799024|22082099003|18002099003|10067099003|261009223027099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
 I4YU3RVRYbwSL5m7hzTlc5ga7DP1+OovCBf+B/ZTVFoFLWTJHiNVelEO7T98EOlMm1Us77Wxa/SwZVWQsQSlxYK1ble0IpkeAr9mgLUACJTPGDRnaVWVbzAhYy0NIvrfXZuUmSZbsqYEUTNzF/oz/Twal6tCJJ1kGS+JKzGReDGpkSUwiDZHNTU3o8iyBKyvxlG9sJPQx7qo5ZnTDMqGSRQzZyEBMh/Lpch4GIbWi5bo5ao//7WEK4JV7DF2CrXV77dIDemOl0Zo1AVRRcYKjTeg6SC8CKVJ7z3zt2qM7fO5zapUmCMHa6WGA19zNORp6aMMSh0MI8AKc4+jGGhdCpaG5dQSumbyf3oPWBIQYH/+kq1aKKF/CH+YaLpOo1ct2aGn69ocusFaQ3UmiVMUGQfgEryS5YXHjvQlhTLgxLyAaST7ZJNxohD9o2JQKAHC4Ezabwv0WlLMo/YuhUkES+b/PDRiy4s5ZX1Ks9f7qeeFXVMRY7Pfos0JLidTnXyqUBXEHb4nHOXHZvG6aNi6BQ6Nfeic5kOIFhZJyf66mAoMtpVKtQnsGmXlIIVgepA66XJmjMOTaeA3z+79Iewjzsb/QUTlENzjMpgKonFBc57zN3sc6Jv6VH4nEdxmSmwpc1HHnhQA/GltKTPRGyiqwXkpT+3YJHipHlZGwRKFhMQ=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(10070799003)(23010399003)(376014)(1800799024)(22082099003)(18002099003)(10067099003)(261009223027099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?leMcJXCS6G0jhrOLniU5nToCUvAZftvZ4hdacD5x2NzGe2rLRUmr09iAaFz9?=
 =?us-ascii?Q?lZKyZLtX+h9E+fFcvSiaEAxY+i5TmwEKHs/AceasQ74DWQAeghMfIudhOTbB?=
 =?us-ascii?Q?MB17OVQ7jVChfaY+RdgKmtdyyIV3TiCadV4wx1IqFNwZ/jqNlcJIcyS4oKnf?=
 =?us-ascii?Q?yTOwD+T/HttEmoSoNQd9CZn48kaQHFXm9w/5kJ9GnU/AZKOlKUKX4hqO06rn?=
 =?us-ascii?Q?8SEP1lfhPAKDxxp+XPFGPz6SsL4VrL6ugiSPVtfl0cIVkgvIPFNiYgqg72JW?=
 =?us-ascii?Q?/M5UkOH+/k3O+a79bB17wsvekzPCFYFLA2lPiPJtm/RnHW3A03pALGqW8k6v?=
 =?us-ascii?Q?KaA8uCYh5uQBIHrr0eyh9x/guL5RjNh8E3wfYBiwKu2UCDQIMT560AT0R8tA?=
 =?us-ascii?Q?XLexddEY7h/s2ck8eCPr8c8xxWaAwTICv0PyGo6VDVp6WuT4SwNtLON3fbuo?=
 =?us-ascii?Q?/m6xZPEDW+fQoWdnG2jb6kL7uGAsrV5GXEg1vXcCnXZolFW13wRTjtXleF0T?=
 =?us-ascii?Q?M9oOUJv1FbG826VevSr8qsuXc7SUZOIPonZqhiBYlN+h/2jLi1PEz+4vVwVM?=
 =?us-ascii?Q?tEWliy1SGQoaG6/jLvE6clwaDw5xGeaHeGqrjuk0EUwmKiONU4xC3D6+RZhL?=
 =?us-ascii?Q?Q5powb+E531Is7SxFUkJlvRM5rIWgRkHA7nymlE/mGNnsjmQOdmToL/6jQCw?=
 =?us-ascii?Q?kSWMFRYOOarkNxu+j6Lo+7BU3GlTgvNhRKC7wWveFyiWiTOCvpHXGqEBWp3F?=
 =?us-ascii?Q?72q/rhZGzVeGUXUfpMtAkvGiJSMwPxX1/TSp8GT4/ZRXf/JeTKTRVB3XiTbc?=
 =?us-ascii?Q?m1GieMIxhoHKiPygQEwzgcmbbBEoBL4QObaJuN6WAFop51luP350iucBAfEW?=
 =?us-ascii?Q?jJIG5jdeXpnVV2YG/Hms78Y59blbSdeHmebpRnT4+x/92AxoKypCBATStej6?=
 =?us-ascii?Q?+OKKfP57N0/okSbDOJBN3VtjUYfqyxAfhmH6qG3NgdcDydyRHUZgxSUbLp+z?=
 =?us-ascii?Q?+blLoNTUVqbHgo44Qx0qsJMBXCLyEnGRpahWfBOnujoqr2x17hvU7CFMn1c4?=
 =?us-ascii?Q?twrM6zYakBaZ5xvFA+BN7E/oeKA2T6JJ4zEDSYJLmKG884sUX+PsWlj8LsjM?=
 =?us-ascii?Q?FFRd54x3wbNS/d1sFmgOZVVsbkESXAB56RVJqHMHPckB+TfiXy2/L2d8MeiA?=
 =?us-ascii?Q?dSG9KDNl2YPNyqsz2MHBreOUTL9rQyCWLl18IRmwBJJ6n1Lyub+nFSRNDdpO?=
 =?us-ascii?Q?k2HBfbj2OAlKG+id/pyM3LnlnDU8t9Jinn55dA8IspMDnloibkf1lLAL6EOz?=
 =?us-ascii?Q?7X1zqt+/BhGSHne4JPGI1iy/0ea0ig4xuKLIaM/NiZZuzWe7tJAh5rwFn3db?=
 =?us-ascii?Q?tne+CnxjXFetVUHSzj4ad2PQvzposAPcgWewLwcJB0gtg1yZRtfHfp1vIuN8?=
 =?us-ascii?Q?AgpQ1XdDcJaB7VUZe/k7YjidTcA3GR/N67YPB9k/qEAQuODOhHCrpLUEKJBQ?=
 =?us-ascii?Q?CrBzPOCPg0BuB+3o7VsyuVAg39Mv35LMTitNFz6OK0yviW87vMTB63L0XUP8?=
 =?us-ascii?Q?Dgg64w1s82rzbTGVfJD0QK3voDnYazRdA7DmgVvquK85+RN9RYs+noBYw2F/?=
 =?us-ascii?Q?RoF6Mqtsj50tt0xXMQuBF5H61iKUXxVtryCpFodw94lcJ5NN/VFXVBLqXF6J?=
 =?us-ascii?Q?/4ctlYe/5jKLlCFRrTZ3S6H10WqtQ/5Fm3+Lx+R/MGA0UTwrr2cucB35d0ef?=
 =?us-ascii?Q?T5kBI86fDt46GbFJ0MMm/8alT/43vkemgqto7xuCDSuLjjVzA2sWiK8H2/50?=
X-MS-Exchange-AntiSpam-MessageData-1: ea2uagDCNCLudtRG89TpY7WaMfwzGylqHWI=
X-Exchange-RoutingPolicyChecked:
	vjw0nWJov0Rn8FsCAQ0GE9AxM6BH8L6Z51XaLRc6WT2Meql0KHZypuoQsBL66LbqXKP36rBfj35YHZqw1UCP3pH3AhOwusfOWVP4v8GY6bZ7y0yHAXAczLg5mfLRV4gqklzK8iF9G3kpBcVKMcV0TfxODgxDxX4AYb4j+f50kUmibBqvOuSvBUg6p3S8iSsDJ8DYa/ZSR3u5VxsQbSh219Ze10Uhk6CaZE2lo+U3N+LS186XHfHvFFgYxpSI3nF+FebzvchS8RROdn3eoQCoa6GmW+JvYb3iYUYkIZvMlNvxiAslZCZc72TZ/XOq/an5Z2CldK6knKP2U31r3T0ijQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	a8TAbRqOrY+wDvtg7FM+PCy629Vz38yWCaE4zPDmqp1F+i9rfr+U379WUPWXbPqiw3L48KUkCCaogr84wj58ySaqQd/g/8v2VSOULmXPTOpFQkv5KEwkifO+yIGyaDkRQwV60bjcPoluUYBdZysiw2X4SP3EucpF59QRHasQwC+YUxYI+rBAZ6iDH7NORrOSwwY3NNYVKs8zZYecGx42gBLEcjY5zOymsi8MVbe8VlZcwyV8vU2u7HmrJ1Ut5SF0/SyGk1HLlObCghJN3Urd8KuqGCkrr6OcXn48bI6197jQHt4S/GOoM8yzJ6L7xzia8x1K4UxrWFCE+oZXblPftMqNQ7HEocGydUdWUAUsuZA24lZSI89nBeJQdvKUvzfmdlo4pJelZok+m6cjQ6l7W73Mvlq0wagou3x/iUoNf2mfZxI+6RQRhCuxeuja2l84qhTRs33D/aQxMqxUMA6rjyJUpjXtKdhjfV04rg4sdIsfICuEXo2eFsw1cSqHew6e1Y/jc9T4SmskZKpaie3dOJpvwA/bQRtZCmEmvzat3laX+WJfPozMig1aAyXESiWiDAi5LQJS2hB0zY4SYVwXCPYymug4UY+ePj60p9E74pnq1yNn7xX+6gaZuXbWMVQr
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eed26b3f-0da3-458d-dca3-08df2f791348
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:41:57.3340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OTRNcT4aYbw5+GMYAso6q/UAbU6OSFPaYvd3K4J+WXoq7lonKGp7g1+nN1/wSF6tuSyG65WV4kdWBuO6mrMd6HFmGRtLLard8pASq8cFTDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6507

check_bg_is_active() is only called for zoned filesystems, so there is
no need in using the wrapper for taking fs_info::zoned_meta_io_lock.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 4339aed14d2c..728ad2df376c 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2250,9 +2250,9 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
 		if (!btrfs_zone_activate(block_group)) {
 			int ret_fin;
 
-			btrfs_zoned_meta_io_unlock(fs_info);
+			mutex_unlock(&fs_info->zoned_meta_io_lock);
 			ret_fin = btrfs_zone_finish_one_bg(fs_info);
-			btrfs_zoned_meta_io_lock(fs_info);
+			mutex_lock(&fs_info->zoned_meta_io_lock);
 
 			if (ret_fin != 1 || !btrfs_zone_activate(block_group))
 				return false;
@@ -2275,10 +2275,10 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
 			}
 
 			/* Pivot active metadata/system block group. */
-			btrfs_zoned_meta_io_unlock(fs_info);
+			mutex_unlock(&fs_info->zoned_meta_io_lock);
 			wait_eb_writebacks(tgt);
 			do_zone_finish(tgt, true);
-			btrfs_zoned_meta_io_lock(fs_info);
+			mutex_lock(&fs_info->zoned_meta_io_lock);
 			if (*active_bg == tgt) {
 				btrfs_put_block_group(tgt);
 				*active_bg = NULL;
-- 
2.56.0

