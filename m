Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794246733;
	b=vOpnVmvfEelrZVnhuSheUSgyQKIQ/uQ4ke4wXp14TapZdvoH9xWsdPSYGnbhxw7wFxm6
	 EZFNyvh83TdMprBglsb3wz9lbvXt5l3q1djNKU0P5YznUWPgFPM6+1r0AW5ynwAojRR4B
	 Co9z1BUrhFiB2DUaLD1UEkq2fyVuEnUPKi1rh9KA57Sk1BDXzqOpH1/7v/NixiiC4fSt6
	 8P8C4+08m0VSOTNz+cKfD3QInNK+xVhLyCStAFAGkGcLOd0PJJwYcCo6j+8Vu9yrGtGJY
	 of2Vfi1lDxGlq0eXi+FsD6cDABON9ziYMWxaukbossiRs7FwVE6LQA3MBnvfqkUY72w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794246733;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 WDCIPOUTBOUND:X-MS-Exchange-SenderADCheck:
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
	bh=3DRuosKdxQksP+iNAck+Us2aOkdSGDhsr5ojWs1oLdk=;
	b=OvhvTwdxaXtBJ3RE7NunLQB/cljLOCJHEc0/hgFR7zwYTtzcAdlkxBgLL5d3ddOc8cBD
	 EH6jQtcCHaP+JOzIymNTaCt1Qbgy7E3E2/Jwcgz6M+91k87vIeG/MentNcDQ8SxDvNUG3
	 cTH5RpitrzVkYzkWcqz5p5GDUftWFuzP3p56nJgwu9z5rHwcNJhuCzGxi3xEJLA6LQ0Vv
	 KVJ70GsEJc5Rlw+Q6BGcosMIqYcHVKyRn0QRIRFOOd4feMxfCpMGghWt0p6NztjZDALZ7
	 PgnH2aiG7PF8sKuQMXUeZ/UX3drGJraowo5N8kS8PwJ5spUyt3MwLvpfUxqbN2shsgA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Pj745zmz;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=OXgRCKuF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44222606A33C;
	Mon,  9 Nov 2026 17:52:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44222606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Pj745zmz;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=OXgRCKuF
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794246733; x=1825782733;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=om8GPP3lUJpu+PqSvzve4PyI8B3foo5b9dV6Olc5+kM=;
  b=Pj745zmzbr9FAjnft1glArrYTzDfiXUuoN2HwhNYnweBVw67X/2hjIog
   VtFuzBDpBVkdX0QoHfTKLj1U6aDTDz3KLuy4DnqSrrD5i0w1lsNVFCuub
   xJE4HgTlsREJBpc/jUtmFjyvzodLM5Bwg1LTlZyF7jiVW+hKizds095ak
   Xs5Lsyq7gJd/DCcru7h4o76W1CdnyUuZCV01r5VGOI5sgjPlv6/8JH4To
   V2w2y3v8J69EGFxLzBfCKfKdQmL/qbd92yMZDzDvT49LhqAH9YlZGbH7X
   STmyps6/qw7xrpFdgAkp8mmn6E0I7U/4fltAnBJYUltVFzeN5y9YAldQo
   g==;
X-CSE-ConnectionGUID: bbORdNXERpqCDJsKSl2zaQ==
X-CSE-MsgGUID: Rz/ztS1tSEeKqC3J/mSVOg==
X-IronPort-AV: E=Sophos;i="6.27,204,1786982400"; 
   d="scan'208";a="160380361"
