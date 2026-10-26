Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793028263;
	b=iCnr1PmvXlVSRjXpFICz1G/JPEqu/mt3yYWz+/9moGOVZB14PMHjq0nN/l3yNV1r/t3W
	 +dz2FJVcqhkswhfqvSjgFgCdN3AaP0Z8uhqV98CMT3FqI4wkgqnrxyLegoDSvY795IUKB
	 GCex3cQRIJ4Du1g079N32J1kT26u1TFs9mTkzj+naQP1K56ZmHgcXVuvxOpjaI98o1SDN
	 /9DEl9qtcaHPWyEkt5sn3gDAFE4pXARo5fLRsoZ1JDdUs7g6yf+AMeL7VEUH/K5NOHUys
	 hIUHPVMYLx3Nw0GTafQ4ls/+b1qySgGoVLLcvZogeA4cEvBqPY/7TPHJ6umwCxaOvNQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793028263;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Message-ID:
	 Date:User-Agent:Subject:To:References:Content-Language:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
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
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	b=aAHhlKbvCTDaL5bLeYHwflAFucXzbcsN1zkQ0K+vOlOrPmXafpbWSsHC4+o0GY0qglqA
	 V69aBD3nIYHAuIRd3PmXb2Nk2icfhObIcMXzEb62ej+2eCTr4qx/y9BcOoLVvFwbqQtDr
	 1Daq0MOKoDA6zlNof4CGDNXfosquTDVRcKNH8PgLlQrmznf3f/HjoDRH8r375Xc09bz1c
	 OoLMKs+m0jpYOdyPztjFyV6JSBm0Ft8FxoZ7FHVEesJ4FycCieX7GyuHiRzTcw6yDoRZV
	 CT+zVXv/umsdBL5MHjbsKMtGyLR+aMtAHCCgyg5D0+ApDlOrUKSpWOfj5vTw19UoYyQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=lxsvxqXs;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=V6lnYyyN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CAF606A31A
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 15:24:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89CAF606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=lxsvxqXs;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=V6lnYyyN
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793028262; x=1824564262;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=lxsvxqXsNJvwReFD6vDrWEzo4sHJ/A+1ink9q0k+hwZO7Qp5ZxK0XE8o
   u5bA1nPnKEHV7PRZgea39DqEJJYnrdGMoW4XCMP35vRg6Z9PfHA/9GlyY
   YpEo0js75MBUTrQY2eumKybF1jJhksjzH0FEh1E+fU2zD4J35DHepFKhF
   Cnmv83PsKdpYCo/Sucr/TBgRb5rVp+DIF/Kj1EPWcPRVAnyEtsCqfWyy+
   lHEnGvY+ecnrNoS/gh+Lr2wxP1cEOKGYQuCN3iWMHlrkcDct3PHgY6gZd
   tW2S+O5BMH7eblT+uwDxYSIbcghxWmHs63Dy3EOeWfRgh21hN2FAXzGcy
   w==;
X-CSE-ConnectionGUID: 2uZJPdLBTEuVxgByBfIGmg==
X-CSE-MsgGUID: OjmHeYrXRg2jyk7ReMLgWQ==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="157416127"
Received: from mail-southcentralusazon11013041.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.41])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Oct 2026 23:24:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gbiyeL2YeSPv9dYzS6nMN7iEQa13S24S6chh+/b5FCu3dCLyoFBJJItov6cbw8g/EW6coR2utN4g7ESoyCSeP6J0ab+2IIpt+VRtnvCGYPMrBQsP0O5q+5m7N7HAfk+afLhwy313cgUWG4tVZRUe5rzcKmBR7kT3QclS3DO7sr2y/kBdYkNzRLwRLejWVSpRURyIv6ce25IQtdE5SDFhpUk9JvNhMkQlEmOqngtYcjxtjDhk/282eoooF2v1gNuAVkyi0E7N6b4CPG40SKrDZ9uSPc3KDnyScJ7F/iowPf63AA9dXQ39gSzUZkauQrrGcNgID24BtD4AZLutWlF42w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=RD1chOueiSYgdL+yhRNZ2ya2aomV91AMA+TFTXyJSBCbI1sR23+J2l8EBBHnjlOhfplTHclpxLnpyePmeuzRBZcGCadpgE2dpbXRpaLlisJc+cHKhvfjO+jjWMb6p7/q/ndREpO6fV8fJD9wKkS7ZsdM6B5o3SFDmRoYPQrtzEoLK6eHrdb6OmritDYoMVs9Z+nOG8BDCMTLODQH9VQX0maFTdH+G0OFVBuMkgjGdw012EEoSOxegP3ma3pALLksmR1sMUSuuVBRoHa6tA//gxigzUNN1WXroA1OeHcrrHvTtTAXVN+K3mLHAcmFbbly2iv7D831vEdKGnNarpL95Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=V6lnYyyNOodIGS1T0ng/WbX7DasfRmQHYwTqjFEXbedAneoec2c+/bwv3w+WN/USy5w/FPxdPEKYz9h7a3Idgjln3LNK7MzuRaA13OHsE/p/KNQF8EnRi7iPpgXGiRDikmK+F0Kqffw7wzpFsdJVp5w9nWpBT95WXqJjgNiSQkw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH0PR04MB8162.namprd04.prod.outlook.com (2603:10b6:610:f9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 15:22:41 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 15:22:41 +0000
Message-ID: <7ca30e9a-d0af-4f22-ae19-00645f4b7b3e@wdc.com>
Date: Mon, 26 Oct 2026 16:22:37 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] btrfs: introduce rbio_nr_data_sectors() helper
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1792661955.git.wqu@suse.com>
 <0b7f47fcd021a6cdcb882cd4a6e49b61e4a41c98.1792661955.git.wqu@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <0b7f47fcd021a6cdcb882cd4a6e49b61e4a41c98.1792661955.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0007.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::6) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH0PR04MB8162:EE_
