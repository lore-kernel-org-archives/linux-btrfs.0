Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031005;
	b=ufG7XAx9MoY5D0769mzKbAX0Dg1nnJ+fAPK7rjtc39AzvbyHA33jVvOyq/D7Ghlpj15N
	 MW6XJekmDOIVVyyoj/0goS3kbbfFGpqG5/Dckbfx8NmWxQdCglm/E5VsWNyoGlwLWW4AG
	 P1CoAzz4aFtPUcLpj9T2YVkGYUQ6r2LzdvxgXU9lXGVEIe3qna3hasJWnnd74CKpfybCp
	 Akw/ELIKZCeHAzg7aAdvD+1I+TU8i1sIhCvNtLvpiVEu/kAG3zi8ARJvp/tlaoUIi7off
	 mQ2GshA5lnJu1fO4u12wr8uXW8uLtPfONWvT3T4fRijaXW0EpnoZtqWPEVeQWyLSJFA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031005;
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
	bh=o2iQ/ee6jjIru5p1EwGMCsC38Uv/v+D3RpaEetViUKo=;
	b=pmCGFwc+c4mDN2yXoypjVKod91gI0cir55NhRv0Mymd3aiX7Zsl/0xj4q5JjyYHpmY9i
	 3jd7CB/7xb+Tw/hq37EKopwoD81J8raGNAYt8rjfPcceqdnHVhcNEHl4buPibv/cdNdIh
	 be9v3VNgJbJP9krZ/QB6KYi61KJ2XbjY53W7cGT14JAdx4lxmhBzJ+E5XeS1MbXMRBGFX
	 92r15gYp8P7VxwY6eTmNwnru6Bx76scsRu0J5abo1Lfw5ESXMCrUqBo72BliD/inbl6yJ
	 zNfb9gYeC6EPfi2xoOLlSzGSTjaAJNCwkkf27b7lMezdB2y1YMwCOdgD9S/Qy80EATA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=F3peJVMc;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=azQen1Tg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD70606A326
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:10:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DDD70606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=F3peJVMc;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=azQen1Tg
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793031004; x=1824567004;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Q8dRRMg+SsYC+JWQqlPrs0r6ETgaWz4Fo845/02Jvss=;
  b=F3peJVMcfn3GyYs5rsPI+XHgWyNgzHA/CAiAjuh4qD60MphvAVWLSQjw
   VSTUG1j18CalER9stu4M+qW9oz3oXMw1F28vRyie7iTFzaRXMZGjEg0rg
   oTtxeO9JRVCxbnWm4a5DPrrxiTWnMcM75D+iLWcrCC4Dke3lc2QGSBFem
   Kvo0INwDNw3QIpeewiHX+4zwkfcjpvA5m4F6nROvVdep68krQnrUofT4O
   rDkSRaXeU/nk+rvn25lGa+ASzO/3/jOFHpDhryWSMZaK5jXMpiL8DXBJB
   hKWFXfMhxBddOKEyqVkrxMQOgYcxTUAjmqXBinMn8Sh2M6/IKNBxUL/hB
   A==;
