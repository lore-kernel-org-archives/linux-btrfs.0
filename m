Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5CF30CD9E
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 14:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776956083; cv=fail; b=a04y58x2iOaqftD1QyxrqJipXIcKcG5r9lqRCf9cTxOCUNhgOc0wGWKG3eg+SHCnEfEQnrNuF1Hmnocf5tu92RnjgtzaLz4JYe6sPO3hepsZJQngicQMDxso9ejUeKEPbAvcdskWCmsIv8A9L2T4FgWzuJBlhcgMxThD/2OkyEo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776956083; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EMAW1pv6pRirG0Vl6LQQSpiZcgF88D5OiAj+0WZh+tRONgIdSQRKgW7YD+OkC05GlHz7v9bw41g4udagzu9FWxY2hs4k9RriUzw+ov1N80rDbu1R9eofzg9OccnupCcdMGwy+t0xApYQbZf7IwchIccTszqE64qSVvbvkBIQ1cs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Hyp7uctO; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=GC4otDqS; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Hyp7uctO";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="GC4otDqS"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1776956082; x=1808492082;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=Hyp7uctO4Qo/HJAKA5xk0JIVMflC1JH8DMdgl9HCI5n0Y9SVIUpeU7h5
   hbhM8l8RHfz2EgnHZM1U4n70y8bQmJt5Hbmh6A12QKTJ42FYQMwULoHPH
   bbZBR1T6DQHEXWF1WBnedyxS/ZrJyC8Em/VSG2FQ4smPIM/PqyJTQyd2j
   iEQT9pL+w2FXzBaMrlcpiJWCFNPVgLCt0t95xIcsgcUCY0GDAGNelfwXR
   LmfMjRQcoe2nJuSXPQUyHXQX/RezHDKnb2C+Iz5hkxFdW5+lCCPO6zNXh
   o2inEyUClTeM9XJyyOaNTXw3OsYLYt2/UzElU7xoW+voZA/5RHkWOy7Rk
   A==;
X-CSE-ConnectionGUID: +V1B/DLlSumNw1+2/iBU2w==
X-CSE-MsgGUID: JUlMOTaAQCigPY6Ok4kjbw==
X-IronPort-AV: E=Sophos;i="6.23,194,1770566400"; 
   d="scan'208";a="144612325"
Received: from mail-westus3azon11011006.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.6])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Apr 2026 22:54:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g/CEAUGawCBAdei+r4MFchINRCJgMrQicOoyDkSdXH+p/Y2AarCcaDcckTOs4OCQbnmImRwgXbOrGZnkr7k/JjsenNrEDM1nVCS8EkhqLhAPL2ZB2EDznEfIDeHrtMCwYVCjsDSmXX43hjcQQnM1C/ndKikWG4zBAAlywy+QO57Ujp4A8oPGa35r+z+DbUUev8CQOZeToCoR+o0xH7VC3L4mFvu/MrtaEHb4XTFcP6dPqkmcRAnbW+XrcDGO8sIHtTr21jwpMX7chM2svzj0TmTo23+w8uSXQ4mIW3y4TkRh4T3+sfVk92y0uI+XHuAz17NBYb0FAaHIAVhbvfTvQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=VHaCGzYMLdR8udjHL9ivzGsB1ZxiElt8hXAYdCS5zZyIKizIe2qcHmLDgFNb4cAbgwYNvqNdvD4Zrar4kMTngjTE40USyiQR7qcIyv7wGCLet23Zf2JvVTGd7yCPLb5kjkOAqPQM7H1lYEjrZDcRnwrl2Zt6lv8eOiOx4d1nagh9l7Zmp1R0LPLISfxl8FQ7HupL7xYFT9turVp4mHslsEbR9vamNFY2FVO/T8wTqeGybOXTzL1DF5omtozAILi/crfNKl2p+Ya7rYWktXFkWWJzOLrOL5X1miJTl3FYyRkAI50xoYwkwRCOeU4BUcp6e4bOZY4qceDj+gcNZc5oIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=GC4otDqSx6jZ2Tyk3KfkO1lxLW9dD9sj1EWY3j3mLJ3VDbpsG82KJcYV+xImWhQiWCcjtEx/s4KmSnVqfPmJX2esA8rlOORgyhL/QWjbByw8w+5WtRR3BKSYu9z8TcS+gTWi6GGnHmprq5/MPJD96tnMLAY+4BioA7/EStoQLaI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13)
 by BL0PR04MB6546.namprd04.prod.outlook.com (2603:10b6:208:1c2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.21; Thu, 23 Apr
 2026 14:54:39 +0000
Received: from LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3]) by LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3%3]) with mapi id 15.20.9846.021; Thu, 23 Apr 2026
 14:54:39 +0000
