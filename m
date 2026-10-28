Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793211696;
	b=Fufg1l8vPuyMrbz2RV4jEj3p4dKUYxUTsAgD9ZjCjD6B6tG3ogVWmfg3V6CkBd5FXFTx
	 GYibtr1/l5DrCWabNgJR3SroSYBvpUd+DZtFZw9yISyxHHUSmaWXYgPjes1T7qRNablvt
	 iHMNNVX04gz2oCA6tpP4b6qae/BoVriIpXZ8/zgZlCFfSI01KIM9e6+LKoitFk5YKzRT9
	 Vl8EhNi+HDkvt4DW8jKCx//qRej0EwhQFnI6vIXAY++dyoiwcOaUR5hBAYicK3Vmw/UcI
	 THiG0YPXHYGnFNh0aEv4qwRhtNMANAaD1pMM828YPKbxtPeFt1/QJ9aCSZOk24moggQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211696;
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
	bh=FJNnJxLnUcfvVx9RfiRyW8QJjgTTzi6fOoqZXJkxo0A=;
	b=nvweb78uMDuHhMB9kPwmGROoI5Hwo9/WuLwMW2jekSkHIBItblhiQBSE0LYFLZAkXuJx
	 lR9y9MpDOufyVGRiz6ORq2yxe/osRUvpOUkTJqyO3RMFvpIQ5FAIddMU5Tz0GsdpsxuIF
	 mDAf6wS8lvqXuHO9/crHXLoAHp7zPhgi+l1OXD5ldsjcd+A2Jhg3PHtFU3B3YPWGozWxp
	 qThmgbxsil+X45Zg6SpMv0ZGhcnUgmjX0qbJqed5KI7vhEECUihuTtJcXzMfVt6wdAmj2
	 pZ8vCqtDSAmwBlh58QPAfSe5E2QEGD3wu49k6yCnCipSkAH5il81lO5bpOGyI1Hg4+g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=peA1AK97;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Nyqb4pqe;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD360606A32D
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 18:21:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD360606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=peA1AK97;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Nyqb4pqe
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793211696; x=1824747696;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=sR1wB+/3HycbmmkQTPWoznwDxoQ/wxVV/GMw+2RP5A0=;
  b=peA1AK975O0Ty1MBNLSAh+vPiyS171qVko5YS2syYcwLaFG8Kj0NY5B7
   1lIqd3oHBx+lpKmfDzDCEJYHcYD3xkksonimCK/lSGWjOwXORQXSYWsyB
   lULhtsWN/Hl8OUxRRuuj5KHa5p1TYb8XFQaPcYAeemjiFYios8JuIP9fg
   0s7A2XqUSQp9wvvUmOovz3LnzbU5WAT+t2LRV2mm/rTCAuNs121X7wpBF
   tYaQk2jz+xYlLKCGrggaiGTwdaK/3TbZU9xO0058Ex9Abjx8a8lcebIBn
   0bG7Y6b0HZFfuTyvLaw0vA9B6KN2PpLFR+TMPnrdFOu26FHwOSCJd995Z
   g==;
X-CSE-ConnectionGUID: 9Vy3AdeXSpeboqkALrx+Jw==
X-CSE-MsgGUID: 4dpVOj3dSdeZ37w6I7AJ3w==
X-IronPort-AV: E=Sophos;i="6.27,183,1786982400"; 
   d="scan'208";a="159234663"
