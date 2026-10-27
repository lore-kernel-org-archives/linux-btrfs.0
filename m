Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793085776;
	b=s5OQapibY56nl5NSIGGY2tbzqd9BO/SgaX7uCs2twMe0TD2GSosBGJr7jDPg3oZRgkRW
	 mvICDj/zN6bTPOBGOBegMpOWD3P7VGoWSECBPrqYiwuigNVTEEayyhA9P7sHr+RDU43A4
	 r18C790kNclv6FMumnfAk7jlZREb2m33f/QYI8nkeklCML5clC6hsZdFoJ48l0WCDMwm1
	 II5d/MxsECUBe3VJWIOxi2YFdnEi/xTV7VbLooR8vtdIuIweEuO+xLpOFY3ey9rS/4YXY
	 JPdvBzM9e95Ewi0/PMgO3Nh2DUgenJxd3mRA0aMafrZdW5NU3ZHB8DfOY1vzR7AcO/Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085776;
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
	bh=Ki+RWVlIuxrXdakXtXRxpORtXK1g9NkTJJSvwjy7Szg=;
	b=zQ3vSko3YLFre/aHyuezrQxGL6ImPFP5e/TT+hCFBjkxkVXFB85ZFPCHd4gjvnbp3dNQ
	 ud05NBJJwFjYXE2d+mkBRNcqQrOLeFkdnVOCc91WAZq2MsnonLUu1Lx58barNjXe+ld5+
	 ghgwDRKsQ+UY5sRuIyFfr5d6xixezrnH2d+ae4ku/qVEI8fyE+4xJ5l+FPanQqzBl9JNz
	 DS1dVKg6W19P0q7GcVyUZNbrkaKZMv+R0NI0e/C6MUQULs+oe+niAgHnVzmK/pcpWLXts
	 q/Ar/CvwDPW5OIsn1Q9rut/hoG9+ZoE2mMr4UkGZ4IectNC9jYTtn9Gj8RZI4K/8v6Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=UX0DL5Bs;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=TFOpWY5w;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A7C606A328
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:22:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09A7C606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=UX0DL5Bs;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=TFOpWY5w
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793085776; x=1824621776;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=RCDo1JHPDR6kH3VbemKt4cy3QB/iSQ0l8bQ3neLpdIo=;
  b=UX0DL5BsY/j8BgC9856PuESYDotfu0Z9+nJEWHbSRe+oJ8k37vxZlrzA
   o16n0I8HzLE0O9A14aNsAn+UOJAnDkgdBMIXYG6f4Cnj2E0fD9nV8GLLH
   QPb5/9TBUfSfW02DBArBP26fyn05cv2QDCkolxL/DrfvTV5aNSmedUNJh
   6HK+8KzhusEAb0gvs1kFOEv4Rn1n5hnWoJdDmmd5nMpZTJQUNmZexTA9f
   pLG88wTc7cw82j6mR42eiuzrLIkJYGAdViIWMEeH6njJ0BSDtCnSzyqp7
   YVmXAQlvdqEvEHTj3DWxG58exPwqQBcOv1QAiCU5O1k+2k2jc1FrW8UW+
   A==;
