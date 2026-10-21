Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590115;
	b=WaI7VniG/EzWmpoQ2LqvUGmk5up/YFz4OdRjsOnEo78bJtVNx24B3JaKxu/H/4RL7ycp
	 iTLxpTu54Tf+e7yVvglnY5OeywN33bmppdbPVvleYGpgqRy40bp14B9SpclPHnrof58TV
	 2onLyqG4TtPsZ7b6KP7C8MNw95wnqqsrVFBfzRfVeGILADp7qs3R48S+2kDNt5RTKUUvo
	 B93e4SfxMJQF3IEhOa8KxJ3GXMA5nwPA8bw6/BoSadIKS5Sdn8zqU3aGkBHo/VK90ThPv
	 dBzl54OyzUQAmBnqTx69yMvvPr8JQ3/mUranxVr8+3oPTNscniUwz+m+LaKNL4zGb3A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590115;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-LD-Processed:WDCIPOUTBOUND:
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
	bh=i8e1aGRnoH57vChqQ35d9WArpceIIOvtpudICNncXhs=;
	b=FzYhKHmFfb4OEZSHtaZfj+iYpL3IZkkm+URgP1M1ZfB7tcjb2SbmGgyKoO5ISoQYN54k
	 J/Eqq6jgoBIGVTaqU+SMTjnMO9DLCeOT7F8BoL+HCOiLMA1GeDuaiLLrczWeDiAvQ3pd6
	 tCT9racPl0Ef6XQm7jP08guclNCoJmYcD7Deum+2WVLxMgbFagb66RNJ5fAwDbEdMMlUB
	 6nSOYZ46LUWlV41qMWeDADtbXMeNfWgkVFlVE1c0cCk+mSezmAT/cbf+dcnZw7Mo0x1JL
	 m3BB1WMPfBtsu0D9ikkTfqPix8Ko7eu1J2kykl07eF5sMMP/LWxt6Xbo86F4v5JUjLg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=ZiKvlj3f;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=BgriI66G;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A33606A323
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 13:41:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74A33606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=ZiKvlj3f;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=BgriI66G
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792590114; x=1824126114;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=UCoTEKX5F1FfMLBfZJJve4A+LGr2X0zeF+k+3dd+P8Y=;
  b=ZiKvlj3fAm5PrauqxBz7+hz48ADZMsvMBPv4m4LJRKBx7XCFJ2XmG4W9
   gnNy/m3kR4jfBevrWPgcI3Sc7Pe5Va+/Fc+IhTnGpgJrKl1jeMWOf4mit
   ZdDq1QrN1OSvDMdL20UNnf0fPFlSvVpDDowiqQdKkmAwP4SKM2wMiuJws
   7YUhbEH5WHjPQRlxf7fAW4Yb/9U0uJhIIcEWUi9fVGeROM+PC/0lOeCbj
   Uqn4ZDBfMMVq5n6FgZYTlEPd1++1PfEyLJ/+vcwolxnQLvWf+wd2JDeEB
   B7iS/UdxFxALp5WlqrZqhME7MdXoXnqLLWXko3+xiNpPj+dAwKfmf1n0k
   g==;
