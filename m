Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795791992;
	b=VHY+zUflB58bJcxYxfNI7GKlqYCc4KU6e2oqvx5Z4972TA1D7tOIh5k/3MUMnPJ8/n9v
	 Scni12pkrGGA8o+XGHL9C/f2y9h/XtLVoGq3S4WPgZsxXuMQm5tt5pFIHMZ/jOaXPuBYh
	 ByHsCKoe5iU2Of4Jed77dON5pz6we1gJX9rKLMFe5JFkmx3uTeCT3fgSfEJ5qDYb4qbrj
	 scbZLfI7K9S5egtfU4D9od4Ykvc2DaxMbMN0sq5UykHCp1Us/3PMdzyPgw4Jqh6UUyxoj
	 UT1twESVad29WmdSD7flLvWIBUxlftXj+aDAeRrBSc/nAviqVNAYh2esbezTRmXw2PA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795791992;
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
	bh=IX3TpTctB2kuL9OyHPoDgWVnTcxegRxGIazMpXAFD0M=;
	b=ZuD0vlp5iOYhs0ppvdTNiL+dRN0Dn8nNQU5DHwcKew2oaIZtqTyTKOy1z+f8YQFBhQIR
	 vJAeEMEzMzNAqSSzghYroS6xJsXJlybMMhn/vCq+fSOEnEh1+ExhS5ObZ4wS1FL31yUoG
	 MRMbAa+79t4B88gIhNQu0Lc/RcLkrf7m34BSYq3hdwJyiDWiHQBF2/aE1Od9eT/DouGUe
	 bcyJIZSSsnKGTY3/HhEbo9h7CsCnfh3GcRRwUOkumDrrOB9EeAXkCqfwBsqYr7zRfzhNg
	 Tjy0aFuhTLp1J0HlFKNFFgFDU/sfDvhEjGZvQVbKt63lWSYJNbTYYcim5kiZXjVEqwQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=aVNjYPZa;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=jwR3DCHR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CFE606A31C
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 15:06:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89CFE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=aVNjYPZa;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=jwR3DCHR
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795791999; x=1827327999;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=JO2rr+rXFqNgQEQ8W/PNZg5ruicVNobFng7U9Sl0CYE=;
  b=aVNjYPZaOKjgPdacgteQz1IigkS7u2SGWxwUH4yvD6XOYmpgMkrRBZgr
   eQm60hwItly5OhD0a7RRDuO58xn0kLK3BzImrbSUV+6SWKhueOcSwzL7a
   tPyDu1ZuFUKIduPcmR1DS/ZPSs4s21+C6OW3dsmhaAq/esMgL+PTJzhHC
   vzmp1T8snsb2HKbLUPc5Gt5IxExiL3qfttAPxXqRQIcKkKzfs2NoIQts3
   uPEl+h45TM+RjxOmN8ePWA9iPmLE65eWX6m2hAMTwGVQJNleBE5ISmT8q
   sDrxDgUDW8HZWDL2m3huXjdXEdA9AR3Vd4i04pef872w57F4Nf38CXoUY
   g==;
X-CSE-ConnectionGUID: IbUrgTkRTrW6HY0s8Fm8uQ==
X-CSE-MsgGUID: OLeGrzmcTgqzAGsNDF5ohA==
X-IronPort-AV: E=Sophos;i="6.27,237,1786982400"; 
   d="scan'208";a="157674252"
