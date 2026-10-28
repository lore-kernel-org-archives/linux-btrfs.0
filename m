Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793211704;
	b=dCSdLqH7Jc9aXmLheESz/aJ8bqWsow1dAwvEqZVnYDIGMxwQS717soqkFAPbqpCirPNW
	 PHQO1mStVnT/rznnb1sLZJ4DphG4fqoYioMP1BXaWzBmubfhLQLmMiXmPkXofOl3Ox37m
	 I18oLIxIuen1i67+U9ijM0RuyIQTHLfDxcdjqlqArkKLl+kJFPcVKs9mmLW/qMQdJKwWB
	 Q2rfiObsTqN0OX2h7T0ols7mqv3WlzB3mxRGpFMDEu7nBCm/zkqq1c9MHIkzvHgAbBTmQ
	 Ymd3cR6DgApw75yn8hv7cEo+ui628lEgUtwcqfEubV5sBEWrOmDooFtCP3WTU3ZAVDA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211704;
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
	bh=QrDlUrocWx4oSN3F3Lx+rXHUx3MRlOza2E4dHzOtb9Y=;
	b=sfcqARjoSG73j+/M3G3IXyzoxhodujnV/rKtxm/B2640CDZcQQjFvVVMC4v6uiBeio4N
	 kwRjxMQ6Hi/06Ur6mW1nV5oN/rJHxO2+9iHLGILTfHfjx7zveSp0eUCEEXzzFXGDBOZqJ
	 OKVgSCa3cpgXI05jSiZtxtzaQwdKNFQr9cbtklrqNcJtlskIQr5oQ9fCcFV4pJrV4g2X/
	 g+IuchcTTtN+fyF2mHWoxHtQ+jCvUZ/5Mn5UBSnsA3poDffZIqLrzY03bGNr/inMAiKjI
	 WEUwnUm3SUzeFJi3/VAzFHqSa+DepcimVOs+RJc5qzttbru3WoXRnAmStE+P6zI6EkQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=kRkAfrG6;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=BHOSoACH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B34360A261B
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 18:21:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1B34360A261B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=kRkAfrG6;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=BHOSoACH
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793211704; x=1824747704;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=a/DdTGIA4NDKSWs+NgJ/yzyC/IfICOtzppE7nuPHzac=;
  b=kRkAfrG6VtcSIRYmQ/aOCj8Dr9GXXJoqfi6EK8J3b+HxcpTTzlx4Td5V
   BaDttPuWddSWjykK3YQLVMLWzuRQE6kDq9mHbIFyRpcRESWhlBvzVCTfc
   HQzY+wwjPDHv6hZFYIK0c01/J5p14hbX2BDDsVh8SKp5B9My8laSMA1pw
   7T63p8FgbAePMzwpxvhcsTYkk3HYkMCLA28N96YueT1GIaFN6xlWeFtDn
   Coxk7WezdBBlJ7bnUnKXV3M4+uFMEDSF3BQ8N8QO3SxFzV1ZjlfI02Zj2
   BwNY5ZDO1TO4ooNKiyndXLF2vrgYltwNvzfiR5JGeChspN5n5y5hPe+Q8
   Q==;
X-CSE-ConnectionGUID: enx6e8EOTte86nZjiiTPfA==
X-CSE-MsgGUID: 1D4ZvtkLQliISCeS1fkySQ==
X-IronPort-AV: E=Sophos;i="6.27,183,1786982400"; 
   d="scan'208";a="160194166"