X-CSE-ConnectionGUID: k+dySwWLQEyBViUFd/c1Hg==
X-CSE-MsgGUID: ZC2el6HUSJGbCNHr7mNHlg==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="158647856"
Received: from mail-westus2azon11010021.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.21])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 21:41:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m2nS7HCrpcLJJV0lt0PP5KcPMNuZi52v/h7xtqWc+xGYUiTnzaC0Fd94+UXHYLx2SbXGzZTRzRTl0DOq98nvbV7ArSlJkJDawYzJFRiASj8SDH5MzgsaYZgsrahgW9FZonLB9k+2ugqCT4CqxvyCAgJdI+lD/50CmvwR0DLJQAPuzis58Fn4GzdOCJ80eDVaiCbEmSI+PoNkcPv3odxoyJ4my2kh03tjWrpd+apOon+iR+FNKT25P5d2vi3ux+tKTjgHE2b7UfaDzJpDeYoqHrGObX0OGBZhhVkRteRPXGPCKn6hlX7B/o9veUKpVkmMicAoiUGWLx00C8zmn97ABQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i8e1aGRnoH57vChqQ35d9WArpceIIOvtpudICNncXhs=;
 b=SWdvXIm8ATlEqDDB2MUqmG6TAzzKrnF30jY+UZw/T39DGNW1dP3GxhaaXLA+wgUXgGW9mbXn/vApf8FS3VVCgP+4CDQG4LJkWIgxurl3sv5LXFZ2ZT+pAMk8C9V3I6xv0TGxfRzenkiQe971AGE7lxIHmOba6/pFMvbuxIxixEDc+sNmoDxOsif3Py3lL3BBXWVhY4St6qV8OQCRHPk8KXUGBOVDp1nWRwJaiHX8szfPfeCZxopKgAEz4X99ChisdzW27WxulIOeno+uDuJtpE5MeBR62VuPzK1TteiSV0TuGV7uZJiSwLxd77utpZR8jQjLjts/yRgx7gFe7qGuCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i8e1aGRnoH57vChqQ35d9WArpceIIOvtpudICNncXhs=;
 b=BgriI66G5DdZBj61g3qzlnDCu0ftPU6ehlU1deMpFvOYFy7+TZ1llw/vtQmpm5+K0utvoFZamMP2fS5AeRdCqYdFVtJog0ntLBHkyBucOfpBXrvfbw4Qy61t1h4CxFO9KomOnkNCalYjQP19WmUYtVtipOK5aEd716OOq1cDjkw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV2PR04MB9886.namprd04.prod.outlook.com (2603:10b6:408:352::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 13:41:47 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 13:41:44 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v3 01/25] btrfs: zoned: fix possible race for reserved_active_zones
