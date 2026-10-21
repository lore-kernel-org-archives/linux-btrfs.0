Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590259;
	b=HX2z5g74quEUsdBEi6T9LP1crbrmR65FN0knVlWgBMAfdxLkXZgaeH/yzaMMhQD6xUHk
	 iK8IPkJrUAHQLZmMo9b6k7o0zsfwzRnfA/AYD+tG15NOtgZzjjWoxsOYb52HiQIt/3zi4
	 e3mRnllnGFuWu47AXWNzY2pQYpK07EOLTmloKT1sUvFRpbymxlO2n0zyWewYFnBURHbu1
	 sIrbjgu2Ryw33pNMpU8TS+qv5LKGRrv7cga+iwi1XGtHQkC1RTISCFTo1NUxdIzWCSiYC
	 4wsgaxpu/0NRd4B7zWAN3J1IDJI0oGZGMTVxPxUngCqV+gGFJhgaUuAG8VIhbi8C2WQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590259;
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
	bh=Vn1gibb6KdUM+EbRgM3OU+h1hy9JwtoQL0bh14c3h38=;
	b=Twf4itt+2Lxifc5XgRwXqEcyqswphqf4OcBbB5pycuvOlpGtj/y4LUCPKjrmUPILoM2p
	 X3hHtIC3cqN131BPONuF6NLZMRaI88AmOKMyy/MgppfqVA0zKyaEkCPVuGPvgmG6DttzQ
	 YagOb78FXnsJshOyiAvtAPzQVFg4tgbNtC1sMtsnYprA+TjTffgoSidCfMv3MsgbRz7gN
	 S69Bl/gaCX93+VhQkALiqNbgUyp+ZFU9HZDSipJh6aVFUSrZcOcd5DrDtgZqS6KefvoHs
	 h0/+22ZG4YYLSlcrPy+nTPrfYvcA87CWXpv4PXWjEQVDiai+O9sdxhfsuA6Fu/UgZjw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Jgq++EKy;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="b4slW/G1";
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C79606A319
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 13:44:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24C79606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Jgq++EKy;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=b4slW/G1
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792590258; x=1824126258;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=2p3Nk+i6Wkq51DsZnKzFYHDv8+kifcJwztimGAUTINo=;
  b=Jgq++EKy7lSNJKT+i7KmWRTnqGl9N7UHX3439NnVrk5BePOwkZTPipWx
   GmGCxraTdyfyoEHfHjlp6w4BF6ZdxapXWsUjYe2ToHPUSCwcXZNoSIXdL
   BVkPupE+d6qjgzwIStU/W0uaHZE83lkSXUPp5z/YeYYQxROn8zkOvze+U
   PZVKhivLdPOhZME6qo4wfwehiKuKFH0ICwepqUBS5wowkm951kTCh8gzc
   kgXRyOsydEK/s/jjygTKu6DvGh9m2Lh7ubRCBbQ56BuUPzWYEKOp5o6hG
   KR4AH9aJyTs+PBT1hnarG5OVDA4tzpyJhrrQS4Lu0xehWlg3VYM1chHde
   g==;
