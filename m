Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590146;
	b=qczvZDx8TdA0ymvjMBvk/zzejbr+ymRi4jOmGXhrm6vVfMlX7e0tJebKPn86SZCoLqtJ
	 5EOhjlTmumBPmJPKkejkddRN0VKYqPsbQvEWLmfQWJnQueS+nRgcVEBcRvUWvy9GsjP9R
	 s+p+axdWjP2PuJ7pnBaHde/WUYLAAnzFelAHOhHixxUXUZXs124KqaooWHNa2RjtVe4Vg
	 frni6WtaN35DYpIsG5EGqU3KlHnhjnKgbZveCmtFUMJawdeTNoDF800ycIgX5gxffF36z
	 9XatJD3vh+WKaQVlvSYiDnXjuYhE3xprqAJ2jmn2JDNLtUw+nXR2UYxXG9lMZ/n0loQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590146;
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
	bh=vptFBAgH7IjIbcbjyYVr3DzLcyRWVws2jKhiSyV0rzw=;
	b=mUScMnTCRLvsT9ICA9uL/oj0GqwISGYTu2TcdZqljFpO7mSn52p2N6GIawQhF0oSF91c
	 HYQ1y/NzSigGB+imjP49j4e451XLLFY0/5eJnpd++dvTGTwEXAsM1ujCclhQRfUiATlZw
	 yFjfzC7aYFsO5ZujnN4Bc35lrBOPKIPKHcPfxTAO4cBpdMA/Eh22iMtbTLU2OdBz5kTmI
	 GI8mml3ybwV4sb4O3V5QWh/8Bk1OaMruLSswZx8PNlMhlZpuTCJ37Gg3aHxnodQ/Sgagn
	 J61KMW6nZmJXR9o2+nlu/eYmvzO73JuKrMUzxuLQqxc9Ut4AHbQFqqbxW/1kqeww79w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="qv+Zpe9/";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="j/o/0cFK";
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808B8606A329
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 13:42:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 808B8606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=qv+Zpe9/;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=j/o/0cFK
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792590145; x=1824126145;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=yQyO4KxBaacupphHrXSzIEyymeYN80jyl+TQVsj4hfQ=;
  b=qv+Zpe9/ZcWKf3/z0L7WTa9T5dIKy5t4Jj9/7vLM3gxWXKiqdPWmw2/+
   +KaQEO7YpDMjCHQgCq/ZZTjKaXdunc3SnuuVBB32b2An6xw4tToWCN9e5
   uxZxiVZFzetJV36/fsZ5MFdk2zHV7WMUtNsFcNPuChlnJBitS/IYYNPNf
   BLgAw5Yf12BiODny94syJK+e/4A+/bZMsN2mfs0/RN37q7P15UxXgi74d
   LSJiezwvIt7OiM5kh7kqB/2546K6KXngFwdWZjfB1gwe6P8BzfTdOlXCh
   EbFWmJbBKiUMrl5r/wkEHVTd/VaCtw4nhk8MwT3qdQv3slgu8AkRePzro
   w==;
X-CSE-ConnectionGUID: hgzSEUOaQXqpUkFx4Fnr+A==
X-CSE-MsgGUID: YsPODYalSlKOuT2GL//D6Q==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="159601524"
Received: from mail-eastusazon11012011.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.11])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 21:42:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mclexQ0rhiCT3xTksoy3OuHZb08Gfgk49pU55RZEsdPZ+gfB78JD/pEWin5FOCnWeGzEawvubzdJXCxITYx6ZSI4jY+Igqx9Z09AlHjtW3h4SmOt5yv0VY+bs5r5yth7CTmf5OcHfWmcmVhZJF34cCUQIZtxL495tRw715kqZrc67RlXJEApTaNBL8UcVPeMVSz3pVldSpwfV135tCOfLVhjgVgXfRTg0PM0qXG11Rh0+fCNTMKN4T/zErX4SNydRgn8vOaJOJSiIsURJhqVpr6qTYikvZPupzfpY4pHoHYf9Y+mUDbtTI7J/ORLwYS7yHzoDcC9zoFO4zqp0ktG6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vptFBAgH7IjIbcbjyYVr3DzLcyRWVws2jKhiSyV0rzw=;
 b=GeW2W2UMIRXPpMc7dYYxMtCLD0w0kparzhVuWrJlYLmJgfVfJmj5oTSs0+ChG1/GU1QI7cyn3p9w3sFOGAHWPgKdYo0Un9Hba9dvhLTvN2C9pZUBeQNr75WfiFdyx08nmOktUeJVZzWWRsglvhUwLzZnrMELrsjg704UVac+IN0pXv/9cO4trsSHJYJVA9dqbDwYD8WPBtRMjbKxjwav/Mg+sOGAkaeXx17fRS0sIePeHwnKIC4Mf0AjARRXDtVHQ8+7iNFxSRB8BaONa8oYzKcnBm+GR+feN0HhzB2G40jYZoAFX4/wb79EBcEXd+ONPvLSJjQzYM8JM6JsIqWiVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vptFBAgH7IjIbcbjyYVr3DzLcyRWVws2jKhiSyV0rzw=;
 b=j/o/0cFK8hHBoFHilkSZ+JIYTK90n2CVKQfSyCO7C+scfWXk+ZcxuO5Y9U0zjftcaO5eX4gLZRalSWISok8m6nkPVogxQ2b5xHjN1WbnFZbiYTwJM7NIhHlPJHtzbTTFHYbPeG1cOG3zdlvvSkcfYddUxti+txeLADEKj8ijk9E=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BL4PR04MB993834.namprd04.prod.outlook.com (2603:10b6:207:304::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 13:42:21 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 13:42:21 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 22/25] btrfs: add btrfs_bg_type_to_num_stripes