Received: from mail-eastus2azon11010053.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.53])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 02:21:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ocGcsFm1MnnuLnoMvwqVoM+bAMxqqqYRUb97gtVxg/iE6ETZhIO+XmvIgWlWSqkHFi/+ONc6I7MulCTr0D/a5m+eJcJcofkYlCEi78APO33ohZEib6rA7NeOs8Zg2p9Ss8htlJ1EVOLRkyz+2zAk3rprw+ggSd5UT6XRKGKkPr20kmON0qQvCrGz/TT0xxqkxmF3cdY3lTTEyWC9nDnexodvyFq5KQ0Gs7l0tmki4PZUBNYg7/R/61w1r6GpEH1IDC9YwQe9WPQsTR3TJ2GQuHhcG6xxsDf308JpcG3PEBgMX/UoTB21d1P19F21sK8xs30kWcz0IOWfzpTBJR7P/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QrDlUrocWx4oSN3F3Lx+rXHUx3MRlOza2E4dHzOtb9Y=;
 b=W5AXsTPAEPlNXs1YpyuwysGc2szHKtgmsu9cF2LvcIirKa/Ztsnb/s8CLiT37d4WfLJyAJLPCF7arlMfO8eQa/kn2Ji5oSqAaPYY27tAh9IVVEpUKcft59iQ2mqF8MKDWceXFOqpBA2EdfbpMLNBcX7mGg4NnCN6UXpRoxvHSl6BY0A9nWqTwbSQoD+HepQETOcEXi08+iLCkGUC3h1YBBewCP37aKipHoZY1Bha9c3S4BkPEF3Vq9sIF2pTyL7/uH1b1uum8Z4/ovx4GGLl1u4u7A2BWdOEeml+DLgpLzbmSCD1Be6vewsGfiUpaLSASn5r1LxWr0joOlDKpGjx6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QrDlUrocWx4oSN3F3Lx+rXHUx3MRlOza2E4dHzOtb9Y=;
 b=BHOSoACHC5/5i4+loEPl+/84j1d/M0nuherG6oniU9xmgtKDTcybFeAqOcMcefhjiefpn05ZoDXvmh52vhu+uWhlNjGwrUSFse+C8eW960BXj3/eybP1A3Wxqk07cuQX3DbjNrQ9nyC84WUvs4QV5EHGbeXlK4FeIak6debw4qk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7605.namprd04.prod.outlook.com (2603:10b6:510:57::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 18:21:39 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:21:39 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v6 09/25] btrfs: zoned: use plain mutex lock in check_bg_is_active
