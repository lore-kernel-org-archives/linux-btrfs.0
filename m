Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031011;
	b=SpiH+KNXtwZ9ITHIyUi2Ib9sdMu7XGf+Z4CqiIz3o/q2cgBylEIo2UuqQwU3/JVv6/Py
	 9AIl2Eb6y5zHnQjCF1SYsRxz3VGMLCHUqeJSV/8YVutNxVs7UfRSRl5LcnoSz1LAfUDjc
	 FVAjtX+RcxDn2/TtqzeUfKZpysJhHFcRTugJssG4Z3YmTS8ksStlZmP6xdgGvO/vIB41o
	 xIkB5SvGVsQ/jeNCczLEOsms4hGKqGwPnm4xjZM+9Bc/sYFH3bkNddnZemcr8HsMPHP47
	 7QRRubcc5BXwsiyhOO5SBOxQRqD+eaP4lfNtsCCty61ScP4cq9tMEYZWalYAFsPxaeQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031011;
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
	bh=Jf+3LQOmbP74rPE+GnnB/eQJA91u4VCRZEbGga3Y6z4=;
	b=FzyHz8HvOLju3lzYNxX1JgbQsgbq9N6YtpAshkRc7AKU2hW+7UK1QvKex5ij5+Fy9C1O
	 NQD5TccJFYK4OwCoo6K0MyhF15sUm7kDkjnD9jj6B3+zX1eQbADAz08taHEJrrptEuNQB
	 12QHA5TWz8io8swVQz5FzOTxJhxdc3LSVFONSve3ksqZBlGJ378lnXGaGXTokg6Qt9x5W
	 oRow6fMa1/gewVIVDcI9U0Qt6QS9StGuHbF0MlYEkixJnm2odXHz/axGMdpkFcgWnT067
	 zfrsN15E9LVCEQtqmXnI9KTfSD/n1w2k4pUglbSMmPeVne3kKoNI74G4wFKM9aTufUQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=nMeVN0rL;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=DzrfzEUl;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A5860A260B
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:10:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6A5860A260B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=nMeVN0rL;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=DzrfzEUl
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793031010; x=1824567010;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=55Ok2UQ8BlolvnSa6WN5yMhIK1/yARGhphfIoBYp60g=;
  b=nMeVN0rL68QNK79l4P35RPPKhOG83n2P/ueEfNs6DRhX+Xe0dYcDiwDq
   dRsP54yGyafVbCyanYENNLTtMmVNFb3L6iABPTcr5Zc9Q2xdIlTdSORqq
   BhwvfZ/iYLls+Og9WlkBwdsM+MF82eyV2d4HuKZQG4gK5/crH4g+H97ZO
   mR/eJnuSkRreGlCDqyq487VEdCKoaMETiPaZs4htq3t0TsPIDm6ASVkfy
   KNxgChku5qeo0hi+vUDD8dKQJcLyvA5K5eXNpUvUq/Y3kgEk71pZIeQdu
   YyJnM/3ymU5ueVoFj0ApRlWoOmBaRMSFkYX2kfEO4ALp9pfVkq3c0nw03
   g==;
