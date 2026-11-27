Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795791993;
	b=NTmvqiwEGPFcKn3f5dPIaeMZ9xaG/P5XNlMe70FN7luviranVpY47+zvUcApoiZBXjYi
	 pFCjMAF0bgZ5FyesfeCbU0Pm2WVeHo6opb6gBIZDNhQ/5Bv/UBWSPcwKlQ0KZy/O3CNOj
	 4N4DZRpYcZ98GL5QmUeMUThfcaKPCXGcNQwD3dohuTaxES8ieb9yIZKqcVr2Z45pHHqyV
	 IKGHf4E74w4oORoRqjWzXM5Vnw6E6IHN0cFEc8JElSIoDo2lP+SKwcKO2477m5Ti5lRkQ
	 nFUlm7a+ySmZVbqhJ9rMTboZuK2qHztNdKG1VWm425Z3bMWRtbFJiSPTuC7SLO2nfxA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795791993;
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
	bh=hm39Q8tEYwcpFV3JUcJXp6cSRBOTMg8UHAtcNANG8TI=;
	b=MES21E/4ZRd0vgzMnMpqL2EVlN42yryXEU3uphkrWVVv68pWMS7n2u2SaFYFFz10BrRX
	 MntEsZp80QdnRXq9C0kVFF/xqLmG4a/QumOzm7l1DLkVUUlDsagr6yk3QXe9GHMwqqb6T
	 9fOuqzXneSRF1pSVszbPmyf/KD0i74lOuPtlUQ8L+WoGFEU4PjlfU/PdHd9ccLyQkuBnA
	 Xs8TC3NaU2Wp7Dw/UAvNXUqij0+OT4FLUtswqd8nGQKK5wEXr5T02f9TU7/zqZVI6Wg0H
	 FtQsdckJbOtWmR5hwsVJ0Y57+2lhzbrboupr6dx4NaqxaVuFf58NRmEXuNnJUZO4CJA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=W9agrHTJ;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=GPX4H1Wg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEEB606A323
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 15:06:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7BEEB606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=W9agrHTJ;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=GPX4H1Wg
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795791991; x=1827327991;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=p1TkglQFdy4ZkcKlwAgXoeusRfAGEY0Y0ShDDHIHhc0=;
  b=W9agrHTJGXevsSQe+otmjyEvPiKqSMw+cvjSFWB9VDAgTeI5rIvxiLzh
   O2rZP1PuQBjIKFiA9UTABCxiqxJzybJ9syppnmC2TTkDOsDXbd6CMm8LQ
   CYASLpvsWx1KAcgOCyNlIFpU4qoYaV5BpsvKrC75cGBCRk1Znqpp7GGbz
   NhzCHgEhIkrdslDFBHM+DqJFWkq142NXzGgTueLqMvh4JuTle9TREivkj
   TlZ0H66jaapH1PAN9z2B3QzUILVyUjfyH0q2vEJkiUyPFk20nTyPFTTPH
   duR5+mY3Wr07h2PiPYs5HzJHZFuYLABrdZC2YFWnp4FE9qEJB0aBqiyKm
   g==;
X-CSE-ConnectionGUID: J5POJMRJQumoWHx9J+ymxA==
X-CSE-MsgGUID: ACRJ92BjRp6ci5K6G32OMA==
X-IronPort-AV: E=Sophos;i="6.27,237,1786982400"; 
   d="scan'208";a="162902165"
