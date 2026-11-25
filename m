Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602628;
	b=vwvvZS94ZrH+E3AF6/kjB0x5GyJ65RC8eGv1gcXerh0adNdQK5oVVd6jpEzaONcotJyN
	 lQs5ZKH+Y+MJI0vDy6m8h6QqrPAvC5NZ1KnjZ7QtPTJPUfWA727AYIuJMfKjtcY/JhTtC
	 36sHLnJKwbe9Lf0iJxojNpNE/9IJmr99chotU7Cy9LwWZaCQl3r/4PU/rq0mip/ECUgJb
	 4wk6GuV3xEVSLW2J/0po6w1c+mLEKrq39gRqeFudj/e80bBu4EZ7orO4UgXKaZi9PRWnF
	 ySHfI+DeZZ92sQj9ZaUjyHTnikGhb0ihG9oEjSjkAFSR5FvVfVMUSvSeKfhj6jm3BUg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602628;
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
	bh=189NoHcnpHlGl3+COYMneevTSOQvKIV4FJzfNIMumnE=;
	b=BYK1eckrAyeVwmpUs1TDr+eau36m7FINaDR+6UHkN9nuNnMwMUglzBY7QnOsUX5GL5bk
	 tx7izv4R/UAzTDuye/jJ2rsodk8i+4VHNJfGpow0XfVbd4W5Odwktg+SmgmoNK5fq3WVu
	 v9DQS2DBNU7klKPIWtVm/cVu2FgNIPUBO3EhFYFVuf6JBaXb6voS2zc752xo2/zWM4GFx
	 THFCEfUcBmnJiFbvAHGwWDV96YvkrpTyBX3x4d+3zZfXS2HFslZlQXZvZHXvl07cY8AYV
	 s0qNagGm/BmR5Q/MpE2z1kb816uw02v5Vvcjw1eiJwI/nQvo63IFBj63sjFmTigbs9g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=j47TnARo;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=IbOWliEA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A700606A326
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:30:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A700606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=j47TnARo;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=IbOWliEA
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602627; x=1827138627;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Y/NEDX1B523mR0KPR7peb7cE9WK4fGw18385eTdn1wg=;
  b=j47TnARoXMR/IfpAH4KXbPRBR4czQbd33W794tOk5hzvlquiLDDRlDMd
   1bbxqvoNY1OYnjgu/KAGdQvwAIGvI9fvoPtIDnJwzxxqPhw+8HeoL/cb0
   kbIWR2uzLbjnHh/HLPf4g/+ntjxGJzYyjsSJUxHrACb7a+KUgVU3HTb7v
   YpCWzyvSQ5bgNa2Pvm9likyeix4jtQVOE8fEBHvnGJhFl1SMrS825Y+ak
   6kNmpwe6TSZYmJeElL4lIq3MV2FHnGgtXY87S9cDGuEc6ymBIdC4wS7nD
   KuIMKT193Ak7Xl9Yc3nGDR97YoIDKxNRSQUmdiwmk5ZChcJFQ92yM6WgX
   A==;