Date: Wed, 21 Oct 2026 15:41:21 +0200
Message-ID: <20261021134124.2338902-23-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BL4PR04MB993834:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e055c21-e1f5-4487-cc59-08df2f792067
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|19092799006|10070799003|1800799024|376014|366016|22082099003|18002099003|10067099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 846SUHgaY2as2PpZo8R7P6ctlLJ04zpRB3CMIpOzE6YGokP5D13nEFxv8W+26ndnGQIaIXT58gDAd/0YU0nAYhJEtAuNLouYPBznUIAj8nOMBKZmZCdJOZCnHjMi2+QxpykOjUxxM1f00oXvjGBvQH69PrV7AezqmduiaHvzLoss3tKXUCLnknYZA3vb6CGhrE0PR8ucaU3w+WdzvBmnagwErnvbCGJMEfOvdgLOOoVa54Twpl6xH7XglpCSKcY33M7Wh2beuGDyA0QcxWqevCid/zcW7g3eux1OiSiKTR6lB4IJcb7ub5hog7MSSOYcEAqQq2iFfd1aCAWlgSP2es/UTfW1zyYoKyEreUBb40ZTKT2kGpXROfBkXydmOzp9vG9bTuAYAOyCwevjkub6TVNgbpMGkpqJYdCMegH5MlYl+0oM5pBB4ZcxQZMnx7hKPBgSnA4Er2XRISSjlYriw2Vp2StlRFP1l2ZAUih33w7M1gWfQWyXRgNBiOc0Xc9QIjxxoqnmdkMONbr/tS/kcG73mD9Ht4R3HQAJmUKAJEwuv/MaWIq5U3b/dHKjaOyU3wVnk1Tl9lYkj4PgBHrCZ/PmErewU+7ZK2mTY//BGi+9qRssD2/eVw3MrMghkmSg8qyK09peNw034YX6rxEIufdKD/wAsZMaOF9e2omh5sU=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(10070799003)(1800799024)(376014)(366016)(22082099003)(18002099003)(10067099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?bWGAVvgC3ZjmgTvvNek+BmraEv1aAM8WFmxmfXlU5AyvW9Ezxvtg56BZr7gS?=
 =?us-ascii?Q?IgtLUrKvr4q0Iaioz5DAz4lCN/JwHzo9/fhU6bdXIFHOH5RgeTWmW8pDY3Sb?=
 =?us-ascii?Q?XoMBBiERn+EjMl0OgDwmHJ25gW2lJ6+SkFJRu3BRxdO9lGdBKdAalVvAbfxq?=
 =?us-ascii?Q?4ftQUTxOhcor7srn8Fs25Xi0q5OjWfbiWYGHL2dnq2d4oGLj0kE3KWLDn6PY?=
 =?us-ascii?Q?lrx0Ntdoh3EXmShlAaZJMbdZy6hUBUTPud5nrOwfaeLLdTU/lo3OahamKa2L?=
 =?us-ascii?Q?c8IkleBkU2fF4Q59O5JG62q5I2iiQ4d0EFJidm+EsQQplH0M9oE/Mm2Nzz7f?=
 =?us-ascii?Q?gaq42tfLZ+eIWNFDqKMJgIN3D/+OXi+4vo3T4bWvnqC8eo9KNqMUyWhPemfH?=
 =?us-ascii?Q?tSa0tAoWEc/Jv5LtgHWDkr3PdrxpLUPjZuwxFVkzXYnevf8Fy/Bhf5ORGN3J?=
 =?us-ascii?Q?VZ8baoDOC4W1XNqzKN+9b0SWPhMhWhAu+7KrS2ZDob8UBaqbXfZ1JgtaSbCp?=
 =?us-ascii?Q?JckFxMwrrk0IXE5rNBiLBEwaTMbhfr88WsfropknO9tqhe5a4ePXXmy1jwn4?=
 =?us-ascii?Q?h6IqC4HytwmNqa6/dO7tUAfYOxCLlD44mixBL3VQ/wtG1DYCb9dx7/+ojIFa?=
 =?us-ascii?Q?dOT9Prh+ATDMEzOB/47Ik3OgRVrZ9bhqq/1aBxu5iMqhz9iEf66r1XbBnA84?=
 =?us-ascii?Q?wvfekmv4NMPTHc7fyfFHiXLGxCb1waQQB4q43WlmKRF2g2S6yuXtg6axIh21?=
 =?us-ascii?Q?Zc4jOZ+ZWr/Ae73jEF2bCYmIdYU5YL6IAfEmkpUMIAFPQcV7UGiqVEt/ipdR?=
 =?us-ascii?Q?Gl37Lnkeo004pw4ZPaR0iM4aQkWj90ee9WNb4PRek0QIDDDvoJjQoOqubZH5?=
 =?us-ascii?Q?2CfzoTT/OnmKMOSL+xF1VtBjuRnf5oz9ZQmqNnBAGm0YZn7+aoeN+UhYqAOp?=
 =?us-ascii?Q?v+M/iJQrd0fWr+CFu1tzMnn2ix7XELeNsYmcu3hLKRuoTsm7l+7A6xWYqMQ+?=
 =?us-ascii?Q?wufCovTPPexMu5y1J7HZTitXbXJUGYjyjwedfhBeuJQquXtQGd4HxLSnGVzy?=
 =?us-ascii?Q?bcEjvTqm6rkB05dRu8DstBXzz9UXZ1ODCvbUaQvtXKd9uZz3ScrUW0gz/Ltx?=
 =?us-ascii?Q?vrwJlLcKu47uJFUwZlQCm9Mpm4G2/ih7/1dp2oPvn4iyXGuFLSmuL/io98z9?=
 =?us-ascii?Q?cPNRbjRrHXFL0Dlialf4DoOHzz7QRb5w6F6ojCMrXXqoSYqDvhVxOp9z4LcS?=
 =?us-ascii?Q?vfdUqlIEbjJnbBXoU5bsFwZCEkmNjos0igIqkhdD1KNxDpE5tYiCHVhhYCax?=
 =?us-ascii?Q?lMksJRF31BTG3giLQkS7B98xmsKKcv0HwR5r4xdmcGkPPyc/pf3db6MOKvHg?=
 =?us-ascii?Q?fa+sqPBn1r2iBBODtHvwpdN9kPL3VKQ7yZzSNKtGvucKC2wTq8zgaBMxVzxW?=
 =?us-ascii?Q?lnOEfFgLq6aXSRiTPC5MVimni2MqTwBaAq7fmkOobv7NUvOMeDY0wwnpssmV?=
 =?us-ascii?Q?UWKd17ApInfpENld2Lc9RrDk9wDWDlpOuaNSch0h/iMvt+fIIWwJnMHNSrva?=
 =?us-ascii?Q?3pU/9fiELEUxUhXg5LEfbS+OI6j64U0PDvCbfzBPl9QXqVWYKRiD4LIQMyA4?=
 =?us-ascii?Q?eegCSFy7kuLNSKebNVr0gqvv7lHLY1efjGwhkkizGtcNgEPHJ0VTtAEfil4C?=
 =?us-ascii?Q?325Q5NZR4Tz3quJFXsuf+F9OjoXMe7xMYG6idD0pXxDv77msmCED5WGxdVn5?=
 =?us-ascii?Q?wr/gpLIKk91UT787AvyG21vjJQs2gRba2UsOnc0vMFfWwMEpmXs/qwMMhYhc?=
