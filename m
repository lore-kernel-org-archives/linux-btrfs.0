Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794246730;
	b=5mKX/4lnowrcqP+qztdzZ7PPNyGYBfks4vKdBm34kKx1bGOVd77v1Yiut1DMH0JqVdc2
	 IYDNZO+AUyylDtAHYjHAu4JshYeh5Q+zsgU5ruxRtMG+d5zZfjDZdWoBDIBatF9J6myqu
	 1dKiZ1mK5eAMB2XxVZZlVDe0Oym4JoGVZdnT2OSo1IK6l2ha9v897hUEw5oijtVephncC
	 G6SOazhf64/QlprWqIfUc5HQqPaFqCsVDXWaiJkbx69q71f8AqqUBYB6UGWcq5WZ+pPSb
	 P+2x0JlZ2ksVwp+5M1I5/9fhFF/S39KgwZQItLrvdX5GGA29/U8hsyc7jXyrGxsB6vA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794246730;
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
	bh=LWPw7VPXLtYo8AOiJfBzWuP1aokbNfpxJg26OG93qeg=;
	b=Q7JhRmQ5NXvx+Lgi3KS4QX/z4oQriVaqMmzll/qmAhhbgS7/I/Xd23RXVuAZVQc4Xatk
	 onpBNEGtrD3VKWcxYrXZ/YORKhjE40Q0LKKWbJFFOJTWTNbwI1MzZSsHQsMSGjf3eGXlQ
	 mDOgxIYnvJV37R3VOpEWX6+eBVrElgNuMZggjmN2nv+7ejonwLa//4fquGTDDk4aYwX8D
	 bFHd/izGgPcnS1mAHU1jL1qmcsgLQTkjvYHVnpvHoV9EtBzkbFUiUipVRwBp5XotzGjCO
	 xIOVkBz83rTMLZGlXxaYa/UzJx6WHD2g8onO7bdU2Z8ZxiFFk8z9GzfLnLwiBBMZfUw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="kR/2a+03";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=PWuMp+QL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525F260A2608;
	Mon,  9 Nov 2026 17:52:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 525F260A2608
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=kR/2a+03;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=PWuMp+QL
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794246729; x=1825782729;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=NQvON/4q7neqpqot43uV0wW4CpuTPFN9TlzzdQmd1Co=;
  b=kR/2a+0396lkSDi7ZZyBhjpMlWhjJ1extjubGg9NXBMjs+ushSgdHhkz
   xcEJiqk+YKHIsrUzJv2hZQfYpbyTNbZtXcYhsAhmpk7+y6lOb7/8Zedf0
   l2wgprTb7Af6nLHrgokQ5VNpCqXond5krn81y/bgAggcXZ+r1wFG5mpzS
   PfRWpbcHT8S4h9+ajPR53WgexZprSMyDkyskiSe4VUYZq8ew7Tqnc3Yaa
   bBwa96980hZnqKqp8jGBhSwrN+TmqweYdcBUeiOlIGY54vTKbGRvDvh9P
   /1sFicrGMYwvi+G8thwdh1oos6cf201SjiVTxdhe2l8GqVkjzIBKtE6HN
   A==;
X-CSE-ConnectionGUID: jspg6X4GS5q7vbaCJwnPQQ==
X-CSE-MsgGUID: sA6GhOa+QnG/Xvm+X4MoVw==
X-IronPort-AV: E=Sophos;i="6.27,204,1786982400"; 
   d="scan'208";a="161353150"