Received: from mail-eastusazon11011051.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([52.101.52.51])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Nov 2026 01:52:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kjGYEryShnfBl7giO2OStdupt5D6XzDMQRXdsgt98E5dSj1bIHiOsq4Qow3L9Uy8xM2q1bitnFlZNDhPI6rICwO/YfvnHbkbGeilvJx6AmYHIFQZvY+w7149f6JOb0QaUZguCJ1nJdpGax6ntCT/UPwO2OOYE4yidyo+5axDCd+HZbxutM856dOPo5h2SHT1QB+1Src7kMmTZMLu+XsHnFLFCoik9YcG71usbws18mmAYQRUSGOS0ftdy8wStFdmyzrlNwm/13iguUJRGlkwDBGgEFlWiYAxR252YcyoUSj52LCwRbY/lGNc6FZQWrd8u6SUix7au9ghTibzBB422Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3DRuosKdxQksP+iNAck+Us2aOkdSGDhsr5ojWs1oLdk=;
 b=s38P4SLVvGi9TnsIwF+nog4gd43g8Mi1cPCetsBjYAJTMbw+5j1qE4iFxWAxLobilOp8AjqytqdSwzQFKxPFqDaViQzXhkF9zgU/WnG9IcrEvwyZZMJBlLKR7tKyDXt038J0WHJaDQzEpxIHZk8BSAhPcadR1oCQGxnkrAHKtroYx0ogF6516W3o1P/8R/0bhQNkdg2NV+E08LBl7TZL+svBLihq8XAFRsW9p5U6T+ImzJ/hC+WSldQNf1+0OUspbOEErn1w+4/FNoWhwclOYskRQQ205Rc6MXMTQYIr0aTrg5v3yB8xDiXdK/lIb3hXsIUqk3V8+tzxPzF4n5KkLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3DRuosKdxQksP+iNAck+Us2aOkdSGDhsr5ojWs1oLdk=;
 b=OXgRCKuFrvCC7FRMFHgoLDvPTv1gCQZhLmOnwORp6ThL8UzstWRZH0XXUF1fPyriQUAtBcVITQrv41BJJ4ZI9QRcre9UTTfNzSFZ6R9+UuaDdxe6z8uFqwCmbCO1yuibR4mrmtOuxKjfbuuwDXGOyAll6v211T9W/gzYdpRslzk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV2PR04MB994350.namprd04.prod.outlook.com (2603:10b6:408:419::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Mon, 9 Nov
 2026 17:52:05 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0592.012; Mon, 9 Nov 2026
 17:52:01 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Zorro Lang <zlang@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	linux-btrfs@vger.kernel.org,
	fstests@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 1/2] common/zoned: allow setting the zloop device capacity and extra parameters
