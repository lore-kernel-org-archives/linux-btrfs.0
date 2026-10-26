Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031008;
	b=TMqqRA4dmnzlTYz/c1Mw7Si///IeJ8V8Z08ynrBqoF7Xc1CQJCja5PJJ1kwR8tATd2wr
	 N4xqqPLAm4J9cHYYab2AbhRdNQ83Wqz7vZSuLT5hl1+3ZcVhsGKtLXPcYn5J7PUSYVzi+
	 2Hufn1bQ9theBA2PFgSdakFL520cSMdlPfwBYvWUvl68KYycckT1MsvYQ9uceIb7jo+Nl
	 bqGvwisOyVYoGIhDbSjxsQpzaPS2OhLhdByCbhftdVUBd7TQy9fokXIlHl5EWKnawvfeC
	 6dwUiccexIei+I71kuTNVLFYY0iI24MkhpVazTBp41lA53EFHKQOmj7X0ajTEhLya0g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031008;
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
	bh=UaPBnd/QNCK8c7VR55bEH2lkFdoNR/C/R/1gsRzlF8A=;
	b=A2IMYbwAFcYznKIQvpttfSKrTTbgW84LHE+cHD4j9j5ow3Xj/cabFEPM/3BmBspSwhNC
	 FhnHmHNljGgqw+0/NfqYnQuCCLiJxXy4xUbzdLp/dpxpr6vC4z7maHKPjTdAIWZZbQQNj
	 QhK8tWIuXUIrB5wwe6lmuHdcT9gg6MlPNRw2VKWMoQHtg9fSZLMonzL7uercJktsnXJs4
	 aB4ljRqn6thvhw5Mnw3bfO8LYYvOs0A0ZYAohquCcp+rX/F4+J8u7haJTdVLc7l1sTZNh
	 rM33r+2dq923xbO3XzLXK+SQx5BUClnFn43jmFvZXcdNkKKzWDL8wPCOUop0HJoP02w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=BHP8NVLP;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=heESY6Ko;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09C8606A33B
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:10:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F09C8606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=BHP8NVLP;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=heESY6Ko
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793031008; x=1824567008;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=3F4P4/q6IS5daclCQNXs6rcgHM2VTM9cAuRMwXON0Y0=;
  b=BHP8NVLPyWRVNEbvJBMRuyrTE1Ebkc4l17L+ywuHgvbv3Auw81f5cZX2
   8d9nUVHAW2PsSDsql69Qi61bU9R/KyDpqZIa1IP/c9meB2mGQNs3LiXPi
   7KYqEoUIHjxRDSWaKy+H5JxOV01gv8fkIcWL6sCXCuen9hGPSKdYeMFfg
   9T0/fUiLwU2E7bk9VBtdQBCreQeK4P5U4ET38KpUSEn1TfaMU9dww98hJ
   O8JNy1mFAOk9JoJx9D8Z6OIoWWwYRpMZS+Odnqg0SSlKf5ROIfgwkeEVq
   AYEwQrgvnSuQTzFBZhyzjVZxEPypl6RJICYwS4AMq3vfbISDCijqFGuzG
   g==;
X-CSE-ConnectionGUID: XL1bPfrMTuCsFimlu2t8SA==
X-CSE-MsgGUID: g3xrXwlkTESCM62kJ185+w==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="159033903"
Received: from mail-eastusazon11012045.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.45])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:10:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eVr4yxxz/R6svt2LVzJIzyV2diKpGgiZnSVTNqniDbcKAaWFyhy3LJGc0C0CozSaifJQmm9ZziIzCGwdSmlBmQGqpYIMCq7HJDWv0KsfpKc19pUuaKoR/YunzF+XVjG6FprWbYoyHDdoLxSbul3jRnILQlFmZFiOXNepHhD+AzisZNZsOp6eriMRcBo6Iz8W7bfrHTnTjcmfs4essztEJoK4YxPQV/fdzwxjez/rLueUJ8rFR/4nZl3YiLU8r8S3Vg0ciEwpykTHU9TbGv3u4+hBJj1Gi7CEgcc4mWL25mpWZdmeFJuaGF5ZZgYXG4ZC4RmCKdEPq8jXqBRt1725zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UaPBnd/QNCK8c7VR55bEH2lkFdoNR/C/R/1gsRzlF8A=;
 b=O+k1wsBwc1kAO4Aol/krmKNc5sU/Jx+ssZAXyLKjODhFpHDKF9VdxfAqTUPXdEbj7/xGQlX5IOLLQ1X9I947DXMdXVcCzXTmKwDFsOv30Vsa5LpjiR6NwSEoxCnR5OXO2x+LP1h+awriLvQF1vjSv+La8Ho4P22GqyMtCcqzGew3xBCW3K71wUOj94d1EKfcOkAML9VLfZwGYVTIwLRK+vS2G14FccC6CvJIF8UnCxFMlq5IYkditpUxVTJ2EQ6DjDii8CZTI8AU6DPn/6BZVzJWx6EueyYzP+Mv0KACO+OITWy0mDXvBWWZuW4c15Nb8AyL0KI55AxhaOu4uJ5Lmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UaPBnd/QNCK8c7VR55bEH2lkFdoNR/C/R/1gsRzlF8A=;
 b=heESY6KoUJA8TSG+Zk3s9wHeuNqzz03CYpK8W58h+pW8Y7ZDdJ/Rs5i4rWMbQlAeRML2kCKwiWjpWQz8Z47GedMMT/fkqa1bCFR8ngsUuq1XpgBr/QAapozXpZWdVO+YdxxkgKz48JzVNgETOZaA1l79RccHe3YbPc9fVYT2cCM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV3PR04MB9220.namprd04.prod.outlook.com (2603:10b6:408:26e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:09:45 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:09:45 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 12/25] btrfs: zoned: prefer sequential zones for data chunks