X-CSE-ConnectionGUID: 2yj2KT+ARw+XTq7V2J0lgw==
X-CSE-MsgGUID: hrh0911HRaWp3+tcBUF+kA==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="161662147"
Received: from mail-westus2azon11012067.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.67])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:30:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xgxdtdDiHSNGhg3Chzkt2vEg+0Xm1ipgtkMw2oYZmiRb6J9LHv75lGZuyFnl1yJPerFI4ULtrYHWL9gyKMenWkqskidmG9GwDQKiSr/YMS1rOpcrK0Oqg4UAM1ANuo17VIre26iKs0Z+SNfOepXcDrNXFNcoxKrh2UIdxb3+7leRfBoAWAsHCoykFr+MrlouTBXvGlvyLaZaodlaTrWtU73BvOnKpuFVAVH+IquzbUa2eKFdaUqwYoLg0eUwiB5Jz6/nDPx3yKIGcDs7yuR0c0eFZ0+cMedKklDDJpzRKM8/wKdVw4TgiITr1aE9MJdD0/nSZgoyfhvEYDzgpOSl+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=189NoHcnpHlGl3+COYMneevTSOQvKIV4FJzfNIMumnE=;
 b=uEgLTBDFecB64sWy5jMKmAPqFul8QpgAcaI8YYFmFbXJvDG/EhtEjVlpWwxx5IoFZtobM9BKgw4l3ChxBkukXiclv3d1MLlv2mrG9OPERptPLiwpJfI2YR9PeefX15eIX6j3AN5y4ugCtSAX/djhp6jAgTjxPjBWEIW/d2yh3S42LngK7Sx8id2lUUbNz8sP492f7ovl3cgGjSHNQkV4XTemB/x7abCh4c4E4MaIAJxFJae5/NG8Dv95CRyBgz91kBotQpxU9O0LSKNv9vgYjwRyH1bsbtfsUIeuVhknu8/NT1HiOKmE0xFZ39J/PCUsuVuwFovNZDxkG6WKJwRbYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=189NoHcnpHlGl3+COYMneevTSOQvKIV4FJzfNIMumnE=;
 b=IbOWliEAk2luVJxa3mcKEl+Su8VrHkxl6h/6Yxgf+kSZFpBuKNHW34H2j+qVuykSju/ikvbTBqyRHh5ontcW81DmwC9kg9b8cFFZs/ZvxBJnDOmBqjQqD0Zj6DdhCbpSRiTVkQIFIGKMz8VbGhqt+3/UxrYMBPH6MPPwG0GBF94=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7870.namprd04.prod.outlook.com (2603:10b6:a03:37e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 10:30:25 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:30:24 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v8 05/27] btrfs: zoned: skip the append only metadata writeback path for conventional block groups