Received: from mail-westus3azon11010052.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.52])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Nov 2026 01:52:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gJW2mOv9ozUle8eBw1X9zgFN1Jiy9NsGERSGlRM71yhe9F4Cp+5OAf1IB61lh1JxHvXRCWbta/CMXVw6VGwjUB6685+SzfQqSp2SJd83Er9hzpxJoO937nJEMhyRqF0Rew7JkJvrRmuy9dYJ3nRiLHfnZvkb7oJEkK/ZD59SlV6/Wfos9RfH1GibWh46O1OYo/gQPG4Ra2hn/B02nn2aD2EAguAzFVGilSpT1fqvyPt13ru06LPfkYRb3f9sXalwW+amnoorzhrnEl9tWJuB1Y/BLWXE1kETiQRLMnDRj1uakXLQFSyrKF9Bm7BEWUISekqRxvJaAiOljRPtdQGJlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LWPw7VPXLtYo8AOiJfBzWuP1aokbNfpxJg26OG93qeg=;
 b=bi03P0Csx9kNj/hcRtXfc1FksEVO8aD5y5EikL3RWL0w2v79tcli2HTMB6lLg5wvlahzZcOjwiI9bVMsdNs4vedt/Pi+n+2gfmtpP1Uho+JMUV5pPm46kdgSs9EuC0xR12cErHdQMFypT06HhTxfo/ftE0nIzqNqbGsRrmjIcv6yHZtEAfbCWcKs3QWAO0lxKT/eRsexNNj9VoIYCxzP/BA3L284CUSQk++njtCllOX03t8JEQDxR869GW/uhY48XqtpXtzBew4g/Qs4nqTK7vLhYCjFC3uBC5XNjFRH5YwfpK02Gnw8eQFO/VceWb6i66gFSFN3bfpuZMr0NcvSlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LWPw7VPXLtYo8AOiJfBzWuP1aokbNfpxJg26OG93qeg=;
 b=PWuMp+QL3f1/r4iyStntRE6X9SJRvE47MVWCo1NJmYnD+IXg1+bAmLqBigWWdIGmCgbpbmAgcg0N4eucpXvYVwUTEx803LZ9XGiBsjWrlJVmiK2Jt8pp6IktVHkKyPnODCidZ3b+fw/sK+oZAiCaQNX/QyIFXh3RZHns3hU9nok=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CO1PR04MB8283.namprd04.prod.outlook.com (2603:10b6:303:152::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Mon, 9 Nov
 2026 17:52:06 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0592.012; Mon, 9 Nov 2026
 17:52:05 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Zorro Lang <zlang@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	linux-btrfs@vger.kernel.org,
	fstests@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 2/2] btrfs: test active zone reservation with metadata on conventional zones
