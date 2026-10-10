Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A10148595C
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 12:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791634038; cv=fail; b=Lls/t0HThNDmLQd3PM9iduh9mdgxb1AgreFuXsL++Ts84A9A1gfncxxbaYND8onS3KkhRakQGzznHonUsl53Nlv3yV7tszU6movMztaPgzcNbYve4rFR/9RRJC7WWm9l7QvGNJe7AS4WkISnkykQhvKr3zy+gH/t44MXdO7y98U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791634038; c=relaxed/simple;
	bh=fyxbfm8HKLEo3kRbhxudUYPPRV+hIlQKLle6Xulo3zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WSrQSA2S1Y+dVL4yhmXA/0i8skThifuNsIzTbcaeP5JBXLBikn6vWCCe7Mm9vptbQ2kD47x0VZW3u+OTZFWWuUjHFqu7ARnEPgSihuEOGgTQ9waryxyjcdkNVU5HgxQDwsUe6Asalw6mt3HRtgylycjSffOjHJDn/NGQXwZ7R8k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ZdvThgPz; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=woKomThI; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ZdvThgPz";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="woKomThI"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791634037; x=1823170037;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=fyxbfm8HKLEo3kRbhxudUYPPRV+hIlQKLle6Xulo3zw=;
  b=ZdvThgPzPnO4qW9CnfqSmWOpqbEz4bVcjOLa1AXAEd5dmwBtbcPlutP5
   fNwYAS2E4YgEJq0DtTQ1FhLV7iqzdfdu89SfOvjRoGkqeU23Tp0awhrCr
   svgL6R9NA6dTQppQRuMu9Gm2TYCdD9Gu4VfcVLqWj1FHtO4zMFpYHZ81/
   AFjah/J1CWWKpsY00ZNH5vaLjIQfeJwpp05NFpUvz19sTpczkeui+zZzz
   dgMR3slQZikGF2NCZzLFb9U96rVw6FIfc6zSCqszzzIV4tOxaYPMWpjBj
   Wo+cgcYiI7/N9XQTj6e0Rme0ZDLhmVKuQsqPpTvnrBrG7bFI9PCiUMQ33
   w==;
X-CSE-ConnectionGUID: P8D88hGRRfWo0RFZYPB/JA==
X-CSE-MsgGUID: 1sv7VXJWQISoRHIbe6P5NA==
X-IronPort-AV: E=Sophos;i="6.27,150,1786982400"; 
   d="scan'208";a="157785445"
Received: from mail-eastus2azon11011013.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.13])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Oct 2026 20:07:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wbSsqMjl7X9V+M+gqiIIYhwJDOYXz1oZ8O+WcUFqiTmDp2DC8g6/toOYouK4hS1KDaexqVGw3IywDc1ueU1ueVCAgH/q8c/ZJC9Cb3RROzamvNkcpLsgWaigZmVoDa5+MmJC4AIfOH9kgVhYGsiplQeo+ffLEnxy2A5jImpJfukKe+4dVj8pNYeyU2aeykUQrcd3/xCS2cMVl/yH/SqoN19Mc2mmjJoFfvr8+nP0cQHAKFYNnCcPxl7/Rvq5JCgc9YZgvVEFiXJPnhzYpq1bZeJxUay0Bjb1E5ofuyhkwitLa4upuZh2iXc5ZHDIzWM37eNuzOY4gLdIqRZuQ7mIHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xBwhkFb5X7QNFtPV+jPFcGO2BrFNWuYLylGzSi0kDPg=;
 b=ATldDOHog3TvhiOUhkiVTOvTG/6Ndwgp4RwxeToxLyy0rgM5/NZ/yRgRXK8/3l45u3d2SRqk3s4rUQLT96pXTRWQGdxXsBOulDWPSVcwGfdSzLlTi2JpXlf17Ul2nkZ9Mz3OjaQgfX8dvsDCRe66jF+6TCNwnKmH701yQSRmudobsbYsjM3bs1k/SalI8jcv9MXQNQl5IHE498NjJL73nPp4dak0iN67n9PE1Js674GkQRThMA6ywuTK2rtwTiTcmxAa/bZyJVe65xXs6TzzH16KnXuauxGF9GsjdsDcPPjFcljltEJVrratDMVdfMb9B3V6ZK6mi0c3ha2/UcjeGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xBwhkFb5X7QNFtPV+jPFcGO2BrFNWuYLylGzSi0kDPg=;
 b=woKomThIfpKOy4M6vAKV15P4ItDN6XnzUxw4p8sWJ0HbyS4IhhBKccS50nLw/TAwbasPY/6KFNRJ45Ljij7Td/pSDkOzCFzoWDdtPcBWIdKPo93Hml51vWopynD5jYXq8/VvMs2LrLH25iRXpBKgZkSfs2xFTAnFDhzY9pWAyyM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7886.namprd04.prod.outlook.com (2603:10b6:a03:300::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.19; Sat, 10 Oct
 2026 12:07:14 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.015; Sat, 10 Oct 2026
 12:07:14 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 06/12] btrfs: zoned: only take the metadata IO lock for append only block groups