Received: from mail-eastusazon11011019.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([52.101.52.19])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Nov 2026 23:06:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VSa7XJunlav47GMJJhTVi+CTZunoN/EH4w/xm/KKvp5qG0p4UnYIwEI0S8nDTP1edyON0BxHUok8A/TBGdM2ATnDrZ29jJe4EW7ZzqWISNmn1/PwlXqs0vbqwzOEcpHRXDKAe4gVce/2pTLF2T1FJbTuuqrdca/j7q69McJLNNp20NhDMpA9wvN2FWyNvjWr1cUzRCCeRiuj3uTwAaY/Drhe2Cfhs8lWuM2bkgT/aNP8ckcOv8aYfMpBDjBRqBRUyoOlBgwBudJU15h7HL/G3W05M8Ge+ZJ/ceu7qdK5G9jOZjcMxJnXJx45oJwkGZa5gPuqfTKSit5x4SjFHf+Zaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hm39Q8tEYwcpFV3JUcJXp6cSRBOTMg8UHAtcNANG8TI=;
 b=gKTMAuXOsWmFB0UcuduB8yZ/SQ/5mdQX+HuSUxRdsINPEQo51suPXrdgOJoDriOx8rYDTj1Xw5LoTSMdjpyfwEfGuYH0HOAtBfK8fpzht/ERkqZ/C5CuEey0g/T5ij/dWWqULX7DsvJPs9tUlvngxVnxcyt1d51VOSOJjd3pA1tAE27tWolpJQaoPKIKga/qGZMVjTpZq42/WbtonQleU5Kj03paAa5E10xwAW3Eu3T5QaP1g9HslAMyFMtL16IJ18CKnAOZzlnEslup32BfyMRjCNQazIs+UCED4blb9akORnqmYLTIxjD+l681UKKA7vqU2RR1BehO4fbLtuMEYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hm39Q8tEYwcpFV3JUcJXp6cSRBOTMg8UHAtcNANG8TI=;
 b=GPX4H1Wg5q6wkj+VtJmTL5Dk1qmkcL2yS5i1MvTV7z0bSw2vJSKVlwTnPTT60EWrmyfNwOG0I3mEMzCAMx2csjbMsfca+gg73KtwtQzoOaaJEVWaeZ+dc04v84sGjTP8+vXQkvAE9mu4QD/K4fAMQB8T4v58cDs0yqe4wmWLllY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM8PR04MB7960.namprd04.prod.outlook.com (2603:10b6:8:6::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.10; Fri, 27 Nov 2026 15:06:23 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.007; Fri, 27 Nov 2026
 15:06:23 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Wilfred Mallawa <wilfred.opensource@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 3/5] btrfs: zoned: allocate a new block-group per file
