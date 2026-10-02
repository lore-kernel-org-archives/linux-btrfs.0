Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7E541DDFF
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 07:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790926654; cv=fail; b=and2nUrLraW2yyOJKYa/196mEX4u7iv8m4V/YP+Lc9LsPsjI3V+zeFaNCEdMimcFyU2hxaI8yJjTWTflSle3xgDWMSdLsrzfi8Vu3W7p4cK63sroerxq4ECfZr3eKGFFqewCctU/nTh8Ja/hshOWY55c22fj68jNDPJPbhy+Fdk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790926654; c=relaxed/simple;
	bh=jRzW0FZKxO54GkgJ+6xF9TGOB3Vdp8KSnqV7ywNCscM=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=tpYV79B98/ry+15qEU/VM5glPxobZOfn0xdckvMGmmZhPyMztHDcBrnpp7Tl1MUl+hR4RuPzMPS8ODTmMJb3zhelNsOtxdeB7OF1slFqfhVmYqSQqc1Rvj5AeM0fPE/9T+VC84ouQEiBYTuNqoxDkOLbMSkkXiUXwp15eoLPu24=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=RSzi8eQt; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=DTptAPtK; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="RSzi8eQt";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="DTptAPtK"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1790926653; x=1822462653;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=jRzW0FZKxO54GkgJ+6xF9TGOB3Vdp8KSnqV7ywNCscM=;
  b=RSzi8eQtROMO5pF6jVBX3N06y9iPamILOHRvNgOyJnEclBlxB4j8mdfm
   TNos1WKJFCGN+BinIuC7TzobkPcxuNESTfSHFhdXfTBUkAe0olcAzD9Ec
   3I7kyGNI+IWzpSL7Pl6/s4patjadc4FIJ6LDS8sBYhIQClz0IOIFx+kA2
   CzDsGtx6GCzx3+YRFhlTi6TESvjuv8+DSAwLEQZs9nh5c2buQJeRDtwIw
   yPitST5DnPSpCWwWxpRgSsunxX62ZruVJskHzQvscG1c3UeEtuCVImpvO
   mtpeLPGpQ0j13997Al0Tey1eG8n2mv5/hwKr3p1wDteU/6NtTCJF+CGUY
   A==;
X-CSE-ConnectionGUID: 3PNE6N6IS5yYNgPT3L3yLQ==
X-CSE-MsgGUID: vEC7/bOAT8y3KkHe7eKkwg==
X-IronPort-AV: E=Sophos;i="6.27,136,1786982400"; 
   d="scan'208";a="156966604"
Received: from mail-westus2azon11012031.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.31])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Oct 2026 15:37:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NEprl1g3w/8b/xR2+ev+M4U263n3a/KoWw2m5HD2RWep6Zra0rx5kWO4b0iCxr2BOr0TH5g5EdBZD+nYsqJYrtCR8BNlvOi4LMZN/q5vOoH4fBViV3VrgZeKUCTIi4tb0SvHfYT+Nh6vPx7sj9LK+s/RVvrOCpI3FzdRIMYcMEPq4Jl3TkXtzTh1AJr0X36M1nNbLgeUoT6fswcoUtABfbFG1xGdI6XC5RlzVV63OiWFnIa7MKKqod6iTPHgVLAcBF5wXM89ZPjyXWY6l553WVkU1/DVOdW64RTQG5RiQKq5viwy24N/AWjfqaGgg/Qtw+JeOEhRoqDUsbXOUfEqjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RhXhi5uOhkm21nA+tRKsseNmLGeXfjDQuyzTYzGEQUk=;
 b=OggL9xrIYnKK/sacK8RaI8aRV5SaZb7L2sbv3/EtlwC+t7+kLsHv1lNcOFFA2Gp0q1mnlER4GHStbGFfr+vxnRiHNPneCGYQ6ng1TaRuRCETzWh9wQtxye1erTr/uD/nVqEiXOXkpP9CjWC0/9883JJG88WsnD4fcWHosYq5mkqgiq1ESPe5tAbkuRY8TLbwR8ynag8b/Io3HNdKpikXHFjebM3zqZ+Gneklt4aFllqzSv9U2F6avnS2pW98OnxG1MoYDxiFKIsdHLLAg48xcb6fSBXe0lgUirZQOMsbx7Re3srYXSCqzuJjG3NJsGsI+inDVECt+n0n9tyTXmbpfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RhXhi5uOhkm21nA+tRKsseNmLGeXfjDQuyzTYzGEQUk=;
 b=DTptAPtKywf0/WsEaG5ezMNUDk7crwj3QAXAhoTckcNG+ju1KETesfGTQAvhz0VVhS47WY4CIr7jwOF+wgNO6lB22jbw2eD1mJaUysQotmxiJvNImFTOWTxhH99pUmnPibouDZVWZWp6/wQHlMXHfTnZZWAqlVW00RxovxRl8Y4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM6PR04MB6283.namprd04.prod.outlook.com (2603:10b6:5:1ee::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Fri, 2 Oct
 2026 07:37:25 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0472.016; Fri, 2 Oct 2026
 07:37:25 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 0/4] btrfs: zoned: LLM inspired fixes
