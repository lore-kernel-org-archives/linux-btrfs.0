Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794941988;
	b=jlZsi2ioPy8tgcMkLpTUcV/EpwbwrqjFaXW7rVh8kaMMLM2//eTkqJJIobKjlIVm4M4Z
	 pPC5Mq26MgeE2iz3dbvozzKiQdMzw/e01Yd0rE/1b9tjCsuso6ORATw4+70rQwkOlT1gZ
	 FItD/+0Jr9G1wyBZLmWvsTaNxFLf9UARVWk+3YbY6PXBx3ma8hcKgALK0UTfXEwfVuk8H
	 8kJm6Lcj1dQDU4faEwCOBqEvhRN5rwRs52Fl8MJIYYzfq8a/sXDnj1vHBndU3Bsb7Aw+h
	 a28cVZa1w111FP4gFbOmn4JlVVvp50Mu1wCTaz2tlo9l1RKdnCds6UBc9P20rkrd/Hw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794941988;
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
	bh=wjb87e8y1lG+w63skstoJYEZeXi8NklHNoDpWxrUHs8=;
	b=dnlMXhP2NeCnXnmATSE6xcyMSDg8qDqqgQps7vCmw/hx9Do+nx2FGe7TrXX2HwwAjBas
	 2ftCSmJwnt0AiTPtdUKLxy52zoaDGlWWiU1nrINz46OcZ7+rj1YADEwb+KC+io2Jf/WLq
	 Tvrl4bfFUnmg08N+JRfWArAcPZ/XPRBi/vYTrzRwDlBhA54pgRmtH+vbQx+ha3N90Ujf9
	 UcNsve1RDoLJ6dKLtM2QxbOBT+kYLxw1pzbT1EiXH47mF4O+n3yCssafmP5bbN6VNUIdt
	 wn0A3+bEhqi+wY7VChflIh3DIG00gJ+ULJu3ShU1QvfaeDFkabgSN3j3L7wlBTQ+xag==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Unxj30eR;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="wfgNqNy/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583AC606A338
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 18:59:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 583AC606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Unxj30eR;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=wfgNqNy/
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794941996; x=1826477996;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=3ftR8j2+L9fsVvyPgMX0ln/GsY8l3mMI5ZK/BSxCgsE=;
  b=Unxj30eRcN4BKOVjUKzwbK+W1/jUFpnBaetqy3VUX4XlPbBxE+agZtx9
   6w5N+alTRZTvjsGqxMWtpneGk+SPet+P+bR0HlmwKEVE7ms8jOLdQu7fT
   rgRZy441ZRWyDcXxXH+3HuqhUuY+ZPrwCsEkBWJUFsb3XsaEqfiuvcI+u
   B4kk5T2TEWMc41BkmmU22kD+ylI40kOf/JT0LuY75ruFZxPHQkqKGOX2+
   ga/xvCCdGt0t7nnoG4cettFJ8yEz7jvPRNPGMiN59ckQdr4kNgYLV51Ip
   LXB8X6oXyKUeqkaok5kNh3syqyFu0Njk/tTmlpOZ9pPzstuym8d1UGs9s
   Q==;
