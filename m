Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794942005;
	b=fyt54O2IkOoPg6hjZXpjowI9jg+crAMLT3JFpwO+RtJCg9Q4ubY/5sMQVmLuYuWi2vE9
	 hL3tK1uY8YSe18iZIlt0aWcmm07fPArDAbgBCLb4D/abHg3Rp5kA1blsCT/WPaiDQWY3q
	 nrodyp9/LNB5MhCF/2ck5DR1ZYf0P4ARyP334Pztb3BT2zSUNhdGNxP3EqtGfRzVOog+c
	 dLLpBY0mVI5JCUTBfVc48jxu21X2TMq0hf5mUtLNNhzbXiMPva/2PF+r089bwV1kKj1Ys
	 cEqOhQ67nrk8emMBlR/TvbOu3etvd5bGrSlGOK25MocT/HQw6UaboKvbzLK9efr/EoQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794942005;
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
	bh=xqIoTV7gOmgLEfcfo0ONTKuyW/gHnDsWnEyC75fO3ac=;
	b=CrHbGH/ZBp+bhPteuasr4Jptun+Em1CdmITGUEvuKlvZ+0b+Q1dRRUbGcR3DSQy4kxqu
	 Wu/uhZV3jilJfANZuwuvJgYZkpeYhBO0wWf6VwqpdH2XPsO7R+nlRuR3wgE/q0fFRL87p
	 yoi2xDO+JpNeSr6v1FPDQ7gY3l5jdkQIawSyAmSq9gjo7AinTd4lMJ1sRuiERbNUYRrDy
	 lKW2whV77nL/JnFDuv589HuIYMz88beCqr6/0PpqM2GQyFQxIDDGH6TDQ8e0gbkJ814Eg
	 0Xp1j+cJooCSOfTwZ/LsVuxycpQnzEiOmpvD7FNCBgnoBfyYflQXo9bcVq3ytEfhBRg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Z6Z60SHV;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=kPwoUHt+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED5D606A32F
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 19:00:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0ED5D606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Z6Z60SHV;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=kPwoUHt+
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794942005; x=1826478005;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=F3ull1lCt7b68Tu6MP2X6zd5iYs0b8O22z7SqVYyrSc=;
  b=Z6Z60SHVLRhADaCgr35qMTI23G6rBESndpGrA3G7gGHZYzJfTiCoPorV
   me6BaqfZipSj+8BxngCArZmKcUjzYglM3SaN845U9UQhbqwO2vpxBo1LZ
   4UpyBBEl3icuA+GawESv2I7oaOOIxA/hJs+dVXLk26RU190OZRnSh9LPy
   26KK3WuIl+e9H7m18ofI7pK8485CriJAYESyrtWiIPFsD7a1SnByMSfvD
   5KtaGMn/WWsr9q0TD8d2Eyept1DoUW984bD/4H6Y0NvrDKfUhxrl8+v8x
   Xa58RhwQ3st3AI3v9oRkD6XA5xEi+xrT9hb3+aT7TfoqwJqs77Nmau/Mu
   Q==;
