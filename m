Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794942009;
	b=LdN2vLTaAtH2xzwGHe9FAX4VFHrqLJh8MB6mKAT0Qsq939Pj6tcxjwFVTKfc7DwH3TFw
	 O2VnAYehgbifPlWwMNMncK8yNFxFqtODh1KZrOQp41zDSKeE1Ynp4dv5hvL0HihT2wAax
	 mTdUR+IvKoEi84rTm4WNi7Lyq+Wn9N+BvzNOX3dX0Cc7yoX8Qaoprzrh3AJ5phPQ/w/Cw
	 DJwbCgUFJBdwFy0uHJl7Ej4+qGhO/l/0z59F8SZDRt1G5Z5tj8C+sbc4WbVuQnx2dWuiN
	 4R/wFrt6fHHGBPaRdO22Ppj1tyIkLUayUl2ufmCpHbibgnTmP0yUl9HxOszKre9+mvw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794942009;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:WDCIPOUTBOUND:
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
	bh=B/KKpGQUIAEjoIteCaDeE7Tbc3YDSdYtJOI8Xy4L6AI=;
	b=nbK3nWalKIdikTXwTXTEK9hj5QjC54pY9tetP7nwfePz93ihhgXBhamgbhwje1HPaU4B
	 CqxHovm6u6wLIE2hwag5RKGYB1I2F/lnUcToeXvvj8K3E26UYWaEekg9yih4A2obibhpD
	 y/R7zQopK8C9yP3+a1Q1pOkPZStf5sS8Y6zd7+CmtZdgBIvTmyMy1MwMxVs2FLXhn/KHB
	 TBjM9zIUejxC0GUQV6BgTywywE8csbb254gJCqyh8/1r/WlgOXOEBTwA9OGJytG/Mo0Qj
	 pHAa2VYU+TXPjzwTb5T/7soSyYeXSbPNgwo1946oCBTPUCPcAJifGwlP59BufuwMuuQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=DZ6y8xzk;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=T6JL+qwE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1331606A32F
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 19:00:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1331606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=DZ6y8xzk;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=T6JL+qwE
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794942016; x=1826478016;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=JQKO54Yz+ESiJfMOm/eQAdcM/mt9etmR8LepE5NZHto=;
  b=DZ6y8xzkaqtVqGfwO1VYWhWH2kTv33Ctv5w8QFLhCyC/f20LS/k8J7Y0
   3zsg0HHn2+NrAgDqO81u61ZAyciDx1czqUPVP2xx0LRAEtPdNq5VfHMH6
   KaR/xWH2LGQyC2A5OD8o4224DIzXD0YleFV5vwlFnBPa2rzpGH3yK0CEL
   id3U1SIXGyqF1Z/i70ma7eTy7+POMCCVKXqdk3PW+sTNhLhRbUYuI5QTn
   f4SbZ//FXiM5w+8tgJKXu2OJ++BbK8TDrNf8wOBGIsXwCOIZlvPhR5HZl
   tp3VZ81nOlrqrn/d5jmuRofbgljs3pJGLLf05q4OLrkQ0nK/IQYN9eu6U
   Q==;
X-CSE-ConnectionGUID: qTgoLr6cSXisIXt9x335fQ==
X-CSE-MsgGUID: j/znaYcjT/+BdBSaL3++hw==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="160149054"
Received: from mail-westus2azon11010065.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.65])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 03:00:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c8FIGgK0sqQaLjIOHSg9ZcKvnXWDtoIYYhOFjuQXBJsS3eNzPXilgdBwBd0rLt/Sa97oPg6QbqIHyJvWkLLs3qKfWw02g2TjTpk99OYRDw02VNL/S9Ui/QJVjUI7cyMRhBZzEwjA3qRQD0vp5E7FuA5viVIZNChRaS/j4JOfrTHZvetiAvUSYC7lbg+7qljToBACw90NeIs80SgPAFM+vN9Bhle9MnXuRLscmcDF8Q87Rd199UISSYTQ5DPe707hIFhOaN9lM7+8vXZTjmNcSVPLlsASJE4qs+Ug1n4FlFQ78AoXXV9Zk/2NRmtJDKV7pihxAaDmmezOztrtJKp/nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B/KKpGQUIAEjoIteCaDeE7Tbc3YDSdYtJOI8Xy4L6AI=;
 b=lEfpfxSi6hPsiAEXOatu2keLNEzdcstPR++Bas9fEd54h16rGshjtXenJtYKcmonBy1VkMK+Um53iueHNgqcgSzUIP90oUqKNtCcHzp6QRej1FRee7/WTAZM31qk1BIZLMm3hiaRXw7l/nuhi4Ti4lzQ3C/VPQHOPgfnf3JnVMD36WJKugWGYksDYt/jQQIg9lhK34K8/LfiyCi+ZB+7YxgUNcyngKyUKd9rTTgHONr4ZrdarIdL/QabMmVnu5ns3FwL8b5jkjPF1KdR5tEuD8G35JoIK18Od3z1whLfL+SNSIKSEO1IlWt/kfPVZ4T/6MkIj2YnUirWwxepye34Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B/KKpGQUIAEjoIteCaDeE7Tbc3YDSdYtJOI8Xy4L6AI=;
 b=T6JL+qwEmRrmH8q4TFCjYWirAxnqU5youaUt/ezRAP5UhOsP4ZnpM44dgt/t6AYQ+gC12hN/hYwmFhp/FSXMYdjCJVdfS5fkoX5V5UTBVnbV1Pvc5s+N7eKTWN2qAoOWrjAIV8q5obpOrVG7mw4e1GggHkiX+SvJStjZcmQj9y8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA2PR04MB7483.namprd04.prod.outlook.com (2603:10b6:806:146::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 19:00:06 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 19:00:06 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v7 25/27] btrfs: zoned: keep a zone free for relocation when allocating data chunks
