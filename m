Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC2D3A5422
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 10:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782123796; cv=fail; b=b3T2l//7OjsExAInCtnFARagStKvIhCYtyJXYZGoxYcYRwbXulaahgBLFy7EZZYzMZ8U4TxSF4oInR+1lcdtaM4rmLBiSyBwunwQ86LoJ7mPcIks/a73Vr/HqYynkN9+SfGaghTxg6H1zZZb0GHUHKJX7PBoEo5Wf9FxaoMJuF0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782123796; c=relaxed/simple;
	bh=dNz+DVo5e6bZMFayJ9xjv6PAfTaKNnTccSI6gFYI2L8=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DjaQDp9mIcrOxVgvfTEUlSet4i00hiZ5Tu3xeegWnDeThQIo5MwmyeTmlRLxjWl6aK2Wn6bXs3xkzFNHBua9Sx/WUCep2i2xu8WrZrftNCE0lNBoftkp/uqrbqKF6Af7X2yZk9WIh7zSDOjjIkUR4QiObfcGqa9JhZsj6au0qZE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Y3+2PV+i; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=MVWnQSBI; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Y3+2PV+i";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="MVWnQSBI"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1782123795; x=1813659795;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=dNz+DVo5e6bZMFayJ9xjv6PAfTaKNnTccSI6gFYI2L8=;
  b=Y3+2PV+iZkrIUUIfk6S346aiF8WnpHxnuhvCDtnsRQet/7QtTKe7LMBM
   YxL/N8+4gU0wZfi3c6+AYqv9JmLsOZeWfQcubleGd3SoILcq0Y8T5jEMz
   DLVmKy4vDD57hqNPNyTqN7tG2ejzBhog5Y1UnQ2wI5UDvJfJzK+Oarmfl
   H/5jyWfzVT2qL0F18Yk95PTPCWKWmiC1llw9YNItdpNOtsXCSctIr7D+G
   5ukf6q0unOBPk7E2mDtlTAexjt0OWUAIguOzdkZve35BgnuQyenCOhGDr
   PLdzHzHAgloba2wHwVWK1rvzSuqJwJzrHyPGowWEBUQztfMxgIcpZBS8E
   w==;
X-CSE-ConnectionGUID: YeNF9pkKSTOv0tozOx6DsQ==
X-CSE-MsgGUID: rSpSTS2tQher75m8z9wlLw==
X-IronPort-AV: E=Sophos;i="6.24,218,1774281600"; 
   d="scan'208";a="148080820"