Date: Mon,  9 Nov 2026 18:51:45 +0100
Message-ID: <20261109175146.1146100-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0002.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::12) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV2PR04MB994350:EE_
X-MS-Office365-Filtering-Correlation-Id: 067b7dff-caef-4d5c-69f9-08df3e8a288b
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|23010399003|376014|366016|1800799024|19092799006|11063799006|261021121427099003|261021123027099003|56012099006|261022105027099003|261026140227099003|261028144727099003|261102123227099003|10067099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	O15QRWD1gnrON8vI2JofvVvepdd23zp5IYo27VKI4uXxfdEYhl/1HTqIAveBEe6AxfTU4RhbsFfAqC6U8FFDOOW6LeubSoQoly/j1oSGahzBc0faPwOlMrOYtZq8FQnI78m5OlR8vXTnWMdGH1hp+IfmvOTH392Da6au/xJM/ZlQY0fiwTUHrcX2RcQXtdo7tGsn0MVC5JN/2Uk5XvS5Xe28Kdg0eDrvBl39Ipn1YXHIU2klHefoxO4J7Cutdf9fZ4qj6pDn2BHVS078+Br15aQ6+x9APyQx8LduRSbBam1jEfxirwrjxQzz9wfVEd5u5qvuPSb6WFmQu4mVfAKDY+h+BFzXf5BSFWg6J6YcbLtntIUCkGVp8KUzldZ6zGMFtsKkfVK6qaVhuZK/1us69dNDRDkymhHVX6hzf692jKiYRuc/DHABRJUHb7U18oVkDEfSwYoSESDBLwwd/ipm4EiMIN7h+jSdfbs5UERgh+j/qk0m10Z6e818zHqb0M/xA2PNJzqcen217fC4KGFw2xD/fIASN2iSsxzE/kDzZ6Abqv0WUESZNpCB1kO0tBnnLmhUVCSRnWHdiwb8G0Q6mCS6wtJ1oexVUPm5wfKA398Xake2N08B9zHyY5/KbWH/xkEA/MOYFD9gJ04OLVv4QLEVtxR7a/Z4VRQssbSGBQc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(23010399003)(376014)(366016)(1800799024)(19092799006)(11063799006)(261021121427099003)(261021123027099003)(56012099006)(261022105027099003)(261026140227099003)(261028144727099003)(261102123227099003)(10067099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6n1KdWO45kg2aXQ4oVX1PFgPxDkmRZI51AWGxp4xi6OAAv9tPfO3NxWVj01L?=
 =?us-ascii?Q?EKA1h8BBV4qhmwiYYz4RoFvIcFNBnBYWETt2EYE/Gyv6FTgJqkihqrDH/bWy?=
 =?us-ascii?Q?pdjoky7co1rPx1GYCeITCDYg7I/hfzUAZXlH0fDedojwCffXAQijHUO+Qu7e?=
 =?us-ascii?Q?R2GJjUYYV69VL22eShRDGfNaw9F8Mp6PLOj5nSrJHAhfeerLmtqMVBi2cETo?=
 =?us-ascii?Q?xIYljHh3yizFBjjmXpcjdnaPu1aE0TQAX8dZamHHS0sW3AZkV/0deHhPRA6U?=
 =?us-ascii?Q?Y4ZDJGZMi4amuLxWc6XGuGM9Mo8s3+2FplhplX+OiP7rK4v1JNCX+sLkLBBf?=
 =?us-ascii?Q?PBFNtr+jdQ6HA7YreDykIcCyKxA6aGMBnlEUtgas9fdKC0iLcEz3lgjP455V?=
 =?us-ascii?Q?qnnBpXIzITOnjoR4rzfDlYplfYAoAZal7gLofDkEIUqBGybZRH4p0onLK0of?=
 =?us-ascii?Q?stx7x8IfuL4zYDSOKxQ+kmxxyXRQZdS4bdgfkPW1XfK8Mo7WoeMM39DqS3YO?=
 =?us-ascii?Q?bOEDTp0GKOBrnJvUZu1nX795bQYD6cPcntfY2OhxzhEwbwSdNNwWRlhm3Vu8?=
 =?us-ascii?Q?+9AwBjBzE+cYKK5pCXl4eI0hI0XrIs/LPbRgQuC0Sa2VKKGsXXnP0dcynD5V?=
 =?us-ascii?Q?466RoJ06yPYbw/4OQd3vZ+kayEqCR4QQD5W+nzisDhc3SN61vI8VBGFA07dA?=
 =?us-ascii?Q?QKfI3ujSXEctEMKScYi8kvHUkkHkmpBeqnKGk5Gt2KKBoUwDI7ZG12fIfPem?=
 =?us-ascii?Q?CpAP/mZBTDMUr2WAB+CgkV9mt2do7uAX10FXh4ax9CBJ0Hoe/TDtEdubHqrY?=
 =?us-ascii?Q?E+hnDl3hJmeJcEA6P96xBhjksaoaJOEoyC+jTvRCspGXqscxg9TEw11jaecJ?=
 =?us-ascii?Q?cmgQ7KCDluXWqrDYkSkwyzlRSlCk+0AG9uOrXnDcmTsQI3R9BlMwaHT6Tdrr?=
 =?us-ascii?Q?x0QEqv16QuqKslIQkqRy9kezZHl7Q3QgBtHy5PBvf35rSYEMzgiuESSTryTG?=
 =?us-ascii?Q?ERqCyzT2tTTtb3fhve/aT6iOGnG/WgERszxECWBjt6MHlOyU/MZzp4tbHTj7?=
 =?us-ascii?Q?pOs8mrW7sWT+1SuFCu9FhCElVqLqHTLY41K9eAya7W0LiQCyvI62+8tVQWgc?=
 =?us-ascii?Q?kRb3uyWeDunspb0iayPobdUdqo7OkbHwZyst1R56Dujsy+EOb4dqPMwyd9K3?=
 =?us-ascii?Q?6cmDQbO+4ceNHpoJt+Pno5Xtfv71BXiSrVphrxmsdPWCG4pA2lVepR61+/RI?=
 =?us-ascii?Q?kCW26fTEClQqOozNgBujM7fhkJjxpnvO+xwfbYuXcKrW5swKzdpM6VqIYkVq?=
 =?us-ascii?Q?bwBnC/P3uIHLnTzGLVQGb0tGk0A7GLe9OUB9dzKf8wF7wkdU8xPBWUzS8Ts4?=
 =?us-ascii?Q?HbTjHIGqDL1MjcY9sQyLkBVvPMcBhXXyUfhj+Tv65SXuFfW2Gk876qEH353G?=
 =?us-ascii?Q?g/fCqA5jc+m+N9g0Hfe/LoD6racwpySoqjmm2ysrXZfFlcYmgNq0j7NQjZz2?=
 =?us-ascii?Q?IMxH3U0pe4EHSJOzdA0HRayOcLm3uNDSUbFkj0Ej5VHlZMnQUMd6/PwUYhS8?=
 =?us-ascii?Q?2brMFPl3qCUARB+0tS6FPEXXC4PdWQGDXqzNXjEUzbVgiYgiU9l9cZjfW3vi?=
 =?us-ascii?Q?zZCw1Pv+3Al4dK4KEZAmGdqPGQIa5FXhMtvtBaeNQpis/B2ws5uA/SX5aVoV?=
 =?us-ascii?Q?tigzDvFq7aqZUTzUvB7aeHyqlqOGEr2ZUh0GwqZlu9AR0Sz2aW6AxKGVF3wd?=
 =?us-ascii?Q?xcf1q41DhMefjCRTGMJLdqmXl9RoKrmGVfZPjTFi5MEiyTNHvmCHfxI8Spfd?=
X-MS-Exchange-AntiSpam-MessageData-1: I7a9uxqvgC1k5lBDMKJAHzDcLAna89W6vOg=
X-Exchange-RoutingPolicyChecked:
	UZ613QC8h9O9y0wjtYytTe5Ifmi6ZP4JTwL7nFhStmV1TVwflJWQUshQog1aRFsP/yrKH8v/54MkPiBuog6cqxNF1gWcSMmM7O00Ycm0Y6/flz90zQEifsJWX0pl3HJyyG0a20Vw0p/2+/0EfHaJcrSQRAln4r1Hg7/VMbQWx/8OoRnz7itdLu4gZxWOeHOv8MPQ54KqA6hE6MiFaPzrAK8l0RQBkFRVj1NGie7wscbDrHuh5t+j9FGMuce+Sz/0MC7dzTS9nxTYplG/OI0RTRKYKkhU8oeIoYw6sb8F/mcJ82uITIozJU+k8mRW7U1FyBjWxwZwihShz+NrtKHKyg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XRYhq4DcHFo4myviQ8F9c4rcIAgiDmCZTuoA4wh6JDjG7dvasBEqnR5LVr9v8P1NFDMKm6sv5YeSBonGjNxXz/PwJAHuOJ6tstBgSjgxLaCu5gq3XhPGJk2s310TqJQOkxi9hQq7tjzS5NWMT4iyvRdiCZqs2WvoFYR1EmRPE/kaFg5Z9QVNHchGLrXoc//RJdbd8TC11iE+Mh/a8ZdKzivaEIViUsY9tkPvXO/4Pqmu065hTyuzvRfyOZ+rVxr+xSwWFq9t+oyQtgRFA/38PMLCmvgixDZ8OzJhv7zfl4FEeU9G7a+uo6BvxuaVvoXHSn2VH9YL/qX4Ao1r8mzqbzqyHfcy542GpszfihDskW/N80RnlbzdpPB93CSUa5SUFlY9h1cbUEP6V66MYbm3psIe47VW3TMZMgOoB07RoBzPeDFy+ggNGMFYKkgu0Z8jt5CzAGrnpLpru93jXwBBs13sRyPcEM4Pm1ts9q2VklgJyNqbzG6UZ3N6FQcXP97ru1fcDKGFAr9jrPOlKgtbYCo4x6z3eRUiYKIdLvmwc5jJhDQRZX83iC7DQNR0xrM9KflVtjAkhfxb84RHKJ+/veRBTTGC+9P0Ojx6S2f7L9LehJdBGScWYCVQlNAE5QI/
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 067b7dff-caef-4d5c-69f9-08df3e8a288b
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 17:52:01.8939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EATin42lyzbADuP7Duexr7Y7NiTeQPkMBxQmNwzeE+hWqLpR38L5CpLrm6PYgpGx6WjTQXiYd1Q4Th334E1SmkpJjyylCuWiAF+zTS+VHfA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR04MB994350

Add optional fourth and fifth arguments to _create_zloop() so tests can
size the backing device, which matters when the backing files share a
filesystem with the test data, and pass additional zloop parameters.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 common/zoned | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/common/zoned b/common/zoned
index 89d0a061..7fe794f9 100644
--- a/common/zoned
+++ b/common/zoned
@@ -81,9 +81,17 @@ _create_zloop()
         local conv_zones=",conv_zones=$3"
     fi
 
+    if [ -n "$4" ]; then
+        local capacity=",capacity_mb=$4"
+    fi
+
+    if [ -n "$5" ]; then
+        local extra=",$5"
+    fi
+
     mkdir -p "$zloop_base/$id"
 
-    local zloop_args="add id=$id,base_dir=$zloop_base$zone_size$conv_zones"
+    local zloop_args="add id=$id,base_dir=$zloop_base$zone_size$conv_zones$capacity$extra"
 
     echo "$zloop_args" > /dev/zloop-control || \
         _fail "cannot create zloop device"
-- 
2.56.0

