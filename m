Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA674B1468
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2026 12:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791979458; cv=fail; b=ECns70ogZXwL03C4RPt5dCFw4RFEYZtnL/0qS/QMeON9vbwu9TAfHgSiSKHprjrRmvWjUNjdECpxwtreA1ImpwSjQmKsyIS26aFYBLztfjYsNM0XTA17v0UUoM8eokFKRk+tP1Jm2WbgvhmIiTTUrlfsUNVH2gzPN5qyCs35RGM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791979458; c=relaxed/simple;
	bh=9cDNmJssneEOojnKQpG3pu6GOBAH/PD1vVzkis1IoYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tgsmhHig8898+4Yc36oAu5x855m3np9tO5MUyh+4EbE6I6agl92dTKG4CkipXQdXeewEHHgggNfZgtXAHl1N9nzuwK/O+uZKt+HsDAZrznTPT4MmLvskBO4Q2XDB2PpbIRmpKr//PXE/wwX50tSNpMHPhBWr1u403BrlXhlpLbk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ksOlKMVp; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=JQ39Uv7X; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ksOlKMVp";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="JQ39Uv7X"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791979457; x=1823515457;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=9cDNmJssneEOojnKQpG3pu6GOBAH/PD1vVzkis1IoYM=;
  b=ksOlKMVpCAskVvePKM9We9MkM7BN6JWE6Rr8vHwUHH9eXrJe2oEYc8xs
   90rod+ZECN7kMqI4X8GjWMxUilKwEd4FqJYvHERiPM0j/d1ypvqT8Y/Ys
   t8vIk7m6DrAZzGpjdMi6oxt3G8+soY/fb5YhUT/NKtTNQciGXUHMHYp4W
   RVy46pgSrIIJGp+SmPevr3UrdRxRc14aQ7EcJIchtZvuiMYr6fIISvYxp
   90BVnhidJrP3HxR6QW7wNJOGy35O7jDXuHEs+wurtHSdbRpXmkt1lcFHl
   b/6iBr3jBbdzUyReqIHFYqANezZgIDAiS47nXTff1GLiStE2fuysStDOk
   g==;
X-CSE-ConnectionGUID: BDkx4liCTGCo4NL/Ouco3w==
X-CSE-MsgGUID: wwk4ywlVQQWLv6QMuITmOQ==
X-IronPort-AV: E=Sophos;i="6.27,157,1786982400"; 
   d="scan'208";a="158077248"
Received: from mail-northcentralusazon11012067.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.67])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Oct 2026 20:04:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oGqiJdxs7wPCQ3ciSxgMfRzHu9bQiklV7QwuXQo8l2MxBiLF6ZRqoodU/S47qAI7dbfRUQ1yPRrkTGlbzbCIqImc4svot29mWChUIuALUCEhdELB2HTfcVyON4DeCWhFVhzn7FQQA4ynAN963nW/jZQOFU+/+kTg5VP3B8reqbzR209SgI8JhxHhKY351V38D9/Hx/cnBd6ImgQMgQMboWi8nvpidcSp5FCk6psNbRlmMHbWVbbg28pB3J0IhHrl51pPrRx86RJsRz+A7+8tX6WX0VAGdaUAGitvkcHte+kwXVvC75bq3W+WJsvDLQA3vt7LFRXZQAPYkx+llLb8xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fJXHaH8anO8ghKmZXCTcRIEoN35UH4yFHgeL0j6bYSA=;
 b=Xls3Lj/HENsEp2te56UIjt1mcbhCv9U0R+RV2eC19ECSwBdFNuOiYyXbeXw+Q1WcAmj0knmanW6XXf/8P/E6+pB2golvv9ysM8v8GIPNRs3M9ue83e2ci3tCO/6Ln8niHW+80f4Ohjdr/sYrNHO0hIkPKluP2E3IsqYsOKRqUrWHy2ruwLEW23PooFvAXg+c+IrfMWQ6XR67cR+K9wq7XoHtPfFBOtdfQFeCcOLjor0kGJZdvgpR4iV6inOf+Kjh9fkbqu2+03g+pVPRXVIvWjkNj03FA/DY0y95hlVgTf4+48Vbdh/7h0ZQzSV21vsUkMNP8ZHVBGHv8erj0+e5zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fJXHaH8anO8ghKmZXCTcRIEoN35UH4yFHgeL0j6bYSA=;
 b=JQ39Uv7XewsHuZ5CxAm1CzDHtdnryHswk4harT6Xjwx0qDY0PqBRbyWjag31PuyGUT7rKx+YK4Ylx+/CwbDhyVKs9OORsx3xnWvvzKMppMSTU0bHEOEyHQZehfZgEWs1MiKYVaBRI76ri00VIVDFVZQAJdcTPVEK3BoJx+oDRiU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA2PR04MB7529.namprd04.prod.outlook.com (2603:10b6:806:145::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Wed, 14 Oct
 2026 12:04:13 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 12:04:13 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 03/13] btrfs: zoned: don't recheck the reclaim threshold of zoned block-groups