Date: Wed, 25 Nov 2026 11:29:34 +0100
Message-ID: <20261125102956.266389-6-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125102956.266389-1-johannes.thumshirn@wdc.com>
References: <20261125102956.266389-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0411.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7870:EE_
X-MS-Office365-Filtering-Correlation-Id: f375c3d5-a82b-41ac-2282-08df4adf1db4
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|10070799003|23010399003|1800799024|19092799006|10067099003|56012099006|5023799004|11063799006|260925022911599003|260925021911599003|260925021311599003|261022105027099003|261022075727099003|261028144727099003|261026121527099003|261026140227099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	RSsIcpfenGukL+gkHOAx8YdT3uxryGHoQw+NA+LmZ1Hk5/VqrDSJk0eBR3VCIAZA0ZSAvdNbYO9c7j6OkidujTc8MWU+lPH+djEDxhmYl7apa1BAyAOBl/+f52FlQCzVTl+Sa4cG5HPY5lK4mOx2BW/zfPr3FxsUaJdnAB2T7jwhOo9ExueK8uxOdynXD//B/cDUvCOscy5f2vtkDQlWgX8p3vfyisWaE2Ip5IB4ZNu8EIggAp6PMEHuGv1smIHICGtC99J+OYQQGgHXiDEv0l/Ed2dqssT5/t+P4/8lwM+sGdLqlb5A6FjbV0imB72vz8YsAEkKGK/tmEqLw6LhoozgC9RI9/OBB5CfbrbSWDwOyYjIop4qc92R2FjB9jV484L1KwVOEyC1keJqJgg+PUpBa6eLJ6Ifus8vC2fKjKavMT8oUFdRwuyALWeCchmwhr4wtqgPyY1DSrmi9vxMGI/BBOxPcJhOa5ehjNKz5eaGt1KTnb9jgSO2+RHFQmpFZKe6kQq8nzLAfKif77LJzSO8Dg6a3E8jWD3TrGtb5KYiOWjLOPtBQDPCMw8qADvubW+PK7ux3DxEBeeBI5QNJKYuwRk1SfYPWmEBntgHG6czdf9kx4k4+KhU89w5myvMgkGr9JV4nvoPb/FHRdZd9x3jweNmryHY11d5DCV+cUM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(23010399003)(1800799024)(19092799006)(10067099003)(56012099006)(5023799004)(11063799006)(260925022911599003)(260925021911599003)(260925021311599003)(261022105027099003)(261022075727099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7DNPDk0Q7s6K5wJKbV+quYCuWMNJ+1ZEDxwRbvMBv4fLJH+XBTvDxAf0mVy+?=
 =?us-ascii?Q?dzHv/ev6MpZ3fubCwHAx11bbEC4WMn9CZGeGJK57v1XMTgiFgGRtlkehA5O8?=
 =?us-ascii?Q?MRAYt7q5bmJq/vpsd6xLcA+N9aid/O/1/7XNG8Ig/pdeWFM1xjMoY/4m9vSR?=
 =?us-ascii?Q?OSXMHDH2UUC3fB+YPT79KtLknj/8bJLhGM4ZY7x+mk/21wrd/kjzdLgL30kK?=
 =?us-ascii?Q?i3JrJxCn8MgqWW4G1sLNJj8ICdVlQHsCrWL2WdLmU9P4Yqseuo7LLssScjdX?=
 =?us-ascii?Q?mab0ghk8bEWTQiykbNgWSZRrwiy6uVxQPFRn2j4C3JvDFDhXhwt/uacSs3lZ?=
 =?us-ascii?Q?u/OOc79X46ACu+ezDrov/w9HMX4Qe5TyQLQ8lJEstVLSBVAwF29lTAxaZfZI?=
 =?us-ascii?Q?5QLXJyVCeLuQpJ5raBViaNaMhwLz8P8x6xv7w0Uh9TSyzIMP7LX6QBJQDK6n?=
 =?us-ascii?Q?xMPH1nnqLiJM/Pq0WL4S2xeQXjfw8r7B4qFYJ+2Xsj3RUg8ye8xrg15Ahor8?=
 =?us-ascii?Q?zVcIhRigT3l669nooqLm2xymW6Z6lSlv4e4IcsCDsKBTrvGKV/bO0dPYYb2V?=
 =?us-ascii?Q?luzJNlSDSHNUU1IUkMeDSPk50cgKRS6rLZwRiOp6A/oXBkMgh5eSX9eNS9PH?=
 =?us-ascii?Q?ED4j0Yeb1zuuJil8JlBcMC0ua9aurD8I17PEKkcNSOv4vPgePGB0c7Reakiq?=
 =?us-ascii?Q?xGQWvwlQk0VuHbS3y8jlBIO167nmIyGZh6OqRrw6c+k0kPzS2+o75inCBUS4?=
 =?us-ascii?Q?N412FEO2FIRy2tyNcuu8xrQuPEG2kGWosAh4rYGyfpSwFJHBQHKQ+8fH8Mm6?=
 =?us-ascii?Q?JnVbdwxerDhcg+O0v2v+kl1MBbV7uEuMBDP4FJY4gBnDu0aQKzzTUi0WDU1T?=
 =?us-ascii?Q?2geNDvDLgqtm6bJdz7Ib1U944oQNxsb5z+ZmDdNZtQjex0PxudbBWcgHruJp?=
 =?us-ascii?Q?e9pZiapxhPBSGBiES4PNbQA5BMSPDKuiB2daDE8Vm8VHhDVIHY29ihJO/bBk?=
 =?us-ascii?Q?GFM3d5yXHDOzBVsqgERT8TQiTCKtBmsUldr5sk3UOlRJNo8KI43A9HFHMIt7?=
 =?us-ascii?Q?zt20SYMXxUGTE7QLxSPTekTD73++N2xv8rlZBLNXEWhlptjvuje92kck7fV8?=
 =?us-ascii?Q?4HwXvoPG7msTTz+GqlQgvtZo8abivYYiM0sYa3o/NsNm/DGDIBgZDYmIrakI?=
 =?us-ascii?Q?UsaVDAS6jOsKbAAFCrQxCs2IQRKnbD8pEOsC6G5MtsmTPWohldRJXU996gyc?=
 =?us-ascii?Q?HQi692Bul2sO8ZXxuPa+TrbX4gUGSX/sm9mEO4K1NubrDJA2oZTJrP2EE8hQ?=
 =?us-ascii?Q?kndrBJQkkBQVLgXALrXXHEpt/zhQDp1R9StL2VjQw/GnlxWpk7hp7A1vGRA/?=
 =?us-ascii?Q?ap/HVj4rB9mEkWdvm1x9cRKVhHkFMl08gHkMJBvhOrsxLJnVp1CRfaQqDD2P?=
 =?us-ascii?Q?YKvS0hNstAnOiqn5LKIWSxcLTNZm7K6lshKBOfIBbzIs446xKr0GOe/jTkou?=
 =?us-ascii?Q?Zy3bJxB95jlr2oldxWjQ4EIa3BkhW35qWJz41qOV0LK9tOZZTv7VXTIhFO2n?=
 =?us-ascii?Q?DuUTSGw4M8wKBp4H0yKg6RDD/gSXXRSNrJX9mGSYh14Ztsm65XDS+aClc6cP?=
 =?us-ascii?Q?VoM7W1J8KqnV9IrQcokzJLrLnmfAeijKhxhHG5ml1gDYjOmBYDGzJsKyDaDS?=
 =?us-ascii?Q?mCxTQhypfGC4KHHtxVO8G8AszJSEy2E9lzsOk6cyWyraSWZC9l31w9qRDPkO?=
 =?us-ascii?Q?U4TcHjwUFG4Id+mk6wUL2VSiTak8BJqVCNZoOLvy0afAxQhn1xTm2sN2G9UZ?=