Date: Fri,  2 Oct 2026 09:37:11 +0200
Message-ID: <20261002073715.2191177-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0062.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::20) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM6PR04MB6283:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f0eb67f-fc28-4bfc-6035-08df20580094
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|376014|366016|23010399003|1800799024|19092799006|11063799006|56012099006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	TI4uj0e2jXEpSfU4BsTKyLOVUQBMU8ZvmqxHR9gq1rLADeDjw3zNeY8RD+eUv/5aIGuRLUkCdfs0SPtR1VPPTRlva9eIfz/0dG3tsxOGd2k4FsQAcOJTXOzf1eu/XKK3xyMPQMtRVRQq3tCgZMGHG9DwU90a90s5flOQTq3da+AHmoP4utM1/jurRQrpxbZ73h1+BgMIopuSwZxy9CtFfKmuj1ZMEVWrj9lSnWz6gmP2BwsqYNTDBJQTelHmJyCho8o+uPT6Q/T2RrsZVbW0BU5D1N/HB/N6dapxqPGsNwXHSNWvmxAkiPkxAeC1EmQal+HbF33Z+6Ao2FtiCM0sVf0N24GKioGTJ46eLEWnFeULhJxhLXfYhWZe+VJddTibeGEYZFzRU69A5cEaXOvko7NKSnRhIq7pRighaw4RTNKn5u4keT+nkLddshneUL4CkmiH7LDppihBQEuuADsYzyIesAMyQo1IrSzvQQVMykHWbswqzjS+PTGGUh8JI9Clp6VgzNNYtnHwVULAoljck83HgLCN5+Rsacy/rzNPNxaRmjbQe8uoYAjDtkfo1CvSRVzFiHEUVJ4+sslFgdHlxWf/dVdd7cqJPwnm4acoDhBhREShc0g3WqeNq5utZMM5r9H5RKsEIwPxdR0t1JdPiuRwbaMEunPhHHZv/ddvRlo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(23010399003)(1800799024)(19092799006)(11063799006)(56012099006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RAaqZ/Vh12DLSWQcP77igzhePNI0e4Zyb4FDBrhHbf9PF/5Ud9wq6uHV0tVE?=
 =?us-ascii?Q?ci9v4EvMqa9eP8s0Qh6oY6jHLBc3dsNCgzLIQNYC5rsU/GAd4McQbPfXgsgL?=
 =?us-ascii?Q?VhOSIlPj5rUp4EzHAj45C1Wx5RaxI7Yit6qjc1MnlugYDhpf5Vgegan9KzKM?=
 =?us-ascii?Q?7muA8VYGUEvwK6b43fG9Q4m73zgZCfaZrcMEkcEXGu/mfyKizVO7dg94ov44?=
 =?us-ascii?Q?zgDfgIg7dUjr+Yr3bGgd6fXR8xSMNzki3CTYsn67nV2pyeooe1SscpYYauBR?=
 =?us-ascii?Q?Y/cyNchndofn9hlkhMYCGSWmyAr74IwZzh3eHiTDryXagFhSBAB+qLMkY8Jt?=
 =?us-ascii?Q?p/ilYd5PzodBlCM3fYIT0HC4ka0Z7yA30aP0ml1XmVXsiLQurDf/3L8sWJQS?=
 =?us-ascii?Q?HnK1nQi3KBhp7nu1LWiMDkqsDJy/snQNXA8n8YakC+Ex7LbQZZO19VJERjkw?=
 =?us-ascii?Q?A5/wwEJFFeuHZ6ccmmfJ86tjzIOBHZhTTbp2LEWuPVixrYmT7nQ2vKi7fd7v?=
 =?us-ascii?Q?CWPSQ+/xRnZbq9LRVpKYYZGsnExtp6iXTSPgQdT1sFHkQuJlLWjOsmgHRP11?=
 =?us-ascii?Q?DwbW4T8qSDdbYABvs0Sbm8vRHKypTOoIKSGUbUCq24sz0L6DFctywvhyS9bQ?=
 =?us-ascii?Q?PqmxCTqx+O5dU+/j6EWfhEqV3veiYzHdiHRKMJ261KUrKx1MX2YxZ8spQai4?=
 =?us-ascii?Q?yeH2vMGvODg2raJWohJt9x7vnu/9gSjJbJnR3QoGIzY7+fu/ild/MLhXj/Ao?=
 =?us-ascii?Q?4afpkn6TTKaHRxHT6/bzeLsAx/KvDBogv2ngspbbiELObMYi87mdOLErfMKF?=
 =?us-ascii?Q?ut7HddCOvADDym8UtRlxUi0Yq+209L4hLK/6TfHn7fpVRL1S8LOZHpNi/2Jx?=
 =?us-ascii?Q?uAJj46/7vmSc8vHysJ1tAexOAqRgQViQ3iDWfydDbjdBDVwKeRGvdNm2LmT9?=
 =?us-ascii?Q?aHG0T+jr292OBsToNUhRTYeHWfiTNvBDZfQS78p4SjqBmngex6b8RoKN2E9x?=
 =?us-ascii?Q?fKic7dexvq9h1L3yl40JLXyiJyube+SLZ7RdkIJRi9lE5JI/5nYpNqY2PhrV?=
 =?us-ascii?Q?pAq5lHQVjYrIjjHhrOsnUKbN9kfdT0/zskHh8e/H8xXepmQaBzoO/5QaNb/F?=
 =?us-ascii?Q?/LgD8t3RfxGqqOdhMVx8p3V08wKBpSvCgjxeECMyWZrVeFQaQgU7Q1jYSKl6?=
 =?us-ascii?Q?sSJ56b444KmOT7UDn8lpUavcJvJWChQrlSngZJU46vaPaiLVl2CPEo6esFvx?=
 =?us-ascii?Q?m5abmStUhr4VG4L2VFh0lIOjohOUP5YUkaIuWKhgypJ5AHWnrtHuYHUYpHlv?=
 =?us-ascii?Q?E9wHmof2JzJSNv4SjScrdgg6agdbRvlkjjIU9qjOnnkDt06pRkRhdlZ/L9yp?=
 =?us-ascii?Q?gwXELR7ydxobuaE4gZ2CD24Zx+mYVv5Rfr1NOxBtfS28oqIwvmzo/cir0+S/?=
 =?us-ascii?Q?DE07vSTXs3ceY6oNphloIUcFRvAqxe0PJTMbnQeMA2i63eoZTURcAKo8cR7Z?=
 =?us-ascii?Q?iVSdKxi6mRpF3ny9fWwIi9O19/SRzM8Gi51WMnmh9bVHXxZ781sQWamwR48A?=
 =?us-ascii?Q?uEyvrrZjweDh9nMR/wlf/XPuQ7EBQVP1aLzhpJzZnUk/rdIZfaTxOoVmD4T3?=
 =?us-ascii?Q?sgFPT5/JXRzYNr5mcFvrX9BCQUOUKMDRa/m0KHmFbXWUaLu8/Es4vy+aVXtZ?=
 =?us-ascii?Q?4knIGZ7vNj3LyCnkjf68hjMtmWQcZmGLJGLhVmJgfT5b3Kr3JuMrBRsVNcR+?=
 =?us-ascii?Q?oAo8cCziQM3xmEUnqoB/2WnvH7LyOWKX0BWaxjxe+f8+Xh/vceiB8UbmTt2R?=
X-MS-Exchange-AntiSpam-MessageData-1: 50bfah2uZ0GFsmPSlUND6g02HmquV78kSK0=
X-Exchange-RoutingPolicyChecked:
	IMzTzCXm3n8gRTjFiffHZZE/1WknsMdUYapIIcd2IBbpOKjDab9W5AZIOJ/ou6h8+sJ2rF2vWsxl1poWgKE3o4dUzdxpaPwhhBQizwb7iMEeHh1xsXvZ4zT6V3+WzmD6YbjPFE9+9fyjw6lCoei3pYqiJjArfHP+VNhJQrl0UL+7Gkri1SPUWpGY+NkNjTihJJHHBKkWt01r2SN/IHDlYfbb04PIBpiVvcGTuVCYGKmpEj1N2qQqujMcgvFD8I2DGXfSULUa6cc/YQ5lT1pUCFD+2fACQzhW8sBfUhKzAD2ho8gz+RqXRH1g4xz5LdAgUCP0Vdg4QB4EMJSINJI2XA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	f1IgpjE52S/0T9Iq9bUsY53WxIrEixgDK9UmeDEAaMTDeJORwJ3eIggNL00/kttvYZlMGMws6rZZDsREYAQF2Bt7h2pwcEunbhiDQ/Isjc/mJDx6R031xbkJPJCkN3I8v+fUN3dMubsznDf4o84lr/cBvD4NeFijYN2YiaarCnObxSvBS0932oGV7A5cJQI/utOgML894GSApqbzhQWtgC7aviSDCLzugGWVzGoNilEWXkCMeXwc4rBk787FU3V4bQs7BIlGlkbZfPzaGbcsIt8vW8oMKZ53/kulfR7ihNdZv8/fRvGVvIH4loHJhmbODIV4QkIc3l5yHLEYxVEU2TteagVu6qcQV3jRxyjF6JIbciAAf3Tk6HKvB8Zm2Lfb2yrJFpjfzMBotzpSqrP5B1m/VzKBOatDahac6+ywLJ6qqsAQfQlNchuKhlSIbRacZXY/YUzUNOm0utVxMYS+RtY92K7Fc3G6nHFyIxfQV46bH25KE1+H18PWiVLRuaPPVpYNm9xkK5OxrRZaGGnIyMCi68Te4DcFJkFaDY6BzFKG+GbMwUJzzS2zxKIYuOVcGDs42dyNEndDcSa0DOSSqHTbRfNFb87TwP1JozlTSXyQNByKIVIMLZwqTtstKH3j
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f0eb67f-fc28-4bfc-6035-08df20580094
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 07:37:25.1496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NOMzkUiOIhPffkdAXS300HejIzHF0DiyF+IG1K/poZKS/ni+JWv2IxJISI8dM61asQy5/bGeV1vootmVNGi8EgDNWTetMso9T8NIKQq5xGA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6283

I got inspired by Darrick's "LLM inspired fixes for XFS" serieses and
told $LLM to have a look at zoned.c and find some obvious problems.
After sorting out what I think were false positives, here is what I came
up with.

Changes to v1:
- Add comment about the possible UAF to wait_eb_writebacks()

Johannes Thumshirn (4):
  btrfs: zoned: only change active zone counter on successful
    (de)activation
  btrfs: zoned: fix possible UAF in wait_eb_writebacks
  btrfs: zoned: requeue block group if zone reset bails out
  btrfs: zoned: avoid underflow of bytes_zone_unusable

 fs/btrfs/block-group.c |  2 +-
 fs/btrfs/zoned.c       | 67 ++++++++++++++++++++++++++++++++----------
 2 files changed, 53 insertions(+), 16 deletions(-)

-- 
2.55.0