X-CSE-ConnectionGUID: CdLiyT+PSh+0ordEfeiDIA==
X-CSE-MsgGUID: 8Za+gycvQkejg6zWu7KN4w==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="154422445"
Received: from mail-northcentralusazon11010054.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.54])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 21:44:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V9T03fVo5rP3RvONzSP6gBJRtLCp0xBLU32DfafL3CPr9zG769Y6RVEtITY9rhBSe08YXaOyQvyj+BK6hPHvSeoHYDbsTXdPwiYe+So3cepkW+XImdX2hEVOhM07RkuXeEqeztQTGdR+wa9yS9uo8M0t9/lF2clbqmZ9VyHvorZXjpOsHYmMCeKbyCty8mbalsQrE+SJQVukmuWnIqn2D6PfrFRUTZBzFCY6o1kGtqUna3Tr8001d4Nj0GSCi9UWpif4FMIWEDAPPAQttHySt6K9BiEGb5WCtzqCKu7CN2t0qR4N0myvBJMPR6VI4Q66u0M12KGZy4d7JLaZFcczBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vn1gibb6KdUM+EbRgM3OU+h1hy9JwtoQL0bh14c3h38=;
 b=GDc0V+wOMdgVs8VEP5AbuD0goBlnlbdMhJtO0Bn48GHxCOvjrpaubS0gLsmy3aVKV0NgdnDqZEZPUaBbFHVnDy7QeMeZbWEfuO+30qLUm6VoeBo08o6FxyxfwRILl+ZuYu67RvFHrjeZ+OaGzbPWGfRJ13LknAkDxm+jW/JDQyzLZgbWAWfsFmj7Q98AjA3grQdeXveXSlNSwLB5DucEXBW+ghrWQqieQbxYspImuIFiZAno7JrulnJpkYWmreUsVvOdspHzC1n4SROnE4f7dbcTkcg6NROxh3A5DomuQpuVdZF/T2MIWKkMxNfmcEfHJpXhPsUgmXNN+2qi2qgUFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vn1gibb6KdUM+EbRgM3OU+h1hy9JwtoQL0bh14c3h38=;
 b=b4slW/G14qW/LCuMQvPbncBtCU/FskjM04jwdQVRFjrF6lgfPLJewhSPPjDoZt1meeae3yYNfc24rTZOqj+fPouVkMf2T7zVHjk+IrV4+0FnLO0oa9vd+JmOqwLozUMYpyIme9UoY9TbwfAHBvfz7UrT4HUyfEgxx4XQjJbTJ5I=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LVXPR04MB10002.namprd04.prod.outlook.com (2603:10b6:408:37f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 13:42:17 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 13:42:16 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 15/25] btrfs: zoned: don't recheck the reclaim threshold of full zoned block-groups