Date: Tue, 17 Nov 2026 19:58:48 +0100
Message-ID: <20261117185850.4128157-26-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
References: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0167.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::13) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA2PR04MB7483:EE_
X-MS-Office365-Filtering-Correlation-Id: 74b8fbae-72bf-43bc-1b19-08df44dcfe2d
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|376014|19092799006|23010399003|366016|18002099003|22082099003|261009223027099003|11063799006|56012099006|261102123227099003|261028144727099003|261026121527099003|261026140227099003|261021121427099003|261022105027099003|261021123027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	1iVV3E2XfhPLgDC3wTBMjANjIMWdaQqJexmNeQAtBcOdFdIcmUHNZTcFWocc26rlNAU7oM1Ya4DXUJH+RtjtV5839uowJhwhb9oAZ0KfwZ1ZvdGW36z6pIH8wPbwo5ekHfeEL5o3P4+TCwjfMj/8siTxGJbcSeGBQe55cdyFiZe3Ykgim/qA5sjCJygcltyPQhVV0FSvgRB9oyFffaBNQ9r5Vk/DAvDI8jc/UJUvKQK+nRCVaAnEdWm9qvztKUnLOw9NlrW+HjCgbd/VDDGkU/qxsrkVa1zJD1IGlOlhbsBLcUc/ONkgfH6bmCiD2Kb7UET7zc6yICxt5pDibK4HLmq2mFjFuiOlL5RBqZQcl4nnOJd6xFXkyVHQ4gzrq+XedbDeT+CQZn1S/+NV0hqHZqnkr5DnY4ogLf4JIWOII933bLlGfi1JOKHKZeV+waOqsB+cs1juQsaGc5mYoawrP1cADf1o8VLgqSIl98mIszTVrV/DfyGH9ooNsY0r5Vksqry/eFAEsPMrC7xDsIuxBGLcMrk6Lt3XrHmAqH0wxEAJPsLdZhakL0NBlrqSUSJTcdtYvDzoXOmIckUegRLinvkYn/CkuIPw8Nt7VQaLWDzqN8pXJ+M2MlBw3DgTnugOMSrAHfNUetjjKsgshQFgk/CticW4nbEMhy2vFOreE6k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(19092799006)(23010399003)(366016)(18002099003)(22082099003)(261009223027099003)(11063799006)(56012099006)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021121427099003)(261022105027099003)(261021123027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4qtQ4Ho0kBwvfQ3AB4n7FIWkdcnGZeME/0apBsNDoBKxGbrVcPClFpUdk5qN?=
 =?us-ascii?Q?XMPFWxw/UNutnOSgD9hntiGKopiScia283QKwLhnHfSXnDHbB9Xiq1m/WZmk?=
 =?us-ascii?Q?1cYrqOSvLPLFH7Iay4BBBC+g4vZaqopJ6XLW4If9tbMLBUraGt33pfSZEQWT?=
 =?us-ascii?Q?lDhICL7jLY2ZW7HwVangx0cjJTwoX0cElY7f8y3oKO+rpV0BEoRhU+hI5jUL?=
 =?us-ascii?Q?IFpxrcX3gyh74prM9P5h4Ti+xqJHQv81TsRJJKtbas6OLYpelrQv+HhnB9zY?=
 =?us-ascii?Q?DuWmG05DZLlsKfmsjN1bosWKCI7g0asD1+1YczKO8DCmZL+vT6RYTu4zwWNs?=
 =?us-ascii?Q?njhq0GEFZi6Hlxw4dKRpsoBIj197/R0GODqLqDO24nvtJ75ypTmSvWIFM2v+?=
 =?us-ascii?Q?eOhynBw97ywkMEQTcHiaDZpyPfYpefoCgn5SBWtwx0Ew+/XO/pcErjV5+h+6?=
 =?us-ascii?Q?psvRwASk0ZccxgMPNaxAo9SOVE9iK6SUsFCan/4C6fLSvfZL3UHpPTEBxLcx?=
 =?us-ascii?Q?fD6UPU9BECJucynoph3vcqCS+Rd1uT6oR9B4s6M/rb+cGUyfg6ejaWgTVETj?=
 =?us-ascii?Q?tn47c9X+1jkNu64P42o4CjGETUTvpZq3EIXXOrIO4peSsfHYlBwKDb1G8niM?=
 =?us-ascii?Q?QtYeN2eouYhuv4TTEPyQfHbtopZsWV+8GVQMJnHyG/5n8B2KvDRXZ0qumwGf?=
 =?us-ascii?Q?FmNWSvJTijtn14qDfTvsI2htL+tvYvG7RmLh+9DEmcb/9ezQ4b+SZFzTHnh9?=
 =?us-ascii?Q?NhHGMqe7CIGFQSt45a+Ai6MYVRMAnv4OX62/JojqZvU2LE0lrz5hcCUlM0dl?=
 =?us-ascii?Q?lNSsfvoIiDb4fAswMts3GNEMq6Z5CrU7j+xwNkTUdUewaZhZK4lrdM/r5ZZV?=
 =?us-ascii?Q?+DOR8PyZdxQXq6efmJKI80rz/KyOBv+v5DHmG3cf7q+4iCU6Xac0XR8EyCgP?=
 =?us-ascii?Q?Y8zeoLdNw79YPsmexatW7DbP6rMNL3yhHFatPTjarFh90ExsYv4NdIC9qfdB?=
 =?us-ascii?Q?JHVwioIHrscycs4DR+T1UdsAU1AOOa7lBQMIaVZJC/Gi79pih5KUu4V3sTe1?=
 =?us-ascii?Q?7TCqLxL7C/5JEMEz1GlJOGtuuCq2AryRiTtnVZ/qx8HPZmz5tvQJJq0QAjQp?=
 =?us-ascii?Q?7MyjiH73K+l+3Yb7qm10Qy1GIQ3BRitxjn7mBCR0KkNnfxe6oJpqFVuPxqzp?=
 =?us-ascii?Q?27YnFIgkTYvrFxKtlM3E9Xb6Y4qgOqlJ1p9Wy3rxp1ZnpSbvQHMDvgdmXR9L?=
 =?us-ascii?Q?CKuoVrtSXfLfy8pgcu0GTWTozOoI5pMPMXCQsGkT2CI3dRQrzsFrI6YE7NI6?=
 =?us-ascii?Q?tcdVjnPae2GPhwje3Ckg5nZd6AdTI3eKiL1Q3QAqJMQlmT4hnsQS7HxSflkZ?=
 =?us-ascii?Q?F9x07BjKbn0Fll9kHyOqXspFkhsJSBiisL+z1hoYLbYv5cMyZS8oxz4UUKcz?=
 =?us-ascii?Q?8St6gkmt6/QRS7CYhqQnfjEcYpkoAtnyotlNunZbDp4PK1+Q1Wn/uTerk+FW?=
 =?us-ascii?Q?rqj/AUhrK/ilYjqnzq1E/E1kn/y+JB9NVh5TLoa6gSPSu6oYYelKEBJh4KlB?=
 =?us-ascii?Q?7d7T7lr+xrsZo2PhRBD7+axrq4/FgSxsGo108uWC1wcvv22so4KBuUa9/kdJ?=
 =?us-ascii?Q?mQSEYIPkgbD9dNKUAIJ1op9Qyp+C8hwSgsPW9QzWNYAKBkItce2k0OOlb9xv?=
 =?us-ascii?Q?sSS2v0r8+JLVO3wrEYrkwa9FvEibUohpvVwhP1jWD54RMrkRAN1AxrqHluXP?=
 =?us-ascii?Q?MOueFpTf49H4Sz4RBsHuZa5J4mHqyqNOM9N4YRIVOThByF6lv1fas1zMHSH/?=
X-MS-Exchange-AntiSpam-MessageData-1: KC+jEkYcNscUlBoBclg28Pjq6kPy75EjEsA=
X-Exchange-RoutingPolicyChecked:
	ZHKhvWFtVw9PE0o0BE0w/m8DhzpkvUubrxCqBOZZH0Zfu5/wzA6uCqTPSi9zfjTYILj69x5L6VI7CjZ10Pzsa4ruumZiJdmZm2yR7dlpBw55IINFbTTs8cQ1ZfkfQ8BLmuHDJaVIN5pygOexdFMcfpiE4wPGCjBHpnhKcONuGA9dcMxMlb5QRCvuNLE9P/KF7uhef6chLKVKj+kGTSHeB/tkGsPCtscTk2pOJyUBgKWQFCEFDncPeGNy4x2/GpK9ePula+0V5IZhuhGPlnDcyzPoH01ReOHsP3Nvsgur43YUe3xCp6XR6gB25BwPHKAg3EVTzEXv/7wiigaVNsiV/Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	x5QD0cq8/EzPsZ2I8KLYJMqo4NvcdSKuYnO9VvEYOoRoW11PNfWfF4A5EPj3jlEo6E0KooEs1wIXrZtv0KCELQ7L59e7DWqmQApB36CiqOaQGoJ8HqsubDwkzPasXZXgJnUH68ydACIHNT+tTZ6RBcEk4JzKUHSSvxKH4QdPdrZY1sEB/xUwXFTqyLeG9ShG5spGWSIH1Ryb2wSlpbAusr44CRL+9X4+SbAYbf6CMwAqMBhIttOvzABR0D0syAEp1rCT2ljmukTTk+anVS/36FPz1PXGOtpBglcEfmg0VUmOmht8zXxiF9F1+c9fmhxyzJeLrnuCD6+3FS4lQx+2kz+d1b+ahTwS3oMHLSeIWJ3Bf+9VA0T4UKccc4Nx6n1jbIqwfe8ldGFSNpwGJFj8oTlEU0uIrYiUzeQUCh1DcQg/KmIw4vdoAmdMvxpS5NZei2IO1AwtPhf9P11HZ6/IwlXZlfE4zjRHfPDeZN14JwrDCyQkCgFKAxtwhRf+8wljBsVtiVxz0mUGZ/3Wk2HE80AslJIgRsAqFPNT72DxJ1cwmWjr154rMQNQkpnQZdDm9DUQWWEwtEymRHi/xwqhx8dpPUiRFl0+IK7zKzFsgHZEjJT0qkxguB0RU53jrXBG
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74b8fbae-72bf-43bc-1b19-08df44dcfe2d
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 19:00:05.9774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ueZkpcyvG29pOV0haZFDij0zWQ6EhBjrq/cR1ku4BipdKaEzL4DOnJvpPy3fa+o6Wu4JwpBcOh5iVFf2IkH6bLnFA1s8sRfeFKB227fgvag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7483

When allocating new data chunks, make sure there is one zone free as a
relocation target.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  7 ++++++-
 fs/btrfs/zoned.c       | 32 ++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h       |  7 +++++++
 3 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 6801687ce029..40b8f5499007 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -4132,7 +4132,12 @@ int btrfs_chunk_alloc(struct btrfs_trans_handle *trans,
 			force_metadata_allocation(fs_info);
 	}
 
-	ret_bg = do_chunk_alloc(trans, space_info, flags);
+	if (!btrfs_is_zoned(fs_info) ||
+	    btrfs_zoned_data_chunk_allowed(space_info, flags))
+		ret_bg = do_chunk_alloc(trans, space_info, flags);
+	else
+		ret_bg = ERR_PTR(-ENOSPC);
+
 	trans->allocating_chunk = false;
 
 	if (IS_ERR(ret_bg)) {
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 67b440670125..5ca1a37fe9ee 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3772,3 +3772,35 @@ void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq)
 	}
 	spin_unlock(&fs_info->zone_active_bgs_lock);
 }
