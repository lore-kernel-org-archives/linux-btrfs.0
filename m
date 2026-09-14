Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412EC2FE057
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 08:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789376105; cv=fail; b=tiaQLkCH7t5jFkM78BYa0JZappsWubMUm4RUJcTDfPyVwVQM4RO2aYBJZhVWGy1nssTMvIKQPv8d23chx+1pqgF8qs4hIQsd7OvjODjL1uV+yRkOMh195ouQt9yntqrrHWEYS8TvCvcRaWS8ZW6j4JvxgYi+kZjLW8f+EYJ3gck=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789376105; c=relaxed/simple;
	bh=1ooK2nxW9smN/H/rOjRDKcGErJ2VrFO6dyBik3NDRTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KIg57WuTANNuUe55b2DBaXFJJVEpY7xVDq8GUqhBsDVI1vJ3xKHPbo37jx1um06QUYaqEpWANopzACcmBe3R6PvlrBeodnvhAFRRS/ooTfWr5RMuxmSmV1rNTrYBCxThzYP4Ol371JGxa/ihPNSYkSgDdmhjcUds7kH+zeBxu2Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ZyfJC2Lu; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=fzJz27fF; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ZyfJC2Lu";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="fzJz27fF"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1789376101; x=1820912101;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=1ooK2nxW9smN/H/rOjRDKcGErJ2VrFO6dyBik3NDRTc=;
  b=ZyfJC2LuxwJJnPCjHg/LVMke9Dx12rKCVefmFmqRyLCf1IIt0Rx+D/As
   +9FLGrRC4n96pF2geiBOmPHucQcWaxmdKfLvnsccsgPxyDSuMpW3Egx2j
   pyeu/w0G2IkuATgAG1QZmGWJDvscH6NUcIut+kuEQ6cCw0Jck/yIpggj8
   IfeBPObLstYd2W60zKjK7W7FN7l3BlUTOlaYbxyxrHcw/MICAsQ36hJmb
   RcD9Zlzb5u1iNGOJ/vshXkLCjvMUyRWdv0kowDnVpwO7cOe8GiG+Fk5q9
   FM79kkl7gOKLPT8RRUNv6o2rw9VyZ9113mnSGETEuGzFU3YdEaPhw+Llb
   Q==;
X-CSE-ConnectionGUID: w2pVyPcjQzm+zVW5kMhuTw==
X-CSE-MsgGUID: BxMBfqXiTtyD03c7GLqHOA==
X-IronPort-AV: E=Sophos;i="6.27,102,1786982400"; 
   d="scan'208";a="151403845"
Received: from mail-southcentralusazon11011049.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.49])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Sep 2026 16:53:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fUzQNwB1VmuWamfz9PK5ZFWfRxTrU6cxDNG7s2IMwZ53BcWaxeE6uP20ixovxippJXyDCxL+bQDfqN0vVMMjqdMm2iVHW7tTH0VQEudhT1ixngZCaBXTdjR6T32NnImUnui35s6v9jcWCBbBg8Fhn/Kjl297VvpU2a4ePgL84Cj5lEdsIezmWfrQ1Fx4rXPGQzrVVBIL8ity2q9HwCU2gL52pInXUYAykyfqreXX46brAhQ5HP+lG+Bb3T0PDSgDw8YH69AXz6ix6oHTTTFESj9ZM1ruyLtP2gK4p8TUqCCn3hgBdVkdufsNPT6Bv1BMUw/I4uIbaZ9YjWaTsbRaSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k5TrmnG6wN7XpiGPweu/3vW3BGqhrx/0G5nd99JTSXo=;
 b=LnoiczZj0wRnF/rWQzcDLhy2ghG2L1BnTWq2FkR213jLsV+6rSdGLDt8GTlN1PXppEO+4wqNeKB/2qUAMWib7DEmEPwANyq2H2rhBUcILpczNz3Jc42sO4cHA+Mkj4u6B+qSzZ7lRX9cJNZ7XUvfzPfBC5uThLO4uhkYDA4EZ18VTuPtmVOizh80LC1x3vaL6PLDuQd932GAd2G/UDO+iPgTVd0HiTaSNNgXMS8cE81Ic2uHdrGMrEGZCLN7XUSnsK9MINUdQNC+HqZG1JXiYlGqbZcl/0BrZ32mAfHTMqSUeawGreNjaCW21u4j+7XcFq9ELFMoo2MS1MbUSfYVGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k5TrmnG6wN7XpiGPweu/3vW3BGqhrx/0G5nd99JTSXo=;
 b=fzJz27fFDHvF3Q7WfQds6gjJIV124TzjUb82+goVGrfIGv7V/5OQnL/zyxFVzexwbnq3Qmb/0hP8F5842i5V7hzdeg6Yh6T58yQS0ezX8YboOnjnGnyDt+fm2/BxEVZ4G41YRzAGKZ01nN/lcA65e53z5hNve8FslTG/hdskldk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH4PR04MB9263.namprd04.prod.outlook.com (2603:10b6:610:223::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 08:53:43 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 08:53:43 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 4/4] btrfs: zoned: avoid underflow of bytes_zone_unusable
