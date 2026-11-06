Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793957174;
	b=n1aBUtGxK8chxfQ6Lxxiy5LTX1tVReDV6k9KgK0xxbpgTLJBl+vb55tkIB5D3aHwFPtl
	 0y/UziL2pjb18quDyo3Vz8S71D0jWEj/dbMEI79KNvV7mMXWmiR6hslAl+D0OjeWeThyu
	 bEwdC0p1KbcDvPO0k7f1cFQgp8HTk12w8Pvl/Fmd4B8c5Le1n378j5GmS08uywpSrcsFO
	 E3ov7O2V8LhAkXbpFlLPCIeQu3x+aa1Q38meEcdcnQp82WUvHE0CxEct40GuUvaInchZU
	 E/mKMDC2wLgoO2DmtH2GkW9qQcQ4ipRMGlK7xcOrieIgOBTAEMcyKJJTfR8HrDuU2CQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793957174;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Message-ID:
	 Date:User-Agent:Subject:To:Cc:References:Content-Language:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
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
	bh=Mmf6CPNCE6eKRdoDW5ZYTZ3Knb4lPcQsnq5ukuc+x1Q=;
	b=rpDeEG/uxbQ6JRPiihPVQFXbXZType+nHq6MhCeDAQnN5N713fiPXT9/mb8k+sSjGQnk
	 mkHlEaxy8lY/9hVykpyVdbCkirUnzlUBcKS1NxZdP63bPLBLVKdk0JgSC21XAiseTpbK/
	 kRbqLasb+yc4EFDYy+cXwHnmhVo+FCPSeWRXjZ3y6GkOyHd0gLioAfNQKseubyAzSSJR4
	 TCl7SQ3Y0yTFVZBjBj3zDeEHYTaHRXae9drLDFv73v7hTwpHT6i98crXF8IHWtDWNNqck
	 fbVIgxiKTj9XMxuRv/v78lUqCZRnEQDv4Lc8FdgSbnRzBhTI1nmIzDhsLtlt26ObatA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=rX5dKjFv;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=b1NDCRF0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610E8606A326
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 09:26:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 610E8606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=rX5dKjFv;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=b1NDCRF0
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793957173; x=1825493173;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Mmf6CPNCE6eKRdoDW5ZYTZ3Knb4lPcQsnq5ukuc+x1Q=;
  b=rX5dKjFvLPLpSOD1co+v3mKiYaRGoRE30ao/MpA8tSuJCJ9f+A/IwxCN
   P3x9NpnXRlPLvDoOaEfmBhB3voPvgd8ADu2vmuM6AlGH7L2uTWw+/TjsM
   QEhx46cf7ADHiW9oD6H+tgxPfs/94SsIq126drKNfFOq/Xpa7++WzLjmI
   CyRExaK6LX0hi1WynQ6C7zCwjKJkvM9udA8/huShUkWP7LMdfbFa72LQm
   9MI8ieC9OYne2zAnMDf/MvXnwstomfctSnph50RSU3gV5O0vT3+1dsfIi
   QMs97CeIiR+66Rbg5e/0ltF+8BoE73jUU1WQqiR6jXuxbaWRwi+Swn87h
   w==;
X-CSE-ConnectionGUID: xlDtdILiQNK19ZGOF6CKGg==
X-CSE-MsgGUID: bFSUzVrqQLG5ymMIN54E+g==
X-IronPort-AV: E=Sophos;i="6.27,197,1786982400"; 
   d="scan'208";a="159904509"