Date: Wed, 14 Oct 2026 14:03:42 +0200
Message-ID: <20261014120353.757931-4-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261014120353.757931-1-johannes.thumshirn@wdc.com>
References: <20261014120353.757931-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FRYP281CA0002.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::12)
 To SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA2PR04MB7529:EE_
X-MS-Office365-Filtering-Correlation-Id: ec39e051-6d6f-4103-9d6a-08df29eb4372
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|10070799003|366016|376014|1800799024|18002099003|22082099003|10067099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	2nqFcsv91AxSusnzPo+ffM+7CTgL9tmeZ5KPHZui/rxfYXFpntvtgMsCZpM1v4EAetkEdLCdR02fc9LtMQWmKXBpZXAkkzl7HlZAaM0sTg1LJQpbpMAgZ/fQFUdXpb/J6Yi929yZ8UHxQIp7NPvZwevwOch5Xls4nbCoObVoJUB2hOWNFVR/U7jvMkwuyKDicX6HfYvW/jZf4rAzAHHVWRie+qUFeDRX5b3mzMiPddv6dJgCKtwGzZzYr69Y/1muOI8tU7rTNFMwY+x55Bnh+E443OCW8hXo0U18dnkechyOISiqwKAhwFh0TK4c/UGvHuJaEw/ixdDvxBrEenK7fu73PbRyMIAtaM7jfXga2j3ZpdQRDcijdtlmA4D80k16Ld0iXTwf7CsSOLkBxke+TM1+WVNs9MwY6UTmIYBhqN+ME9hjmQBIgqEA8awzJ5odaMXnDPc6YJPFLvfKxY765A1dH1QiM/ewBEqgeZ97YF4prDcq72NzQYSGiz5tuVVBtLbfdCest4vo/V0VHCzM8FoHIYX7JQbyz+X0pfseOXe9CvOZmmTTG7+Uw5SNHXBSG4hvHgWCi9Ge0jnvYDDkiw8KoB1AcKBeFlNAlZNeIbIE8zkm9MTkrlGPJU75bGRPfR6l+waJoMNgkwfHgfjcqj0tgwZctPDn4u+Z3pwKvbY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(10070799003)(366016)(376014)(1800799024)(18002099003)(22082099003)(10067099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Cmsqc68qNOGpz1YsN47qoxqT6x0L23tak4LunqvsDaJ+0aQMMoq+cKvH/1CJ?=
 =?us-ascii?Q?OuOEL9SiVWPFxCxqKAi7fVWixbgLjwHuGMXQxV4Qny51iQNSsKB/LtC4/eMC?=
 =?us-ascii?Q?0Lm8BqKajgw6R1ErhIQuq52SghP4TU++Yj8RCWOlv3kVDo2wqM6rk3ncmQVr?=
 =?us-ascii?Q?l7ixp3MnsqKZLItf1yl6RHon83CxhyDG0JZPLFvn+ZJ5mTnZiRxnpBX9mYIt?=
 =?us-ascii?Q?T079lf9+1u9SPeV1mryAV6cq1Hj0U2RqkhK7QyMLTWcrtu2W0Edlbe9pUroq?=
 =?us-ascii?Q?yj4GmCSlS8f2B/1uHQqlkQIcgnsxPDKE1Ag+/MakxzicsFLGwrhU6FuR66Z2?=
 =?us-ascii?Q?mq+oXvUrZPZ7AdlWHGWC23znaWMhubRB9JN1ryfPzSwJy9xWBmRfaxdXVFIf?=
 =?us-ascii?Q?AH1vJ6s/M87xUBWEQxyBCjMw1tf7KQvMPKDvbHJt9u1WjYpauLKO/CIKTqFy?=
 =?us-ascii?Q?/fDdWUG/Fa3DQZ011IyvG/wu1ZvnoJEehzFoUOP/E85U/5JxkyfkDMwh8Ayf?=
 =?us-ascii?Q?nrgWFn53l9dKpatxkJ0AqyyLQMo8rQ/CoPzd0oVe8RVHTk5mwmUQpYmGLkiz?=
 =?us-ascii?Q?P9KLVvUKV8KkaEnXuVR1EYlBIBrNla6fxkt8zX9sYKiWo/c8h7U3YSq+kFeJ?=
 =?us-ascii?Q?SsZOJojUGDi5f3cjjJy5zGpFmeqyDh/kxWVdxzsBwbHosjrRXQx54relT+GY?=
 =?us-ascii?Q?i+xUXRjr0C/xyXCDUdG9j9pjL7ixc0ja1X0RTw0CuuQ9Yw0CX8cf9SotR6Ge?=
 =?us-ascii?Q?ko1tSyEVCfOBZd6gDYaX3j1IPpJ3KE+CnXTBcPeafIH7Jn7VxLB0p7hUByp2?=
 =?us-ascii?Q?s4pY6jffauiI4RIk+WMwc/0z7ZreaAEwQm0IXrZo3+TAdkWamJQ+qbIRxdqi?=
 =?us-ascii?Q?fz2RbDtrX2UqwlN5k9mRcP6k85tEoXdQwRIvaXALAGavgyFc/q0Oiv2qHBu7?=
 =?us-ascii?Q?1BC0b3fya7M0YZaoyZRMj+QWBLvA9Jqai3qpbv1VZoNZhQsmmuWmhRDV7Qt2?=
 =?us-ascii?Q?p/hv+QdoqKhnjsbHPmNhy23NpH1InDPJzZHnrRqCY2tHLaWaRzV0W29USigt?=
 =?us-ascii?Q?LBw8yN3mpSvtSfxsIxQa578bk/UVYB+Q7mJ4S4akHNUDZGf80Yz6epLRTRW+?=
 =?us-ascii?Q?1cWxEXzO7STcVevQGljOXLlYKlXyXCDz/Dp/2ovJNhwSoUer/jLl6pFk5IVx?=
 =?us-ascii?Q?lxamHB2h/Bpr18hifbbooQAljEmWaFSGuyECFBB3k8wVR2PfDNGD6G3C7zLG?=
 =?us-ascii?Q?ZTFyZ9dY6VrBnhkMqwPmibGvepB/t/hTggF36ZvAPUeIEfgDYbGFc6AVFIsW?=
 =?us-ascii?Q?nqpZvJvjXuvx+8iXw55kEgdGKC+1lXHix3Cl2jtWDoJDJ1R2fW7IUhZww0e7?=
 =?us-ascii?Q?dHVmsSgpGnO81CN1QvaGADu9tqezsodXTcPAmkaPmByD+ySxGgbXTnICAkFB?=
 =?us-ascii?Q?xSzny/ULIXTfyg/CiTd/jlTBeDy2OfUjmGL5Y7KTW1mk2cdskCqD/iKtFtAa?=
 =?us-ascii?Q?3k9eOzl5NmDdGqOjUO7epREufWcNg9ngaIfgneoputqMYoy6cGfCw4alAVV3?=
 =?us-ascii?Q?Z/IjlCQMSrJNFbxrDEqULp/y2b1RAuYz27mivI8F6ktoxf5Ra3+TNreQEQQR?=
 =?us-ascii?Q?fY18OhdF9y7cj+13S4I5ev/ZKi+8duqK67nEwPK4sUPyBtMQWEgcpcqj4hzk?=
 =?us-ascii?Q?DEnlUo8Bma+3Rm61TpHvC9AgcLtk6F9nSnK5ivFRaxjm027usiQcgRMj23Uk?=
 =?us-ascii?Q?biKD/T43CNDUcUuzYqkuy1BN+75GocABF689jlnRY207CzYMeFrNDcGh5sQE?=
X-MS-Exchange-AntiSpam-MessageData-1: 1FuEjGuYZ3H7KV5hLB1duECfrUpMym1ol/c=
X-Exchange-RoutingPolicyChecked:
	UQlWY2qZcwZgBXX1a5apqEtBRwHy3qMVGH7bCV+zndg8rEfpWyMPgEEGRlfRQDtZw2mnRhBO2ZYl8f4I+LRlMlGVetJYmQe3ZWBQH1V+qoxYEgAGgURMnNC0AHSu1izySWQkNPVsdXIV8tQBI6DpD1AOcpR7f8HfnoZXP4kKuD+e/outIc6atne8xkgpY1ya5dxAj1PM2Magndj7bGPRNsdm4Nwkmq2RjZjSFaMId8qvg1txYCCNRldgpX9B6ZuwCFj3AM/V3db/MxEKpMipPnhoEeDZJzhA/nICjFQ4ETXYv+j64hv7IDhf3H1Ag11kSwjYgVcPh0YqRxFEy5knfQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UE1SjSu1NJZStlGEe5T4WR7gxulaXeOBWdxC3lXV+t0xDZ7fOUlwCNYrYQZxqS3XzXg89By2g26FW5JvCHYCGGbR7/j927NuEcs/j/dB8TaPZozDict2dTSZzKQfmkLwdqspRjAreM2gP4N/ox7JHcmFZ9cNUkccB6SgtuzGOP9Ihu/2hRwK8aSh+xzHriTlYrRtzizzaM26fIVEoopGkS/u8fyNUlpruq11TUV7cPeZTtuVP+IoB4so/K6eKJ4N0CGstTAuOp13yCM2CvGzKcV1xths2/2ibi1coOdI8uyP7OCqbj3rE+qwh7JvrVw5Gk3g1l7zNPR44qqlftUP6YRKyvuTWFTEB+g1ZX+XCS3yjZ9bkgLxAzsOKc5gaZoYxqZHio41q5OZbyi1LZC/9S5k76n5WP37NRJhEvr/I8O6K0dgc5zKZF8kblSPCLZlDh2T3NP7NyQa0xCMMkKA8QiQvhst8pd6jLeE4o5HGBWYzpStW6FrZSiObdURXzj5UrAzd1RzB8w8XdgVaoYkCIioQ4X63ldjWh30ibD8ZiA1sP6aVpefMSee8LqpE7Okjh0vlwy5+FcLci5UkZ7XTMm+ztehCGXqMqJT3XJnaJIbpL4an7aIAVtV23XHkwIK
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec39e051-6d6f-4103-9d6a-08df29eb4372
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 12:04:13.8076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /kfqTbqEMkBQe2oUmlOA+s0g+YnmFA38NWcZmG6bQB3uaa/RbCcPySY/4sDtNYjKv8vhqxhDyKWeP9SnnJ5KfxkjXc0WtLoJyy8wmUzZlMQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7529

On a zoned filesystem, block-groups on sequential zones are append only
and their usage can only go down. So there is no need to re-check if a
such block-group still qualifies for being reclaimed, once it is on the
list it needs to be reclaimed.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 34ce3bac45a3..bad55ab4cbb2 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2033,8 +2033,13 @@ static int btrfs_reclaim_block_group(struct btrfs_block_group *bg, int *reclaime
 	 * being freed, pass in a fake giant value to skip that extra
 	 * check, which is more meaningful when adding to the list in
 	 * the first place.
+	 *
+	 * On zoned, block_groups placed on sequential zones are append only
+	 * and their usage can only go down, so the block group still qualifies.
 	 */
-	if (!should_reclaim_block_group(bg, bg->length)) {
+	if (!(btrfs_zoned_bg_is_append_only(bg) &&
+	      btrfs_zoned_bg_is_full(bg)) &&
+	    !should_reclaim_block_group(bg, bg->length)) {
 		spin_unlock(&bg->lock);
 		spin_unlock(&space_info->lock);
 		up_write(&space_info->groups_sem);
-- 
2.55.0