X-CSE-ConnectionGUID: c6jb05XQQe+R9jiSJSM6xw==
X-CSE-MsgGUID: iwrkpBL3RtCizAXkzEIlVg==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="154863249"
Received: from mail-westus3azon11011071.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.71])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:22:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tVqngxjP3Pf6h+ChWXapzNWVsympAyahXRuCJN0Nsf6yhFdrvedf7jA/E7v5+3BI884MBa9y0LA7K7dmklwDgElPifJx8pX9h7VSs9iLV2nXx6Z8tmTl3I8ktGvuK5XNLuUlt3COOjH6QdVZcur1Tr6J1LAbnv9IGwEgSVEGCT8f77nCRq3COP4GO7r/14qQt4Cm2sIhHKFHnNQvmGNQSCr+xISaBdbY/w/qxUAexDeJkf02zecLCuO7wN+nxFcJmfiI8VzfO5ZtHYQYkek2g/hUXKd+X0mTxmh2HQOUB3BI5ccpWEMcT1LGFAZnDNq93QtEG5DeH8dJ/XcWPv/t3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ki+RWVlIuxrXdakXtXRxpORtXK1g9NkTJJSvwjy7Szg=;
 b=CgHEMuzxFlXqB0v7DsR0SzpgjutGLDGSkVrd3McX8PKOhu/CWukU5yYJp9VoRrqE6GxtktdDfT86jihPr5vE1Fm3kzgUC48+Y+5qFo2s8X5ghjLTi+C+EpIrWXqLdCA7BCrmB0mPJLL0KmFgSdf70ly6Zg6MiW48+u19tkGT0XZ94bIJQ0ZfHp7Zb7pWp082lmFpb3KbSu9pe2hspTBKoFrWF90WABlOxzM0NQQyh+yJkd1S5bSm6QthOvOSzyyJSyT+QkT9S+e4B/0C2RbwZJYc7kM+gpCsosX4X01aYvXyFgpN/sT+0qfoLgjMN1dNODRQRH54IU+fMSPCt3F69Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ki+RWVlIuxrXdakXtXRxpORtXK1g9NkTJJSvwjy7Szg=;
 b=TFOpWY5wn0/r+QbR2hoBLjbGa0uSaXAActE7rjNzhnufIhdbKPwnyGOhv/9VTl3utqq9qU/s65Eb3sBI5CUsZ6zCLikk0W+JGQHguyG2I/Yrnn3tMPdB42hjyEPGLAwiwn+hwbFF7tcZ0BcCbCLvq3dH6F5drV9mr9Qv7ucUW7o=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB6398.namprd04.prod.outlook.com (2603:10b6:208:1a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:22:53 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:22:53 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v5 06/25] btrfs: zoned: only take the metadata IO lock for append only block groups