Received: from mail-westusazon11010038.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([52.101.85.38])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jun 2026 18:23:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fIebjTPPwWY+6AE3CDJp7bcsjH+wW9fzDkhWzFYNaQnPR0AlyqMFMH7x0BmXyoKnqN4jHU5WYra7Myg0PooamCpc0ufpXeMR+cjb+ophX0hqsG2ory9Ut9Dpz5iYJ7nsdK/oF1rJtRWTh6EdcykEBS7TVpNE0J+A6YBn7YQuH7mk45Vh0ojC64d7c3SuA2Bcp4zOv10ZYSxA7p8QxdqD3uhNOS7leqg9DaIpZMPCacN5v3KqvcQ37TP4t/nuKMySBSA8dIogwMVcYjkB9qgocd6fjsTumHC7t5Ngj8MESL1A2ofPT6Hrg4eRK+mqd8F0xZGiRmqfz+QmZ+Z4ldGZMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MF3WoKFXIG5p7A+v5yrvBfk5OvNoYKZlfT1i6hz+NfY=;
 b=osyc2HzYOthhe+F6AnVxhwqlUUvMe4Hp9RevT3dPUWXYYAhIt/JGZ9u9BC2RIwb5z4FiXZpp46nowV8ia0TVocJyH12atZhTK70IRv6JvOX3cTIPsayo08JQrqNy6SSCer2iP6P11E3Y8/c0be+zSRQeKJSNESwmal0x9eRGrm4wS/en+HXYh8qH/thubDsnIR99Ml+qvso92kslQitwX1JqTe49IxkrZHZAYurJ7aYyxd6SIA1lU39etlTvBsmWAn/CilTqnYDJACp1sHrkzm3MTcIOzgG35mpXsRpVgGKRcalbbFSgS2cMBVJwGt8qOZ/TBAj+pp6oXtScC34pZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MF3WoKFXIG5p7A+v5yrvBfk5OvNoYKZlfT1i6hz+NfY=;
 b=MVWnQSBI4zeCSliheoik39Oi2sGAkZP3EcXwXOuSeke6JugebGOK6n236xf8PidUwxN9kFGXFwt2gdvTjI8+86DUHR5Xr+zFYnHcJiOXfIlrLvMcMhjA1MQ/JB52ZDDpFl22e4VbAVVDiHqNiw/JBRmh4xROmW4QWijeIq0cDh0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA3PR04MB9004.namprd04.prod.outlook.com (2603:10b6:806:396::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.19; Mon, 22 Jun
 2026 10:23:07 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0139.009; Mon, 22 Jun 2026
 10:23:07 +0000
Message-ID: <b436c427-1d87-4c36-a159-0f5c03619771@wdc.com>
Date: Mon, 22 Jun 2026 12:23:03 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 00/15] btrfs: RAID5 with RAID stripe-tree (zoned +
 non-zoned)
To: sun k <sunk67188@gmail.com>, linux-btrfs@vger.kernel.org
References: <20260619090211.497100-1-johannes.thumshirn@wdc.com>
 <CAAuSuOqD+=nHVZu3czFe5JfQ3m1RDt0sWibVjPZdh4HeOom=Fw@mail.gmail.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <CAAuSuOqD+=nHVZu3czFe5JfQ3m1RDt0sWibVjPZdh4HeOom=Fw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0365.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f8::8) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA3PR04MB9004:EE_
