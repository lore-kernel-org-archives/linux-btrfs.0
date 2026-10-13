Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5BD22B8DF
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 07:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791876631; cv=fail; b=nYMp59MwrrZNZycoW7pRAWyDIo5tnMi10sqXnFIvy/KcQsd0pOxxHNz/IXPDc4bZzV8ObswcZrQDzqnxJ7X6iss3gLbAyhYNPU5VQM9OSX3Hd5/pAFYIyqXvMlwmu7FBZraKc0PnUWksHDbC+xtOBrFGK5GiEpdLtbm7PfnJ1Ek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791876631; c=relaxed/simple;
	bh=5Fdr9BZ1blCchtK6scBLtn693NEYZqcCD81KAHUCqzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uGYlb6ack2LcSl/DzhXAlcCNzLKrnQrVHkNOjQxupn8oK2EsTml/iqV1pbQT9em1W6HrHmjTeSKTBmpNyGab2ekV5pRcpqNjQmjQ9vdFfc2MQDJbVbajwOKABBPZ7p0cIJhqvRrlhx63stDMOSDeqHsvS6h7eaPybT+EngsrEt4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Rx1I/yzr; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Nc8bgmzY; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Rx1I/yzr";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Nc8bgmzY"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791876635; x=1823412635;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=5Fdr9BZ1blCchtK6scBLtn693NEYZqcCD81KAHUCqzI=;
  b=Rx1I/yzrkbqGBtIcJ87UrzjgMUnZHIe4k6S2fRBiJmkCFHd5bHh1lIc/
   4TaLPW9sRzbJBTGl//Vl7Gf1BznD7B8UVwIa8Ji9ADlF0Wuxg3dllKhZI
   HLviehImxz8DWlj7xGrXDt7VsmKhdcjDTKI/tv7/gG6dVwHtH+1ljJRIX
   a0LjTz41H51EONYxan1i3tjXpdiTvGPYJi1FoO4J0ouf/SYcpLf9UhLbr
   RS7EwZEh2ZlBmfDtb/zfrcewKujkwDacFN8uwK0UaY7xEvsvZHelE5K+k
   dkNcgFKwonyth1DYfGIPJCY9CiNDr0x6f2mw3WTxwG+1ndUcw9O2IFSbW
   A==;
X-CSE-ConnectionGUID: Bn6N5QU0TP+j5mrCKDtaQg==
X-CSE-MsgGUID: Mqs9hOarRAyyXS6gRH5t0A==
X-IronPort-AV: E=Sophos;i="6.27,155,1786982400"; 
   d="scan'208";a="158917179"
Received: from mail-westcentralusazon11013004.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.4])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Oct 2026 15:30:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mqPXb8am8MTWR+UITDy8G/LZjOWvwQSG9GbiRTOgcpzHmqLDRSf4XjLSMC5pQc7BKM0gPHfoWF7jFeW7/rJ6wNIMN7SrvBjlezyL//x0HfcwEUJkzSTfWZQs/Pi3tK8dw6Bva58i0GkSlyLFESAAQ+siI17usPWFRu945uLgye58UKC3ioY4BCTq+08h+sBr5B2VJQstKqlKdQo6wB9qQJhsnPn4xR8VGAFwndOpOXAQg7X1c9wxQJP4dEY/M3MRmKf1nNSgaeKnzGLMTOrT/4VpakwzSpxY8GOMudacPuNRe/CKBNc6+wypSbaQPHcAv4j7bbJU3TfPYJCT7Fp11w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UeHOL4Y/3183IRe7os+dLcRpyHHmfMdJ6K4/EDt95m0=;
 b=eQXecry6wT0qP7YCksWWMt1GZ1oP+i4vCGw2QP38opN8ysdqP4+9CKRoJAcDcEUrDsQF2uuGlnoPMmbX47zzBOotEAbhtcR0Kx3LAS8X4QDDdxVyJ8feXIJxZoyKJyxQNT3n8gEjAogCjlp558WYQpW7bgJxO6L5H+pEZXWe/YnSqL6TtKVDpzzfvXmEn61Vfj5TEXh3N1LZJxaWv3qQHg7u9Zyrfse9Ay0bvA+kBfH9/01Cq7LJnyHYYKwt8ocMjDAgl5Kk0XpocyOmx7uni9iDvYXv4jNtv8J+Hq2b3xz3O2sCbtt4H+r6m+1vvhMMTU+dUIh8ynwSq+QIFswMdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UeHOL4Y/3183IRe7os+dLcRpyHHmfMdJ6K4/EDt95m0=;
 b=Nc8bgmzYDUhfGT1dFs2eVyh7oy2N8PcYtVEvj3ByrmlV3VEATI3Vi9IdIxhrttaCocdY0nYF9Cdp4RQ+3q/fs6rT6NmU8XdXJkT8rfklYhp7F8+dy/5V0FRiBPMMHU1+J8JSg1rv33pWyjOUMVsrmajJ1wzfzSx9+bCb1syr+2Y=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CYYPR04MB9031.namprd04.prod.outlook.com (2603:10b6:930:bc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 07:30:23 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 07:30:23 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 06/12] btrfs: zoned: only take the metadata IO lock for append only block groups