X-MS-Exchange-AntiSpam-MessageData-1: NugvyuG+vOT2PoqVHdI8ArTMaY5kwrlNgrs=
X-Exchange-RoutingPolicyChecked:
	eO3QcadR62HLHvRk3KrBJzvbSknAxXZazvFm51XLxTbgyfHAQ3dM/4korzmpAQYD9Mn2oDYJt+9FZt4v6nkWKP7HmgdabtOcZLuxO8DydaKcijGICwV4hPMdYH34ig4mILzDXC2ica4bsFh9Wufq9hw2lXEmOZXT89daIukyk2UGYOb0IU+LSgMqtt4oyDuFRodL5CsFZwLlW1kod+FWpHaBiprqWj5zGIg57MPIZww1FohZFrwQ7apWIRuf9yzZeHDs9UrMFgu0MNcT96rSNt8TgwO+LQFE64m0ZghdiRPFbQTh5Al2Jq1CHPd5QvR51GqENR4CzCMKb4HD4CQmkw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BLUp8ZgeIC9Rd5ahP4w7XZ4g04qCmytUggDxMnfmh+qduPEq6vw+LlKSTE53yz+a6jbpjjefN1q8joejxXxRMDh9hxK34ALtTOSc3toE7/TbBwVWzHUENEukNjP3Qds+pae+JISk0L1IFDzTjN59Gi4j1Y1+P8/jYoxuM5waOQ2o70qhblEssVdTJVkh7T8wB8NOGS4JXga3T8AAbRagG6c1pqlQ64lYmCPra9mM+qNJDVfOv3u4D2ayy3c8RJLe2x/94sktWrwoHywV09Xq8CmvXBK1tZIyhqdyj6XE6oIVn9yvW9CYEZmciJZ789D+S8OKBwd21/68ju688xzln9LU1ZBfgOWWszm/sxwpd8txtiXnWx7Syh0X3xvZV+jZI9YWUjGOsglE72UJnFlpJignV52JOtluBjOU2/3ACjxfdJXinfbKg+nbJi8N7u/oRNA4vUxGLbqf4pC1eyoFocNO2IxQCLiSVP8H879Ap5SfdYOtBl9nBXP3Fln832oeu76g462h7yrvMUZbFZZETX66pt5TJHjgGXjk7xXMUrh3leFbAWlyYY3Y9N06zsLHSGrzRjDvW3daoMyBVpkndWE2HTborMK4tOtMiemutmvMP1HIF2xI7YLVnQV/Lvsb
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f375c3d5-a82b-41ac-2282-08df4adf1db4
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:30:24.8430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0EJy5MdaKEh0D+LrtapjA5hekuLvw/XeiMzAYNp+6mtDGd1i3MZaQlD8F+yOEErYxBVjxMu/PgGjQOThAeUAwCX9QVjOVIjiq+JwSm/4aUU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7870