Date: Wed, 28 Oct 2026 19:20:55 +0100
Message-ID: <20261028182111.160492-10-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
References: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0052.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cc::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB7605:EE_
X-MS-Office365-Filtering-Correlation-Id: fe91fa40-2d04-44e3-11df-08df35204ecd
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|261028144727099003|11063799006|56012099006|261009223027099003|261026121527099003|261022105027099003|261021121427099003|261026140227099003|10067099003|261021123027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ue8V0cDiO06CJoESk7TgZtd+3hz0c6AULTvqIMJuyyyT1tnJtMroClPnCeL26Y7K9zXLHQmLjMCVXKR2cXgIwauRqk9cAAtYIgkbd4r4YEzm7rxDJWF69vmKAVQpigOUCRHqOFXNBu0rQ0t4pxomoZBIwPlHNvEF7gsEGk9jUdzfW5EzIovBcvGmx2lIDNqWOrLkAiIiKq7j0FhP+tC+QvQxTDQnWHEx/6IQAh4+HKSaDnr49b3fKU/oPhFfQcXZaPlOCg5mWT/amoatr0QTgMr61pIZX40r1ZpalTdmFGDXzosqTG61IZkwb6Q74QbuFUg+o+kxfSv1NhWnYWTvWgJmBzRYZNZvPAcisiGoS0BsuyQHazm/OhJ/bL+iFkrMiqrMVu1O+J3hfHMguE0NBkYeyCPAJQuZE66dhUmt9hLEUN6YZigpOz+CeyyGEHehNOHfFqiEQAZsfiA2Ef7djSvvOCLKBGnxTI1d2ADZIdGpgUfXNU06GMWeCXa2wuFlulU9IgOBAQULDKc+VHhuvLSiWp9ElTyINtBwdcZzoIBEMflCDu1Imse6WCHxCW9JXZW7EhaG9MQTlUToYRyuGxdT+2MQpTgAzhwZatH8I2zXK7XnXvI7XDf7ECeeyiCKt8aSfuHPdAfwlBBdR7Rm8wfMn5+KAoRfetyye5kSw4I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(261028144727099003)(11063799006)(56012099006)(261009223027099003)(261026121527099003)(261022105027099003)(261021121427099003)(261026140227099003)(10067099003)(261021123027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L5G+mmKSr5pfsOLbp/aK6porpSPc/llrKuog+GIw2mh9Tr952xhFtdcRmgLm?=
 =?us-ascii?Q?WQHkfP/jfdJWQENDRMdUC69+8MVZFNswhkYnSVRKcXt1Z7BmA03R2Mgeedn4?=
 =?us-ascii?Q?jZKPb6fcHpDQPjG0UgbCl04Unecg0SyW206jUjtHTUgerXEJ8EKx2VUrB5X8?=
 =?us-ascii?Q?YFqV+T83+EYyAAkTb23waoZ137pKxgMr5gHEJvkOUgh8i3zKrne/+sxHuSUI?=
 =?us-ascii?Q?iUMfakU5Uno3FfAAcvUDbacGQLe3DZihweUYwlb6rjpVDf9l5s+Lb439O3k3?=
 =?us-ascii?Q?LvTdoA2L5r64YBk8MOq69PJwhP0I4Bw43jcYvS/TO3M4zM/YjTSv3Lvs+AhK?=
 =?us-ascii?Q?ReJvubFy2WGe6ef+0dfSrEZ6RZkcn+PB+uO1kbALGDQquBEwU1Wx8VqNuAte?=
 =?us-ascii?Q?/4736TzgdwX11hLETBZy/NV2X3Gc8A3EqpjjOQGUDOx6Fw9txmKEesWBp3ti?=
 =?us-ascii?Q?kY5Ug8DF1itRkXzcvL3jj6mBEGaTnILCy2JqVcazVT3qTXKA9wFZg9okqhpu?=
 =?us-ascii?Q?PDtb8US/W+pxjsMGL4nLwZAMwd3NjQZpBbroR5dJ8AyBQiLbZCj4q+ej9xwd?=
 =?us-ascii?Q?1ESSPeoaRqSZt6qD0F4ulC1MhsMwvWgBORiNCXgHVv/g8slhBIq9ayKvW1xw?=
 =?us-ascii?Q?0KbPWhrHE50rOO0EiL1KSqhBX+nuWLYv57jUuVICbOxFpxzTXz/jyCVoNvoh?=
 =?us-ascii?Q?H2V4augpvR76DTnISCE6J786j2AXZynU3WhCaAsycFC+v67D48++DdknSrH4?=
 =?us-ascii?Q?ZeLX4axji7tKSMJJ/7nJCzNGMLFapwbC3n6EEfkaV9XykwPB47WBhDCdM8uJ?=
 =?us-ascii?Q?KYXr77vTMNZ8xtLIN9M32mBeH23JxQ2mxCIdnd+NvED2sU/SqVqu1wGDYSlB?=
 =?us-ascii?Q?pGvmmZjlinit5kQa/J842a0JQWs6VCp7vMBcX7urV0Aa3TusGIyJrV9zIVx/?=
 =?us-ascii?Q?n6pLEPuY26ie1BjFXeX8LULD/iwCYrqm9IqS1rmjbZ3I+XEKsKuPXFCcA3oN?=
 =?us-ascii?Q?Px9LWn+U2jx35CYKn/azW5YmqiQBVWXvVpGsfCo/7QlgL7SmwAqCwImuCTwC?=
 =?us-ascii?Q?LS7CBO2SlbrEv9iMzYAvbsW3lpzeO0RZ5ti/RWLmWLUwC/zNOxMrdOP4goHL?=
 =?us-ascii?Q?fyagMdJ6p3CMlgpZK+4XSWhivtjSXj/8516fr/RiAlhdusk8G5jJyl8D99ek?=
 =?us-ascii?Q?5BS3c5vxp1uEp0irEWpJtXWXcMSUpB+mkhXpWYYeCKy00XK/L6hj5Q51LyHT?=
 =?us-ascii?Q?o0KB6qXyBznxNHduAz60mtlUFR5maqcGT6f8kbaonKVDuXshLXslcYy9wa2x?=
 =?us-ascii?Q?PVSk7v0sWb+DBSPt9ekUBda64glXkNEL45mAf8/e1VKNIbrdaNY9I8z2WMH3?=
 =?us-ascii?Q?z21YYATumCtnsVh5z9tt/0T9lSvBPZ5g3bra0duN8ecziZE50U4E8gHuQlp4?=
 =?us-ascii?Q?UA8YtBFwgcWXgON487AJ+2omP/M1ugDkT4u00Z1JmTmSbwLotHv1CxLlrVDH?=
 =?us-ascii?Q?CouSREJkA7x3BWihpmacg6kZypIm/Nv79RakwAfKvE8UgR3KZ8FHp6oSu8fW?=
 =?us-ascii?Q?6Kk8fQ58eKDCOJEcXoiZOQU63JG/3xVQKud+U0nH7zDzSBNbUe3dcJ9ZbiVw?=
 =?us-ascii?Q?eZs0ZI8e5uGWIuBYi36HDjxHT3g1qNI8peITcVohCJERTXUI7/rNmL5OEUhl?=
 =?us-ascii?Q?mU4DsOLAoUmBkM7I2osH1DGN+w3fHoYSA8xUQdfK6PtTpJ2M5+QrqO2CPx21?=
 =?us-ascii?Q?ivMXlrHLT9Lvmx8rIfYp9X1qRUWHlxNszgyHfz6BYwuURNd8uw2sU4Bo35NW?=
X-MS-Exchange-AntiSpam-MessageData-1: DiBQvm9jcq6NzRN9a+WgvM1dLHAwDs0CQ1M=
X-Exchange-RoutingPolicyChecked:
	rTpmwVzx68VzSB2q7zd9MFa8JU/4+P9ULmobZ33VFA77TE9x9CKF/qgdN8UKFXMNjmVF8+i4SOnpbcSenXBd1U/Ec9kxI0JudUhSeFOILGPRSBBJzIApLQvgnHyHlwUsh5N8DKd4U3iE89To9FTjlZioE3n3/hC7sbYKyiJGyI0uMDpywerSsHv9ps8VYt75TMpYmvEmX0UUTJfu77ubHcVhpdJD/4Saq3ugW3FNHDcXksdQa9b47cDW5e4w6ajoAbbpa25iJ++E3KK4A1gTku0/l5S3UpM7+uzoNX+CQu5JXf44S4HizhsaLwHC248eYWYuPk0ncunRabVGFeW1xg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	R1XgfULoiJLtF+oOkunVGDgDC6MTq+TJicIrwKYNttua2cdshb5yuSdJSkOosxMgGXN/lPo90XjuSzjzWDUxMxE5DFWVgVHExAtyweMig/1qzUIF8v2nKcihpVSz2iZqAqViMfOJTt1UDX655UqfkGBKg36VX3yBoMPOjRfcDwlS3Y0n5nEPcjuFg8JwLZQeVHiNpPCRb4w6ya794T66SNpbM8xDes5iymJEqmEkaqYgjhqnU1iCLDBQ4piMqHtbnViEjj90r03WQYuZflBxeXbNPC10gkVqHuxGJwo2KSWrVWu90SjXl8q7L7rqyBYmY7p53vWBn6xSWEea00rgmgSwFTdGfkWBPfliQPtRQOF9FJrHCoMkxDHIUry2Q5tytyAmTIClxQvMMDQ+dn+H9k/MC8EcfcZ2HDIe3ethWCysBLF7ukK/XLxM4C6cUFfzaYfLzWZFHd9v6o/VekObEXNO8ymDO/+Bl4/dwjdOxaAMvwy7iw2tB2Q5A+NT8Pjw6kTwYhkvnTJiaqKKXER4VC5/PKZt4RA+OdT+G4AQgp/5HuazLQqJQU7jOEcKuffeiqF+I/lPswJyN0jr+BZLQni4dur+i21VU5aEL8ftKT1JOs8mHkGGviGBDC3HE3T1
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe91fa40-2d04-44e3-11df-08df35204ecd
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:21:38.9590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R6TxYUI8EwNs0M9SI56WQNogg3vmy5xR7NROHyCTDdId4GdJbnwGdsIMW5yPpJSBmcqhL3H57mLWZAHiUi7oZ3XPv6yKnsGWBMPJuFDjF+c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7605

check_bg_is_active() is only called for zoned filesystems, so there is
no need in using the wrapper for taking fs_info::zoned_meta_io_lock.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index a95e1bc9a982..b17e3c624672 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2245,9 +2245,9 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
 		if (!btrfs_zone_activate(block_group)) {
 			int ret_fin;
 
-			btrfs_zoned_meta_io_unlock(fs_info);
+			mutex_unlock(&fs_info->zoned_meta_io_lock);
 			ret_fin = btrfs_zone_finish_one_bg(fs_info);
-			btrfs_zoned_meta_io_lock(fs_info);
+			mutex_lock(&fs_info->zoned_meta_io_lock);
 
 			if (ret_fin != 1 || !btrfs_zone_activate(block_group))
 				return false;
@@ -2270,10 +2270,10 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
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