X-CSE-ConnectionGUID: B4FlZLYZRZu7O6MDuIrpqg==
X-CSE-MsgGUID: u5EpmYU7RdKtcR9PEVDInw==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="162096905"
Received: from mail-northcentralusazon11012027.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.27])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 02:59:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lDk1+R9s2gFAU7GBpVDXf6BuPnfdh+YpAI9YBkmkPVzfBdDEEliLLQ0K2iFBMdHSjHE1dCU91HeKStBmLEtwdyJ+152/J5dJKokFx93HH+obiU6wJr6hRO7yB5S1wtOcbX14q4eJYlF0mwVqrvfzUFivxt/8hWIPxb3d/Z9RCse3OEsl6LL43a1lFcH1bxoLpe9D/P3u6Kac/zcCF+xDANIFXyqlh6x3AVMwCxgHImJEa1gIWgvcYJYGrNJ6AE7+5HSyqgNQrYkPcb0VSCIjwQGvN1uudwbCas4sFYQIjar1e5Frmv2hdeBrKnPKZG7uC0Zd7sS3L6wrJbwEqHyD2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wjb87e8y1lG+w63skstoJYEZeXi8NklHNoDpWxrUHs8=;
 b=RcYNt7vJPw+br6WLylTKfVkYwdoANELnz9ggxoo7z17FFYnwGm/qYxAMiNXCXL2mdT6EAtSXrh27VnKZrj/Alze66o85PufBm632Dy9kxYLB3ba2MFyMTTIjdJkxYup5if26a/rjBLiCdEIguaPSVToUF9edYp9oFqp3PLmsQmknDmEJgv3+yZhHbfEWxD2WDpgX9rOhpqOn6n5Q+U6hEJoHZJzofc8BsYOYSIPlTRnwLcoyimbvJnXxMVhh6P1QFola78ONu/a0wOfrZMzjpsqdjyWd7PM6N9nlVrBXdXrAZYvh1MBWeB3k77b1WHyXkLCLHEGn8217GbRJa6NYqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjb87e8y1lG+w63skstoJYEZeXi8NklHNoDpWxrUHs8=;
 b=wfgNqNy/Rck6dsTWGvIPFpUkfcWB950PE5ieEvzVTUOYrmsA1GoBHJggmMfiCF+hDYH0h6HXvZHldVohAoq7shVAEb3i7Depbs4s+96Az41DTDRnHPFxe6EYJ3tn7GWNBrERGLXvWBTro/h6kCPrgwkRAJAO/X+oSjqpAEFoCUA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH6PR04MB993818.namprd04.prod.outlook.com (2603:10b6:610:382::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 18:59:13 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 18:59:13 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v7 02/27] btrfs: zoned: reject dev-replace onto a target with different zone types