Date: Tue, 13 Oct 2026 09:29:35 +0200
Message-ID: <20261013072941.424029-7-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: eef6bad5-30ce-4003-0d1c-08df28fbd7ab
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|366016|23010399003|1800799024|376014|19092799006|56012099006|11063799006|261009223027099003|18002099003|22082099003|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
 73x9+woQIfPIhr8EY5miNPEEDtaqCEkEHigkzs/HlVPaQu3QNF0p0QMB+RG48ZEs2OpTCjFQnFfsL77YU5h75igy7mX2pGvzcOyeJvjkX0p41l9mH0PEQBL57gpvwQRwmcK9Peh9lUlO/nT/9DvkX6clJ41mdiMKVSkNrdZTLDYiYCPBUjpHll+lMULIE6Sxv15pt7jy28TMxmiqrdmyySBx0GHkoi66b7/uZt315r9Eg8fd9OBvyqrwdZDzhW2KJxoZRoPIlazeBmOZjRaPiFaXZbtA9nGx/BLRRjeh7mJk3YHJ/MoE8UoRc9ngGDX6YV82m6boRJHcD6fBr32rKiMK+yJZ5K9mwCBBt/oBecHgQo95psivwDK+sIB0l27EK/N0bl34XGg03Dj01F2aPxih8nWg1osjlqrzAlmTwsLdBdzhH1k0hYX/AjCEwYZwVvFnzLITcekNFGkUvRqrpbhuQOeDs77aAyPmamLBdxAlWmk6EvxyrDcS3AeSzKtCC/65MibuYbKCIo7qiIR31sY9jpolPvYoXLwpkPvQ+9WyKqFpGTctaOBUCXTdj0M+YCObwh2qQliu6Ke3dLhQE1Hmpm4LWn5DJzesH3IdkXJjDZCEBkDQa/jj6wClxwAWaAFALQtdPgWXyHSAyEJ01DXHCQOfF+siSUqDvWJqnjI=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(1800799024)(376014)(19092799006)(56012099006)(11063799006)(261009223027099003)(18002099003)(22082099003)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?fqgY4+WnuZU1o5L+9GZEKGl4ycbdbTZ2+QcuZ2DF0aQbua7B/kwwp4V863BT?=
 =?us-ascii?Q?um6YPVI+xnNpjx+dQT1MLaUJjyixEpeNizjsjmMw3u61glU4ufMPcyd5/bUZ?=
 =?us-ascii?Q?4gjq8aK7/qy1QjQuN2z7W7FgImmYVBR9+0r4AviScjmtI/B7qvXaXN2evcFC?=
 =?us-ascii?Q?uua8dxTRJfXfkv7JkIqghyl0cDML5GYY5c6pUjhcyBR3vko4yfsAvRETyY/X?=
 =?us-ascii?Q?0dn/nTWzn9EmKfW4jsdsyQeNxAJ2KQE+VxgRMXeQqhhhPfXP2N1qjDEgaoRK?=
 =?us-ascii?Q?ZNe1LYR2Urio2nIFErkSbN3HchRyzv3pkNE1qYcn6naUUSvUm8le232hxl5h?=
 =?us-ascii?Q?ZTEuq/K/x7FfN58I7SXS1lVlW/qbcwE9t8CbF4PagKgCV6f+zbpI8dzRsPIB?=
 =?us-ascii?Q?vgEwk/J64MYM9KMSZ5rJFGRHqevIbnYERu+uv+3JX1iaHsQ6cP8Wf5er1hTO?=
 =?us-ascii?Q?nRZm6hGIAalerJ5DXnI9MxZ9eaCKItHcdDd+0vQRsl0P+JG159xFhBG3jZky?=
 =?us-ascii?Q?DHCVo6Sv6yeSZSMoX/tbPFzWzyc7OqqthupxawmmDRyRelJy4eky30iujIrG?=
 =?us-ascii?Q?2SXMNYrgzKXr3Xg9/iXG3+nRBb8I3o4hYt3hyqpHH86DVAOJg3lJUV1XaLU5?=
 =?us-ascii?Q?3hymuh/OGdMy6pTUIF4xU0IFCe2FJqUfQ0x7I/9qM3Nz6cw0Q9VtZ2jjOxD9?=
 =?us-ascii?Q?fT2q/UjMhPA4TLTEzyGfRCW5cMwjUiCHMITR5N35kR0NAkuANYoPO0NJb3Xw?=
 =?us-ascii?Q?b9B7pLDkACpeFIA8UDNqvyPrsj6QUOGHRiuWXXUEAyIIA7jTJZ0zgZjFzKzX?=
 =?us-ascii?Q?cK/8CuMoY6kuUtnST1KvEzebxBD1oXbpgj6yjVCHYEh+9V9qvjQ+I6VPDS3n?=
 =?us-ascii?Q?abRiaaqk7XoZvDmU2O7m8vJd1QDgFBF888rKUlCYl1dM1rqa1bSj99t50nTQ?=
 =?us-ascii?Q?4/w/awCoqJzatB3R1iCOk8qP98tSZc4yBgSidmATsAhS8Hk3jKlpwxhfyvr4?=
 =?us-ascii?Q?+1S6lnHZYveSy6bzVHqmqvb/65Ih/YBBsvZJemhzUxgipp9RMuP5GCUN7zsO?=
 =?us-ascii?Q?Xp95aC0koXDqtPZUg0qKfBY4NygTf0vWIyc181oa7gpSSDI2onsyoQo22Ve0?=
 =?us-ascii?Q?eS3ZamPKsVwS6rvAvDinrWfYCNylRgTOmUMZ9F1mW/YeYVhgP7LjmJnrJ4BL?=
 =?us-ascii?Q?tcrk4KY6jc1za0pA2Euc1Kmr8VnE4Fcs3zu/kJx+P3SeGmoD5MCwfvCL8Z+k?=
 =?us-ascii?Q?AXUI7Ab0LDCJ0M+ZCQUaiuENCZGYExa++cb1zH2arxMakj3N/fjJDUusEoMa?=
 =?us-ascii?Q?XA+latPkSk6VlFhLdIwnnv97QoQBYuSFFOqfhvLvuXrXdiDx7cIXgly23BQG?=
 =?us-ascii?Q?ynnVXY9s0z45M5ANduD8kutcYwJcCoQgIiJGYo3Vcz09R5M6oGr0dT52SIgv?=
 =?us-ascii?Q?InkpKWHjNQnr1KtI7AuingTCUajvuUV9wj8LfNAFNobzAOQZGiiiiqp+4l29?=
 =?us-ascii?Q?f73oYon7blZQ3W7ahAxsM9yaAnd4HmCBlKo/a4r85KLICXNeGvIUJUmtIdoo?=
 =?us-ascii?Q?pnx0ky9VZBdyEHxeal9G5PsKSHytKOhlSLnfSDbwQGhaBBXhvCebOgr5deIF?=
 =?us-ascii?Q?6W/aYyLBxoQN+qGPTg8qcgSk/Bw1474zhzS24m5t9qTdrDsRetRmyBn9F8LX?=
 =?us-ascii?Q?pDhT1tZbzrBxAzkAcOAJWFnAyH7WVRCIEaBoeHAlPYjY+aNfdpi7ABONNMhc?=
 =?us-ascii?Q?jh/R4+Du2H8b0J4aejnDjY7g4+qzeKIBh2AbNDyF4BQAVESOc4M3Yxbjc7Rd?=