Date: Tue, 27 Oct 2026 08:22:12 +0100
Message-ID: <20261027072232.419318-7-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
References: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0142.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::15) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MN2PR04MB6398:EE_
X-MS-Office365-Filtering-Correlation-Id: ed089331-b9e0-4986-e986-08df33fb1d84
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|23010399003|1800799024|10070799003|366016|6133799003|22082099003|18002099003|261026121527099003|56012099006|11063799006|261021121427099003|10067099003|261021123027099003|261022105027099003|261009223027099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	syrtsK4SdyJoobVF8Vv9JI9Me95BgfctPdNovrl7AETgdkXT6lYcRhqbxUbcqbFZ+z1Ri41qqIdN3cOXSt6cco4lJEXRJ5GwmzjnaMjlQ+6jP7CkJJU8uR/2nZ+slTVS4ahHQW4OIakOg3AE+5g4nl7YqCRSNlC4hDrS+g10KgFOxk9qVUYLtetTck0Rsh714D4bZgjZG2BN08m6jIh4sSRtEo9acqscxPQs7UedH0YVa03hcQGvbDNnvWmxHeF7Q4tMVMnzUOaCPP2/dKIXA3wYUhr00f/G20gCZPhg6AoWZqQNdnW+1DYAdA2oAY+uAdMhOMhibuPKyVSqN3kRfi9//6p6Qgo7Hhr+iscR6hx+kpehwT2XsSLf5p4OD20v69pkS24m1zxKlhYbyxIDBsb6U0hQK0uimiFnt2MCaa9VNvPB1b7j8wlN3n983OBorvD+ImFFJEIcuEVZpYCjuUPieiF2FJWmZPeNil0BntLh5YTrEAzZT2ttssR+/XdvFqg2FvNDliKpS6M1BQIaW8aKejt/xFCfzazkLTgWdZMLgIAWf9ooETdbB53MN8Ra8SNd3AMOWahe8wjHi2VN30IbaYgyOgHQZzhjRVUCLyoDtG4rhq9IMHEa08U3MDuloe/n3+YP8szgju+aYZ0W0uLS68A1cuU8lwIY4Szt3k8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(23010399003)(1800799024)(10070799003)(366016)(6133799003)(22082099003)(18002099003)(261026121527099003)(56012099006)(11063799006)(261021121427099003)(10067099003)(261021123027099003)(261022105027099003)(261009223027099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5LYCixcdXfCeCwyGE84YPiXfNUERAuZEQPoEnFhvnfCqZAeQ54rVg+6uxXnq?=
 =?us-ascii?Q?THMApqdxZVgWXAwM4hE3G7LSDPRaQ+NdloGZMcqUqZCLt3jzYrCFufydRzwu?=
 =?us-ascii?Q?kIxCIAWGnGHcA+LVyg723BX7JUIlivJWKvviQ0vrF/3lTnSIHtc3D6QdPnJD?=
 =?us-ascii?Q?VWSCeLHF92FV8ppFQxQjak1ZLZaB7QujrIlP5LcbLRNA88qndiWLkUS+EFoD?=
 =?us-ascii?Q?p55hZBAnPamKBAKmHqRKchZazEfOSWxx1nctMXfeFQTRxJMg7xqMyX0O9TgF?=
 =?us-ascii?Q?cH6UI/JzQg+C0FHDUXznXIkpZhW9j2t770wJU3A317UfscUXsShxdREjVufB?=
 =?us-ascii?Q?IR0PNndCts/9Cdjdy56Gj43M1hDkZbuLEVEHI8ZKHEGdnDkUBWbiaCzXh1QZ?=
 =?us-ascii?Q?TKuItI2CURLMifYQHW4JRKnJavILo+Mpk1XaIbf4nk9mdMKWw+fwqOT2NuIp?=
 =?us-ascii?Q?WcTfzrfygiueBJPkeu3QBWbj73Nvx/C4bhBvwljNDl2SZBlZLJ3SD/J6LGvC?=
 =?us-ascii?Q?qsztEQPcqC5sQKNZ8std7fmDi8ceBeQjlfK0wF9JMXer+wo5Mf5NMRDZezve?=
 =?us-ascii?Q?t0CXZ0MGpDFka+9hqD9DvgTimO2L1ebUWQx6nBptLImoi8Eb8BAxOhjKNSVK?=
 =?us-ascii?Q?//I+hryh4EI8r6aSNSNIqFVW0nKm5k/IflkE6EOAF/xGKFma2Bu8YaqpjWyC?=
 =?us-ascii?Q?kfW/0r8nTGB46bY8A/1IwXGnOa4VQgsGJXHFJWWOTtnRzBu48YnCRM5+Iz20?=
 =?us-ascii?Q?wXIMUTMabj02NSrUkgOhwdVdT5T82b3p43R1w+kyvKAO3oP20Cxo+kom+oz+?=
 =?us-ascii?Q?nvYVoBat0yLEWx5S55q8FpGF8EyjWevLSV8XWM/KVlpz+evC+IyCpZj1lXwG?=
 =?us-ascii?Q?FsN1kXwO/DXKX8lsa4g4tYLZhifuVL6/quCwU4RqUW3P65jaVRWWPkxHsmw8?=
 =?us-ascii?Q?mtVZUM2v/JyWZzcers7Os6QkQCpi5gNSALghsNnIfyebm4F47M8/A4jRRmqc?=
 =?us-ascii?Q?lq8KKpEpQv6RK/VTqUt/iUd02f6ObG0TAln3y00myIWn5DIlWjcLaqzXZfpK?=
 =?us-ascii?Q?GFG80TAjtOoQjvYwARxymhtT4KR4ulKjU64P94c+QSF+VEAKGiwNBVwPUwIc?=
 =?us-ascii?Q?T3p2AwIQ+t4K2yCGTJzkevHLymSWXC5wFj9k4uFrr3GpmoAdtHRGNX2x+xFu?=
 =?us-ascii?Q?TvKNEOoH00petwxjVVoMJNWSu4Wmy6/2OS+Z+sf95Q25J5Y53FQtXw4JApOd?=
 =?us-ascii?Q?VX/3HFO9axKG49dOhtdNT17J2qlwSzKT/+0m816gJh1C4TZX6deN6Fzg4h6C?=
 =?us-ascii?Q?1e7V35WPgXpTdzMsGCTlGcncAcUMRriIkNF/epZsbECPUpI+6aTO5/6B1mIl?=
 =?us-ascii?Q?Cuxg/F8cyOTKfLbPzQypzc7x/tnMVtWMltHM43uWrvVEgsoKtBzS0uan7pBL?=
 =?us-ascii?Q?zJCiSjsEXaVxEAV5v+UuYasWHtjeg3avEuPCybB2EV4vr+8ZayoXgdNzi+rv?=
 =?us-ascii?Q?4p1+iOmhs6+R+vO6hS5yALh2JT5pgaOKJ5dCSRFsHW9c+O9LAUg5dIV0sn+9?=
 =?us-ascii?Q?ERHTUf2F5hehOdTGkTsdSgmIQQD+DSJs0aGubzZL2vEq2xxGGFni1wumGUAL?=
 =?us-ascii?Q?IqqWVLSAztayhGmW71D3alxq3u0JPkKFUi6yW/ILl0NxEcUpvQ1fafwJKtDV?=
 =?us-ascii?Q?vvh8iLgWbpIIT7AYTxiawospomoOm4brN+LodWAkKpfWl/OVLEnSL5lqYub1?=
 =?us-ascii?Q?RZC+kBAynC+WQr5OoMYw+p4xKN9KqVg2mqSDPMAnNRv85IkJ0bRnblBJn5jI?=