X-MS-Exchange-AntiSpam-MessageData-1: no9Im+kjLKLWDKhCLCTM/mKscTvt3r5vmH4=
X-Exchange-RoutingPolicyChecked:
	VZiNTcrldRK5U2w68+LhGV6huI/5yOr2t6J8T6xAC+mgCtDhtihsb6B0+Qa+GQ6Kq4ZSZg8h/EEBRe9pQSfnIBG+sXsL1R141kqs/Iw/+bhno5zJ5ee39hT/EjO2WrrAB7+7AefNuy7k6WBbSgparkkxBIUzCmZGTOU92sj6hWzSGuAtWnqr5kO5Hek4yml9nTAxHWLwmcvZH3JrC/mnAQBLvwMFygW0ZXEOyeu3bB2jbM8/RflZcopTfaPQx/m+LuKaSQ0WWcxNk9LKSdmuFnu+pwTDaaFjxY+eQ5lgZqstPqHv2uxgbSElyGjxKL61BKD5N+NO/JKsKPUsqrmQRg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ny9JlocIT56XD7q/Cu/vzPtRSZkMcOiohUnWVi3ESqDRMTbSjeVkVlTxfZD9YeBxxWtNoArMfTLcuGlFULOMd/F9gEUH0dJgz4LYLtAp+NLVdAReAlHCeSmF5Mf+z9TsaijWOUjZtxcU4KWlIPZ2XA8BtDvee1Vj0zo5FZw6AnUXitSmNPGMWLSSfohwEYLbpsKWKbL6Y2mi+udu75CUq8gN1HJFX9Pqo8C28vecCkI1NHupnEd9bTeexf/0Nne77x26ZTDbupzgFhpZi1hNndz2Pd1cIKQEfR+V8sndYKUTds71WAF8qL+0yoRUrLma6or0MmdxJMCqgJN2VqJA9E01nfDcj7ecaYMMCnfpiYo/TQwO6rtEmqJk8BnYh4nZnObouOlWC79bNphht9D4sWiY8nHFBemtSBeMkvK2BuqRW+8aj6Y17AZY8VhdRSSvE5UJ1KHXGVplBMuUcw4XkksjZ5fmj9OJtpOjpxZZEVe2vENBAdiMypvbGgRAFjO0BuwZWbeNiwBWGUe/ldPLU++dFUrkeCy1B+lUTk4ZKp4PofLPkzz6h+mrByhF/TNn5Bu+ffqkB71oWnNlu5u5iYi/xPc4gjdCRDgcXtl8hRGf/zfSHdPAJs/pTZsRntvQ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e055c21-e1f5-4487-cc59-08df2f792067
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:42:19.2055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AOlnkY3Pg7d838nd45hugQ/YQ8Un1euQKJVZwPUFEttimknYY6vz2NypjhNqapZ1sWfMhmututzg8ZSWOcpnE26hRHHMzdIh3IZq/nbDdy8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR04MB993834