Message-ID: <f89ca239-0752-4f0c-a715-0bd3d910193c@wdc.com>
Date: Thu, 23 Apr 2026 16:54:35 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: collapse report_eb_range() into its single caller
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <b2dc0f485fc063e2b666e150002f59a278b97023.1776944252.git.fdmanana@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <b2dc0f485fc063e2b666e150002f59a278b97023.1776944252.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0077.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::16) To LV8PR04MB8984.namprd04.prod.outlook.com
 (2603:10b6:408:18b::13)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR04MB8984:EE_|BL0PR04MB6546:EE_
X-MS-Office365-Filtering-Correlation-Id: c2dded37-a0eb-4a9a-f91d-08dea1483e4e
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|1800799024|376014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	/a+9fZhsWELa1V0ZED8FBzMe3Bn9c7KK0HaiXvjQ9JKZHiCMdVi9eAj8z2OBnUINnFQFU0FML8tTCU8PZdCtZzUvyT8q9VfXHa2SSYsySWS0H/p0h6G/m8WSjdJHK+lFJ2gZJcvlT8IwojZRUBNm6uVAqiyxG5bzQO8bTdxM771JXZNHRJi3WZkD5lxwGbdjFgPnW5cK1iQEcz8bRF+TntTI938048Gu8tvwHuBgEKjpXmjLgUQYBLvXbCoFWv2oolkFJrBsKpu6cnLLETvqhTF04GsfYYwkwLaOLLYv0Pfv0cZLXianryzcK1QCGpx4br+6gjTU0r07wm2LePfhZzCNQ+zuNJxlZ9ykibOImpc+hsQ03/ltlecqmjOnFI5yohDAhsN3ekt0IGJ1FG+Mk3+Mc+kn3qO0/s72THoiU9PLNFODwPSxNzhYNW6au8uF6Soj28STE5HILQcp5mfWQWYO8IFGpkQ5S0C09Y8t5CHiJYSD3Y/2oPPAjwof3nb2ia7Cl0yVTBoJUFpFqIJb166Ds9GWemhudrNR4BSAD1/WkMMYXo+Di3P+u4sHIB65drk5InI16tPupaURsALBYJ+zNXnImP0HWCR44b+WzYWVaE8tpOCbExYWOx/7Nl8Rc5rRgpfPN5z7AklVCvk9CQ5ylpp51iZSOJfx5jGvQi0PC/gHLYvqtMhCfmxoxahBcHob/VnibT0GT14l8tBlgkoGGtnsPn1qfREr5WYWdK4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB8984.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(1800799024)(376014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SnhqbXE4NllsNFM0L2xycDkycFdFenVIc2VYeDBxTXlXdTBvcjNscWM3ZnBO?=
 =?utf-8?B?WW5EdjI2eWRWalNvRkk0TitNYUc2d0hnTnZMZ3JMNk9ERGFNSUVubnZyOGkw?=
 =?utf-8?B?ZGpyZ0orQk1zTnB5eTVUUUdNL210OEVLZ09IVUcvK2xJblFMakVtSWx3S1My?=
 =?utf-8?B?bFRLZ3dLc3VoKzFjbmdXcmZwdmJnUmFkZHhPSTBJSE9LS21jNm93Y0x3cm9S?=
 =?utf-8?B?eHNVeDMrNGZPczlST3BpYVB5RzhKbjhEaHo3dTJTZkZ1WFkrdDNDNE1ac3Zs?=
 =?utf-8?B?TWZxem0vTmJXYzZrNHY4UTJaK2xhZWhyVXFxZzJsK21QQ1NvSk9sTnVoQ0N1?=
 =?utf-8?B?aDhTTTFjUUcyQUQ5ZXgxWDVwbmgvQmxQdjF2WGcwUzNqSzUyN0IwbTVsZzZ4?=
 =?utf-8?B?R2RISUxtNXMzbmtzTHZaWUt5T0RuNEt3akRmUDZDUzA4a2JCaW1pakpBczhy?=
 =?utf-8?B?U1BDUlRCNnRWUEVVb2MrTU00TStDLzVyMzEvSlJ5M2NnR1BESytKeGRITWhR?=
 =?utf-8?B?U0trVVRjUTh0SlFld09hRW8xc2pBMEJTUCtOUmg2dFNDM1FVbjNhdU1nT3dz?=
 =?utf-8?B?WDYwOExCTEl1bnduMkhFM3VLVWlDTVVWSkFCSXZyeXluOEE2NWFJdFJ0b2tt?=
 =?utf-8?B?S1RRSEZYbjFxOWZOeHJOS1F6aEtjdDVQZUVUSGVLYlNXbzVEdTZDTnVqS1g0?=
 =?utf-8?B?L2t3alRkcUhEV1dRQzFIdUY0ZDBhY1NBeThjcmxHMEN0Y3RNYWdIWEM2UFQy?=
 =?utf-8?B?N1dnVjJFRWhRbGNvTXFyeVNIMzI5eFRaUDg4eGVISmQ4dlBVVzFTTmc4UGZn?=
 =?utf-8?B?cSt3djR5dmVQZEE4bWtTczhsUEExWEREdU5sSEpRK1FjWEw3VDQwdnB4ZFZx?=
 =?utf-8?B?M0hPczUrYk9xeXpiZmY2Yng4SWRrN3hXZmhCNXZ2YVdaMHVFcm1ES3ExdEhx?=
 =?utf-8?B?ZHZiaEt0UlRCNjlkWUNoVSs0ZHdPajhFK3B0ZUd5cEtJVllXSkl4WDE5b29q?=
 =?utf-8?B?VnJaWmxubk5BWEU4dUhRMWszWkV2cHAwbENlN3VkOC9ZSmlWNFdwazBUbm5V?=
 =?utf-8?B?bE1odzNvSlYzb2k2TFdSMno5TFdtbERUbEs2NkRRTUVpallNZ3NmVW41U1B5?=
 =?utf-8?B?UU1uUmszcTN1WTA5cm95Y2FiYWx0bHI2MUdNOGMzSDBBZXBITVFLN3FNemJN?=
 =?utf-8?B?SjFkaTZodGdsWG1sTEtpNlVGVXJTRnNEZE5ReXUrbjVpZUt6Nml0MlFJNXcx?=
 =?utf-8?B?alQ0cEhHc1B2eTZOMDN3OTA5cmtsS0tEOVR5bnc0SDZoQ05WeGZXYUU4VzYw?=
 =?utf-8?B?ZlFZcHpicDJadERkeVZKREp6NFBOeW1Ja2ZSTXRqMEpPY0J6VXBUNjRJZDZX?=
 =?utf-8?B?Q3lkOGcwTmZFYWNRNWhrNVA2dHlYaFExcUhrUHdGR2NlbjFaS0I1aWtJSHRV?=
 =?utf-8?B?ckh1RFVEN3N3R3psTldhV2FRTDJ5cnJoKy91MEhXVXBzQUVJbUZ4TkxDVWJS?=
 =?utf-8?B?RWxUTjNoWEU3SXllZnFULzdreEFsOTZ5Wlh2b1grQngvdWF1OWVIWjl0WDhx?=
 =?utf-8?B?dkZKZElGRFlrb0MxR01wTGJQMHRlSzJpVW9WMzIwcFp5Ly9seWx2ZGt3ODhI?=
 =?utf-8?B?bHNvR1BHQWlNczFmOFVvRDFmYmRDc1hKL3dOdkU0bkNxeVFaTW1pclk1aUg5?=
 =?utf-8?B?dzg3aUYvRCt2VDFpNnBnNUJqRC9valo0Nk13akcrcVdkZUFvc0paUFloWDNV?=
 =?utf-8?B?L2ZCZGxoOTRPQzNFVmNCQmpWZHVsR29acWRRMW1MYk5VZ0tycGg4d3I4TEZR?=
 =?utf-8?B?KzMrNmdDQXpUYVNTN014SWtQL2o1Q1V6VGlOR0hobFpibFlLeWRCdE1HZnVZ?=
 =?utf-8?B?NEozNUo4RHM2anppMWdUNzFKUkUrd2R1azFIWkp3TWY4cWpJbFZPdHBQMFZU?=
 =?utf-8?B?cmFBNG9DT1RxdmY1QVhrZGhOYWE4RDlpdTF4bVU4dkRSVGxYMWtSRlZSUE9M?=
 =?utf-8?B?dS8zckdyeTZ6aXFKUXVBUUVOYXVEQkdWbVBCaC8vVjlSVnIrbHZYazFabUx1?=
 =?utf-8?B?OURDaEFiWGhabDZrS0ZXQWxXKzl4UlhUajc0bnUwNkcxRDBGK0RIcnFpZWhJ?=
 =?utf-8?B?ZmVlZWNxOVEvK1M5NXJvRmNFZWkwazVSQllPSjJQTTRIK1lyMHlKZmcxYVhI?=
 =?utf-8?B?Vi9TbUxGN2NSYnlHcVFuMHZuQWRkdk0rUDhrTzh5RVNjeW1JVnJVRTNZQ25r?=
 =?utf-8?B?T29UNlRGeGNYMEc2T3NhUEQ5ZkJHMzJkQi9peUpKVnlrZTBENFpybnV4YW1L?=
 =?utf-8?B?Qy8vT3NUUWw4MUVwQVpSMUVudDk2ZTJqYW9tVmdRQXlEK2lqdjRZMUlUbUw1?=
 =?utf-8?Q?Uzq5eJDMdsRbVDUZuPevYEC37hM7Ho3VDK9TEkRlGsl2e?=
X-MS-Exchange-AntiSpam-MessageData-1: l4Oqr3xRhckfaRbfjcbAMRScyi556qapPBk=
X-Exchange-RoutingPolicyChecked:
	LF8bpFNeVvYIxHejtvRsfE6zhGUzqs6IFDBzPE+MueFho2G//P7xQ+jO1vyTZ+B6ytLeAe0bbCEAFQxM8PlpIjXcI0lfNgHj8btpnyeABgluumdlFp4pfTBkgqBFB4P8fxhtn3eVRjhTMIbKiJ1H8vbg5xE8qDVleLxLJzouFhpe1/+9kP0n6HvPPdEBqsTsFmzt/Gq4Y+RWhgIhz7nL6EPwJ2XAkZXi6qn46gDZhs/8Wkjy/odQB74ROLcEpf1TyWCbFPYzgBAngn3T4BZUhHMWqup0TaWZ+WnKkpeI+ofWOKFSHdI49gmMiD7H6QF0/5Dq6IRQbKJl1d/nQ4guWg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wq23aCdyudume3WxHMMtZjubgkuHxjgxM11Rl6ZHEbeUiRCB+V34LfDf81p1mowse+QuEEfg5eC5q9zR134OAPnmfX3/ChM8PUHUVHvf7xfX5XEi2sBLMbVodRyW8N3AJpb8GskgzlpUY2ak0/To1IPKc5jG9F7cAVNpTJcqsWKkUQxgCWu6Ve49TzRkuEd86yZudJsR1nZfJENTBIMGUAwAzbycaua59I37AwrOiiH51Qfvukou7Z5Lr127zafuvFVayogyviAbAT5sVzmMdSC6wJY0XviWaLS+jaRJY4l/RD4nNo//IhaTKVUMwVs/TkxODrgszusN/u5z8/GY633rVJKTOG+2acCfC0SYHMLAwDgRrrlF2q66XMaMTEwzL7UtjhtrKJm/euX/+sd3UZKXb0pU13ti0dyDojbCL+DDnSJqHx2OfP2CUCmtpuA7vwxXQBmXb7iL9R+1I5mxHCOfURffW58LaTvOtXBco7CGDU0d4901/JX1vl25FCzqYKo3IP/lZ1iIeySEDReNCZfkuMMIjz2+neEGn6z/0eZz9R5u79eK/z76uPfB5qgSxkODJrkOjNScxPpUOKn5CPPKZaqzXk0m72Q7vNQTAMDmcqaQxtcgtCsevMvYK6Nl
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2dded37-a0eb-4a9a-f91d-08dea1483e4e
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2026 14:54:39.0647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rfsVuEG2517QSjUmukv7jbtugOeLIsawTglN5PEQ6MN4OJ8OqyE8kZl2aDEeXsTsKGFdQW46Bm/dJ2JRvKzzqiQ88qNSjcqPJaheoB8Vw1g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB6546

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

