Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602673;
	b=yNCyIyMIWhefaGy02ILYtK/rZiFsRDpCxiBneWeF7lmHAO0a1X5IrCnjmWOwqppg2LI9
	 Rp26aPMCkioSRAKZKHUglJc/f+lcE+ye8B89h86H36AiEdKNmlAF/En4pG/+s/O+Me2hp
	 rHIHUev4+XV6GGosz/xlLUhdhyvXSTIR2+Twj0AdDfKr4mEWUMp9+EqYktFEIVaBtOBW2
	 vj0C1xw6s2/aiwf8bYS9SA09vD5rzm8y76grZnBMZQkiyfvs3ogXzgHWroYU8jIG46nF6
	 s3j/umS52K5M57cRla3FG7iSEF0GNLYPlETTigH8iQB+6t0tF4TcY+125loiQ/1Nfow==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602673;
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
	bh=6+DglfFpDrrWmweRwb9wlstisZpT59WQcqM1u5B9xdA=;
	b=FccoNL89OOGp6VXB66NjMJkz8yr1W88KVwGBxXU8dGOl6TnA4lki98xc80ahJuL1O11u
	 3JciMYNHHvO6QFi4aOMZUWrotLh/riZsjiId7paJy0zL/7NoGxq7fmWqe4sj9gBl3Xgoo
	 3Kmwr1qGt5x5hdeTR0kQ6HAYAbC73/37c90S9yGiJ0vC21Dcg3RA/oe+tBFhg3aW28JwP
	 yPUtlcoU9K7GlIV6BbQg52kZoqItGFwryAKQkiymOkgNtIjHh1xiUH6MGFRvmJ5yve5mR
	 FCDNUuMkcpMGxjkm71cpbX7i3P3wysnMBkf/OY4L+HAr+YDbdcVtnNPPR6VSL2j61Eg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=JfoXHR5u;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=SaMbu7jv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC42606A336
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:31:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2CC42606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=JfoXHR5u;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=SaMbu7jv
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602681; x=1827138681;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=9Ei7p9+VLEesqU/iJL94D99pk3CyeZtqm3cevgVWwwU=;
  b=JfoXHR5u37zBa2PleEr0Q6woQK1uGaDTxXZ06Ss+PVz9t26gFHToI1qc
   Mfz4Iwtd5j7abG98LSWdmpK8YDPb+aQrfd7VBd7oT2+mOiL2SlWF8RSon
   14uQncuZBVMuEK+NyzMRuF3OX/Y3zPQ3eq/fUHaYD1xNm0a5s0XpQRdz7
   PUDIOIO6Zh/Jn3emo0ypJG9Exy4XN54YSMbNG04tp9KMhnKapCEl1lTmk
   N/8RoKEw7YmrFBfb/MPlIlKp5LC2SCTl95t1Jvhcgyf4/DPK3FpGnqh0r
   3WYRHlzBnRQG2w7zIAb3YKOLpy87rTuhJA1mz/LyCgIcCteU7gO8eiVm+
   A==;
