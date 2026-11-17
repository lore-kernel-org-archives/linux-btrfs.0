Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794942014;
	b=zM2mxGauZOisPvPVXBefQuAqJBn/6maM63+ADpIti3/t9aP8jsX2G8+P4pwdg90UtW1f
	 M5tdSB4trrSPHOYkBeCEqTT389bvims5vlbsYNIqbXqfJNAwx1al+5UR/kXIKngFAAhOF
	 NPPc045SuEqHqqJCN+yXm/hM/CtUkUTQdm+tfsyRIPfjjdWTloJ6tMCyNjhcCdzErjB13
	 xYy1A/rFb0ZeurGqj+ID7MpkplWT20zTt+cmRoo/eEtyBn8Xzn3I+A/hDTmwtDxlP4kyG
	 tGGlyw32U2AzosUkmGwKFhP9ap7KoiNRjjW3DreEfJm06U58+15Yz5qZNhhvydeRsMg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794942014;
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
	bh=k7R7V1qgxkS8xTd9W9k28wHjLOVTBD9AN55U7bJh6Yo=;
	b=vVncYv00LtuvvJt4VZhec+gSIah3/0Pnnbh5UhjVEQc+BsV5K5gYRU7e+f8h0nqPdX5r
	 abKepcbNLZHfvxI3YTXKb95PHGUU7TZ/Sp4dBYQxqQYQYiCH64WumY6ggWbhzC/tiYwrP
	 EndOYTdNzJwv/sT2lYkhrNhbbcZjDHL2XsM+mhAFN4fCnJk/iZNdlLFsZZX61uL0sYSLU
	 PEODrIbuAJ+AHQZVZZJZUxFVp6x+5vJrLB23E1yTubBLc+r/BoKJ5mo1rNeURvJLqoZzs
	 yx+o7bS3aV+mln8GbVHzIj1AaPW9XdEYkI7tMYPjPGckZl2Fpr7IzuLSbyt00IcWwDA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=HucAsKmW;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=E1AAo0Hs;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146A0606A32C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 19:00:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 146A0606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=HucAsKmW;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=E1AAo0Hs
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794942013; x=1826478013;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=2ppk0B+IM8hrgjjJrQS+E65ea6SV1vHIacpYx3YImyk=;
  b=HucAsKmWQjkZQY11/T1zGWvNr98ZHbayM5SxcCpwmG/ayIkBLg3sPLAO
   70dyPOTIiET5RtbcfJM7KgF1Nq4NpEYH66+b3y5C6VLE4x2FzT9gZj9yH
   6Y9XZvYJQQyck4lIlKQ1QD4stIq34uSlp8YTVVfANtLAc/+n5BSIgy+mE
   z9A8Dv3ilYogxokbRdGrNiBX5f7mUXaNUoZt5csd5W4X6PCyML2NuHCir
   Aj9bK/xXoPnJitnAyJqbDLpGsmUMKZfybGWbu+cbXZkq3mhu71wml7s1/
   Ix92pWeJZz2j12VpWQzwoM35w71NxlgASkPTAkKSi9rRgt/PjnHiBnqle
   w==;