Received: from mail-westcentralusazon11013018.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.18])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 02:21:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z8Xj4nWb78FwJAtyNi5w+jsHwTNRRRQGzyx9yWn9PBzt55xFqYvNteEgYnU/ky9i6bcQy9EvJOPVg5OGa2x7jVSsDo7NHX7JmpwT2hOym/yf9YmZRys4zZoWE0EXiEE6KqHtZB8KdpGy3c75mSCmoNBpoMYXJrQJ1oj8auFZp98PuBtdsyiXkFrWgflrknx/3m94/T8YXgoJYUGk6eQNgkhmxTcwPUVyI6XJrDF4bzCmuDu+1igl2Yh41LAjDE5tDFkIFLifRVgkEd2OzN8074sJdaDDJgAFgCLG4kQgqWtGtVyh2kmipCcbHqOvyjh0KkfGcDTo7yCk5BE24lhZcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FJNnJxLnUcfvVx9RfiRyW8QJjgTTzi6fOoqZXJkxo0A=;
 b=t0bRcM1q8dqx8IJENSIdM89ZwWIJ5FM+DQ0HTeB7EqrllkXsc24VZtvMW24tbrYThg4rQ2vW74jJKIgqxvPXUQxZhH7DymgjNm8y9jdhBewpKC5ohD6zgTtsMQEh/0HIB3i7OenUAXs/bzC5A7rdFDyN6r5pKb5ARDAvBp6Uhafa6qeS/LeufPl7DmrS2MmKwsrkoPRHyw3/m3my0Sv3WLtaFpEOD/6KrpjxhF6LPqPoFQxmEpanalItagRi6VTil6M2dz+9LSOzCnw4SL6+pZzNl9VSR0SnPbUfbMV49Hn66XvDJmX/jWMRNoerxs/sHRf1QTPhr9iKe3JWCzMe4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FJNnJxLnUcfvVx9RfiRyW8QJjgTTzi6fOoqZXJkxo0A=;
 b=Nyqb4pqeB7zRpUvlfdHarZKBR5VtFI107cdo5PH9N8W5kRiUqUWTa8Q46sgYw8eQ+8cQ4HjqiNp5x05cCnYc+QS1xj+iT4ZkIBhp464uqBfxhB7qJuhEv5tSRDWaowbRF7A8kgvFkk+U6zXb3vxvnh/Gtk0AeI7g5dd9uBXr5Ms=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH7PR04MB8753.namprd04.prod.outlook.com (2603:10b6:510:234::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 18:21:32 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:21:32 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v6 03/25] btrfs: zoned: skip the append only metadata writeback path for conventional block groups