X-CSE-ConnectionGUID: WV6S1HmMQC2p0VZpKDMD2g==
X-CSE-MsgGUID: 7X2nVikzTvWSAHB5bOpuFw==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="158068811"
Received: from mail-westcentralusazon11010050.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.50])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:10:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uhOtwYifHvfWtt0aY6xcwIPZB9bynoj2oi7m6BtbXIRplfO/nDg9MXDx47SZrOBGCbuwm1aY7BpwfnHw77KsX2PeAIZ5DkZ5RGUPIJ1C9epm+OL8wyvWGlz0LfUQNWY8ym2QmzCcj2rVFd04KfYH4TRQCdcXCoLWDIwgVVUJTVdkU5jzK7wfciDmw3inrJ+kEnrOtytIsVTK4itbX5IvhnkhbxaMqS95cEonYVIcZVqzcsbfKWjhUMwjxXAVYlRFQuQvp9ziaajNq1KWApiN2LL18eLjOCNJjVg3JdOnuGQPDq73zz90cfOr3r0jQiBVKs28/J62JsLWp/2zaPM7Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o2iQ/ee6jjIru5p1EwGMCsC38Uv/v+D3RpaEetViUKo=;
 b=LNGe92fDoLa/fCQbUzHR1SdFEFw70lN6K5oWuuZ/HZY0rJVpr26hJZ0YmH3N6cBaPcAL4wpTZVw5oFjY8XiCmEcOZH8EhiVi2f59un0CLfBNXlXOmyQysllXzBkM2owkDfVDI8iCwLa3W5Oqk9xgtk5C8RZB87lZxkNtomDuGMqBPUTWmosqX9lunHZFa/e3yyyj7VQmJUQF66txy7aFXvIBpx+Hjm2nkcvWMUhVJpqUWrnCDmDW++LhptcwLiRaT9DYoDp8HHtJn3aXQ8jPi0gJMJkPSfGBa8SoBHp30RosiXVlToBWTeLbsNNb2YuXPXbzBN27Uxiv0tIZXjcP2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o2iQ/ee6jjIru5p1EwGMCsC38Uv/v+D3RpaEetViUKo=;
 b=azQen1Tg9LPRfVBtgAeYEaisfDAdW3SNv3ViHLSf/NdFdU20EwLbLWNTbuGq7kFJef9es/VSJ7xpHVuHfyG0FpHSSaTTjZ/EpECYzLkkIn2MNAXSw7qVtF55KNxOEtHCVoEp8wOJM+HjLC3zhMTFec0QO92GOwm5uKU865QkzWQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB8472.namprd04.prod.outlook.com (2603:10b6:a03:4e9::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:09:34 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:09:34 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 04/25] btrfs: zoned: never activate conventional metadata block groups