X-CSE-ConnectionGUID: MvXC1VKNS1KZEXKKlMIJOQ==
X-CSE-MsgGUID: xubhjynUSEm1s8c5+NjBIQ==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="161732732"
Received: from mail-southcentralusazon11011062.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.62])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:31:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FlE6CrrrsfwpYlYuXHv10syEDXd+VahDkSiO23kDO1U/B6FKopMzpjVswdpd1bi5gxKop8T2O0AGe3eQt4fvCE2MijJg5NREH1DqYnuKU/IN057sKQG48d8AxqYoe+2s6gp81IDEWFA6qR3EOs0iBapXx+hUYMklKDpLJfBZaL1AiCa7R5gDUQ5PsQq7vKf5cp0eDS+7zGyMufKewqeeHWEvSpKS+J/m5ZQMG3sCjoVXzJUZJRanWG/V6eqG65t9teMC1Wfwous2fbKNTBuOCoevTywthSih0oTRFPlq1CxIUfiCtzZEQCmUfjFB6CyCaWHRraFGH9pE9jv2fpad5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6+DglfFpDrrWmweRwb9wlstisZpT59WQcqM1u5B9xdA=;
 b=O02mlJ33PREkHGNy4tNX8RIIX/SqVSDFDG7p84igy1EHExPK0qM+RLbxl8JgN65qEupPoCCL0qTJfBRqjJPFAVCCfSmA9AQ6GJOoED4tc/sdlizEoUB7P7AN/8D8Cv2eF+KAL1I8aJyV3KQRwzSYklFMGdegyaMJT0eZ1sbCCB5lPcjWNB2FxVm/HJIA/7tMD4/kEWZEDvsD6JOXmQdk7RJAJ1YOKp9M1wiqlWnPDuqstVDfIb/I/WJqS8E0lF52c19yd44RNpQiGzPOgIhiC6O8oF4unB4rx2ZkPaENoeKaXEHu2Tsi7kf5sWP4lDc96ZY0Syj4TdS5BJhm7iJ/6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6+DglfFpDrrWmweRwb9wlstisZpT59WQcqM1u5B9xdA=;
 b=SaMbu7jveSHVaBAbbyU4jYklNls3mrVX8APcwSiCUIGnu1dNygjlOSHbGW8DAMzQ5LgmkilMxSyTH8bAYtPJ3EeAYC6OWd2AhNwFICBKZeVBuIeQ0FGqYguw/pYwIysSRSs+o4HxCnoWGV/C0MF7qlSTahgDmpa5FyFVClv3Q2g=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS4PR04MB9868.namprd04.prod.outlook.com (2603:10b6:8:2fb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Wed, 25 Nov
 2026 10:31:11 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:31:11 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v8 24/27] btrfs: add btrfs_bg_type_to_num_stripes