Metadata living in a block group backed by conventional zones only can
be overwritten in place and in arbitrary order. There is no write
pointer to honour, so there is no need to serialize the extent buffer
writeback against block_group::meta_write_pointer, to keep a zone
active, or to write out a freed tree block as zeros just to advance the
write pointer.

Add btrfs_zoned_bg_is_append_only() and use it to bypass all of that
for such block groups, which lets metadata writeback proceed out of
order and with a queue depth larger than one.

Freeing a dirty tree block needs to know whether its block group is
append only. Count metadata block groups with and without sequential
zones, so the block group lookup is only needed if both kinds exist.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c | 10 +++++++---
 fs/btrfs/extent_io.c   | 10 +++++-----
 fs/btrfs/fs.h          |  2 ++
 fs/btrfs/zoned.c       | 28 +++++++++++++++++++++++++++-
 fs/btrfs/zoned.h       | 34 ++++++++++++++++++++++++++++++++++
 5 files changed, 75 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index a40eedc65dd2..77bc4176cb3e 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -64,11 +64,11 @@ int btrfs_should_fragment_free_space(const struct btrfs_block_group *block_group
 
 static inline bool has_unwritten_metadata(struct btrfs_block_group *block_group)
 {
-	/* The meta_write_pointer is available only on the zoned setup. */
-	if (!btrfs_is_zoned(block_group->fs_info))
+	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
 		return false;
 
-	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
+	/* The meta_write_pointer is tracked for append only block groups only. */
+	if (!btrfs_zoned_bg_is_append_only(block_group))
 		return false;
 
 	return block_group->start + block_group->alloc_offset >
@@ -248,6 +248,9 @@ static int btrfs_add_block_group_cache(struct btrfs_block_group *block_group)
 		ret = -EEXIST;
 	write_unlock(&fs_info->block_group_cache_lock);
 
+	if (!ret)
+		btrfs_zoned_account_meta_bg(block_group, 1);
+
 	return ret;
 }
 
@@ -1204,6 +1207,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	rb_erase_cached(&block_group->cache_node,
 			&fs_info->block_group_cache_tree);
 	RB_CLEAR_NODE(&block_group->cache_node);
+	btrfs_zoned_account_meta_bg(block_group, -1);
 
 	/* Once for the block groups rbtree */
 	btrfs_put_block_group(block_group);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b2739838c646..6ba202b312b5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2535,8 +2535,7 @@ static int write_meta_extent_buffer(struct btrfs_eb_write_context *ctx,
 	if (!lock_extent_buffer_for_io(eb, wbc))
 		return 0;
 
-	/* Implies write in zoned mode. */
-	if (ctx->zoned_bg) {
+	if (ctx->zoned_bg && btrfs_zoned_bg_is_append_only(ctx->zoned_bg)) {
 		/* Mark the last eb in the block group. */
 		btrfs_schedule_zone_finish_bg(ctx->zoned_bg, eb);
 		ctx->zoned_bg->meta_write_pointer += eb->len;
@@ -4169,13 +4168,14 @@ void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
 	/*
 	 * Instead of clearing the dirty flag off of the buffer, mark it as
 	 * EXTENT_BUFFER_ZONED_ZEROOUT. This allows us to preserve
-	 * write-ordering in zoned mode, without the need to later re-dirty
-	 * the extent_buffer.
+	 * write-ordering in append only block groups, without the need to
+	 * later re-dirty the extent_buffer.
 	 *
 	 * The actual zeroout of the buffer will happen later in
 	 * btree_csum_one_bio.
 	 */
-	if (btrfs_is_zoned(fs_info) && test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags)) {
+	if (test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags) &&
+	    btrfs_zoned_meta_is_append_only(fs_info, eb->start)) {
 		set_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags);
 		return;
 	}
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 84a6eb2ebf83..401a5fcf45d5 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -919,6 +919,8 @@ struct btrfs_fs_info {
 	u64 max_zone_append_size;
 
 	struct mutex zoned_meta_io_lock;
+	atomic_t zoned_seq_meta_bgs;
+	atomic_t zoned_conv_meta_bgs;
 	spinlock_t treelog_bg_lock;
 	u64 treelog_bg;
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 0b29d15b9fab..2279e5c8ec31 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2300,6 +2300,9 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 		ctx->zoned_bg = block_group;
 	}
 
+	if (!btrfs_zoned_bg_is_append_only(block_group))
+		return 0;
+
 	if (block_group->meta_write_pointer == eb->start) {
 		struct btrfs_block_group **tgt;
 
@@ -2327,6 +2330,29 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 	return -EBUSY;
 }
 
+bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info, u64 logical)
+{
+	struct btrfs_block_group *bg;
+	bool ret;
+
+	if (!btrfs_is_zoned(fs_info))
+		return false;
+
+	if (!atomic_read(&fs_info->zoned_conv_meta_bgs))
+		return true;
+	if (!atomic_read(&fs_info->zoned_seq_meta_bgs))
+		return false;
+
+	bg = btrfs_lookup_block_group(fs_info, logical);
+	if (!bg)
+		return false;
+
+	ret = btrfs_zoned_bg_is_append_only(bg);
+	btrfs_put_block_group(bg);
+
+	return ret;
+}
+
 int btrfs_zoned_issue_zeroout(struct btrfs_device *device, u64 physical, u64 length)
 {
 	if (!btrfs_dev_is_sequential(device, physical))
@@ -2594,7 +2620,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	}
 
 	/* Check if we have unwritten allocated space */
-	if (is_metadata &&
+	if (is_metadata && btrfs_zoned_bg_is_append_only(block_group) &&
 	    block_group->start + block_group->alloc_offset > block_group->meta_write_pointer) {
 		spin_unlock(&block_group->lock);
 		return -EAGAIN;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 2225090839f3..3c561f6ad228 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -81,6 +81,7 @@ bool btrfs_use_zone_append(struct btrfs_bio *bbio);
 void btrfs_record_physical_zoned(struct btrfs_bio *bbio);
 int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 				   struct btrfs_eb_write_context *ctx);
+bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info, u64 logical);
 int btrfs_zoned_issue_zeroout(struct btrfs_device *device, u64 physical, u64 length);
 int btrfs_sync_zone_write_pointer(struct btrfs_device *tgt_dev, u64 logical,
 				  u64 physical_start, u64 physical_pos);
@@ -220,6 +221,12 @@ static inline int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+static inline bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info,
+						   u64 logical)
+{
+	return false;
+}
+
 static inline int btrfs_zoned_issue_zeroout(struct btrfs_device *device,
 					    u64 physical, u64 length)
 {
@@ -439,4 +446,31 @@ static inline bool btrfs_zoned_bg_is_full(const struct btrfs_block_group *bg)
 	return (bg->alloc_offset == bg->zone_capacity);
 }
 
+/*
+ * Data is always allocated append only, even on conventional zones. Metadata
+ * only has to be, if the block group has at least one sequential zone.
+ */
+static inline bool btrfs_zoned_bg_is_append_only(const struct btrfs_block_group *bg)
+{
+	if (!btrfs_is_zoned(bg->fs_info))
+		return false;
+	if (bg->flags & BTRFS_BLOCK_GROUP_DATA)
+		return true;
+
+	return test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &bg->runtime_flags);
+}
+
+static inline void btrfs_zoned_account_meta_bg(struct btrfs_block_group *bg, int delta)
+{
+	struct btrfs_fs_info *fs_info = bg->fs_info;
+
+	if (!btrfs_is_zoned(fs_info) || (bg->flags & BTRFS_BLOCK_GROUP_DATA))
+		return;
+
+	if (test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &bg->runtime_flags))
+		atomic_add(delta, &fs_info->zoned_seq_meta_bgs);
+	else
+		atomic_add(delta, &fs_info->zoned_conv_meta_bgs);
+}
+
 #endif
-- 
2.56.1