Date: Sat, 10 Oct 2026 14:06:16 +0200
Message-ID: <20261010120622.3781326-7-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261010120622.3781326-1-johannes.thumshirn@wdc.com>
References: <20261010120622.3781326-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::14) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7886:EE_
X-MS-Office365-Filtering-Correlation-Id: 27153a7d-a820-476a-1e6a-08df26c70551
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|23010399003|19092799006|56012099006|11063799006|261009223027099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	7ipniwD7BXGRZxjbhKDhrStETxQwcTW4X6w4kjJAjovnqBQZogAfGEE0/7o48JQeXZxYk1wI0zy0VXS3El0jjDUMbk3XX3wzo5NcSbfVBmJwHRqpWsarsnq3TcQJea17Rgut4QqiBWV4y0+5QQt9YwCjLTSrfrBFli0waH8Q/8+7lJvMwFEl7PENsrdZ/UyZ5LM7dLsWkg3+KO6g0QqJ5n+AAo5SjVjjL6LYP+LYzXg4rInfizqBz7pFE4T3hg9+G7fB0Ms89Gci8MpnYzxJmdZJnBdhXqsw6bFnhe3mVJyv+5Pn+Cp8TLaIJpcAXKCifI3GnYm5EFrmWwB4G1lwo7Tlgt+0g5RyeWDjurQsiPs+1lshKqfWh9J3JDs+8GJ4N/tO84Y9I11AIrrINgt+4izNaVekXhXSsyPVxCoyXHJ7gScH1VVRy2ooGeA4j5zvLST5v8wiN0Bw/0GqysLfWcnaK4p+WYkVpSO+LUXTcoX1W1BW6fcomaRwX5dVM6HIlVoFk2WFEp7EpRjerR8DeY65sB5bene3P8QHnf7rkEgVCacV3vvFAUKbFVYzHRg+GuQlSn/HUdeOa6cBAMo5tZN5NtDz8Znb4O6mGIOlUmSeMfvl//00278e4brunJo62d1I0Lwg8TDNm+XPad2GIsKlEsx/3iJU/MWMMw3R1Ms=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(23010399003)(19092799006)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5x4utgpUeKqbaqo+s2WIMf1NNyx5wzpf0w91nMpnFQkczrjIK9xzVs0z52gY?=
 =?us-ascii?Q?VsrzrCkEzV2EJomOp9CO6bqopk43kWBIkDZMm98022oLuBD7YR07Eq2e1U0n?=
 =?us-ascii?Q?LRDhBMI44i9ix6GI4ixfAbYwAZgi6PxRBYwjM9kgj22Ikeu23XtUqh2Sq7Ju?=
 =?us-ascii?Q?2P8a95BQFpPmYqYLXssueuFwVwYV4BxaoF6yylpRSYBVmPMpBV0wzaccPU4N?=
 =?us-ascii?Q?v74t50051ldiKTM9hUzrBiO0+EirHd65BSwsBsr2BqUlTh38csFfa3aCLBnl?=
 =?us-ascii?Q?xhAW5xXK95tnu47iuctSUmyc/CQwRP6c/RWFs1ry4y4qi1akfPt4S6M97uoL?=
 =?us-ascii?Q?kRl3lUpSY6UuQy6iDTNRfy5r6Ss3mcy83QRmVZhC367Iq8NX3Yu1rqyFUTTj?=
 =?us-ascii?Q?kcjlhtMAlK+X2p8C+wRQG5gAcP/uNCzAIdGXuTzoYAustEDEekngfkVU4xF2?=
 =?us-ascii?Q?ZvPpZYBVAjpmQgpy8Bjzv/2krPZBvrDMwXTqzhY4CS9AwpkbZTfMEM5DXLGe?=
 =?us-ascii?Q?L4IuZalIv7mrzBkjoSHNnk2mWKz/qMy0Y338yVWegFotMZROzO3wNXqeS8VV?=
 =?us-ascii?Q?OkuQ+lpOZXj7Kqg9mFNv7eWiuWCRQGMEGtpYpo5ZnVbrKJaUi4ofalOsitCt?=
 =?us-ascii?Q?q/Y2zdSeHMko8VsRYKH+bIGIFsy+TL2aVcaQOg7F4FqZ2RgtJgofaL91Q8Qi?=
 =?us-ascii?Q?8zGFT1Omz4Kvn9MpXZaOTp10REE8AcyUIuQavYePBpmc8Fd7sFUio/FjmrCZ?=
 =?us-ascii?Q?kGi+o2N553tYDjimFXHbuF+zh/t6xySOWu/0z9CCR4N7zs7SZ3HJEuu24lqy?=
 =?us-ascii?Q?3VMcQtGi7LjSaUwst57HAwnpP3r4dE8ru/4TAOnJFe/+inQVMmROoYAjiCnF?=
 =?us-ascii?Q?Kgq6KQi0oCnSMoYvbmoIegcCcz7/91/EX1uwHyl6spS/c/BoF1N2nYJt8MBr?=
 =?us-ascii?Q?xfJNjp3p3G/nDRRNR9hEM46840HFkj1Z+V4Q6M3kwoT799h3Wxkf1chlSfgS?=
 =?us-ascii?Q?X/vNLfU8mPYbmE3dPvHwsfufkk7C7zS9Ww5kEmsYsthp9WYLuJQxDRvyXwTy?=
 =?us-ascii?Q?odz0xFPhmY9vq+kX9+SEfSEKVePFL/gsWMuSRtrgwKW7kgbMpJorXbABlJYP?=
 =?us-ascii?Q?cFCPUL2udJ3viqtOu5p4aTuK44cX+MF0Z60vCwHSOu5+UunQMbvrZcdxgQRM?=
 =?us-ascii?Q?5yiVHBK6yfGGxsTH6xTb84BS9+3xh9/b9+3Jdt4gfjAmpttlzkzlcX1HzcDv?=
 =?us-ascii?Q?XCKGkqSMDxycYSCiHngRyvDGDrIH63chGf447O0zh+PKzLUS7VkCI1URvbcs?=
 =?us-ascii?Q?a7URgOtLzlVuT9Egc1y8GRuSDfX/e6aTVX6Zu24K80x3PQofL9QEUs9RSqKm?=
 =?us-ascii?Q?bjeL4eMxKj63ix6QycHd3dPd+0eDHafVAXuscvVzERtScUU1geQXyA+AQ9w1?=
 =?us-ascii?Q?pJpu/NwLIH23HhG5Y3GaoxTfIbaFetK6OYIkuHsyPs9WlmXkMCF3GRs7dfFZ?=
 =?us-ascii?Q?WL/bMNOABL4GG9O95QN7YEDU7uoN+k1sEHKh3o9pZUWY2Xib08QKYKp3gqIb?=
 =?us-ascii?Q?2Zq8hq2m8dXQZFegp4R4RRXiregEz7DDthzGlsTnSFCFASm0423/HIadMQOU?=
 =?us-ascii?Q?Y1PVdCKlCXGRzMg1NhLymfER7yldR8bUgnheiXO9c/wDLyRFvSVSU5LfbAaz?=
 =?us-ascii?Q?kMAiI86aVj16WNzhqq3+Ift4oY+d5DhSdw3tkBRrIYUNwKy6Lts8UCSqldy/?=
 =?us-ascii?Q?f28xgHnz7u7wjpKFtV1oFxsWBCl7vVzjFKm5A/yNcWeCRvKHUIc+jwC8ktOk?=