Date: Mon, 14 Sep 2026 10:52:48 +0200
Message-ID: <20260914085248.347198-5-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914085248.347198-1-johannes.thumshirn@wdc.com>
References: <20260914085248.347198-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0314.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f6::10) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH4PR04MB9263:EE_
X-MS-Office365-Filtering-Correlation-Id: 4666f4a3-5063-4e4a-ce0d-08df123dadf3
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|19092799006|10070799003|6133799003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 jIqeik0UtSoSKtgQ/1nfT5zDwbPJgMPImoTYqAeMGZnnRRVB15BZqbAZ16K7Co+KFRmmSaixL5XQppQ7UTgJf+JS/H7tLfO+tpoUuYnMk6OcHDApzTmdW6n5pyh198tY6XXa4oKillMdFnZx92grfaFnrUDIgfFLr+MAPbsxOZuMhA3drhZWCv/mIUTPKMRxnR+bjDEhKYBR71aH3Z/6oiqBovJ+d6Yw72NIpYxxr9araKjNexy5ESp/BAlSRBcRRSM2jae1F4/QYnq3HqcT3Zc/pwbgBcCtFGXAgRd67OrdyhDRMQZ4reYAGAHgDyQxmtqw+sdVw6Gzkvk/P4pas1XFw5hMvrTIM2r9DzDPvy4S21WUGnuSyH0nHVtuglqt303wCIolo4oyRCOOLN/UQzXBKzFNHz8LLCfzyT+PZlBXleyd1h68M1YO5m+SsB/CVrFyS8tk9rHDkSHsYQNnLnGoEGFUfdJwdMS6VkhI8mb/IozHhRLmKmuSyKxXAd20EYh7S60JWJt4n7rkvQESycsJItzgfKS8MDZ35fHuBl1FlMydKw2Mr27DoNEYwdJ1/myeawvOHI3jW78dFGrHWLLm/2S21Uc8l0/SnUsud8N4GOz2RkMUm4hDlg78pXRxh3bl8TIuYVjql1SkLuRPdkg8WGUj7b9+hqFSB0k4yvM=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(19092799006)(10070799003)(6133799003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?Mf4MobnQFiQ537u6yy5GqR0IoE8a4E0zHZfQ5FtWPOkU4LSj1dkcR38ZVQhi?=
 =?us-ascii?Q?8Thlz0kzdWCQ63SnPK+O0mmGz/Jh9HQhq6tC1fEl4mavd+7luJ/LcgnsoVSn?=
 =?us-ascii?Q?HVNtogoHg143EXwSWkvH5bR5beshyV185Oe8yp9WHsuMbZrKYiwMeAK/FJ6a?=
 =?us-ascii?Q?exCT3zm0jJ3yDio9krLPp6fv1ycGDf9yR917f7UJgWBF5J3p0tvlhy2gI4i0?=
 =?us-ascii?Q?B+Zr5lCHuK9cJgfJ1mFbut6pzJBtd+hdmOH/tnJt+TXZs0RqEXXTSGqp+NLM?=
 =?us-ascii?Q?OCfw9Si+MvQ1I8+DU2M1tTXgPh/ZPY7or9nSBUPsOgL8DeJapxO/wa2sbKTZ?=
 =?us-ascii?Q?rZn0gFKMUln51J5mmSlPpBPzlIK+mrlZ+gTJ+2rXd3IFtAfdfN5nsCNQva1M?=
 =?us-ascii?Q?7lagxKcutl2QTyB0DxhUueDBKJsFze8Pize/W5J+fZB//cfrpyNuDvJqRk17?=
 =?us-ascii?Q?3JirO1rUWTNBcPeix75PEkizksxiAz/jxfjrUBa/MhcijwRCMwBJHJ4aDBSz?=
 =?us-ascii?Q?jyj38HYI9LeOP5DViEweTykhspWwmomAHhQDS7sexe7sdyAOuzZTEoq9ybhw?=
 =?us-ascii?Q?vdIkgRcKWnkBAzu6+ifOHJY/5jzjx3KVuYxc/Nb3mzv1znnXoNxFKQzmuIqc?=
 =?us-ascii?Q?IUgXBWJmbSa8vdTa2MFxAedbl0tNm6e7G9yCS7rPNysdOD2yeLZfaU5xxkw2?=
 =?us-ascii?Q?Pchw6iDsLrMrNNaCO5ZgmSBY0NZ7a+W7OyTqZqGZWKglBMkqorR9ckiMkyGc?=
 =?us-ascii?Q?59Li3mLJJNI4aI6owDpHNhcJUed5084K4M4v6UkxLa5fYCdG1lEkp3Bma+UV?=
 =?us-ascii?Q?I5WINJgD70v2T3+v6RPU8GJ9FxxhlRCMC6t1WgNwve8+fiqqWVdAIsstNeEa?=
 =?us-ascii?Q?+Z/TjFPWeoxFUKx7SvfrXOL9EKVYLJ5I41IHU/Eo2FhR0x6pd62savJM9jBx?=
 =?us-ascii?Q?FjQI/rTq1byY35Ocnk0cnd9+AMRescznNeo2dvS7Y8OoohprFitJfWTYM0W+?=
 =?us-ascii?Q?tpQgbo50gqT+EIUsBnrdAEuz0HcVHEEHWgYzYbX+hlj46Qcy6lVMi3TGnRfV?=
 =?us-ascii?Q?ipdtqKTvWM2e40omib1kEW+Gat/Mt35YNeW6thgPUraVbB8njqmrjUxlNjPj?=
 =?us-ascii?Q?R6fFmCZtZ/KBIvfnznoZMC5xQqI5wFm2+1j1OOU7vA8heJkqkvFusnOAigGh?=
 =?us-ascii?Q?RxSxl+HTrRaGKRuKLC0veaJuZHb9gl0xITMBUak+ng71DdlJJdDv7dGsmRTu?=
 =?us-ascii?Q?C231lWEES7/fXs8sUQBdYKGdECp5VWAT2nZ+Yjh1F2WyWKauLAz+6fpAlLmG?=
 =?us-ascii?Q?F6f7HeZGSclkHtZFAd9DIJY9MR5zRgOQv8OU27Mw7mEZtVGJHgyfiowyfJt0?=
 =?us-ascii?Q?/c37ZU7JABcPsF3nIwFX/G0Sx53KMR2OMOOUVlX1b9Wr9OSGFizWnTT7A2BA?=
 =?us-ascii?Q?RGm6GmoNAJcg/Y5PQs0jlBKudAlZDih2O0K4U9mayZg+c3QOcbFsyfCUY9ab?=
 =?us-ascii?Q?2GfQC98ErPQHXaLdKMqbdCwLSHRlVZYnlK3fzDyVo1eZFqGNFRV3pYvlksRn?=
 =?us-ascii?Q?dH7nLNIttmgl9J65X61RUPxYVEWTdEij1OnxTFRRMbnNjso5Cf1FriKS41VZ?=
 =?us-ascii?Q?1Tp8maXsmqsGhczXH7Imy90nY0ZbKHJJkZuTcvgZ0Nkj4tp8omqpDfz8lkBJ?=
 =?us-ascii?Q?vTiHZrx3vQ8lUm42eGSGDoFVhhBSQdmAoFoyHskuxNsd3KMtvPQTd1xuC7qL?=
 =?us-ascii?Q?IaKyB5CDa/OkWlSs/1PdX1GqKNZ9bNhQL2aPV1HbYX5Ot8oEuUYd0PecAohX?=
X-MS-Exchange-AntiSpam-MessageData-1: A4Oy8n+HxqJiBZ600vsk+nVKtdssvdF50rs=
X-Exchange-RoutingPolicyChecked:
	CO2OfEWmTDkO2m39ZSOnRRuL948ktsUxZcBBvnVsE/KAc9wmP7tXBSYK2JVEmgPZ2ZWhlw9GlVur9Lqt1R8d+aMzNkRW9sqZp/zTKBAh3ojXZlqD0x1ycq15ocNwRpfX/olp4HGu/J/21X1joY2bL3NSPftpNfkYLUrMTKXmi7PrmjSRosYKXG4aW7W/jTX6KfWakLr9VOECL14K9k1STQDn1qwQTgU1/UZXkIfp8i/BOCzYB0o+vWq+oI/3B1sjsnMKWYlilvxWKSxbSg4IjUWBQlGEtXIcNq7g7vyLQVaNk55H6TE53a95KBz6Py7EWsXyb022eyNs2kBSZ/+Bqw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TwBwUBiTiiLaaFkf7pzpyQzW9HWOO8W1oM9FGVbxqr6RN1LzUlcHMP5796ifbiDaCv0bkkQOdinsf3GKh158Ve893laz7toBmHyzROzKS86G7Qb5WfvULmnIUl+aFGiFAcpVM+saNodI02DQxWN8oNrG2Zzg1/2pFl4ISMmP2sfNLoYo/fVm+jH615ENu2I5ZE2FZ9JFUh8msA9IuYrB8LPIiwzZ40Zx50sM0MuZKvdEUCniHg2L77t4AMdnMRsvPT03WppqK7XViufiisXXeana/EuxsOvbYdYuilZzR4gOdMIkxxuWdPOsHqcYL/KTTrwo7Bw0opN6NvU4wEw0yIAzhM3yktGTkYwDTgQKuGNRLAKJe9aelw4EVmz7KbKBAwSv8MYrdrS71FQ+PZk2+wm5cG8h/3AdLy7cYx+Az/PYKH6CxN56vl1NVLMgVNCzcqPG4qAUnEJYDYFANKSfgrQHmN+zbz58XPSEmdQjlUtaU0kTI034e+VGPj7sJRyl4f17xPu8yDalnBmpFonOrzmOR24vKkCeHB6nUFqOUHU8kpz2QzTd+UU72SyNqRQoK0Q1t4VoIPLnb983EWh4sDPIjVXYGY+btA2s+LPGaNFReRcjvcbk1c2IYCxR+tCJ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4666f4a3-5063-4e4a-ce0d-08df123dadf3
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 08:53:43.1270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FLQTCcx/zmKtqYpFItWetvwmNgpQRHsf/CRqTbv5zAAiZiO5DBiwTYZemJvN0udqnFRzuhmVOCiHXvAAPBrJ+iHsqe0UTfDnQ6wi5qzLdyE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR04MB9263

The two functions btrfs_free_reserved_bytes() and
btrfs_reset_unused_block_groups() both manipulate
space_info->bytes_zone_unusable without using the accessor function
btrfs_space_info_update_bytes_zone_unusable() potentially risking an
underflow (in case of btrfs_reset_unused_block_groups()).

Use btrfs_space_info_update_bytes_zone_unusable() in both function, in
the case of btrfs_free_reserved_bytes() it is mostly for documenting
purposes.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c | 2 +-
 fs/btrfs/zoned.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index ee182369254c..ecd00950015d 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -4074,7 +4074,7 @@ void btrfs_free_reserved_bytes(struct btrfs_block_group *cache, u64 num_bytes,
 	if (bg_ro)
 		space_info->bytes_readonly += num_bytes;
 	else if (btrfs_is_zoned(cache->fs_info))
-		space_info->bytes_zone_unusable += num_bytes;
+		btrfs_space_info_update_bytes_zone_unusable(space_info, num_bytes);
 
 	space_info->bytes_reserved -= num_bytes;
 	space_info->max_extent_size = 0;
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index d9b9be0a5496..cbfb24a44edc 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3234,7 +3234,7 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		ASSERT(reclaimed == bg->zone_capacity,
 		       "reclaimed=%llu bg->zone_capacity=%llu", reclaimed, bg->zone_capacity);
 		bg->free_space_ctl->free_space += reclaimed;
-		space_info->bytes_zone_unusable -= reclaimed;
+		btrfs_space_info_update_bytes_zone_unusable(space_info, -reclaimed);
 		spin_unlock(&bg->lock);
 		btrfs_return_free_space(space_info, reclaimed);
 		spin_unlock(&space_info->lock);
-- 
2.55.0

