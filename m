Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E4937C0EB
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 07:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791876722; cv=fail; b=R8LNocA2Nd7L0mqUGLP3fxg7cj9wORwfXqsU0o+SLgGAd4TRkyjMxNeydM4kZ3ciSUOh0LjPFLGYQYf72En4kK1NMRWleC8PbetPuB5ZjUTFqcHK/B36+bveLw1KXIQbLf1ALEZyIsyAyn9OE43pwO2kTnaPcRHF3ohB86ZA1jI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791876722; c=relaxed/simple;
	bh=B9KaqwQt30M/N/8CPD+2FU/UCc9hYi1pUJEvoaVPjQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Q1Wu9qoqgppjELeubyc1ZAPnX9HcxKcJRxsJ7eaqZ54GApk3N4JZ5y9a4cX1ITWyHHsKevwHCLoUw9aulZA8qvikpRZ1giKsPMqxX9E7Ma7pn6MUKI4GPU9Cm45JqPCNEK5mxILObmqPNsUXHiZjm3x5r4KBhWDfO8FWRovl/t8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=nJkN/r7N; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=AG4UHovh; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nJkN/r7N";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="AG4UHovh"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791876721; x=1823412721;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=B9KaqwQt30M/N/8CPD+2FU/UCc9hYi1pUJEvoaVPjQ8=;
  b=nJkN/r7NzzBLYknebOr+zdniZGj6cFZQXBBmr8Byc5N2iYzjTbIYaiVM
   LCSZDA5w1P7R8R6bLeG0BniMqGWv1U9RCN+EVI73qTvjWR0B2KauAmY8Y
   +iLdrBivhgZha4QmJC0FDf/2Djh9f9fsKXf/SRvE+lvz56Q9+kCNMEaSL
   GLMtVzRX69xQJ6Ufw5XtUjIezA4gyn7U9ohd93eo9f9+x0YoXOWmDOXQH
   wgAmNS6JKsSrnE8aHwam+AyyrFhWgf5pDjt0SFJjQTOL1NMS16l9poaE8
   pa3DSqE201SeL9oqLrrxFX4Tzp2ow+W0MlbcgrFn0n1/cJhlITeFdOfBk
   g==;
X-CSE-ConnectionGUID: ddanurFRT16FL+76QLYqog==
X-CSE-MsgGUID: OfCKJL/YQ4iQxyk32KDCBg==
X-IronPort-AV: E=Sophos;i="6.27,155,1786982400"; 
   d="scan'208";a="156364540"
Received: from mail-northcentralusazon11013046.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.46])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Oct 2026 15:30:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZVyuzeGkehtNzLqv+uFmbs4UIXOHgbY00J9lYpYdmSVegALcbwdQL7GdRn3pvuL6mku8h2FA1B3S0jHZJHM6Zabzg/6Zb3T063e6uCmWQLlQyuad+dMTViqfCMeGMMtagkk+xMNSzN/qLHLd4E+4m4pMe5Iy0GscPrOcLYOZZbQF84mWjF7YlnaEuTeE4r0rWfpgN7aUTnM1Xm2MpzE+zvHc58i4qIG7wPwO+Qm5KKlNYqr0FECaFVnlOzC3k1bptS7yukxzCDSudEd4wStzNxi3OTPB1cFu5PMuKu6JfC2a2tV+4LCsFliOR2UUPlR+VKNVghf3FexLHAp5auuwlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b1w4FR3ClHtC7lc3Ltvm7r731XFoLiXgHtYrUKH69HQ=;
 b=YyFJ9l0yu2TrSLITYgHZ7qf19PM0x0ioXsIHWzSC6Dg0JgXiZ78eVcpRDbqa+F2SXPFIwFL1uhPcQAwU9ILRW780QLH6O1SctTCKwxuf0R9caEHCj75xkoWoFzgDPiiLt4XxxX3zpCg4JaigpR9sc4ksdBYqBIgbCPFVQwQmLdPbbVBtVK32Gatavt2EfqnYUlTNe9h9qVLg4erFVLx1mcgq7dKPeKpAkpXLKkuTAnL/noS8Ftf00oSBMq1JWJdnJNTTJH+tlIfwQ15qzSSW8b6cj9FvtNr7pfzSjQcxlOuTJq2ipHiOgMSEmxGPwOKSln79lXPU65wyzUWGebjHKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1w4FR3ClHtC7lc3Ltvm7r731XFoLiXgHtYrUKH69HQ=;
 b=AG4UHovh0nBNrUkpuOZt0l159ZLPF6yLE2Q11bD9Vc/4+BALNTjh1Yjig9KzA9eOyde+XQYPbbNlw8/hk/d3pyP2xE/nGnHnLi5QChrj71Yfy3zKkB4PzPNeS7AhJu9x5bY1V0F1MMW6IE/bVptaGb3q9Gpt17qx+BxXZSCLR4I=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CYYPR04MB9031.namprd04.prod.outlook.com (2603:10b6:930:bc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 07:30:29 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 07:30:28 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 10/12] btrfs: zoned: use plain mutex lock in btrfs_zoned_release_dirty_metadata