X-CSE-ConnectionGUID: 1EUFALS7TnqcRFeizwLydw==
X-CSE-MsgGUID: H7DemqRuTuaVIUXlzArQwg==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="159033913"
Received: from mail-eastusazon11012045.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.45])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:10:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uE8PwlpJ4RIei/TIELvsb5zBEZI1CsCxet8ihWHKXtfI11A+mc2Dv7oGtrq657HfHA4MOE6VRYZg8sWvIREkpBOo3/lBJpJppsdawA61FCrz2TFcm/48uGMMtU6D8W5TPO1ofvy2xhGcUunvxJkjs2zWiLcXItmOZP4sFLh+6zbD8p1DSTgyEBML07gG8ki9tWF2vvNv0KbIi3xpS2XoSPMY+63VmbXxmhY62R4gdvAw6GZ002x3NKmeQhldwN2MNyd4cjDPs1jnJtu45s4ln1HkAE0xaa+bV926hFXT2TVkrVABQ8u+wODAqglMYXAQ4kpLZicn7ELpGn2BimWc9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jf+3LQOmbP74rPE+GnnB/eQJA91u4VCRZEbGga3Y6z4=;
 b=a42xZJdkOX77WOT4MwqOlLu0QOiFTyfHK6HVleGF9pfjra6DMB7e3xhXuTNEcjpusE1v+AHltR7gy60R/FlTrGTPC66/SIrvW8j7WYzObXZ+gQK0yo2KqZBkOasEWIuLlvIxKO8NSTSCiqJSrkKdE3tMnwog8Yd+MIFhfCnqp/FJgmuF/wtiNpy5jezKvOsuLfAk0Gn/PxPaY8CN5WNu2M+hcvd2rXY1oq2B2rKYFdmLgN2d0Z6m0uuRTKFZnnxylRvRYOjkI8fvmcMd/HQr2N3YssA7oRhQD6+i/rpj0M3dfDMXodf0YLC/s/vvxuUIgdJKRt6YK8wxvKbRvP1i8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jf+3LQOmbP74rPE+GnnB/eQJA91u4VCRZEbGga3Y6z4=;
 b=DzrfzEUlTsCTiPu/Fw/HnuExvPNUoevCebufgOxJmo3rvCd/mfsXZLNd7aPm5zY/ArCFj5bJBD8ih2D3tjpAFrVsPRIXQKmMN/r+qzbL1kLdVlRnUa3IyJz7X+fhgXZqy6jVmFDspbnO3s91po0F8//RgAlDvle2PqqUFokNa0E=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV3PR04MB9220.namprd04.prod.outlook.com (2603:10b6:408:26e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:09:55 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:09:55 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 19/25] btrfs: zoned: promote reset data block groups to the relocation target