Date: Mon, 26 Oct 2026 17:08:52 +0100
Message-ID: <20261026160913.207909-5-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026160913.207909-1-johannes.thumshirn@wdc.com>
References: <20261026160913.207909-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0145.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b8::18) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB8472:EE_
X-MS-Office365-Filtering-Correlation-Id: e707a684-4e4d-4665-8eec-08df337b8685
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|23010399003|376014|366016|1800799024|261026140227099003|11063799006|56012099006|261026121527099003|261021121427099003|261022105027099003|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	A0NNi6QRqN80sWgzwn8ALVxY6LD3ofS/iWR1pLgKIxRyeHOUENSm+5qSPPpXckNv2VXCiIIhf75XZf8rZ/jpAd4snAcXdBtdDIY5V0lCCU1EQPx9myYew82F4Xu+ephFeMsTJE4t1E67+eucVTmUZvvGTt6tunoIjVJpC6/Po5DOKnTBtMf4SHy2X8tf9y6CJs6NRocLzv2vQZN2Tq1vcv1C5GVc6t1qCha7mkxbFBzBa3A0427ZCZvyb28JW2mSdBP5ECsjiX4l8MeJ4gWrf0dx060Z5W8ABcETnjqAsbBEP2DpB5yAvTxFHiucpEgFnHWOCHkVNL6FL0iqwK4aeyDFjyrCZsfYvLCQQdyzh3gjPJsqwSlGYXp39ASu16lLelldYp9zqN3QxBYzXa8kr68kGtoKjNwmk91fjUVZOgzTVt/JnSxLJcGlaBYYlwYvVppjRAkH80ywZ0riuZO10kUAQyoHmU/vRcEUeyD2rWsLyeE/Gwpn3SmH3gk1um7jxwYQ85RS4uXQpIPlycbakz6CKRMgMWVxt36MhJhatVsX2nYmfuW7bi13ZlcPW6ewNsVX0GfucsaKND0nk33tiqpvzjaheqbnhRNPlpeJtkkZ6PQ6/EfsovKiInR3w6J0yOJeQT5UangFnB0Mt6FovJ8wozb1K2xH6B707k94B2Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(23010399003)(376014)(366016)(1800799024)(261026140227099003)(11063799006)(56012099006)(261026121527099003)(261021121427099003)(261022105027099003)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VP89T/s2juCDv91Pozp9qFFCfcYkjm9FXA2AKKSMKnFAZ1yekfRjivJsvnCy?=
 =?us-ascii?Q?yXghVdGdn9IubeiugnXmxl7SSja4VpjpKWLOtkmG0uBVD++a2ZS0FVIUuSzU?=
 =?us-ascii?Q?dH7i2QIoXyn51enhY7rHCice/LKfvgOfjfqpUzw1R0xOGga7NA0Y6nFQ/SHW?=
 =?us-ascii?Q?Bderm4kSM+MdEzBxFVSi/H9O+2CgvK6G7PPjXp1vYEIGd335i8vedGEgXgd5?=
 =?us-ascii?Q?qc3/cmzm8N2YjTKSbSPeZ9kmDa3F8ITEEv8RLUV3nhkCE2a4nUdUTbwPg5K/?=
 =?us-ascii?Q?ztUqjWBgKvPISrjGyNjegyovM0tBaYs3duDKZ92b1syGIbFnEwQWvmo018bF?=
 =?us-ascii?Q?8w/rFvbzAErS89swER3KgEYIkvFBk6pbTa76g8xRl/z0TTdCS8Sq09Xll0DS?=
 =?us-ascii?Q?HTS8ACWsb4strqf5TNBcqEGv0+GgTzX0D8I1GPy4yOhsKewazKegD7p2C5I+?=
 =?us-ascii?Q?+FGHgC5VFS+7F4KqwCUvsCpE2f3YekpLh1IH1vQrpu1KNBTJ4UsFsyGoPD9O?=
 =?us-ascii?Q?XCdpdAnGEGnP7g5FD/ZVphsrCQA5rGjSOgJPgFGLZyp/VXWjpdr81y8SEu4l?=
 =?us-ascii?Q?Kc6873PIJiGN9Asc5nzZltvZYT/bNrVpFrp/A67ulTKN67nfhcd2FUJNpo8j?=
 =?us-ascii?Q?mdqiXn+MK7WT+C/has2xlitx/XTj+8MtCWynMdB2SLAqtc3bheo90ed7nTkL?=
 =?us-ascii?Q?pI5Uczgzc0w2SiXFGKpHNyAhstR0t7mvaWczdl0X54gQrIkw5mszBS8z1OYM?=
 =?us-ascii?Q?y34PKF2mjGabzDBjEPj1Tf3Cwh935JyT0/zTxSwKDByN7UxB7Gk4i0n7hEoS?=
 =?us-ascii?Q?DszPVSrP4lq3ugc83MqBmtWuHy0IGZT2PWCQL48XcktFcrTmPpti/i0EiRf+?=
 =?us-ascii?Q?sSkJZfbs4JA2dc2clSmFqe9z+Q81Y2sM7IUu4uKGYH8Qk1nFFzKE05CE6sLq?=
 =?us-ascii?Q?LR8mxl+Md+Vx0JKDhEGu7LF5B7oCJqui7mOLb6+CkQGKgSOlBSzPvkxxN89e?=
 =?us-ascii?Q?IDajJchQuCWxM3hcwpbrWgS8nMueDOd73T8zTuv1pDQDrhRo4AuQlaWwlCMz?=
 =?us-ascii?Q?CLrcjkA0SbQTfoFpBboZRLVljMTquhmeq35tNHTmdxpK/Er4S/2jKrm1dURW?=
 =?us-ascii?Q?sP9zBGKwZ+Cu39ePwTktI5GyfWiQo5nt6WzOVoptmEYEibgUvlHHP0Ao2Z7I?=
 =?us-ascii?Q?OuVA3EKy64Ios3FBU3J1aFSswTCBiKh1/GpKUxJWbdmnbyTtiZQQ2e6nLghP?=
 =?us-ascii?Q?jJWuGqXeKdnCUKFSL3nF2MX5Pw6wEDAL5gpJefmpTVMWBLJ+W2d1HYGr1Q6w?=
 =?us-ascii?Q?nEr7/q1m4mhnDd9NtKhpnkxM8urbxF57Yw30qMjPvI1ElxMdF4UU3cRJMQxm?=
 =?us-ascii?Q?Im4eOMgXMX9IqpaWBIRDvbQdiq+pw1Q20onCGKVBrA5+tSfBa/dLhV3c50Fo?=
 =?us-ascii?Q?UJSEpY1M5ILKdHVauP+z6Rq1xXQD8fwvYPtB9lg83Iy/VaRfLO4HXe8PELrN?=
 =?us-ascii?Q?Q7OybJdGiX8oepewBZualgWh59iP6uqDMb/19p9NXlZdUslywsUj5HQOOK4S?=
 =?us-ascii?Q?7QqSdid6UGwXXHjaJl9JNNbVLHsKf1fl5Zz6hNe4QNcT795eOBl6VKG1Q8tw?=
 =?us-ascii?Q?Sqpkkco67p4jwv8V7fyJSq6ulEmSFQnol5Tvih7+eqoO8LX/U89aYNxaymbw?=
 =?us-ascii?Q?Q+q5uda7jhcURQRLTkA2HjK5ZUe9w9RHoJeGasS8HCOmifj/bIqAwZZRxdar?=
 =?us-ascii?Q?8clWmWL8GTg9fMC4zXAYwoXiPEKzY1fEFKSjhyuRZn+UmyWBw1oCIYH2KV56?=