Date: Mon,  9 Nov 2026 18:51:46 +0100
Message-ID: <20261109175146.1146100-2-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261109175146.1146100-1-johannes.thumshirn@wdc.com>
References: <20261109175146.1146100-1-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CO1PR04MB8283:EE_
X-MS-Office365-Filtering-Correlation-Id: adb15b89-ae25-439c-9b67-08df3e8a2973
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|23010399003|376014|366016|1800799024|19092799006|11063799006|56012099006|261021121427099003|261022113327099003|261022075727099003|261022105027099003|261009223027099003|261026121527099003|261026140227099003|261028144727099003|261102123227099003|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	RDLpKW15SALS3r77v6NaO5QtWkvPqDNBieS+nbhWbyGmwllRk7bHsW9R3DHb4Seycx/8pwVUp+0mBQ6wc3u8NSRjuY6Bdi7DfcrRZnmTVelN1UCcSrSEkplnRkI/tGtvaNKeT9rk2aC2ASUNBu8fRjNdOxGQA9bs4JX/vyYNjRJSigOkZumxern0JOMFphqX7LUqVBKgsksiqUrG2Uwe6O55Ff5MxhgukqBm1SnJZ7xAYiB0xFjQwp/WRltnx+rnBwK1OSwg/zKKWgj79Sc83suiUSLXouCKG6XFmVbZUc5cugGlkT4aSilD1SBNENcuPmA8AYFWtHeJzOPmcKeSVo3+sx4h0H+IJCbh/Df68bLjWutJZqMf+TvgBci4wuPAWNK4erqMnldJ4OcoyGh7ji/Co1RPXA2Zq8lPkNIY+ySs8CFXHW0RhUV3dMtLndOEo42cWeCQ4/E7JmjJ2dDLcnyRMmVvRfLzhCOZU4T8M5sBEbrsqGQfHPN2/acybKiy3hqAXRF/sruU6OQwLuAFTSqHEc/p+cfEzgO9dlojlgA4mrCpPiTPb/mbB6v6nf5LAHVcKdBtGpg9CMCzjOyYDDqG1lnwkSEjSsnYU+q882QivkYx4K6KoVAk4gVpg8KB9JfjBSffffEHs7fB+5b1NkHqIRPyP1WOpf4yT58R3Es=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(23010399003)(376014)(366016)(1800799024)(19092799006)(11063799006)(56012099006)(261021121427099003)(261022113327099003)(261022075727099003)(261022105027099003)(261009223027099003)(261026121527099003)(261026140227099003)(261028144727099003)(261102123227099003)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fXdnnM5yY7cwZ/55squlYsaYpZRWpKo9LtBvK4NrOG4xQAcPRMrHL2NlfYlL?=
 =?us-ascii?Q?cHBk6MPqGlzr+h48hB4wIPO0+pIsKLAw/2nVkVwDzmsXbs9FRrVQ9/SWpIiB?=
 =?us-ascii?Q?EO/6OrLVZEvwnXEt0UfSgOtRdyW9PIMi2p8SN/Or73m9ZiAYI7Ew4fLMeB78?=
 =?us-ascii?Q?mtVbtvG1We7tV9OVB1dGbYe471vdkSflwNvN/ScvjsUH9Ku7ppN4wyG1yM6N?=
 =?us-ascii?Q?7uy/e7FSX3seSwSbjDdCSmfteu2YxS+tIs/0RgnQtVK/Hwx74ffhpksv0Xzo?=
 =?us-ascii?Q?D3sWltFxWTCmo8fWe5LY1JWJ7XruUIh/D/QGMONcU6QA+7c3c0RrCww2Rzl9?=
 =?us-ascii?Q?Oggrgv/NELKUoxdcFQsjLczfAzIwuyGeRGxDrOxdaI0lxu4aBbPCecNnBVdV?=
 =?us-ascii?Q?FBv2yETtN6BJsv2i1wUrGhMZA0YuISFd4rLrrSVkEeDuqTkFmNuiM5qSn7QI?=
 =?us-ascii?Q?iHRrXvr+cVlkirNC2DVCCLs7yI6rIkFAHdsrSfBbyaZpYFroFe6X5EL2o3o/?=
 =?us-ascii?Q?Xev1iCqdE6M3MNNsHPy7co9eN3pjzrWONgkhcOLe81BPB8ljxzmbtB6MLvhx?=
 =?us-ascii?Q?ORWfMKTVOwNSn8jm0XWjytWtvLJ4xvm5AziC5KUEctJQE7Mi5B13IoE6b0a9?=
 =?us-ascii?Q?wmnSCGvHAXMvgnigXvFGdcWYDXazyAxtYDXbPM3xFG+TBo2ClkPFRwntNIZ6?=
 =?us-ascii?Q?97fwFav5zrmqFq6ZepbnwIZZOjmEuO4DUDHSrzeLdoHeJnDSTd2EXfi4QO48?=
 =?us-ascii?Q?YnKgvW54tXGifdIn48TSU26j8ZJQUM+ObT2i0mutuV4AX/UcCiZVbYnWOLMl?=
 =?us-ascii?Q?NvIS9HossnnRXomRPTt958HGk6xBJI+sJC1QjZ8LkYmOdKzO3ROpwahV2Gnk?=
 =?us-ascii?Q?REv1akQOUZExiHWKJUrOj/ThrSh387/x1LW8Cg8RtoVU0wS9gunq5csPXB/2?=
 =?us-ascii?Q?OXB2HoJ/zaKdbowtmq/N0hceZn2/PMRYiVe//ayUgSiEsPZ9vgYJXODnk9ZE?=
 =?us-ascii?Q?3+KY1qvTp6KFBNVq40iGTSDE+b0JCUlh+0mnkqjx+0avL03dzFrs95ENLgg4?=
 =?us-ascii?Q?vd5a3zFlGwM0oaWB+//VbaxZhTBft2CYOsJM8NPOnZWzWo8v01Y8d5Bgoq8P?=
 =?us-ascii?Q?Ql92w2OVXgdD2U9XaS0uvvxCfgSI8TsADIdxpJ3gptvcqIrjePGhg4b1n0U6?=
 =?us-ascii?Q?IkPO0GYxLtGKqURVv0Qrm7bRCkp1sJvsvZfsqgNuyCC4z9YkT0LHd1oU+V58?=
 =?us-ascii?Q?ACdlP6fQMxf4864RKxm+VVLHykMpx7S+aAnM2Q+Da2FwdIXMeddnAnxOjzE9?=
 =?us-ascii?Q?Jm2IPcWbJk2nxlv4HtQlol60m8W2mnRT8a9y6u8lrJy3t5PffVxyznm7MLjU?=
 =?us-ascii?Q?AhCbbOwUy943hXFG96BsyZRtY+mk0q/yF+fe/pXkTix6z+/GsIVQXzEVtBy2?=
 =?us-ascii?Q?fJQcN1Ke55A9YWLmk4LMx0A8Clh1E/uH5xpmWjzO3V87VwHk97n+VUgN9Lil?=
 =?us-ascii?Q?cq/30X4jlXrNoihyOWgk1LWNbwqAIQ7cnSAhZELwAU303+f76nWQvbokvteR?=
 =?us-ascii?Q?4njyUU9lu5dvLdXUIOo6s4k5LOE0fLnp+o3g2tWGO7iqtynlAFuJjODpnlJm?=
 =?us-ascii?Q?R40/bF7nrHab0ElkvrUxKeU74GPxxzIE6NaUtBvMI5e0GidhwU+Gn5cbRNza?=
 =?us-ascii?Q?1N9yCRbZODDAddOAIvjBM+DIdAWbRZcByL+ueUzN7gyqPfC6weCEkQKyQ3SE?=
 =?us-ascii?Q?zPSo6phWWeYhrX3GU0ia++orYC9RN38KsvAiLCiBgeCdIx/X/osNZ9wEOsqh?=