Date: Mon, 26 Oct 2026 17:09:00 +0100
Message-ID: <20261026160913.207909-13-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026160913.207909-1-johannes.thumshirn@wdc.com>
References: <20261026160913.207909-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0145.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b8::18) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV3PR04MB9220:EE_
X-MS-Office365-Filtering-Correlation-Id: 258f29b1-1293-442e-b152-08df337b8d4d
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|366016|23010399003|376014|1800799024|261026140227099003|11063799006|5023799004|56012099006|261026121527099003|261021123027099003|261021121427099003|261022105027099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	gyrZc3GNi1oEQBu9POBvWr5syIV6w4aflOkKiWGPIz64fMMpR3/pRmNtKjSJpBuXK6qj7ggrij7bCQgmgnaQgnTl9bL9ynBnu+PtH1+wD+KKfeL4mQ/XqU+NCFLjV8s4gxbQu2/jvQn2B+n3ESp9aPYeey9MfHE6dEbzrwVkEwPGLB0Q6XEfx8lTxJceAmj9jApyQleWtkto+FTtU2qS2tR3+CfEtARef5Gh42PlfQSpH6fClCPgaQJpoPvZq1Q0n2+Qb8u2VPGmiiyLn6wGW5vJ53H4wJaq2wei+AXq9JeZREYum/4ITxKsycyNvjQfqGDcHlVcxJMbLnS4v95sVLbnaXZwT9o9ztx/ydxQ2J1MJdCym9SKxgtYr5CqChNyBzN65KhyhkIo+CGbiBOPtJ4oqgNINR5AfGGNm26Z86lN9ujMRsvV6mi4hue7VEYzzNg6qB8EmNXvOtRkr8PHjWlpSxtwXTUCu+/6cMxvUKrno/4+qiGvMpcWTeyAI/F3q/LjE+6a/pRKGD79kP9AwxDihmUIz2IbDMBBUrZ04rWoaofTt/2odbTnN7bvAG2cZ6jaBjMjOgcQ0TpcA473o/fmwoQ0wFGepbzW5aDGePjES88QjOMWzHdHIjpYJcfocmC8Kic0FQPZqIWOtryWF1n2PQBrr9oghxnxiwI/Xbo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(366016)(23010399003)(376014)(1800799024)(261026140227099003)(11063799006)(5023799004)(56012099006)(261026121527099003)(261021123027099003)(261021121427099003)(261022105027099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KWt0TskqFtCn3h1elog4c+2gHjGbZu3NNG6bRvUoWHgfvjI+xQUpkmm3y89q?=
 =?us-ascii?Q?eYCYKFwjxvn2ZFKwB/X//ISnIVSFhM/R5lnEZAXlDt5qMu5JWq7qc7IUEnKA?=
 =?us-ascii?Q?o/ShdEXifP3gB2g/vCQDya3yRbqkiv+YyuowtaFgwgjBv9K9tJmcSOeimqHE?=
 =?us-ascii?Q?932g1wfqbgq+YssfSWgOn35epoZ2kXP8d6V0P0rHOvngxMWWs6YnH81DuOzW?=
 =?us-ascii?Q?+fs1liAij+S41SwJHLDMMbRD1UT3B1sVCKbJn+4hRDYlhvw19YwuiJOxrB5O?=
 =?us-ascii?Q?5HT8GCk4qO9/1K6aVAThK5uuNWVCID3qe5TeO2vThYIGXL2eFpDM9UQ+1FEb?=
 =?us-ascii?Q?hkU09rPor1VnpCnjjjZa981crxiXSyzPg4jt33Fu8rliqZs9Zdw+JHewtna/?=
 =?us-ascii?Q?18FP4Gd8LEs9aoht4meugAE/Yo031vfZu4NqbB0bU0z8xgvae4Os0X0Bujxr?=
 =?us-ascii?Q?QH6dN1HT77sPb1yABqmFyiUkeX8aSWtsvWpGcgCQBZ6q3SYLImLZicL/F7NN?=
 =?us-ascii?Q?K66voYC7A5/0y9tF/Wft0uVPuoPwijre8xj3eIWy6xwE3hWrJoIU3bzKS0oB?=
 =?us-ascii?Q?LFTqr9LvMrrkbBi9tvfCCDTbQ49MFGBA5AIk3m7ni6QlM2GXSINoQ/jwyihE?=
 =?us-ascii?Q?8b/NJF4ckpj6muVh+n0GARPr/SoqktWArhuRNRvztvI2sr9P1c57D0NwuP+2?=
 =?us-ascii?Q?hzzjXCqBSnUMD3zw/1DLmISSiFA6y4khIX8siGK+/q8VRxpCgsQOjmyV2zJC?=
 =?us-ascii?Q?lBdMjBqce69gf6jC2juBECZIb5xn+aNPhWa8euzXJpaL1OauC+db+zKGIOOR?=
 =?us-ascii?Q?jI+2LF6QdPG/taEs7o2sWqDP5SntzubrdlWbf8kYseAJzLkSDkSqPFwruDT1?=
 =?us-ascii?Q?Gg4vFE1WYL7NzmE1IlHWdsVmjH/LRM7QvgWu74KiBkZO/HwDdP7oztny02vX?=
 =?us-ascii?Q?4Y1HlyYvlZ1fd3Fxq7YDZSXCdbtAQ5O4zzpByG1k1h4OlLSLvdprFWec9TpE?=
 =?us-ascii?Q?vsp3InycE0VCkK36ndSoiHyGGQlPMLDs5frc1cU+DoOwi0OTCNk8ufdMgE9B?=
 =?us-ascii?Q?WMTIHnHa4QfnfC0tEBepPtT/d0AdCa9YieHpm+qMrnYvwd6u4hLgFjQyvH44?=
 =?us-ascii?Q?79+SSsDYUtzYUL1Sm5OSUKlHf4kmmKopWKA6EQKf9ABP0aYJdk7gdsD/gZv1?=
 =?us-ascii?Q?61ZZP0hX614pFoLoBs6rWrjSGITY8OoeDmnk3f6qT1N4qybCzpNwxzT7tMlJ?=
 =?us-ascii?Q?JmGlqxT+aAIjcAIc49kuQN/R4ZXl7Ae9IrjtD9IrBJFnHGvJJDM+73x6RjjS?=
 =?us-ascii?Q?QpA76uBSVB6RmAPbuiCzxfkp2vc4GT1WqLePNMN2a/k+J+S8kJezzU2oY2Zl?=
 =?us-ascii?Q?0dVwoXYxrYBz1CZu2WcKAQot0GPYxcpNfwY5rWaNSrDAQpn7hyEFLR+yoAT2?=
 =?us-ascii?Q?ieYLfLz0flvHtwdNHEozulqGE3pxQpk748aKKV8L1QUkRStF8lLOd3vxmK7I?=
 =?us-ascii?Q?UtjVChEmGu1AfMYxex2GllfELt+Q+JopJJYlJwxx8RpuiGJR26AI+RxPH2dl?=
 =?us-ascii?Q?jzQHYOjFBsabLgcLf8nZaHsABFBE64V6qUHwo70c0JtnwX/riGfbKwUzzpkB?=
 =?us-ascii?Q?lbEGXC5Km28367E3nZuZibTjFkRvrgcyF0rWzrhq+zs2tYfmi8wTxWBW6a4f?=
 =?us-ascii?Q?kTruggzvU7iqKAaMx8jbKALctg3G5Raah+f74bPCZ/jzWzePzz9ShGr8N1mB?=
 =?us-ascii?Q?x2IfTrNTABBkuqKlEKnPSzBckEplPoFmuxwk7SRLSkP2FsA+Mr2mAYdD1hbx?=
X-MS-Exchange-AntiSpam-MessageData-1: 7XJZdnTwvfMKSQ==
X-Exchange-RoutingPolicyChecked:
	PnHB0LsD8NAplNNQQSchjmvFsCFDvtzIcWttu9ApwFFe7GAFbSgqGNzV4V5Xip0plmdXXvM1k0KfeGsXO6pFiE5ZdhIsVUxQ3KrtnEzcktcZ5pz7bcKcs3bPTEtlP7lXg6qOasx0hjDu9AS6l6NEqMjel4t2V4zzS0WjA2se2p7MohtK6wHCwNDUswzqSw+4aMzSNj1Pu12W+lAYUI5PudK8E5nCC8ZLw/qpEh38WXUaqzk94NIg8Ms1bsuZPwNW5jYBKZN5ard79PnBwp60uB6qyOehEiPwgxkzxtaSwtarUSLfiQbefGW5b4lPdfID2Gcn0p+CB9Wey7QgqMcrig==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DhEM6NUySj8jzpwGFipuTTMZUHnxGLtb6CZx37wUss8DcNNdAmLOJHmQTOHferk772E0V4rMn7H4IZ/iWIQ6UidxpQHXds2yDme0hBJHp4+2zGJkddnYt2YDKnxZkyCmN4wi/tXc9acya7T9j/JFXmgzgb+fJ7yKJzPquuSZBhfo4T/+x6WT2tF9xdR6ZKdOkqjTfN3LGqo7aRd5uztntram6E4Tu1YhfqBmdpmJGnCUurE1n7JVJTASJoWF207eyqqOcceGrBd9b96S7XQT46RxECddApXs83bdPPp8SvHe1KxGJ5NZdzN5vgZVVQZgdVnRFYbSk0RicaKaoFMrZIBOACnn8Vn+U8EyxcZI9+GeaCHsd31mL31i+iR8klaGC70bip33PF/xQFi+ATkStH8PqfEF9bTh4XVlURGzFVG6dnQw49Apkddzj0eOuNojvTweSqkHgh9mMDoshtYfQVZRrcbDI8sG9xhl6Qkf1xjmbDHqnh01w4WxGsOYn40b00B/8O6u5i8KH3F4JhbGIyz5M4X/mp32T4Ut9GY5yx3qX1xATG5hq/c39K2FdNK3i2E9Sd12vcUIOblQM3FLQuF3q8jSzOfbfsfRRw0l4Wben0ForFmKNbd5tKbVs06e
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 258f29b1-1293-442e-b152-08df337b8d4d
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:09:45.6012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MNgIIDxTVHG7TruM4h6NPB5LFjx3Q2TFgqYs+2FZb/v8KT1/5AMCwPzFEmduaLKWlCrTYFt9JhI4goHY5I9qQgNIQmg6L47PAU8Px8FyCBo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9220

Data on a zoned filesystem is always allocated append only, even when it
is placed on conventional zones, and its volume dwarfs the conventional
area a device typically exposes. So there is nothing to gain from placing
a data chunk on a conventional zone. Doing so does hurt though: it
consumes the conventional zones that metadata wants, and metadata is the
only consumer that actually benefits from being able to overwrite in
place.

Mirror the metadata side and search the sequential zones for a data
chunk first, falling back to all zones if that does not yield enough
devices for the requested allocation profile. Devices without
sequential zones, e.g. regular devices with emulated zones, skip the
restricted search and keep working as before.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/volumes.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 76bd54af8720..09449381fe2e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5897,6 +5897,15 @@ static void init_alloc_chunk_ctl(struct btrfs_fs_devices *fs_devices,
 	}
 }
 
+/*
+ * Metadata and system chunks are preferably placed on conventional zones.
+ * Those can be overwritten in place, so such block groups do not need the
+ * append only allocation and writeback paths.
+ *
+ * Data is always allocated append only, even on conventional zones, and dwarfs
+ * the typically small conventional area of a device. So keep it on sequential
+ * zones and leave the conventional zones to metadata.
+ */
 static enum btrfs_zone_filter chunk_zone_filter(const struct btrfs_fs_devices *fs_devices,
 						const struct alloc_chunk_ctl *ctl)
 {
@@ -5907,9 +5916,9 @@ static enum btrfs_zone_filter chunk_zone_filter(const struct btrfs_fs_devices *f
 		return BTRFS_ZONE_FILTER_NONE;
 
 	if (ctl->type & BTRFS_BLOCK_GROUP_DATA)
-		return BTRFS_ZONE_FILTER_NONE;
-
-	filter = BTRFS_ZONE_FILTER_CONV;
+		filter = BTRFS_ZONE_FILTER_SEQ;
+	else
+		filter = BTRFS_ZONE_FILTER_CONV;
 
 	/* Avoid a pointless first pass if no device has such zones at all. */
 	list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list) {
-- 
2.56.0

