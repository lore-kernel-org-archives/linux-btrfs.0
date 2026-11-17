Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794896358;
	b=A5huI6L+UaiG4Qb1olXrO+Fg9K1Xo3Dm1i0oikRn6pX0dW9rTdO8oRk0xwxtkCqU0SzM
	 vT9HA/ClZALb/mkJSr3ve7FsqooP2j2s3xk0Ce8qdRrghUe7xR32PkQGAmK9NtD7P1QCG
	 X6RnSPses79IStPus8/7+mitezXK6e1iwBFaaDF394yjelIR8utlHHf1yw0Y9Ms24Qfsy
	 oqE2YOtP1GkE05zXLvIvcO+UQzFzZyeo7Mq4pjwST0slNIskIkf61Cs7ZP06oXkDiXX2x
	 RgPjPAm4HPcDmpa/NthLSbTcFvgieVFqMK5w83wKGr0Y0ckZOkuTsSzd74VN4yK+T1g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794896358;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-LD-Processed:WDCIPOUTBOUND:X-MS-Exchange-SenderADCheck:
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
	bh=tzNI3QN2zDMTwrkRnNZdjyMdLrGhGV7I58PqqYHgMAQ=;
	b=ghJ+dwRF9xNm7bhhoJaVeKHiD3e9W8cQgLYP9pf7TqScXh8s9JacfoQk+7UAfBqoRjh1
	 sCLBrmhDDKPdqShZ547sMyWKUuUSUEqKHaEUAGH/CvAwitxOuNBUf+5f6h2RW2MLltr0k
	 y+RHTr7Zd/v+Frb1nRFV9HLtaChhS2Q5NHk26874YJJQ7eRq2LRiZgVHZOjbkIKmQjps+
	 6jEase3hWxHjfKqtlMheANebewE4JZs04el5pLbH6XwvTwebazzswqBqRo8c33umq+Jmn
	 iGCgVB5JSQ1kEQDjQXy/s0f2nXeFMYG4cBdKQ1kl0qFmXAJCuhP2WtIc7hBQXVJd0DQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=f4vaciXf;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=OEO+vgnb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E5E606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 06:19:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84E5E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=f4vaciXf;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=OEO+vgnb
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794896365; x=1826432365;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=tzNI3QN2zDMTwrkRnNZdjyMdLrGhGV7I58PqqYHgMAQ=;
  b=f4vaciXfS4k0UzeyZhVPT6MfQPQLqU9V1FqKssQ3hTacaFY7D4oiGIjE
   KMoSUti4xh/OYciUCgvBOO6T45UuGjU/UmiBxcnTnNnpaDOTbYFS5BJ91
   h2tduYK/qIe9CFWLWQPvKVIMUeBXgE2xZfBYbCwYoo3CSOoiQ2su1L179
   Nj/2tM/ABP60B+jpH+/Ke9z3L+MOmxhTKfmC8cklI5M22Tnx4LgfQsibN
   Z7b2YBEt8qRh4qiK0Ejd/RGzaHcOnjlpeU4XIHlSM08fw8wjXx66WLaH5
   8Wl3b//EdOMQFWrGMOZReuKrmjxuVoeuCcupGAdHxmxYpvHUIQJqFNDTP
   w==;