Received: from mail-eastusazon11012039.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.39])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Nov 2026 17:26:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vfsvPcJVFThuiqGPKuAH9KlX0svEOYPSXcW0G8HTnB5PrGbW0lng/Xys/EXr17YWzyys1oLOBaLyVFp6LVkShX0V1uvaVLegLg+AvLaQ+SIAcm8IscTsbjoKLNNsWiYxCMXOiuIH0T3OxHcOqeJ0/RfIN92luQxeZRzHxwPzL5AnCyUkF7dx2P+K5AD2c6rbhxciBbrA9osWYx1Zt/n9w0zcFIwgZw8mvUg6HMRfb7kK/Ru+zsFue+H/OE/vxR5YgHfWCiQUVy8DsWkvc5X34XMaBxMgCUnO+ycmwjvPShRxU1R2K1v7yKqabdrILytBkp51A7akvSZpg8MHGAnFyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mmf6CPNCE6eKRdoDW5ZYTZ3Knb4lPcQsnq5ukuc+x1Q=;
 b=SlnO0UlpyMzNQcuXsaol4qzrCtwhOh8g2ft2UgX1izHYsTc1F51ZADVOavGhF9q4bLhybi4Qi8tB3joSk1Sj8MDrIUVPW5GreTwrvF3J6mnTjrsuHYQCA67tTUksdpewNPVB0qUtxiRIiSv5GMcSicVQjT7/TXKWaaRLZmwwu9S3BAEiuWEC6hOSa8/ynmWekDn8pTpgnGLiRVYPDb+zA0prNBwByPUQmwa7ZPuqFFuEtgzF7/jqeSz5KCvJQ0PzvKR2HaG+JgdCDfpIbQG/GIDT8EdgSij50XWUR4sn5RjUK+su1ZDQwXRbhLJSb+CUVKQnDzK5oEy5kz7s5ZaKSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mmf6CPNCE6eKRdoDW5ZYTZ3Knb4lPcQsnq5ukuc+x1Q=;
 b=b1NDCRF0sxfbAvHSsJ3sQnM8uxPwgq2H1jU+B4F/3IrQzf46Yf6W5Ti3+MoEQGA/Np0qEXBjmxtngvLYF8fRypt7tgWNJJjyqAiyfhrP64sxqx3KCeZFwHSGI3xJjKuXM94E1eh7t6Itsp1j6KRAMcInXk5Pj8AnBQIHB50pLac=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LY0PR04MB203084.namprd04.prod.outlook.com (2603:10b6:404:223::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Fri, 6 Nov
 2026 09:26:10 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0592.009; Fri, 6 Nov 2026
 09:26:10 +0000
Message-ID: <a27aa643-924f-4879-bfc2-9108f9f89f31@wdc.com>
Date: Fri, 6 Nov 2026 10:26:06 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: Subject: zoned: transaction abort with -EAGAIN (-11) on
 host-managed SMR (WD HC670), fs forced read-only
To: Jochen Philipp <a2jphilipp@gmail.com>,
 Dongjiang Zhu <zhudongjiang@fygo.io>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <Naohiro.Aota@wdc.com>
References: <CAD=K2o-BBqh+ikgfD732Cb3M1Xx48QGw3kTFsP5iSgH1mkr0wA@mail.gmail.com>
 <904615c7-003a-4158-922d-c57dee9a3ecf@wdc.com>
 <CAD=K2o_vLPSvm4Qzi8y4t5ay+Na9GNk2t5a3iMO3NYJvwodKDQ@mail.gmail.com>
 <CAD=K2o8xFgYBHMim-KqMysV+Tec9LEUbo6jfD6R-GOAU8N8K4w@mail.gmail.com>
 <CAD=K2o8kWgTRqBBw1sRfO2fopqQOLfdeX61h=OFPMST=Wdo+KQ@mail.gmail.com>
 <30a6e871-8578-4d27-bb0a-679b94fb7f92@wdc.com>
 <CAD=K2o9LbeJUcb0xefwVx-rC5udLNLwqouO8pqFB0R+rWQvHng@mail.gmail.com>
 <CAD=K2o_MwSF_XS=iRu8GMPhH2Sn6t3bsKLm5BLOjZ34tV4aRvg@mail.gmail.com>
 <CAD=K2o82LSzq9CN3mQxfoByGCteSLCXXetjnxLGQaQv+8gC6-A@mail.gmail.com>
 <8d2e8334-8a6a-4bb9-9c78-a126be7d94d1@wdc.com>
 <CAD=K2o8CTZOPQ1iMTi2+zirKtQdY3bS5Dz9KMAamyid6Lf9QbQ@mail.gmail.com>
 <1f4f5514-b20c-40d7-a87c-911276a5e661@wdc.com>
 <CAD=K2o_A4HE7SwjTGJWr4cKFmu-OtJcLXQ2w=XFJDYGnOSbD-Q@mail.gmail.com>
 <5e929ec6-4641-4990-b910-489e34550ba7@fygo.io>
 <CAD=K2o8EAtV0p1dXBBXvrjw99zOb_XJUZ=Zz+1BjwVmhsScMDA@mail.gmail.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <CAD=K2o8EAtV0p1dXBBXvrjw99zOb_XJUZ=Zz+1BjwVmhsScMDA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0227.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e9::8) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LY0PR04MB203084:EE_
