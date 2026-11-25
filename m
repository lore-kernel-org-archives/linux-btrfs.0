Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602623;
	b=QyZJSGLN8ofx6Ugbi03COT/4HZcpB3l6y/EnZ0xi1v2pFTWedCcjYkUtc7TqPbccm0mR
	 wITK8MswX67zZ2f8JMKsD7Ik4LA9T7Qeoey37iqjuW3Tra/NDTyC1N4ED8hVITBC9uduL
	 9c1IuKlG3gkByC/8nFIYfEuPXDaRg+lnHyNCItOwREpBaN5EeDBOVjkidpBif1sdkwQZu
	 SgbJumUmcGoAsErUPTDEjOP5P3EWtaogk1/iMWiegMaKQJTYWlBPbAd8uvgrAFUOXBjBK
	 PkIKKSk3TWzh3qeRByggGYGcoopNSlOLK0ypwUEtDbLn2N1nf1JtCk7htR3cow6/FEQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602623;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 WDCIPOUTBOUND:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
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
	bh=tlHuLuG+JKaVYoM24G/mhjoVxm9MeyzfSTQf/vNGeR0=;
	b=nSSDci3zi641UcTXqqI161txijHGChpZU2BmD5GRR2AjfbyhYHCx4JQ2a1RGPQImxIMP
	 pUfC18ghqOYpHlDEjFYxFGy/P/oGRiSI5g8K5ozvB8G4wM8whq7bhYYxZh8qM0RcT6KsE
	 T/IGn9ti2/eFkVZLPZtKhQRHdbgf6VNyF0eyhjjIyAikZlKC6qQge05zVbh0U9yOkzovO
	 DZpZ+D3jt+w3hY8+I7VY8yL5MNUZBcNg2F1AheAcf/Nn1ppFdOGf2QdHPJBbMu/TuvxL7
	 ownaJmSFgpDG73DDT3klMWjWJuld6E9eqREV/6Qrww5Wnl2/JlAOBGNpJ/zasqIJFcg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=V6uz6NCU;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=m1GxHzTa;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8A4606A321
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:30:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D8A4606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=V6uz6NCU;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=m1GxHzTa
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602622; x=1827138622;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=RrFkaQ3VsHS+wvjbiHmGZYOe4JbtsEySeJKrDC0bfLg=;
  b=V6uz6NCUKKSTBxg5ABCpeoQpMS3+gHSx0H5brwsBpTds2G23pvewJXxv
   JJhd51usTiCxoKrypL6Sbt5+SPd/jmW3dtRbbHNBDvZ6m7yRGzmm0/rPt
   TZ6ccQWkzXHrZ/12aBEvWPOz/CvzAmgJC1R4KrOjcdirvWKL5A7NT2sSD
   YmpFd1Bjwml1lfLX3U/eBYZDOpd/R4k0NLXU0BwOQrutK66KZlj8ouDPc
   nd8jQ9ZvqcfqYcviF69R6qKHSdjq4b4vLOCeYUkGloIQjBtHmSoXDn6+P
   2HmHfnY2vxV6FHissIlKMzecTai73JPiU0ny0pTEVCRQ19D5jyvmkv3DU
   w==;