X-MS-Exchange-AntiSpam-MessageData-1: 9yjJuAKa2PnP4gDt0cHh9EAk+ZY26k/5C5A=
X-Exchange-RoutingPolicyChecked:
	vT9bWdEH7wDUWN3TgiE2DBVMFKywMLQ0Yu2DX/YOkOFk6VU+g/3nE5pisG9WTZqMbv4l0D7gtl02XmAzNDHgJON0yX8zYZw+Y/TiceSIJAGqYTaZ6ghmCd1cIqaNykx10XgxAGxh4rxdZJ6kduGsjn4tEOSlsa6p33ehhhChdV7K0dYQbzy6bU9QLavZKBqa++xDlpIDwoljrcdUWsv0itcGyNcTEBFmkAAErB6Z5BTuvx0fE6hkSkncma+bPxgEtajfufo1QaYd7ZrW3qrqQgqFrHYir1E0Vhqax9pDMoUuSstIl7cNABFAroq04u2kcxquTlnShlv/htfEGiEupg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OV3mQXaJDUoIpRnbbSA9s/Ud/f8Bi5I8iGvhm+hx9w+rJ7rcQj4O3PKgqu8sMh1jNOuwEQNbaW5gkpp3JUkZWN9jTpwH6qKh4gGhUm6CpxAmBzAFrXlwCo1/v9HAjE4bmDWeUnRblSPH11x4lOiPFj7swT4UKbuRl2DRj1KfPGCyv5OAryLe3P4j0l6DqznNkpkdLw55BicBO2Axlmq2PSMtpdiDuwXuvR+mi9Qi2FMq8Rc0BKRjc7ZD7Ytjn+h2ThJH5WQLsvT+6L+g6rJQDRw5U/lCWfa+5lTEQPxUK5d7FLQresXjmbeVlQOxj7lOjhv4P2EwGzZh8iKpfDHjjLjllWRr/BN3/sX1bJX/rSKBJV6ILoJ6jame//HTIANB9tNj8XhmwyZMaTNJVOVisUWY/4cAgEaJ8l28Pj/9hXZVJ38IyZbvqyZmbjkP5qUfVvHvcHA7sctCwCivmHkE+tED/73/BcNrBwZnN7qrgDsk8mSLniZ+9zWkovCxESsSggjqtn6lre83Z3hqNjPQCndKvMH1GZMyHjhFRjfSSHTNUE9hJWJbPOo/aQp5TQNe1PRbqZsWMv+NkaBDPBU149viD/eUwBAN0e7B3woaKMYq/jhEtuLf+GXxfNs3pYf8
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27153a7d-a820-476a-1e6a-08df26c70551
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 12:07:14.0791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KUPkwn48MpK7RqB2FF802yG2daZNSSypvl5/li1WibXVtmpEqyvBIPASm5LJ9lQ+HKwBR6O4vYQcumJHP49/OP943RGeBSjAY/acgB+EPRQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7886

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
index 5f2b690a41af..e0e7171fde3d 100644
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
index bd1ffbb62805..ae7f04699765 100644
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