X-CSE-ConnectionGUID: rnRoAUw1REura+hapM6D/Q==
X-CSE-MsgGUID: Gce0fke9Tra4DRrK9tzGoA==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="162045178"
Received: from mail-northcentralusazon11013023.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.23])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Nov 2026 14:19:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m1+ih2EWe5nniJ2q+ZU7Khm2mIuZ1RlkAOtTrVmvDlWinK02W6v56tU+up/z6KqIJ2kLBQP360WYOOJcYXjOWejt50MIl1NAuOMAugpvUGxQamrQ/Jwcuw7bMSdLDMejZ8DGgrpCJWlXhU1fvfkyV70Ll4i5408hZPBRrz7kuoeul/lnZ3drvgSyDrLAki0cvtlbSfh9uNVqKhV1LbE86ApIiw5NbsPgq+AxNS9XO69dVF06RfBqzG3KTalPYsHpLAhbXF+FwR7FiiDCKEKqrCdwIhFg9VC3l5WM2wJ+aq1i2gtVDYIlc4DAFt+9whw1fQH5WjSMCtveXY1q87oKWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tzNI3QN2zDMTwrkRnNZdjyMdLrGhGV7I58PqqYHgMAQ=;
 b=uqApPiE2HWe/FrDUYGMFtzFHXhlpqgPS5eDJLGJ3W7PLNGouwSjiijRo2xF1HwXdZGNvyZrgAC7YZ5qUjjHr3PBM0OjjXi2sy1R7c+gl+575fk3DccXD6kzCy1rmvnpBgkDOTxU42XFSUi/VJUazEGwXNIcOBR2Vkqx7JzZb5LxXY4AhXRoc+uMla0ahuIYNQxCIIa02X69jszdb1aOWFLfelEZbiksEO7VDgpeTlpHJYsKochEBXE475kd676WbRkLHgerS1wph/AlZBnFkRsWSEOWt+88L2+ze1KeqshihM/CVP371OlQw1WjZ/z7WbkIU7mPI30YRB/tRPrRgZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tzNI3QN2zDMTwrkRnNZdjyMdLrGhGV7I58PqqYHgMAQ=;
 b=OEO+vgnbNaOZBSnHOf3gwB/Yg6lMqzHvSOUa6UEzULSpMQAFArK0Oh0g6zEqEyey9hPSjrSJcwujSOuBqrpFSMx3JVDOLJpIxfMHTRxXR+xzoY/+arFbePcI7iXOalyscnVba3r6hoM8H6qoPO2wnjJDAt4DNnjUSaBTxKsSuIo=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS0PR04MB9844.namprd04.prod.outlook.com (2603:10b6:8:2f8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 06:19:14 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 06:19:14 +0000
Date: Tue, 17 Nov 2026 07:19:09 +0100
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] btrfs: props: validate property values loaded from disk
Message-ID: <avvxsrVakxTIcs9g@neo>
References: <27eb729ab79e98927812e0e1df9e699716df6036.1794522787.git.wqu@suse.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27eb729ab79e98927812e0e1df9e699716df6036.1794522787.git.wqu@suse.com>
X-ClientProxiedBy: FR4P281CA0430.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d1::20) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS0PR04MB9844:EE_
X-MS-Office365-Filtering-Correlation-Id: f0eaf780-eb4d-4860-6c05-08df4472b3ef
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|19092799006|10070799003|10067099003|11063799006|56012099006|261026121527099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 GMcWfCiCpLNjB3QHKDGmiyPAIYRJvgr1hRlKSKiK4kVtsJRhW5E7Cp3uOArUWRbZyJy/Jt/5C42HfzhMRiLP9J+16CebCwhXFMsgcJjX8KR9yAMj2qskcaVLxQSjoo72Sj/foQg1XqX9x1YQsjdVw9Hlj0ZaWCblKGukvGou7EGBSClncQqlOcawIiqfIcAx2ziJJAr/MBiZbBJHwYTg3FQp7Oy8PndN9Y7xgu2lyAUozKJF85vPRkXRhQ0ap28NQ74MBxtzwpo7tfkAub2ucP6/uxB37xyHiNjwZ58+1bUT2L0ifxIVY08ich/CeNP7sCmMhKdwoo9aI0jXlMUY5ij3BjKokPRKIJ8vYEhZ3Kb1cubudAh0T1kDOzBulLriiao61v8toRiQmC8lOfZ053t1bO96dPcDZ4d5Ztcqx/gcioywESD0BLlnMZBLCfzhqnhTZt/JWMm1ccQzQc/RwJsjHpTW1xPwYkarOmDSd50SwEdrP+xBiYEoI/Ls3pllV0Jq3p0C8vRR613sCKIqzU9ycb4uxuWa0+OMTTvaRfghpSsrUT8k7Idyo2a2r0d1y75IEO5wkjDfuD5sTo999JQJKYsvR+d2XFXKmBMX1qS2aw5BSlGs5guVEWXkFk7H1mwCk/hXMN9nU70fPWTBt5ild9j36GFaepGQyow9qow=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(19092799006)(10070799003)(10067099003)(11063799006)(56012099006)(261026121527099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?FeYz2chS5ACuRJC8nV1nlTzceG/meNQmpoZsokViRE/2I6WKuCouJD6aV/2+?=
 =?us-ascii?Q?TUkuzIFRmeHeiczn8mwXbzf3qA/dVVaeGvgInCuySp7voPMqF3tsKpMWt7do?=
 =?us-ascii?Q?7KYyBJDfr9rtbf5NDp6OLzOku5A4G2kS6wSqJ6gLwNOf9Mtf9fj8AUPtsBKY?=
 =?us-ascii?Q?uC2vy/KizjSomLANjYTrFoLSX4tv6hkm+ZPGN6BhbP0cJWdWU3S/9ErtbYq/?=
 =?us-ascii?Q?0LxnsZUal70raFsMjDhKkIrxvNNI2HKxayN08ywAaL03bRCHL0n11lWeRDgT?=
 =?us-ascii?Q?TrU452YqCB8Q+0oPq6yNJflh5dLGTzNlazoC2GdvrFIlqr3DHKfoPJnn4XxJ?=
 =?us-ascii?Q?KsTsGe+z5aU42Ul8EerKOez3n43ZiWNU4uIIwHGP7DtC30d3bzP1+S6C7zqT?=
 =?us-ascii?Q?OccNJtr76hEWl2viKP+xak05p1CDd6qoBd0QZDZNZaljGl0kc7U8M5+oCd3h?=
 =?us-ascii?Q?kVJ3K19yCBnfQYsJt3BKEwNS1jrUhf40dMtk6YzEOPXXveARrSXntFKeOrZ8?=
 =?us-ascii?Q?l9ZV+XzW7sj7i4n7wgfpeBDhNz0XS62Nlgb5KByMb1rJV0jJK22jhJqCc2NZ?=
 =?us-ascii?Q?3dU5ftIDS6NknL4di1d6kErQ09LXbgPprdRkhJsh4QF0Tf49h0HnLJ3u8xDk?=
 =?us-ascii?Q?sDmTYZcR3ndKsOX0RP8nmZlZLRtQCxqdEXSvi1vgHW3jlZ5htIvas3YGi4GQ?=
 =?us-ascii?Q?5VsAhjeFfayfdZaTt68vDihpEX6rth7K/vJG8yCdZrEVVbZNx3c4eb+5szcV?=
 =?us-ascii?Q?sbYvB4J4bK/5H7cdG80Nl7eK0cpizdotP3gClr5S0YqWtttmPWL5IfGi1VVd?=
 =?us-ascii?Q?vATL1y9k80W1dZPHnlQhHkTwX9VZvfls76S37aXTLy5ao9z5nln1gh3qLz9F?=
 =?us-ascii?Q?9fr5M7HD1/L3NgQk/yZmxlNq0fBwz7kjwPF6W0eMSGjbJDDswT3XQviJvqxV?=
 =?us-ascii?Q?kgeYokBogqklIwOlMW1FJc8oc8URRsnP4LwZcqBtF9EEuvpgQUVheeTALgvw?=
 =?us-ascii?Q?c/1CosrcjiA4oRSbsNTdIZtBaAwGlsxCvHezM+KfIV0jwk41F9lKz0qM3GAP?=
 =?us-ascii?Q?04Sb4Yg6sVPd569UwM3TaPNV4oXbVCga3PxoukQjaoDPvowkWiPp5/tOKGt+?=
 =?us-ascii?Q?VMqvzXOeEqrZCrtIL09mczok48Bj8XEekquerKdd720FS7WwDEz2uYS0fNN4?=
 =?us-ascii?Q?88neTXCdkeOQqUkmFc2v1f2b2BuyN2AX1Fg4N1ySB6QCcEHN9ORxJw5G6RU4?=
 =?us-ascii?Q?/y4baZ3vur19BiBW/acIxeNxXHWfgR4ihS8oSJ8gQiIH1LPEAkyKo9/HCxJc?=
 =?us-ascii?Q?A5p6+sCNhMONknkGGejVH4wj8mAgNQnU0cvLsAwqkFzfgY19nPS/LF9bd9Ie?=
 =?us-ascii?Q?1gIRvL8xFI1f39m8aFMoO80whcJ0JXH+zZ1qmAhYTjvjaiN2S2YAXocCwMaP?=
 =?us-ascii?Q?sqMPzpejPDeh5MFpjEXCqe04y3dZWD/QcJAPjF/V1ZdvlNTRhK6q1T+C/zCR?=
 =?us-ascii?Q?m+zgWMyTZHQCtF7Jc6f1bQ4A4soCw72UGVD+NpX/DtxGxEyh2CrIyvnT129T?=
 =?us-ascii?Q?j41tC6BaHESejPBvrMPleWwuoes2pzw8R37npCedmQCflKAHwN/7nZN00oUE?=
 =?us-ascii?Q?TdNuKns7Bm8of2DZQPIxNMtN9bJ1e3oW8ZGkPESFXLa8xPzB6wdCc35yU+x9?=
 =?us-ascii?Q?cYwKjxhVD0pRgCeLW+JfciQ8s0dhWvyQ1e26GJ2N99qX7M+G4vV4mmKqEUsI?=
 =?us-ascii?Q?uR1RIFee7VRXPbUEMbiylNjKwRes46McFy4Tu/otmih+KC7Rr7QBj9EztY8q?=
X-MS-Exchange-AntiSpam-MessageData-1: xCBnHmDwv9h4k1RnipXWovoZX1AyXDI+s68=
X-Exchange-RoutingPolicyChecked:
	QOzpYCiLhGz9TlZLZKPqeH+eLSC094z4gx1mKKFKozH/HqgS5BDBGCJoMbbdaJXMTDegZHmm81VyThmKqugQhBsw8tU/3jcOuswI+qbZnVWwPpJVxf90gY18gmIPUVTCAuhPOSZt2waGPmZAHVUzZ0bILYAmbEpQz0fvnoXeToaOZHII0sIGyPK0z0afkyKzfI8Zpw33XGcfBvd6RjD67fmZE6224ad2KO0z87aeggOMhX8wM5r2DcxxrvAdaki3IVYm7NG8Ct3reMQ4TzpuKpbrtD+RvXuaf0Nm+6CVHv+htFfDWsrw4WVtvKEXBmVfbcoFdIH39/wKFIiTbBfq3g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YSWCcGBQLnm8wE0lYFI7pyJij/REl9WruS/jivIHPieyG6QkrANGAS1VTvTsifr9zbd/mHHPykcnSGVnRzJu7MUvjFPWtB/3GvAPyodZur1TWYcmoWBGfcgGCGsJgblsHCuX0MffQANgbskJ9Ey6HzppZz/5xrdHLOYyKvrY6FtuHtoCTFO5nFxemuzEESAMcnUtHyfTavCvcOuiXAPXKkIVwv2/zq2yktcsyVgF/7NiPDELVSHSfhHDPZOUB7q5GmB48X9ch0/DJJCAU4EnMpz0M9/TLrvl4gnG5/4HLHzAxtln/8Fyp/HSx74vWa6aNAfcQSiVVd8u384o9ZZItzRMBQ/nWUW5gYG2eHwZ3bn/47nhWwjS/yNynC5AVKS9dY9LxLoi8a/riZ0ryNpOE7ig9bFbAXKMHKpnZBDqkEOdHrja1wAOs7FKhsXgrnEP/moocdpxh6yu4HMFTiLudPifrCGlXGDECG+GM2eLA9RNzYgXb9K9fvDbGa6ZqJNM3q0UjJKfyOkjWpoUmyfi2nRzgFXxgJDJBtWVEXciMyeGXA0ndZQuq6jHx1oFqyqHT0nqpOP5VoU6RY3NCmRiiczjySvg8bN6v8jRFylUZ/FXFduFQlvzqIhQWdpy3635
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0eaf780-eb4d-4860-6c05-08df4472b3ef
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 06:19:14.6861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z4wmvYG8R0BGSyEHz0n7IuIez8IQAcapXVlIvPmciUL8aMDOx2HsH3ppKvGs5HnleNSsKL9KY+O8n/S6UKA/myANNTsVBUFi7tTbGpE+YY4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9844

On Fri, Nov 13, 2026 at 09:03:10AM +1030, Qu Wenruo wrote:
> This may cause a behavior change: validate also rejects compression on
> inodes that cannot be compressed (NODATACOW or NODATASUM). Such an inode
> with an existing compression xattr, e.g. one set before "chattr +C" on
> an empty file, used to get BTRFS_INODE_COMPRESS applied on load. Now the
> property is skipped with a warning.

Which I think is the correct thing to do either way, so:
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
