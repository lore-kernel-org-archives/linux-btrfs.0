Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794905413;
	b=Qdw/sWGqSFV8YlhT/QWpbb04d/jKAkqOjGKsGWbHLa6oYElknrhaf7nVOLGrtDzYgo02
	 1I+DaO7oSq7zzIQzw0HGrFp0j6PbdV4XNdhMz0Kn6DNxtA6oJtZgdqrexYcLQzQyl4AAY
	 Fvpo7wlscD7gNEVWQc0JGZFmvxzddmveXoWNDV5O0+bRqavwx0QAQhzxj1+b7dkHUeE1k
	 IhYO6Uyg2C9H2Ggms3NGxd/y6NY6j13/WadU4mzE9u3eESIuPg4IkiOC1LbRbfdBz0nwt
	 jtYwhF3UWfVJG44S4E5ky+qh6srPjRnY+9uTI1KkXC8YSaEOhcEMPt83cI56kdNne7g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794905413;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-LD-Processed:WDCIPOUTBOUND:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
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
	bh=9mkpQUR3c8q3hSX2z9B+LNht+xxsxjN9MLuoK9Buj4U=;
	b=kdMxTHH3dbjri2R1En70rz7U3smYrLuyFalVJ8pknL2X7MZRCArHJCw6HJf+6XHEhUb6
	 Cyt4RLr8h15cat6m5OG850dy3twB0jHqfI1Z7OkyQVM1JZmcdLOzRBh1JdKa4O4IYOlMy
	 fRRNEqB7Itj32Uzmis9Ez7xu7TuT69h7xVLUddGlKzVW6u55SVQKe+SrR5pPuV/2AVJEE
	 U5Ie1O4W4z0vGtnv4a5SA5LuEHvFBXl06+6Hth3Yt8obXo0bGy8mKrgbFc5OXBgIgI52S
	 pm7OvwWts3ilLMm2pjQ9RZ6/EF9XCAcmPed80Y3yzu8Uf4rYYtjdYw2+a0BgUVtky8A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="KlKg/ekv";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=SzeGEWDp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F84606A882
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 08:50:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73F84606A882
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=KlKg/ekv;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=SzeGEWDp
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794905412; x=1826441412;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=+H0Zk1FvAbE0/Ob/lzUwmQFC3sQQf2vqnAgM4bQPsZw=;
  b=KlKg/ekvo8kO87PJX5oD1jCVSfe9e1CLKPft4h+TLwlrCQTbymvP0AZu
   mHD+0EY7iABBBH77UF3YQ1BMyFtZUmbhMU3Ngp13sTlv9fdonUvx2RsxX
   5MMVcFUpQGMXg7zHpbgmPN8vOceXjSh/giiFh5Q+E2cR4gG9EJJeLuP6i
   0famNo2cDuR/IYRKBMSEjecWlHIKPORzqqLBMhiuggd5rNRf0wjYvuOxo
   sQJPwUBYNmBQMZQzNNtxhvQovyu4gRyjuVDYCxNpQhVwliwePAqnGFotC
   DpqIRDtP+PFJIBPd7qbXug23ThCBo+5gJA1aSJvtH4a/5RL6x+lP/5LeC
   A==;
