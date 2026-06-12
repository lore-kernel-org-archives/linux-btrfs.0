Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C442379C5D
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 09:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781256834; cv=fail; b=qclHJu49qmeSIGk0q66fh7zbvLuERFCFZINHU29YYH28RkneWLRVJmf/+/KfR7Wnm/Jrp30DK+mOcSu0l4L8fVdmuxkiH/Es9eurUraeLeoXzr2Iuxs2fcrM3DzPbj2XYa37/ZGxcy3HsxtbauV2GMc/iPIXMFaP4LtabCRypsI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781256834; c=relaxed/simple;
	bh=YSO8O9EC5yg8fqu5/3gk9V2YY3iJJbfkbIHiXDRj1+4=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SuIMb+BQuDl9w1x+/B48uRXOv+FVHRZONfInY+Cis5+DOwaoeBZE9O3hgjpQWq9cVosIZQZYc3ZglNmVXATgy8eAgpDFeTi0EqxqTEUlOHnEggbTF1p0ovuXB4EW66ppOLG2x/xLPbUKiRmu5YHle4HsNZ0Fn/we4TGBdub7t48=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=itFeG+aF; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=o5YcpjJD; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="itFeG+aF";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="o5YcpjJD"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781256833; x=1812792833;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=YSO8O9EC5yg8fqu5/3gk9V2YY3iJJbfkbIHiXDRj1+4=;
  b=itFeG+aF+Um09TIxCJklpXFmCGLqJmzWYMwV12gBzIeAQjFEBunb8QDD
   vG71oX/dxv53sYLdEQUTMRi9Ej/OWoMrVhIhRsrPoHvQiIiDoG6b13ifA
   /lXh1uDnkFY1cpZ/Q2U2SIinqBA6hUAZGg2I15Pxpdz2yQry+HoJ0Ev2b
   DdQnZOxwR3T9PX2GdACrbmVtCB9DRR2XqhDXGWt/vnFy0blxzWHqTJUmc
   eVJvRTOkMEWPYn3KrrGCRxiizis7moHphgwacRmSTZZ0b5/6rHDNRY2hf
   5ngC8wILlrvHhlpYu3EQcWrVIYTxBrJAjKmWwHlposdAjM8nTrBObuONW
   A==;
X-CSE-ConnectionGUID: 1n0RK8OUQjamlBRwEsP/GA==
X-CSE-MsgGUID: v6b6+WyySlmIArmu/1z9Bw==
X-IronPort-AV: E=Sophos;i="6.24,200,1774281600"; 
   d="scan'208";a="148992067"
Received: from mail-northcentralusazon11012007.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.7])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jun 2026 17:33:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RgtzWDiiINx4IaeSt8diEu6EHyFshmby+EebQju5M2DYWxIUCIETnDGhF3rwkW+GejVlAZlkJrtsa+JcRZA1mV8gKUHUS0AlYrGiipB4q7ovLtnFP02uG9R9WGRqmixdb87gLXDOvOO8Toscr9vC+OetOxitds04/0/tehnI5GfLfolG+fvupLolDsDZwwMuxB8vhQJ37jkDrExUI3PZTNqkSIjE+Sw1M6TzSyBQV4dtyt6shuKadab7Hdj39sJ3tsm8AdE+zV+NcJhXhoAT+py/JUnf6bVogSTxfHeis9kbclAam3+2C4w5KCX9oo+zvu4a3kQ1RAm6kkekGGDjRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YSO8O9EC5yg8fqu5/3gk9V2YY3iJJbfkbIHiXDRj1+4=;
 b=XhQG/c2ZW8hT4dtjUgSnpRwjs3JrvIXp5vsifHWS1TZre/jNIPHoV9mVI70qxXXDJwMv5n/yiCM50e6pbr2fU+WzW6iLE24IJv4Yc56Wo58Q1621VjPJccrWcvFS8UTFQF0M+TudkTb7Qbt8EvCjUlHV07b+2qekU33fH6cnRRp6eTIN4RcMM21kGdS1oODS7G937vLAKpeGF94X8q4gxUlw+IAff41A2UsZ1fs+b3DWrmPBZ9smvuckm9/GA9mBKhSFsr1nL9pu9Xs/xDXonYcJg6eB9fLwpykpEBLCwccB9t+j1KW4CQqk8vRbizEmdOdOhPZC5hVhdCHp0r88fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YSO8O9EC5yg8fqu5/3gk9V2YY3iJJbfkbIHiXDRj1+4=;
 b=o5YcpjJDrAOnE9XE9cY9fJAMGyQ/OtxSrzyIVLyIgC901zU64hSOniC+JwGTVPLuWt8GbsWqptadQjO9czSR3nmdMJVaS7lQCmxtflMXAlyYQtPu/yI7plHD0RHmV1CHrM5fBI9pHsjXCkFIWe5vQseS1kpRyweSoB0G+BtCraI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA6PR04MB9637.namprd04.prod.outlook.com (2603:10b6:806:432::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.14; Fri, 12 Jun
 2026 09:33:44 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0113.013; Fri, 12 Jun 2026
 09:33:44 +0000
Message-ID: <efdb295e-a3c1-4429-a704-b7cea68f9b92@wdc.com>
Date: Fri, 12 Jun 2026 11:33:41 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix root leak if its reloc root is unexpected in
 merge_reloc_roots()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <7508b925a940bed6bd39f6c9eca5e27be7119bf2.1781187556.git.fdmanana@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <7508b925a940bed6bd39f6c9eca5e27be7119bf2.1781187556.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0359.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f4::19) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA6PR04MB9637:EE_