Date: Wed, 28 Oct 2026 19:20:49 +0100
Message-ID: <20261028182111.160492-4-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH7PR04MB8753:EE_
X-MS-Office365-Filtering-Correlation-Id: 55c5136c-5e9c-4f96-87f9-08df35204ad6
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|10070799003|376014|19092799006|261028144727099003|11063799006|5023799004|56012099006|261009223027099003|261026140227099003|261021121427099003|261026121527099003|261021123027099003|261022075727099003|10067099003|261022105027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	gUP+m8VPAfDG2vUtc1wxX/pBNyDi1q/RNbLMstb3hKPvpMqzfZtTLz51A0x7SvG86pk2OmkWg0iMzUYTf+d2zoAGFOnR5QGDL+YBEwlLMsIYAUEUkI5CabCVBxOG3lHL91/Va0jA7TM6etAGf4KmCoMgW/8YwBkGAB30VWGMPKFvge0zapvrbUUztOfXpmfnXQfbbMbZnjOcgY4xGNd6IHlQkkLkyrUEySB6U24P0g5m+Zx4/SfcBfN33T8QcDmUZq3sB5UHhgI5GIzXNqlPS/x+tg7NayjDpQTZUJphdHz9I49jMtMtdM8IvOMxehvkoGeckbMILkabJcGZjapJ45AQomMKcod0ZrnVENQ7ZNOEFyPR54TU/u+IcY1DD9t6TuJjPEFTP/Gj3m3lFh5DkPdQ9QE+vOSi6Zo8izKt+Dx5sYoOCzL1COVT2MYoYnMoVqMwsAkONbElIL9xrYCQ31ymY6dZf15I7cWaqTPu5HDZbuGxI2PXzmbuDizU6Oc7qZHvdAtMgOyw8+BhOaQnGN3ThOufivZ2E0My6By2jdNhj81Xq4j6OtSybq+X+YYvMcs62Wrk76QJp0X0AIR72W+E53t33eobnI9LmY1+joQhn1a+7z+f46VSYpNPkKQF9KBg05RUr1Iw2Sez/BZbt1mjoHYwxYVyS9N6epyD/Ck=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(10070799003)(376014)(19092799006)(261028144727099003)(11063799006)(5023799004)(56012099006)(261009223027099003)(261026140227099003)(261021121427099003)(261026121527099003)(261021123027099003)(261022075727099003)(10067099003)(261022105027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Czl9U5gqE62No8uzsg1BMNSPU1WcKCPeQtdHZ585nnM7OK9YOmqYagnecoFy?=
 =?us-ascii?Q?pvezpa4iKHQNNRFD31p6trLCZc6o8iy25X3WcCBKeA3xu1lRjTLbs32kZzdJ?=
 =?us-ascii?Q?3vlFptIY6iwEYjTRaTl4gsDJjS7m92IkCARe6A0N9UEt0Q5BepuCvnBoIRTT?=
 =?us-ascii?Q?f8qGDKk5Go42l5CSMqTskzqOZQkg6By0ub3/J2Vfr4N9dX3Fju+NnKP+hKGa?=
 =?us-ascii?Q?fG8bRdJ778SEsKxLK7jr4EsSb+TZatKv4eBPCDPp9wIiTEvwXBKnteYy3wpy?=
 =?us-ascii?Q?woXru6BtasbFi3YgvdU5+7XM50N5fv+cv1dIN7oDFTFZuijwyTpc9fVRO6zl?=
 =?us-ascii?Q?GENey+ZWkEWZ5w2Wvvievufchj8QIUdNj4BZqcQw5/Bdvj4luOw2D5qq2w1/?=
 =?us-ascii?Q?neYtkGwA1sFyqYKeyUbN2ebmPmgZPGBA2+fIiKgu2hwL1nSRTftQZ2JwpFDn?=
 =?us-ascii?Q?V1XRVUL0Gs8tEoixiutLSswQMQjKSoxmzSi/vHVB/K1ZxaVPqVh2LsPDrKLy?=
 =?us-ascii?Q?zA+p8S7azkbNl6Qjd6osgoiwsyENjNTB7mwuQv/lKhZzEOcTYOUNamf23WZ+?=
 =?us-ascii?Q?m3g5q/2en8GxfQOW6CmeyVhkVPo7KZFi16Be4yWmU4OG+0bDsN2FT8jP2iiL?=
 =?us-ascii?Q?Cj1suFTX/bbIDyRZkzPtKXKurPoLR61l9a51d44UxvZ+tyC0O7c+CJuVfUmj?=
 =?us-ascii?Q?PQyukZ1fclNU7FGczj/z6S7PO+pmux3mVHxjmc9SVQFpbL/bNlr0i8XeigCh?=
 =?us-ascii?Q?0UJUCs4WeR+ttR3t5iWi3W024ZAMswNMIi8ZEXGtJ9UjiBtPcyGsPR7wT0CT?=
 =?us-ascii?Q?QTRf4g3rXZXdcWXu5enqp2EYQujUSuOVswukBrUaR0x+MmRsCwasswSquCWd?=
 =?us-ascii?Q?NBFsQmno/TcB1ZP52XbRi06JC1B3dDp3MknMuq6OFnk6d0nSfKo3F20NwAo+?=
 =?us-ascii?Q?plwctvqT8oB++IvAj4cmzSmcW3yheQIK4kMO+dco3FkoQEuVSwtc67vJJPmh?=
 =?us-ascii?Q?Yngm+dM02JCySmIHJdfOdxGXY0c59/gI58nXUWruINm+C1eeXT1daC/quAp/?=
 =?us-ascii?Q?aZU/WLF468Ht6ulhXrYxmHkphPKHtIWQOm6yCt5qyM1A/suDeqGIXF9BiNJ4?=
 =?us-ascii?Q?zCBPV2EQio69RiNLhCoFHx4VFZ3G7LaSecLizlBsg4QSqqZq7yoRfr7xdsJx?=
 =?us-ascii?Q?YUSpbI4mGwCN7j85H2kCuugTQ3q46I+Jj4aPQHa0ZWWO6fgfZtC78lB/glis?=
 =?us-ascii?Q?ms9953SKK9QHaBZUWIzFFH7DnXHvz9PDLPJWwaJWQBC8r6A+QdF2CbvHZP5d?=
 =?us-ascii?Q?biNxh/U6nUpb+7TxNhqBeYVDGv/0BajHc22inAcgqxsOSjofjWh9+La7FD9F?=
 =?us-ascii?Q?kNUZGNiozZCpiuiKiPgNMN8obWfgAZ+RuiRJlNTfcuZRZsKyrFtwKh3c6YFJ?=
 =?us-ascii?Q?xmP/uAaixSl5OmHN+gPr9NlebaIJXU4/j3v4R7fpqBgW8/NcvnTTuzUFooaW?=
 =?us-ascii?Q?cRb56/77YvEJUDyc9JpzBaqt/gt2zs9yQTmNP4bQP+w17Ec3fEtYEUtDzYNm?=
 =?us-ascii?Q?grhA39u11S93U/gBsoondQv/HS+SFShV1ZBFR8Ua6nY3Jo6oICUtDzHCwKvh?=
 =?us-ascii?Q?f2RQI7iy9EAIIkAYBToS+G9pxRPNd52eUl9KmqZH1+U05VDXegXZAR3nZNr9?=
 =?us-ascii?Q?d6yCQj2CoCGcKDrHdEHFc95vRgzunEEsInbRk1txV4w4bI0a2MRJdCHjo2ip?=
 =?us-ascii?Q?OlIxx0G242IMo96JY4RNIs/DnW8ZuNRWs0ikRnkW5g/AMEvwDE7rLzRit6AF?=
X-MS-Exchange-AntiSpam-MessageData-1: 7cCDMH1U2zEQr2VoFhKnJ7+jxEFNhYaeNLg=
X-Exchange-RoutingPolicyChecked:
	w8l0W0WzceTh3D+xxLSFLL3FcqbzgL0ZXT+bfI2suRuj4G951KtbTAPbI3Y06QyLEXFqhsRXd3MwOjKpyfmTLcGypbafYxHRIBsKlsbKdEWwRPWt2m8+UqgmfrlIbv/Y/MgV/IC/AlUqWHjfwBTNuzN+y9YrmA/ijaynqjUbhBSFieQiz6x9TSxPE7I2Xzo1Bqm1pwDkyHz5aLkASw6QGlHVOLT8qgdd1xbW4ni0zSuy/QLXx9QP4bJgJJH6wmWSyLUEi8m/QUnR1YUZNyrRMl45XzWiuNtCyyTEObMbwbpMOweU4xrd/qLpvlnxmPaaLMw6LdsCujenvhmAqPigHQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	A8hu2S7ygHibdh/J52hyUkLyvHji0NxpjdEfWwzv4lXku1CYwC8tYIMxgjWszdVPTeIZ/9rgc9szDnnJsBpYQGCILCuQ4ZXYka90Bc81SlNNdoAVn7gpLzFHKhIpTu/7bJrimTOhCVElEPMzTVullaRMVugG+fULvEcSYOsQEjJ15cSKU8XXh7n+LfwZ9HQpY8Eqf5SVsZbcakjG7OJOFoDqg6ch/dpJWfSAbR+cW5sU6KpToMbABFNEy6WQP4otH6OmXiqcq+EXcM/sFuliFLHcbQJ36141dSW8ieQw9ASdQPYeeYHhP8gZjF8DAtIwWhYk0xEaAVLGEOZuGbl+gx83YmPQCHD1BEoQebmEdR4PIYX44od+pvcv0WtQI1PCxmKppOafYVpjwJ176AzpRruBVo3E9KvwOT54ndZNv7PP8H34gKzfU5t4iWN1CV1c9Pzzw3G1ZlxJKycFxPJTNS1SPivWjKFmWJY4nw1eDeH9QvGdIbBS+ubPyJOe5ma7bjHiseFTjnBlAZtqTu3Hw3bWP8nU8PuC/CtZaYmTMCbr3DDh7GP4vNW+CMZHWHBwBlTeacQLm7RcHRqJUDlTz3LfGelFY8HTcEEpm2dnN3WToNsPLZL97wLZL7BXvP0v
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55c5136c-5e9c-4f96-87f9-08df35204ad6
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:21:32.2492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 055yJDoN6E2MWyprFocVTJ3YX56xsZjUu7JSpL575SPehfc1PvQUjJnrM5i510BAAzvAp6glesLoEJBIMID/ZgqhrFF6jUIRUA2WnjpmZEg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8753

Metadata living in a block group backed by conventional zones only can
be overwritten in place and in arbitrary order. There is no write
pointer to honour, so there is no need to serialize the extent buffer
writeback against block_group::meta_write_pointer, to keep a zone
active, or to write out a freed tree block as zeros just to advance the
write pointer.

Add btrfs_zoned_bg_is_append_only() and use it to bypass all of that
for such block groups, which lets metadata writeback proceed out of
order and with a queue depth larger than one.

Freeing a dirty tree block needs to know whether its block group is
append only. Count metadata block groups with and without sequential
zones, so the block group lookup is only needed if both kinds exist.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  7 ++++---
 fs/btrfs/extent_io.c   | 10 +++++-----
 fs/btrfs/fs.h          |  2 ++
 fs/btrfs/zoned.c       | 29 ++++++++++++++++++++++++++++-
 fs/btrfs/zoned.h       | 34 ++++++++++++++++++++++++++++++++++
 5 files changed, 73 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 027830a53f7d..b29070b51b92 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -64,11 +64,11 @@ int btrfs_should_fragment_free_space(const struct btrfs_block_group *block_group
 
 static inline bool has_unwritten_metadata(struct btrfs_block_group *block_group)
 {
-	/* The meta_write_pointer is available only on the zoned setup. */
-	if (!btrfs_is_zoned(block_group->fs_info))
+	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
 		return false;
 
-	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
+	/* The meta_write_pointer is tracked for append only block groups only. */
+	if (!btrfs_zoned_bg_is_append_only(block_group))
 		return false;
 
 	return block_group->start + block_group->alloc_offset >
@@ -1204,6 +1204,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	rb_erase_cached(&block_group->cache_node,
 			&fs_info->block_group_cache_tree);
 	RB_CLEAR_NODE(&block_group->cache_node);
+	btrfs_zoned_account_meta_bg(block_group, -1);
 
 	/* Once for the block groups rbtree */
 	btrfs_put_block_group(block_group);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5ff630630490..8b49581eeffa 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2535,8 +2535,7 @@ static int write_meta_extent_buffer(struct btrfs_eb_write_context *ctx,
 	if (!lock_extent_buffer_for_io(eb, wbc))
 		return 0;
 
-	/* Implies write in zoned mode. */
-	if (ctx->zoned_bg) {
+	if (ctx->zoned_bg && btrfs_zoned_bg_is_append_only(ctx->zoned_bg)) {
 		/* Mark the last eb in the block group. */
 		btrfs_schedule_zone_finish_bg(ctx->zoned_bg, eb);
 		ctx->zoned_bg->meta_write_pointer += eb->len;
@@ -4170,13 +4169,14 @@ void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
 	/*
 	 * Instead of clearing the dirty flag off of the buffer, mark it as
 	 * EXTENT_BUFFER_ZONED_ZEROOUT. This allows us to preserve
-	 * write-ordering in zoned mode, without the need to later re-dirty
-	 * the extent_buffer.
+	 * write-ordering in append only block groups, without the need to
+	 * later re-dirty the extent_buffer.
 	 *
 	 * The actual zeroout of the buffer will happen later in
 	 * btree_csum_one_bio.
 	 */
-	if (btrfs_is_zoned(fs_info) && test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags)) {
+	if (test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags) &&
+	    btrfs_zoned_meta_is_append_only(fs_info, eb->start)) {
 		set_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags);
 		return;
 	}
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 2dd167c32d61..1597bd4512d6 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -919,6 +919,8 @@ struct btrfs_fs_info {
 	u64 max_zone_append_size;
 
 	struct mutex zoned_meta_io_lock;
+	atomic_t zoned_seq_meta_bgs;
+	atomic_t zoned_conv_meta_bgs;
 	spinlock_t treelog_bg_lock;
 	u64 treelog_bg;
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index c3bbe22c8850..f2d99fe50ebe 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2014,6 +2014,7 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 	}
 
 	if (!ret) {
+		btrfs_zoned_account_meta_bg(cache, 1);
 		cache->meta_write_pointer = cache->alloc_offset + cache->start;
 		if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &cache->runtime_flags)) {
 			spin_lock(&fs_info->zone_active_bgs_lock);
@@ -2295,6 +2296,9 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 		ctx->zoned_bg = block_group;
 	}
 
+	if (!btrfs_zoned_bg_is_append_only(block_group))
+		return 0;
+
 	if (block_group->meta_write_pointer == eb->start) {
 		struct btrfs_block_group **tgt;
 
@@ -2322,6 +2326,29 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 	return -EBUSY;
 }
 
+bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info, u64 logical)
+{
+	struct btrfs_block_group *bg;
+	bool ret;
+
+	if (!btrfs_is_zoned(fs_info))
+		return false;
+
+	if (!atomic_read(&fs_info->zoned_conv_meta_bgs))
+		return true;
+	if (!atomic_read(&fs_info->zoned_seq_meta_bgs))
+		return false;
+
+	bg = btrfs_lookup_block_group(fs_info, logical);
+	if (!bg)
+		return false;
+
+	ret = btrfs_zoned_bg_is_append_only(bg);
+	btrfs_put_block_group(bg);
+
+	return ret;
+}
+
 int btrfs_zoned_issue_zeroout(struct btrfs_device *device, u64 physical, u64 length)
 {
 	if (!btrfs_dev_is_sequential(device, physical))
@@ -2588,7 +2615,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	}
 
 	/* Check if we have unwritten allocated space */
-	if (is_metadata &&
+	if (is_metadata && btrfs_zoned_bg_is_append_only(block_group) &&
 	    block_group->start + block_group->alloc_offset > block_group->meta_write_pointer) {
 		spin_unlock(&block_group->lock);
 		return -EAGAIN;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 8e21a836f858..3a2ca8bd68e5 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -77,6 +77,7 @@ bool btrfs_use_zone_append(struct btrfs_bio *bbio);
 void btrfs_record_physical_zoned(struct btrfs_bio *bbio);
 int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 				   struct btrfs_eb_write_context *ctx);
+bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info, u64 logical);
 int btrfs_zoned_issue_zeroout(struct btrfs_device *device, u64 physical, u64 length);
 int btrfs_sync_zone_write_pointer(struct btrfs_device *tgt_dev, u64 logical,
 				  u64 physical_start, u64 physical_pos);
@@ -215,6 +216,12 @@ static inline int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+static inline bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info,
+						   u64 logical)
+{
+	return false;
+}
+
 static inline int btrfs_zoned_issue_zeroout(struct btrfs_device *device,
 					    u64 physical, u64 length)
 {
@@ -432,4 +439,31 @@ static inline bool btrfs_zoned_bg_is_full(const struct btrfs_block_group *bg)
 	return (bg->alloc_offset == bg->zone_capacity);
 }
 
+/*
+ * Data is always allocated append only, even on conventional zones. Metadata
+ * only has to be, if the block group has at least one sequential zone.
+ */
+static inline bool btrfs_zoned_bg_is_append_only(const struct btrfs_block_group *bg)
+{
+	if (!btrfs_is_zoned(bg->fs_info))
+		return false;
+	if (bg->flags & BTRFS_BLOCK_GROUP_DATA)
+		return true;
+
+	return test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &bg->runtime_flags);
+}
+
+static inline void btrfs_zoned_account_meta_bg(struct btrfs_block_group *bg, int delta)
+{
+	struct btrfs_fs_info *fs_info = bg->fs_info;
+
+	if (!btrfs_is_zoned(fs_info) || (bg->flags & BTRFS_BLOCK_GROUP_DATA))
+		return;
+
+	if (test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &bg->runtime_flags))
+		atomic_add(delta, &fs_info->zoned_seq_meta_bgs);
+	else
+		atomic_add(delta, &fs_info->zoned_conv_meta_bgs);
+}
+
 #endif
-- 
2.56.0