X-MS-Office365-Filtering-Correlation-Id: a5ed6c5a-b100-4909-271e-08df3be7fe72
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|10070799003|19092799006|366016|376014|1800799024|261021121427099003|261026121527099003|11063799006|4143699003|261102123227099003|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	h7bnNzpO3EalW2xu3ckx5GojWxOO4w28zZbeJBD240ouTYxxb7QYkxoTHU4aA+O9sIKSLDqTpkDzORcSRb4oWoEghiN7bLb//WYJYCyeHgmFZaI5LPQLeVIaIxH/hB5UaG0csuOT3NgL/V26hgK9BBG905pE5dVcwMpGRDJJrYoZZPRXNidbo/h0UswzVOLzevEklsL3Fk2oDJINZpwYLh2pKae/ga6mTki+GACxkylUbs229a4umtaWZSRy0kphH2o2tOy0EIkpXQC9ydEQD943vmxsIT7b+DxdQ6tk0aHDWx+ewtW05iJnueqV3Qgs+91HCPhO0PA6HeoXcPYFJ0/vIfs+l+uRU202ah6+O+XboD6Xm7V6rZcOUYPr2olQDxY8UQTwgeFs3Z8Jkqqa44/yPqT+eBuwfrupSO2Iqug89lN1PiXeoOT8grAjadS/vYHXdOlFKY4aZpxk6yip1sjr1MpwZHg05VdYNXZWtcYw/xtOtUI1xCtDnQ9V0n70KBrbAQEOfu9b1TzVIrx/hrSwGp5XukHP3/xcd/z9ICdzUVKIVGIaZ9MgpzKM1WKSeR+5cxzM3mVYkYnGq/abNBn2WjmynNFEWI57TppXxK70BOUOUskc0P/tA5XZbMKppb+s6bcThMOgM4f9AZ1JOfUB0rlUfUtcHluaWpsTUwY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(10070799003)(19092799006)(366016)(376014)(1800799024)(261021121427099003)(261026121527099003)(11063799006)(4143699003)(261102123227099003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VlNqcTRWdVlPWFlLcm5uNEIrcENwRFcvYzBWQlp2MGxZQWRnWTNGelpoNS8y?=
 =?utf-8?B?VmVDNmtzZGYxK0tjeHVsZmpWNmlJaXdaVExoYTZqcmNXZjA4dkpYMjdoKzFY?=
 =?utf-8?B?TE9vc2xrL1JMZjFSVlFZbSt2RE1QWjFBUXJZMDhaNHZDVFZGaDMrY0kyT1FW?=
 =?utf-8?B?ZU5wczJ4M2lOOVNaS3NHdkRNM1I5S2NCMHJDbTlqZzdkeEMrVEY0ZjJzMjZH?=
 =?utf-8?B?aDNUU1RlWk9JbU5oWjgyWms1R0FHcWk5ZjhCTUxrOUIzNFpuckpERE1CYy95?=
 =?utf-8?B?cHB0SzdnaUh6OGdXNDZmZ25jK292aGdoaVlvWndNeTZSM2g2R2xpWTZReXhM?=
 =?utf-8?B?UElkeGpkeFl6bGFLM3NQdGtoMnQ4c2VBTWFqK0JhRDlTUnAvR3lvSEFjbGMw?=
 =?utf-8?B?UDFHOGt4TktSanVHSnZYeGVXLzBwY1d3NExnR2tsL2JjY1BtbVdqS1h2andr?=
 =?utf-8?B?T0czR1k2V3dUL1lWak5uMzVHUjNyL2liS1VCTElUazFyQzRoQUR5aUhEN0V1?=
 =?utf-8?B?eng4T0k1YjlsRlVrT2NxQXRsdjJRbDlncXoxbXZZZ0UxZHpuYzZaa1NuMW5a?=
 =?utf-8?B?Z250ZTYzSkhzbWhWS1JhU09FSEJrTXpLTCtMbE1MQnpQTjg4dysrckZoTTZt?=
 =?utf-8?B?ODZsN0lVVmp4UHNvYkI2WlZicUZ4SVNsMFRrZGNORWRPY2ttcXJFT241cnln?=
 =?utf-8?B?V2MzQm5uanpyMVBVVzdYZ2kxTVpudU9RN3Z4WTdMVDhBVzJxKzdhL0orbDN2?=
 =?utf-8?B?WitaMjNkOXRsUHBuNlBJZkZBQTAzWWhydzVvNExPS1h0ekdkUElyTDVzQno4?=
 =?utf-8?B?QytLTitXaVlWQk9mQW9HUEZ4eUtSSUF1a2FnREdrTldKN2ZYMDRkZlkyL3VQ?=
 =?utf-8?B?OHV1VkZzbE1FSDJYMVBhUktNY3o2Rmh1UFpoVnAvUElkaDJzdjJqcWhmdWVs?=
 =?utf-8?B?dnBDQVl2Ukd6amtkZ3VzVyt5bTJjWlBQT3FLdCtRYVY2V3Y5dldmNGUrZTRV?=
 =?utf-8?B?aTRETHRMSFY1dS93L2dSdisydUwzMXc3SndNSmNvblB1VktLTmsvbkpKellI?=
 =?utf-8?B?ZEpDTlYrTkJmOW1URGMvQnNWVWhBalNKZnVHc0FmTG5GN1pYd3pIbFZlK3VS?=
 =?utf-8?B?S2lsTkNEUEhrOWxZTjlhTFN2aHBydnV4QnQzZmZQRzlrVng4TzQ5S0dRaGN1?=
 =?utf-8?B?dHEwRjZlK1NsSkpqTnEwaHNHa0hjVFVtbEZxNWY0YjVyTlY5SmFnMnJnTmhm?=
 =?utf-8?B?Nk5ONHFiQWI2bjRlVVMrOXhuRTVvZy9RRXhrYWIxRnFxanVEOWJuOXQvQlUr?=
 =?utf-8?B?NkFmMGc4SkNyVnJsVTRZMDgzUk9KZ1AxRytKSllFSEh2ZHpDYnJzc3I5eFh1?=
 =?utf-8?B?VENWWDRIUGVxT00rZlArSkhTV0s4dTNsazFIZm9ZQ2VCRStSYk5SVEE2NUJI?=
 =?utf-8?B?SnhzTzU0eHduWHEvU0o1NENQbzlwZ0l1QmpidTVOSE5BSTZtWkVhUFR0SmV6?=
 =?utf-8?B?Nkw3RjBKLzkzZmxpU0xTZUY3cTRWeG12N0g3WXlkVmJoTmVTWlBjWmYzdTVq?=
 =?utf-8?B?QVRMRjR1b1U5aTBSUjEzR0F5RXBrNkM0cEhFNnFaTFFCUHFmeFk1V0VqemNu?=
 =?utf-8?B?RmxVUHErMmw4MndqVHpBQVpsSXh3SUdObThtS3poWlE1cWlHSkpWWmNET01w?=
 =?utf-8?B?cTRqTitQL3hqVEZyd0tsWTB6Qkt1U3NFZFJmT3VpVFFzZUZHVW1TNVlzY25k?=
 =?utf-8?B?ZTM0ekhHUGhkaUUrQ2ZGSmRkcDNiMEJ3V1dnV1g4ZlF4MHY2KytkSUcxcnQw?=
 =?utf-8?B?Z29YYkQ5QzIzTUg5RUhrcDZuWTZ1ZDhROUlyODdmQWFwTG5nQlNSaVJEb0Ri?=
 =?utf-8?B?UXY4YTlpalROb2k1WTRXSnQ2RTlBamZVOXlDUWk3VTBXSVRWSWI0QUkvLzIw?=
 =?utf-8?B?M041L2xaMUN0d2JGL2tZV0hQRHdjZWR1a0EraWZZeGorMmZrR0lBV084SVFT?=
 =?utf-8?B?U2dZMFYwdFlaTXpkNTRwZnBueUI1a2RwOUFMaS8zL2pEckM5amVxOEMrSmxk?=
 =?utf-8?B?YktsajlUbzk4VUdSREMzQ1ZOWXdOSU5xR1BSNnhNKy9EbGZHUEJQa0ZKdjBr?=
 =?utf-8?B?RDFmclNpZTFuNDVVazNkQ1pvcU1pSXoxbXJHS0tJQyt0VXVSRS9BaUZzdDFq?=
 =?utf-8?B?UG5zU3NUTkVRWS9VTTRzZ3pRaW4ydnhDL1pDT1FyWmo0bzNaTVQ1a2dSUG5m?=
 =?utf-8?B?OHhRY1lYRE1BWFVaa2VoY1YwM3VDYjlHaFBHUkhQOTlHWVVqRFRkVS94SnA5?=
 =?utf-8?B?eEdDQlE1VTFyZ29vVlEvMFd1bytEeVdIMUpIQ0pQR3RMWlMrRExkU2ZxYyto?=
 =?utf-8?Q?Zj/tcb688s0oPK6KohNvALUQ9UFQBlANrd+CzPlLMUHOV?=