X-MS-Exchange-AntiSpam-MessageData-1: nbI7ThWAdnUdw0+YLcfeIVBvnAZwTJNOdys=
X-Exchange-RoutingPolicyChecked:
	oN0FUb/BmMqH/S5DUXFLSEtVc7b+EgLuM9jE/cIbePFAA8PnWZsMaW1rWLB45iNNu9ID5ECud1u8LCGtmR8j8tnnNgGI5HgiNFWD+VcMKkAoQhwDoy9OYTeUpLDcBc7EXnQJd93zQwDe8qUwa2P7GnLIj63iqg+vNc3oiorFCwFHAIOl9+u6l+E4isWAW3zGEwjQwgNITfoBmW8i41YaXudhOKj246IpoU96FqcRlcgLQmMspU5U4xkWdXDb8Ah6LUQUEpBazGYBI2c1yMEBPKCdEUZ+VBKfU5WzKrinf3dJtDL4SjzQ9VIvAK3Ct64gBSCOayzVH1XybEdJSRl2CA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RU8xX9Lx7Dg93TacP3n6wF/9iAvdcN/IusjEsf18GQVn2aKsiCxjqCTgHl6U/uv4MModxQE8zGJOwDRMa9rpr/3PUfMlicSbM/VpnX8gFS9aOlBwNZDD9XOMjMCvhTGZHXxDVGwE+nMIQMPvGFNluC6a9F3AVgroUd/CSIoBZRr22/dYeKv8UZN9kRfryWIkxdoT6lU6RgjNK0ihjM+iRzfkqp9IqM0yp3sitJ5ZdwmPO3fNv9LtEaIHBbthLwutjwUXWGakQJivXmfGoLQiCFdO1hHS9MRNrF0bHlkyNOrtXq0BHhFSWXIQlrWKFF5CK9UJs59RP5a6D3mZAS51LxgU4vQY/4Ri+PJ/IcQGQ0vSaOfXuWKNWfiptyx+qb40XW9dNw5aGxWrk1QWWfSjulX43RFlcR0KcQHRh70MIBRlmuKb47Q0ebXIbGOc3PKvab8FmpGAqk3tzOzxXRdCEsVaSF3JRGxJufjXpfWDcZKI9eQEHJszVZJRQoVpZbqZOI7mQaKXFOx2InMCOQ3tGvSKKeVQNq0ruYv0RKCgFf/OPslOl7PwHA7KehOGPwamm4luLSSF2Tz5BHxlL4fXVR1ui2p8opivkn6py4eNRHVXQvNsA1Qe3qZQefUnFeFu
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eef6bad5-30ce-4003-0d1c-08df28fbd7ab
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 07:30:23.0847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zlhL6Bn1/mYUzSPDx4S3Z/HAuPjg5dvUMPxmuwk+05bY8HSKhqA5OZ8VZI4u8MB9ZnSzut+dtgX7Sw+AJ1+vlDEGF0hqae/moBk4NksHHCY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR04MB9031

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
index bd745b913d15..9e3166a4c66e 100644
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
index da6d97d96c2d..dd6b0c68b376 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2274,22 +2274,17 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
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
@@ -2303,13 +2298,34 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
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
index c5116db8cb0f..c9e9b221681e 100644
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
2.55.0