Date: Wed, 21 Oct 2026 15:41:00 +0200
Message-ID: <20261021134124.2338902-2-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021134124.2338902-1-johannes.thumshirn@wdc.com>
References: <20261021134124.2338902-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0100.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::14) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV2PR04MB9886:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d66946e-ed11-4392-1ae8-08df2f790bcc
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|56012099006|11063799006|261009223027099003|18002099003|10067099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 m05MedWKHIFzCrEjheOcuf31s2O28VxWrjwCs4jks75RX4t7nKq15vauXmT+5AcSlg2KTmJsT+FCBWe/UfpsIOez7Q48nKZJ4HvNPMIVpTajHki9JswuAthMfgKSqan1IrBnW5a3zxdgQtFQiPurdOURt6qh52fgwndBcGu9w6supnaZ5Vxwd4fC4PzcZM50yJQmWSKyu1d2LN2t8HACxkVSgrHBOK5NZTMIbtkk1yIIp2X4wDDd9HLnfuZceMGzth0ZktPoq1802w7n4wP2eQ8gj7oTtiiEB051S/+wtI+ZMF36d5pxm06B2qmzZn0oMihJkiEBd06/+OeRSInHKsXYbJW0Z+7KvHvajlvFBh7HdvGYMkktR0t4t45zAqTf1vu1YI8P/T/7J/ckWtVh1kYQtc/yNtS3eey2+oGm4KmGL6PUDjHt6AvZdLyGBpJIdce9rWhYkQjtG5/PBRhXqtfwq/uI8Z5KaRUk/D6tw+eJGsJA+1MLz4x4AtPmy/oc/qNo/epjeX158cq+uFn+SI72ifoDThoSrvnwo+TvR4fHlMMU8s9BQ9AsC9wzaucDK9yNR7Tg82hWH7MMWFcnjIiHfkWxo4SoVYyi/dwYLvHGKa6+iinxfK22KbkXK28H317FcpwWqPZ7+bsuK5FSeS9o/kjVHMQG9KGEDl+4ZQM=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(56012099006)(11063799006)(261009223027099003)(18002099003)(10067099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?0q8C07FfAsCw1ERt3FQN0dSPjw+9hvT+QyaT6uI8HGND2jvZw48JHNfjGGwk?=
 =?us-ascii?Q?hlYI+jXyul6PwjHQSqjWzoxhl3rJZqjwZzpooo47mP2DH/quAhQNUFxCWoeU?=
 =?us-ascii?Q?mvDynZa/uVxrgBUg+adkxe+J58WplJmJQs6XtEdeMWidi6/FqYDEK08ez2l2?=
 =?us-ascii?Q?bSK3KBRlB34GRkegdZlGTOqQiIes9HxR65AeGOZo4MdxcyogQUOmqWjNrbEh?=
 =?us-ascii?Q?ziV69KReLSO/NABmGLP3Bpe+B2DfqJDJBeVwOxe8Cmk0loAcno3icCmRptr5?=
 =?us-ascii?Q?ypljSTklxjg+UcXRjpm8oTOeGa+r1HsC144DSwI9O2Nhlbt6CFxV9zXuIfwh?=
 =?us-ascii?Q?tNe8Gv2y8cTInl0iaIj2y3eBpRiUG8B+x+r63I1Ld/fCkxa5CUKFN2521tBq?=
 =?us-ascii?Q?pr9+ttS4UwSZFGiB0BBbEDTel9Eb2fYwn4vx0n/ogJVDaLkTJSDWV8PywbkT?=
 =?us-ascii?Q?2DTwRKeUTmPF4InEj095E0+R5CbweRpNGy9pNky86ysICzgjRJZ3wFG5L6v/?=
 =?us-ascii?Q?N3Cp4s/Yk1Y34nRouRaACBOiIZbDIo0/Uohu1yN2ACdscWYhdlF8rwIpNmv4?=
 =?us-ascii?Q?k63VqqgEyWPhojCn5asi2W3V0EbA2xGltm4PtWH/En50YNHIq3VEj0neUYDT?=
 =?us-ascii?Q?f5+lkayVy+iwbydCmqJEj316aJFKOf5u4AMi8To6urZFjHDKELpafL4HVkrg?=
 =?us-ascii?Q?8jGCnQ28NbXmEFlRFhnrJ98/5mTbccAjGsw90Y0uKhUPYZ+WuoX/9UeZOEm4?=
 =?us-ascii?Q?P4lhLFHLnPdzulDlGf21nOHyZQWHj/Yt0k/zcDZqAVLY8OCkKl1QslwipaEd?=
 =?us-ascii?Q?pGdv0s79Y4uzdnRfv2FZpMadCWn/pWVBdj5gKuefoXxt0V/EEcflCdiXtWuj?=
 =?us-ascii?Q?/nqfBdwtw4e2os5vV0YsWPAmEc78mZbfw3p84Gn0pHJrSLWrTujZ6Ax6VJIY?=
 =?us-ascii?Q?hQOTXl8CdhbVQHJw581zFs0u2RxEYguqQnzQroONfNzsLQjHVPmm22HFLsI0?=
 =?us-ascii?Q?rSllxXFtkQNeLaf5h/Ky+ANMay4QL1tt/4y7QDJgmzG2x+EDHmM2oFKJrCX+?=
 =?us-ascii?Q?axzlVQFCgTLcwmjY6Ov62cEHj8eNPbPi7tZVvc1o3h3AxyDdEXz5ZwDKwyzh?=
 =?us-ascii?Q?csO28tsxij1mXNACwBiCxqvjGhsoUCdhmiB/scYH5tAbbuKdkrzG45HpH30Q?=
 =?us-ascii?Q?Cva7GuxS860XZXnBZPdi0OpNqXG9T7Z+zlHZ21OzmW9WprHhM99mGnyTlDc/?=
 =?us-ascii?Q?DBWc8UBCQmU2YkyW8Eo9zgNL82yTERNPzGpSWQPGvNhyb4vjyqibL8GjLwGp?=
 =?us-ascii?Q?mxrqUTnHHHH9+7dKH0aMMivjCpM6+tiDH4teggqR8wlpAgru8pbNGPDVmlZc?=
 =?us-ascii?Q?C2H+yKzNNhWqvgOkcgxi3p4/e0AD2FVTQA73Et1ypzUEBJmThzOE8fm/vjVI?=
 =?us-ascii?Q?CXIDUKhOVm7Pws2YKu90aE99NUncJI3ibTVXKrDKytqJbst27qEYHeO8NhHA?=
 =?us-ascii?Q?vY8+nxdn2o5SI2ks4Nj6iXRXeRIaPaH4VoK2lB2QG+2V/WWpPj1ZI1Gn5q44?=
 =?us-ascii?Q?vyv80kWgmbOgZwEzGxZ9cMc7QQzzIiy1YvxZLam0Y1Y90j41K/B7MiXiM82X?=
 =?us-ascii?Q?F0CJrxZkdXUGL4/FLnZnQnIM2I5S2Kp77qpKdXskXMrNYndlyxWorEclYbNS?=
 =?us-ascii?Q?MoX2cueBg3yV6Zn5yHzft78k1T76zY9hX3Lsd5fKHOmRoI8TtkpNuT57PzNS?=
 =?us-ascii?Q?hhiZMN7ZMMu9ZGZFTzeqI+7mU7F3eIgoeOn1+4y4Ng6xg5fVRi7QyPWetelo?=
X-MS-Exchange-AntiSpam-MessageData-1: lOGSMKnl27eyALqFH0K4xtuNNPm6qUi3nt0=
X-Exchange-RoutingPolicyChecked:
	aqMW3wNs+q686VMH8smizgev3gPhKCv3OhWdIH1dQt1mkWWqhpspEBU6PS721VsTzD7ANHpyvXl7PBItnxcl6dXXmkvWnZQCy1YBrXYGThOgJyZ3S/wcOMhdbsf76vaXX1eWu4UdXx7oYfd9bRH8y5Ry46mRXFCtyjxB7/WyzvjO6fmKPjmKDrHUbeheuFJHDcgUZsB4MrTYpE0jCN3nfRxE4QaKwv4LYjzoOyiWWru3uHT0grz6FjH9SJG2PV1sx0Kc7/DChIDh8xIfinRAtD+gKyOY66l8KOYqJUtDTLowVU8ThqwDHI7FlobT7OXJ8iEJxvdd+kKTJZhEe05eqA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VoOAwitsPJ+4OCv9b5j2kV6xVzWmHOBQOgjnNQzgav7PaBkroLoPyngTS3aKoTD9ppZ1HIskQOgMW3sj1hP5ZBKwEHZBiZ0ZPxfgyq083/9+t+5zgJWmjGScnGtgwNAfqvshbzWVRm9K7TKln/yRabNiTf3zp0dywr/oUDJqVfvJJ6XYVKocuCUlR5wGP6NdAJ44CCmEuvXhRuWLiH/gAyfSD4C/BWaifEXd00HKujd/aQIqLDP8gf+ZPLNKxgr20ujIu847h097SxH4TXiXE1FgL0suNBQjQ4s40O4FEWSXkdDOZi7EDKKCi3R7g0uhFoxYWGxbeiPjc8w3sytUSvxO+iDsRfCCywDWMcfQr32UtKRZ1AGYEyBVkinODhLA9qAhNbjNkFE1HYrqsjo5ADeVTLpb2NGmIh7437q/kbSD9XoHr8wg6N8ZqMxr9WQAIylkwskxG4T/S7JpIElP8gsPwPqDMr7xwAgtTPdA0EawMHfR3LHh6h7nmZ+gLqliZ0kh1BFT39DQruo9HkAbgbfsSSXIItz8d9oTwVlkSl0WDGXQ6xGLDy8LKGOvvRLOUj10otPTxLi1Tis2grHL4DrYqM71OzyAcwq3A50lLruj/xAVqO35ueMRKWeCiKwY
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d66946e-ed11-4392-1ae8-08df2f790bcc
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:41:44.7809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8FCmBImT/vg2E9B6eOsM1wC8cFR7GBLz6oSoifKpyoxm2nUca2geUexo1bL2uPOsUo0FKRSHv9BYBAOkolEPuNJigDOIYNE+GYB6NUS3YXk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR04MB9886

In call_zone_finish() the counter for reserved active zones is
incremented without holding the per filesystem zone_active_bgs_lock
potentially leading to a race for the active zone count.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: a7e1ac7bdc5a ("btrfs: zoned: reserve zones for an active metadata/system block group")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index c0bd5e086886..8e2de2640457 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2547,8 +2547,13 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 	}
 
 	cleared = btrfs_dev_clear_active_zone(device, physical);
-	if (!(block_group->flags & BTRFS_BLOCK_GROUP_DATA) && cleared)
+	if (!(block_group->flags & BTRFS_BLOCK_GROUP_DATA) && cleared) {
+		struct btrfs_fs_info *fs_info = block_group->fs_info;
+
+		spin_lock(&fs_info->zone_active_bgs_lock);
 		zinfo->reserved_active_zones++;
+		spin_unlock(&fs_info->zone_active_bgs_lock);
+	}
 
 	return 0;
 }
-- 
2.56.0