Date: Tue, 13 Oct 2026 09:29:39 +0200
Message-ID: <20261013072941.424029-11-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013072941.424029-1-johannes.thumshirn@wdc.com>
References: <20261013072941.424029-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0017.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::27) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CYYPR04MB9031:EE_
X-MS-Office365-Filtering-Correlation-Id: 25a36564-d59d-4d4e-9779-08df28fbdb06
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|366016|23010399003|1800799024|376014|19092799006|56012099006|11063799006|261009223027099003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
 KKmnggm4JQYoIvShE15fldrTfYtoyeCBxiJMMdutDnQPX90Y/LmxWwTmlPpX/IVdIKUUGDSCd/bUvDdlBTadR/EFZ86dQ8reIfzzeegUGBWROUVYJfOxiuRno2MulKbgU0H1YiDzz4CLPjOlTO7hDgWAxW3Sem2Mm/SMcoSFCV4T2+p/0fQZicdp+faYhrNX6NSbXtJv4Eq3rnOzFa6PentZ6U1Mc9XZLb+K7lSnaf4Ru44VhFg7MyTEnTWMYjxLeFrfWPiNenUrkeSTAJDzVAJJPZsq28/mtWX4nxmC7Y9twto5RVihfAh6MGvk+MbJ+66FXZkvbDcyBJhK4oIWcZoLCgIWP4pl9Z33vdk4zSZPjDMHAgEEAH0jqu6TdvdN/HgZLbb2JAK9unKYbMm5Wx6KwDVnb9llvVqQHT6MdKzIwOTxzb+hP5qJ/0OuFxO3NYJ+nYTniSC0/p2oKwckjSFLEikBG0xHCHr1S3B7n5kqxDwt/nqcX0Z/aLuQ00qEJf3JnSa96TdJrTTG72GjExeNxrVCjti4NyrfLnRIUFv01PjsJew3r7906nipuchU1k6KC4KSQ4AnEsILmRa6eSagk1NHjk6k+P3dmwTm/zHDy/YMdaV4ebzbPvVv2siK9DsDTEVvPYBuYJHP1fj/Igc7eZzt18u4qiz/BDqm38g=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(1800799024)(376014)(19092799006)(56012099006)(11063799006)(261009223027099003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?BpE7piWhUO4aGSVvNjuH4w2dIcBKvMiGO1R02fsr554oVcSvYyALjeMSosh5?=
 =?us-ascii?Q?97KdDFFTf/TD5kVEx4loTmNgjc+q4z1pQ6ueosgQn50xrGitHg/XSaE4JKci?=
 =?us-ascii?Q?BLO/ADWMvb2+l3w7VR/qgcjSds7BAOjdQLCoiO+VH+hb/HgxCOP5F6L8SYQp?=
 =?us-ascii?Q?DjWp5Pxk9WKwzD7vfX2tI1IoxWOYtVWiocRizJ6V8lCfpvDEcVpp0xEt3M/o?=
 =?us-ascii?Q?tdP/hyXkgKiShjPrVs7UMNfzpPFwFLiXZ857Eoz1eAcZvn1B5IWN88HOkWgk?=
 =?us-ascii?Q?nynSYt7StKpnSpmWvLWf+JuHA72zc/dR+FZT1S8J+x2pI8FwcgySY/Ggbmk1?=
 =?us-ascii?Q?XZPM/VVzwlYVoijisqxufouebokoqelMr8V+rdaPEMqvHIT8Ot1digWUmuOY?=
 =?us-ascii?Q?Tl7/7FnjJ5fyOtv2xV0dTBrQWtxbesoiXzBHuM69O2BsgZt1iytzr6QCQfch?=
 =?us-ascii?Q?8W+xDK1jb+UpCIu9ixYZ+TRF9+RsGz1qK+W0CmGa5MeOjuHDyvWITttj7i2N?=
 =?us-ascii?Q?qHwz+fypNsX5pdaRpm3CNQbvq3RIz/5KNJ/4NJw/16QJCmUtfnRJHyNRE8mV?=
 =?us-ascii?Q?Fr8fbNbqxKeoYSCx6tOklA0hqtyt6/pH97K1Lqh+nu4/OckD5jjg/imE6mNI?=
 =?us-ascii?Q?f3okXRac+g+gxC6YLWG7q8MjSewEBOe+je4j6JR5P6Z+1MkmG+0nFUdET21h?=
 =?us-ascii?Q?9YskqPxoFmEBUR4GITzE2TRzHObh8eKzCjBJY/j6m9ddc13AKWucf5XpoTKj?=
 =?us-ascii?Q?t/ST1HEdJFasEc1CQQH9FQpEru7TtZ3229VIMa//M+R3+ny0TEZZduxDG0aF?=
 =?us-ascii?Q?R58Z1636CNTzyJzsM9lwFE7pOUb5Ahr942AvLAQPssvTsRG619KVeZ4EFuKB?=
 =?us-ascii?Q?YWEtDfjEjoCtRwDxPXL7sWeh376y6KM4QrzxfZ+TtcKDbHgq5C8zS+ZwDxI/?=
 =?us-ascii?Q?h5pfR3ECgI5AnpyFIAX8IBba1wfLrJ0fEn9LCyL68kVk3+2QRlFwnYbzYrYY?=
 =?us-ascii?Q?PG9VTLOMYp1oc52qKxBnLNfGZ1pcDePo4yA8dW2HHTCtbGF191E5G/u8Nth9?=
 =?us-ascii?Q?a7hOxcJmZdGIO/n54RF9HOqY0Tac/wGy5S/RI0xwR9UErAvx0tYLAHqplIhj?=
 =?us-ascii?Q?B2/B16GDzaoz86UCcfmv0XR0ckUR45GdjHgxD6trBvzy4pFhHsTOlWF4itfx?=
 =?us-ascii?Q?wmHSKswXWUj9695wMs5+wMkPTvNiHzBkdaolsyM6umBJu1hpBJrZd7zeVoBx?=
 =?us-ascii?Q?U4reuu0IMUkT3p4MZkt7vFhICRGBV++EzQE1tOR0gxpOWU15jTm38x06Vy7O?=
 =?us-ascii?Q?L+pjitDQMh07hxXqssuzdR6to3c0t0wpMp+fa7eMmRouPJYtjtYzbRk2xh/m?=
 =?us-ascii?Q?6Vh9SCSxczw+A2HixFbMKpRZ29VOX9OJkJ+0+7buorGJuISwAcVuLmnX09iI?=
 =?us-ascii?Q?MKzboNgduh+AOezNoFN6qRxeO4n7AhSgvLQ7iMobZy5ghA/q7NsPqsF9k3PW?=
 =?us-ascii?Q?A6pIaVUFkZdB2oLDylRx0BH2jhLoeqHLPUXPP3SpHyZUBh7NfQQBHcEav6k4?=
 =?us-ascii?Q?oZ46R0J/MMx5Tnu2Pl2mXLeE9RGn+zxAbIuIFa9q0DN898POlSjrwtrSxzFq?=
 =?us-ascii?Q?dQWlzUPIOLcX/W3sknOrE/Lmjkw8kvMW7AiwTI0gYw1SJ+3XHXXmruM4cNaV?=
 =?us-ascii?Q?kHrV/VMmwH+04Fxfdv/zMb2y4dRB9U0mJLAB501UudxguZ754YZE1tknM6/y?=
 =?us-ascii?Q?inJ0opv8eTr2O7xvcv8N1P2a4pHfBvtKz0ias5QVOmIrYlXGOnpruA7CL9h5?=
X-MS-Exchange-AntiSpam-MessageData-1: vAeVYM8qq4vi/hlpZqtfTx9ZzYT2T4MYBAI=
X-Exchange-RoutingPolicyChecked:
	cyMvlgsPXwbGYN5+6ygvVqxrz6h+6VxZInQ30zQTcTWVFkAVlWwJy+CR2gMOBdw/P4tf1sxqL4nOBsZmp/pubk0B6S7gcc66TGwZToBCfCG5MzZP5u5qluQHKxSkBCxybEgtvt2KnChWBBSORmsWEHEcn/+O1cpykc89BqW1M1IrsGZ7Ns4uyWZEsflfFqGCcnslzOQFZvCDsQ8ADek0c2bBHN8mhyk/zLb4rLHb/f1T1X/vhQIXkRLpedd02hGkDbld5pnfroO3cFt9vb83apO2wjDucCmZKJxNpC7PqiY3ouTISW26/sDGUdPVw3p+0KNswIFBmQkAfzhNZwPV7A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/arwroPGkq052YLPLHYCEX6pDdNM5CDMQxjjH4EhP9xq+1KOBM2FDhUrd0luPwHACP2LN3AmHm4Y6L2B92FYow/m1Nu9VgdUZJl650W8u9wo1A922JJKz2HGCsuCbPWjFPvHxLwSv4atvVLvcPA8HwoBjRrqUFAXEVEwu5M/zwJVIl3HzGWe6MKKgJQKUTtiJUvGIz8Xbz8Aql/LQTKtq8HquBWi+9kQvcVfQxiI8wA2nwJxSu7siBz9lg5Hjl+EM44gOjKX97NxlAOLLsP9U73SW4dWHTNGf2An3UKdjEopz2RmAZHCsnd6ZKgw7lKmrZ0JyRoGmmq0GHNPb21lsIU7XjtTAR/8Jr05XmIvwPr0g8eXcpNsft4Wp/FnJ5+XUz2YjqVSaV0DFd+ekbiYUUv4QKzTgZo3GosXJxDk75YzYFofMTqkMRuK8qgy1ydkspIw99PogdMmLek+wbm2CITFOg3c4vpJ+1HuuOJ3+orfTKqQcLNMUEEeGZdVxlc3nUXk0/Kj0o/AOshUfAhJD/TDz26ruDAdnh6cHjvZLwZip0QdttPkr750gwftrXkyC/mMQDnx7+eRypUracLbci1/izLzTSiF5elisREGecqhq87/yG8Q07wLKCJDdbU3
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25a36564-d59d-4d4e-9779-08df28fbdb06
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 07:30:28.8829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vNuxKkByCOEssUIXAqRdG59iD/kBFBivsGCL+BOZtRndzE4y6qnreYC6C1wJUN2Ypmd5+/daATgiszE/q4QXlQ6xFBRKCG9EGbfW/bZaaCM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR04MB9031

btrfs_zoned_release_dirty_metadata() already bails out if it is not
called on a zoned filesystem, so there is no need in using the wrapper
for taking fs_info::zoned_meta_io_lock.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/extent_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9e3166a4c66e..b5d9e29bc5d6 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4224,7 +4224,7 @@ void btrfs_zoned_release_dirty_metadata(struct btrfs_fs_info *fs_info)
 	if (!btrfs_is_zoned(fs_info))
 		return;
 
-	btrfs_zoned_meta_io_lock(fs_info);
+	mutex_lock(&fs_info->zoned_meta_io_lock);
 	eb_batch_init(&batch);
 	while (buffer_tree_get_ebs_tag(fs_info, &index, ULONG_MAX,
 				       PAGECACHE_TAG_DIRTY, &batch)) {
@@ -4240,7 +4240,7 @@ void btrfs_zoned_release_dirty_metadata(struct btrfs_fs_info *fs_info)
 		eb_batch_release(&batch);
 		cond_resched();
 	}
-	btrfs_zoned_meta_io_unlock(fs_info);
+	mutex_unlock(&fs_info->zoned_meta_io_lock);
 }
 
 void set_extent_buffer_dirty(struct extent_buffer *eb)
-- 
2.55.0