X-MS-Office365-Filtering-Correlation-Id: a124a77a-4b5c-4c08-ea7f-08ded048407a
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|19092799006|1800799024|366016|18002099003|22082099003|4143699003|11063799006|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	2dmabNwMHhxOZyLSv34fKg37lVv8zRPN7D6vT4/OuHobJ9q117SJVOVze6pcs0I4jNCU13cpenW9oeEsCU7Enrdncunm7AxJ84dbMyu5tNTk5eCsSThNy48X7380lHGeIwVnhpUsfwLx/wdpH02K0BzD/+yAJEH2UyMzcj27QmdgLNv6scRLq9cTscTCNpJDwgtlncCYbNGUbO5y48+7TMDyjLE7k/sVGd9mNTikwTMLHiizNWkchVj757uBNsD0ZOeJgFYzBnXYt0/PMozN57zFVByMmwSD8daEChpQl7QskZAaXMRoQB45GOr1x9dEJ/J3fwuFs8rQZWHeMZIfAYYwFLXeqpURCAg6xbGF2rSxaAvWVD7NRnxOCHrLGE3L5NyaVKAXLEfGRbtRH1EhmpP3gV1bSkbf691pD4UF4EEuQmSrKpVCg5buDgwfk2uhXM5dDxke2aw3dtan+SZNMaBWRoCabt7wKyyGMeCgdi+fNsVXGZ6yYIMKO1bZ88XTJOSLf36nKiPA9JrUcwRcVQHkPxcHp+JKVdbDcCj7HepqwBIKzYgspUlClJyfxBeR9Fc1wsL26bl+X82A88j24cy0J2+3k+3FKSIozjcH4g8q+TYTlhzfBg/QdBfSJKvy5I8v7XeUNVfiPzvlfQ+sp7fuTSaMRGtr2STHREpF764=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(19092799006)(1800799024)(366016)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VWpadlVwWFR6cldlcDRuczlIRFFENXM0aFJ5NDRoeXU4OHlFSUIxckdwcTN3?=
 =?utf-8?B?QWdBajhhMmZhQjlQNUhPUndxOTJNOXBTMm1NRmF6aTdXZTFKWjJpQnBNcXNi?=
 =?utf-8?B?YzRRbGhrMVlTVDRicE9OMEgrcmxYVGRjbHdSeG9HalNDNWdaNThJS0RCMmZi?=
 =?utf-8?B?TWg5RVVNUG1mV0c3RERFL1RKZVFHZHlOcVY0WTZOZWFrS0tvNnBhd1djRjhV?=
 =?utf-8?B?NWRhc3laOWpYL2hHUFk5bXNJOGxDZHF1TGJxQklhN1BWR3ByRlBtZ3lvSkxZ?=
 =?utf-8?B?eFp6MFdPeCthZ1BRc1Z1VHMwUWlHVHV3T3ZmaWp1WG1FVTdYcXUzZm11czdM?=
 =?utf-8?B?WXgyWmthci8xZk5FK3hJaDNhMlVZUDJjcEZWUE1jWlY0Zk04T3dONWVKWTJi?=
 =?utf-8?B?cGpTWXBPalZROVA3amFETmpwc0gvdmJadXY4K2Mxb0tiQlNkMkppUU8xMzVQ?=
 =?utf-8?B?YTJiKytVT1oycnUwSEd4UG5LZnRxVU9FWkVTZ1gySWFodUhnZmpHRERtT0Vx?=
 =?utf-8?B?RU1uNHgzZ3VnTDIxd01sVUl1cExXNWpwRCtOTmdaaks3bzU0VDlIeDlkaGRM?=
 =?utf-8?B?NVhoN0RjRXBJM3o4VGljYTFtR3UrQ2xHOXpBL3g5Nm1ybUhyV1REdVl6b0g4?=
 =?utf-8?B?UnRrZmVJMmE3SGlkTkJWSmlpekp2M2w4R3l6NWpVdjk0TURza3dpZHN3ekVV?=
 =?utf-8?B?aGpVOWVId2pja0hVTjA2OU5PT0NuZWlBM0lqTjg1SFBMeDQzSG1CV1QycEVu?=
 =?utf-8?B?QkFhY0toZTU0THhQQlJwVTNvOEJ5cWFCK3dyMWpDTXFnRFdVWXFyNll0RU1Q?=
 =?utf-8?B?bS9DV0pUMWJiRVVyaW9RaXV1QXJLdUlkbktVWmZ4UFdQam9GVW85a2JINy9v?=
 =?utf-8?B?UW0xRzFjZlVVYWhadFBNSnlaNmdjdkRKTU5ycXBTenRycUZxMnNGa3E2cHJ6?=
 =?utf-8?B?b25XOGZsK3NqNWtsYkZKdmZjTE90SGNXMHRUWFFKRkJqSXBMbEwyTW14R04y?=
 =?utf-8?B?R1lacER4SENVY0pwYVZacWlVRVZTVy8xeDFxcHE5QmE0bkFHb2orOVI0OEJ1?=
 =?utf-8?B?dkhLVFMvclFpODFPWUd5WFh1dk8vVS8weU5nL3NnK1RFMlVSMUJZd25tYjBY?=
 =?utf-8?B?SWZ0RGxQeUdnaytMcmlaUUkrRDRLdFErR2VXcnFCblFpdnJUaVpLWGdXb1k1?=
 =?utf-8?B?Ti9KVW5QMEVxbTVMSGJBandMTSs1TUtrODZWajVXcWNoelk0R3pGRk9wTDhm?=
 =?utf-8?B?TzZyK3NTMDVERFhQZk9GeU5TaUZTQlN5Q0l2V08rYlVqcTl6VFhseVhzUEIv?=
 =?utf-8?B?Z3lwTmRNTVBCQXVRaENNMEU5VVMzb0VsTUlNNHdoWGs4cnBWZHdQV3FwTUtz?=
 =?utf-8?B?K2FrSlkxbjI1WmYyR3N6OE5SOHVEMWZRSDFBdk1aK1pTWnpZdmJuajdWallq?=
 =?utf-8?B?bG9OcTVBNG52czR0S09wa1hXaEtacjVObWdJaGp6c2MrSTZ5MCtjNmp3VXNT?=
 =?utf-8?B?aTVTTGlrUlVoZG9CTWxiUmx2dUE2cXhKMDZqb2Jaczd3TWxSbTIrTU0vVVpt?=
 =?utf-8?B?R1UrazhieWJpcUdLR3QrMlJRNjYrNTh5b1poQVF6RXNZN2w5ZkJ4eTV6VGQx?=
 =?utf-8?B?Sm9tZnVEdzREaHBYSEVtN3VyeUZxOHdXak1qeXJxU0Q2dWlBemJRRmRQUmov?=
 =?utf-8?B?dWt2b1MzL3N6LzY5STZWWmF0T0RwYWxjL2tvdlAzWmZOT0E2WDNqYzJ1Z0JI?=
 =?utf-8?B?VkNSYjA1OTJjVGZ6N2Z1bDVHbkF0ZmEvWUxSMXZUMWoyZmRwN2JhbWhpVk9T?=
 =?utf-8?B?bnNha0RDRy9VMWlOc3NKQ3l2VzlNbTBjb2FIVFBrd2d5SThEMlZpRGZNVXhL?=
 =?utf-8?B?L281bW0xTk9IYkM1RUJNUW1LbStHN0p0dDBkR3dzYTBsRktKTWJlVXRvUWJh?=
 =?utf-8?B?VFpIKzhmejBFL05zSFFxVUYyT3kvV0dOaWYxUVNZczdXNnBYeVgxQzFDWFBL?=
 =?utf-8?B?TTFGOWVlRXV3MUd6aUdDay9DMFpvN0t0WFNxbmJ5QzhYbG8vUU1maFRTTjJL?=
 =?utf-8?B?TGpyUmV6MGZIbithbUo0SGNqaXFYVU1oaERGQkY1Rnh1ZEJQckpsT3VBNTl4?=
 =?utf-8?B?TXZiODBraVFSVFkxT1F3YjkzeWFVRElpUzNhbWdVVDJ5WFBhL3JqWDZMd2Fs?=
 =?utf-8?B?SGdjQWxXWUhzU0NlQmo3VzJaaDZrYkpwVUJJdDRRS0U0aWxLeDE2aDcvMSsx?=
 =?utf-8?B?N2hlTkdyNFNHcEdDN2h4U3ZJSDBCbE91aFlvTksyQVZyM3ZQTnQ1c2p4VHFs?=
 =?utf-8?B?eC9zQUlnS3NVOEJhTE81c0QrRm5tNW5YeTErdi8rL3h5MmhMZXdyMHRhZXU1?=
 =?utf-8?Q?eH90ZJn+OSAdGMsg=3D?=