X-MS-Exchange-AntiSpam-MessageData-1: 1j5Bq2PKP6MwOdiwnq9vDCPshpzKAlCWZUE=
X-Exchange-RoutingPolicyChecked:
	AaGz1SgtffCLrR6MVtJPB7+qI7QvRXJnMG9IvaiextFHuV+/k3xMqKM/+3FjqcL3VrdUM5lntWoRoXgcms59VwUWNDV+OF2Ez6SBUmskteA67PZbbRXlCzIxNeceGnFwG420nvBKa41V/mlWPqL4q5lnZy67wBWfolxrJc+h6Q9nisZh4foYLKFfr04RFYMdL2EnQ/LZw8trkvRak8+J2oWH3pN7OILMpWdhDxM0CJ3Enum2p0CHOr8A8yobqwqQG6vQ1Vsux3zP+BWClf3VEvJy5whnVn9FS2b4z9kh8ptISM9etLLaxoFtN7TVRTTsiunm+6/I/M//+62IC7096Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qGwH/bTPxI+z2cRAGx9ERxjnTClhHS8/htm+ZjKKgcSz6fu1Us0jdQo+4DVqBZhTYdpY8jzPyWYH11ENhjD3/MhF/8qqwfNbrlSRZHVc6Mw9FgXZTehopgIj45Q5qiRL7XisKkE8ycEbBCwnne7x08N/Hgg2AFoGlFrchWaprD/std6UgZPcR84hr4QTsEDWDZnHUl33uoSOaG6INHM2V4aPo4eZGzVJUbpg3IL6UEVdHK96AvAlzwNMzsXmyUYzX/92y0Od6tr1jfLP+aK9NuZdCz+D2jMqcZmWI7wqfgSS53X2WYBng1c6Ne9aN1iVvyxkwQcRgjgtRMC/mGLoftzGJWbrA6nkRWgCBFxR9TgXf4jQLgpxZSpDgKQ+9xEu3D50XnhtG4Rucb5QxEj06x5sOqNLVj1VKPgbf7Oxui6xFB1BITg1Bu1zo3DK36YgFkGJ/uyxPZstMZJs4r1kRgB3rsi/WFyqC4xyW4zpv583ci1d956mmQIOvRJKhx32rS4mn8UEnp6gZwEoURjcVhefCkU9N8i7DRiLDYjsqqH5+lSNMz/mRa4dZEx3mSpo41rRVFx0MVwmg2OZVxcEEn7+IUSChTq8+K5IY9CmGL2STqGryPzViKKM2q98YlE2
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5ed6c5a-b100-4909-271e-08df3be7fe72
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 09:26:10.4912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CvYdcDC7xFiwCLE5HguEveWOdychdCDogdMasAwNEnzPblJxrBNK8bm23LbzEUadQOYHsivFSEJ6iRmPUjSp4DNmZFUQPr9CpYBi4jcwbGk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LY0PR04MB203084

On 11/6/26 8:36 AM, Jochen Philipp wrote:
> Hi Dongjiang,
>
> thanks for reaching out - yes, I'm willing to give it a try.
>
> Johannes asked me to keep the on-disk state untouched while he
> looks at the zone report, so I'd like to coordinate with him
> first: Johannes, are you fine with me testing Dongjiang's series
> on this fs, or do you need anything else from the current state
> before I do?
Yeah if you don't mind, give it a shot.
