Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7068647011D
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 11:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784719850; cv=fail; b=e+e3vgw3+vdlNMP/wd7yto1ncVcja6xIzqG0Sz9r6UoRAS5N/LJ4YyiBMOZKt2XhhMMoB4mZZlQaBV9gPsBzlq7GzSlHoIhc+w9xx8hVjE9XY/G7D4690mDzmSSFIbj9QGU8ozdiRkPKUDji3GWXAgO0YuDlVX4RYzDaZ/IUlqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784719850; c=relaxed/simple;
	bh=0WUW8nowTj9/zaJQoNXhdtDeYq2lLyEHXzgRD/X8PVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EFhDN+49GQGN9HpkzOURUny17RjC90iLEY7VfuMh9792Ov7XRfiPuxTFrU90OcZ2btSEZpJdqU7yxmymRJAP/9gaNXHC67xh/T6wxLzPuP6tNd68Ik2kwGF+5KbsMUGbr4Xl6OoGn2vsBKGh7JOCxE0i8mC97+J7dVa1zhBnxHg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Uj7SJYW1; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=lG/Z7H0C; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Uj7SJYW1";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="lG/Z7H0C"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784719846; x=1816255846;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=0WUW8nowTj9/zaJQoNXhdtDeYq2lLyEHXzgRD/X8PVg=;
  b=Uj7SJYW1N8cKoAfE5j/ReqUynDml2DRgsu69CqRCZisKXAC2grEmbuuN
   lJLOP277gGVOmd0fi7NyGmYuSLtBPSj/71uf/wMGMtfB5HTtJ+lB0eYP0
   s63eZO2vod+gVWfl7bG1DDM1Ho2Xm5uL70zZn34M1Hq9hJvcgMogIlC9r
   GfChFo3r0RdBVo+XG/Xd7rT8Uri2+aLNr7i/43tY0lrCU50GC6sSM9NFC
   FxFcvnx7UQjfEcd2ej8zL+3MO7uC2xSfJO4+M7kdKuTJfMnDMp0egmP59
   hNsEGUIv2Vr5CDGhsA65p51DArqOHyVCTDbcOL2ePwsyzLyqN3mvYGfRs
   Q==;
X-CSE-ConnectionGUID: RBh7OQBGT1SCj7CoVm7zQw==
X-CSE-MsgGUID: cduEw1rpQ+eGtAXrPhZp6g==
X-IronPort-AV: E=Sophos;i="6.25,178,1779120000"; 
   d="scan'208";a="151556165"
Received: from mail-westus3azon11012006.outbound.protection.outlook.com (HELO PH8PR06CU001.outbound.protection.outlook.com) ([40.107.209.6])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jul 2026 19:30:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nRnK/R7acweUwDBVECBKmAYSidE2hw2mmPKtawEye+ocfowf0Ky0Zr0rbDL6QbXIf16JLk8JPVQLZlDLiVohmSzWAlngppz03WQj+6NRWif0V1TBUTyJ6aR1p52ZQ/TQMUo1ybiZ9WaSAc64k1EHerDwBYMf7GaTjpGluCvtYtiR8jKNcIouXbO4QhiZce0SlDVSKRDHvga7YaK31F2P5CR9aydPzQACNG8MNqU9g0Af9j9geHnTsJHXi8mBHwRxvAurdBegP8nHRy5miod8VJABizvW2CvEyi1cLsqIMFVwsywbLhBNeUvMXtOx06FGGuCALcVG3Un24pqP/sE/uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GMbcgbu7YBy+eiUnbj7nLBxm9nuwCQ4Wx5+oV2ylDTw=;
 b=ODiSn5C2joJCTYMvwTzOxZ8i9PUwYJgDmMOckbak6cEBgWvSCXpbwEL1b3O8jo1BZges2IRJ9fezfeyY4ZeQgEVGTQcVUWG7UYYAX4qO/W/JBJlWKVHtjoQC7jKN2mqSe7g+Kcca4teDk+Gbc3W7U06y0F/8BoPCgvlnFFXPLIkBs4SO312MDWK7fW2xcXxdWly4L+uzkHWv7QB8yspsQg9g4RwWiP0jh6oxBtxWJreBsSzvWqEKTyrjj4KHiTfib1udIbQqNSdJS9mlFZWjpUauQPS6Jbs9EodOxL7bIUXzKvU3QyMwJn9db5d11clkDMEIlrhzyLsum/+raTpUcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GMbcgbu7YBy+eiUnbj7nLBxm9nuwCQ4Wx5+oV2ylDTw=;
 b=lG/Z7H0CQROVcdjCkuJ/OQZrbotvXnE9fAP+2L1Z/BgBtKqt3i1EQC11wwF9r5Pj76eR9yiV3s8hFa+AKUqWkxTiNNX9RENAhReJ81kIinfvTvpZhVtMSmcPhVD2QncQcY7wYhdNdPdiuBdNA+ZniGK26IuNqgeMMf3OoW3AHjg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM6PR04MB6810.namprd04.prod.outlook.com (2603:10b6:5:245::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 11:30:34 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 11:30:34 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 2/4] btrfs: zoned: drop stranded dirty metadata on transaction abort
