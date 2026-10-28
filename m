Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793211718;
	b=XlvyZWi18QAyhJX9t97e+HE9FDyiejeGZ9IrTCH5af6Y8/EIyTvaEG0F+cWrt/8cyyTn
	 muHZr8ijUhnPS/UkVhEOs6zj/RwLGSy66VAYrccOlHfLZaDfszv8Q8iHzr/yEQmgJDxh6
	 qL2iYcIaTa189KK4pR0nOFtwrPsUCZMZlL8bbcVkBwhr8UdWAfon/2ZCRZnTYWAnIPgfR
	 uMopqkf125fkKmILr6x+oSMlGNRJ9skOL2wdAFiYH0wUkM+AK/8uBP0CE+u3qN92LeuZO
	 /RIzO6TNFLEXTZF0/3yuW3L/BvKa7cYXM2sJYXUz6j4wp2qb7dHYQv7Ej1JZsQiwyxA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211718;
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
	bh=DbUOeXjLFj48idGYVRBslLSC6v3Wep18duMv2miCY9k=;
	b=ck0hlNbVBotN1+YfebuYFvoA0UANJxf9jcv5nEAorBdyIHMEmwKpHTfbo5AfB57/d3pW
	 wb/VvVkeVQgs+bSKdTUur9u4mSgqHkD30YWbywmcKjJnqG9s4zbSGIuGaQMxSlteaJpp1
	 xB0HQqp68OSSmBTg1L767SpsNfyFX9Ghh/jQt7QgL9aVNzhZ3kD/7mkXOOIBbqcm/oaV/
	 pczsQ+eYJUMY1s8JcY+POg0IDc9dEAr9k4qpHfxTa8qExlv6nrnqnDSFLmxmZJF8LmePz
	 dk+QKLg1V+PSQ8JRiLeERXtN14oaYSma2ip/OpQ6Z1WF7WR5qbUFTzmdPRAq8+r2mig==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=am6vbe2C;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="uPI5t/k+";
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06D660A381F
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 18:21:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B06D660A381F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=am6vbe2C;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=uPI5t/k+
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793211717; x=1824747717;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=wTfnSyCkPvuvxkt0vnSR0REV0dOkeArah7Xkp1xWctg=;
  b=am6vbe2C24C9bQlEzcqePBVSwjTPESabUHqUzlFNdl7MRK79fkvedOVO
   xjuDSohAZCugWw6Y6vCnGejay7fRB3OfVL3eimMNxrQTX6Rn76htelqK6
   ieahRelJ/Yg3Mx9cnbEvornihGy8Z4zHmubGhnXqbkqzP9j9kmzi0wsVN
   EYM9BGju6mzxYkm5hJJLleAWhQlWxunqkBOTSvGOiLC/FqIJHOnkWRzfd
   LTIK+NB1dk1ge9PTrJxh/+A8bSAxa3dMDTMcaCIOnfWRmB07HHd+YFf1i
   /dKI8u706E6LG2whCLLVZuu7CqGGpfCG/Lx9Kz91l7t7iL/KZ4v2NsYpv
   Q==;
X-CSE-ConnectionGUID: IdHoV/aDRNevIqXVZYwvZQ==
X-CSE-MsgGUID: YPBLXcWiSwGwwDqGaHqOSA==
X-IronPort-AV: E=Sophos;i="6.27,183,1786982400"; 
   d="scan'208";a="155004272"
Received: from mail-westus3azon11011042.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.42])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 02:21:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kS/JMIL2uhaDQL8gNKtfXxI4IG4SPyzwafW04Y1vV7eJERz8W2Qa9WJR1qQyKLcgte0FonDSUYnlxWoOfAUAq4cUn3FXgxdiT7hxUTqb7LceGCQME8V/0Xw6TcYVu6gpNf8ch+MLna1f0VdYt4SOcSrJHM4n5X43wk++2x78sO1untsBbCDPTr08Vlp8SlmdzEnrZ7I6c3f4sO2wDL+aUqtzlvKyDi6DjiGNe7uMqGmuggKdXIqr0tyIxwZyQcouxhFoxyq84cO/MdfdzpjNcN2vsMcOnDBceLKfLIj2qTvPix8AyDoHNZ6iYJauSonpibtONwl0UnIGOTePJ6Ha8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DbUOeXjLFj48idGYVRBslLSC6v3Wep18duMv2miCY9k=;
 b=u9/zI3AS8SpNLMd5TfGXTQmGCNfmPM+2d2w0SInboYIbENoL3AD3g6q2pJm8RxGVYLnfiSQR05yEytDm/+HM9znUt2PT/19iLqP+vATSASuSRP3ysHsnnV2+Rv/pfTitoeIHi+IW5glxnyo3VHALHTGrV/iN1iQ816z9ILZfj5/OEwlY1eRTZieMip1+zUw2o8q6/Um5mPy+CutAAXLzE5eY/k9Eq1AB7KQf+qPM70Xk9tMUdfuRm8VYyNu4vyMT38OylkulW512hzwzJnuCo8gBCd+8XiB2mVOjoKaDv0ULhWzsYqRxqqXZpvmaitZjzJqKClDSeygZBL104J4aHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DbUOeXjLFj48idGYVRBslLSC6v3Wep18duMv2miCY9k=;
 b=uPI5t/k+P3UUeg1FTmbG9dYNr/hXEgvsBy4rx9EaigmBOAm01pBsSWteUoVJLwD1T/wJ+sUYqFET0chSGCFq9MmGJ3zqVfIseeGsDQBzfaEMw8/ua+yA9A+7e/uKp06cjSB0GtGQEC2S+DkXalazmNVJJfVEf51VCgY/XxiLBxU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7605.namprd04.prod.outlook.com (2603:10b6:510:57::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 18:21:50 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:21:50 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v6 19/25] btrfs: zoned: promote reset data block groups to the relocation target