X-CSE-ConnectionGUID: JIcCDGB1TQuWWg9bzqs24w==
X-CSE-MsgGUID: tJPxNMy+SI+b2GO14qXr+A==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="161122904"
Received: from mail-northcentralusazon11013014.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.14])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 03:00:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gZWyFVpHF1EU07HPRPa8l3nD0G9m8Vkp8ldnNwAcfirJRW4ebM6aBaTHtYo3iTzj+aMySld90OKUujHWY9OUbD0OH4jqclENGgmJZotbEDaabAnGp2HF8IG/Ao4wRSIBsZw95cppsSwJG54tAToczrnqyGG8dP5Tt/mclPx8lVAtKoSq1dYdiUreMjBXQpLXqBwnxIyHUjU1g2yl2DKQto8bGhssXtxnaMGIIcRTHbyr5JQJ3rW6FO30XIR7AH5jrXO5VU7XqwE+HPqSROzqVykxTwxlgkoRRjtooWBfJ0T/LtptitQAJ+qF1I5j5INVCzUDr+oWjt5YOKahfV4C9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xqIoTV7gOmgLEfcfo0ONTKuyW/gHnDsWnEyC75fO3ac=;
 b=ZTzNDWhixRyDD8qpRvMtW/YgN1Vm9S9C5VlTI03TGaKkGC8KXcktqKF8cOjnA2Ak99/cX4cImm27ako4uyvcddy/grHk8lpW5ECponMEeEBKruqODy+2FOCbH+Z4YFG3FyybEPLrTh7cAkSgiuZvHjY7LjPSYXuLrcF34Ixpllflb8JR/ydjKylAKtAyQ2dVEqHG56dbvXkssrNvolgzPGP4ldjoA7czYMcdFuVZX/Y0s2SytAHvF2HQPnS3Pz3XnY5Z0Hacx0Vzmr79gFsUFcJ1YcY0J9/m0+O/5pzPFEfdf52n4UqLrmnwtHWIszHftDMIPgfviXuIt8aPqbpOng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xqIoTV7gOmgLEfcfo0ONTKuyW/gHnDsWnEyC75fO3ac=;
 b=kPwoUHt+uTbEV6HRRTQbvRUhEBL/Y1EUGQchreDfNH3hMMPXtsrDTqAxoLIfb+XlKsoO77GzdZQJgQFiI1r23xbM4qHjYNOsEM5NB074NGdsoNGKafolgp2u6HlGLlvTbf2Vk/Ai8q/aOPqdgE4GbS7sKJA8pn3sGLHmdFJAYS4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS0PR04MB9511.namprd04.prod.outlook.com (2603:10b6:8:1f3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 19:00:02 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 19:00:02 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v7 23/27] btrfs: zoned: reuse block groups emptied by reclaim as relocation target