X-Exchange-RoutingPolicyChecked:
	YyYLWQhM7/gn3EbDMAJ96JvRBu8Y7GLK4qjgjDu8bhbA/tFGInhwpHvv8+1ZNZRDt8IBpMICHuun2cW6mXXH+SBdU8nIASjsIJXTyMKq/Y662Pah9O8KjBy95r5jq7n/sl2AfOkt2c3LYtR5Xhy6PN+FcqYHOcN+IDeRpfFc5KUpDW57gT7Bz3piLbSujiSzfnk5Gj3WKHbCe5WmF4tT7b6gYbPYn5Zpl700rRXMgBlkqVi/QJ5FjqMXlKDlzhmZwk6XS/hyLLKrDDuLdHSs8wd/RIC08TftwL2bvmTeJHbjoeJ+wa3vXhgKHsp34IEUUfgbLUuxM7QrbJwk9RAXxQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ykPRwR6H6WpmahKg18Vn5X8wyG8QN2un+C2RErhj9hDEZ1YeS0mIHtXPtnCO23/4VVoyCuPtNf9DyahyW1ZOzRZeoFNOu3/fAsVMPLAcP/MYTBbiMVALxrYmSKew5Zmr0pU933fda/z/1hxMoZBZOC+STfYizyPM6C38ibPZEO5NGe41jFxgD1NqcRM/voN+oYKhRV21t07Xo9lIacd9YXrQIBiO0/7VU/oAOg/IoU9nMds6oY0oFKyYXZhidVNN5hcX1ZVJclFZZX3xq4FY9MivspQRvaiTRiBX8f1e4GiN7x6SvF227UtbD/e11GZEBuD2y8hMkbCdMvVLHSVTJd70ge9QK62jqYL7+PdXbcLeNiSEiemAjieipw7OGYqFoRnkY9na0Cngo/j2u+6PqSDswUMwSg5esJrgRB0BJnDxVFDRBXssR+lXoyW1OQMQDnXqjZegqmGyY2LtDcL7KtFTzh4LqiL/ASxqaM4z8owAR8pWBjXnZ7b55QNID567ThlbzaiRWX/8NeG5XvANvMSIo4aMUEEzZa1fkuwWMqNd+ax0Inwq16cmW1EQwPPIzCX3LGz/jRTI0CtDAYYpZNJAoOgkua0i2aiy/tevNF6p/GrZ4HP+uLSlBpxliTsN
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a124a77a-4b5c-4c08-ea7f-08ded048407a
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2026 10:23:07.1961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DZxdSrQPEODY5WiDjpAsjB2ite6unfh/DzXq3B+CyIHmZqY87Ctj+0rPHqczcjc8NfV0xUkca5yCIWs6rqAnU0TjuKvfFq2Pc57DwfeDJZw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR04MB9004