Date: Fri, 27 Nov 2026 16:05:59 +0100
Message-ID: <20261127150601.803290-4-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261127150601.803290-1-johannes.thumshirn@wdc.com>
References: <20261127150601.803290-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0040.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::7) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM8PR04MB7960:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b37a9ed-7dab-4c4a-9a12-08df4c980027
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|10070799003|23010399003|19092799006|10067099003|56012099006|260925022911599003|260925021911599003|260925021311599003|261026140227099003|261026121527099003|261022075727099003|261022105027099003|261021123027099003|261021121427099003|261028144727099003|261102123227099003|261009223027099003|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
 Wg4ncKHAISZ3zGOTCnIn9Ak1DRVhQQeNS8ARy49rtm/Maiovk+wbzEpFB8YcqlBQaHwB5/fFEWpaUF1rmF7PkbTqu56H/RKgT3kgo0waCUydWNpqpzhCxZ5TZu9rK5qByXaKyN4QeaAwcL80Nyw5WVvb3zc056ojzM8XBYv977Cq0svlYb+Q4BHnxrOlslujg/MPgSOAxFuZHSCKTynSm/VP5f5nKK9ggsurv8OETjQ8AmGZlBvftS1rjE6e2q0g/0KX5ccJf8x1gs8uKaJ0wSLV1u2TkQMyxLAjiaL0IL56/SR3vzDzy6Eq80a085y1kd1Jm7q+3L+40O9u9ELpJ0AoZs/MvySNYOiaf2lWnWx+HcwPV9rjGAfb0OOzGeaK30mTBeOaSNlkScAxdD7z38f3JVJtTVR2myAAIkxHpyuZFTiwVGG2yTe4AbN+0yyV/yMaZqpW7FXzJ4rkqvu2W4QjA4O3Md7qbUGFdERTE/fYK1hXCWvS/3dR4gDJQyyyhHf/eftgnyCvHEyqg5gOvqRjkO/rrdL9dxeo62hWgmk+CgAF4iY3cF58VAtUGJBTlI329YXnhttO8ba/f4urK5aOoP0HJ6GnLX+nmCJK2utVrk3RrN6gNxtgZqVT/FvZZMmPEzoYaA2kZQRYEe2aYh17giBrncaY0oXU0q/shZo=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(10070799003)(23010399003)(19092799006)(10067099003)(56012099006)(260925022911599003)(260925021911599003)(260925021311599003)(261026140227099003)(261026121527099003)(261022075727099003)(261022105027099003)(261021123027099003)(261021121427099003)(261028144727099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?Ea7dCJJrUEVsPsmpTcruGv9HUWO0bY62SXhD6vOpGnjzY5XW2te0OlLiA/dQ?=
 =?us-ascii?Q?PcMyPh9OQhYx94UikUW52hg4uQvidCuekjAlgv8K+NkyqDLl1oW2j2DRJtwM?=
 =?us-ascii?Q?sMQh3cZcXW9G/Fz0czzsXTkJOTzEydhPIVq4lgVApVbNTO78rxpGJ+HsK1d0?=
 =?us-ascii?Q?cFzn1NYiilIKdYfCo8zq67PytksGYrERTRnaWel7OD3aj5h73HBIGvzcsCzs?=
 =?us-ascii?Q?z6Pv5XFdg3yiZ1rkxNYO4wVfBL/FhSq5pFpXxBWQt8hNHzCpSCelKdZ4Lh/D?=
 =?us-ascii?Q?xt22zAyXHZZOH+N9OhTYsmGqOfKtnceALtxfxR2gA1LnPRSXrPw7I+TXgsUD?=
 =?us-ascii?Q?pijd7SyE2+26vuwJVFySd1kH5U1E9m87npQZkAuigNH8Nwbd49iTH/H4UNAE?=
 =?us-ascii?Q?CSvwOJQsHLsctwbe19ycUGsh8yP3/nFmdUw2qCVZy3C6UsJy3Tl3JK2uGYkx?=
 =?us-ascii?Q?N7/wzJrpw1sddKpOA6Xo+9HpahMSwhLv9OfcNlzFHejxHQseirMqXAxYoECf?=
 =?us-ascii?Q?0P92T9HcGLImWghZ1Cl8wClO+5gVpyo4MtluHXhui/dEtoWkMQVjf5bytPR2?=
 =?us-ascii?Q?B/q6H2j5v+LUu6rd3E38iAu98xzlP/tM+9+sFfq21vpLEqXDhkQAsqR7CZ+G?=
 =?us-ascii?Q?Lk9b7GOPI2pSiuL7eIq9ItX1Oc9+Ji2o83fL7fk14VZyLIMOg/ehVyYIqOcx?=
 =?us-ascii?Q?ExYzvm9xnBcCpOHb6L/Lni4BWViaeh8mpKgj/RJp32Z7XwBoYHG7UBs8YlP0?=
 =?us-ascii?Q?WdGXTiIZwM/9f4osGnvvyNJyCIFaQOwabj48R47oV4eVSwDW6RQREnoxi8e0?=
 =?us-ascii?Q?5Y21jlON/KT7cSh0/SM+ZPYJD02Bic4+RELeofhU8kxjsISxq8lxjzcf/OFe?=
 =?us-ascii?Q?Inu2JxlHBuyM3WX78Zv7XLVfhObYl4hC/BpznEcSS44xT+BW6KpuliF+lzR9?=
 =?us-ascii?Q?sCsubTuqsvs+P7+pSSZj7BIZ2fNDF3HgPmg3Uo+RNf5kupd+radGO4K3W3CU?=
 =?us-ascii?Q?T4IWfLpFYMRqejQmPquQuJlpKZMd83ERyAUK9fku157hDotPOMMSxS30X/Ll?=
 =?us-ascii?Q?urFAC+dgRk/5QsnxzLiEDSXdULBZfeYYJfGixauJilKt+6P7Zzlokrx5Gp8T?=
 =?us-ascii?Q?uTlQke9Demn3Hsnalbk8yssneCywjxd79D4oUTdfrmsmGTxbV+5Qo6BkWQfG?=
 =?us-ascii?Q?lqV2NcMYpooVrSWRxpPBB/5PvpgH3bAl+iJXE8bX8GZtXBHtAsV3k3JGfkRs?=
 =?us-ascii?Q?TbJSIHG6nhX0UueupJx50mW8SIZPqhHT4XdjMvpwLCiGehBgKMLkK36N7MQL?=
 =?us-ascii?Q?k2liVQ77nhzsVO6izcsgDUTTygoYfJK0zzZ5MS+6B96m+8N4o4sFb/pP9P5/?=
 =?us-ascii?Q?VkDmfodV1rlNMLqbIas2mPw0S5Bp9qrv15WvPVGaccxBL+crHS3Xcx6nmhHo?=
 =?us-ascii?Q?QG66BOStXBiPzn/sljeZqtsxMfAA1Gtd3j4WM3dk+QpY9eDnOqEOO9nuLRQh?=
 =?us-ascii?Q?zyM8AphzV3bsiFvONLmo31aHxU5i1c/14FAKNEKDSIJzWTTJLJ1RX6WLTc3u?=
 =?us-ascii?Q?SF5W11STdhSlqSaYwZ0r3lQ/1jxNNGSakgVJBR1V50TmdW5TPD0FsZNONBgG?=
 =?us-ascii?Q?9Z6HYY7fpoedMAGYNrSgA8YNy7U4JH224yC+tSww77Mhoe6wsN5V2H+RPjLg?=
 =?us-ascii?Q?aVVSXYhrLYkLH/E0snXgDHX6XS3qyBEyBKLTSWWU+akffxP26GHa8/TCwgLr?=
 =?us-ascii?Q?jth/0eH1xEE26wQetkFBk9NpBygo4q/0rHov0CwWf4QM35ijGdv9NUBy+Od7?=
X-MS-Exchange-AntiSpam-MessageData-1: APPX8QMXgujVPxO/bIP72Y699Y3cWWdw7T4=
X-Exchange-RoutingPolicyChecked:
	M1keDK8F8WCNxDFYwxhrgdFbF/SnbZaUyRB2huzy3cXgzCvksLI2z5k50q82EA7o2y50lxCRrlC3zZD/oSdl5OIun44p2OetWGI2OKGfa1k0hDlqyOkWDgXCOxyqZHXxpzsQkqv9JMF9sdrRhV3ZK845aSV+AnRbUtNTL7mGZY9tQvmhcqwYwymrSgwVY0+nYZfrHpfQKnkrItd6WrIvU5o63Y08OQakOL3c5nopsNYSSuhDgpOcyNH3f3kdseTG6JkbbOD5OENVxizLJvWyCPYg2cNabnbsB50qNNT5emhYMTa8pp87g8yGKxcWUmcfdR54Uh4rkuaQ6sUuXxQIHw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wXtCc7xeLn5DogLgZ8cWUs1CQdAK9a/li85YJF1hZFHbFshkLqVsIv/C49EwATnbK+VsxEM1JvMw8wNBgAt066+B5HiH1PRVBokXDhs7BgmmHqfR0R7IZzLjOjtztg6FCt9ou4b+ZMbu1EujR56p31NI0qt/08NR3jmiIyPJXhQYk8xaydEaKCXeXVV1Op1eNbjtfSgNZuE4IaTjwK23NmiuCH8pasiS/zCfW0FM9YpS2CWTI/3Q1HhreOJut/UU7hryjO71+4nj1gjqu5efTDqtUTvBN4fLC0qQ4Qatf4BDnoknfdJDSD/JTi0ZieT6ktbkU10a5mDj4N59C4NmibzPEYeHEVxmkpdK+jJahFyvjsPdo4TMqs+lgvbvcV/dTlesK2NGCuIryj/WIFdoASU1wYVTnhPsj5rmnBIr1EowNOnH9qrivA5lzm4y+Lu1WJo7jCNteLGv8gqueOnbBc3VdyALE1dxORWEw9dxJawiT5rxBmzvDy6kKAD1c0liJ4GPjmK5DCcXNaNRYViiXwli+VSKinqq4I4nBnd1sOqDnK4eMwiYzLNGePPH2blVPI5QrfCe9hkiWtmFQHR0EjW2O3zUswboGbIiMEyu45AIrtHGvFSV8+ekmJOJnnYW
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b37a9ed-7dab-4c4a-9a12-08df4c980027
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 15:06:23.2183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5r7+AzqBeRoD9qT/O6mwKIHc9JT8OL/Ao7DS4CY5LrVAx4+JKyogJkFU2wQJD34RJ9qtZEvG2aLzIwayY4mdeAIeAGVRpPC684pAQoxuzYM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7960

On zoned filesystems all data writers share the first active block-group
with free space, so extents of parallel writers interleave. This is
causing high fragmentation in the filesystem, that also potentially
increases the need for garbage collection.

If the allocation hint doesn't hit an active block-group with enough
space, e.g. for a new file or after its block-group filled up, and an
active zone can be spared, allocate from an empty block-group instead.
If no zone can be spared, spread allocations round-robin over the active
block-groups. Never finish a zone for this.

On an expample null_blk device with 64M zones, max 12 active zones this
results in:

Test                          files/zone   extents/file
5 parallel O_DIRECT writers   5.0 -> 1.09  966 -> 74
4 files appended round-robin  4.0 -> 1.0   192 -> 3

Buffered parallel writers improve less (4.45 -> 3.09 files per zone):
block-groups with a leftover smaller than the next allocation keep their
active zone.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/extent-tree.c       | 35 +++++++++++++++++++++++++++++------
 fs/btrfs/extent-tree.h       |  3 +++
 fs/btrfs/zoned.c             | 31 +++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h             |  7 +++++++
 include/trace/events/btrfs.h | 12 ++++++++----
 5 files changed, 78 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ecec52b94065..26f159b293f6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3766,6 +3766,11 @@ enum btrfs_loop_type {
 	LOOP_NO_EMPTY_SIZE,
 };
 
+static inline bool want_new_bg(const struct find_free_extent_ctl *ffe_ctl)
+{
+	return ffe_ctl->want_new_bg && ffe_ctl->loop <= LOOP_ALLOC_CHUNK;
+}
+
 static inline void
 btrfs_lock_block_group(struct btrfs_block_group *cache, bool delalloc)
 {
@@ -4068,7 +4073,8 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 
 	/* Check RO and no space case before trying to activate it */
 	spin_lock(&block_group->lock);
-	if (block_group->ro || btrfs_zoned_bg_is_full(block_group)) {
+	if (block_group->ro || btrfs_zoned_bg_is_full(block_group) ||
+	    (want_new_bg(ffe_ctl) && block_group->alloc_offset)) {
 		ret = 1;
 		/*
 		 * May need to clear fs_info->{treelog,data_reloc}_bg.
@@ -4102,6 +4108,7 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 	       fs_info->data_reloc_bg == 0);
 
 	if (block_group->ro ||
+	    (want_new_bg(ffe_ctl) && block_group->alloc_offset) ||
 	    (!ffe_ctl->for_data_reloc &&
 	     test_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &block_group->runtime_flags))) {
 		ret = 1;
@@ -4259,6 +4266,13 @@ static int can_allocate_chunk_zoned(struct btrfs_fs_info *fs_info,
 	if (!(ffe_ctl->flags & BTRFS_BLOCK_GROUP_DATA))
 		return 0;
 
+	if (ffe_ctl->want_new_bg) {
+		if (btrfs_can_spare_active_zone(fs_info, ffe_ctl->flags))
+			return 0;
+		else
+			return 1;
+	}
+
 	/* If we can activate new zone, just allocate a chunk and use it */
 	if (btrfs_can_activate_zone(fs_info->fs_devices, ffe_ctl->flags))
 		return 0;
@@ -4530,13 +4544,21 @@ static int prepare_allocation_zoned(struct btrfs_fs_info *fs_info,
 		}
 	}
 
-	if (!block_group)
-		block_group = fallback;
+	if (!block_group) {
+		if (btrfs_can_spare_active_zone(fs_info, ffe_ctl->flags)) {
+			ffe_ctl->want_new_bg = true;
+		} else {
+			block_group = fallback;
+			if (block_group)
+				list_move_tail(&block_group->active_bg_list,
+					       &fs_info->zone_active_bgs);
+		}
+	}
 
-	if (block_group)
-		ffe_ctl->hint_byte = block_group->start;
+	ffe_ctl->hint_byte = block_group ? block_group->start : 0;
 
-	trace_prepare_allocation_zoned(fs_info, hint, block_group);
+	trace_prepare_allocation_zoned(fs_info, hint, block_group,
+				       ffe_ctl->want_new_bg);
 	spin_unlock(&fs_info->zone_active_bgs_lock);
 
 	return 0;
@@ -4609,6 +4631,7 @@ static noinline int find_free_extent(struct btrfs_root *root,
 	ffe_ctl->cached = 0;
 	ffe_ctl->max_extent_size = 0;
 	ffe_ctl->total_free_space = 0;
+	ffe_ctl->want_new_bg = false;
 	ffe_ctl->found_offset = 0;
 	ffe_ctl->policy = BTRFS_EXTENT_ALLOC_CLUSTERED;
 	ffe_ctl->size_class = btrfs_calc_block_group_size_class(ffe_ctl->num_bytes);
diff --git a/fs/btrfs/extent-tree.h b/fs/btrfs/extent-tree.h
index ff330d4896d6..25d4b17d7458 100644
--- a/fs/btrfs/extent-tree.h
+++ b/fs/btrfs/extent-tree.h
@@ -87,6 +87,9 @@ struct find_free_extent_ctl {
 
 	/* Size class of block groups to prefer in early loops */
 	enum btrfs_block_group_size_class size_class;
+
+	/* Allocate a new block-group */
+	bool want_new_bg;
 };
 
 enum btrfs_inline_ref_type {
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 0277b2a48a73..db173d751179 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -67,6 +67,8 @@
 
 #define SUPER_INFO_SECTORS	((u64)BTRFS_SUPER_INFO_SIZE >> SECTOR_SHIFT)
 
+#define BTRFS_ZONED_GC_SPARE_ZONES	1 /* XXX: This needs a bump when zgc-final is merged */
+
 static void wait_eb_writebacks(struct btrfs_block_group *block_group);
 static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_written);
 
@@ -2757,6 +2759,35 @@ void btrfs_zone_finish_relocated(struct btrfs_block_group *block_group)
 			   block_group->start, ret);
 }
 
+bool btrfs_can_spare_active_zone(struct btrfs_fs_info *fs_info, u64 flags)
+{
+	struct btrfs_device *device;
+	const int needed = (flags & BTRFS_BLOCK_GROUP_DUP) ? 2 : 1;
+	bool ret = false;
+
+	if (test_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags))
+		return false;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(device, &fs_info->fs_devices->devices, dev_list) {
+		struct btrfs_zoned_device_info *zinfo = device->zone_info;
+
+		if (!device->bdev || !zinfo || !zinfo->max_active_zones ||
+		    !test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state))
+			continue;
+
+		if (atomic_read(&zinfo->active_zones_left) >=
+		    READ_ONCE(zinfo->reserved_active_zones) + needed +
+		    BTRFS_ZONED_GC_SPARE_ZONES) {
+			ret = true;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+
 bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices, u64 flags)
 {
 	struct btrfs_fs_info *fs_info = fs_devices->fs_info;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 2225090839f3..2c17c31437ca 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -103,6 +103,7 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
 void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info);
 int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes);
 void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq);