Date: Mon, 26 Oct 2026 17:09:07 +0100
Message-ID: <20261026160913.207909-20-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 049e6d7c-c80e-418a-e29c-08df337b9300
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|366016|23010399003|376014|1800799024|261026140227099003|11063799006|56012099006|261021123027099003|261021121427099003|261022105027099003|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	hNAY10nRBagvUKRQP5RTMVWl8I8yFZ1BWGXLcjQLrilo/5SgxX/wxb33Ou1M0f5kpZ7sMay+4ZBCagbhA9CkG+6s3u2GTwjP9NgYTuGcLOK2zlZ9b8WzGce3noyD0tk/+LoWgefpsZR4r0R5FkO3l2cS86iqYMqF21YAwY5B7QrXPQXRtG1K/t+vcdj7ps7aMeBSJ1O2pjIhUk8CsKEcL2jQ4+ZFjAV90bXOq7hkFGxLcyV2NNAzSb/+Pz1GQUB4ofHdBzbNbtEsyYrm9OBh63ELzMKP0bmimjOGmRVXPrFiqFybT9t7jfi1UkoPq5FccSG7TVpzx6dYe8dubMPdPaQHPYJKijEfEepIcyjgzxt5BF7b08uxXBhrIlDGnnPAv5aOuAVVDt6DdRbv2r7KGV9HI5gDAoO2gEOP7yYce5l3zCPd22SVP3nahL1Sd1VVRrap8BDrKjsLiGdPBbAcNeFHltD7bmWVquWR481ik9FS5HkBqjyM+c8j/HwtM9A+/9fCnKTmFncnN6cVsv8Rj04AIDWCm75kQzf8FX61+QuDnXQ8PMp8KcjtxsFKY245uout95AJek78miHBjoxD4JuKwyxyNys0m+DXcvJ0EQ5mYSbj7j3JYWo7kF1fUmo5H+WADL2ZxxilWWNCG2ZX7yrWfWVuzu46FxRXsytu24k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(366016)(23010399003)(376014)(1800799024)(261026140227099003)(11063799006)(56012099006)(261021123027099003)(261021121427099003)(261022105027099003)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?glzy5F+Dq6I1L8ics+AbksZL+6hdbDP4kyoIJZ8Dq2cRhzww9cfbt2zY0FcZ?=
 =?us-ascii?Q?GGJtv2eS4tcxx3JlHHSFRl+Dsk/ai7XAHqVHZM/Faq6S02lIxBlOb/dmNand?=
 =?us-ascii?Q?OgxOeI4/pbRo9g5qvuZD9YWa7+tZ8L3vT5uHJTOYQDZ3e2Ioh8H0PI1WinRR?=
 =?us-ascii?Q?MT7/1KJBCF58uw6SzqDWudZ3kLhI82a2Yog4LxlvsNSUX+R0jNmjJBMcR0s9?=
 =?us-ascii?Q?chRBXIsvUalWSYOqQA9YmAjON2TL6yQNA7sayTp9UED5xh744VloZOrmxoab?=
 =?us-ascii?Q?f0pObLYTuZOCx+G8lcxiLw93INrtHviBCzUSqDv1N/Ml+NdwBKgd4NtidsFn?=
 =?us-ascii?Q?rWqb4pq1Grq+CJu7z4owtxcI0YcysqyONzvEFO3g70CsPBe1exWvgTBa14Vh?=
 =?us-ascii?Q?2gNJ0t3ke5BRXZ8nJxk1vuDVJetUHU3+IQDmP3KA5qNIAQsNx/dK1fKC9AJS?=
 =?us-ascii?Q?nKISAT2Mif/eKX1vuR4+DqHQVc+QB+PHxRN1Hw/ID/HM/+ZYNGpbBdQ1nWf6?=
 =?us-ascii?Q?Q2DAN/3LdjGs/F6LN67s+mYYU3wKoAUcjz3OuJFkqccK4/J0OX7+J2wZMpoA?=
 =?us-ascii?Q?4pd1Z1bUs22WDUTs0eh5DM2qNLzVJouya7Tn4FZ4/MAaij4Ll2keDoPDQuJL?=
 =?us-ascii?Q?K94aTNK55uMeRBcHs9ltGEW60YMldN5lCTagQs810FF0mpwZhWXk74PGxaUI?=
 =?us-ascii?Q?IbBpLvXeBvrLbyVMyT8KL6BxB5fQe4ax5O0NeYTD/0bl7mILTWiXV7xW9/Pk?=
 =?us-ascii?Q?n8rDEvVa0QOMxdMqzroaIubIXfcoGKPgczSDgg7Cz8UcLN2UMZt0h1nN2Mms?=
 =?us-ascii?Q?q5nOnZVKJPnQn+hQfGveKWzCrucH9P285JLK42YyAwAaNcxSmCyt+8NadZbN?=
 =?us-ascii?Q?WbxLP3TwKz1rIyacbaH7TdKUcDi+eV6gdbP33ARqK1M3C2Ssoibmp3jzz9xA?=
 =?us-ascii?Q?0e/CYiUfpxkDI3m7Yq1cxtw/uKehbPiKgjwxv1n4F/T2pYNZmAmfF2PaVHy3?=
 =?us-ascii?Q?p6GotjbFGwzXjTKFgfcfd6Ui40kLVYJXg6bdDZrD4lUfhivwwcCQwoqgmbRH?=
 =?us-ascii?Q?hhcMHMUFgKxs87OX7vabMhO/x5/bC7PgLfaZOpGqOhJoIScFF4ms1SmI9N+t?=
 =?us-ascii?Q?9/tl9ZcAXBHNjHKXDOV+xkpIN+JqXiXLN7gKPr19w9+cWBNU1A0LWOnNvyF0?=
 =?us-ascii?Q?rkN8lDOxJmOlFPBGYUL2oGh5rFJ7S5MdhHhiJeKfIdT9SltEjUCMSt2K5YQr?=
 =?us-ascii?Q?0r6JWd0kwIYyRkIvsiw3MlaVvl97YKehD8eu4GXG2EsYsX0JncygvXJqeXCg?=
 =?us-ascii?Q?y34HBLBQtWmkv5CCR7os4HGMrt25+7jej37a/7q8V1su4jKD3MAi9vIKBz7v?=
 =?us-ascii?Q?UHqClUiYpkX7ChtowCWCyZAbMvx9tx+5VBoiB1SzMRJdfbV8iXBIgzwP7OqG?=
 =?us-ascii?Q?XvXKXkGpheBrSzqzYecz0BlE39mlndaImtw5rHjqXRtcfBzWnUk9eKNVivmm?=
 =?us-ascii?Q?TElSnJjJEEik+/7iQ/HfTKeiQQa2lMjYpcXQTv7vS5wep43rwkCWZRQKds7P?=
 =?us-ascii?Q?dFgrAloPagnU07gGwWLCuHrBrIMCLtlzOCN7PbjnRMJ7/Ui8w2P+Kks3rgUO?=
 =?us-ascii?Q?VENPSnxntnhUYVio+cCFSQDYXe2kqz+gXxHTnT7RB9hncWg9aQrZ7aGMyTWx?=
 =?us-ascii?Q?lFTd8a6B4X0kYlhb9SSOhJDTJ9oru36AnzeZfyR61JgomFhPbQ02CSmndXt5?=
 =?us-ascii?Q?UUIOCYvQNDUQLgxjgzffXcS8dyc3xFFQs01O+gZuAJRpxlxsi22KnenrqEJk?=