X-MS-Office365-Filtering-Correlation-Id: 47a529a6-bf80-4ea8-8d46-08dec865b245
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|10070799003|1800799024|376014|19092799006|23010399003|22082099003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	a1opR0t703RyuHZmsrqun8EB8B/X0rhhWWMpK9L6KRY0UpZlNk73wB7ywVjgSFcp9OwPRmtVIf6IK4/LGODSbHmkS3okKy50c1uEZ+/z9ptJbUmZYroHd63SPy8NBQJcqBSOU46075SJfG9Bse9qoDhZoQlw6JRgN3EA1SR37PUmzIVgVzlxSHO6ye7M3768w35QGQspaNXEG8uokw2cOxJSApJFZGQQ0hL7vP+TRs7TudZKejJrXvgT3UhLaiieXIkt0gHDXF/LBLqoiK3doTRh0V/sIlb9pt2FpKAMbx+TeVggGyXWWJ21V0iQvwUp2cllrX2tO56dIpOLD8KGF82sNtl+xE5FLr5kw/K1scCnMSXcQx4swxNt+W2bSD4iQszMgsIY8mg05wwnaMtYUqXEhMHr8eQPqwNywaIkxVDZedjz9yOC9+O6OHUo1Wqk0XUsmYSoZnOOEnu5U5pdQgG11onKfYI4mkoJ8ckFOrTWOHZjxkUpt+JrfXlUl3oojEtzWMCh/rMClsve3OjsdZ0JhSgqbupeeKlbhskJSYRLqy8pKNslWLTN97QDhR23Q4h8/UP1cVAUyAnJDDOSe95CWiW8kgmV1aMOBtQ2+6broJMLKa2AycMU4AJo1xILqLgnHY6glE7ssI72NkPPxHtzbtk6ni6s4uH4L1qK23Hk3Kdhbkypl/d8ZsXj3o6J
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(1800799024)(376014)(19092799006)(23010399003)(22082099003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YUpQUmFwWTJkRlVTQnp5MzJhTERZbzllTWN5dlRpSGhEQU9uNko2TktzT1po?=
 =?utf-8?B?NDZOYml3eENReDRpdnZFbktmM2RrbFExVDlDM2doNVNJV29kSHJCc2JXWXRX?=
 =?utf-8?B?eldXbDlJMndycDNpVlhzbEJvM1FSR2hDdnVUOW9NT2VZUWVURy8weWhSV2Fk?=
 =?utf-8?B?SEVucWs5RldMUS8zVmJlaDJSTG9ORXExUC9GWkZFVU1hK1NMZ0Z0REVQOUti?=
 =?utf-8?B?ZjNsUGt5Y3d6UFp1RzJvLzgyN1Y4WStoR2lsODVoUVQ5NVlVQ1RKUnFHcmhP?=
 =?utf-8?B?WXY3aFlFL3BlN1dhY2EyakFCS3E2c3JJL0dVZHdTcE5uaS9FdEFEc1FXWE5q?=
 =?utf-8?B?R3Q1Nk1vdXU4ZzVFVlA4SERURWZBM0N6OE1NanNpK25YMm9naEcrekR0bjFN?=
 =?utf-8?B?SXVoTGtSUW1KT2ZJZ01mei8rT0dYVnpxTDY4TXh5Nm1rb0M1TVZvZDQvR2xN?=
 =?utf-8?B?MS9kRnloY1NWcWszZG1ZV0RMU3cwQ3hkZEFCbEprNWx6ZVpRY2EvbHNLZjZD?=
 =?utf-8?B?djZualZ3NkZDOEg5SlB2M3laYWtFNVFhK2s2ZkpORGNmT0d5Mi9oWmVqejli?=
 =?utf-8?B?T0hxU1JWVWEyekZhR251QzJrZXU0WjBTQ3ZkOVZpUENyTHBnTHhyYlMxUlp2?=
 =?utf-8?B?dFBOcDBiN2JwQ1l5NXIvZVQ4ZXZGVTRFcHRoM2d2L3IySzg4R1ZsTU9ZelJr?=
 =?utf-8?B?RkpHaEpkSjdRdHdLaHJqR281ODcwWXZVbWVTSGM0QlRRVDRHK3MyZnJHM0o5?=
 =?utf-8?B?a0xocTdIUU9ZbGxqeWJBZFBCOXd5Z21oWGhsWEZmc3pySUNZbUNwNlpTWHpU?=
 =?utf-8?B?blYwNk5rMGVNL0c4OWJLTUQ5MkZsdVlPZC9iYW1ZMGJaOVdBeTRXTndqSGd4?=
 =?utf-8?B?ODhyZTBWV2NsTmNRU1AxbVVubXdsdWZvUk5Gd1JlN2FQd00zSEUrdjkwTEpa?=
 =?utf-8?B?VjQwdzBkd2FDRC91dUM5NXZJSzhTS1kzZmxQYlhLaThVSzZLc1VGU0Vzc01x?=
 =?utf-8?B?SFhUc2V0ZDdOYkZ6SjNSMTc3QUtqWTZ0SW1rOGQ1OWIzYzMrTFkrRTRpM01h?=
 =?utf-8?B?aDZ5V2hHL3FlQStLUHM3RlBMUmxTNmNVVVE1cldDeVhuL3I2aUowMGtCWGM2?=
 =?utf-8?B?akIwdmhraDA0NW51eit3U2wyemdKVDM0RkU4TDFUZm84RnBZSFpBWjVINURT?=
 =?utf-8?B?YzVib0ZpVnEwekh3bUw0TDV2V0w1ek5sa0VuRjhIM1M2bE1ROVdGYnRKNFQx?=
 =?utf-8?B?c05MaUJKWUlLY3RvYS9PT3I4TFZaNGE0eFFQQ1c1NlNmdmNFRFFpRFNwWDhM?=
 =?utf-8?B?RUVpQlhIYldlTDNhdmxuQUoxYnRTenBTb2N6aE41SmZXaEppbkgxb2VZcmtX?=
 =?utf-8?B?TFdxQmJDUjViOWxqWFVXbVA1QWpGMStVWnZ0a3JHNWxtMXorWTkxQkt1Vmha?=
 =?utf-8?B?U09PelhRV1ZHSklldjF0djBWNlVDSkVpUU05STdBZ1VzeXVtdThZSlJwWUdx?=
 =?utf-8?B?ek8zTiswRGhuaFF2aTh0SjloVUl0SFhaYW1SdUVWQ25vdTJqRlkxRGFxK1k1?=
 =?utf-8?B?Uzd6STF6YzRZMmNPVDlCcExoM3gwb0ljTWpad0tWblZZSExEQ1BaUS8veEIz?=
 =?utf-8?B?UTBZRG5hSDBvUEFrT3JaVEhDQ3VZL1pXc0IrTEVyeDgvTkIyR251K2ZyRkdu?=
 =?utf-8?B?MW9WSHREWmF5eDc4MU1BejdRNGd5cGJWRmZVN0p1LytZM3VuQnhSNWMrUGo2?=
 =?utf-8?B?dURNRFl2RnZpTGtMNUNkQ1NlVUNvbzRRYjlLTWpjZ3ZaMzg3Tk8yN0dNQWdy?=
 =?utf-8?B?MEtRUFdJWTU0NHpHakJCTXpkNTQzOVY5T1RYNkdSaGNWd29CTkJrNExNWGhh?=
 =?utf-8?B?MEp4UCtUTUI3dHM3aDFkZ1NmVkdIOWVxZ0lLa0tQNXhFaFpOSkVxVnFTbHA4?=
 =?utf-8?B?aC9kSnJqYndwajlOa2tpeUdhZzN0RElLMG90QkhHUVBwQk5mL1YrcisxTUo5?=
 =?utf-8?B?TXg3N1MyNldwMWNDRExseWVOd291Z2lhTjB3dFhsRjNpL2g3SnlRaStsdWZB?=
 =?utf-8?B?SUlwUGdRK0U5SDk1NkR6cGFOYWFmVllNeXdEblBsMW9udlhVRFl6UjV4OGZG?=
 =?utf-8?B?bU1LeStEc2dxMldFR2loNXBTalA2ZFhnYmhUZlJHSEE3dGRMZExreFUybVJW?=
 =?utf-8?B?cHFpU3Y2RjZLNkFhRi9zUmdVTEVvZHZBRlRZZTJ5NW8wbDJCY2ovRi9RMURa?=
 =?utf-8?B?cGhiaUljZW1SNnBLek1zV3FidjdXZ0l5SXFPb0NPd2RkemJocStoWXZ6cXVN?=
 =?utf-8?B?bG1yZWh5cEZrU012d2Q0OFJsK29hTzRYb1luQkxwZUFuSGtsUUFVaGtIamtR?=
 =?utf-8?Q?lFxfR9U6HwL0jyC0PecWAJeOYLB9EGDTcEiodbgH3+zbs?=
X-MS-Exchange-AntiSpam-MessageData-1: ZoZnzh9XV00WjQ==
X-Exchange-RoutingPolicyChecked:
	RToKMr67whA1Hmdhfg+Lu0l0qmdw5eeqhvxseBTOnI1882LOGH1uBgAf1NUxHi8bYn/bLhBKLuz/WQlnWjQKb1dc/yCva7nUqEDp1sSKyd+m3Ej02KeDxl65hGZKsSV2Okn6xWgiC6e2PVOjs7XQ2luUNnRXnKN+EjRntnJ9YDg3RGHLJWGE8fMwqcffC374cnTGAghpeQufTXP5GgRkoTvLb89yuROqpmJSfT+0u4Etay3j4sUlHduXl7zqRyY4PCYwe41rS7gwk9Bhmlz+7d/CBuOVOs92or2eSe3Qv9qSQSvhRD8XTYEAL+YVqwUHTghHrWYxa2SJCQzKbzXFmw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WwvILbsnBna3KsPqLzWIRwar+vU4SDC+/ommZ/G6F48tBkWXn38Jor0ldE/7i6NZ1DGYHf8aAcGYLQD3ltMFS2gHgZfUczf24sHTi3FSX8r/X0jqxbdx6wPnGMEaJhEnKmdnPHkCW1RVoBTfMQlFUbMdcHpwecnrjG7scUC1FHcefTh1DiBNShan1p7+m4vh1CCalZnKTlyPxoJ7mmXiQPtIezxvN8kQdd105Y8/Ebpmw3A1dV1KaY5VORbqzyctjVENb5m37gBkbfCkbamy2H9oxqPg/2JvozQ//gb+RI3HF6j0ixMswf8c70+Kr4b9QuJCypbSxJC7c7UD8MkCpR/LwufCRNI2bXE9FMiFwCOQsHe2uQBZ8vLXPs1bV4PRdHsGOCuVt7SqFEqGrU5CjKCsvVBp4SFZIEGwVCizzcA3PotQIQmFMrCPwJz/hHbTNvlezB1317Iyen/1j9V+GA0agGVx0zIUeJlyhtldiQqU3+A3XS0A1n/zwaMciManHufCgJ4PJEXowA5/1QRL8Yq2qagwoN3opWw3eYt3nIGf+x0QAVsT8J4mUSjrfWz7BPKCdvn1/PdlYZCN83W/mEK7ZmLgkBnX9XpZ2T2vHTGOJZCmzcTNKrDVGomiAZUd
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47a529a6-bf80-4ea8-8d46-08dec865b245
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 09:33:44.3879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: orI21kSU7kVfvC7pWOU+w5fZsG0Houa6hfIc1kwd7aWP2m1JPblp/9B8w0L6oCVY/QDm5V3FGFunvUjjy7kzuKNEfDP4xHCvFBXsUJTDr9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR04MB9637

On 6/11/26 4:20 PM, fdmanana@kernel.org wrote:
> If we have an unexpected reloc_root for out root, we jump to the out label

                                                              our? ~^

Otherwise,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