Date: Tue, 17 Nov 2026 19:58:46 +0100
Message-ID: <20261117185850.4128157-24-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
References: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS0PR04MB9511:EE_
X-MS-Office365-Filtering-Correlation-Id: ce410bc4-f441-4207-4701-08df44dcfbde
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|23010399003|376014|366016|10070799003|22082099003|18002099003|6133799003|261009223027099003|5023799004|11063799006|56012099006|261102123227099003|10067099003|261022075727099003|261022105027099003|261026140227099003|261021123027099003|261021121427099003|261026121527099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	8kaxTJZZEVZUbhdrPAVnCggImkyBtcvDdnC4ngd6gxHXASKMqoOGOhaeh1PXF7MQxmv5LiS/gY2R0FnClDXOjpjYD0DQoV5BVB/CzbMtNdYakS0+68WWc0z1vFQnjYtiVl4gT7SoXy5WtG14VYln1a1egD4j2xrGwcLK4tXWEyIRQxEmVo9lzKWuV3EIa7UxhUCja2WmwbmNuAjomQUOyaEBe5TGMqzQ5EJsFd/fuMT05+jKI4q/PONeng0LEcQWB3xFETQRj3qhjNIbraTClTGB5GGShxvYxxscuCZsRHHAe9ioZVnxDy4Hplel5F6mfWA6XPRsQ40NOWZw5zsTeNGVid/Vxjhx8n83GkWDBFBZzfPEt2O8xSEcyq02G6+Zk3ywCt5POCrDzdpVymDtw/1HrPWageHiFD9htpg792YiQMtlNGH0MYNE0bpHM5S2d6iuF4fe7Kqi3//fMRtAfLXvqMhp0DR8wNEF42+SuLcvF4zkCcWiNf+ZVVLqmWwRKPgzCvGs6FK1HoclrUmPBkqvGJmQ3B8+UXgsSgvWtFqRZeU9zK1lXhHDQXV+W3bH4Eob8xWXsPvKz4vyqaq5L3bXJ1VK6yiHWDRB1YllM1W39pwkNeTZjfVDkp3Jy0/DL+z6BcXrXI4hoRFDNsFj/Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(23010399003)(376014)(366016)(10070799003)(22082099003)(18002099003)(6133799003)(261009223027099003)(5023799004)(11063799006)(56012099006)(261102123227099003)(10067099003)(261022075727099003)(261022105027099003)(261026140227099003)(261021123027099003)(261021121427099003)(261026121527099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3OP1iVmjJtzD30V1iqu9J4lKXjjTLTt5fFkcZguIIJdupz1C8nBkLStX0/AE?=
 =?us-ascii?Q?Alf6HPS/8b1dIL2sD25vaGcGz49+snCAYTOrE7uqZomRoJXX1dbkaW54Z86j?=
 =?us-ascii?Q?KrQBxoNJg7QuV74ArbFQKm2AQHOxIdygCGJCYBiAgdHV/vmJ0xajt+om97mJ?=
 =?us-ascii?Q?wLcz94809n9HVV8tM0wxypuQ20s3w9bZAAM/8rfsiMmljn0IOwYN5Q28pw50?=
 =?us-ascii?Q?aYqKnsiGIdsoq5OPd2MZqhRZL7AhK0suEWA0HH2SNV+E7nLBFSNFLrsZdLPz?=
 =?us-ascii?Q?ynEtp7K9oIinwh/4p4BHR2fiNKGDG2EWTV0a0S92EeP95efvfGjJ3uWgJCQG?=
 =?us-ascii?Q?XZA8RXDe0tOCrGe5P1JylS/T3RHuchgeer5uPy7oixbwToFa5zHotc3VLwRP?=
 =?us-ascii?Q?tcEBg190V0Dx8kd8/lnqW9U3sAzsxTOKtD3kc32oBVxxQrNdBCPt3Xq3gEfM?=
 =?us-ascii?Q?J/5I7tmkfxBffMYhSA/OPoJgZ2usMTD29jrtYEj7K97RXNTd3AlKJknWbTMs?=
 =?us-ascii?Q?FefheV8Pbqkkmw+MIDn7lKSYDmrHVip4bE+enpgewMeUGKV7zRmiqrM9QHto?=
 =?us-ascii?Q?i1G16oF5Zzc6REuVhNqRzZWHFVEk8tZUHMmMQCNGxRmDHJ3mtci/kDmC63NB?=
 =?us-ascii?Q?If26b8dAwtZeJnY3IHDK95Fa1hDPJXoUcicJWBLrHnMIMcVosb15iPz0xkrx?=
 =?us-ascii?Q?8sl+Xe4K9xSRxb6Z4DKmurZjU/Sv+IALneJ48+fI5nI3tV2PbwvYUM4ZMIto?=
 =?us-ascii?Q?zL9SE0HPmwlVm+InOvhQOMrU0i6BnktRJGwlJZ98im8P4wqkh+QHeLGis6qe?=
 =?us-ascii?Q?Caosi+o/YabZFU9Q5KgY2Yioi01Zsq0H2u7PhkSRTIj9whvp+okGVenZSWOf?=
 =?us-ascii?Q?3Wh4bDBx5mUKLEIKENYz5e3h6kTbPBr0Ckwwf8ShF3ucLkoZ5/mPSk98Fe05?=
 =?us-ascii?Q?7YQW17TMZH6UP4dLy+s58q7+GYvFvTHDrncRFKGl5iKplNA1Whw2tQTnJBgy?=
 =?us-ascii?Q?PYjB5J8VsdEaR7+7g7LiK35FTOdFhfozr1/+vQMtrhtF6nNQJMfQWl3CTSzY?=
 =?us-ascii?Q?/hZPbyQ4qoUftVZrZdc7maWmfebaORTueqAAFbCP2mXT2qNKWURH+v3rT9Ub?=
 =?us-ascii?Q?4L/3nytfjBGlAWbrUTdF1Xm6Y6CDOt2HqQBROksYu4DIjlKlF/P1q+reRFjg?=
 =?us-ascii?Q?Kk0aOET6UBhJ5YiO0ooIo3irPMZ2WgihCKFlJGGKjr8+HDi/SN+qb1Rq+sFU?=
 =?us-ascii?Q?VeTGl1Xy94/TasRMUIJTn59j70P7X64+Wq1ZZ1vJ4kDInE9E2ZtAlbL5+s+D?=
 =?us-ascii?Q?iS/M5Iwin+8leakJBNDGk8GACQgBNGu8UI39Rfq2Vh1LdkQIXLTy4CqAA7DZ?=
 =?us-ascii?Q?JQNozZ23NRDNqIfhgY1/IrZJx/bD0tZxO4W8S4APU5svbNqM0CMOtem5MNqo?=
 =?us-ascii?Q?8gTlTx0krt1cg9Zck0XUtveGQiFJEpbqZ+0jgN3xJWZslUbJZDywh59w/JRh?=
 =?us-ascii?Q?zU9En9qwWXDR9kjgP+Dq/Ty7/+6PhW1pHfOo1PvdGCLIgitoHBae9q8ZjXIB?=
 =?us-ascii?Q?aUiVrFbVMlRbHPMuPbjVC28edZgaBrNTy/ZMm7ItYp8CYznf0pOV7kNU7tbn?=
 =?us-ascii?Q?DjCIwHH3TEXOToYRXMfOTl4LfK/3xC0qFWK/I9+ZBPknKEACvOUiqusV+tDo?=
 =?us-ascii?Q?sVmMhXY4D2MAQweAhNa5KklC9dARmK9m2eEMEctmw1CIt4rf1MpMW1dzXczc?=
 =?us-ascii?Q?b22ApMjdpseV9pV6NE3eKw2CWDSyUVlXflzetLD5dSh1Vdji2kj+K5emJmgt?=
