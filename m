Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794941953;
	b=RGWuaI2gJFD/13aBTcMy22+zuZf5BcC3aAC29/D7NMAS9zPN+34eXhboXE//FBFx2Z5V
	 XXq5R97K51aiOmo5w9fUr/QJVJoeRckhrKIcpPQ75n0afcizNWTG1/lDYm4zZKNNSO2k9
	 HSj4U8vEzHa1TrVZ/DJTxFGupySkLVtz3ndKqtyNNCUVsJZBOionVKWUGP9tEujxIwU1W
	 02O7LOklNnT2gkqkWYMg80oPaknH/rm8La40wYnU9zIFgbgyZs5YfHkB9GalQfxCjXRPl
	 MO71Xu4+xoHEY+h8B03If+/LIOSdFOk9Gw2vzEg3SwnL9ChEV4YybOGMcPOsz+IIxBQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794941953;
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
	bh=Won+KcDZdh8tKeGK/ls/j6rlvVFFH75I61v6DXdEOKo=;
	b=oVBeJNZnLTiv7Mc0Qv3CWi78gtUpBmdb2JXImdjjR6gJzHPKhq//WM+9M+JKrhi/BniZ
	 /hiXd2nl32TEPJ2uH0DlV4R4q17XbYy4q/KC2DVmI5gUYp6Q6XoCuEhTgM58ttdOUa9UZ
	 yjSzYw/ddcB72lSS3DpvKMO1mSXNtowvcCOSrjlYRUHR39P7oeFalwouh8OGbVb6RuiIy
	 Vbz5h3ne7GGxJTbVdHbMhKLpKs6iANvTJnJZJ07zpjVeFwCRUtcJEcDxTC25ejQjHQLtQ
	 rRCTwtdy68/yXqWgZXPrIWTVzPU1FZzt5RntNC5oxd6M4vHqQRvPpbC/7Vw0iWhxRSQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=a7lBijJy;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=yKKA4TM0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298EE606A330
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 18:59:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 298EE606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=a7lBijJy;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=yKKA4TM0
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794941952; x=1826477952;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=48BurYBc2AxrRIxPxPqVItP4r5ghSUM+k+aDKxKMpn8=;
  b=a7lBijJy57VU4WbQvIVtkKU8wNPKj+bgw4Ln9bMj9lsHGvHKqEQShxKJ
   sY8l7GW4c78S7n/3DUSIstuvtlFDWn5AC302qJs/CAObGeE+1u64e4asa
   47ACDfaeojsoo1sf+XdWANRHZmNIgSO7IlpHgNpRJFeqVVOKU+ruqsvj+
   VlRa6Wlq+NJf9mp9WfAT2bKnAMTekiJ/dTowGdmZ5YWQYn83TSqE0FQrV
   amFhl15CpzxS1FrrYoHysm46YIzYNPnXXXBCY09LdVUzHMeKxUxyBIGND
   ZdO1LhKJpnbJePs/gRb0FIaQXUXRrLf9EL1V2YiL09vhBmN+FoB2e9OlA
   w==;
X-CSE-ConnectionGUID: 4kZGX3D1RvermbYPccIfpQ==
X-CSE-MsgGUID: CvbDUom+QOKIHN23ZqSj+A==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="159505123"
Received: from mail-northcentralusazon11010007.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.7])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 02:59:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HZ5MiahQK4ugkTB5O+X0a9xp4D2NOPjTR6jO9icSoJLtzNUC14owEQYYMeWQadsd22NyEkrc11FW/6GRSuW590D8GJvP/muG/+AhhY1bv/kZ2+IYOX0bTIeIIxW9jfNKxQ0nC8720avrVT4tz5kVnodcH1sPYRQwslxWKCJT4JSwyFmB845Pj/2YPVIWcVbsI2dDzajRNeRUxYxqxU3yVD9XnZax4mHBqNb+mYx6e3WB9qmELUZ4J+7l03dNP1LWMP2meJYqYlE2EaI1e1X/OGKAbfzlYsEbMxhJJfRbMJ8sRuHC5RRaAnKtBybklZhJUd+CrjuQI2BJa69Cl6lBFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Won+KcDZdh8tKeGK/ls/j6rlvVFFH75I61v6DXdEOKo=;
 b=q93nuvHJlIKOfkA+oOWW9Q9KknNfV5wg2Gj01jhLAB2fqGaU/wU/Hbwueo0dfEQPxLu61Z44i8s6g31vDVYEl54uAkbV9f0QfADuxarSgNLrCuUHJ3nEtRHSVUVvrtbqf8XfKXw1wwhW5fWvfvbcNFTYaH6QRmxgdexDHzhWYEc6CnMHfCcvO3jUYXbE/t6epcgFFB6dfneI0NxmcqH74ayHmbltP3rjSpHdxF6B0EKogWre1gVT4fmqAzqsNMAXxevy6uvCVpgtPCma+w6hcwz+Jn5DaCraRfr9tKq+BmTMPn2K0K1yMG0DS5o0NJWNunNs/RAzzAPRTGfLXls21g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Won+KcDZdh8tKeGK/ls/j6rlvVFFH75I61v6DXdEOKo=;
 b=yKKA4TM0b5T+jk7PoVMYRImw6G6K7LjY6G2Vb24q5a00GHkSZQ69F/nCgnZvdG2b4zum7fV7V+g9i8+HnWsIEJJ7CmRKpcN4agREwNmljuOIw5n07bf2uqapOXiwDSqZXxe297WGgks7g3RE3yLRTxpkeS5Rd8rRKAHq42J1V1M=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH6PR04MB993818.namprd04.prod.outlook.com (2603:10b6:610:382::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 18:59:09 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 18:59:09 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v7 00/27] btrfs: zoned: fixes for generic/747