X-MS-Exchange-AntiSpam-MessageData-1: D36QIRsdDm0Nug==
X-Exchange-RoutingPolicyChecked:
	kg9HW32qsJvMNIfcz6StYBiHv6SVR6z+lCaAQ4NahQggOKGUDTcsiQAoDB9l00+r6BjW3AUiG4hg+yL/JDJYi5dT0ySEVoSyk8Akt8XgGePixOWofWiFmlbGsiM/c5J4I22Fv/Q7ke5HkFzAw1lIs7V/w9N82tRt/7U+hXY+YqSgaZbbZA0Oqvn70Z1395VYokHTYiIS3l5TJBML7I8aLIhy8q896zhZb0IniWSM7tU3D9sj1LR89MZvCcfjxwzTQYRsGLDsAcQGzT/uhNnGh+bsmUeeoOXlZXTd3gPcRo1yON68v7y8QuywVei/RksCXFBJNKQf/9KxFnHmnyx4vQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3yUGsCGvOVtPvXLtnqryu/icC+bFfg4uqjMmVxEcGNJ3tmpBS/9w8oQBFBuC6+kQT2kT6ExJYzi8MCNeD8A6BIOiHZ8q3bQF6GUQ9dAG0FOkmTekNTNf8+CzwU10dAzesnj7mJDIdbHCo+gldqx3pRv47CxLdnzPt1GFKugwPU5ZkRNwiZFrBUiw7AQK5PaB0nQBrXYMJWbez39rwJ/6Oujlt/YU23MasHWZy9J4SVfWt/u3W+M7NvttS9z4Ui4P7rS7JjpFKuunwZ+0SmP8zsCcZ512IdOS19pRKEy50qJyhz3Nh64XtAjnvoC/oSwbad2T3fKeVpAdWFRXw7z5/aT1ledG+wk1uAzMO76EuySNhc0XTekJ3hwBrRwjG11g9yGqSg/O7Q6n8MBP31jUScZadJqKplZBLjICWpjWlNPSPRWesIgrsn6yfIFCeOebHNAlXVPuva7B4ipJkJSXWpdD54BWUiY33mgiO8Ja7bWsjsB9luOU38owUsEQYt/9+qSTKlknVTirLoM4ps4E4NRgSNVNg//u2NnQJNC6b+U/+XWH9e1zqpZuemKREw93y+8CpS6VDH3FljLhmTv0l9Gxoavhxk8pqsQsbStNT84YD/KoTH3aApJEoWLt5ecT
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e707a684-4e4d-4665-8eec-08df337b8685
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:09:34.2398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uREzx3GLCjz/0M72pCEZ2LVZiKDvpwCoL9gfstJB/1nAO/26x0X5t63OGOBPkoUFX3lGHaVbJP2PN2lSe8YQGHt3HVRk0+9NsiEnnsEBoLM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8472

Metadata and system block groups backed by conventional zones only are
written in place, so they do not need a zone to be active and they do
not consume any active zone resource on the device.

Make btrfs_zone_activate() a no-op for them and skip them in
btrfs_zoned_activate_one_bg(), which would otherwise report progress
without having activated anything.

Such block groups are still marked active when they are loaded. That is
dropped once they stop using the append only allocator.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index f3063da06978..00cf54d20b36 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2451,6 +2451,9 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 	if (unlikely(btrfs_is_testing(fs_info)))
 		return true;
 
+	if (!btrfs_zoned_bg_is_append_only(block_group))
+		return true;
+
 	map = block_group->physical_map;
 
 	spin_lock(&fs_info->zone_active_bgs_lock);
@@ -3060,6 +3063,8 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
 		for (index = 0; index < BTRFS_NR_RAID_TYPES; index++) {
 			list_for_each_entry(bg, &space_info->block_groups[index],
 					    list) {
+				if (!btrfs_zoned_bg_is_append_only(bg))
+					continue;
 				if (!spin_trylock(&bg->lock))
 					continue;
 				if (btrfs_zoned_bg_is_full(bg) ||
-- 
2.56.0