X-MS-Exchange-AntiSpam-MessageData-1: 6QctDd5I84r9+XpRE1TavXwTy0szFRB4WjA=
X-Exchange-RoutingPolicyChecked:
	213/dPf5TEO1WguAU1FwYqE37WCnw5i9S4EebmEVpLwWK89Jm7rJ54PcJIF3fB3XXoWUKkYD5Zy5oja7cjIwoRh7UjH39zpdjUq1HWn4QVY0+nDvIPasU4aLU3rk1dHdhjFzU+hqoxi6fwee8sVEEl0OPhXF3n6SfqqJqVS1AtYKYMvZpjKPrkWb+NKUep9QdyxiWaEYkRcIuXz3OUK7qlSEmtc1F4q6msl28q/QDpAmTd9HI8kAZLmBYmrgPdvoBWNWivi2uSWtmy2kakdhXK8/yZosWZqEP/DbNxdo+n7Gq9Tlk/eBHZ/AgeQayNUdTUPuR8ozChDV1GoH73x46g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oapxLD9d6mKU/Sy7oRmMO2AY+J2A/u92Zlc4TyQfI9QSabQwVgLUj6dLVmA/XFO7u7OulQzsFA4rMcjTFYwg90yfKdFXZNAtmH83PBGwcwlnA7JfzZD6WwPcXg6YTTNIISyUalIsEaZl4UcyKNDubhAbZKHyXA5hAcQSBbhRxKp4pqfTr0wx/OLY3y/IjP207bTocDta/hXZ0l/L6yHKXfWPFykZRLalYMLBfZvmPKJgN0llSeGGk95150CGB8VdOUGd1JPNEQ3KFk527JZPs2tse/z6RSpNdRUoCbavbO/APoQSClQakrOBsmOYWJPGaTFE8Fe5UVI7rxvkRXPmYjpaqPcbX90fIi4HEKk4qtttDDzBGiaW9bUpZrmAaLQoxSvJLTz4QZZuW6l2JjCLr4uQNE8cvxnfQiej0eHwFcZmUhx6IZ5EYzzpNTfwUsoTPBe5xfjnU0TQPAnZ0khViKJ+Rn9Q2dao1TggFuKTuu/aaXTbMDiXlVXexRrS5q/Ai+/63Mm92arRV+Yfv2irLDvyUJ3LC2HO7O4SCRQ+Y3p5Qd3iv8U0BhDOYVSs59qQxBjfrJrgRqQqpEAE4Kc1TeF+54045Cy1nPQXnybxOmepckNqe0Kd7yzRFF9WgZnG
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed089331-b9e0-4986-e986-08df33fb1d84
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:22:53.5700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wNtOuHzggrt21XHDXnKnSWmAJpOa54T09xnLIJmeSSVgZOsCgi5+ggm7mVD4xRCP4PNCvDH9efR61/grTGkFWTf+cZ4YXFkw037Du7UgxdQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6398

fs_info::zoned_meta_io_lock serializes the metadata writeback against
the zone write pointers and protects fs_info::active_{meta,system}_bg.
Metadata in a block group backed by conventional zones only is written
in place and in arbitrary order, so none of that applies to it.

Acquire the lock lazily instead of around the whole btree_writepages()
walk: take it on the first extent buffer that lives in an append only
block group and drop it when the walk is done. A filesystem whose
metadata is entirely on conventional zones never takes it at all.

