Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55FF38F92D
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 07:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791876723; cv=fail; b=aJ9PrwwpyZuxFCykx65ShpP0uf8/6jVnyNNF4h2O1cH4ne6qCu7W4KF2KlxmYgx7CKja2mPxAadVstDoe49yBEwfXKb6ummLJdd4pjdQ/oxtla0MSq9hL0i7Wj8QcE+tuVoVY2yu7dKkzo+zTlOHdDpcKf5ouNdr7mbwdwgiWIA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791876723; c=relaxed/simple;
	bh=m/Rr+0lS5lUlDH3/BfKjPjhOLdSswzaVekkYJI/92bM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RH49iIRTjTq8ab3JoR47WYDiq38qUA4PC4023/MwBYv0oq/lDuzzNkuXoiojZ5QS0zSWX0UlsGrl1i/Y7mObJzGySrUCulE53FvIv9UjemfRS/pROmI3f1e390DRQZk5f50g/xnzsLluvpLZeIwxQP1RO9PZGaExF0ETChQuO64=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=hp+eJnyX; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=dhYdD1ix; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hp+eJnyX";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="dhYdD1ix"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791876721; x=1823412721;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=m/Rr+0lS5lUlDH3/BfKjPjhOLdSswzaVekkYJI/92bM=;
  b=hp+eJnyX5UNc6NgzUE0gmsvy0eGrmAyKaQ65G7V1RL/ai7y/VmnHo/YC
   hGis8BrPd1DCA6jSp7xEcqMJNMM17YkW3RRDv/xqmtGbYU8w1lSXSjpq5
   FBgvpg1GSl5ow3w30pRx+XcW0vET1K2BuqkQF9aV1xILsFiTmbGpfEVWT
   swJdF/Gj4stjiBTZRXgkz8IBfJqk5L1UdHW4JtAvcG2cGsvAc6v4V4yu3
   Ng3H/mFtI0uvXESAzTWvHGsNK+Y9MhGYeSDsXZQCGytvNdlJN1FRcdUhe
   aEmTBfLhsoqXChoBtsepee+YJBVcjhr5HYU6wnVeUqJ8TOJ7Z91pdYjLQ
   Q==;
X-CSE-ConnectionGUID: ldbhxzq3RViqOnoIt3HB2g==
X-CSE-MsgGUID: D0cwEJODRSW7iz58ZJFsLg==
X-IronPort-AV: E=Sophos;i="6.27,155,1786982400"; 
   d="scan'208";a="156364543"
Received: from mail-northcentralusazon11013046.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.46])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Oct 2026 15:30:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tl7dbaebZnVnf6sNQqRlB5pQszC2AOgC+W0hdfh2bKf3cXUmeMgcANuTHrf2QH8TLQL/bbNXTzWJrbwHOUB0y7xDsvsmemzKlfOCJcT97K4F5DyLmq4dZG8DUYGPiWgOrTEnxkcW9VQkpzZ8LLB+72PwZ+Hp/oD/P7723ewkms0zFEyo4F/rGYjcxZyyID2dSl5TPfeE7s4mk0GEtHbzbW/4Tvg3qNM59kJ8qUThtZn1O1sKIwuLexAkJ6woR8Z2wsQWmKIVD9uJVPUBsBmibppN1EXO246dzitbVw0dBWmBsbSEc/PoPHgS2MOlYBSj7sf/Hn0wGvu+a6R06dB5dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PzCH6oeTc8tjSGiNul0LwvF6x0ghRwa1OApBQKtmuUE=;
 b=e6yNUCU9Bq1DWaYNL6U+SCfZNrlK4rlPXBuh2etm1VoRut9ntu8lZ1UA8+G3ykuximiIRthzRUKuHAO/ZBhPbttwTEePR91UbSU6vEkaLrLTl7OAWRv4k3wYUH6xQ2fT5tq1v/cgZe4HMYG2mURQb/eE3RatDN+RM22HwOomIeDyHWyq8/fsmyaxWD8lmZyk+WvXTa4n+Hb36snibmb4d/8+i/weHn85tRD7TACExc+C5JrHwEFjfVPp3F3m80qX/0Pgu2F+ynNVRJ9f36Lnzd3klhx6IjTs7RTre4Rrmlza29iMUKV2lo1SL8bqElDYlKGD7gOrLWpAAte7bUzKcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PzCH6oeTc8tjSGiNul0LwvF6x0ghRwa1OApBQKtmuUE=;
 b=dhYdD1ixQnZxyK39QUkaC6w0pRx8pgCBwZBC6KYsjGTLeu8fYPTnBxfvMQSyd5OqU3PytZlFWVb8J1JHOyUOOHfP6zR93jCvo9LSGM5dvwF9SqvhYgucOQxushwgZxdkgbbCnBAast9kAF/f+w/NLSdNRpXjd67o4n4Yuku8vhA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CYYPR04MB9031.namprd04.prod.outlook.com (2603:10b6:930:bc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 07:30:30 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 07:30:30 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 11/12] btrfs: zoned: remove btrfs_zoned_meta_io_(un)lock