X-MS-Exchange-AntiSpam-MessageData-1: SwSYU4ZH0h6QFg==
X-Exchange-RoutingPolicyChecked:
	4yTp1ZgkNWvJD0GQTbLEPLi9JMEVbQny8DyfmC8wz60A+P4h/t8Bi+AowxYpPlIfutauPygeT5ELXv2FNIx0xRGK+E7u5LWLBfcd6wGst4fkk1Ipckd4N2lu4qbAOcWXOw5WucWOPc8sfluLGFcocm+vYiIbCOJEvdsQ/oFNy+L8NvAMOjcrgPigOvWIsitVwPtGzAtLOdZo6lP1fSkGnG9PlVrH+QzJm3vjFAaq2Hdj0eotA5Qr07IJ4a6vR59O71t5Os4qVBygbb7wdpiteJAtoxNOQDoEDZlCjBfi9pWAlXMLhomP553HRYUHnk8dOa8rWBUrXEwHSTawWN78FQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZDsHHDHNBkNdb5H1X/PwAxMsaDMLdAQRhYpENnKUZINBKxOEfyCEBxooMiPlmwYlj7SGQsbAV+mUpzmV/lFPTZJ/QgTTnt6mXFn84BPRIbXObaKhDA45VL1S34PL0f+AUwjs8aIowbWXomo99s1tNCxLcOvC7MYYN6BwzTBoUF7V0cnB8SNCKd718G00WmZxg25g9QImlhaiS1NMeSY/NUWg0tJGp+tj2CvqmeeXXGqzkdmu9v3j8a/79VBSlkYO9B4EQQtzPaBWTfcUP/8Z17pftsf6ngl49UEsXg0LFU1JezQOyCWDsXYO6VV7ue95il8f2nilWVVmQVtLWDpaHOjSbvtoWmvgZSsyKzEI0MdNZdkVEqOOYD3NfujjRThmfsaH4H/6kvH0WqSq3tUDKcJVs/KZalDF3/w6C1sWLD/XFQRVjhbMZsJvyMDLUjvA2j1qz/zjvZASxh7IdcTYs5SWHtnLF2p3GS5UYISWemDpSEducfdjr/gqSf66835MmNwBLoYar1v+n34FU6bUS4HQOsrbSaiGDf4qhVl9CVLFWGSqEG1rTv/Efd/0i2/UMyHvkuXH0v0cHQAY53Wn7tt4Zakavk16Pl/z+XGVm+URfK4ZzLs5w4Rev0KOpeno
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 049e6d7c-c80e-418a-e29c-08df337b9300
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:09:55.2564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MwOyDTJXnAJduHJ2ILFRU6ASjAaE4LkU3IczHDmwh5bkPZMNlZ2FABYENI/zAcWFOmq5IifGnDzDrKK3crcIE30eXFI0cebZFSthdjN6r/Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9220

When btrfs_reset_unused_block_groups() resets a data block group in place
and there is currently no data relocation block group, use the reset
block group as the new data relocation block group, instead of returning
its space to the data space_info.

Returning the space first would let a waiting data write take it, only
to have the block group moved into the data relocation sub space_info
afterwards.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index d275568cfb35..181b8caad2fc 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2974,7 +2974,8 @@ static bool btrfs_set_data_reloc_bg(struct btrfs_fs_info *fs_info,
 	return true;
 }
 
-static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
+static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, bool promote,
+				   u64 *reclaimed)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
 	struct btrfs_space_info *space_info = bg->space_info;
@@ -3034,9 +3035,26 @@ static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
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
+		spin_lock(&space_info->lock);
+		btrfs_return_free_space(space_info, *reclaimed);
+		spin_unlock(&space_info->lock);
+	}
+
 	return 0;
 }
 
@@ -3414,7 +3432,7 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		list_del_init(&bg->bg_list);
 		spin_unlock(&fs_info->unused_bgs_lock);
 
-		ret = zoned_reset_bg_in_place(bg, &reclaimed);
+		ret = zoned_reset_bg_in_place(bg, !fs_info->data_reloc_bg, &reclaimed);
 		if (ret || !reclaimed)
 			goto requeue;
 
-- 
2.56.0