X-CSE-ConnectionGUID: YoEDDaBAQ/K6xa6jd1/v8g==
X-CSE-MsgGUID: AIMX2gUhT/uNj8MCwT/G5Q==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="157492366"
Received: from mail-westus3azon11010031.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.31])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:30:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TbVQurvgsueo/WlGHmZNfRfWMzOSwiQM9B+Sp+gACzU9E2eZS0+7cGSSKskxL/+Md64GTGM82Od/pAaEo+g5RDEOf59zD70IdVfWrBpMznjjhuWEaRX2/cTz2BqoPuF64eLOKZNRZcd+MvtThv95Z1pB7wLXh1QJjcVaPd7IdzMwka9tv8/jlhtYMofy2yngXOJ9iG9OWtcQXqdnuhOrB0WG1r6v2wLjJSLny513vK8D1S3eT3t74fQoJ6XQ+X7tTU23bUdFGyc0sh4jvEpvbuMbrSTkT80WSkg4y68Vj3liVKPkPPaEA2Y2gaiDx3ZJmgGy2sA3LqGc6aooNNdVXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tlHuLuG+JKaVYoM24G/mhjoVxm9MeyzfSTQf/vNGeR0=;
 b=Um2IFGD/M+cptJYN1qsW16RzAw0UkF1F1szznY9f7XhnUTCAMcECo7t2n7ojVQZe5pJ6CKLazMzJeZ2z8IweOIeVpNX2k0QkOQ6u2BJrSzFhdDkZ6SMHXMHpmp86vosFhiUZlHkMYgSJ8dt+J32FZT6YNdRBrWlSjvitq555MADbFC52GXl/yV2Iq7wdJmV9P6W5qyQyssHwB8iLh4eZJkYVsc//RlEaUx2CYC+HgfozqQ1Ivfc/hFbi9u5BjjgZiaYIdUcAw4JqMBJIF14tpD7LQVLkYL3pj+X27WGBCE37NrIo4N7Isc6udZMjGyjo6acCYgB0v6AhcVBNNEsTgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tlHuLuG+JKaVYoM24G/mhjoVxm9MeyzfSTQf/vNGeR0=;
 b=m1GxHzTaQzs9btZ/QELnP3EUxFELOLs3zRcln50huE6ajQfgoUhSnc5ioBRJCrag3RmZtF6PGDrVlLlO5mWNhj+OdIXueGRnn75Tu2c8EUKFp7C1kCVsHrC0cHNEusQidr2ieV/dual4ymxunTZC2W8pA6ai3AP6XeIT296g8VA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7870.namprd04.prod.outlook.com (2603:10b6:a03:37e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 10:30:13 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:30:13 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v8 00/27] btrfs: zoned: metadata and GC updates