Date: Wed, 21 Oct 2026 15:41:14 +0200
Message-ID: <20261021134124.2338902-16-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LVXPR04MB10002:EE_
X-MS-Office365-Filtering-Correlation-Id: b846a03f-cd8a-4110-845f-08df2f7919bc
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|56012099006|11063799006|5023799004|261009223027099003|18002099003|10067099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 X0KaS/fe6z5LMUdcQLAgclLUijONWZO/lRJy9wDqLHMXu5xTI+NvpL7/kPRAWPDvwm7hq5OdlXnGgXvIiT3Kf2MUrb0ijuDR4gXqd1bwAciILaNTDC0WvYev2KWKxvr7FKeHTqT5u3NBp9bmve9EBAhcW1WsFHK3g6qNr3xxaCCrEbwnv0iICNsrVw2MUaK2w01nzcN/xnm32IxplTaybAG8b3eJMCdfQ+Q+qp3IObkY0KwEfdQ+Avxmhx/Y54o4/1pUNUBsLEmVlr51M/RbGDwHCv5ddhbvJDkqZ7rY8mF1O2vT412Cp1o7DSEdImKj08JdeimRzJpnxLVteXdTS0s+9c5dQfdc9PxMR438HfwcsxgIh3t6QXrKYmxfHacWgM+BkXmixQTozsr+XSA33hCIRuOsiovDEdO4abA9ZrtbPaOkhWJP2MOhp9vJ2yZVIKp79If1eOT+E9Jjo0IBcWStIWuxUGXngP4VTPnAnXEnrMJh7+Zl5czW2kXT/yJjTAbvG5uEvBrHKoUF5S2i4yDLcBWUfWLfxiHv5Bxvw06iwXUAYJN47vOaj0oeXtxl+y01o9C9EPImlbpQaSyEPB+nrRed4QGX/XW38zlcz6qXc5nr11Z4Lp97CTA+dEWmEuovg6nFWBNpQRtqBkDttkWGvNdm3VBb7VyCbgp8YoM=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(56012099006)(11063799006)(5023799004)(261009223027099003)(18002099003)(10067099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?TfxWjHJllAtM3gu+eKra9ilJoPr5TZFDw4NAjov4Zp2l8ddFNkZeOiGDvHcf?=
 =?us-ascii?Q?vJUE83FcDnbMHlKthokJ9Sg0ED1CIdXsoX6mlpWfQLBq0Z6dAILYpSCb+ti+?=
 =?us-ascii?Q?YNR/JZjxX6AJbKK7gz67v8Bf+68qFtjf/gZQEyk1UwiX4zJlcWvYB+69vRXV?=
 =?us-ascii?Q?bxrxQkCzOrmEZtokrr8aCsfQ4MIipgj/f2URzz61taluNujxMEs4tJYhk1PS?=
 =?us-ascii?Q?ZbV3SQbB4nSxNArvXMS5uwZi06HhayIsZZmJPJfDmuvy8NnYdKdgPDo7QYbG?=
 =?us-ascii?Q?vpVDJ3wX1kGSsygFVynHJCm+p5OWQ31E6Km6eAXzSl3Cyx/4C4rpw6nleVql?=
 =?us-ascii?Q?T+dlYHtYfz8ArTDoSm2YWmxZzhx2VfDFNFV9rRXhbdyXOpZL0ahub0Biz47/?=
 =?us-ascii?Q?bHYLn0vG7pgkFSFF3su1pwFH+FiuD5waCFo42DLcyCCm1mfDa7a6zx9VZSbI?=
 =?us-ascii?Q?EY2034iBSTANEDEE4+JQgk0HxCMb0b78jpDKuYJzr34/vyDdmDEphY+J/0HY?=
 =?us-ascii?Q?Qk7WNakukHARM/J+OX7zEs8D7mFjI3zvHjeedByF2KQxO+6aQDpDnhmP0i1v?=
 =?us-ascii?Q?drX49/Fk2UwNp1TBOtRJn69eUnpd5dfMMkWZVMDwJh8leZx/83KsRIhs6Alz?=
 =?us-ascii?Q?asTGDCLy4stt2gtDjUmqQmUgPmIr36aAknFnLZ58JfpkwHAKd74K+WdoEmf+?=
 =?us-ascii?Q?3H0zomq6tj+SLRxKZxSvlR76P25WEfeXARuuQcx83ERsgKcULol65wTha+qY?=
 =?us-ascii?Q?FCHO5rPuzkDaNDlM2c8SODIkPCnrP8PXrZu6Ehr41sy/Xux03hMxXX8e99my?=
 =?us-ascii?Q?98aLmQwtygHpmVXc5HPy+f0ChvSJ/5MQaUa+uF6/5qp/WiT2yn1DQURdwZM0?=
 =?us-ascii?Q?O1igfWONdn0m5qy/ht2/do5t14f7yxXs+ct1V9rnMI0MVxvamOVVnsDeGowo?=
 =?us-ascii?Q?E/Zp5c+j5BsGW3+ngIvG4scJCM3bvTdWbIxtuWJEF1LX8/zkwkoU7Qui9hJq?=
 =?us-ascii?Q?4ud64KtSQ6vHWr0ENIod52h0ih02rWjGL+M8O232EU6ye6QP5pMWA6Vu57MJ?=
 =?us-ascii?Q?FuuNjhptNvURCVEDWK5JjSDfmtfo57RcFesGBEa+QS43Vk8FUS292N2aK286?=
 =?us-ascii?Q?4WGhp7kyHYAwKNrrFHSjXa1lClfzj+2Q+pj2+Ep5Dc9wt+3/YPfZvdUPsBRg?=
 =?us-ascii?Q?Wlw616C16QSXOTl3hV3PsHrwgjKLQKwjHURE9//CIvQuSLROrA3OoK5BtRiv?=
 =?us-ascii?Q?JPf+WNEZfJ/LGjZ65kFNuHTNHt3Z4HQ+8Hm0IbHB5HptlSpGgW7CUVa7x/bE?=
 =?us-ascii?Q?+++HhniScQPdpH3MxWD31RTaMRWM45VaYllcA4ZdPBDDAZlYoAp9w5IEqLfG?=
 =?us-ascii?Q?RNa60D+Ts/Wvjm+8gTL6KFvCCQCf2Q9S/qH5/fUe8cpQ/iMIV84FjKkWc6v1?=
 =?us-ascii?Q?lt7Jp1GHOwuqXVT90Rw9bsPaf4/AEYf8mY8zwUPUkhaTonHQP+rbr+mZuQfU?=
 =?us-ascii?Q?ygW6n+67NWFyr6Yei+s5/TZuUFTbGutG9x7Y6OOLAzi/nP+27qITa/WBNoK0?=
 =?us-ascii?Q?73gpnPt10Pd4HGUEt9dv3AMwoE/ZHjaQizjXCmDVlL7OJCc9Vd+HVq2zLXUM?=
 =?us-ascii?Q?UxcpP0fjkDaFnn5Epr0izbxHShauqJI8COymbLctUfWyhGRxpL+JjnDR2YZi?=
 =?us-ascii?Q?AQBRejGfVraSgcnYdzDarxEO04eStSgEBZgAg8o2fVftP1gvEZxZB7iTkMJa?=
 =?us-ascii?Q?Qna0IojsukNuixAE6JG+rEGZ6skrCvlscElOyheLUBx0WBdbh3vf71wDM076?=
X-MS-Exchange-AntiSpam-MessageData-1: jad1fxUNGtdlQH9IDH7Q1s9nutP25iWC4Hg=
X-Exchange-RoutingPolicyChecked:
	tT/oiQ0TKnB1u2QerZoJC8sCSldWhhdXp4aYH7g7Cwk2JaxvL1TCu3RsFhAwXtjdYbAUnw/LJKt6a7Cbux7BUMRgjsHKkwB5JMKLLTfxF9yUeOGMv5pRZOskZUttT2CNqqDKTzpNBiE/8NXXAJoY0G6MjbwDnCmAFb//ndY46z+00HJf1YG70WUF1HWySPIl1Kk0hvyDnyd//IcFDzHYmqe4AYrcXJeYPLv3ovFardVFHHoB3hM2bXYgLhcEvySAcxLGY41PzbeBtXrPk80mrMyLZlcDjDTkFO2jOWc7shgTbXTNRbqgfrR+Dl5fNXohkboeVISLctFFQQN2FpeI8A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SzTDaYSZy3LqA7Q++jQdnhJVRax5/sCjHtqc1QyY+UX+r73DR2gJ7oExH1yT58Vy/gxJil6/0GtdBH572OCUBT8VXax+oA95CDiWTG5n45Ybz+lonVfK6IvLQnTMKTJTTLhH2l9W/ypUuhY1+aSBQKhLrvMIXah2M4+JF1qK4vvhNz6SfHtoXNLDJD1Z+uZPtw9qU39BJq8e8t5DucG8e4NmNBnf/jC/r4RSSLCRLvCOq3ntyMjY5dUCfCqRmGf2lx8f2KwoFWWRdrOC0tdsve2LEGepZ2tQznRS7F33AxCxlKObhvchlUVNR/RsQHD3PPEZSP7Gpi6MIoT/2on5xwV3EDMEUeX8yqqFvl1odlTklkefYj+O0quwf7X7iUkX5mgHtbcqIDPWH/2V/1XOm10ddvnb1kwfcYMgXdfJBxUReCNoCbmEopPtYAiseIMU3kyDVyerANxt7gzbaQ3HBkPBK8N44E+fHLyGSGXLKSEfb8AbK3xSsM2+p534mt2ITfqi4H9MxaJRhEMjn6+pGJ71uAg/D/hfdWB8ORRLbCSoAb/qHEkfsYFOBj5lFxyiGTNvRCtFpeoEtoXOdYeYxEGuq0r92Whdo3RrCN5Sn37paSipFtSmEClFZocXNK39
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b846a03f-cd8a-4110-845f-08df2f7919bc
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:42:08.1566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EyNniKo5nvnICaj0LTsSZ3y2n8Kud6D9ZHTEDlawggW1ZavHuCYuX1Xyx3nqnmw3xnOEhr5pRDrM24RZr4wMwnlY3MInnhJ+4OqBiXDzAIg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVXPR04MB10002

On a zoned filesystem, nothing can be allocated from a full append only
block group anymore, so its usage can only go down. There is no need to
re-check if such a block group still qualifies for being reclaimed, once
it is on the list it needs to be reclaimed.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index e38c728a503b..396783c49a88 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2004,8 +2004,13 @@ static int btrfs_reclaim_block_group(struct btrfs_block_group *bg, int *reclaime
 	 * being freed, pass in a fake giant value to skip that extra
 	 * check, which is more meaningful when adding to the list in
 	 * the first place.
+	 *
+	 * On zoned, the usage of a full append only block group can only go
+	 * down, so it still qualifies.
 	 */
-	if (!should_reclaim_block_group(bg, bg->length)) {
+	if (!(btrfs_zoned_bg_is_append_only(bg) &&
+	      btrfs_zoned_bg_is_full(bg)) &&
+	    !should_reclaim_block_group(bg, bg->length)) {
 		spin_unlock(&bg->lock);
 		spin_unlock(&space_info->lock);
 		up_write(&space_info->groups_sem);
-- 
2.56.0