X-CSE-ConnectionGUID: b/c8Z7nbRvChU7VHbK1c7A==
X-CSE-MsgGUID: 3/yHj6wOQTCgzZxJJmREZg==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="159505248"
Received: from mail-southcentralusazon11012033.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.195.33])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 03:00:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QeSILln1IP4cnn+J/p9gxe1xS6Bh+uClpY7SBPAXCd6/S9dt1njEq3iB3zRRjYiCnToUkVReGaKRh/Tfc1W2BjOu0ofBP0uk222jjHDYlA+YYEEApMhgz9pnbIp8Txr+7MniVrp3me3pG6bdEVkupPwcJu6PYHJdar3ETSL5Jw6Os67vtMtqTvn6c5rvgPNqzHwJpCvBmMIy5NmlL2yGM2PHX+WcoKEYgbj5Agh+aVWKVVOhaHdjAv8MWj7MxCzS9moQrEThOVyyyfgsjG0i4Fy36QTA4a1c3hsSOEIZt54PPprB5Q5WY+s7Zwn7+TUGBssxnrNuL4fn23EURFQcqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k7R7V1qgxkS8xTd9W9k28wHjLOVTBD9AN55U7bJh6Yo=;
 b=u7ZGJD1iMDAvfzvKT5YI8KzkZZg3px86ozh0eDbhXhzhD+N1qBw1a8VIznsO7O/0VI4JsCN16fptMYzsLzqZ/iGTmwk1bId4y22uqQgsvY469XswMiSOF1I4mDXdGAeKZidigji7Uzu1569MitVe13zl+JQzSItYt6LW2VxpeVRxa5LiE5JnY/ts2Drad0XxYQCDK93I6h5vCpoTezTb/Yptj0SfBhmn8RFlWrvXQODkMkz+UVxEQkWKhFaKy59X3uxKiXeEymL3xXVSdSieDZZrDcDcqIk5AxXkAse4ajTjbglGY8hpTOrtz9yZQ0e0614/3ToyvQHiOpzbHPQDEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k7R7V1qgxkS8xTd9W9k28wHjLOVTBD9AN55U7bJh6Yo=;
 b=E1AAo0HsN8Mx+c/SYoH4Bk2YedJkoxrAMhTpi49E3jspFwsX38ab6/il32KlGWJjpzz/mPZOxSyc5hJ1MUopWxYn0W7laBdhTMjKDlG3oVdbY7tjSsCkGk+EOphGD7TjLv+qYb/s+07KtxAHuGpPsS8/KoUv7Wu5Je6C3V0niR0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA2PR04MB7483.namprd04.prod.outlook.com (2603:10b6:806:146::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 19:00:11 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 19:00:11 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v7 27/27] btrfs: zoned: provide zoned specific reclaim sweep