Date: Wed, 22 Jul 2026 13:30:14 +0200
Message-ID: <20260722113016.1896990-3-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260722113016.1896990-1-johannes.thumshirn@wdc.com>
References: <20260722113016.1896990-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0008.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::18) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM6PR04MB6810:EE_
X-MS-Office365-Filtering-Correlation-Id: 726bd1ab-4e62-4a18-15a5-08dee7e4a53e
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|19092799006|376014|11063799006|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 c4nlrdygrEFCPgGSCFZsQ0tsVx2Iicz9S7ZOeeMXMR1GlqaWAskPq1hmaRlLN+ZgYqdv3YYvo/2gvGI4Gk8iN3j+CxbTlndcjg1zG0ZpWgJTWh/+Ys7IR4tPFnGtcFuonvliF7r0KE0ADc6dP4KD02mAn23Knls/IDsLh/r/bIIa3aIwZEdeYeFyTTuui2z39XWZwOQCWwUJCh3VrtUAbC4xEQDsXDUqoRPk6InHaOzQ/mJKZc1i4+iCzrNge4sTBnnqhQ7SCLFoHgz/LewpsbDZC9Mi/MiwPLlVakjbPUqhROsfyb0kFkKIve1RHxtUVzxk8wsrhaZB4k3gCXnGt0TOqZqeNcGFwydzbfrD7jAefGV9lmdGgEhdg4p8+e+V/16W4XOTJJ7kGvnnHfcxagPJbe5q7eTs7fOXBfJNe6X2Fo0QC4oTQjnEljZXGVxYarvnlaoulRC+RWe/n3B1hECs6p9KV5zM/bocK07ygJv6ZBuG05DiqWMeSKXNPAI6Ou5AYu8F/3owFNOGB38VRV6vpDEfVr26ylc+G67l1MvpcmVfaiQ6mkWkEkL0zXLHSQYBRgDfw3O+TJ6yh5cB9MhmnAZl9pgnSqY7i+TtoLJNxpNFFpcgfZCjwCHaPbXDwF66LiipJqUVdDtpFLi2EBfM9ZDf4+svXNxYTpMsn2M=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(19092799006)(376014)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?IFU5cMpvHRPcg64p9d2ae4fSiuCehwTVnAd7pPuOW/KOQOfRsetDwqWZBiPH?=
 =?us-ascii?Q?0Pjo362E0rWBC1VVjcvB3wKH79i5OpPt44A3meieSjhNRojnIfvbn2e99y9x?=
 =?us-ascii?Q?xo1wMoISb+MFtfuSKgu78uNxqN34U3mizaqFrU0B5vIYUDbGNkS9lEbN0AfK?=
 =?us-ascii?Q?sluem+oWdjM0B9OoWrJ+GrUO8ZNtbEQmPbjqUKs0goMsFJYGRXb4fETqHsNx?=
 =?us-ascii?Q?A0ac/n+ioFNw/AckW9dt+c/AR/AR+dgi6eJgU44Y+zwfZ6HC4JmXg7DctRFF?=
 =?us-ascii?Q?FtzG1cq4Jgg1gQuKDny4VSJMiSUKHSBm+bkt385FsaTw8NHcWrV8b4JPzoXu?=
 =?us-ascii?Q?xS8Ndvjp1JhzyFWejzypuiayZBJu7rtkfaLduW3j1633aYGr50WHVlax5o3i?=
 =?us-ascii?Q?m8OfqtaHEWbLWwvOuEaElPwMKBKGA+IV2mAjCnRUDZ4+kPQFZazpRUANQpOP?=
 =?us-ascii?Q?lExCusTm1xBn7lb2zuhPYcdIcAIjhPb0Wl10+tAs/96By/fJFKhC/n7795D/?=
 =?us-ascii?Q?ij9BYXRZk013Jq6zbPL0ZsLkmjyOmXij1PvsWUIWxR2tKQYd8xvEz9d5iNNI?=
 =?us-ascii?Q?+N+2h2rRbB8BtQypB7+wtXM/D1VLd0CMwlD0Zk+m5JZVGCaK5t+1GPol/8Hp?=
 =?us-ascii?Q?hT8L3Llmh2VkpBwNcmMbLa/WzMqUFrhmSBGvYGSnSW3UtWJLnCmgByf+aQR5?=
 =?us-ascii?Q?fbG7fbpv4xStzS8xoHF9yfXjjtnnDWa/G2JJDEMSKW/u3H6/IhmbruWRWvQb?=
 =?us-ascii?Q?cYjYG5CoWSasfj67DvT6ohiG7Em8XmfPTHgk3YfTBku6qOTrHpJgJybVTV6H?=
 =?us-ascii?Q?mvFHwNdetbGok2nv6h9pguCp00NZCHGqz+ZdUeiVYkpedXEcufSxJmKt3OGf?=
 =?us-ascii?Q?MqGUghzAAPFUv28wc9yzEkJ2OZljrmz8O5FfZl9+TweE2ilblJt0sQR5ik0X?=
 =?us-ascii?Q?R1DlCcL1430TTlAYlgIcIURVg/v0fiSLrCF12KSdchIj9AuQwAV0QPsiQ+f8?=
 =?us-ascii?Q?M1QvhzyKMDCicc8upgJ/drhS/qbmUBNB5sA2yuaIzmvuKN/yjS12hrFtVkDS?=
 =?us-ascii?Q?AWItmcmDGjW1HKiW8CAem/9m/8jZ4ih50sXvd+LP3sSMmGToQd0cHh3kPvt1?=
 =?us-ascii?Q?gh5yM3EwfufnBOIFuS1LnkQ3cT5iH77Il+R003hNsOCYydV8o3GgMjdrK7FL?=
 =?us-ascii?Q?+fTV5sU6/CjyfwJmbavCvCYJ9SvB+TgL6e59PPcOf5zhluOBcRHCKvfS2YMF?=
 =?us-ascii?Q?OR+VSBIvBgixrF46U89pG6+YOn2r/e+BIUBVvcv4OeOwKv2FuyufN398S9hk?=
 =?us-ascii?Q?L3ajP9hOYVHpmAzeIBHilUJvhCSNFDVX4KWc01N6zMB/lEJADNYLM2WRl8sn?=
 =?us-ascii?Q?aDrsDMbDJHY+6N7sMDvNYYc7oWLCWtqR3iFz9fuK5IjAbuKmlwwhKJpTfyQF?=
 =?us-ascii?Q?Bj0Z+nUtEjiExsEtjgEr54acq1tytUWXFDFC/GirvKj+OyoBDYIRMGnjrtBL?=
 =?us-ascii?Q?PGZUavEHhs6w/NnQZ9Ai29zDW88y1JNHIE0XEkvaucd6UjNyPI95iFsezCt0?=
 =?us-ascii?Q?+nQGPCBVhTfCLJgOemDjPhG9GEHzfTbNNjiKUxMxGOJOk3+WigQcG6d/9Dsd?=
 =?us-ascii?Q?Ku0ohrK6bawpPkD5VjHiBrGzx9kLvmVsvMUutfEYjeXLke/kgBLjQKlSfkBn?=
 =?us-ascii?Q?XvFzcUCJcFqY9kwpX3NXoJQ6dlcTTWZe9nnStm/u5dkC+c/PtRrqjsOUnkwQ?=
 =?us-ascii?Q?wa1pp1lK/N9H4ji82L/RRuyJOhXAba59hofaxeP9XlpU6JeLIU91HsplpFnL?=