Date: Tue, 17 Nov 2026 19:58:25 +0100
Message-ID: <20261117185850.4128157-3-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH6PR04MB993818:EE_
X-MS-Office365-Filtering-Correlation-Id: a2835e2f-cc65-4c20-d385-08df44dcdee4
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|376014|19092799006|23010399003|366016|18002099003|22082099003|261009223027099003|11063799006|56012099006|261102123227099003|261026121527099003|261021121427099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	lMl8OBs+9BkZ32Adk8+n8M1G2kOwZdl9Tsajbzk5/SbclpzxWx8S8B7s/rIWi59kH7DrZ8VrCrXuirp3IhlqRthTzp9H+Hu8GWDVJ/I9GhAC2MFiPCERimLKYiw4R20sAzqylfbA1eyLSt3QPRiz5NmqB5hrabr7eIzUdTVu8bmS5slJrs+ywKRIXvSM6nX0LXL0QE8nCs9IloAfrVHT5ov9VfP9+ibqH4PQMTaDx0gciSMm7ToegpaKhSnUpgPR1edzDy4wVblonkkWd+oB4bpajqXfwJnwSIa4bWx3jOU0zzH9ohRGXzB0ViiTcBjimsK88nAMWGpzJqdSHpShuS0WRTn8Nj4priHxhdDi7TN0oa+DnnmURvPDVksJbrhF6CZ0pvQzqj2AIkvOqxp5sTCkhXpU0Uy1ukCL1rAFuJpDzKYtgZ9QpJ85hJIRO4sBHSVlx3AKBfOv9n/sBKSEGjVcvOPvaB6DDH6SsymlQl3woSLdKOGrCU+IxsaZ/cuLexEZOvYN5eUuqelb5D+N2IU865dVjjDRDJnE6qlo4CWaJgbdC5EstWIE6odGbZTSDJdlhN3YjvjnUE6bKLGsDajY1LxAc2vQ4hcjxbUkegbKFa1rKd28INrIvL/vjjWylbJV3e2czBTxx0YQO36Ms3LjTuXDsuAsQtMTPasmnuw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(19092799006)(23010399003)(366016)(18002099003)(22082099003)(261009223027099003)(11063799006)(56012099006)(261102123227099003)(261026121527099003)(261021121427099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bi3GUY9C8MhymbClsCHKVFI4VwnLZz23tfmE4GEOUUg0yhHZk8OUQ8ot5SCQ?=
 =?us-ascii?Q?8YOizXOr4Br3T8k3KXRalD4G6hAu1wVYVjcZUEGaLpvuc5prrr8JXKQGqbmT?=
 =?us-ascii?Q?k6z84RIpJkAAR4dymWLb8fN1i2qCQUasW/uuNHr7pn2OfSc/vJp2iwhwbENa?=
 =?us-ascii?Q?yWTGJyceJZ09cKmdYZvMK45fwct0WxIBkL0EBZuhFS35YHbBmGKzbgs4fOKA?=
 =?us-ascii?Q?OZMWsAkxzvf8aMP8YHuCe6tQihlgONVyvOKRWoQCq8XOKYYtQfQtnyyrV5+e?=
 =?us-ascii?Q?nhLRO/b9fL3O94k97sr9UQODzJFHTHICfQAiI7YjvIuAH3tJdw2cfYcUKPWb?=
 =?us-ascii?Q?DI0hqrrjUV61m3bLvrHHyAGSVE0RCW/whv+PtmGuh1coAldbzxcdBOt45UMa?=
 =?us-ascii?Q?Y9Tk8hex0DZb2UmXH5ILnA3SPCJj0sBvXeGqBGy3JvNjfFkTHEE4EmaMccui?=
 =?us-ascii?Q?N4vBkjO3oIkdQWlVPdzTPR6WYY/YfTYAHknkAvTvVARq/hty+w2TPkdZHSQ+?=
 =?us-ascii?Q?+jS6zQT2ibNboCkerVmZellcwpKyJf81pxiogrsVynpdu0xr3bDvirXk+Fyh?=
 =?us-ascii?Q?G4vFoVAUZg5ludK5Yjf4pO80monVCqsXDuHc1I4hs2wYm8ZaTSmnUJSKADgM?=
 =?us-ascii?Q?uV/w+2F4TQAbM+FgThweMIiYPc6kcr6JTG/bA/BY81SHrjvqyAw6vFszCEh/?=
 =?us-ascii?Q?xiEXxV8hT5IS9qVHL15vA4Hwk3bP8Aj2VHpbmYaa/a1aGtsaX1x2BPjBXhsd?=
 =?us-ascii?Q?Zt2ds0gyD5/TpDUWgqta0aWxqVvhH3Ttpt2VkwdGnH7AwROvSUJO3ZAJ4n/N?=
 =?us-ascii?Q?zHGu1gZFs1ytJCSLF5IHrhUVHyAUpi0UeLogCTx079j85ZA/S8jf2WjtYv0E?=
 =?us-ascii?Q?o81duKIjPzpiq7GpNiLqdmHdTggZC+ppwIIH62Oxz2m8zk+qkU5dX8Q30iOY?=
 =?us-ascii?Q?7xksyJVqa9jJ9NghZu/FJvDInxDaBxwHWPnZR09CAFi6f9+W04IQ0eN6rTZI?=
 =?us-ascii?Q?yCdosDhYe/lcb4E1Pob6U1yl7R+YEy1Ru9kBRE6PPnmARlKUrIMxFl5PWNfN?=
 =?us-ascii?Q?VTbiixMtcEDRsMy60MxrQmijL3fvUe243dC7xXcFZS/PQSiUrVSQ4D1Vt6Ee?=
 =?us-ascii?Q?IevEYi8xlhRD2pdcU3+t50YgjzFzjev9zqch/q3Dy/IDFQBzIOYVZDTXWJZh?=
 =?us-ascii?Q?O0Jtarbfs3sJ3HLhVWs9qz2JRo4zDnEDTM3mrKfpaHdbBzdHkueZzE4Mfto5?=
 =?us-ascii?Q?FxUfz+jiIbXs8hP78KdF861ZcaVNMwxvU9VqDeYTnL1n+NwkDafnaI82Y5QH?=
 =?us-ascii?Q?Sue3TSa1IrLNWrXT7QfRE36ZGhASd7rCKRAAOPspA54PQcPdAPYg/02Vk/Th?=
 =?us-ascii?Q?TyhIfmDG+XCVnEul3qqC56BsxSF38R3dZE65PgCOqw70bwbO7iAxT0U2rbbB?=
 =?us-ascii?Q?UuPRgv80/5TCZCNPMMgjh/kUYgrI7TQtb97JL+vjDj1Rzp2HeRoYUkx7J1Vm?=
 =?us-ascii?Q?KO3M5l6Q7nIb73luHUO+6JTniO1unwqXdYFLjmG320fzt9zuj2ZSTInrM/KV?=
 =?us-ascii?Q?VDhISRqNLHd43VRFqeN9/lNyiJEylhW0uwn8UhMzfp4lC4u6SmAwY6BHfPSh?=
 =?us-ascii?Q?zeFC8D4EtIGkqlfJRUzAll3yS2eF0lhslaBqPe1OTLvMu5wqO58XZ8SS3c/t?=
 =?us-ascii?Q?y9A2hTutE3awJaTv/gKSRsIV4kWHo/lThj0EEkq4iTZrz0zViDevy7xSfCHE?=
 =?us-ascii?Q?DqQrs4oLImZGGMgBG2b9K4Qdrog4rNIlNHFFrkl+VPh8QMr84brKw2++vZfb?=
X-MS-Exchange-AntiSpam-MessageData-1: itz8WSMJdhhIQlquFt3yiwJc2qQwIV5ZnZw=
X-Exchange-RoutingPolicyChecked:
	Q41aR36rBZkGlRflXQkPvaqoE6lLtBrYJxC/Po/xPRrXHYbEfX6xtYpuWu/m3FQwsW0PYoobKgErIwmdJMCQDQisEw1B3DNYJOH4hrf50d+eq6qRkhiizBcRfiPUpqPAgDgFe/DuQUuUPM4bD25RAbhZ2IvaFD1PZttM6IXgGE89iI2TwYJe4A7VnUqTBbtIAZqG+n1t9Gfaf5lPa7AYbrlZbIfcyOmltmtANLvuMVQ5nMtB8wHuJkvri5/S6DPzRWB/mTu8EdMqNrC4y0Sm6b7mtD6b1WvCDAEX1PmaqKhT60NznFROYtUOa81F584cj7Lx4Q9Mxc4QU/LjfkcRnw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Z6dEi27zvAlQkc+NGVscpUKZkKtoZuhvvSLrM6qbk5D+W5cFJnP8AgfxvF4l3r9Cf82EZUyzDJERaJCDvT6Yisfdy9fP7eISaf6xgVI+6eRc3ucUqYIIQnRZx6ArXHberZoOgLx6H82IAra0+sf52++W9EaNismhZe84tw6g/aS4ejXqNKjAw4GBlrGIGllximO2IzZthvmYja3ybL5HsSRl6sjQLHho0/l+HfQUbWk5yiId3Tg8ZcMIFK5jURNPF17Sv5eBPupp3xeo1Uty2NC8p4dS5jY4Qqob87eyZRRV4iL7zwSgJXZPh0e7Nnma4nxcBms4czgWmSuDWruE0P52F4/69bDiNhfghQSTFEXzPFIy1TAX/aNpwDOpNppy1nvu+MeYuo9iAEyhFqxXSdm0c1LaZ0SEG+KgV/d3xWOZAZ3J910qBnIx5vaoCcaeXjhlqcIyyTfWUeO1p0VxCE34K1nF4/tCe1LrTwabNVFvx/6Asjaip2jHtQEzxXJmhbXSH5wsY6iRwqzED9b5SEtGuAHR/zCvgcA8yB9RiStPAUvG5XKWp6wOVYjeJIR1ArM7LCuIHrTo88ONuJFTIiF5eChtz4+GhT3uVbODiEOBKWCzApHaMlR27BOxTmmg
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2835e2f-cc65-4c20-d385-08df44dcdee4
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 18:59:13.6837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mGySN38IQ2UEzvaaVye84IRahcaNltg+4HL7fLjcatQJHo3p4JK+XGJjTvnl2g+/TAbU5qs1A/+ZUGdiUZY6ZkWK1Pk4ZbiNg+wlIX2qTWk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH6PR04MB993818

BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE is set when a block-group is loaded and
never updated. Replacing a device whose chunks live on conventional zones
with one that has sequential zones at the same offsets, or vice versa,
leaves the flag stale. The block-group then keeps being written in place
on sequential zones, or written with zone append on conventional ones.

Reject the replace if the conventional/sequential layout of the target
device doesn't match the source device. Missing source devices have no
zone information and can't be checked.

Fixes: 7db1c5d14dcd ("btrfs: zoned: support dev-replace in zoned filesystems")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/dev-replace.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 3c48cc714fef..a7a76e9572ad 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -318,6 +318,15 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	if (ret)
 		goto error;
 
+	if (srcdev->zone_info &&
+	    !bitmap_equal(srcdev->zone_info->seq_zones, device->zone_info->seq_zones,
+			  srcdev->zone_info->nr_zones)) {
+		btrfs_err(fs_info,
+		"dev-replace: zone types of target device mismatch with source device");
+		ret = -EINVAL;
+		goto error;
+	}
+
 	mutex_lock(&fs_devices->device_list_mutex);
 	list_add(&device->dev_list, &fs_devices->devices);
 	fs_devices->num_devices++;
-- 
2.56.1