On 6/19/26 3:28 PM, sun k wrote:
> Hi Johannes,
>
> Glad to know that you're working on btrfs's raid56 and raid stripe tree.
> This really a big change and it will really take me quite some time to
> dive into the code implementation.
>
> Before going into code details, I take a glance on the total design and
> it seems nice for me. But there's still some details that I'm currently
> not sure so please correct me if I got anything wrong.
>
> First is about partial update. With this RFC they'll not updated
> in-place(overwrite) anymore, but use a cow method instead, which means
> ... we'll write that data elsewhere on disk, but still share the
> previous logical address? This will change address mapping for a
> blockgroup while current existing blockgroup profiles will not change
> the address mapping in their entire lifetime IIRC so I have no idea if
> current free space management things can works with this.

I'm not sure I follow here. This is how the RAID stripe tree works, it 
maps logical to device physical addresses.

>
> Second is about the new key type in raid stripe tree. It makes the tree
> search more complex as we've discussed before. So I wonder if it will
> work just putting the parity stripe into RAID_STRIPE_KEY item, and using
> the last 1 stripe for parity on raid5, the last 2 on raid6.

Theoretically yes, but who's guaranteeing the order of IO completions 
that trigger the tree item insert? So that means we have to build the 
stripe extent upfront, then submit the IO and then update and send the 
stripe extent once all data and parity writes are done. Otherwise we 
can't use zone append on a zoned FS.


> Third is about the partial tail. If we have 4 disks for raid 5 setup,
> and the extent only fills one and a half stripe, how will things work in
> this RFC? And why use file size to decide it is a genuine tail? I have
> no idea why it makes sense.


The file size is purely an optimization. If we complete an OE and we're 
at isize, we know it's the last extent regardless if it's partial or not.

> BTW, this might be a little off-topic but I've just read closure.h
> recently and I wonder if we could use that to make bio related things
> more readable and easier to work with in btrfs.
I'd need to look into this, its been a long time since I've looked into it.