Date: Tue, 13 Oct 2026 09:29:40 +0200
Message-ID: <20261013072941.424029-12-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013072941.424029-1-johannes.thumshirn@wdc.com>
References: <20261013072941.424029-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0017.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::27) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CYYPR04MB9031:EE_
X-MS-Office365-Filtering-Correlation-Id: 88a9bec4-3ee5-420c-c885-08df28fbdbf2
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|366016|23010399003|1800799024|376014|19092799006|56012099006|11063799006|261009223027099003|18002099003|22082099003|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
 1KWotVmE53Gw8BSY5GkeCEL3XynzOclr/4YCr9MD6FDbNPqyXV7SGkD5VBIPI7XQJSgqBTnl2l7/vnt03N3HKTFh1+kvRJcsUlZRtPh8g+bvnV3joNw/M/DMZ52+mnR1byhlJVeeIYM7SoHA229YOuf5TC4p1i+57nUCUW5Im1f77/vZzWcJtjhGHXJAuw+LqLFLVD3stEJgjJqXRnSQfmDizcF+keMm4AidgwytIOtyE3ArAWCtvZSp/O6HbHt1zXW3Dt80ZANALUIgzB0xAbsqc3xQuwMF5yCc3e09SsZ/fyCOrtY+5lLGWRAJdq8QLUl5r5knvOg2gClbM+r6ao1MzVNOkcRuqAuSwJi0KtVrHDbZuyHagxeqASBi9ArcR2FLMVT79kC3ol5mpXa8pa9ijrtEDox92sm5RPrZ+j/3Ckd+7JvxRnF3NkYJfN78btGmiPz4VXHfXbTV0wl5Dj/dTsQXvD4yuj0Dscie04qRc164jcoRacnJyCymaxJkMSIxt/XTF5AOINE/RmJT5dLeCDRkICfg2uNioL85VBoT3uKeAUu//XHC2bp9n69QhZ2F4Cet4aO1zrnWRg/CtRbo9WUwAjOb+qZko8/0RSNCK34KTuL4LeuNhlRepQqiQNMAfZknTEyQC04sMRjNTXb9hUqYB2UPQAaWUi8Bbnk=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(1800799024)(376014)(19092799006)(56012099006)(11063799006)(261009223027099003)(18002099003)(22082099003)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?MCZl4NOf9Gi2u3A5mWm9IU6/UTrEg3ALzcJOpvwoxv0G418Qiu9otSbJD98x?=
 =?us-ascii?Q?Q1vV6HEZyDdZ6V+Om3qfYGM8O6B5yDbSlS2Dldu3ooASqa5Cee6twHEtmFjI?=
 =?us-ascii?Q?cR4pfOy+u1uNeRyeIJ37bJ2bgKeUN0PuuJS/AT1LMwSrmd4XjAdNerNJzyiA?=
 =?us-ascii?Q?Fqt3QF1uAvwLN5RDaeP0+KGaQ9/pIJ41iRLqZiXYynmp4MoJU0+M3A5mKTh1?=
 =?us-ascii?Q?K+D1Otpo/LN5jmveNxK07DNT1zyUTYXt0k9Fdju16cW026bjbTMryN39405w?=
 =?us-ascii?Q?AdqieZUNJXD2oBxuR86VxNhX3B4X3aIGGm37H9j89vd7JU36xMJLdO1UZMf4?=
 =?us-ascii?Q?JJJUVb6GU4wa4W1SP75Y8OGKBwBj00ntiHFe3PyaGSyruaMN7JWRbxe9CbcC?=
 =?us-ascii?Q?lSVqh0rzOu1tIrMD+1M6Avptb/VVJAd3sO+CKj1hIleX2b+JnjsGjczHR43C?=
 =?us-ascii?Q?nxKQjg9agohRi8GRa09veBccoSTDd4umx32MHav19xeVme24gK6GsKvaPjxT?=
 =?us-ascii?Q?+3m21aKazsmKCtl3rakwNgJZAWKXn2TOCOZIzCvcLIqxwTqeJjUhUKhLPQgu?=
 =?us-ascii?Q?Wt0KzyB55PKJfQD4nijDPosU9N3wMnPRDGNiqUh/s2aR6sAO6akg6Tq/9GLZ?=
 =?us-ascii?Q?U1UM2P4ooqe+K3S5NFFrWBC5cgQ7QWFINOuAdzwreCTOxsTH605Cor+Xi3DR?=
 =?us-ascii?Q?Zg1uzwgqlTJWDHWcJYE0mUqUQI4liaaIdrzta3tGNdlJlFWc2N/aPAavriNh?=
 =?us-ascii?Q?rz0n9+dIr1Utw6QNs4lSl1cN9RH0AvyCGg7qe/ZEbCSwgPhNhfJmy/4P+thU?=
 =?us-ascii?Q?FX7Wc0CrOKFqP3gldhm4ZAOkl6RcqzxKdCwBFeHTy770Mh6XxNib9RxHuMOy?=
 =?us-ascii?Q?Bfxuz4b5QPPMpfJhjv/s2hswsk6Nug/nwUnPxmPACb9Q3oftEaH/wRswLw7n?=
 =?us-ascii?Q?7ciShSjk3st+RuYI7Cs3Qe9mUHhciAiRtEP+GLpojsvmy/WOqhnU9K9p2stL?=
 =?us-ascii?Q?QYMfvl5hY8NZ316Hj0DJmirgs4IVY2T8qDhBi5SO+Y83z1H0r/JA1x33Cxcv?=
 =?us-ascii?Q?Go9q/yLjEVBR1CXWSHHzmGcxLX/bwloO3a3yg+FKE3fqr9EIFJIkzTjMKWAB?=
 =?us-ascii?Q?nsi23mvEhprMfD+ITPjLSMJ94bH/PXPnc28TsgPNSfqc84BK5uM2ZRKUnYFN?=
 =?us-ascii?Q?M4JBe6dTyWIZEbLASwdFVUctQxrMbigXCLdWAp3CycD31Sc2cgTszddGtau9?=
 =?us-ascii?Q?FVPE6POKRcQuz3a+Q47IJdDg864Yi9OPBgM4A99OJxYnOOwZM3fB4unO2HEs?=
 =?us-ascii?Q?+jeFz0FRBj7n/92sMh6JBAdW1+Gsml8NZu4BeJulwl7/tI1rwNrHFLgQQpbU?=
 =?us-ascii?Q?JE7175cphixB4uK8e96NT+tjJ7P6jOw8ZfrKqLInxNkjF182HC56NoU5NwGl?=
 =?us-ascii?Q?zbflW7E42Em58jJRPMJ0/xYuAhmPqCqB1u9xzbM1ezmZ5ckVhvTBQPNmqXzO?=
 =?us-ascii?Q?vnRR3h6i7FPJzBEHIH/PNbhif/07lly+CSZqHQezgboiRsaYgCn6I4Mvzfel?=
 =?us-ascii?Q?9ePi53O4vCcWqMIYmTvJHqz+wVhDMiPk0EJc2k2a9j9eCZjof8r7engoGTWh?=
 =?us-ascii?Q?I5OwATCb6nHPzO3TfVGSh61NpF2BAZ+X9ZwEBzm56OWADBmKsVw78EpalO5G?=
 =?us-ascii?Q?pgTnWbTBTFwpilZNqXL9zKNFZfSGlDf4rs17/isaWBEqtkgdo0giqlzlllel?=
 =?us-ascii?Q?IxzPpd8p74mJlFB3rucULNmf+L1sCPxnzL1Dm6UFOp4JwdrdgKhF9hcHM83P?=