Add btrfs_bg_type_to_num_stripes() a helper to get the number of device
stripes a new chunk with a given allocation profile takes. Profiles
without a device limit span all writebale devices.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/volumes.c | 13 +++++++++++++
 fs/btrfs/volumes.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 14857421a0e9..11dd33797d5f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -195,6 +195,19 @@ const char *btrfs_bg_type_to_raid_name(u64 flags)
 	return btrfs_raid_array[index].raid_name;
 }
 
+int btrfs_bg_type_to_num_stripes(struct btrfs_fs_info *fs_info, u64 flags)
+{
+	const int index = btrfs_bg_flags_to_raid_index(flags);
+	int ndevs;
+
+	if (btrfs_raid_array[index].devs_max)
+		ndevs = btrfs_raid_array[index].devs_max;
+	else
+		ndevs = fs_info->fs_devices->rw_devices;
+
+	return btrfs_raid_array[index].dev_stripes * ndevs;
+}
+
 int btrfs_nr_parity_stripes(u64 type)
 {
 	enum btrfs_raid_types index = btrfs_bg_flags_to_raid_index(type);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 67464025e449..6b9a2744f6ea 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -910,6 +910,7 @@ void btrfs_scratch_superblocks(struct btrfs_fs_info *fs_info, struct btrfs_devic
 enum btrfs_raid_types __attribute_const__ btrfs_bg_flags_to_raid_index(u64 flags);
 int btrfs_bg_type_to_factor(u64 flags);
 const char *btrfs_bg_type_to_raid_name(u64 flags);
+int btrfs_bg_type_to_num_stripes(struct btrfs_fs_info *fs_info, u64 flags);
 int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info);
 bool btrfs_verify_dev_items(const struct btrfs_fs_info *fs_info);
 void btrfs_update_per_profile_avail(struct btrfs_fs_info *fs_info);
-- 
2.56.0