X-CSE-ConnectionGUID: q8DTTSkWR622H+LFt2s/lw==
X-CSE-MsgGUID: wg1ynKA+Ss6A91YqcB1i7Q==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="161007148"
Received: from mail-eastus2azon11010015.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.15])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Nov 2026 16:50:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y0b7pPCfvFR4UPF0U6h2xwbNkgto+ZKZgb2k91JHW7RrSugP5g6cIAyzH2FkTaaYX3OIMUz3DaZxIvjAYqifUH936GTk9C5714Ytp+ZJt9RzouaFKYMjb8l8dC9SyMBwk8nfTjrh1O26et9GwNFzY3qaOTivMJF4fOj/4bCaxAdLL6I02bipFMnmePE76EIJS9WMEya5nYyI3WyvwtwHFqstfTdSIoFbiC2Zxrk+RnAQomW3418j/oaLsuTKBgotWrYJqvOKFZ/jXFoAgfPU3hjfpjsiFZW8rz79coMtpVONWxHFa78BQn5B1hCqDY3yAgfSsmlqSolT6MuYw+r5HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9mkpQUR3c8q3hSX2z9B+LNht+xxsxjN9MLuoK9Buj4U=;
 b=sNY2/WxW8lypEIhyy63Kbz+L6eDgRKCfYU8fe+yKZEkF+nqre0wdqqQUIc/ojhkUsK3zciZ9TR/owLgMlvk5ZpQ9Np9imKvSAEtSltnArcOdZBUi/wRzzdUU8GTuQul1xqCTRV7v5ayuqPYtmG9vL+r2oHCyG5VmYk5z3tfFYRV4QRX7g+BVzBjmwid98k6suX15bcS2iOazk3tgPHXz3ZqlI4QClCu3JlNcbI7eNsTo/soanEsgPi5BvzM2Aaj7xuRZp0J1x8Mx3bEsYXKs0liOI6DgBsxZdlgWhvzIKQqdS5dqQzUtdryQpbUnhILyU4dWpgu8+YWvtG+UItVmFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9mkpQUR3c8q3hSX2z9B+LNht+xxsxjN9MLuoK9Buj4U=;
 b=SzeGEWDpm6QjOOmR0EUYJTVvvNTO7Ih/30bAgIAvRSCJJ3s99gPbzpXn47VCI8aKa6Iy9CDeIFHjOeMvZ3LQfrifL2GZEqsNcBjwznCbmm3wIJTseTUukCS2lYZuJPzIzPWU/potSAEMHmuJ7aKNhHmQSntxcaMZTiPwHKH07Cc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH0PR04MB8145.namprd04.prod.outlook.com (2603:10b6:610:f5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 08:50:05 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 08:50:05 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Mark Korenberg <socketpair@gmail.com>,
	Dongjiang Zhu <zhudongjiang@fygo.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 0/4] btrfs-progs: zoned: detect and repair FS with exhausted active zones