X-MS-Exchange-AntiSpam-MessageData-1: /A6hgD7Wd2mZmVb2HC7bJY1zgJwXZ2jMqyw=
X-Exchange-RoutingPolicyChecked:
	m941FHQB8onDUuVOjWEIcLWqntQL0Yl9P/nR5EePc2ghbWBJrCwtjEzD754cfItCTX5ZUNSNA+F9dkhdg57ivLdO9779JH3Ewm9d0sWvPP3KGWJ+/TdrQ28ZEBu8QY8XOJhW/sm5FHOn3OhTfQNEVTVw3teuB6xBPSSzKSz+r8dpWDE+q4//vzZn0rgYZE7aPHaLblKkhX9R7XI8JPjP5M7P+XmjvHqllhdQPf88Krf7qoPqUrGtUQDKU2zJ5dIcWnS3WnTS2hqm5b4hb6RsgNVvsajn94QMlvt3hkktcdLR8A0vmzRkmRbPkUtgwK6SYI92mAiJ9198rYYTLJOnSQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UQmlm/uytKSvhm/CuOJCK6SMZF0qbRgZAP2pGbp0Vv/YwUSIZoOi22C86qiyuBtKKln7vzfa25SqLsYVzj0SfEaR1d/gUzsvezMo+p/LO2+ZopN7pPJrEBmnDvQ0wrbjhuHbcIPjcb01CWe39HDYaQL7HLVfRb4f1RM/ec7ueUuTlQzEJzCIcC11OfIraaNr22/NiR/GE7s7nWVbYx4GoQzrFlAOe6MrHDAFew+2pTyzejpoturr2jIu0KnenwpLd/BwHiJJgMBwVe6zMFZP3BEdg68jP4qCjko9y7Ja4Kq3LU9jHBXs5GDxW2riwAWfnpLyEKnbyP3/bW+/qFsjxr+u28xnyGHLb3axHk2OBsDPFYutbwhrniTNycVBIRX1TsFdOGuq8M/YL8OgXTMxbYNzYPteT6uNKFTt7gXQv4AvRzPuxW9o+UUh39YAqP4yahefuc8hGV5uwzssICC0Np51omzrRhRqRQlM92oZsdANg15pUGcTh3r6+/ojsWRdoDAss3sL14CguNXSf9yfpOAbhtugoiarum5p0Dsbym/FDnzU7m3ieeWyzScylvxtZdaGJE9DiKSWY3L2vJRsxlpc3uwkVyzlUjU9s6HzVWJ7R5UmaOEe0qJbAcyGRHMR
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88a9bec4-3ee5-420c-c885-08df28fbdbf2
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 07:30:30.4337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nqsDtVeCjb/86XbnOxPmtzerUz1Ys2ByR3QO6epUtVWrt0I0hzcLeDJuTVX+zb/Tw1zxOnJR70p4Oyd2ye0J/EIGdv5s8u/DgJMmb4v2rBg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR04MB9031

Now that all users of btrfs_zoned_meta_io_lock() and
btrfs_zoned_meta_io_unlock() are gone, also remove the functions.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 6d35e9f0dfd3..c17177a52c60 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -431,20 +431,6 @@ static inline bool btrfs_can_zone_reset(struct btrfs_device *device,
 	return true;
 }
 
-static inline void btrfs_zoned_meta_io_lock(struct btrfs_fs_info *fs_info)
-{
-	if (!btrfs_is_zoned(fs_info))
-		return;
-	mutex_lock(&fs_info->zoned_meta_io_lock);
-}
-
-static inline void btrfs_zoned_meta_io_unlock(struct btrfs_fs_info *fs_info)
-{
-	if (!btrfs_is_zoned(fs_info))
-		return;
-	mutex_unlock(&fs_info->zoned_meta_io_lock);
-}
-
 static inline void btrfs_clear_treelog_bg(struct btrfs_block_group *bg)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
-- 
2.55.0