X-MS-Office365-Filtering-Correlation-Id: 96c459c8-f18b-4760-2cca-08df3374f9c4
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|19092799006|10070799003|4143699003|11063799006|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 6Nlwd4rAh+T6avEH+ev6OOu7l5SggZJw3szYK/lwHXR+/V8yZsrXoRYCOn+aB3PLQ2GDjgJi0qT4Oi7eBYZKI2M5SvTmQKduJfCmuhWEJGMEcjhhGcZVz0lJXYZim8JhAIS+5+e3SSuGPutFY2NsALpp1PB4M7Yb3w/T3/RvhEA83t+6H62a535VXv0RHWPfSWFn3m3fYY4c8RzYDOUXXHIlikg5GxpYYtuf/WyXcz+UtwvP29vQmCQ5lT5JtRomv5XotW+Td/Sq1m95ju5WaajMy1RR+QB6eN3Gq3g79UwmZeRROgz88DL7/QqBCQjHmyPyob5+Z3Uojb/VJx0Z9aqCazMZXkJcbDdHQa9mtw9Ve6VN/EsxZuarupT5t0C3uJD5/LhNx4UEY6fY5BQhAa7HhRJj7pHTwZA0G3+rc6rBdI8bHVoE+9u0kY3jxNWi/IUEWXPnfYmLbXQn7mgE+2a6a98AxMTF6haoHpKJBEgUkYQ42Bp2S1N5+dvIPutHBy8dPWhGnoWKJv9io26qmrr+c6x1rEOH2uaGYENjCecEc+WbylJbpXzPuwHf0lSYrYRQfaSfnOHt4QwOWpTxiF8zuJs16gRBD9k2N8o90oJA+caOqiP1wfTlY1unwbdf/QkBxnszZX6+5ul3qn4iqc9vK25TXu2XPw1+unNYBBU=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(19092799006)(10070799003)(4143699003)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?Q1F2WWp3UFNlcWZxRHRpZE9nWnBaMlA2Q2NZU3Vwa1E5MCtBM3QvQkorU0pU?=
 =?utf-8?B?NFFNR0c2OXViTTdMNklabzY5NllmcWs0Ni8xOHNUbm1GTVpvak9YUnpFeHZp?=
 =?utf-8?B?OW83ZEJ1TlJoeGpUU2QvYm9kYlhCcE5aVkc3TU14QnVtTGNBc0kxbENPeWg3?=
 =?utf-8?B?MjVzMDZpY2RQUThmY2NJKzRKdzFUakx0cnNlZGorWktkOFZVcFFKRVJtOG9S?=
 =?utf-8?B?YmRFdEYyeFZhZy9XSFJFYUVCdldQbGpSUkxJb2FrL3hoREJ5dUE4VERGSTVa?=
 =?utf-8?B?TDVKSEUwVDVGWUNIMXhEaW5HL2J2SHZybmhad3J3WWdXYU95SjQ5cTRFd0tq?=
 =?utf-8?B?aDdaUk9nZUZDd3lhVyswZkxWUmxVa28vMFptbHFoVnp3dnpGQ05RUjBOWnlP?=
 =?utf-8?B?b3dQSXVuVHBSeEdVbFMzK1c5L0ZaTXpWUzBPKzlIWmNoaEl1OTgxVVBicUVU?=
 =?utf-8?B?dHAydUFhL0JvS2tTZ0lpSjM5WVVZemZHbjVnUEN0QkFFdzhuZVZ1M2VRUkhl?=
 =?utf-8?B?aE9lYXVGVUViQ2l0V3hQMVpJNmVxeXRWR3dyazFHOGdzSWFTK1pPVXl5WW55?=
 =?utf-8?B?bnd5VGtIWks5MkxpQlQyc3lHZmo5cWFYU2xKZjNIY0syY1ZJVXJGZVdBVHU3?=
 =?utf-8?B?ZGF5ZTUvdHBVK051SXR2dVZvaWZSMmowMXI1QWNaYUFkWDdURWsxS2FGZEZR?=
 =?utf-8?B?WmtvVE1kOTRBRlZOMTkySXlvT25WOHNKaW40T3FkalpVSm5Ha1pzdVpLemZM?=
 =?utf-8?B?Mno0WkVsQWttRnA2Kzg0RDYwbmJwUGhDYTc2cERDQmNvclZjUTdqbnBwUnZs?=
 =?utf-8?B?a1RRN290cWxQVDM2cjFmT1RUWXkweUlIdEhnd2JnNFR0VnZJR1FqYUgvL2N1?=
 =?utf-8?B?bWVzelZ1NklqQzhQeklQcm0yejBWdTVpTkc3WkJFUUNiZ3E4UkVkRU9oeklz?=
 =?utf-8?B?S1c1dHpBd1d5VXJheFh2QzJ2eEdEcklVbXM4VEZ1dFRlNkhkMkJDQXJrVXlu?=
 =?utf-8?B?RVRwZFg2U2JMeHk5NElUTy9UanFJVkthV1g0cy8xNjNpSWNXSXc3QXFscHh1?=
 =?utf-8?B?L2JqY1p5MWFya21DWmtHeEt6L0VXUlF3aFhoaHJXVGZFK3U1NVRXQS9MdmVV?=
 =?utf-8?B?ditwUDkwTXUyOWVGd3J2M3pUbXk4WWFkODJZS0VRTWw5SU5lN2l4NHFNRk9M?=
 =?utf-8?B?MmNoKzV3NVhueEM5Vk1iK1Y3NnJLZHpFQzJMdVlBOGtpbzFtNXZBQm95Tm9l?=
 =?utf-8?B?dzJvT05IejFRUzFub215ZmhGeWl0WDJjeWxFeHh5ZGxRZy9yYmFsS1NxMlls?=
 =?utf-8?B?Y3QzOThLYTRIQUZXd3U3VExpMHQ2RFJQTWlTYTNGbFE1L25GNE8wYzJYcC9z?=
 =?utf-8?B?ZzhHTm1nNmI2U1M5ZTVxZFRDTEVvYXhsTXcvNzJ6c2NJMnVEUDFhZHVHUE05?=
 =?utf-8?B?cGt4NE9RYTBXN2ZzWU1PSlZRbWs4d2VqQVZmU2ZzMUp0L2NpUHlNRFZWcnIz?=
 =?utf-8?B?a0h5eU53dlZlRVhuSWtuNW04SUYxZWVhdEp4Tk5iYjkyTnJsWm5aS0NnN29h?=
 =?utf-8?B?dmNKV1RFMmpBV3hwS2crOFpKb1VWd0ErN2grTnZQYWNYRElacTFSOXpScnRP?=
 =?utf-8?B?REZybWZXeEY1WUh1NktBOTRla0Y3OW5ldXFCNlgwZ2pQZXlwMDFZZ3c0R1Qx?=
 =?utf-8?B?UnZvVjFQS2o4d291UWNBWTBQMVFqdEVhb2E3TlhRZHRubllMd0NtcWM1S1FU?=
 =?utf-8?B?djUwbUZmZVFjTGdSYzNFNjFaSi9Od3RSb2I4M0pYd0hBR3NjVXE4ODNadUhZ?=
 =?utf-8?B?T3Jlbkw4Z2hhNnE3Vjh3OU0xR2NJeVhSNWZzWENxWXdXOVZxVkZucmlZeXc3?=
 =?utf-8?B?dDRZRDlkL09KalFZV0NkV2xxQlNhZ2FtYmlld0t0bnUrZkVsOVNXbkQ4bi9i?=
 =?utf-8?B?L2x1emxLNFpvb05HN3BmNGtYTjlNLzVpT2crZjJFcVRid2lTYllpbHR2T2pj?=
 =?utf-8?B?eHNXWW9TY0RmWlVsdTMvUit2Y0xSZGRFcDlac0ZFa01wYjJYYWNqR2wveDBx?=
 =?utf-8?B?NGtUOFFxVmhiZWRnRGVxa3pvZ2FBTE9ORGJnK241b0VEMnZXME4wREtRcUdL?=
 =?utf-8?B?RGRoeGFMblZOUFE0dzg5N0tmbldLYUJOcjFSYmhYMUJqWWs1MldCMkZ6M1pv?=
 =?utf-8?B?UldkVmRZQmpDNkd2Zk95NkZEQTdDYUZJbFRic0R1TVlBY2UxeXV5T2l5eUgr?=
 =?utf-8?B?SklYeUEyUThWcUdnOGZGVU15czJoUHQ3TzVsWHBNd1p6MVJocHN3MFdoZ1RE?=
 =?utf-8?B?SFBkbWNjaEVzVnh6cy9wVFpQYVZ4UXgwakFMdk85b3JQVkdVUC93bU1tdkVq?=
 =?utf-8?Q?Zxf0wKjWcL/3UDOCa4YLEjlVPjF/2Nz1PJwST8iOhTaz/?=