Date: Tue, 17 Nov 2026 19:58:50 +0100
Message-ID: <20261117185850.4128157-28-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
References: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0167.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::13) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA2PR04MB7483:EE_
X-MS-Office365-Filtering-Correlation-Id: 378b431a-d849-41fa-1550-08df44dd017e
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|376014|19092799006|23010399003|366016|18002099003|22082099003|261009223027099003|11063799006|56012099006|5023799004|261102123227099003|261028144727099003|261026121527099003|261026140227099003|261021121427099003|261022105027099003|261021123027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	oHk02t4q2pLGY5LsGlKzusFgzFGiu78fAoRxF50M3Nb3JMntx8O3I+GFHDzjzXdMgmdxZMrwm820eNj7EJ3bFiXwTfRKfyUM1VvFqKAzE0k5OtQDsGmioGIwqzWgDYvxMHEnUy/+3M8FFHKx3KMypYc0kUJVB3OonXkPQUazCrbgYw4OcFbf9MQqoKxmrrNAytBzv7GnTQAF/rF4kxkrAgWYTy/8FLqGjp0SY7kEEp2i6lGFLnboAnZDUu39O02DFcuMEGXFHYlIuvya3Kq1OxOIP0AQ/HBtx3D0HRgJJytvTETuA1aepHPOf0Yf/7M6FfxguYEyGjfUpBEtWq71VG7XTpwsD9LwHIbnQ4L7cR229Yi/J4iyiIunHpfLtjwpg9dB3U1mPVbP4sbpjkhtESgvGLmr75pKy7A33gNTbaXP1hurelZKPrwyLAYD3njwdI5BU+6+sEPoRAJA9V1ariK78VeZ9ZoZ1HFRXAZiNEDmFLmFZtQhQI5UJCBabZ3MDq79tHB8xZ4a9XflPbqg9rxruK/DfT7J+Zh9JahrmI+Bc338btLdD7ECcP499Ko+BtsZm4mK9G0OIIMFAbtWgYDl7VPevZBSmESS39UsBak/+zreodLh4omptz7hFBptkuANJ0hB8agR4QwJXVq9ooJnfyn0X26QxB6jDMLcYYs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(19092799006)(23010399003)(366016)(18002099003)(22082099003)(261009223027099003)(11063799006)(56012099006)(5023799004)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021121427099003)(261022105027099003)(261021123027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?N9evfInKJsSqGPPG6qV8oInz2AKPmCI7vBrfBcOgsKsX6tG/h6DopsmH+7wj?=
 =?us-ascii?Q?FQHDV1a7zVdMVjr6cXd+uRsDn6uh9GERB2xgna/WR1+/E4i2trJlZpm/1kN+?=
 =?us-ascii?Q?JndcpwbAwHrF9o8M3beqpjweVj0RmzV6p8XsUj+37o4V54pRYxuk4sN7vA9u?=
 =?us-ascii?Q?Cbs67mJ2WbxnHPByJXXot4Fvf1/CAXXKa7ySlzuVu6KL8Mdyj6/EYPxSbVUu?=
 =?us-ascii?Q?Lfwc9DixyWA3gcnDkSHFaE1lCUDBnD8+79DKPj43zKOK613HaDwkK8cuFwTv?=
 =?us-ascii?Q?GlRKu9eX+rbZzLoQ2s8NrwlGW3bA5Ktmz3LD1nApjAF6k1FlZkbFZ6Lcd5bw?=
 =?us-ascii?Q?8RCxMGuktF/PnwhXeJSdMPvORA2zVejMMrPK2GP0YkIRHjfvDzUK22N9WRZ/?=
 =?us-ascii?Q?EDHFDNDSmoZMbFszQmD2JnKbWliayTTFT5957c4VqFcusbUTpHU5hxCKYdw9?=
 =?us-ascii?Q?qGiYua9um+2HwJccnczOjrqIp4fB7tx2LiPn8nVX0/V+RouwnvzJKIRUgi9h?=
 =?us-ascii?Q?7Y9+fVvTD9DAcBRsfWKnl4s7nqVkxPU/jupzXl3oiCtBtp2Q57sj18cbNt2L?=
 =?us-ascii?Q?qKE8s8AqZ2Agk8dFQesGGEt2bNLcRTUUkoCJ2B7e4zf/3aqFZO6o3ySaCgx+?=
 =?us-ascii?Q?LLU1AfjaZxASN8G+7WslQ+hUNFjXiAm3RMe96PWcvY8iDG4ocoW0Z2yq1x6F?=
 =?us-ascii?Q?CGNY9aN5cIfqWMtI3gtWADbZW0wvlnM/10Kfzzn0j1uZnxU4I3r8dttHKI9R?=
 =?us-ascii?Q?VfelembU4t247zvii4D//OxdQlIc/ekZ6WuDRPKA7KVX+7oVHPYuJJFimXyq?=
 =?us-ascii?Q?fu60BzzymW6GdGFV3ZZ+Ujvet72KxmNGLbAZgQL0S/TmlOFY0fH+pUqWjEXG?=
 =?us-ascii?Q?6oskTLQ20QqvmWnBjWP+EpSSLnnOX42rjvHBTrMZYUP+MBZmWfS93Q4XohBf?=
 =?us-ascii?Q?ZBrP16zLTEs/oHQ+4dWD2TgAwobSeZatsD/8DCa36BCkBt7drS4GOv0DGBHo?=
 =?us-ascii?Q?AAihiqSJ5x3E8EhwMo7i8iuZue+cCrRFAUdLmpKS5H/dNhK7KBaDkFFTi1RU?=
 =?us-ascii?Q?CaIr7DFr72jRiDqICt90ov9FCRY9wfXjeCPGiAK86mROLtpzVpeoDMvv8iPa?=
 =?us-ascii?Q?kf55QpmWA1lB0iotiSY4YZSVkVats6Vwfj7xfJOhUAsUna286hmLOF0W4npk?=
 =?us-ascii?Q?CixkvIFb6RTcUPChb1z0HHuQ2Am0AXLJv0x5oS9C/XBQR/7Tblmks9HkZrsy?=
 =?us-ascii?Q?plsqKcXkd3IEq0zc7UhUi8WHs8M0+hCyKFln+o3LI5dEyzkFR3+Z+P5pYP1O?=
 =?us-ascii?Q?QardGniHBRDvGekmAwjuubQ5TBNKxIyP0rZP3vJjMS6ClyXVmznVeZSweg3H?=
 =?us-ascii?Q?21H375uaDMSlVEpLfFJe+xmU0/HBCRX9oyyC39IUoxYm02s8hv1XNGs/F1MV?=
 =?us-ascii?Q?2WCx9jjE2Ry1a9N/2ToCj3PJj+KVoYCCyHyo+dEuRjbJXypJn4Dbs21yBeLf?=
 =?us-ascii?Q?wXBVOD2RvS9/tWoUXpmQWtDLvalbYulpU4uMH4dGKBN3UuQ6PVUVD7I4mu1T?=
 =?us-ascii?Q?40Onw3ZFk9BvIl6GZTI8aFXRU409rwxaNzr/blUnqvqWafvyYzrcIz4ITn48?=
 =?us-ascii?Q?OyH//DwjWZyhy3iLinI7Q9cZE3r9Tk1x8sIc+1HzpjzR/nbev8WHn8Ndvp5A?=
 =?us-ascii?Q?kCfo57ypn7MazfWXdFgd0cbhBqhwgkofOya26YgF7xKyY9V/FXm2t2fFSUCp?=
 =?us-ascii?Q?Pr5xidef79ggNOdykDJn72QFBeqVQZsnq5woL4qPHQgHXI845Gluk18ion+o?=
X-MS-Exchange-AntiSpam-MessageData-1: kLnLvtDEJDpjPHSi7qLUrRbX1L/qYSRvuLo=
X-Exchange-RoutingPolicyChecked:
	xco1fnETg04/sL+JmIlL6aTJvWXBTSiKbGx3wKocZ7UmkW0bpouLQtmNg7ruG30ckN/KqYE2XdmBx9pztEXnRtZBWgbWxuPCSClgX0dHb+W32dDRzDwgKrcmbinXlUd9TagxVUvLZz7C+NB9x57ORd+ngjJup43xCP1jBsSSdPdEEi5fK/qgCt4hF4RN8OXkOzzNtJ8TicyRhaW8no74W7yaAe1w92Yu30ONLRS/lJ7oUnQzSfu2cTgHgEwqGAdpfTFrLSR5/IqwHbph/HsoqT1yfDu5T2DT4+OsUOUbT58Vm2RMkJUjbtE5Ny7qw83c9cLs4n8TCyIlahani6X4uQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7qIrHF5+ydkQlyClec0PT9CTs4ke8S67U6/T0FmMgouV7ClSCyugfBK7FoT1VT0u+rvK49rUOUBHvmmWn8lfSDiGixsuWPoyeIYHPh+VPia2QJSvTZrFSziUn6tP4LQDhMLoT1p3ab3cSKXOcB5GHuf9UcbAPB+pseK2s5MG5hZM3ZiDB/3/11OvKxsFWnGCIEA5oz+JZhbbe68eygVrGoJr1nqdMxi0bmdZLZ3YeqwhRLixyIbf9RjiRILWBMmUbDnLJ5vmeJyrYAsGON0BWxix8xfoFGBI/10AkKPOYbzZ8SV08yzHKcLK5ZZ8PrrI2Y/I8LHuJoa7ono5k95mvQyCmE2Krd7pjhDW54CT1+7hu1G33QZ4e+mud//XYzkoQY0YPltTDR2ELXee596tJaKi6oF0fA+JOVMI+sdQ0ETbATJml5R+OuU1GYPyjuO2DtUycFOOScj7xBdMTDu0wXxM9ve01Vne2EwlLOdI2sJMqYlbUIwJSBDOvF1Jy+sc/AfAjOjrn9tE66Mxg7TPWW8q2XN+63VLxaTJngf459/oJIbmdW0c0N4Xb93Be5vyIE/n9T0UGxGkNhogTUyeDW1jMAlFgMtZBzwxW51y2CpELez8qxC4ObfEX56WFoqM
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 378b431a-d849-41fa-1550-08df44dd017e
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 19:00:11.5450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ja/yC+rR5OURUb5S+eh30AIL20W1wRwnK4CpyiCQKgBmPj5+5E7JJVAuQDzCACaoCLw3qbi0I/rDUS5kHD5GbKH4NYbVlyCGAl5uSDDs1gI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7483

The RECLAIM_ZONES flush state calls btrfs_reclaim_sweep() to find
victims for garbage collection. That sweep does nothing unless periodic
reclaim is enabled for the space_info, which it isn't by default. And
even when it is enabled, it only queues a block-group the second time a
sweep sees it below the reclaim threshold.

Apart from that, block-groups only get queued for reclaim when their
usage drops below the threshold while space is freed. Block-groups that
were already below it, or whose garbage comes from many small frees
spread over the filesystem, are never picked. With data tickets waiting
for space, RECLAIM_ZONES then relocates nothing and fails the tickets,
although relocation could recover zone_unusable space.

Replace the call in RECLAIM_ZONES with btrfs_zoned_reclaim_sweep(),
which:

- queues every full data block-group below the reclaim threshold,
- then adds the full block-groups with the most garbage, until the
  queued garbage adds up to two zones. As soon as the data relocation
  block-group fills up, relocation uses the zone kept free for it, and
  the waiting writer needs another zone on top before a new data chunk
  may be allocated,
- also considers the block-groups of the data relocation sub-group, as
  relocated data turns into garbage there as well.

The periodic sweep keeps running from the cleaner, adding an additional
layer of garbage collection.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/space-info.c |   2 +-
 fs/btrfs/zoned.c      | 125 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h      |   3 +
 3 files changed, 129 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index bb08294cbf9a..22b5ecd8b464 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -914,7 +914,7 @@ static void flush_space(struct btrfs_space_info *space_info, u64 num_bytes,
 	case RECLAIM_ZONES:
 		if (btrfs_is_zoned(fs_info)) {
 			flush_work(&fs_info->reclaim_bgs_work);
-			btrfs_reclaim_sweep(fs_info);
+			btrfs_zoned_reclaim_sweep(fs_info);
 			btrfs_delete_unused_bgs(fs_info);
 			btrfs_reclaim_block_groups(fs_info,
 						   BTRFS_ZONED_SYNC_RECLAIM_BATCH);
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 5ca1a37fe9ee..ef2cc51be7bc 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -6,6 +6,7 @@
 #include <linux/sched/mm.h>
 #include <linux/atomic.h>
 #include <linux/vmalloc.h>
+#include <linux/sort.h>
 #include "ctree.h"
 #include "volumes.h"
 #include "zoned.h"
@@ -3773,6 +3774,130 @@ void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq)
 	spin_unlock(&fs_info->zone_active_bgs_lock);
 }
 
+static u64 zoned_bg_garbage(const struct btrfs_block_group *bg)
+{
+	const u64 slack = bg->length - bg->zone_capacity;
+
+	if (bg->zone_unusable <= slack)
+		return 0;
+
+	return bg->zone_unusable - slack;
+}
+
+static bool zoned_bg_reclaimable(const struct btrfs_block_group *bg)
+{
+	if (bg->ro)
+		return false;
+
+	if (!btrfs_zoned_bg_is_full(bg))
+		return false;
+
+	if (test_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &bg->runtime_flags))
+		return false;
+
+	return zoned_bg_garbage(bg) > 0;
+}
+
+struct zoned_gc_candidate {
+	struct btrfs_block_group *bg;
+	u64 garbage;
+};
+
+static int zoned_gc_candidate_cmp(const void *a, const void *b)
+{
+	const struct zoned_gc_candidate *ca = a;
+	const struct zoned_gc_candidate *cb = b;
+
+	if (ca->garbage > cb->garbage)
+		return -1;
+	if (ca->garbage < cb->garbage)
+		return 1;
+	return 0;
+}
+
+static u64 zoned_sweep_space_info(struct btrfs_space_info *sinfo, int thresh_pct,
+				  struct zoned_gc_candidate *cands, size_t *nr,
+				  size_t max)
+{
+	struct btrfs_block_group *bg;
+	u64 garbage = 0;
+
+	down_read(&sinfo->groups_sem);
+	for (int i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
+		list_for_each_entry(bg, &sinfo->block_groups[i], list) {
+			u64 bg_garbage;
+			bool below;
+
+			spin_lock(&bg->lock);
+			if (!zoned_bg_reclaimable(bg)) {
+				spin_unlock(&bg->lock);
+				continue;
+			}
+			bg_garbage = zoned_bg_garbage(bg);
+			below = bg->used < mult_perc(bg->length, thresh_pct);
+			if (below)
+				btrfs_mark_bg_to_reclaim(bg);
+			spin_unlock(&bg->lock);
+
+			if (below) {
+				garbage += bg_garbage;
+			} else if (*nr < max) {
+				btrfs_get_block_group(bg);
+				cands[*nr].bg = bg;
+				cands[*nr].garbage = bg_garbage;
+				(*nr)++;
+			}
+		}
+	}
+	up_read(&sinfo->groups_sem);
+
+	return garbage;
+}
+
+void btrfs_zoned_reclaim_sweep(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
+	struct btrfs_space_info *sinfos[] = {
+		data_sinfo,
+		data_sinfo->sub_group[0],
+	};
+	struct zoned_gc_candidate *cands;
+	const u64 target = 2 * fs_info->zone_size;
+	u64 total_bytes = 0;
+	u64 garbage = 0;
+	size_t nr = 0;
+	size_t max;
+	int thresh_pct;
+
+	spin_lock(&data_sinfo->lock);
+	thresh_pct = btrfs_calc_reclaim_threshold(data_sinfo);
+	spin_unlock(&data_sinfo->lock);
+	if (!thresh_pct)
+		return;
+
+	for (int s = 0; s < ARRAY_SIZE(sinfos); s++)
+		total_bytes += READ_ONCE(sinfos[s]->total_bytes);
+
+	max = div64_u64(total_bytes, fs_info->zone_size);
+	cands = kvmalloc_array(max, sizeof(*cands), GFP_NOFS);
+	if (!cands)
+		max = 0;
+
+	for (int s = 0; s < ARRAY_SIZE(sinfos); s++)
+		garbage += zoned_sweep_space_info(sinfos[s], thresh_pct, cands, &nr, max);
+
+	sort(cands, nr, sizeof(*cands), zoned_gc_candidate_cmp, NULL);
+
+	for (size_t i = 0; i < nr; i++) {
+		if (garbage < target) {
+			btrfs_mark_bg_to_reclaim(cands[i].bg);
+			garbage += cands[i].garbage;
+		}
+		btrfs_put_block_group(cands[i].bg);
+	}
+	kvfree(cands);
+}
+
 bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info, u64 flags)
 {
 	struct btrfs_fs_info *fs_info = space_info->fs_info;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index ddbc93d0b8ad..7837dcc91684 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -121,6 +121,7 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
 void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info);
 int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes);
 void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq);
+void btrfs_zoned_reclaim_sweep(struct btrfs_fs_info *fs_info);
 bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info, u64 flags);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
@@ -343,6 +344,8 @@ static inline int btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct s
 	return 0;
 }
 
+static inline void btrfs_zoned_reclaim_sweep(struct btrfs_fs_info *fs_info) { }
+
 static inline bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info,
 						  u64 flags)
 {
-- 
2.56.1