X-MS-Exchange-AntiSpam-MessageData-1: 31bwYRzs7PY4ug==
X-Exchange-RoutingPolicyChecked:
	aA47/IoVRHis5y36yo1omqtCsb3JQaUa05Zqcajs5Dy1iFEK3y+dcUgszSOR23axsC8yZAkDJWHf1znqoYUV2B6nsi7p7YSeEZ4kS/T8+C2xTIzyRoLo7ZMZSU6DGswtxwc/sFJCh1YcMlaRkdgBf78qOn+hYteo10TaehC2eWM6/hBjSZjH31WMDI2GhLZ2MSpW3jwzhImYWuMgfrxKBccWNctYvmC2YZVaCjmzZAfu2i8So19fkU6AXzo0wxRe9lQl3z1kzF+TiHf6Tk52KL15lzl82VZUOceB11g2vJGsj5YOolI504BMSxnDE0UvZ/DtQvLF2lM2bGArrtSUjQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+rLZYF9tALBpLBx0faDgT+7x1j7l9Hbz7UQBQI+kQSbeWeoBevh32mj4XevYuX9WfKPCScNFhsmTG9FszuvnmrTTvaPPX7Gb3JY7A7bZKU6HaXV+uykOWJFfGjFiHfD77OthqQwuKNkWeRs5xdBr+SNcDyUVUZqtZrvQ2tTl/uYJgPox/DjOo47o3RLKTOh7ilQz3fh2YJVUB9ghqqssvVxRI1ft4x6XR5Rjym9XJdWzL9rKHENcrfpoNPw4r3jVfgSi+lNxNG50oT9LqotLTmDTmac5y20QePyDtwMwtlP6vIIcLsR7tE9kDfYyn5SaiKOpcLKacjX+DwZqLKLiqZLUQTLlqrmp0yEcXUa3eh36CTDyoJx7oAdiFgBh634qPDmfmFHNavpxX6S5rpLk2KwP+GFnPHl8RS2mqqmL6uFH6hM+tO1Cc1pwRfr3HzFe+NMvA9dyyFhqrFo174svNarMh92iQLZKhcZpl8AzmO9dcKI1hzb+cmO2OyBfsd8FrfdImmC9oWpnONB70RdFCDhEodrVoSvDpTOojr8W6qwsf43c6UELDBFrlO6NXHn0Yf0HW9UIKrbh41bOVJf5iF9PvMyitiMHspQvzmhoIo9+8P5eIQKzLZuSfBdLXr4k
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 726bd1ab-4e62-4a18-15a5-08dee7e4a53e
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 11:30:34.4817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 80wkGBviu5gEmQ6J9D6/DSp+faFvG/GjaTFClRedgtmYFTPkzuj29ohNogRqpVE18g2lQeBHXHco5ZgymK53iz35BrDFD/f0x/9r8I8voKA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6810