X-MS-Exchange-AntiSpam-MessageData-1: hr5hBPr88Bwu9sfL8GO08EtrC+7/Mnyzqcc=
X-Exchange-RoutingPolicyChecked:
	x4Z0m+BU104axavUBYauopNhbOvwDowi0paq7srmcqBms7kb+/KVDQajyqjKwr4XUA4aG0pyzw4m0NvyCCbwG2BDVZPm98f5vzGkOLY6B5PV70FP3C256Pdt1flD83H3fBPVV9LxAzF1SMm4eO0lbHIwuZocjCHX+Tw7paioeLJjLukLGDs6uuvFZ4PX1xuWT8uD9T1yfft/6NyTu4xRm5UaouQUMRLGMJra0Kx12uJsUkcyPUNCBaqU7fh0+QnftPiug4ys5fyNzfy2CixqyoDckzMfQI3z+XG2w3xdBS88SNovLy8ixIvMxe8MxDcM5trxK2vz/8gceGXfuQdD7A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	663+ZxrwBOudOubt3srGERhYdo59wtwMXfaYY3L1DsgDfFzZ+ag6f0wXj6WLeLNGPz++C6M6MQ7H7JFIW7OWNGrTXuo9GOSbIce4DkfVBr1z+k4nPWTLJtgPurJNtjEPhWVsMn0KuPToBspzt56jbpI4bxTfw+wR9lJat3KaH0Z1zGrDjFsLDmY0wnGxRpiJkfmcva8N0MqTnzu4d+suDEq/NyJYy8M8isiQUq94Tbv1mgZrqur9TwSdjYT2dIcJScKJzSvrgBtIu2RqsYju8f4xHFYFv6YCR9GfW/+lG3F2CMx6bkTSqe2vNccpGiyMVylJU1BWMqWT3ezOL48YZ9XGHrOSutpyytcSN69XdVDZMFOc1MiwvfsNR6gdR2qcuTCQYJtgdpKHaR5ATCiZypBlVetlzvys6/U76BbQ4tAdDlhzSHRmmo9i+S7uitlpG9JEeAfkQexVZCdkO4XVQDgiFZNs95oQom+a09w2a8AHOPFYelREYc4zCbPiOcHT6eOtL37VmF8I8b5mF20o13XZmwv4lNdK6r5w1Q2vJUi3t+9uWaDXA/SdMv8xX3aJ4qTSzA6jn04fkreHG2qrHI2GrsrACRYiP08YXlanG9GI60u94C4lNxCV/2CQiNQJ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adb15b89-ae25-439c-9b67-08df3e8a2973
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 17:52:03.2777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HpyEpwZbppVtY/aRM43owSzqOrhea9HoispHz91WxilP4Yk0YISPfTyM7BSTan8mFBXS9/3YUdGzgElUaQB3KbypwIBm4VnurCWGvkMy3YU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR04MB8283

On a zoned filesystem, metadata and system block-groups on conventional
zones used up the active zone reservation for metadata at mount time.
Once data and the tree-log took all active zones, activating a
sequential metadata block-group failed and the transaction commit
aborted with -EAGAIN.

Create a zloop device with conventional zones, take all active zones
with data and the tree-log, and churn metadata until it moves to a
sequential block-group.

Assisted-by: LLM
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 tests/btrfs/362     | 120 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/362.out |   2 +
 2 files changed, 122 insertions(+)
 create mode 100755 tests/btrfs/362
 create mode 100644 tests/btrfs/362.out