X-MS-Exchange-AntiSpam-MessageData-1: LhXk+fzpyntHdbAgXXkbMtf6iVOCJqDGNMA=
X-Exchange-RoutingPolicyChecked:
	depVuKO/JPmb3cUHrudDspsb2kLzlTYLHwYJZfkKKdeQMzN0DPZrNeVSF2lDH92z0fV6g0DxBTtcWZxf3Udvt+gLoad2ufcJhKPicY+/LhGHJPBJ1emIgGlD317o45ym5/wqNo1s4LuwCxOpjOTTwFBV+mci/e8WDe6rH+SF5Xfzk8yG21VXjYeR3+miL7ZxY9R38BR//7FlY2pFVXwoHYqMEGQMHfZjsfd0BJz7fMmK6ogdNo6EAMJvhHmfvnfdSGAMUzru7lq8EsWdaX07T1elk+9vYeaHsUhm24wOWyA3rs6Kna4+rPyflXuhCtUEAC71/eqdxlHpbzLA5vTTuA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	M5RBqn631prtOspVVAbOxe643Kk9ZTpAfAIkHx4+XkGNnW2EZuTd+WHkj/t93CgpMq5XilmHNcRJoWG21oIg86PPI+sETmh5NwGAG7rkI4r2r6TRfosSSHtAOEurC7cOX7u0bBNQ006UhemaQS52QZtmsqmVd5NeBy52hKK1ma4CKKwRyjCXR4MhMFiH2x2s+hIvjXCGeWl4g/Y+Rq7MCf/vc33oBmhMGwavozBPZQbjAU7Zrfhu8Aam2JiOIjGS7oVUmCuDkuyCCPOatI5Vgc8Np4W4G6vYxS/7CU+C8fP09CXgJlDVWZgtDS3Fwyi/kdavjyq5tQ2E3a0K6x3G9whljoAM8oKU5nyYG4l49nkQtCV+w7WDA7ebdTs7pl4aiNNQLMDOcSESFlJ2lQyoTQCx57LPFTq4MDEMonmgRL0+kh4VvqvubZR2AUgEmX+uW2PnWfviinMn35Q4FzTFrtYZuxj6Tr/j6o/cLWs19QZEV6h35TRfMHshflpHhSpGrLi1VyHc+9BKbkPppkAUnt7SDe1H6N/h2xkweKVXLzGYb6GIASVjxRpeOZo52cHK43ie3G+uTgpAhMrOlT7ouLM1b6R8Vv5s2j1N9InDW7vPSfkZGKds/7g4Ed6iDh4/
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce410bc4-f441-4207-4701-08df44dcfbde
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 19:00:02.1613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lo/D09UyzxQ5yNMh8XnnXufteI+EPBJjmqP+E7946POgensz7ZgZvAyZYrLA/DjArYSx2iJn1v7HSWwqs9CexrAzLjiwei5VKtMi/DCKVQY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9511