On a zoned filesystem a freed tree block is not cleared but kept dirty and
flagged EXTENT_BUFFER_ZONED_ZEROOUT, so a later writeback zeroes it out and
advances the zone write pointer. A transaction abort turns the filesystem
read-only before that writeback runs, so these buffers stay dirty and stranded
ahead of the write pointer where btree_writepages() can no longer write them.
They survive to the final iput() of the btree inode at unmount, which submits
the write after the endio workqueues are gone, hanging unmount in
folio_wait_writeback().

Clear the dirty state of such buffers when cleaning up the aborted transaction,
where the buffer tree still references all of them.

Fixes: aa6313e6ff2b ("btrfs: zoned: don't clear dirty flag of extent buffer")
Assisted-by: LLM (debugging, commit message)
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/disk-io.c   |  1 +
 fs/btrfs/extent_io.c | 73 ++++++++++++++++++++++++++++++++++----------
 fs/btrfs/extent_io.h |  1 +
 3 files changed, 59 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 37fc0d6b960d..e84ee395ac7f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4987,6 +4987,7 @@ static int btrfs_cleanup_transaction(struct btrfs_fs_info *fs_info)
 	btrfs_assert_delayed_root_empty(fs_info);
 	btrfs_destroy_all_delalloc_inodes(fs_info);
 	btrfs_drop_all_logs(fs_info);