diff --git a/tests/btrfs/362 b/tests/btrfs/362
new file mode 100755
index 00000000..d1ec3843
--- /dev/null
+++ b/tests/btrfs/362
@@ -0,0 +1,120 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Western Digital Corporation.  All Rights Reserved.
+#
+# FS QA Test 362
+#
+# Test that metadata and system block-groups on conventional zones don't
+# consume the active zone reservation for metadata on a zoned filesystem.
+#
+. ./common/preamble
+_begin_fstest auto zone
+
+_cleanup()
+{
+	cd /
+	[ -n "$mnt" ] && _unmount $mnt 2>/dev/null
+	_destroy_zloop $zloop
+	rm -r -f $tmp.*
+}
+
+. ./common/zoned
+
+_fixed_by_kernel_commit XXXXXXXXXXXX \
+	"btrfs: zoned: don't release active zone reservations for conventional zones"
+
+_require_scratch_size $((8 * 1024 * 1024)) # kB
+_require_block_device $SCRATCH_DEV
+_require_zloop
+_require_command "$BLKZONE_PROG" blkzone
+_require_btrfs_command inspect-internal dump-tree
+_require_btrfs_command filesystem sync
+
+zone_mb=64
+nr_conv=4
+zone_bytes=$((zone_mb << 20))
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+
+mnt=$SCRATCH_MNT/mnt
+mkdir -p $mnt
+zloop=$(_create_zloop $SCRATCH_MNT/zloop $zone_mb $nr_conv 4096 \
+	"max_open_zones=12")
+
+$MKFS_BTRFS_PROG -f -d single -m single $zloop >> $seqres.full 2>&1 || \
+	_notrun "cannot mkfs zoned btrfs on $zloop"
+_mount $zloop $mnt
+
+# Print "logical physical" of all metadata chunks.
+meta_chunks()
+{
+	$BTRFS_UTIL_PROG inspect-internal dump-tree -t CHUNK $zloop | \
+		$AWK_PROG '/CHUNK_ITEM/ { logical = $6; sub(/\)/, "", logical) }
+			/type METADATA/ { meta = 1 }
+			/stripe 0 / { if (meta) print logical, $6; meta = 0 }'
+}
+
+# The metadata block-group created by mkfs must be on a conventional zone.
+meta_chunks > $tmp.meta
+cat $tmp.meta >> $seqres.full
+while read logical phys; do
+	[ $phys -lt $((nr_conv * zone_bytes)) ] || \
+		_notrun "metadata not on a conventional zone"
+done < $tmp.meta
+
+# Activate the tree-log block-group.
+$XFS_IO_PROG -f -c "pwrite -q 0 1k" -c fsync $mnt/log >> $seqres.full
+
+# Take as many active zones for data as possible. Leaving 4k free keeps the
+# data block-groups active, as the next 1m allocation doesn't fit in there.
+for i in $(seq 16); do
+	$XFS_IO_PROG -f -d -c "pwrite -q -b 1m 0 $((zone_bytes - 4096))" \
+		$mnt/fill$i >> $seqres.full 2>&1 || break
+	$BTRFS_UTIL_PROG filesystem sync $mnt
+done
+$BLKZONE_PROG report $zloop | grep -E 'oi|oe|cl' >> $seqres.full
+meta_chunks > $tmp.meta
+
+# Has metadata been written to a block-group allocated after the fill?
+new_meta_written()
+{
+	local logical phys
+
+	meta_chunks | while read logical phys; do
+		grep -q "^$logical " $tmp.meta && continue
+		$BLKZONE_PROG report -o $((phys >> 9)) -c 1 $zloop | \
+			grep -q 'wptr 0x000000 ' || echo $logical
+	done | grep -q .
+}
+
+# Churn metadata with inline files until it moves to a new block-group.
+moved=0
+for r in $(seq 100); do
+	mkdir -p $mnt/d$r
+	for i in $(seq 2000); do
+		echo -n "$r-$i" > $mnt/d$r/$i || break 2
+	done
+	rm -rf $mnt/d$((r - 1))
+	$BTRFS_UTIL_PROG filesystem sync $mnt || break
+	if [ $moved -gt 0 ]; then
+		moved=$((moved + 1))
+		[ $moved -gt 3 ] && break
+	elif new_meta_written; then
+		echo "metadata moved to a new block-group in round $r" >> $seqres.full
+		moved=1
+	fi
+done
+meta_chunks >> $seqres.full
+[ $moved -gt 0 ] || echo "metadata did not move to a new block-group"
+
+# The filesystem must still be writable.
+$XFS_IO_PROG -f -c "pwrite -q 0 1k" -c fsync $mnt/last
+
+_unmount $mnt
+_check_btrfs_filesystem $zloop
+
+echo "Silence is golden"
+
+# success, all done
+_exit 0
diff --git a/tests/btrfs/362.out b/tests/btrfs/362.out
new file mode 100644
index 00000000..0ff40905
--- /dev/null
+++ b/tests/btrfs/362.out
@@ -0,0 +1,2 @@
+QA output created by 362
+Silence is golden
-- 
2.56.0