When the block group reclaim relocates a data block group, the emptied
block group is removed and its zones are reset. The next relocation then
needs a new data relocation block group, and if none can be allocated the
relocation run has to be aborted.

After a successful relocation there is a free data block group anyway.
Instead of removing it, reset its zones in place and use it as the new
data relocation block group, so the reclaim always has a zone to relocate
into.

Mark block groups that are relocated by the reclaim with
BLOCK_GROUP_FLAG_ZONED_RECLAIM, so only those are reused.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  4 +++
 fs/btrfs/block-group.h |  1 +
 fs/btrfs/volumes.c     | 22 ++++++++-----
 fs/btrfs/zoned.c       | 70 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h       |  6 ++++
 5 files changed, 96 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 562ec70ff0a5..6801687ce029 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2065,7 +2065,11 @@ static int btrfs_reclaim_block_group(struct btrfs_block_group *bg, int *reclaime
 	spin_unlock(&bg->lock);
 
 	trace_btrfs_reclaim_block_group(bg);
+	if (btrfs_is_zoned(fs_info))
+		set_bit(BLOCK_GROUP_FLAG_ZONED_RECLAIM, &bg->runtime_flags);
 	ret = btrfs_relocate_chunk(fs_info, bg->start, false);
+	if (btrfs_is_zoned(fs_info))
+		clear_bit(BLOCK_GROUP_FLAG_ZONED_RECLAIM, &bg->runtime_flags);
 	if (btrfs_is_zoned(fs_info) && ret == -EAGAIN) {
 		btrfs_dec_block_group_ro(bg);
 		btrfs_debug(fs_info, "deferring reclaim of chunk %llu", bg->start);
diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index baf8e41ce8d3..9c385c02c1f5 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -88,6 +88,7 @@ enum btrfs_block_group_flags {
 	BLOCK_GROUP_FLAG_NEW,
 	BLOCK_GROUP_FLAG_FULLY_REMAPPED,
 	BLOCK_GROUP_FLAG_STRIPE_REMOVAL_PENDING,
+	BLOCK_GROUP_FLAG_ZONED_RECLAIM,
 };
 
 enum btrfs_caching_type {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bf6dacdb2571..72768f29b8f4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3723,28 +3723,36 @@ static int btrfs_relocate_chunk_finish(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_root *root = fs_info->chunk_root;
 	struct btrfs_trans_handle *trans;
-	u64 length;
+	const u64 start = bg->start;
+	const u64 length = bg->length;
 	int ret;
 
 	btrfs_discard_cancel_work(&fs_info->discard_ctl, bg);
-	length = bg->length;
 	btrfs_zone_finish_relocated(bg);
-	btrfs_put_block_group(bg);
 
 	/*
 	 * On a zoned file system, discard the whole block group, this will
 	 * trigger a REQ_OP_ZONE_RESET operation on the device zone. If
 	 * resetting the zone fails, don't treat it as a fatal problem from the
 	 * filesystem's point of view.
+	 *
+	 * A block group emptied by GC is reset in place and becomes the next
+	 * data relocation target instead of being removed, so GC always has a
+	 * zone to relocate into.
 	 */
 	if (btrfs_is_zoned(fs_info)) {
-		ret = btrfs_discard_extent(fs_info, bg->start, length, NULL, true);
+		if (btrfs_zoned_reuse_reclaimed_bg(bg)) {
+			btrfs_put_block_group(bg);
+			return 0;
+		}
+		ret = btrfs_discard_extent(fs_info, start, length, NULL, true);
 		if (ret)
 			btrfs_info(fs_info, "failed to reset zone %llu after relocation",
-				   bg->start);
+				   start);
 	}
+	btrfs_put_block_group(bg);
 
-	trans = btrfs_start_trans_remove_block_group(root->fs_info, bg->start);
+	trans = btrfs_start_trans_remove_block_group(root->fs_info, start);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		btrfs_handle_fs_error(root->fs_info, ret, NULL);
@@ -3752,7 +3760,7 @@ static int btrfs_relocate_chunk_finish(struct btrfs_fs_info *fs_info,
 	}
 
 	/* Step two, delete the device extents and the chunk tree entries. */
-	ret = btrfs_remove_chunk(trans, bg->start);
+	ret = btrfs_remove_chunk(trans, start);
 	btrfs_end_transaction(trans);
 
 	return ret;
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 027aa78cbb3a..67b440670125 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3188,6 +3188,76 @@ static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, bool promote,
 	return 0;
 }
 
+static bool btrfs_zoned_can_reuse_bg(struct btrfs_block_group *bg)
+{
+	if (!btrfs_zoned_bg_is_append_only(bg))
+		return false;
+	/*
+	 * Only the read-only references taken by btrfs_reclaim_block_group()
+	 * and btrfs_relocate_block_group(), nobody else (scrub, balance).
+	 */
+	if (bg->ro != 2)
+		return false;
+	if (btrfs_is_block_group_used(bg))
+		return false;
+	if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags))
+		return false;
+	/* Once read-write again, nothing must be allocatable before the reset. */
+	if (!btrfs_zoned_bg_is_full(bg))
+		return false;
+	return true;
+}
+
+bool btrfs_zoned_reuse_reclaimed_bg(struct btrfs_block_group *bg)
+{
+	struct btrfs_fs_info *fs_info = bg->fs_info;
+	struct btrfs_space_info *space_info = bg->space_info;
+	u64 reclaimed;
+	bool reuse;
+	int ret;
+
+	if (!test_bit(BLOCK_GROUP_FLAG_ZONED_RECLAIM, &bg->runtime_flags))
+		return false;
+
+	if (space_info != fs_info->data_sinfo)
+		return false;
+
+	if ((bg->flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) !=
+		(btrfs_data_alloc_profile(fs_info) & BTRFS_BLOCK_GROUP_PROFILE_MASK))
+		return false;
+
+	spin_lock(&space_info->lock);
+	spin_lock(&bg->lock);
+	reuse = btrfs_zoned_can_reuse_bg(bg);
+	spin_unlock(&bg->lock);
+	spin_unlock(&space_info->lock);
+	if (!reuse)
+		return false;
+
+	spin_lock(&fs_info->unused_bgs_lock);
+	if (!list_empty(&bg->bg_list)) {
+		list_del_init(&bg->bg_list);
+		btrfs_put_block_group(bg);
+	}
+	spin_unlock(&fs_info->unused_bgs_lock);
+
+	/*
+	 * Drop the read-only references taken by reclaim and relocation. The
+	 * block-group is full and empty, so this leaves it entirely
+	 * zone_unusable, just like the block groups that
+	 * btrfs_reset_unused_block_groups() resets in place.
+	 */
+	btrfs_dec_block_group_ro(bg);
+	btrfs_dec_block_group_ro(bg);
+
+	ret = zoned_reset_bg_in_place(bg, data_race(!fs_info->data_reloc_bg),
+			&reclaimed);
+	if (ret || !reclaimed)
+		btrfs_mark_bg_unused(bg);
+
+	return true;
+}
+
 void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 1f5f62f7590b..d2011f764f87 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -111,6 +111,7 @@ void btrfs_schedule_zone_finish_bg(struct btrfs_block_group *bg,
 void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
 void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info);
 void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info);
+bool btrfs_zoned_reuse_reclaimed_bg(struct btrfs_block_group *bg);
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info);
 bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info);
 void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logical,
@@ -301,6 +302,11 @@ static inline void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_in
 
 static inline void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info) { }
 
+static inline bool btrfs_zoned_reuse_reclaimed_bg(struct btrfs_block_group *bg)
+{
+	return false;
+}
+
 static inline void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info) { }
 
 static inline bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info)
-- 
2.56.1