Date: Tue, 17 Nov 2026 09:49:43 +0100
Message-ID: <20261117084948.3848762-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0401.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cf::7) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH0PR04MB8145:EE_
X-MS-Office365-Filtering-Correlation-Id: e2c0d426-1ecd-497f-a9ae-08df4487c6be
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|19092799006|10070799003|10067099003|56012099006|11063799006|261026140227099003|261028144727099003|261021123027099003|261021121427099003|261022105027099003|261102123227099003|261009223027099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 wBu0CzQhw/Zn1tbz1GySfWHTaXZBusgOFl4SgledJLdGam2FUSlKjehApiygoyzjU6oZO173v5e9V4pCWiAYCLpMubRuxw4bqL1zrA9LzjC2PGPEOp2IAbfLoTHEhlE9m8qcanx6z6krd2AjV/Zv5ekq105U1VCZXsnO8Vx9uBuThKre9RUOM0M16VuXjk7cv8Y9SiM3ob0hrQ1h47Y3H8HAmIomXJaK+zfgTOZ6gGItwNp0JVDhzhJkFhf+Yb3f7qVsUUA+xXBHW9rTV9NhoIct8jQggsyEReXug5kjbt6W6P9vX3Kq8oGKM3CyG9mv4yonXtDIAdZOYGrxEW0lj66N2Ksnq/MchZskkRw0YVglBdD8j6pOwsgs6Uv8bmeBsGrI3nPMTzekZzelRvucwKFSAWGFOGfnckBib9HoGaBFdKxNxSq9paJJV0g+uE71sjk+vyeovNSIZ5DnT1tgvWI6TVN3LDvjWF6AkLGo6YFhGiZSZd9qALJOpgmN0QF7T0CSnLNlWA/rPPFQ2v5eoe6awdA4av+DjpMQHyFzca/v5qRABtAkoWKwqqcLnte0S9pCetdx4l0jfNN1alcOVLD5ll96iwB9U8EP6Oo4buY6dnJ6CWoPNMZ1p6mxzmIh1RMaI4RgqMT6rMkiU9oDUSVb5qdV689EJM8K/EIdjT4=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(19092799006)(10070799003)(10067099003)(56012099006)(11063799006)(261026140227099003)(261028144727099003)(261021123027099003)(261021121427099003)(261022105027099003)(261102123227099003)(261009223027099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?EQ71Md4ie6vrJbOxo+8skuYIiJWO/He1mBurYmEtIQtFXespQHj7kxkSNoiK?=
 =?us-ascii?Q?CHLhBzkcN3VAO3ZoBIQtFPcmydYqxI6nd+b7+tuM6rwpemviPL55TIExxOFe?=
 =?us-ascii?Q?VYDnuuUfiIs4OCEhVz7b/9CysJDjWLZKs/o7Mhn0d36f0QHgEug9VRnRIH/T?=
 =?us-ascii?Q?2SUX6snVQn8MRPysq0ZR1wUJ2eAzEP4cKVpHEWp+bvgBqNudxWchzFVced+4?=
 =?us-ascii?Q?LCzBPAEhUlCFlh27MTqc2HcUMFCNb/0XS0xiNfC4TUXdSvbcjvtULvOgQScU?=
 =?us-ascii?Q?JmefOtPwDMW8iDOstuNja/tTUXrbzw7d4T22lev4s+yoPjCiprrNeNDOukVN?=
 =?us-ascii?Q?4zYbjFrjOCKiPIzF1+yhLUlnn51FxOr/hhkr752pAXqAkk3sqBNUs8keu6QE?=
 =?us-ascii?Q?nMFBOmaXTyZawJciStG+O21HbHfxE5ySS2lNaQ7U3Vt/QtBqqMJbnm/IROpO?=
 =?us-ascii?Q?OL6+3n8KoeQ8FxcD/e4CYxecml1gvxFQIC76l1uO7H8A5Fj1J53UWFNjSyNW?=
 =?us-ascii?Q?l4R2XVV91wVtuQaTaxe7vckS7Jv8v9J9tkPy2IS4dstmHXiL6CEDSEjyiv7E?=
 =?us-ascii?Q?TYFIytZ8UGKWzrSB5ZlHzd0Ua8RjyXO1HvgUfZNS1Rq9gGrNtUDn/XCGdv1J?=
 =?us-ascii?Q?HQ9pDhd5xbZo4udgWXgre+42X/+Wc9gJaMws4ZC6E+iLh5AZN04FVPhQgztL?=
 =?us-ascii?Q?KWNN4LJwdM9jgxFsgp38mQC2DuPTQHl5hkFXlWWUfcdlW25rwNLMXPnp/MtZ?=
 =?us-ascii?Q?sX9j67x5ptRXQrKyprV9bQ1PK/vAxHJiILEdvVF968OSjGkyncbZ05YErNLt?=
 =?us-ascii?Q?+gjxqmpWsML7W6dHS8D/N6phIrRfDHQpBHZe3NXjtGbwkKMsqLT+QNUw18YM?=
 =?us-ascii?Q?qI7oONtwoM/DAs2/A/useNLpR8sDkD9+qNGbDVycWNkdaA7z6pyJi4xx6nbA?=
 =?us-ascii?Q?1ddUNuwlbHMES412c816JbdEjgOedHZ3s1bAhvfRB81eIACA5guYO69obLWa?=
 =?us-ascii?Q?2UPiTNBYGRtZszx5n85F+p4YjPgAgyULmiIFO9MGa286pXFZZ2akZ8R0JXOK?=
 =?us-ascii?Q?x4WIV8qxbnzXlruvMv1ZDwUgAUQsbiGjv9m27dsh4rj/fXdbbh2ni/Cs7oNR?=
 =?us-ascii?Q?tIqtxU4bxvRByo6qBgFSBItYY9hSRrppua83RsDxe8dgwFnrY79rIVIOGjJ+?=
 =?us-ascii?Q?a0EZfa1zItTjYLoaC+lO2xZpmWutmtXUafAqrbjWFfYS7hJ9iaI0vPy9dA5h?=
 =?us-ascii?Q?fQzL+tIeMxV/pFr9DwP20RxDGGywvfcKBKq+6gdX8QqT7pHaPwvlJkxgfEmT?=
 =?us-ascii?Q?3/bPP2u6tEOPdQiLn67/P1shXJC46ki7Ytluvvomio5PpBZiN2CvVUhlnSAL?=
 =?us-ascii?Q?IR8kzmJVhGODkdvciwfatfaFs8fHl6pfCinmBuGkU5f+8nLKh3jo8TDzIR+Y?=
 =?us-ascii?Q?DjW6kik7EGtIQvOYxw13GSoId5rAuW/ddWzqdFLXw4JNED6SMpsCwV9tSj0G?=
 =?us-ascii?Q?m7agfAaC+F8uM3/Hm11VF7e3OaLlv18hGARKzHUf/2j6mMTMyutv48QMzy7P?=
 =?us-ascii?Q?W4Vgwhzl6fIRfq+/oir/cSkqPdnH8YiJ8jI4TMDU2hMu+6xs4Qjl2KYSDBF7?=
 =?us-ascii?Q?tfdZij87YMgpvtrGoX/sVLFcDqEGykEdntmN9vf9jrpbFYYlSVxTf8oEFeJ+?=
 =?us-ascii?Q?MFOYKWoBjJnfPRd5ZFHvKp99bF9NbImF53ZtkHPaSBuOP3h3RZtyz5nfXV+A?=
 =?us-ascii?Q?mGwPZ+mc8a7AHjVS4afxpSwkldKhQc3EocWgx12rg+ypIrne4hmukwZ2KGTu?=
X-MS-Exchange-AntiSpam-MessageData-1: JVl12JWwAryrBEA4NeHx/6dG1NEzgiZBAxk=
X-Exchange-RoutingPolicyChecked:
	GUh4tTSG0ypJ5e6SmUmdrkTXWo9CXv4b90c1e4j25RDiWGXFYvn6qWnw9vnkcJzXwfXsY1qN9VCoLwI3fXWt0hIiHz7ddxmMD4Qj8UrVCqCSujIwth07lOBiHKbHM92/PQJ3QHKtZ+pvo2dy7pUBdnSXk6NcQ7lk5Uv8Y5G0Lv1QcPhWhonQ1f9+06DK+uKzY4sqyeuVwhI4htrAync+cvHZgP3jy1atxR6xWHyoyyJiGxKQ1d3EGFPdUsEw1hv7l97j7/m3/zH8tgngIZsA/XdHhPAxWh9enkHVSM74eUF7NX3M/4OsN5rsQljgG1bfIv3UMpifFJCztmcHNVgieA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	emMtzjQ155iaRp9yfQxBv8G8aAutX6WrfpW0LTq5C4NTEzDZAjBRBNpZqTPJ80ixC8yqtc9Nsu3aK9wxjor/dw/PFhHicwr0nWEJHidOm41TG5rM+fLVzfnNr9cocqQPyyBF+dNWD8iXh1m7BxJE4pTdm4XNFXFNidBUw1/xHyVYdw3lc7K+pczLfkJyRSsr+gbNu3EO8OccTTRNDIPsIK0/UgA8v9b+V8UUgko5GiPm7traMoRKwuYMFSRtU7hCrBtEDwOvqiW4GTAliaKiG7N2uE9VGxq4gdjBwKXGFhLZw3ajNlGKoD4y6g5YztPtteAPivCERpXFxD6ss8dbAHxZSK46/2UmCJSyv00vJrVd16rUoP6KOkVHMl2LWS6DVIMFze4ExSpRV3WkHPfPmkISkMisTA3nWuf5o+lSEcUOqhl5BgARxeoBs+Bfnqu3bf/tZoeA7nbsBoE4RjWsGq/9W3xKsxyrrDWjjyFpFSJmv8rudxxnEo8cYaqosjFcJQnWsxWohwL9tvM9g5XnQPGgG+fMvwQgmK/EcQ1hUH3XX9g9MtJC8J8XiEvRj6Ss2fGRJNM0kJCLilCJ0HNP8QG1T82KwoebjaKeJ4jJYNxYwTzc62zdGeQonrx6g3Cl
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2c0d426-1ecd-497f-a9ae-08df4487c6be
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 08:50:05.7784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q4mpq1at8QKhoGKHEQUdoWsYr/0/0VgS0271aYLAYl/O9VynXOdacVaI4tfAucGjs/zXymzWXU9kG5V8ag1ZGi475CyrIEn4nMhjZ3gnTYA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8145

Detect and repair a filesystem with exhausted active zones in fsck.
While we're at it, also add a patch to use the "new" cached zone reports
that landed in Kernel 6.19 in progs.

Johannes Thumshirn (4):
  btrfs-progs: zoned: use cached zone reports if available
  btrfs-progs: zoned: add btrfs_finish_dev_zone()
  btrfs-progs: zoned: add btrfs_get_max_active_zones()
  btrfs-progs: check: detect and repair exhausted zoned active zones

 check/main.c          | 187 ++++++++++++++++++++++++++++++++++++++++++
 kernel-shared/zoned.c |  77 ++++++++++++++++-
 kernel-shared/zoned.h |   7 ++
 3 files changed, 267 insertions(+), 4 deletions(-)

--
2.56.1