Date: Wed, 28 Oct 2026 19:21:05 +0100
Message-ID: <20261028182111.160492-20-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: df06084f-a121-4b92-b865-08df352055e8
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|261028144727099003|11063799006|56012099006|261009223027099003|261022105027099003|261021121427099003|261026140227099003|10067099003|261021123027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	QNkKElTm1BaRL6WkwZTiZfO/IOmkaQEfizj9D2Qizdcs4T8RDupkrRosxuc7Gk9kjp8tsTNiaB/KJBZ0h7O9dWi3u5KrxyPUk4hLkDNQ5Tl6hGyzWtxFilvsW6ZFdUoRmFa7n14kgw5gALR9iKyX89z0fIsT5EY3ei9xfmByvMrq0uc6sG2F92C/9f1Qaz7HrMujAYTLPZrEahYEDPUbYLeMG7EIAzaPd6SmIRoZTFDAN2Tk4VZWYO7PGNltfYuIc0D9pEiXsIlq2FY8ok2AZOOjPR9Hkqa2sMCVtkKtpxmcRLF+xotpkFcGFTc2tLdGyhRlmjcJb/XeoG/r+wWiIKd9k8HrPTwNqIstumywWrjK5qAVIoP3LYvGLMgMpGhMCp/wd5wjMB1RaIvA2PU0tGT+IiomaINApvJ9tJU29wp0XSLUfFVlUmma9WL+b4zZ6TUu2oCwFH46LxXubLEheD6Mt2QZpVMFAYbkTfatUGEV5smRcupFchlESxUCrc9hxaFA1/R5F1ajgBNKsQbk2DPSiqVrddv/lSJ0pvmbVDuEh9v105t0rTewL4OV6DFGZpf7e5JWmKxtFFdjDCCqbkiN5P4S1Pa9b+q8+qXU0I08vDiGPvuiLk8MsX2BTFnc4p4KtLdOA77IiGPA3BBEKaT3h6YGvlVGp+3zoUo7y0w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(261028144727099003)(11063799006)(56012099006)(261009223027099003)(261022105027099003)(261021121427099003)(261026140227099003)(10067099003)(261021123027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BALR5HL+PxCseaJfPawfGUNH9unJQUvGPur1X7ynxf+PsaNi6zNSKSI0PgF/?=
 =?us-ascii?Q?lOPNxHOW76u+ReMFOE7RK6mZYiDg6ch/Sl4htRXe3bsmxr6nSlCcgJxnaoN5?=
 =?us-ascii?Q?eaTzRoRjcu4BsWPFMxr44V0Uv7c2lebL2Qsh5wShl8AH0unZ5XajMm+8EvVB?=
 =?us-ascii?Q?GTpgZXTb6OaP7sKesMDcL1WsXO5NCQ2mr29FZ6QeICxCfv/0LHEmZBH/sQD8?=
 =?us-ascii?Q?ZhUzdbZKETp8b3lzgdMUErJUpgatFdHpxt/fiKJ/EDMCh5/m6XyKGHVtqM5n?=
 =?us-ascii?Q?V9mNwQVa/cFmZrU0wmo5DRG28tlf5fZBDZB5oIOeCbt16DPdxRbSWZlnm9Ev?=
 =?us-ascii?Q?sp1NfkBVdhlrM7Ntw8COENh1gyCBTz4KofFLVHWg062JPqP4hFPhy68uNZ1O?=
 =?us-ascii?Q?YoPrc4zYhHdLBE5NmNUxPKEzVUim9alcvXM+6/sf4bBNzn5I6NGl+nGfcpCk?=
 =?us-ascii?Q?NQjs637ZI8UkBMHGavDmot2/5DbqN7OQEwFsHRYMkpRdigcdBGehENspkemw?=
 =?us-ascii?Q?MlLRLTnzxvV1XLafTiLhd7E0YXiZ8ttZnHNy2HpzizG/lqpnWPMWpAlMIjsk?=
 =?us-ascii?Q?OOV9kLop7/lj1xFslMrzCsWLCoOAuoTcW51tYcwKSnFDhKgEI8httpn+xY5C?=
 =?us-ascii?Q?kxAIJtAfRMvFgN2Q/Z4TryI2yblZr0K6us1+Ol724dZ8gTg8Z4zc0fnDwiYV?=
 =?us-ascii?Q?ANGU3XarvKsCbsEkFR/tYzL/zcn+aJjUAQrsrYTiXKDpozQ0HJkgmUvam2Q4?=
 =?us-ascii?Q?Hg0V5MQjlOWND7Gp+PPvozWKxkGm2bccFrvsGF0Y+BDx9dG9KYztAksShKSQ?=
 =?us-ascii?Q?LVcxt3DlR+pUQn/bH94LMlHejgBAkXa7cBNwDRveCsEtSthDCKbH/j2tunH7?=
 =?us-ascii?Q?ZeHUxfWnbA1ElIuc0ef5+Cr1rZAXAa/LSwqrD+N0AZVPqorKETIQY7gTKuk0?=
 =?us-ascii?Q?c6EnJqbu1FnYZJk5HTq8G6OKzBPRy/BqClxjEgdIVZ+B9uNB6R+iOA/lWFAE?=
 =?us-ascii?Q?G6ED36tjEVgnZxGBVM7PQ6IobWI4P5XvcPwv1/WMP0EF1hpOKNka1FHgMfd5?=
 =?us-ascii?Q?FIHckBxw7IuS+9sxA0dmcy0PhMKVr70kUlVmtNxU3yLwgFKUuDxCFr8+0t8h?=
 =?us-ascii?Q?lofERskC/lOmBGG0xyQLjbgFV0t+LDMixhM8ArQwmVjxEhZzR47KS8663gRA?=
 =?us-ascii?Q?KttT67sPqfyCTewWywbchDnoNhG+1GM4L0FgCjg62a4XmHlqWBZpmmCP6f2J?=
 =?us-ascii?Q?C2esDuEG7E5sM5zvh70pv7kbEQH9tON0T3tAMpQx1bhL2uwq1hsiUNbYZ+ux?=
 =?us-ascii?Q?eLIC4y49Q/LDMD6+XYEj8thL78y46rjW+HfN5fiIkSvtjZPCkK8JPlQL2mXQ?=
 =?us-ascii?Q?7zJgsSGgGx/B8uhjni7OA/vUay7m9nLakYv+DFl0vsIr5gU9M2cL7jlS1GxU?=
 =?us-ascii?Q?OGchRGk06KE77D6IDtQQLlpqHL39QlblV3moOTXzaDvSqJiu9zEA4C8m8N0L?=
 =?us-ascii?Q?L+f8g+9WXtqERiIY/xP+vBsU2zexpxEDEVgJQDMRuDJI5w6cxOoCR6OcYbZc?=
 =?us-ascii?Q?AFOOZOuLrIolHOJRPHtqbMA4Fa2tBFxkSlF/NC6ytulqcdnk4eTJKGreb1/l?=
 =?us-ascii?Q?94iXgGR9arlRtQL0DTGpL7uBIPxep7QuoPijrMV1ScjwFAS5s6E/DdYHRjJX?=
 =?us-ascii?Q?hAu9sriEhKYMkHf/CXJ1pblYN8Dxa471xwtjL6ccJ1BzcqYhNcd9TXOcb4bQ?=
 =?us-ascii?Q?L0Yp2IRozDk0zazF0ac4HPw2eFnmiF0kgepDFswuhIoVu8Q5gh20HEtlhlvB?=
X-MS-Exchange-AntiSpam-MessageData-1: H//MAdd4PINY5LxMSr8MPfNPE9sBl/RkCgk=
X-Exchange-RoutingPolicyChecked:
	Vdj+VldHjinde/+PCcCLowqXNg7iKxlc9XziVrFX/7IfhduRsz4Cyne55M9O1b3fDQr6TKmlQu1DRp1Qkl3Y5ILC2sJDL7YTGVM96yzReTPInNEZDwbPSmwZBUxjnxGUh9mpmA+wKjZzyB/y7b6Se8IxvKX0nU7r4WpKxmepLf9TIeELOUpkp3dLrJoxfhynj3MxAAUb3PVorePormGP/PDw9E5wrfuZwBELDOhUNmmv6Lv07YpOCqZPgNhSBSpNkay+wIFB0xzHN/+4lprH4gBLthSSYjO+dV3rT1FBnsYqjCBv7tht8QrJ0+BR0aSu7XtGC38jOty7HRs9aEsToA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cDUrKtTh7cQDB78FmM9ELtdoPnt0rlkF7zM58HOnTVDr04uGtttjr8ygWN0BUfmmN234s4a2FoNw+87XBcNelalszs392efcrDzHC0N4la7JBlxwrCx7XLm3H0nLp0o8Y1WarCFLH1b/Ux18tkYet5T0Um3hVFLJhLyK8Auk9VAgFo5U68eYMKLvcF8xKEwrfJXnzbuXUT26J2NESRYVEZcN65UcB/SAEnYe6++4wu1sSOT/im812fOQtbpwADMh4DgHaV/FcYqckl7QrRXmE4LUdqlJiUz7QrWEfBB6lajSAP4ExLKataS10orXjaPd6puM+4p3YGOnKucV+1LHLcZ2LBlQ0OWAvQXRzGiDODfWap4R3zti7lWiBhWdOFgsISYbbKOnvi7ZCaytfZj1kJNsmDJGvSNGxVpGFYexwCjf0AS3z7gFabNMyi6i3/vFxyZuSw5sX9VUaaopARv3FCxoTGPtgrrwGtsGnYrjmz7b9GoU7We6qQSQxNHPSbLvAt04wkOfTgjTE47oEL+uFcQByYzQCbBO2uDMqlO0VBuTSP2HyCrXZ3WPreKiK0Hm23i9shwBb926iRAyZ936avq2sQJb9OJY0wq4j3Ycc7TECNZYhpyZEnLa1T63y819
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df06084f-a121-4b92-b865-08df352055e8
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:21:50.8188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AV0QVDvvX5z3+aZTgevX4sVWp+R5By9/7Y7PIz21mMCVuQj1TxPe00BGWKp/+KiPPGc4SgWlj/Fj3w0UVMFQZqsbZmbUDmaZeOsoVz/S+Cg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7605

When btrfs_reset_unused_block_groups() resets a data block group in place
and there is currently no data relocation block group, use the reset
block group as the new data relocation block group, instead of returning
its space to the data space_info.

Returning the space first would let a waiting data write take it, only
to have the block group moved into the data relocation sub space_info
afterwards.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index dc074cb0c042..55706f95acf8 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3040,7 +3040,8 @@ static bool btrfs_set_data_reloc_bg(struct btrfs_fs_info *fs_info,
 	return true;
 }
 
-static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
+static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, bool promote,
+				   u64 *reclaimed)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
 	struct btrfs_space_info *space_info = bg->space_info;
