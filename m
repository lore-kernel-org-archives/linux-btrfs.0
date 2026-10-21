Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590146;
	b=VuQDcS0Yl8Dn2fPaEOqjlHftmWP5Y/V0cadd8/UlGKpqutqWeiCS5kkgTpEVylHpCeU2
	 K8e05RlTfESXIrC8S9fX55dE4sPyT+SePZBSGkddqSX/hiDJFlP8rCuoHdlssKTDGnodz
	 exaQxri8yetduWBpat39RU3LlNv8D75oANbRSJURWfWGqASwnUB1he/nahGQRgFL61TKP
	 vZwUSbSHgHbgrs8wWtSfronuAwQUl70J9cAGIvW+X25hUhdpPAqcTP5Z0NeDvRKheOXwy
	 uYhYRWDUREZqp5bkeFCIzaRARHlhFprfNrIORsl+XlXGJ10ejMw+4EydIpt2M+nOigw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590146;
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
	bh=at2MkS8Dkdcw5n/4wkXK2qmyCzrz/0rPqi8ajIyEbcg=;
	b=x2f+VIWJ1VMXVmdSWyR6/oFjyidq1zSzjCqulTa1nRBbRUZ3LLb/9Kvo2utjoJhTLDvQ
	 BJIIWnGjo9F/WFGxPlaRHFmnrbZqIPaJFmOEC+ZJ7EPT0Z3zvdZrVm5fDQnfjaByrY8n/
	 ds0W4fleizuDzoD3a1ZFjY9zH6xAsVKg99O3Em5Dg+rsTrY4mM3W8UQqTVXfkhjZCmcLO
	 tRKdaoefoHiwOTsRvqcR4hV0Kpe5YbOt8paqQnVqaeHkrUC8KXDzBUjdMBgJCKRbcs3vj
	 Exz4ojALJ8F0fsfLWqbwCNY2IaaXQByES5Sc21hBZn5E7RwmZ/gzvoKLAAKMsE/ihSg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=LiliSoVl;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=RsZ58oCg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED18606A32D
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 13:42:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1ED18606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=LiliSoVl;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=RsZ58oCg
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792590146; x=1824126146;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=u5Ms6Xgfzhdy/2CcA0wZZ0oWa+p+QHP2JeDTzRewb4Q=;
  b=LiliSoVlm8f67Iao+bnWKL0ZkDOdWcQ9xvK84jfqYZy4h7qgMuFWabky
   t9j1gJX0bAzWBRc4dLtYmlyEKyat0BRxMUwxOWSnQ+OJswiz7ZBsTO0PY
   pqxEyatPAeVlm+txPkUWBahh3hprwzM+aZSxEqULRiB6mi1LRSfx9l78h
   soqO6oxrx+rU22/N7seWp2xqgPIE6NPWs6LpFFQTAw50g4cH2d69Wfl3Y
   +1AbJrlMrbPQwwfjCrK5CddZJL0YqGK1mLfMg/0BLvmLCRZXRwyMgf3ha
   dNL/fW4tl6P5CSYMt0Q3RHK0hF2qWQ6IME81SHyybxPka+zI/ubo9NTK+
   g==;