Received: from mail-northcentralusazon11010003.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.3])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Nov 2026 23:06:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AC0SEVIWBC2lXXEzY3KMHSU8mQrVMcZDm1wqagkhoFl98D6Z+Z2N5qVOfjmbDwUo0VaKeGS1Q3UVcIAOLBn+fSHcfRD8zZ48Xe+n6W2uFh5rtVNjaM1UnUHGmjT0UUUSD47fJyYhwlHue/5IjpnJoZpsvh++p6a55S2XTD375+VhbBi0sqFTcSPZXcuQszpA9WJyriD4lQ2VIxKPHntjUGTzhYBoFAZw8eTERLUnPaKQbQpwNuzHbeaWEnxQaCC+VR0zhG6wKVO8i7jn0XjAgJEj61Fk/xuEGckom5JMJp8N/gHGdSHDsbsRSEFDmmy4kz6bpqkdLZtfv0NXsfQFFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IX3TpTctB2kuL9OyHPoDgWVnTcxegRxGIazMpXAFD0M=;
 b=MZ9Uxhaxe+fmoEEU5TqDnMTZ67eG/LmRpRGtgxChLroEAa46cLSHbFaof0YagcYD9oP4hcyBV9i7zAO5R+EUgM9waKOeQnrqBXk3NPB2wOJgN9U1XCOdHCDFYX6CGSpv4XkS1cIJXBdJOWkXKa/19En837TrSHglvpc3xbwZ5YVz7AcOrNaI1HYF2jgNmBerG+eet545Z0UgNW04CFLjQ6ZLgZuyMgQDwxXZxKZ0/Jrn5Pc/tBqvKXrdxwi9GQ6j5Ld75PR3zbfCISt8XjSYFjIAbxPflAfEa5upbDQrnCANVPzQR/9JIQ2jEF9WaVZSTClAPRxm1qBDjRhnWO/3fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IX3TpTctB2kuL9OyHPoDgWVnTcxegRxGIazMpXAFD0M=;
 b=jwR3DCHRcT93thZoTcqW0ivEG1LLvn2lWrLwzDsyN06zgFxQtqyHX604eP+8zK6Y10eAMZZ6+/pk45s8j0BOyDmJTk0q26t7+yQVJF3mn/8UKaQM1wevQxSvnuMyjEnkPv02m4xA1ImPXvBWN2jv61dpnvkYW2JuG4Jq1wb2U88=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM8PR04MB7960.namprd04.prod.outlook.com (2603:10b6:8:6::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.10; Fri, 27 Nov 2026 15:06:27 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.007; Fri, 27 Nov 2026
 15:06:27 +0000
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
Subject: [PATCH v2 5/5] btrfs: zoned: break concurrent chunk allocation race
Date: Fri, 27 Nov 2026 16:06:01 +0100
Message-ID: <20261127150601.803290-6-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4928e8b3-5d72-4d5a-9b5d-08df4c9802d1
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|10070799003|23010399003|19092799006|10067099003|56012099006|261026140227099003|261026121527099003|261022105027099003|261021121427099003|261028144727099003|261102123227099003|261009223027099003|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
 crdrgCMG3iUik/9mNARrsEvkVfIBP1xR+7k11K9FQitSHkmrzRkqsp5V6GlNpnL1PP9SuYMhXzbeIaDONtiIeDCORWDf4LRKB2gI/LXZdfoXWb1ZroulY18/G4gXRuZL3KHTzt/9cBSU6+fcqBp35ntegte+DGBoZhaoLt0nbfY0x4J3oVY49aHM4fbdzeJq1wvWXyqgRDc5qpYvRC2mGV0p+KD2rsr+f6LN3cjJtvaaCmkwwhlx1LSiktBp31GKe8oF+u628p4HUBdBEgaNs2iwXgjmAhI3oUP7QsPY9ZQ7RBTU0SAstBaTsuQIcrb5oUqHnctfM3bDVWvQc+SUZVRPvTb6Y++K3jR0FyGpVQ3O/i4ShGRlgV8JqIVf8wYFi60HLmha15Lt4qw69BaUi/pflSUmMRJ1iB2CROayxXw5ykO0cJt5cO6QWnKbPY4K32MsGvM0tQG6ILbtw9lMJw2ZpZuZBek5TTZWaoB2n2/COpYbHnLikdM/Xxt/VX6T1gRkqNdPD8nb68h/n0T2pjBvBAcMtEG80iFaiyfg4h1PL3oe7WqDvFy3tgbG1l00sycLoG2ydJXekeD541WZnT3OC912Zyl1yh8PJONTvwdBQpURgvvDd3hXNusgPgizeS6kpAoyhKLSXkw+hMKZ1KeIGce4Kt8Jhr0UBF5p0Zo=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(10070799003)(23010399003)(19092799006)(10067099003)(56012099006)(261026140227099003)(261026121527099003)(261022105027099003)(261021121427099003)(261028144727099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?ZG8WDgxGHOIR1+HD40RrKdfwSzSAJmg9SQ4kiYOAx7q5YC5dgrlY6rvXfMyC?=
 =?us-ascii?Q?h4g9m2NLPngFYGqrEz8DXbRyOeI27AnhcsT71+ckXrK30sNRJ8I1Br/B2rMf?=
 =?us-ascii?Q?90YJPRB25PZPx7XqwEtkI3fHi1boNyfIjQexKa6lZ8Nn4DhPjqVAbfsyFupi?=
 =?us-ascii?Q?SgLtfnsBEt9wPNMX1WBod1u4ZbARBd+XuHz1KDUBDivUnV0Aub3pX8FK9hq8?=
 =?us-ascii?Q?rPheDu4hp6uAgr2MyotmHKU088mbmYcQcFHR/ZFMFbnsVtomiD87b8g6+s+X?=
 =?us-ascii?Q?GuYM1beagwOF7vAr/aEOnJsIUqOEsmaFELLRMSunfBKItL0sMsMG7OOsEttA?=
 =?us-ascii?Q?0qTEaH6HKVAa/TVSEaT67Dh2OSNM70JyzSy3oQZydggY1zhWmjGbBglyEHFk?=
 =?us-ascii?Q?tnbfkd0VoUPqCNb6x1Q4FcCD/DNmGWbO+5GWKlDRrVC29iC7/zQeDpWfjG1n?=
 =?us-ascii?Q?nf+sDKGSsroQ6DL76N2iyOZKnha93VO+vpm4s+EwFg37mMN4+8eKCoSzljUQ?=
 =?us-ascii?Q?YJ59V6IkDFfVu/Ya+ExdORTmbR3jcTmNrSfYHihYBz6jvHkHTmjp21gpM5oP?=
 =?us-ascii?Q?3zCBSh/LeP/BaIn7aOkqH6Z3TEkfsleRlslyt7vIDauC5vl9383mS08sY4uO?=
 =?us-ascii?Q?9wUdJqa+SVmZRKXRDpC+6myZR38bRtMccYZfubgsPy8kxiOlikshSm/fnxZl?=
 =?us-ascii?Q?qDQIXJJN+ybc7UWxKwGNTtmz57l2/btkbLRKQxv4v9BPEPV2Nc1+AObYpwP9?=
 =?us-ascii?Q?5e9ML7RkagN9vRpNb+owVNPzuDUmwCxdHcH17TPmq6T18lx4x2mLBvVsnJ7o?=
 =?us-ascii?Q?zHOqscA8s9U7PDQwjXLpYf5nE94SmMXEL0saaMxrAYNfZIhXELUUxda9tZTf?=
 =?us-ascii?Q?AavOH0ZI3EdY83yPjn0ySLk3w7zUhDXe/fvMbt4mmGvpxIjTQdxo8mAqQK69?=
 =?us-ascii?Q?s/UjjlaFQQNUMWhb4izyshwCx7A+U0ST1+5meQFlNkNfrQkt8reXnIM74/Ym?=
 =?us-ascii?Q?WumDoh6GAcHALJykohXuBx8OqSsd3XoNp8O6QrSyF6Vrtm75xC0JzsmuUOxA?=
 =?us-ascii?Q?Jc5V9oKQtMun4mrbk7co9oImhNSVYAZXIhBUWmWhbeZZWkBBzW7pvozFWrV0?=
 =?us-ascii?Q?YQcgXlF3C3DTY03QuPQA4UD/UAGD0SDMBVAvRr6PcY03ths6VbFWzHpo4aAk?=
 =?us-ascii?Q?Ppm2Hg3/mP4JOFghkTwNPerzPsuLSMbz5VW6q8n+4QSSl4uN+e4wuYdu5w5o?=
 =?us-ascii?Q?djGRV6SJV3XJc3WSskjg+vJctFjT2Ymfho1QllYQq6NSy6NPx7nLmbnCKpnk?=
 =?us-ascii?Q?0DlfYdghHimSyWTq529cB2615EfEjFKmSuNu5ggqAIL4FBg/iAPM/V9Uvppl?=
 =?us-ascii?Q?w0KVk3ka5EgKcDfxaN8KD5Cp3frc/Oksmhqyfl0KElNcNStYfo2qiRuqCz2U?=
 =?us-ascii?Q?vHBwvCuk3hfcLv8OMjruOHLbjQVxHhvhNqusCMhYOKEVecS6qBNRsLQ/e4Ec?=
 =?us-ascii?Q?jz+dVsn9rOUFj/Yi2uiiFhTtw5ROSwWbk0RtmR0ZDVYTEbn6PEKX2OXh4Om0?=
 =?us-ascii?Q?51AkLjdppWzIDzn2D9hQV4002wI7kZ0luNYb/JjE8/XO8EDIgqBqFnIFwtqD?=
 =?us-ascii?Q?PoDFQhqw0u+mjMZhHfkl6BcrlDziXRTRgn5ZaAdMvqy6wYRxPMgZYcy4fv+f?=
 =?us-ascii?Q?87Cx5saQ8iBDKuEECdZdOFtO0zgK8eI2spyTaigdMeUHd+A7dU1m8UGA1FJg?=
 =?us-ascii?Q?zzMX14MaA+EbxPyPpsKpmuMo+lIh1QzgsCDyACqv0dx/BvfPb4jVnVA6Fp/t?=
X-MS-Exchange-AntiSpam-MessageData-1: GA1aq43BNH2roXSUiYG/uFYH1J5jI+T/Uvw=
X-Exchange-RoutingPolicyChecked:
	MIz/nPFPFrfKanpJDDY4N9RKjCMVkj7HHnDhFn90296iOj/n3jZVZhxxafmi8cdCVp2215k1doFLNQVzyw+sOWZU5FCU2yRpfIQUtqjAxpWEWsAl1AOmte+La5UkckBoovf+5X5tKmYgucjb5Vi2HT6MzYx0PpYXftv6EUn0l14yD6BPBk4Ahwsj7m/SGXPFMJlgmab9eyzrPxukHG812pQJzkoTZRGzOLQu1D9c1uH+ujr1CMtYGkmvnuKEGjAIdt/z7F0vQ1Cgp2WvJ++WwwSjdTUthScdyJYP7QQ5iaJHlIer5qeFwfCFRF/kq2yWT2PJHsY5U4wRkRo5y/J4jg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JWg+zZmysvDEeHR15TyQX9USSGvQ4aBOhEd0l17R3rekIPa75nlExJjp9/z7BM5Wvl/ELCio7jb+qPdAohpqomuAmBZ2ojMvvLn3xsdkC68ASBgTV7ZP4X3JY4EW2MWz8L2OwKk+5wqO6Vb4aB6goHnzYkXF0nppI8KnEoTO75PXFJ4aOdSu3CIkOHVDTnTmlMcs5otYizSyCwxcNLB0FTZNZOJ9M9T2pxOv/nRhksdHFJzglspH/KH80E7EymNbni/fZ8aM4Kd1MzUvBbgb6x1F4hfEfiCr5d482/GHU3Irc8AMw4vyzWMfpEaJhw71jYmZH8talcTte1/ocpcRWFCt36RUz3xXG+k09KxQ5Epta5uzXbTydKorqZuYCrOMhcpu1VaQsgiYxtYX4FIO0TPLHkYv0ITVHp2YNbuKfrBjpEhllx0v/znX4M2ESX7uDYWk5qlJugT9mPYfL5s6XUgFhieewMN6c0fegXqbwMa+7NsxFYiP52aP4WvxVtG3M9JupK3dy/upPXInXpxSXsLUR88WMRZ7IJs2fkzx6JkCtJDxPEfWRcLR49V4x6whtCqGtSmWtJ9x678cPnlFWE5a7kfTC/ZzkzYrG2YcBn9VfK0bzE/Va3h1I9LxXxVV
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4928e8b3-5d72-4d5a-9b5d-08df4c9802d1
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 15:06:27.6769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pYk5c8qfA9eh8QQUTX9iMgFxZ3FjQXGGLBgehFk2nazoSXlExwTcLZyhCkIyu2SKYziQIGEqMH08wjxjjph1Egtq3/inegax9sfu/GvGqg8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7960

btrfs_chunk_alloc() coalesces concurrent allocations, so an empty
block-group request can end up without a chunk of its own when several
new files race.

Retry the chunk allocation a few times before giving up on an empty
block-group.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/extent-tree.c | 5 +++++
 fs/btrfs/extent-tree.h | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 74ba7dd6e560..832b9844ed5b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4367,6 +4367,10 @@ static int find_free_extent_update_loop(struct btrfs_fs_info *fs_info,
 		return -ENOSPC;
 
 	ffe_ctl->index = 0;
+
+	if (ffe_ctl->loop == LOOP_ALLOC_CHUNK && ffe_ctl->want_new_bg &&
+	    ffe_ctl->new_bg_retries++ < BTRFS_ZONED_NEW_BG_RETRIES)
+		ffe_ctl->loop--;
 	/*
 	 * We want to skip the LOOP_CACHING_WAIT step if we don't have any
 	 * uncached bgs and we've already done a full search through.
@@ -4647,6 +4651,7 @@ static noinline int find_free_extent(struct btrfs_root *root,
 	ffe_ctl->max_extent_size = 0;
 	ffe_ctl->total_free_space = 0;
 	ffe_ctl->want_new_bg = false;
+	ffe_ctl->new_bg_retries = 0;
 	ffe_ctl->found_offset = 0;
 	ffe_ctl->policy = BTRFS_EXTENT_ALLOC_CLUSTERED;
 	ffe_ctl->size_class = btrfs_calc_block_group_size_class(ffe_ctl->num_bytes);
diff --git a/fs/btrfs/extent-tree.h b/fs/btrfs/extent-tree.h
index 25d4b17d7458..037a301d8a93 100644
--- a/fs/btrfs/extent-tree.h
+++ b/fs/btrfs/extent-tree.h
@@ -90,8 +90,13 @@ struct find_free_extent_ctl {
 
 	/* Allocate a new block-group */
 	bool want_new_bg;
+
+	/* Retry counter for allocating new block-groups */
+	u8 new_bg_retries;
 };
 
+#define BTRFS_ZONED_NEW_BG_RETRIES	3
+
 enum btrfs_inline_ref_type {
 	BTRFS_REF_TYPE_INVALID,
 	BTRFS_REF_TYPE_BLOCK,
-- 
2.56.1