Date: Wed, 25 Nov 2026 11:29:53 +0100
Message-ID: <20261125102956.266389-25-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS4PR04MB9868:EE_
X-MS-Office365-Filtering-Correlation-Id: 20a47dd1-8ff4-4513-fd96-08df4adf395e
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|376014|1800799024|23010399003|19092799006|10067099003|56012099006|11063799006|261009223027099003|261026140227099003|261102123227099003|261021121427099003|261022105027099003|261028144727099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	14EfT5IAaIv4kpCmm3i06tQcVV6dL8C821ipxg4i+gn+ALkufTIWJyn7v3W4QdYIEytdGAE2ZmZw/tvg1MMuX3ozTlfhIVclKqLlBpnhWxmfcGff0nfTwvuNa0ReulJ7T7P/+wvLZoQAkkHOYueU4Dc6UYBV0Db6uHrW4dgtmliFtFxSVZVbuUH62znrUW6UuIqyGFTD/M6t4XXUbCEXebcwu2sbyYpsI7AozgmjsyZJRORMcQSUKESFRnKeG+hoQHnazrp3+X4lMCSdJY+mznBgwsHUJdR+etSE7KnykpRTsnZ4t1pESyf8pM8amB79TCG734BWerTSaNQEy2RgjaKqNBzErOvGTNWMPgLHu0l5hQZKGyhXgHgnHgnZMh1Fh+AzSHD7/bMdAYJ02GbIXF+eixtNjaHWIM/cL+T5ED3BI59aQLd8EKYc1MGf2ypW8j2ZG3Mynh8YG6w3NhfzwhtZvd8ERlrXGNtb4vjyDXnuwnUK/KQXUUW1NpgWAxaKCBLoXlFbohZlzxOB1IIR9Ngnf54RK9Cg4/JRiqpzBn01xEzq/MjBy7VjOrVId1LVOMHAQ37xLULlXyS8IjQxU4aLBdHzLNGGnscjOmErq4UqMHDy1v6tMqJpXLm9m2Cihj4DYI8xrdJrb7cqwObHgIivFHj6KHnFkeNpM85R41k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024)(23010399003)(19092799006)(10067099003)(56012099006)(11063799006)(261009223027099003)(261026140227099003)(261102123227099003)(261021121427099003)(261022105027099003)(261028144727099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wol4gU1PyvQioTn1MwgA/YwBp4N8F2X6ufGQWSg4twxAAAMP9If8RdTp+lVC?=
 =?us-ascii?Q?r4FjpggG31GzHZUctd+7hiwqD3O1e1XxgiQe0jxnzlYjl50QOEXG0UGtwPiS?=
 =?us-ascii?Q?tkz2Dc/m5Myd2TEGKuUe481gM2hZiW1rWuN6ysuOvdYu0q1LBc8wKiOR6B79?=
 =?us-ascii?Q?Sk6nmrUOOiPrGGPqxQJuiLqTSj51HvugK6eD7SWS/PebJA4ibmNTQbHGzDNB?=
 =?us-ascii?Q?o/AzovC3fL+HT5bScC7Nh8a/JODE7K9OkTFdov55k0QRfP+xd1AX+DM+xSVs?=
 =?us-ascii?Q?FiCOiRvXgOZmpeXfPP/09HLjg63z4hvmiiN+kSEf70mb8X6RzDf2uEoEhwx/?=
 =?us-ascii?Q?lx1vILgIMespXWSRfOcOQLTcj9RVHHPt6jg0Q7yYTkW25oJtiN32gGBBKo6O?=
 =?us-ascii?Q?xt7X4PHwbfdtP1maRad3+tNbObd1i7yvu5pm1BIwDEa1zEhxndNACWF7DHga?=
 =?us-ascii?Q?3Ch79kg8jmia/DMIwxzVihWq0GGccZofTGZsSHm7E5bhvmv+9IYIzXqONq0v?=
 =?us-ascii?Q?MAjXK9kozsDGq2NXdE+BeU6q3ftA2L/vH7spkpj/hEtAxXmrVdKxvm4B5SAM?=
 =?us-ascii?Q?ET1+v1IiHgKoXRsA5VjSMSbw5Ad6c3h6kfJ2m3ovHD6wIq668PAYYqGq/45D?=
 =?us-ascii?Q?sSKpzyTn+dQVl3KvwmbRlLPyKA7hsXdy3rhyb7LJEpKRIStR4fTN3l/usJc5?=
 =?us-ascii?Q?ECcgxqbdsfJkoCt0GW38FD+zoZrr0V7BNt08HtH8mBfT96W614OXqGc3kRYu?=
 =?us-ascii?Q?HbsZIY2Mi4NxLv5A3+iz81ITz0qNeqYSZsydtTr65hMkX4n/LgrSB08l5O6W?=
 =?us-ascii?Q?sBeiaWlFLTt3giswoGb8yg2XrC6MRd5COSsQxbDio52W+eNZGK6bsNtiAg6b?=
 =?us-ascii?Q?cVFwDpaAVYXF0m0GmJ4dO+SZ8nHC2qXRgHBvqsrpAs6koRqbf9Fd1w9sjujF?=
 =?us-ascii?Q?1flWxb81iYDJnfmqahTU6hDZrTRxwc8SeDLBuLCaFEne+/Fzc295GSmWgx1o?=
 =?us-ascii?Q?P8Jk1I3hVeDW2EYpypTB2R9qfGhDwjrl30Gqvdf6Smuc4lJtPDQENKnPqO6Z?=
 =?us-ascii?Q?FTdGyYVkWqxv6PlxcW3Vel/LC/Kg3r8sEjY4XcWgXdk4cAjb4IR2KjEQAPWN?=
 =?us-ascii?Q?RuPx3CFZ02ZQhc20bbUk+kzvR26GljHukFOlMS/Cf7dPseHLGEdW16KB8y3s?=
 =?us-ascii?Q?7c8aEW4YOvGB0i7sq/wzV4wlz+Ud+SSwKhqGXI2o8u9QRy/7d6bpSwvF7flW?=
 =?us-ascii?Q?7h26vwAafr2QNqDt9nEt4xEVfWFSbJolVX8SF5OE+0zhM1ekaLvouXM8tJsT?=
 =?us-ascii?Q?L/1GhXoP/YJLeurq/9n2sdwaeYct+NL6GBeLjH2xqwq2tQc9vvj0YmVMob0Q?=
 =?us-ascii?Q?kInOCyuJr4ijvqa5dcnSOsxjprib457osuHeRLUQ/YITn6FnRVphPpepZHzx?=
 =?us-ascii?Q?shCVxz4GC/aGgCwSO2w+1OFMwUz3Ktx+mTGnLliwl8E6INL6658XAzbVa+3h?=
 =?us-ascii?Q?F1CXsLRRCVmArJHEzQBVcYK3gZB5AxE59vxIieDwC9qvwc1okr9rmH+AseMo?=
 =?us-ascii?Q?SRDs9etRQzNhAc57iQvqk0meG2eKPt5ZrXKtY4UhtIuZEkvWrjl4tcBEDVDI?=
 =?us-ascii?Q?ChPes9ah0cXQtMX66E+RlPqmRcn6amxjYR2nPBuDxBkZRTQdKIIuJn7sqmbv?=
 =?us-ascii?Q?z1PKxeu+h+4y7IGTryltV8whfmLxzBwKzeoLGYwUDLpOHCJyWLSgIA09HNlF?=
 =?us-ascii?Q?Z/K8ApBaoiTcNOzwswHxmTHUUi1dRqM8wk8agxiKeD0KHOGC6cSBozxs7SFb?=
X-MS-Exchange-AntiSpam-MessageData-1: xLGbS/wu141cUcCo1ZeDJmlfXtlSgosAkQQ=
X-Exchange-RoutingPolicyChecked:
	FfyfLg2HAFdo8jwuBeXvG3ipqZcoy+0Ot6Km/RmPxmgK3g+fnuLQLl+FwDiwnQEvVF3H+KNntrYPFrlCkV/DIqHpZDwPIgAy8/dIVRsp7uoIiIShRhmMMB0d2UWbKkxnw2gvZguZplKKmUhVLcJbC4H8JDJMwrajzAVVvAY7FRNMf8TRgltA+8sIpa3uKiwfV99uW0tDGJSuyRpyJBP6L5XE3Lqpyaw+MFf7fmojcKk5IBp4T/X+bpvlDzBoXJZpXAU2wDggOBvtwQEoTuGU1ehgqLURSwd7tI/nmFNIDJtq+kKR6sgf34rEgY59uwYr3RturVGa+6ttsCHg5pn3Wg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fz0uK82dIPCmn4QoQGahyu4XsitH+p8/KAvxvsW2zld8+ARM/idH/azgpujfGPxojN2oOmr1oD0tnvR/tTWsKtQD4Hyu+FYjuAeaFMJle2LAAHH7s/kxoEgrk0pDl5kC4zywojjUYpjoo6egnDGCcOdkOiVfxj5VEfALHb+2FN6I6unP718pREhW4H43KOKqqU4Dsm2VlJc6CYxtCEigEwvgyYtTsPvaDb7nfhy0jwcwU4arG1yJflsAqsNWOCV06nEzR1IUX1377b5UN1mNLWQFJjnB5kwK38NwREZOzsYwsxtupV3LFBnaa098SOUVuMcDl/V9wJCYbzzLqATd4ZO68w1Ei41b1BwpGn4AJLNKzMfwt4lKWTo5EEgyeI2JvPJ9K2S2az1sXbfZRoNozhiBeSAW4xPmFvsCpLhCcMVmlyx9C5WucFOsiwpnEEzPrLOIuQswruHZM1nIS4KePVwoHYdvTsWGBg8s1lhVAn3OLjc030l3YSqXk4AOKyNBs910BbUcbmsG1g29S6Hfqo/byKzB2RzRQKymS2SA7pfl1teuVDkAx1Ief0mplRhtDI8BuQJVTObqR3jFNtcUYGeHOzKnin0VDOhpoTCJCBoHNHvixCusK1AS7ybDY79H
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20a47dd1-8ff4-4513-fd96-08df4adf395e
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:31:11.2244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ptg5X0UOTdCGzugZtzPvZod1+JaGVBT1oDla/Bt1ZcnVi9YI72DkveKzhh3Kl92s2BCPFvsUhBApT4VqQaJynb3Uw64S3kzFAu33NJVE+o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR04MB9868

Add btrfs_bg_type_to_num_stripes() a helper to get the number of device
stripes a new chunk with a given allocation profile takes. Profiles
without a device limit span all writebale devices.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/volumes.c | 13 +++++++++++++
 fs/btrfs/volumes.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 18cbadb01b4c..1c8c7a9b8faf 100644
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
index 891bc2432870..d48d4d1d9aff 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -913,6 +913,7 @@ void btrfs_scratch_superblocks(struct btrfs_fs_info *fs_info, struct btrfs_devic
 enum btrfs_raid_types __attribute_const__ btrfs_bg_flags_to_raid_index(u64 flags);
 int btrfs_bg_type_to_factor(u64 flags);
 const char *btrfs_bg_type_to_raid_name(u64 flags);
+int btrfs_bg_type_to_num_stripes(struct btrfs_fs_info *fs_info, u64 flags);
 int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info);
 bool btrfs_verify_dev_items(const struct btrfs_fs_info *fs_info);
 void btrfs_update_per_profile_avail(struct btrfs_fs_info *fs_info);
-- 
2.56.1