X-CSE-ConnectionGUID: kchV7uJVQfeP8i6T+EykJg==
X-CSE-MsgGUID: MX6I2ksMSFm04ljnIGu/Jw==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="159601526"
Received: from mail-eastusazon11012011.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.11])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 21:42:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eW4nGPhp7JQT6JyqRL5LhixuPMb6jQPfYxi178joXLW1eHAgP/4aD+406ImPiEXSAvBq/5XtviqV6JwOIwTn6kCqHoW11H/gMZqjXNhguz7+yBi5U4HvFRZIooEp3hpis8f4VSy/rMdJ+jxfplaHTTNZNZtay46cev9DDH62z1bxpXsxOln7IO3DtQGuJlFeZRkCPtcWcjpspfAKiTp4LZh59angjT3f5ZeQAO3eHMkbXci/s2gnx5qCQ1DujUusbDsFnavwSeY30dqC8VN/+mwVx9tYZoysZH9lvqxpvpeoD05nBqsEb0hqb4eXx/lD+vSKWaTItpMABF3/nYKmSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=at2MkS8Dkdcw5n/4wkXK2qmyCzrz/0rPqi8ajIyEbcg=;
 b=NvxSXaGYOCzF4WK6rTmctsoeYwGlI3HuUvQB03L1waodALyIuQEXu/B6TXNo9oVbDEDrcl/0HXXie1YJMLgGLJ1+sKmhPhKiDl8IpuvYXhdYVFFhPD4xAYF2FaOVyjJ8N3J+EaSZgKG5nCxqqsstOz2UrXypafjpDwK+ZgyQ+MRDz5P4PeeXd1QMFVbT332AsT0UVORc9gxn84dfoSOMD0dHezfcjGYY/Dcx1vTwROWBDzI3AMmErj4CPskpIdx8jwbickockCBBmRDPJWTHQTXMAfS9d8C/nHdTH3NaYbb5h99je37KRlP/8gPPZtomNsxiPW7fKPFt8LH8G+ipTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=at2MkS8Dkdcw5n/4wkXK2qmyCzrz/0rPqi8ajIyEbcg=;
 b=RsZ58oCgB7YzuLdt0YQtrkVwWs4cY3ppEEXwnl9uB6TZ3PAGfTJ7uTLmdDoac1Ifs5OoLhPzs1Uj+imo9faMSWlwOWxSLPIl9Ud8P+O+Sxyq319WysrDLiH3Ip4MINbquSKSVE/1SUSzxML4z0z/97vMb02mwmEbf25L01Vd4jA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BL4PR04MB993834.namprd04.prod.outlook.com (2603:10b6:207:304::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 13:42:22 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 13:42:22 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 23/25] btrfs: zoned: keep a zone free for relocation when allocating data chunks
