Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDCC2EA75E
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 07:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791876721; cv=fail; b=nWDhl0/TcWuNwmTjcbno4lY5Hjxo40eGtB6oIoMbnswx67VtxzFnM4xV9iYq99LTxT98hrXo3GcxCjmSg1MI/WbB55g+kR08eieRK2gg+n2adjS+nh038sjnLym0moJb/TxXgKGy80lobSYsCdozmIEKRlclDX4KxIuDv60XcL4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791876721; c=relaxed/simple;
	bh=6NwxQpMvhNPOEAqN83F5B3PMai19jcUcolr1AZcoRJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hJ2tB0loVNCy5D4wYvmTvtFh8lDOlrCgdDlxgCkftddMEcOHZxkNC10IswDdYj9UwUvpYyUcPPvWp0FLfFV5my0+Yq61ndD4Kgc7XlNoIOrNCWpyppGxbl/c8YPsZWd8adAXAHG1MsDnFSQlCX80eM3ySBDi8vnCYDBl6m5Or6U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=KXQm4LNw; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=I3RqT8iA; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KXQm4LNw";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="I3RqT8iA"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791876719; x=1823412719;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=6NwxQpMvhNPOEAqN83F5B3PMai19jcUcolr1AZcoRJ8=;
  b=KXQm4LNwTUvf1ALHdhxw9L4rfursIYGt0Kh41ZsT/4XMX/MiB1zPaJqm
   RhZR/l9YwL1CjCmJXslXH35FbSK3SOs9RHReyU9MJ9ejm1aP2pqB0aFtf
   LziTjXs6ajMEt0ZPlEA/UZ8Yb/Z/LDBrA8AYw5aq0wJQUPVZQzFaGuasQ
   edTM3ERyuzV/E1O89HKxGxQQ558Ge0lf/EWcgXDSNJe6fl2bQf+6zNL7O
   ctNvLyHZQkQASu6riiNLe0t71RgoifrNUMKDdU/dnH4baazmHKZIsGz16
   CX4YE6gnOfVKrmSYcMgFP/fgUWKiidg+PGrfx842PNSgfHgKzNk4+7TCq
   g==;
X-CSE-ConnectionGUID: zCMTR1yhQZ2srIFdyVkHPg==
X-CSE-MsgGUID: duPQ0dYgSpWH6mCij1zeig==
X-IronPort-AV: E=Sophos;i="6.27,155,1786982400"; 
   d="scan'208";a="156364538"
Received: from mail-northcentralusazon11013046.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.46])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Oct 2026 15:30:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iOPceo+iS0lQoNfHcIN348qUOap5C0yvbepqlnxalmEu1OcfoeZ+E4hxZnS9nnTcrrKCYwjs4T0KZTH2P58nllTilZRaV78di9S3yz2qsrOf9yi7KQMMhB29NWRTFIXqt6paulpgOx5OebvDXc/WvFPjc/anZdDyhsgfoIU9dH9xrU/2ZFpC595oJtGBTEVrH4h8NJOu8u+qBtpmps1EjX6ZKD7Y7B8Qf3uhPL0Qmf4fpkLgTi2xmhlz5U9fTzgWrK5Ma1Pw9nmkTDieChZRUEGuPtiBca1umX3vnSSrdySbHKZ0TA5Dc6DSeuDyW5HbJ9GL6YRabJLbgFU4/1M/bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TWpzaF1KrB255RxWm+nDQnKNC9uyOIhyXojfeEvm5Qw=;
 b=TX/3nSaJDAiuXVCoLrQ877CrSVizpSgy5BDkqpgxvvkjAUY77EQ26N120RWtfuG3GI03iYJLJmZL+KTaw12EvOG5wTdvBrjdEv/l7uJMCxLy43UVc2QttM8uvRhLhN1fbP5B8XzsFQRaC5vvlErgRc1Mm7Q88ByJ4Mgvi4nNSI7HkNrvrCWVkzEjryWTDqjTdcfPgiKkV4O7okDSq2RfLJiAPaKA6Gowo6n3k/D26/YJsudZsoQzaMU0wDTjXhJPNgvG3jEClp4N8SIdf5DK6ySkhuN4Yj5qCurlMpueCiy4SwC1Mo3U62qZzCwW/ewc7Yf+uYz4DULc0GOGKbKF1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TWpzaF1KrB255RxWm+nDQnKNC9uyOIhyXojfeEvm5Qw=;
 b=I3RqT8iA4FuE6ANvOUD47rGYCep2sJrHb/xs/lSH4YOnT+SFATb4cVl/Ssdf/BI2mI06kZen8I6u11eTC2wSY04uHhoe5icH/HKCXJN8ubZibektQ7SopASsUtxGHX7RQzVF1hRbDhQgAzrol/+y+aQd+bQMobimMdbjXtLr0h0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CYYPR04MB9031.namprd04.prod.outlook.com (2603:10b6:930:bc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 07:30:27 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 07:30:27 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 09/12] btrfs: zoned: use plain mutex lock in check_bg_is_active