To do so, split the block group lookup out of
btrfs_check_meta_write_pointer() into
btrfs_zoned_eb_write_is_append_only(), so btree_writepages() can decide
whether it needs the lock before writing an extent buffer.
btrfs_check_meta_write_pointer() now expects the lock to be held for
append only block groups.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/extent_io.c | 70 +++++++++++++++++++++++++++++---------------
 fs/btrfs/extent_io.h |  2 ++
 fs/btrfs/zoned.c     | 40 +++++++++++++++++--------
 fs/btrfs/zoned.h     |  8 +++++
 4 files changed, 85 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8b49581eeffa..9a85fd478d0c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2547,16 +2547,15 @@ static int write_meta_extent_buffer(struct btrfs_eb_write_context *ctx,
 /*
  * On a zoned filesystem, write out the currently dirty metadata extent buffers
  * of @bg. Used to flush the active metadata/system block group before the
- * ascending-address walk in btree_writepages(), so that walk can pivot the
- * active block group away (finishing it) instead of aborting the commit; see
- * the caller for details.
+ * ascending-address walk in btree_writepages() writes its first append only
+ * extent buffer, so that walk can pivot the active block group away (finishing
+ * it) instead of aborting the commit; see lock_zoned_meta_io().
  */
-static void flush_active_meta_bg(struct address_space *mapping,
+static void flush_active_meta_bg(struct btrfs_fs_info *fs_info,
 				 struct writeback_control *wbc,
 				 struct btrfs_eb_write_context *ctx,
 				 struct btrfs_block_group *bg)
 {
-	struct btrfs_fs_info *fs_info = inode_to_fs_info(mapping->host);
 	unsigned long index = bg->start >> fs_info->nodesize_bits;
 	unsigned long end = (btrfs_block_group_end(bg) - 1) >> fs_info->nodesize_bits;
 	struct eb_batch batch;
@@ -2591,6 +2590,43 @@ static void flush_active_meta_bg(struct address_space *mapping,
 	}
 }
 
+static void flush_active_meta_bgs(struct btrfs_fs_info *fs_info,
+				  struct writeback_control *wbc)
+{
+	struct btrfs_eb_write_context ctx = { .wbc = wbc };
+
+	if (fs_info->active_meta_bg)
+		flush_active_meta_bg(fs_info, wbc, &ctx, fs_info->active_meta_bg);
+	if (fs_info->active_system_bg)
+		flush_active_meta_bg(fs_info, wbc, &ctx, fs_info->active_system_bg);
+
+	if (ctx.zoned_bg)
+		btrfs_put_block_group(ctx.zoned_bg);
+}
+
+/*
+ * Take fs_info::zoned_meta_io_lock once the walk in btree_writepages() hits the
+ * first extent buffer of an append only block group, and keep it for the rest
+ * of the walk. Metadata in other block groups is written in place and in any
+ * order, so it does not need the lock.
+ *
+ * When writing back for a transaction commit, flush the currently active
+ * metadata/system block group(s) first, under this same lock, so the walk can
+ * pivot the active block group instead of aborting the transaction commit with
+ * -EAGAIN.
+ */
+static void lock_zoned_meta_io(struct btrfs_fs_info *fs_info,
+			       struct btrfs_eb_write_context *ctx)
+{
+	struct writeback_control *wbc = ctx->wbc;
+
+	mutex_lock(&fs_info->zoned_meta_io_lock);
+	ctx->meta_io_locked = true;
+
+	if (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync)
+		flush_active_meta_bgs(fs_info, wbc);
+}
+
 int btree_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	struct btrfs_eb_write_context ctx = { .wbc = wbc };
@@ -2625,23 +2661,6 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 		tag = PAGECACHE_TAG_TOWRITE;
 	else
 		tag = PAGECACHE_TAG_DIRTY;
-	btrfs_zoned_meta_io_lock(fs_info);
-
-	/*
-	 * On a zoned filesystem, flush the currently active metadata/system
-	 * block group(s) first, under this same lock, so the ascending-address
-	 * walk below can pivot the active block group instead of aborting the
-	 * transaction commit with -EAGAIN.
-	 */
-	if (btrfs_is_zoned(fs_info) && wbc->sync_mode == WB_SYNC_ALL &&
-	    !wbc->for_sync) {
-		if (fs_info->active_meta_bg)
-			flush_active_meta_bg(mapping, wbc, &ctx,
-					     fs_info->active_meta_bg);
-		if (fs_info->active_system_bg)
-			flush_active_meta_bg(mapping, wbc, &ctx,
-					     fs_info->active_system_bg);
-	}
 retry:
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		buffer_tree_tag_for_writeback(fs_info, index, end);
@@ -2652,6 +2671,10 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 		while ((eb = eb_batch_next(&batch)) != NULL) {
 			ctx.eb = eb;
 
+			if (!ctx.meta_io_locked &&
+			    btrfs_zoned_eb_write_is_append_only(fs_info, &ctx))
+				lock_zoned_meta_io(fs_info, &ctx);
+
 			ret = write_meta_extent_buffer(&ctx, wbc);
 			if (ret == -EBUSY) {
 				ret = 0;
@@ -2684,7 +2707,8 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 
 	if (ctx.zoned_bg)
 		btrfs_put_block_group(ctx.zoned_bg);
-	btrfs_zoned_meta_io_unlock(fs_info);
+	if (ctx.meta_io_locked)
+		mutex_unlock(&fs_info->zoned_meta_io_lock);
 	return ret;
 }
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index d8dd2ae9ff9a..c73953a2e8d3 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -143,6 +143,8 @@ struct btrfs_eb_write_context {
 	struct extent_buffer *eb;
 	/* Block group @eb resides in. Only used for zoned mode. */
 	struct btrfs_block_group *zoned_bg;
+	/* Is fs_info::zoned_meta_io_lock held for this writeback? */
+	bool meta_io_locked;
 };
 
 static inline unsigned long offset_in_eb_folio(const struct extent_buffer *eb,
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 99e44de9f2b4..9b632108c117 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2262,22 +2262,17 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
 }
 
 /*
- * Check if @ctx->eb is aligned to the write pointer.
- *
- * Return:
- *   0:        @ctx->eb is at the write pointer. You can write it.
- *   -EAGAIN:  There is a hole. The caller should handle the case.
- *   -EBUSY:   There is a hole, but the caller can just bail out.
+ * Look up the block group of @ctx->eb, cache it in @ctx->zoned_bg and return
+ * whether @ctx->eb has to be written in write pointer order.
  */
-int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
-				   struct btrfs_eb_write_context *ctx)
+bool btrfs_zoned_eb_write_is_append_only(struct btrfs_fs_info *fs_info,
+					 struct btrfs_eb_write_context *ctx)
 {
-	const struct writeback_control *wbc = ctx->wbc;
 	const struct extent_buffer *eb = ctx->eb;
 	struct btrfs_block_group *block_group = ctx->zoned_bg;
 
 	if (!btrfs_is_zoned(fs_info))
-		return 0;
+		return false;
 
 	if (block_group) {
 		if (block_group->start > eb->start ||
@@ -2291,13 +2286,34 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 	if (!block_group) {
 		block_group = btrfs_lookup_block_group(fs_info, eb->start);
 		if (!block_group)
-			return 0;
+			return false;
 		ctx->zoned_bg = block_group;
 	}
 
-	if (!btrfs_zoned_bg_is_append_only(block_group))
+	return btrfs_zoned_bg_is_append_only(block_group);
+}
+
+/*
+ * Check if @ctx->eb is aligned to the write pointer.
+ *
+ * Return:
+ *   0:        @ctx->eb is at the write pointer. You can write it.
+ *   -EAGAIN:  There is a hole. The caller should handle the case.
+ *   -EBUSY:   There is a hole, but the caller can just bail out.
+ */
+int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
+				   struct btrfs_eb_write_context *ctx)
+{
+	const struct writeback_control *wbc = ctx->wbc;
+	const struct extent_buffer *eb = ctx->eb;
+	struct btrfs_block_group *block_group;
+
+	if (!btrfs_zoned_eb_write_is_append_only(fs_info, ctx))
 		return 0;
 
+	block_group = ctx->zoned_bg;
+	lockdep_assert_held(&fs_info->zoned_meta_io_lock);
+
 	if (block_group->meta_write_pointer == eb->start) {
 		struct btrfs_block_group **tgt;
 
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 3a2ca8bd68e5..f9dbab976a92 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -77,6 +77,8 @@ bool btrfs_use_zone_append(struct btrfs_bio *bbio);
 void btrfs_record_physical_zoned(struct btrfs_bio *bbio);
 int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 				   struct btrfs_eb_write_context *ctx);
+bool btrfs_zoned_eb_write_is_append_only(struct btrfs_fs_info *fs_info,
+					 struct btrfs_eb_write_context *ctx);
 bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info, u64 logical);
 int btrfs_zoned_issue_zeroout(struct btrfs_device *device, u64 physical, u64 length);
 int btrfs_sync_zone_write_pointer(struct btrfs_device *tgt_dev, u64 logical,
@@ -216,6 +218,12 @@ static inline int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+static inline bool btrfs_zoned_eb_write_is_append_only(struct btrfs_fs_info *fs_info,
+						       struct btrfs_eb_write_context *ctx)
+{
+	return false;
+}
+
 static inline bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info,
 						   u64 logical)
 {
-- 
2.56.0