Date: Tue, 17 Nov 2026 19:58:23 +0100
Message-ID: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH6PR04MB993818:EE_
X-MS-Office365-Filtering-Correlation-Id: 9747588a-6d5f-402a-56f5-08df44dcdc63
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|376014|19092799006|23010399003|366016|18002099003|6133799003|261009223027099003|11063799006|56012099006|261102123227099003|261028144727099003|261026121527099003|261026140227099003|261021121427099003|261022105027099003|261022075727099003|261021123027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	g7/o9HDH+n3UaGlxV42X45KhL6HtJNK00+jAwm1YAbVyYyRMjcQgUqfo61FSEJ+mJ2PE5DnuA/GAN0GZTf1Ms/S/qOE+gUed7vLqXT1GkLpdNOUaoWCJD75MT5KxQAumG2koXVciOpgxmp1E5nZgV8op1tYlkfB4EfUrQlGwFpziWeYasVIKkPGUk0AFL+A+Zisoq2aEGc8OqyuzF8uFDxR8vrOYaSyqQkIpZ5PJ7W6X9gFzimPckomusaYf9mcytjNwRIXJqXxp5HRiLRkrhrY1GOrMQjxDo166ccsSV5TKBwx8aLoKujglp6VpLrqYfuAycj9/OnISQApuWkVvtKqKa67ZdAFg/2vLeHKdLw1PPTXdZ1+8CwATDGqd6WaT7DoaXsZtRdzzSWxU8U20BunetXpLR1tC6dvtoKZPHt/CBq9gR5YFBPX0AkOtm5MZapONj7yRQrIABUbyM9EiBw+3c+EPSAmlaSjP7YpiKvP/jI9KA7TvcB1mj1CNzqlipISL8jJYpFIULXpCcYRv2uNPlzyXGYkLY570/tDKrgVDnVuBYr9Nj2SBl43cWMHstEoBAdeP2dAiSgPLm11bJz6a1i1Adb01YRARwkkWUfXjJZgQ31OqYhFP6r+gt+csBPzpjgDqxu5a5k8LGQcDGoEr8FpkZLAApWpJEhAoTpY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(19092799006)(23010399003)(366016)(18002099003)(6133799003)(261009223027099003)(11063799006)(56012099006)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021121427099003)(261022105027099003)(261022075727099003)(261021123027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8q4pkf+B8e65ZKgtm7wMURqkLWJpbemL0EQvDTMueyU9qVNWziY6zIFL2Z2Z?=
 =?us-ascii?Q?VxxVtYdfAIv1MTUgrLKSl4+t5c8f12ve5a+ejVtbf4LAOYBzCqeFSaGc9PKV?=
 =?us-ascii?Q?wnL/rg/cvGQo3stnwC3FmBXIRa5S8JedgSPJoSqbqG5M2v+cohC8OScZkKcW?=
 =?us-ascii?Q?WeAfP0eg4MTj0XK8kARpmX31kKrY1jQBpiNTAp1Qwo1AW+e7PjHCONwtMev/?=
 =?us-ascii?Q?HMCmVi9fRAObpouafo7kKyH9Fo2DITy3CBYsc/eZKNxPHB5sU4DlArcvZaPk?=
 =?us-ascii?Q?jfm/ndz9IIbwrjHux6TBuUpFOUbfnJ8niw9x8q150rm2/fIEzbJbiLQnXoE+?=
 =?us-ascii?Q?rJGANyudrE9Qi+ADONcl1u1gXvnFejIM7YG/v2XDvsmpELPBv2TkqqlAkuBK?=
 =?us-ascii?Q?MR53Mu13ChAz0p4voIkopQpz0uKX1NOh+ojHzkIIbOrfDvl47zfdGm6hgThC?=
 =?us-ascii?Q?gdTNyuDJK29eXpGVZGwqwSJbrK2TXVUn/u1HMRxBtSQKyTXzW2xfLAJYkwcU?=
 =?us-ascii?Q?93cDRjO1l5NujVtVJ5GVXN1SCzttosFh4XWBeJ5Atld706eYq1ugr3AHADxP?=
 =?us-ascii?Q?VawBDfGdsKJaJfyIgGi5jdwqZkuxtM1AhNW1gZReLZP+p67zTBGzyQkfCZLJ?=
 =?us-ascii?Q?/ovipq7JGHB6mBtJqscGIb2OvIuptHB0np9n53/AaSxeFWEy/xyFf+TeqCp/?=
 =?us-ascii?Q?Eu6lkr/jxuuU9derqFQ8bCCp7cJaMvsBgoAj+wJrDZyz1zT0HeGY/erA7byj?=
 =?us-ascii?Q?Apx8Ld8vnm0vvr9X8ulHCJt3mnx54NK9ctbacJvulvYo9HBJm6gjusJBerSg?=
 =?us-ascii?Q?0jLgEy6gIDwTk87RKCyCllp/y5JddQ/MdenMYrHrwVqYFtseGBrD0JKF36hV?=
 =?us-ascii?Q?EQnxczged7FGu+ilLE3GmJ8IEqck6Xpb2lLuGTmGFgUSwEOeOiyIRFUmRTd7?=
 =?us-ascii?Q?M8bGV0Sm5w8FN5Y4oMkMnUZllNwMFIS/pmP7BJ/pFP4isahwzwbSy9oX15u+?=
 =?us-ascii?Q?OHAXOQ8BuadZlVOaUs8XQCkL1qCQpEWJkq3b1k4G36o1OUkGqAJ5IdSrePYU?=
 =?us-ascii?Q?VM63ixKWx78nvgSaQhSBX/zT/TOVYg6H3SVbBA48dpjuRhBWDQEFiesKhmkz?=
 =?us-ascii?Q?YkHNGBRv8a8DhzGqchCHMUTkjOWQz2vNwzt9kkgQ7CicVA17DrlCvLjDWTv1?=
 =?us-ascii?Q?mM0h1VUUva8+SJn5hTNI4L0QS0x5TB3KGL1Wp/uqGlMPtzuFK39itJydzTb8?=
 =?us-ascii?Q?Y2SbhsNzPj4FpaK1MPeq00LZGD9h8ZQAyw4sr8GJgrW2FifVJx4BkNyGRaS6?=
 =?us-ascii?Q?ShjzkB4fWk4SJCqHV9N5TY/OtK4OpsDPNN9BQOeoUyEc7YKakpmw4856J0Wn?=
 =?us-ascii?Q?dvgdlt1wuNUz/ihsjgkRfshVLujiz8YsBr0YXnCxTAaMmSZTAlO2vAc82mis?=
 =?us-ascii?Q?04pAGxOLD8OQLdsR4pgMVthixu9jmbewh0lClE5V1HEZBoCATC2WUTDCTFgg?=
 =?us-ascii?Q?Bjp5CUgPKBHo8tRvbGQ+EAR/WBJz7INqeaPoGI2Zi9fDUHmEz9EMJ8yjkt+F?=
 =?us-ascii?Q?2JCMSk1DYMYbY4ViN6piR8jK0qIGp0t6Xk9PyqdJrdG37WdhrBkJgjYoyWfa?=
 =?us-ascii?Q?8FBFmlP/FBMFxifBv63qiE11HZtXoUisLCBO0B9bxip+oKNdVVOGSzoifRR4?=
 =?us-ascii?Q?GrNU2x+E+MZDNQdS9ah0mwvQdXbpnn5nrSPH0NWlVek38Y/FZZ0UiuGW2OUx?=
 =?us-ascii?Q?9YvtihjdfKKYGRZ7QM05nWgr+h2Md02yfQYN4xkN1+AvcdlJMr4a3o4Kcifg?=
X-MS-Exchange-AntiSpam-MessageData-1: pHy5XX6jS1JSers4Q687bmcOkaXGdRGjyUM=
X-Exchange-RoutingPolicyChecked:
	pGDRV//s8mR2TEy2fxnB/SNH1o3od3JByO0XdsuCBa+QTfgPso+bUaCzevTsc2jOEvZmPMD6Qv5ZxV0SjIw5pYpjfbUa28aKyvLi4ItDXr60H6tWHBJkPzTSZBaQkFYDeZzwXa8iv1dAWjWcTKaHz86eyF1L4IAYfdmnwzDawHWxKbXKad5m47FgapqO7EeZCz7y6LPqK7peEnIcqD7naZXutmw1A3JhM0v9pS2iguX96tQmk+XdrsM+288Yu098hF6CvWUjJM5XZ+tcFZ9PjAQRNj7QOdFQWF5luiwhQYxRTsgN/8l4Iyo73qJz1O6R6+od4SNEShIg8rStggm1FA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	W4zAESSpNDatVOuz+PCLY+go+wOdCDtmirs/hodqXNqJhhidaTDed2bjyXZafWcjinCWRCB6mRtOM5NrkVlNsPQOe4W/XV3CO+ok9KiQxOqwSEycd5E1rRyi43xCTZvMQoAHi8wrt9RoaZFBccli/66YesgOjfDS+gLsnnsBGwQqy+/poBzBBxvu7fi+o9B1BFkRQLj1bmKRnx3X+gIJKNk/XGxGJ+3lRTrJJL9dZC1Sqlu+/10yZQt29X6lcoztHLyewPYiCkE5sKno7NLHO6zaBU1nOtCXfT+xbBxkBs+87sLdpiwdkK0azZ1mcj5PmaLZoG31942EdsI7f6oxRKVcM65jfBZiByggqi1JiewgVSBUwVw7iDGmQkEn28wWFpvljIEsc3NJ6staei1nAh8VNMq1CYezYrcd/+5IvC2Vd6ZDZntRZekFFToTfI+JNRocuJkkindi1R7c3gFUDEHcaMqv9Waz7N+x0b5up8nnePUhcP5FOhXsFaBl5RaXO3lMwb2rjPCO9YrxE24gtKoie7km+kSOW1GYw6sQs+BTK3Y9wuLOKUD+rP8yW0y9POgz1DXsfBaIPwI4PreZA3QHeMgzHHwKeZpVb62pUn+ucKLWnrBuI13zX1MdXAgs
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9747588a-6d5f-402a-56f5-08df44dcdc63
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 18:59:09.3578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zttAsjadpv6hnv0pju3ibQI/y67VonfOZyH+PihtuYsUMjFDJuNwvlWa2vNXcySMnic8RXcF+PYvH3NwCluaol/qEZAUAoES6N6iDUmGWrw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH6PR04MB993818

At the moment, zoned btrfs doesn't distinguish between DATA and
METADATA/SYSTEM block-groups, when allocating a new chunk. Therefore
METADATA and SYSTEM block-groups can end up on sequential write only
zones of a drive. This adds a lot of complexity, as we can only append
to these zones (and not perform random writes) and for METADATA we need
to write with a queue-depth of 1 using the btrfs_zoned_meta_io_lock().

Also the write stream for METADATA is not allowed to have any "holes" in
it and must be aligned to the write pointer, which was a source of hard
to fix bugs in the past.

This series introduces a split in the block-group allocation path on
zoned filesystems. For METADATA and SYSTEM block-groups try to place
them on conventional zones if the device has them and enough are free.
Then change the allocation in these block-groups from the zoned
allocator to the unclustered allocator, which is less complex than
setting up a cluster for them only. The reverse is done for DATA
block-groups, which can be trivially written on sequential write
required block-groups as we use REQ_OP_ZONE_APPEND for writing DATA with
a high queue-depth.

In addition to this, this series reworks how garbage collection works in
zoned btrfs by tackling the remaining accounting problems and relocation
still being triggered not timely enough to evacuate the space the user
write needs.

The first two patches are fixes that are independent of the rest. The
first one stops allocations from waiting forever for a zone finish after
a transaction abort or shutdown, which hangs generic/388 and is much
easier to hit once metadata lives on conventional zones. As whether a
block-group is append only is derived from the zone types of its stripes,
dev-replace must not change them, so the second one rejects a replace
onto a device with a different conventional/sequential layout.

Changes to v6:
- Rebase onto current btrfs/for-next
- New patch: don't wait for zone finish after fs error
- New patch: reject dev-replace on zone type mismatch
- Rename "don't activate conventional zones of mixed block groups"
- Drop its reservation hunk, already upstream
- Clarify its active state invariants in the changelog
- Keep upstream zone finish in btrfs_relocate_chunk_finish()
- Explain lockless check in "never activate conventional metadata block groups"
- ASSERT zoned and data space-info in btrfs_zoned_calc_inflight()
- Add Boris' Reviewed-by tags
- Mention why the unclustered allocator is used

Changes to v5:
- Don't overwrite ffe_ctl->policy, pick the allocator per block-group
- Retry without empty_size in LOOP_NO_EMPTY_SIZE on zoned as well, so non
  append only block-groups don't hit a premature ENOSPC
- Perform space_info migration only on ro block-groups
- Only set data_reloc_bg under relocation_bg_lock if it isn't set yet and
  undo the space_info migration otherwise
- Skip a block-group in do_allocation_zoned() instead of ASSERT()ing when
  data_reloc_bg points to a different block-group, and only clear
  data_reloc_bg if it points to the current block-group
- Don't account bytes_super twice when moving a block-group between
  space_infos
- Return the free space of a reset block-group to its current space_info
  if promoting it to the relocation target fails
- Reword commit messages of "use the regular allocator for conventional
  metadata block groups" and "return finished relocation block groups to
  the data space_info"

Changes to v4:
- Fixup broken rebase

Changes to v3:
- Fix the active-zone reservation race
- defer RAID activity publication until all stripe write pointers and
  capacities have been validated.

Johannes Thumshirn (27):
  btrfs: zoned: don't wait for a zone finish after a filesystem error
  btrfs: zoned: reject dev-replace onto a target with different zone
    types
  btrfs: zoned: fix possible race for reserved_active_zones
  btrfs: zoned: don't use active zones for conventional stripes
  btrfs: zoned: skip the append only metadata writeback path for
    conventional block groups
  btrfs: zoned: never activate conventional metadata block groups
  btrfs: zoned: use the regular allocator for conventional metadata
    block groups
  btrfs: zoned: only take the metadata IO lock for append only block
    groups
  btrfs: zoned: allow restricting the dev extent search to a zone type
  btrfs: zoned: prefer conventional zones for metadata chunks
  btrfs: zoned: use plain mutex lock in check_bg_is_active
  btrfs: zoned: use plain mutex lock in
    btrfs_zoned_release_dirty_metadata
  btrfs: zoned: remove btrfs_zoned_meta_io_(un)lock
  btrfs: zoned: prefer sequential zones for data chunks
  btrfs: zoned: wait for a running block group reclaim in RECLAIM_ZONES
  btrfs: zoned: don't count in-flight data as available in statfs
  btrfs: zoned: don't recheck the reclaim threshold of full zoned
    block-groups
  btrfs: zoned: don't account superblock zones as available data space
  btrfs: zoned: factor out resetting a block group in place
  btrfs: zoned: prepare reserving the data relocation block group at
    runtime
  btrfs: zoned: promote reset data block groups to the relocation target
  btrfs: zoned: return finished relocation block groups to the data
    space_info
  btrfs: zoned: reuse block groups emptied by reclaim as relocation
    target
  btrfs: add btrfs_bg_type_to_num_stripes
  btrfs: zoned: keep a zone free for relocation when allocating data
    chunks
  btrfs: zoned: don't count the relocation zone reserve as available in
    statfs
  btrfs: zoned: provide zoned specific reclaim sweep

 fs/btrfs/block-group.c       |  56 ++-
 fs/btrfs/block-group.h       |   2 +
 fs/btrfs/dev-replace.c       |   9 +
 fs/btrfs/direct-io.c         |   4 +-
 fs/btrfs/extent-tree.c       |  50 +-
 fs/btrfs/extent_io.c         |  84 ++--
 fs/btrfs/extent_io.h         |   2 +
 fs/btrfs/free-space-cache.c  |  23 +-
 fs/btrfs/fs.h                |   3 +
 fs/btrfs/inode.c             |   3 +
 fs/btrfs/messages.c          |   1 +
 fs/btrfs/space-info.c        |   3 +-
 fs/btrfs/super.c             |  33 +-
 fs/btrfs/tests/zoned-tests.c |  16 +
 fs/btrfs/volumes.c           | 107 ++++-
 fs/btrfs/volumes.h           |   1 +
 fs/btrfs/zoned.c             | 893 ++++++++++++++++++++++++++++-------
 fs/btrfs/zoned.h             | 118 ++++-
 18 files changed, 1136 insertions(+), 272 deletions(-)

-- 
2.56.1