+bool btrfs_can_spare_active_zone(struct btrfs_fs_info *fs_info, u64 flags);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 struct zone_info;
@@ -299,6 +300,12 @@ static inline int btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct s
 	return 0;
 }
 
+static inline bool btrfs_can_spare_active_zone(struct btrfs_fs_info *fs_info,
+					       u64 flags)
+{
+	return false;
+}
+
 #endif
 
 static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 1378e697a46f..830927b185a4 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -2244,15 +2244,17 @@ TRACE_EVENT(btrfs_find_free_extent_have_block_group,
 TRACE_EVENT(prepare_allocation_zoned,
 
 	TP_PROTO(const struct btrfs_fs_info *fs_info,
-		 u64 hint_byte, const struct btrfs_block_group *block_group),
+		 u64 hint_byte, const struct btrfs_block_group *block_group,
+		 bool want_fresh),
 
-	TP_ARGS(fs_info, hint_byte, block_group),
+	TP_ARGS(fs_info, hint_byte, block_group, want_fresh),
 
 	TP_STRUCT__entry_btrfs(
 		__field(	u64,	hint_byte		)
 		__field(	u64,	bg_start		)
 		__field(	u64,	bg_flags		)
 		__field(	bool,	hit			)
+		__field(	bool,	want_fresh		)
 	),
 
 	TP_fast_assign_btrfs(fs_info,
@@ -2262,12 +2264,14 @@ TRACE_EVENT(prepare_allocation_zoned,
 		__entry->hit		= block_group && in_range(hint_byte,
 						block_group->start,
 						block_group->length);
+		__entry->want_fresh	= want_fresh;
 	),
 
-	TP_printk_btrfs("hint=%llu block_group=%llu bg_flags=%llu(%s) hit=%d",
+	TP_printk_btrfs("hint=%llu block_group=%llu bg_flags=%llu(%s) hit=%d want_fresh=%d",
 			__entry->hint_byte, __entry->bg_start, __entry->bg_flags,
 			__print_flags((unsigned long)__entry->bg_flags, "|",
-				BTRFS_GROUP_FLAGS), __entry->hit)
+				BTRFS_GROUP_FLAGS), __entry->hit,
+			__entry->want_fresh)
 );
 
 DECLARE_EVENT_CLASS(btrfs__reserve_extent,
-- 
2.56.1