Date: Wed, 25 Nov 2026 11:29:29 +0100
Message-ID: <20261125102956.266389-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0411.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7870:EE_
X-MS-Office365-Filtering-Correlation-Id: 547c0982-9f4d-4178-52a1-08df4adf1727
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|10070799003|23010399003|1800799024|19092799006|10067099003|56012099006|11063799006|261022105027099003|261022075727099003|261028144727099003|261026121527099003|261026140227099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	xQxoLtHB3PHdOcqEy6fONTNt6jxXaRzJzbgSfZ1G3I22Y4InJl5vMR2Qo2Yh1PkqrH3CPTiyNkIdYmb+/3nITh7pDvwDqRMQqnk4uHltA+BFNDq1Ow/VRzw0TwrOnGABctbm7Sm+ynki9YfA9ampY4hDBuuL5OUsBjWk5TJdpxfy3fgQFBi05BDd31rlIEMGCOyewMF/l1KEQD2oHdJrpCD5ni1dwJo64AijqeXPuHR68fl4VwvkNWesY+fkEkHlzUhjQla/rJil8ZbOdLowujxLEjfBnrRM2tMv0Sj9SGWRtp8doM02wydHMRliT1eZ7n512JW5UESVf+ZdxkkkwEkjf4F5FYVjHRf7UMn5dDMz263bE4mg+WyLKqMxx0KR5rjlnLC5rcMdhvArVypZircxmMjD+dNxkJh36mGoI+IYlTjmzT6RzHYcqy5vL/DLVXDiRjvyi3QVEy+ZDwcfX3Uf0APjsZKjfhS2TFpbOReVWwuGx8jCjnjAqhVVazO7WtSFgDr0+Dlgo/b2BhOBp2oPRN0IwbS6vqI+bL3gmy8cCBQXuhPH4IoIDAnPKdClIlrf+RsHw8+kR7Rs20O19pE1zUdMnhyJ7+sTS1FA7uZ/nIbJpDkgvpXegPOTuFS2
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(23010399003)(1800799024)(19092799006)(10067099003)(56012099006)(11063799006)(261022105027099003)(261022075727099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ke2Mm02w45CfXQH88/ZGffrNd5xOUxhig8/xIkm+rBEnTq9cRD6a1H2jnLDP?=
 =?us-ascii?Q?tI1m76W/6yHlAIK3+Zcuk9J1/S4qQfIHQlzKIULzbKuH0SyHYO8nUEqpxMGH?=
 =?us-ascii?Q?uHmp8MkbacUg1jvbvSocHJbYL8/jcm9N4qlbTeSAv3kxy4pA2FUJyoz430dR?=
 =?us-ascii?Q?UvIkHiESmipuY7mOGMOK6FWPr5TRFwRdufKgKTkiAVQc1jH8uvVmGgeeKU/m?=
 =?us-ascii?Q?/K8KD+N0grePphWdedFJCLG0ASSjQBCf5W29dOhKzOj7NrwncH3fisXCxH0n?=
 =?us-ascii?Q?/ohNnKfvL1ZpU1ZpDdabmoeYVSoLVUOAOT4JmtQxzWJ1m8HzJxXyw1Va46P/?=
 =?us-ascii?Q?/DJTjbk6ZsLJADfYFEEecv71H/bMnr/Wdk0b/NZtae3/2gejFELzwgUoQG8y?=
 =?us-ascii?Q?uPHNGxYy3v2Us3mpDtIUK6z0zgp5WpdyFceoImBMvSW/uldP0DxKkgO/ttUs?=
 =?us-ascii?Q?HUZkLe1o21wXMcLbawjpGIdyEqGLD9E/BV4eEN5jMQF7Ihu6hVUBxDa59HYv?=
 =?us-ascii?Q?Ep4iJD1a+W4h/j3c4LTRT/KN5WW6X05uN96fom7mw750KUnq4w9qcSHxZsHY?=
 =?us-ascii?Q?7g6QQ0h5dtmgxBSgNsK0RH5NiINzWrtqHHQM89Dxt5WYSB+6W5W1on9G18zz?=
 =?us-ascii?Q?VxT1BVi9oIJVErTIY/2i46ZUfP4K1MuP3P+DBiUeojLADjL8Q28NNpAaH7LR?=
 =?us-ascii?Q?NsIaCDC966EqktbyqaF8T21uFRm4auXgFN7LlbIgkrORhFYPLnPSs0cO3gXs?=
 =?us-ascii?Q?uMDfigPZdsLWHwgDBLFSF3PuZq9R7AhuUet5wz8+H1S82bJUEDqz0oG+m+7A?=
 =?us-ascii?Q?ksgLK5DCh2YFWPXJbdygBRry13BWuFC+7cVJInrUZn5KVudw/BU56+MY6ujl?=
 =?us-ascii?Q?uj0DwiTEGTqCXP/aWSJpST2LZKtqli4UduG101o0s1DDZBOCtWUOcDR1QFPF?=
 =?us-ascii?Q?n9hvLJ8zm1e2NNReAaZ4T/VjFyeW3UZVpGcb52liWkEHcvlJxAEGT5mJ6/NB?=
 =?us-ascii?Q?9f7H9FOnSIQiBZQCFR7celm9lOqNgQpjLkrUAGh/ZDBr8Vn9hYjbqeGl1fdP?=
 =?us-ascii?Q?tJB+Uijry+QwYBTB3PuP85y/Zkz2ozS7LheY5j/mwHieyOFUQVRDWHgzwqNo?=
 =?us-ascii?Q?gXXT7goF4TW1wniyWBRFSq0H0BdIw0t2qEjkpiEwjiJ+tPrmfvc/iWkXS9Hs?=
 =?us-ascii?Q?NSgcad1QIlPGWJaABPVYiftDRRfx0PiM9agGjMQU41DhNqo0fbAQ0+X4EMVM?=
 =?us-ascii?Q?VMXIGaIJwmbaxzW4CneT/zsOco3a1modgIzb/8HdzrmnKyySKG2U4+tDE9jZ?=
 =?us-ascii?Q?OkHaxrc8I/EbETEmwZJRC7LBhJNC0M5xgugVSMogmVkxy/3k1S/ueEtJ1JQn?=
 =?us-ascii?Q?BKPDuES4MEmOoGpJwRvneOxIPSC0SdMPZ8w8FuPMUiyB85OKANgoAYfqWQJl?=
 =?us-ascii?Q?2Ig2oNtDxxJuOOLhZ9KfrBuG9WNVLiPw3FEiza2H/sCZ42G0Z+s7+9WkfMBX?=
 =?us-ascii?Q?Ax+Dss9tbug5NY1R1mZX4pNkMWYYTby//bPzuRHlMtr7avV2fmpfSvurFg9s?=
 =?us-ascii?Q?2sLKFQM5TwuH9vUQ/wOMqI+S0AJwRkEr5nD4njLYvCIYLL/fvExKZ0jmGf5J?=
 =?us-ascii?Q?OmZEzEW1Gz9VNaakePcFX2ahf3Q0xabUqh/8JCrjOqIXOKCquDTojwCW9tSb?=
 =?us-ascii?Q?i68NtmEiw1JMjD8C+KIbYGTvDl4eohk5Rz2hZ5Kc29veJl+XvUB9TCm9aVAQ?=
 =?us-ascii?Q?8E8EDIyr6Vs2UCoZXweXd8zcs2fcFtKPOTx8FA+cvfdV1ejYZwzt/tQYOzho?=
X-MS-Exchange-AntiSpam-MessageData-1: 63gD1rnCgYVWHpbepk2B4LHwcAnSA8dlpP8=
X-Exchange-RoutingPolicyChecked:
	SEMNAQP/WctJ2Hp9/CYSTs5h/7WxiKk+D7HEiOiYzYd8GZKDW2m2l/NLRR8K56ncgDyta+JNoPNaYpkldRBZ3BF322KR63EjrMYgGLEq6LMM7iQoW7uNJ4OzsqXcMCinfoZtHa0w5wTz/GO4VIVFP4vvUmcqbGcT1JedZl+H+z5xkcn1v2E3vrSBl4ce8AtRWDT2qD0JlNsy86VaEMkCXrHHtPPXB1fRa+i5P66i5ULFMsB0c00rgm/0XguD7Awm6oZfAe5UXnEej69GV9WqNESbdg693bwyJNnvlBRC1jiy8IWPlTQFHBMQG305HvmuuORgRNIzrM2VDv9KG42uZA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	v7Hs/ZreqL2JWJg1mj7DAPJfVsgJdPZJcqgv5bOJ6vEku+6cPQjAOQiZFCw5edap9el1JCUvhLCzA8r+EHH9GlBEGMjTSyCMJ0PgVDZfg8+gusY1u8YpWWo+OCL1FMVhXXNRmYYVbtxWkkihijz1Xi7Y3Y4Hr7B71nZEQhc4Tsx0hsN5s+VMlXs8QDriHWdOST3CygBDj0K77XegyIruD1IchKn0qMUljEj+Gq3brH+sHLK/WqcDRTcZMzeKRgJdXjgcDmtFPjsEH0JdEZj7xzo9B6moZsXaEs2QeqFaV6yHtfC3/abhNE0gxbvXkb4esYncxTzQaK3NZ082ETm/pcRpNeSy+IV5YKnO9m1XHgycLCW5t75pjKtwvb2DtnRaD8ai2ByvlhPFzDjVglg7sG+rbufXfY+8Yuyls2FBMc/1WG1b0TFZnRUmtH4fvPpQNVKrcEHmsVdTyvvmLkEBjb+VMOxGNatl5y0/X7qxx5rjCLNIBxDmzd9aPgj5Cjnolm/M0YVzh5ftQtbRl5tmznOI/w4A0x3o5kAN2kXpXFTJhLAi0gvaderpeapm72uLrEmUuD7f4KZx6pIaHDj4BY2+PJLw8wv1HXFtpaNhO8AI4imhGYZL5uLtgJqoh1Hx
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 547c0982-9f4d-4178-52a1-08df4adf1727
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:30:13.8224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uG0HWYsm/NQ9X79CFWSpZ2FcSGxujg1cyvTUbZFO/KFc3r+I1wil8xfXG31QVQewYshfM8RD6TSYCjbvc6bVXWiFXxsUiXtYMYPGGO9udA8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7870

At the moment, zoned btrfs doesn't distinguish between DATA and
METADATA/SYSTEM block-groups, when allocating a new chunk. Therefore
METADATA and SYSTEM block-groups can end up on sequential write only
zones of a drive. This adds a lot of complexity, as we can only append
to these zones (and not perform random writes) and for METADATA we need
to write with a queue-depth of 1 using the btrfs_zoned_meta_io_lock().

Also the write stream for METADATA is not allowed to have any "holes" in
it and must be aligned to the write pointer, which was a source of hard
to fix bugs in the past.

This series introduces a split in the block-group allocation path on
zoned filesystems. For METADATA and SYSTEM block-groups try to place
them on conventional zones if the device has them and enough are free.
Then change the allocation in these block-groups from the zoned
allocator to the unclustered allocator, which is less complex than
setting up a cluster for them only. The reverse is done for DATA
block-groups, which can be trivially written on sequential write
required block-groups as we use REQ_OP_ZONE_APPEND for writing DATA with
a high queue-depth.

In addition to this, this series reworks how garbage collection works in
zoned btrfs by tackling the remaining accounting problems and relocation
still being triggered not timely enough to evacuate the space the user
write needs.

The first two patches are fixes that are independent of the rest. The
first one stops allocations from waiting forever for a zone finish after
a transaction abort or shutdown, which hangs generic/388 and is much
easier to hit once metadata lives on conventional zones. As whether a
block-group is append only is derived from the zone types of its stripes,
dev-replace must not change them, so the second one rejects a replace
onto a device with a different conventional/sequential layout.

This series used to be called "btrfs: zoned: fixes for generic/747"
but it in the end might not be enough to fix the test.

Link to v7:
https://lore.kernel.org/linux-btrfs/20261117185850.4128157-1-johannes.thumshirn@wdc.com/

Changes to v7:
- Rebase onto current btrfs/for-next
- Add Damien's Reviewed-by tag
- Keep set_bit() and barrier together in zone finish wait fix
- Fix out-of-bounds bitmap read in dev-replace zone type check
- Account metadata block-groups in cache tree to prevent leaks
- Fix LOOP_NO_EMPTY_SIZE retry for conventional metadata block-groups
- Avoid freeze_super deadlock in RECLAIM_ZONES via trylock
- Exclude regular superblock zones and fix partial zone rounding in statfs
- Skip sibling space-info block-groups in unused block-group reset
- Fix hinted block-group race and publication in data_reloc_bg
- Fix ticket wakeups, races, and stranding on reset block-group promotion
- Return used block-groups from relocation sub space-info to data space-info
- Skip missing devices and conventional stripes before zone reset
- Check per-device zone availability for multi-device profiles on chunk alloc
- Scale candidate target and threshold by zone capacity and stripe count in sweep

Changes to v6:
- Rebase onto current btrfs/for-next
- New patch: don't wait for zone finish after fs error
- New patch: reject dev-replace on zone type mismatch
- Rename "don't activate conventional zones of mixed block groups"
- Drop its reservation hunk, already upstream
- Clarify its active state invariants in the changelog
- Keep upstream zone finish in btrfs_relocate_chunk_finish()
- Explain lockless check in "never activate conventional metadata block groups"
- ASSERT zoned and data space-info in btrfs_zoned_calc_inflight()
- Add Boris' Reviewed-by tags
- Mention why the unclustered allocator is used

Changes to v5:
- Don't overwrite ffe_ctl->policy, pick the allocator per block-group
- Retry without empty_size in LOOP_NO_EMPTY_SIZE on zoned as well, so non
  append only block-groups don't hit a premature ENOSPC
- Perform space_info migration only on ro block-groups
- Only set data_reloc_bg under relocation_bg_lock if it isn't set yet and
  undo the space_info migration otherwise
- Skip a block-group in do_allocation_zoned() instead of ASSERT()ing when
  data_reloc_bg points to a different block-group, and only clear
  data_reloc_bg if it points to the current block-group
- Don't account bytes_super twice when moving a block-group between
  space_infos
- Return the free space of a reset block-group to its current space_info
  if promoting it to the relocation target fails
- Reword commit messages of "use the regular allocator for conventional
  metadata block groups" and "return finished relocation block groups to
  the data space_info"

Changes to v4:
- Fixup broken rebase

Changes to v3:
- Fix the active-zone reservation race
- defer RAID activity publication until all stripe write pointers and
  capacities have been validated.


Johannes Thumshirn (27):
  btrfs: zoned: don't wait for a zone finish after a filesystem error
  btrfs: zoned: reject dev-replace onto a target with different zone
    types
  btrfs: zoned: fix possible race for reserved_active_zones
  btrfs: zoned: don't use active zones for conventional stripes
  btrfs: zoned: skip the append only metadata writeback path for
    conventional block groups
  btrfs: zoned: never activate conventional metadata block groups
  btrfs: zoned: use the regular allocator for conventional metadata
    block groups
  btrfs: zoned: only take the metadata IO lock for append only block
    groups
  btrfs: zoned: allow restricting the dev extent search to a zone type
  btrfs: zoned: prefer conventional zones for metadata chunks
  btrfs: zoned: use plain mutex lock in check_bg_is_active
  btrfs: zoned: use plain mutex lock in
    btrfs_zoned_release_dirty_metadata
  btrfs: zoned: remove btrfs_zoned_meta_io_(un)lock
  btrfs: zoned: prefer sequential zones for data chunks
  btrfs: zoned: wait for a running block group reclaim in RECLAIM_ZONES
  btrfs: zoned: don't count in-flight data as available in statfs
  btrfs: zoned: don't recheck the reclaim threshold of full zoned
    block-groups
  btrfs: zoned: don't account superblock zones as available data space
  btrfs: zoned: factor out resetting a block group in place
  btrfs: zoned: prepare reserving the data relocation block group at
    runtime
  btrfs: zoned: promote reset data block groups to the relocation target
  btrfs: zoned: return finished relocation block groups to the data
    space_info
  btrfs: zoned: reuse block groups emptied by reclaim as relocation
    target
  btrfs: add btrfs_bg_type_to_num_stripes
  btrfs: zoned: keep a zone free for relocation when allocating data
    chunks
  btrfs: zoned: don't count the relocation zone reserve as available in
    statfs
  btrfs: zoned: provide zoned specific reclaim sweep

 fs/btrfs/block-group.c       |  68 ++-
 fs/btrfs/block-group.h       |   2 +
 fs/btrfs/dev-replace.c       |  20 +
 fs/btrfs/direct-io.c         |   4 +-
 fs/btrfs/extent-tree.c       |  48 +-
 fs/btrfs/extent_io.c         |  84 +--
 fs/btrfs/extent_io.h         |   2 +
 fs/btrfs/free-space-cache.c  |  23 +-
 fs/btrfs/fs.h                |   3 +
 fs/btrfs/inode.c             |   3 +
 fs/btrfs/messages.c          |   1 +
 fs/btrfs/space-info.c        |   3 +-
 fs/btrfs/super.c             |  33 +-
 fs/btrfs/tests/zoned-tests.c |  16 +
 fs/btrfs/volumes.c           | 107 +++-
 fs/btrfs/volumes.h           |   1 +
 fs/btrfs/zoned.c             | 961 +++++++++++++++++++++++++++++------
 fs/btrfs/zoned.h             | 118 ++++-
 18 files changed, 1226 insertions(+), 271 deletions(-)

-- 
2.56.1