Date: Wed, 21 Oct 2026 15:41:22 +0200
Message-ID: <20261021134124.2338902-24-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BL4PR04MB993834:EE_
X-MS-Office365-Filtering-Correlation-Id: 18e351ec-afc4-495a-0e05-08df2f792153
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|19092799006|10070799003|1800799024|376014|366016|22082099003|18002099003|10067099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 rt6MZiXk/WHpb9cMsUWHudoF3TLYZh4W1wf2ClDlnhKx+ugUK7cMig+OeY0IaPxuvjSSjjZUeN1noX9Ci4nFngDXoS1f5dr9qJrsw8e3yCMLw77FgN2CAG5WHsvo3JQ49uZHTLa38LRAn7yhopRF49iOqFpGoQgr+0llnQeq52k0RRy6YB0Snfh+RztO9ToPsD0rIVX/ctGa2MNpNPSHesvC2kSz/52iZUU6ry1H/UDUAmVKBQxbO05pkU3WcbSYSeSH+tm8GXnVT3OAJk1ltttLMyxgnO5U7jEm1TvRvAWB/h+1TDIFh/rRPApBB8Ox2wZqSW67N7tJzylb8BoEt4oXcttR7E+B3rtGNhKrO1CJcNmEd/uGrC+pQiwCQbAeU+wTvdLSHwWnH6ce/xqNl1bwQa4+odbVwxzq2a8tjiI17qjSY2AI152nhNsEcZYsjefQij39Jtle3zHbGbdyWp5zNJxZ5p2lh6IA7W/JMM8dM6xCz96ti2SmpN79VnZj+Juro8WcrAFBa1sRscqon3/QzlXKIxDhCtaiC/QYzSxxU8FFS2qZmVsY8bzzhtE8tfGqKcGVbA8cQeUHuXyxDor3dn6GY3sShfkbkfrM2L7Mg5ERSBUQOfc/sny89PSCPBJsLihRdKbMkQnhyresuYNyib881Yi2pgmJ97kXeQ4=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(10070799003)(1800799024)(376014)(366016)(22082099003)(18002099003)(10067099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?FpVTvA9p0wtmdHarjM7ud3ua5mvuyF3f26QP8c18Zzr7fm/POQ2kASpn8iun?=
 =?us-ascii?Q?MGazCZlHlzWsRcLLyREuRTwa6fLN4etWQieXIFEZ/sduSdj6/CDaLe/KSS6l?=
 =?us-ascii?Q?FcRn+5HesciAzRByoVl+t6jCrzH7CRSPc4RNVK/0ecUbKxQsIK4w8nNAVoJN?=
 =?us-ascii?Q?LOLDSzMDSYfrNiw1pd7W+Td82nyhcXUTm4fUns+XzExcvHEEr7h0XnIrbAA4?=
 =?us-ascii?Q?EfQ/954oVjnvzdCsXQgojK5egLZsKLBkfitDYUd8TwBFrK+hDEbGZd+jzw/K?=
 =?us-ascii?Q?COCHWIqLPhwu2MBRL4RyJy0s7CEf0mzGkP387ZaEsAIpq7+i6fskbButjOEz?=
 =?us-ascii?Q?dOhRZJEIfPIj5x8sCtgVL/rcFJMAB2HnyPJ/uPOuxTOnfplvxCyc/ZuuE5Ig?=
 =?us-ascii?Q?HDbOPVwebdR/y7Z2Fdw6g1mfTn/Bo3dGexhMlX651xroNA+cAsFtC5O7c/GG?=
 =?us-ascii?Q?ytuOg765s2zmU4m7sXSVeg+EaareDkd4HHWXF4avRSx8xYUMa/RkfXtBk3nU?=
 =?us-ascii?Q?f8dOB8Mxc89HthDpu5AqdfVjSYi6yuaERwHNdIEo4KnB13V6Ah0nRuPdSi5j?=
 =?us-ascii?Q?w0fIdCHHIeH3EQA9OwopcN5dHJN9IqHPhSobTIx7I9bSr5UtsTXVi0LHe+SB?=
 =?us-ascii?Q?YaUI86EIMNQLcEPDv4chEDYXKA7qO6078StNahj70ryADBQ7Ij5z6DSNOHFg?=
 =?us-ascii?Q?jnT0Kd3ATe8KXvGVyvWqIwqaZpOghH0OCARZF+OO5KRMkweX6R8GfgHrbpOj?=
 =?us-ascii?Q?Yjkr7o6436wrw8zmsI0qy9ysn800qm3Ku2gly7jnOACOKGl9Bsn1t39qKdXf?=
 =?us-ascii?Q?bs0jrqm2wYM7p3FSaCmn+cSBqiC3rOsMdjDqnSDMSQkgbaQvapVGN+mqn4Bb?=
 =?us-ascii?Q?QrOtsRkisxs+qNTTKnd/Ld5IWdxxEOVc66CWr2KSQxJtX0wtfaLp/N6LyCAR?=
 =?us-ascii?Q?7PvxhpUoaRu4K+YKUcAqGX+0+IunKuHj2j4AqNtQPSAM9L7uFgUya4reK/Iw?=
 =?us-ascii?Q?nTHAJ57bAKEvsBEwL5OidTXUwLla1529VpigdWBIQTXZnB0PK8KaYfpw77xY?=
 =?us-ascii?Q?qlE0OBjIpobgm8D2BRJ3rl5A6gqJTknHiWQGXEtnUbY+D61xNlr/4e8WiNqY?=
 =?us-ascii?Q?CNHoEjbPHEmTc7dqmbyPDIddGvWmfkLt/0Xj6eaN/dzJK4p7bXZ8ShzSRFe6?=
 =?us-ascii?Q?95VLxXQzwdJm0bRlro36pI1RC2Ely7cf1XlDrbsHMDPMJ99CMeVkAqWHgif0?=
 =?us-ascii?Q?odetCuIAR1ls6h9Va65MeZBngJEOlqoAvzimM1eR1/llybif8PX2vqNch/f1?=
 =?us-ascii?Q?QAGHoFie0R32VnwHBIn6mEiueGPhis+T74Ui5w9u6/NHwD6AtQp2sP7sZspp?=
 =?us-ascii?Q?Qa/yQQoli+75b0qP9Fe2zHe0YWbKhQMt5wl8hBuxsNNl7UxCPRkXm/NwMCHU?=
 =?us-ascii?Q?4TRBo+gvV0GSbA46JURSR+7L9Gt6Qf1ZBv8ijMF9HEOa2nZ4J+0XhsKPONpJ?=
 =?us-ascii?Q?PVcI7QNGeqfMpktdeAtOAzr2ZVlJw7gDh3YXV5jlTY4Qw0+bnPRO1ZoorwSd?=
 =?us-ascii?Q?qASSEhkGHAFmdV5o98sx8s8E1zCIUetXIVlNwztElWIg83T12AKRzsD6dCk6?=
 =?us-ascii?Q?anPm7AKfYSAMxe1Ih3pE5Ez068c+/eZFfAGIKUGV2IAL6CZXmFhRpklz3n82?=
 =?us-ascii?Q?lQCM/ukeP52a5G/4XklHeMUGp0IQ4lJi/QrM2/YKfYJ5tfoN6IvB8iaKKBpl?=
 =?us-ascii?Q?GT4OeCBnZh2NGvrTGwXrgMDg5fNSnSQLBTEMLch/sWqVks3BE+iAv/XsfkJv?=
X-MS-Exchange-AntiSpam-MessageData-1: D0djfvoBY7gemVCw1Q94tjUjiDZ1ouFaerQ=
X-Exchange-RoutingPolicyChecked:
	A1AEsvrBhuyxC6Hgmn1L2jIkgsgmdMeQi61pRNB9foM6ciy4FrhjBM71HwhDUElxYTXj0c2oVGQBIA9+u3GNgGGC7BhXrpM7hWAu35sFMsFZGLUUPOLvcM9aAgtZfjqv2SG2h/g2hIYotjzC1K89wmmCKOj56SUnA67SLQOq7JQ6D5meJcTnaYeFplJdcBZyTsE7QZbM9irTDu5zNeXjjj8QH+MKgvL0GelXaySEM/dxY2KYsq+oZbMXZD6NOYtNyl/Q9j5/4G4i35tkY/ibLFht/Vh4adW/kZTSqs7WX2mHCENsD5rphNhhcuqG9WrRGmKdxm381vurfMxvnJ81Cg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aSp8vpAmmEgJ/HIGzN76RJ1olO0Cd6frTCsWjvm5jfjmi9I4qq2wmC5mRKplUzZP/aRNEX0dGU1AOXp2P4LxI2YaVyGLTNKl93iCvPLKfqPZYe/C7s8gP0RElUzcpso34A2T1/gbRe3viBVcvB9EA/pqiueNOCSXob/7Zn7BMuf5awDkDui3QBpZXyAoBoYwHyd69mTU/w+4b+yo5WtHgZMDKDHPZbxnil9T7iN4CGVhDn4MOO1JM6yzqU9k5iged0eri4i9K67WJxNUDmeoLekZLDRZMof/5tOwBMwqzrrTZaBzqWRmxIlNYPJSvSqVedjr04Da7h5tKzYX8sGOYE+ZF1EDcFBwBhwrzK9oNTxmMhbN/UWxBEcE1LGVCFMWQ74ST2l+LLgSAE6ZfL4MKkBUzXzWHkaROcTaspousTOPBQGVMWkk5b9++XeWkQ+JRXE1TRs3OHF8I2UP0M3GV2zgp6WrGiq3zbUrh7rFQQqsdNR8kPmvkVk3Lj1QfegL1XBzGkvPDkPfv72IdkHwJmZWY5f79H9hvXzKliIgmXdDLzPbWRKtV5900mw2d6wksI4rUzW7r5wwUGK55cUxTOgs+ySGbryrG7bL+jYIhJO2LH1GS6nQORulWM5N/17z
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18e351ec-afc4-495a-0e05-08df2f792153
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:42:20.7526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZtmEQ8mmyZ0mdOLK7v8x6azUE+4t/uWjZRm6npNj7PJV1jJ7CAaMaQ81tHeHOA9S1VKvrziGkCjRe7seKi6mEU2QZuH88JmsS28eUF8Lf80=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR04MB993834

When allocating new data chunks, make sure there is one zone free as a
relocation target.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  7 ++++++-
 fs/btrfs/zoned.c       | 32 ++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h       |  7 +++++++
 3 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index b3749df5ac86..8d8f8726f4b8 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -4117,7 +4117,12 @@ int btrfs_chunk_alloc(struct btrfs_trans_handle *trans,
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
index 1394b7740b18..205f7ed207eb 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3651,3 +3651,35 @@ void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq)
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
index 74c9a4c70d26..ef5292ec771d 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -116,6 +116,7 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
 void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info);
 int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes);
 void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq);
+bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info, u64 flags);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 struct zone_info;
@@ -335,6 +336,12 @@ static inline int btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct s
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
2.56.0