+	btrfs_zoned_release_dirty_metadata(fs_info);
 	btrfs_free_all_qgroup_pertrans(fs_info);
 	mutex_unlock(&fs_info->transaction_kthread_mutex);
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index bac3edabe7c9..042093470312 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3879,6 +3879,32 @@ void free_extent_buffer_stale(struct extent_buffer *eb)
 	release_extent_buffer(eb);
 }
 
+static void clear_extent_buffer_dirty(struct extent_buffer *eb)
+{
+	struct btrfs_fs_info *fs_info = eb->fs_info;
+
+	if (!test_and_clear_bit(EXTENT_BUFFER_DIRTY, &eb->bflags))
+		return;
+
+	buffer_tree_clear_mark(eb, PAGECACHE_TAG_DIRTY);
+	percpu_counter_add_batch(&fs_info->dirty_metadata_bytes, -(s64)eb->len,
+				 fs_info->dirty_metadata_batch);
+
+	for (int i = 0; i < num_extent_folios(eb); i++) {
+		struct folio *folio = eb->folios[i];
+		bool last;
+
+		if (!folio_test_dirty(folio))
+			continue;
+		folio_lock(folio);
+		last = btrfs_meta_folio_clear_and_test_dirty(folio, eb);
+		if (last)
+			btrfs_clear_folio_dirty_tag(folio);
+		folio_unlock(folio);
+	}
+	WARN_ON(refcount_read(&eb->refs) == 0);
+}
+
 void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
 			      struct extent_buffer *eb)
 {
@@ -3903,26 +3929,41 @@ void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
 		return;
 	}
 
-	if (!test_and_clear_bit(EXTENT_BUFFER_DIRTY, &eb->bflags))
-		return;
+	clear_extent_buffer_dirty(eb);
+}
 
-	buffer_tree_clear_mark(eb, PAGECACHE_TAG_DIRTY);
-	percpu_counter_add_batch(&fs_info->dirty_metadata_bytes, -(s64)eb->len,
-				 fs_info->dirty_metadata_batch);
+/*
+ * On a zoned filesystem a freed tree block is kept dirty and flagged as
+ * EXTENT_BUFFER_ZONED_ZEROOUT so a later writeback zeroes it out and advances
+ * the zone write pointer. Buffers still dirty when the filesystem is torn down
+ * can no longer be written back and are stale. if left dirty they hang the
+ * final iput() of the btree inode. Drop their dirty state, and the deferred
+ * zero-out along with it.
+ */
+void btrfs_zoned_release_dirty_metadata(struct btrfs_fs_info *fs_info)
+{
+	struct eb_batch batch;
+	unsigned long index = 0;
 
-	for (int i = 0; i < num_extent_folios(eb); i++) {
-		struct folio *folio = eb->folios[i];
-		bool last;
+	if (!btrfs_is_zoned(fs_info))
+		return;
 
-		if (!folio_test_dirty(folio))
-			continue;
-		folio_lock(folio);
-		last = btrfs_meta_folio_clear_and_test_dirty(folio, eb);
-		if (last)
-			btrfs_clear_folio_dirty_tag(folio);
-		folio_unlock(folio);
+	btrfs_zoned_meta_io_lock(fs_info);
+	eb_batch_init(&batch);
+	while (buffer_tree_get_ebs_tag(fs_info, &index, ULONG_MAX,
+				       PAGECACHE_TAG_DIRTY, &batch)) {
+		struct extent_buffer *eb;
+
+		while ((eb = eb_batch_next(&batch)) != NULL) {
+			btrfs_tree_lock(eb);
+			clear_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags);
+			clear_extent_buffer_dirty(eb);
+			btrfs_tree_unlock(eb);
+		}
+		eb_batch_release(&batch);
+		cond_resched();
 	}
-	WARN_ON(refcount_read(&eb->refs) == 0);
+	btrfs_zoned_meta_io_unlock(fs_info);
 }
 
 void set_extent_buffer_dirty(struct extent_buffer *eb)
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 869925337699..ad4ffce32702 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -393,6 +393,7 @@ void extent_clear_unlock_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
 				  u32 bits_to_clear, unsigned long page_ops);
 void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
 			      struct extent_buffer *buf);
+void btrfs_zoned_release_dirty_metadata(struct btrfs_fs_info *fs_info);
 
 static inline void btrfs_clear_folio_dirty_tag(struct folio *folio)
 {
-- 
2.54.0