Date: Tue, 13 Oct 2026 09:29:38 +0200
Message-ID: <20261013072941.424029-10-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 831afe53-23bb-4ae8-6e44-08df28fbda21
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|366016|23010399003|1800799024|376014|19092799006|56012099006|11063799006|261009223027099003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
 k0m9nzINOWBlebM/5plDN6sCBN1YioFezd6nND+r8Z6fJtVKW/MRMKQ/G4UMY6+GQjNOags5q0tWYVW/Tx0/SUJnTdPv87jWQfPrGfbwh6w7LeU6UOmOQzuNiktbSVwoQk7W0F+k8hM6UED35xYxTAxf3qpzEBtcHIKY1/uBbiTkpxgqBSzcw+ojMEXOcGcDoOF9WOaoKJ802Mzk3i9loDyp/th6nxJdGEt8wZB3my5RAYzMrV3+UbfcNloSNPalSHfiOBGLYPHrSVeGGasOQuB4QNiFweGBrc/rWaji0ShuRlfLZnAt7oR2ekIjwKSkMYT7+NjHN3xQD6rWmFG654PIy9u9nFgwafrEnneWF3ifNnUe6Y1YlX24YrjMP0BSd1x2pFgqujhVevvyKUVJOeVES6K4tPHZt4DRl/6Lvjg45gFR7id3OhBO+Gz76FUDG85Ecv3G8rjjWegUVuGoZl1BGyDoDMFCKzvYV3MpBeLF4PHBsDnIx3n9hq6G+MgrxjeGlPXtdzZD7G6sM0868vxI4eaNnl/NWzXvJWPePe7hpX0YWR9wTFAfnzhvBnfHQWU9rk0n1D5wlGkOBzpdKBYPdexYax729/Rh86rj1wIJhPzAHvSQgc5pFTUlhWFZEZHi6P8tYIswN3Ip+21ETwbVs4NFEYjHD6F46PdNEfw=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(1800799024)(376014)(19092799006)(56012099006)(11063799006)(261009223027099003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?XhyPLzEnNq9W6aNv7hjZJmXCv/4aZH1ClHUUMu3bN3vrT3KyRphRvRrntiA1?=
 =?us-ascii?Q?0fsCGb4KO0LqyhEEhgF0L6u8XpRlx3FrdC7w+czDV38YmaU6bSz4r4TsXCbW?=
 =?us-ascii?Q?PLNnMnRDvz4fIi2yc5+CGNeiAvAe+pqWKqK90qDn1eStwAl0tm9e93c+ja04?=
 =?us-ascii?Q?04ybbQ+YCBmIvWyNv35FrgN5ANPVan3aBuV6qD+y5vq8GyVaGlLKeGM0MWkw?=
 =?us-ascii?Q?uM3LF+BM4Ny6n22328/SwKaiwQDaHexBN2LXoGTF1OU19+VPG9ElXjQQGrJF?=
 =?us-ascii?Q?8iFEgem/ZarutsyFUKWZLmF6O0iK4ksOrzABh/O2Sscgu8LVXdNEs2ZkVBlN?=
 =?us-ascii?Q?TVVtLImwcJju79nwvTgQ6wlaSmZhJm5WEJnFwNJn8Dek/4WAon7qSgMhYgCz?=
 =?us-ascii?Q?KiAlpqLjTjoWNWbw6+fvJ1IOUzh5YF2GGchTsMVOaJ90XagPvnG32+Pt21ui?=
 =?us-ascii?Q?Ybwu4KyM2n+6/HzT6kFarAU8f8F5Q98Hotpy9/LO/ExFSOVy7LdPQsaMms4D?=
 =?us-ascii?Q?ZIAHTAnkX1gywb/rSlYIB97D2a7cpEyOgtYff+Mh8kw9n8FBzIEIeutGhNZi?=
 =?us-ascii?Q?itA4SDxwqHYOzxjPmON0TQelBI0e9aUyg8+cxXyogP5gmdJpwMTiMqqH6EKY?=
 =?us-ascii?Q?DuNivTay1W8M4dfVLHHEmAcmP80JniSBY8wYutXf1eYsc3azzvjtrrLeNMfT?=
 =?us-ascii?Q?UjFEdIja86O72nzOeTPoohoVx/q06IoDRTKEsT8QDzcaCURNx/FOl6G8IYj5?=
 =?us-ascii?Q?Hl0Y9wLuAP7S4j3VsRsCtn6GPO5s0hGNo9R+IAEaLdkcdTke63JbrRE7q7DS?=
 =?us-ascii?Q?fdYqZVjGjs5sQNWXBQsWC9uujVT7xVILAf1J+dROnzR9xYu8B/X97ds3hE9g?=
 =?us-ascii?Q?K9Zm5ihvfNU6okIohg87DD4Aoi189tCFWgnH7e/Lrj3htpGgAHaxXPdGry+i?=
 =?us-ascii?Q?2jSiaGjBdLi8eJO/kW/HI3C3nRQXSK4tXdeahGF/TP7Lt9B+tTb5UFtaJHTH?=
 =?us-ascii?Q?f13yePtwAX8zh0eRciWgevXkJnAdkW2NkPAIjYhgDo0OHUqF6QW3d2eabVXE?=
 =?us-ascii?Q?AUclIA9+z0RFClkadwaW1XtpXmNfrI1iq0wSMNPcIqknlaBQp4715QdHeRzx?=
 =?us-ascii?Q?b1FgJBMlbvfhspELOniE9MIRDP5Nmv7IloC0xcSWZLk2fbWGaY3j7lBxaIFM?=
 =?us-ascii?Q?askl6sfYDJfUqBpuZ2Ea05Kbr7h1qG7DKAYdmMRwwbxhiRlf+lGtew222Nl1?=
 =?us-ascii?Q?OH4I7vt3P6+bHc0lSanUKYnpTWRVDQAyXrRII5NlbGU49Ct6DhAP0BeaLBCH?=
 =?us-ascii?Q?pxqMFLdPSv6vrHbqIrsvYlBwM3tn/NmRWMJ5HdMR9IFbh5289brcyvyWK1TW?=
 =?us-ascii?Q?BPdxdpwt78K0zITnkNIo3e+9fLZ428oXIpIj0gbv3cok0xwmkulScMlJ8wmB?=
 =?us-ascii?Q?IieZIyOPi16C4GpcXi9Az4aF33/ggC+g1ac8OdhAaymlTh68/bAwIbSCmC04?=
 =?us-ascii?Q?S0JhCjS8HRhEBoWokcd7HobPX7t9wkxpFQmbsdjW2akvPytHQNyL9bdM2c6n?=
 =?us-ascii?Q?8OmCiHPfuqzCzXgldtr62Cv8B3DkFJHGLlaslubB7dQL9F9Y3B7UprBAHNL/?=
 =?us-ascii?Q?PBQnlXkNcGRYdQNJ3tAhI5XEaErRyJTx8fN9q3zIhszV9OKcP7GoGH8nAftm?=
 =?us-ascii?Q?skTbxeEmNeW8Qk8dQBeNKLcZzI5LMKwSm7OXCpIRVFBSIttYtSwc8yH73rat?=
 =?us-ascii?Q?dTDnapcWtGDTXI6qiV2dLxmdD0PmO+EU9+3B/MLw1h5Ghfiyi6Hpo1dJWGYM?=
X-MS-Exchange-AntiSpam-MessageData-1: eotc5q8pw3HYyACGFb+RDl7wjPqEeDj+Pe0=
X-Exchange-RoutingPolicyChecked:
	aaTBiWDC+z9jnJGDxALbwbkep41RTLK5IirSQz50VhCGRMuyugatYy9dnVR+3Hwcmu+0Uky5ZdOLwVcrBbHH+J1P0IrgPMYOxtZT8XJEIZivqM5prREP+pCt9pFJ2kZKyZ3/7nl+9D+9lhvUeLs3JAjs04CtMAFY0IcmZQAt4aTjsi18q0zRdvExcgqZAmSIJtYCnFeIQIIRJlFljN0XYTGxt8oGKFo2mjHw13Q3S/iwqlqU7NvwizW+7q7afFnFZsmtWoVeKfndqu+uwVCz0+o4Mul6p22HpzNteLnF235pyL4KBdkyjOiQcPrz1MFbGa4otP0P8GEpZpbTscmU9g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Xqxu6mATCjGb/aw6F0A/SzkycePWAA1GPtfHIHQt1iaIambFnMdW9t1mmDv3FQtQKOhzEgn+p6vZEVmQKy/+9AJ/5xoJjp74ED2cXr5is4PqgN16PMEOcgfk899LEwAbgXBI8lJCajFS3qfHIjV1w9lcqA30Sfa0P6cmnTs8pBg0uAjTe7hRCdziIfy2wuvXcpOr6uPJObbfY6cXH1FWp0pDMocjt5QUp/PNeoEy0u6Zj0gAnn8hHB5qNCHCA5iKCRCyvWJfD0PMth9jxjLJbaqevAW0NhwZgvUHl8yLRZPoSDLfPLfbw5tuI+JcxUY/Srawup7ISQEEvk/alIcWmtL3GXWF/nSvXk3Lz9ERh0HJCYZ/9zgQjIykARSXBYVSZXzd8gNMMs8pvfvoTNVH8jHhFBq3CAOXWJ3BKCrcWrCBl9UqB2Qpv0j7nxQm2P3ds6DXOQhtylUjZxw1c4QCz4EFU30vl8iebNirYgjGs1t258dI4kZouuJcfVegc+h7RDwLrh8taxle2arhGOntW04W1l1feNMW7KGcUtIxcRysEX1WXrXTEUMw+KmMokiQ8DCX8MYb/bzG+D7+yB3MyP7MkFO7Ib9ONzK6UG9/rGzIY18IgGK0vgimNIo66LUr
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 831afe53-23bb-4ae8-6e44-08df28fbda21
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 07:30:27.3806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /0dpdbOBBWLhd65n1DcbnudKNPSWY9qaG+H2WYUIbclLEohZdFqwn1XKmCgD07UbAMDnf4f/xU4p3eXFwtq5b2qO+lzLrsZHb6LVHnYSo7E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR04MB9031

check_bg_is_active() is only called for zoned filesystems, so there is
no need in using the wrapper for taking fs_info::zoned_meta_io_lock.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index cee4cc5da5d2..37f98894899b 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2250,9 +2250,9 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
 		if (!btrfs_zone_activate(block_group)) {
 			int ret_fin;
 
-			btrfs_zoned_meta_io_unlock(fs_info);
+			mutex_unlock(&fs_info->zoned_meta_io_lock);
 			ret_fin = btrfs_zone_finish_one_bg(fs_info);
-			btrfs_zoned_meta_io_lock(fs_info);
+			mutex_lock(&fs_info->zoned_meta_io_lock);
 
 			if (ret_fin != 1 || !btrfs_zone_activate(block_group))
 				return false;
@@ -2275,10 +2275,10 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
 			}
 
 			/* Pivot active metadata/system block group. */
-			btrfs_zoned_meta_io_unlock(fs_info);
+			mutex_unlock(&fs_info->zoned_meta_io_lock);
 			wait_eb_writebacks(tgt);
 			do_zone_finish(tgt, true);
-			btrfs_zoned_meta_io_lock(fs_info);
+			mutex_lock(&fs_info->zoned_meta_io_lock);
 			if (*active_bg == tgt) {
 				btrfs_put_block_group(tgt);
 				*active_bg = NULL;
-- 
2.55.0