X-MS-Exchange-AntiSpam-MessageData-1: 0fk35ZgF9LTp+A==
X-Exchange-RoutingPolicyChecked:
 fIicwXyCKk6DPR+pLDj+cYCVQ2v2NJDp28P6AneZFDpbpAPjgZljjxd8BczPGVi1+n01Og4FeihNrw948ZNyWataJAN9QfVIunokC0fjOvTBU4PkUxiuMDsVOMjfy+Tb9SKp9gl+d9bZ0C73wXIADMbK8zIGGRnpmJ4Y85JOvcKKwoQIrNy6Vhxn1u5ZNIel1069nKhWXL5o/EF1/176P7IP0kbMBMqjjX9Bms2BjtNhdTWHeLR0O0gG4zgLHjsjM5QqxU0J92PAtdsjYIPeMTfs5bydMXLWtFeMkCtICQW0PfUR6afF5JN/DU+WQqoSfBi6jiaPB0Ru5EiNWbH1FQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 vxbwTNV125ObkJAMLIdIcD1lkj5wClTcJcq5+BHRDLZ6nCSJ115qSq3/8XtTL24XiU6ZbKQvccLHsTvZdu58jQQJisVXdus4CZ3cL0aH/NWqUx1pmep6Mbu9YmDOgGKGvoeCUGzoQTRpdnGIcodwkosfCjx/5aam5jPbw0X6Y59+6KGjly1Ylk/8b8UhO5ZA9Qtj8NkdHK/MtaGqr/W7lc3f3LxCEDZRAvADWi3IhACAVtK/2DyIutmZEcczPmBIH/1A2xdMGYrBn0BZfr5+2E4FPgJoqK4aV1a2JIAUqDMiCkxgmCZGVtsZxQrUwIJfk76YQj/Bzon6m3DWnYoAwKX4YDzsdt3Os+XSeeiu/EwiFSPmLu9eRbG+9ELujDlLCAhPj8UXFs4dzBbskzGQ0j/a+LcnqS7ia72F0OiCit3vUOJAf4kNWrp0TSSPPoYU1FNF+wrirJLz3u3WQRXmMvPWJTkGOGNbleDsZmTP++vrcNgTw/kAx2wqbtK6Qv7ryCsbmS4/F/qpR/dqx8jSMlhgxZ39OZ6mRsQ35y7fvCIMSXwZ3cx3IO0cmFbQ4yFkhJ/7oGw0rIc/XLoaOMlrneg2oyqgiw53yDDbqUWs8PLKtepHit0gQaRbcY5U71g6
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96c459c8-f18b-4760-2cca-08df3374f9c4
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 15:22:41.2099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +xYO8aMjPyKzSqoSRHJncyrwLZKmCOeRgANiMvpcmrjRPnUEEEdb9ziOKwyxirDuXwOtcWrKXaR9oNsTQa7fLIE1fNtGsm6nRwFnQQlMTnM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8162

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