+
+bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info, u64 flags)
+{
+	struct btrfs_fs_info *fs_info = space_info->fs_info;
+	const u64 chunk_bytes = fs_info->zone_size *
+				btrfs_bg_type_to_num_stripes(fs_info, flags);
+	struct btrfs_device *device;
+	u64 avail = 0;
+
+	ASSERT(btrfs_is_zoned(fs_info));
+
+	if (space_info != fs_info->data_sinfo)
+		return true;
+
+	lockdep_assert_held(&fs_info->chunk_mutex);
+
+	list_for_each_entry(device, &fs_info->fs_devices->alloc_list, dev_alloc_list) {
+		u64 total;
+		u64 used;
+
+		if (!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state) ||
+		    test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state))
+			continue;
+
+		total = btrfs_device_get_total_bytes(device);
+		used = btrfs_device_get_bytes_used(device);
+		if (total > used)
+			avail += btrfs_zoned_dev_avail_bytes(device, total - used);
+	}
+
+	return avail >= 2 * chunk_bytes;
+}
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index d2011f764f87..ddbc93d0b8ad 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -121,6 +121,7 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
 void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info);
 int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes);
 void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq);
+bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info, u64 flags);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 struct zone_info;
@@ -342,6 +343,12 @@ static inline int btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct s
 	return 0;
 }
 
+static inline bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info,
+						  u64 flags)
+{
+	return true;
+}
+
 #endif
 
 static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)
-- 
2.56.1