@@ -3100,9 +3101,28 @@ static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
 	bg->free_space_ctl->free_space += *reclaimed;
 	btrfs_space_info_update_bytes_zone_unusable(space_info, -*reclaimed);
 	spin_unlock(&bg->lock);
-	btrfs_return_free_space(space_info, *reclaimed);
+
+	/*
+	 * If we need a data relocation target, promote this just
+	 * evacuated and reset zone to be it directly, instead of
+	 * returning its free space to the data space_info. Otherwise the
+	 * returned space could be handed out to a waiting data write and
+	 * then yanked away by the migration into the relocation
+	 * space_info.
+	 */
+	promote = promote && (space_info->flags & BTRFS_BLOCK_GROUP_DATA);
+	if (!promote)
+		btrfs_return_free_space(space_info, *reclaimed);
 	spin_unlock(&space_info->lock);
 
+	if (promote && !btrfs_set_data_reloc_bg(fs_info, bg)) {
+		struct btrfs_space_info *space_info = bg->space_info;
+
+		spin_lock(&space_info->lock);
+		btrfs_return_free_space(space_info, *reclaimed);
+		spin_unlock(&space_info->lock);
+	}
+
 	return 0;
 }
 
@@ -3484,7 +3504,8 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		list_del_init(&bg->bg_list);
 		spin_unlock(&fs_info->unused_bgs_lock);
 
-		ret = zoned_reset_bg_in_place(bg, &reclaimed);
+		ret = zoned_reset_bg_in_place(bg, data_race(!fs_info->data_reloc_bg),
+				&reclaimed);
 		if (ret || !reclaimed)
 			goto requeue;
 
-- 
2.56.0

