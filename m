Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E62D3FC5BE
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 09:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782724714; cv=fail; b=WK1o/Cij1RMcgS1NB8Hs7xJ8dMtgzykr07tzS7f+7Z1qwFPLG4xrofj9kgaNGCKFzKP0Q4V9opgPyTWBn8X9OlzGrQqx7SxDBOXzckLqnihyZFpZsMGU6FR5P5sReDknRiRRtcyuJINveOj3JKc8qAORv+bX1rBHm9yOaqgQX7o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782724714; c=relaxed/simple;
	bh=6zGJ/Yzng6p8trbO2S5tpi5BbQZV8DYh4TdDq1Rt7go=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VeigB9Bhnx6o2mpFdcE8Jo+un0gZKE38PAEAkzW7kO6+ZZgVHKUwavImn0vtzzSrhrN2P8JakK+XiVNTUJ0mboJJScrr8blr2ESfwnhCFZ5BrHFsJL00Smb3PtBPEBRZsg6vPSMuGvFCt5EqbUHZ+0eP6RUnCvNYIEQ1+ZZuPZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=bUTS3h9h; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Mxg3NCT7; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bUTS3h9h";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Mxg3NCT7"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1782724715; x=1814260715;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6zGJ/Yzng6p8trbO2S5tpi5BbQZV8DYh4TdDq1Rt7go=;
  b=bUTS3h9hu5de34rEkjdi8/C9tpBn5sEw8MORMSFoTgiL9w92I66mUyba
   uyWfw1FAK3aaVSt0XSL91ajgdluUwga3T7X5zEkEngaMMhe1yb1UygV5D
   F++5LW/N+u6O5Mu5zQPEBkfAdIh2wuevRjy2ya6gtlqVjGLRzSQ+hSDAw
   nb6ycJ/5Vc65+1f/013t22FnOKtanlqlJtC8nT/6l6cWCBaa1TQlDHVAL
   P8kTAmzX/NxHqHa8/wR+7h9s2Z0u/rZv+LcuYuW9otCd5KHgVi9Mu6KIw
   UAbkl2mfMfVL5vBUxqD5IqsmfZBHSthni9dKLM+0eWQr5yni5SrAGHoWo
   g==;
X-CSE-ConnectionGUID: 3jyQmexXSDSbe4C3rOf87A==
X-CSE-MsgGUID: 0B31fiPjSWGcdlXcl0D94w==
X-IronPort-AV: E=Sophos;i="6.24,231,1774281600"; 
   d="scan'208";a="150922670"
Received: from mail-westus2azon11010037.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.37])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Jun 2026 17:18:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=azBzX7NteBLFKNMNTvluGGyMHZhGN4zMLfowTk98hzbVo4+rAh10nr2yWfDFoII1NgQEB5ylcdgAFuJ2Q4vlpmHCm7NWKoPIYVC1OIF5K1vDDm94EYthE5rAZ8jWrKDaQG94RQvUF48uRqQ44+bmiXIp/yaW9AWJjTRq4U88FyY5nWLw/51x2y1Tz29o9ISD+VN27DeO9UpJer2sZwEgiCaayf3KmrnRoKhX+Dg51IzgEJIpruLrlB1v1jMF2qz2uAJM9XMXZVK9q57riqb2YTzzoObi/I6gdLPPEOi2t12lNGCaLjTb38kYHNh9+eeestHzTswttvBFvwsUqbyHIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YD1/ERPozxwiMkRKFMNNnH6QJiVAqq2LX5JD1VyyCCo=;
 b=fozZ2m2vlyPEx1OFjxQGTzfijC7LjG760BQF8tIYUKRKnERHNrN+yVFiSeEnpNHYXVSbbdR7085G5PKwwpjQvScx3FdjX45WXATAzzrlKJLHWwkLAv8PtwRYCPK+yU962G5q6M+znEuX0l/KNugRUcCFQZYUMKDqgrBuD2oUJl3qcMlTprlTEr0WnS9SZBtCT6JZr6aIpc7OWIuF9xMaapXHekbGIOPvzJ95Jv/gMly8s8nWPuEyalvbNPdlI8aPpfXYv5rgdksDtvgWkNOcNLAH2sEzItwGzMKMpH/1pRpEilNJo7iReaEb3pkltSqAPdpcaZLkUIHHM3bMkr+URw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YD1/ERPozxwiMkRKFMNNnH6QJiVAqq2LX5JD1VyyCCo=;
 b=Mxg3NCT7VzmR7itNQqMhwtEE6K3vKI/X45YNxETqLSPX5sWgWVfCeweBrr5SDy6bpUOJ2lIrgM8lFRXDcDV8MDFsRxH6EPRB1J4bQ8ewcGru3VNvzTyPkgm3ciI9nZtBpSXHDIknUbaDVcL1swixC69ZIxjZRqjv+d13x4okbcs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BL3PR04MB8057.namprd04.prod.outlook.com (2603:10b6:208:348::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Mon, 29 Jun
 2026 09:18:25 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0159.018; Mon, 29 Jun 2026
 09:18:25 +0000
Message-ID: <70ab5906-0ae4-4c2e-b586-182d9664703a@wdc.com>
Date: Mon, 29 Jun 2026 11:18:21 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] btrfs: factor init_extent_buffer from
 __alloc_extent_buffer
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1782249000.git.boris@bur.io>
 <420436ec8cb5db154adfd65cfd5fb350b380a4ec.1782249000.git.boris@bur.io>
 <44af21bb-507a-42af-a908-66fa67c2a273@wdc.com>
 <20260625211412.GA3339383@zen.localdomain>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260625211412.GA3339383@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0147.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::12) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BL3PR04MB8057:EE_
X-MS-Office365-Filtering-Correlation-Id: 04c98e74-6fe1-4bbc-f8b7-08ded5bf5f7e
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|10070799003|23010399003|376014|19092799006|18002099003|22082099003|4143699003|5023799004|11063799006|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	uExXUGMGu30ZIVa6CFqlAr66BlK8ASaF49yzgH/CP0F0YImg2s2hPhHu8+tr0Z9tvgJxldIZIKlT7NmRJL+5YaXCpOVZ4fShzatWexeHNuDrgVRwNl8GwCs9/SgLx6DQUyw6+N9U28KJpCLlv7ODfCyH4+RU1vMOmC+Ma1a16V4pAwlt9Z/2erUZu8fvNyPH41FAs/5DWCPk/KiwY+ThKLV3rd6eGTbJHewhFJxeJ3FD3fpwzq/00Faef+EbIA9VWpYy+wvQD/g93Au2nI2yV3GEULsyJccQ+e17DzBybKB2K9uDQx8HwdcZiSlsfR5ExOXzlNC214nzFoty1+OgCL3cr/Yq2UQWQ7qTvj5YEP5s4hOKIvta4AwcwBVRKcYrp8DWy0JvOgto23hZ/DsaCUKi/2Xf2k1HET+deJjUQaBb5ai3G0v4NhwgP9HjM8u5sexLuspEi+0WoFrw6/fU103sERQDUF70+tvlSfhuvoPMEtAwynQUjF/8A6IDbmP4ynSgl/SxHwhUbSVSHKugwWpvSpGCbBYPyAnivGLHE2PtsD9ljLNq//CUbQnSvlSjF0iuyp9ygg3KrQKrBd4uLgVgxiLJadsLrY2ea+IWVfX/VVp52J3AI2Bp5fjbSsJ6IfVyFb77sxoGIq4F/L6PIbSuEDr5JvjXPBzeMQO5WoE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(23010399003)(376014)(19092799006)(18002099003)(22082099003)(4143699003)(5023799004)(11063799006)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHR1ZUJpSUZIQk9wbkV6UWUyYm4wVUE2U3NEdGovV1NtZkQyZm5sZHppL3JF?=
 =?utf-8?B?aEtYbThxeU1lR1U3UTdEQnlqYUlCU3MvL2FseUFSOUM3bGdrZ2V3ZTdNMnAz?=
 =?utf-8?B?SXB3RXl2Rm9CblZJZ3FhTWxxcjlhK2FWdmhwL1hxOWVYYlBxYStaa0VwamNW?=
 =?utf-8?B?aWlsT0gwd2QwWWRYU2JPMU1mT3NEV1YxVlpkYmdoa25LNFdwRUdUZGpCTW5x?=
 =?utf-8?B?RVByOW9XekxVQ0NUWTlZc1d1aktPa2QxUjl6Q3hKTGZJcE1QMDZ3dmRMeWtP?=
 =?utf-8?B?R1V2NW0zMGR5TjA3VnJvVTUvQ1pzZng0MnFBVXRLOXJaRktWM0NSL2ljRDRW?=
 =?utf-8?B?Z2YwK2RLb1A0VGdkR3ZSdXZlZTBtYTEvVSs0OEIxUldrR1VOdzkzcUk3ZVhI?=
 =?utf-8?B?eXJWMHZPQndnSmg4aUZyMWxib21zYzZ0MXNwa1dlYTJVbFE0bzJ1VFp0YzFT?=
 =?utf-8?B?elZhUGNiakltREplYmM3WjFvd3NaSi9LMTNtUTBOVDJjdGh4a3FSZzJ0b05N?=
 =?utf-8?B?ZFRUWWoxcS9rR0hNZWdQZEpWUGt1bTZMU3pGT21oZUwrd3RtbFJOUlZMU3p0?=
 =?utf-8?B?K3hla2FPNXZ3QjQwSmY1T1JUS2RCanV0Q240VW1MZURTVnc5U1RMUmxKK2pa?=
 =?utf-8?B?S2pHeEhFb2YrRDRSNDVSQ1BLNmdGWWdJZ21PU3hHRTQvMEM3UWlYUWVXVlVz?=
 =?utf-8?B?ZEF6dktuSWhxenBSM1RvZEpsV012Y2VTMExEL1ByYldBbkNDa2Q3eG8rVG5I?=
 =?utf-8?B?Ny80NXdMWGZWQTNPUjIrcWJvSlhqRGwzcVdaWEJHMzlhOXJzU01rNjFvYkxR?=
 =?utf-8?B?SXl0UjNpbGI2ME5OdXJ0dVpQR3dGSDVzTmFWalVGM1lHU3ZjRkVaMVZPNCtO?=
 =?utf-8?B?YklrQ1Rrcm9pblc5VUFMZEkwU240dDhYWEgzMGpFYWhKb28wVjdqamYvL3Ju?=
 =?utf-8?B?bStsL1g4NGlVV3lqSlNIMFk3bGc4NU5qWXJmQ1c3RmZXYnV4NzB1a2ZmUTQ2?=
 =?utf-8?B?Yk9BZmNxa1pwUDh3K3NXc3cyclBhWGFCTDY2N2lVR1RMbkhubkRTa1N6RG9F?=
 =?utf-8?B?K05pd1VnZEtaM3U0NGVmcTJ1alVyTWRramZ2UXdGaDh1S0s3MmVJQk15dDVy?=
 =?utf-8?B?U2hlTGs3WUJ2cmU1MmxWVWpEUjFIblJQY3hiMlVITHNkWjU0ZGtJNzhXQ2FW?=
 =?utf-8?B?N241bWhidHRZNXZsNk5uMkVPMlU1VlJzL2lKcFc5bXE2amF0Q0hzUk5xM20v?=
 =?utf-8?B?NVd5ZWNENVJWVWs5UGRwb0M1TkZIWVJ2OTJwMVBNMG5aZEF1bEF3WFJjdzdq?=
 =?utf-8?B?QklhVnZNUHBRcHQ4dUFwMFYvdTUrWk5uUlZBdlBUMGI0YlpGN3RrWTBFM3FG?=
 =?utf-8?B?WHdiYncvcVRldll5VnFyMXcvZUNPU1V2U3Qvd3FQejllYUV1RjQ0b2xzV0Fl?=
 =?utf-8?B?K2h1VWZ1c2JXVE5lK2R3b3kyRnBHdm8vdENJY1ByalpsSHZ6c2hNTHo1MUJT?=
 =?utf-8?B?bHJyVHNWcWJrdXNxTmRQQzh6Z1M0dlRPcHB6Z3UwYkRuNnB5cm1PUlZCeHpU?=
 =?utf-8?B?VDdsUFZEM3E4OCtMczJXTjlpVUxQcG15eWlCNmVDTkhHTzVRVVlhV2RlUnBo?=
 =?utf-8?B?bXRmMHJ4cUdRNnRRMHZHYjlZVmIyZlVNaSthOGxOdU80ek1FWVVmNVF0KzY5?=
 =?utf-8?B?dFJFZ3RyME5LR1NLR0NUTWUxY3FSay9qTjB2UUR4enorSXpMNDl0RUxtS1dz?=
 =?utf-8?B?S0dBQlZiS0Jya2pwemlBdXA2RWM2Zy92VlMvOXlnOVdnWnJrQ1dCcFp3SnAv?=
 =?utf-8?B?dHAvQmYxb3VHdGFvcXphR1lMVGFhcm83cjF6NFFhUGllQmJtNHpiYiszTity?=
 =?utf-8?B?aFFIbjZkNzY2amNwenlibm1zbTY2NFFFUmt0RHZNVHQ3R3BWMFIwdnpSQnJE?=
 =?utf-8?B?WXF5RncrVWFtMHZRcXNXMG9rdlRuNTdPV1R0b3FNc3gzUGl4clZFcVNnWEZs?=
 =?utf-8?B?QitNU3BwQ0tpTGxJTHpQZTRjTkhnWCtqZzlsN0RFdlNkT05UaVFJUTl6b1Zl?=
 =?utf-8?B?L2FUcDEyMEdCMGgyaWJ5bERxWXprOHdhdmpUQ0d2UXNTeURjdTlsbVI1ZzJU?=
 =?utf-8?B?VGZzUDFQK0lKdXNPM3pYZjVGQTdYaTc5YnBKU3BDaFlVN1FZWTVGOUcvZUFu?=
 =?utf-8?B?b01xbG93WWFsR2tXN1BIRFNWL0FPUTB0dk1RcFQ3Tk83bnAyc1NYdjZjY3F2?=
 =?utf-8?B?dllUR256aGVGWk9CbWtVLzhycXlaQ3pOSDd1QzdWSGlBOHBabmtOV0hPMm1V?=
 =?utf-8?B?Qi9QeDUxc29PVDMvY0Z5bHlaZUJuTGFIL1BvT3UwTjcvaDV2WENZaXdCdWhP?=
 =?utf-8?Q?hhcH6VyLnFFy5+g6qfH6mQBfN+Sd19Xg+KWp90Ruw4vab?=
X-MS-Exchange-AntiSpam-MessageData-1: p/FBNHXx/D5Hpw==
X-Exchange-RoutingPolicyChecked:
	cNZ3vx4+1vZK2L1jPAtRsHuSNKZA9kUOnFn4FcoW5zp1F75eQeLudzKszgi6L0eW4OxclVZYKNm8ruh3xX37Im3pPY+n9JoaK9PuXVUx48WjUVKaYKOujPt5H7fBpcq1G5IXVlVWQCIvYDVaZh1C45AbPk5/X5txBprbOBWEZluBtoZShLKGTW8KTu5PM46JJNfUvV5QkX6Oo15jK9HgCl/1B6qNpzIxoCL/0bzO/5gstIuxbyelxK6HMGiCFwdx8BZ1adSzDZmLoHnkq27AQrgHYyEfH+AOVOcevYsYhmp0ppvkicifRYklCBDXsmnPyeHwfyzaa6Y+hp4aGs0Lmg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mII/0lwjRYBk93FERehS0+q8wKd9qm7uAEQwdRieR0qNpjYJF8cVU9Z/CMAHpuNvaH3cUFHNoUuKvhRLmOLV8F6ueljyC+eIV/t4ayu5IBppgMk/dyflwdjrMb8A6VSZBVcV4Gm3WP7rv9ZGYYXqHEv8Isxyo1U3+Hq46OJv34aNcsv/7wilnlo8wYkZmnYXaPfzkfhUiPtsKbYjQTj9a+x1JKlyfv8MXx1AOuJ3EuAqZ8KHLffUOL2MuG7Al62Vq7NobeRKN+xQ3k86b88i3n8TbWmPdKs5diTHieQIDo+LIvPmbiRaWwjZFIippLluPZ7dDHi8KlXy4LsnNU5IEHgAYcZWpAgBOhdos6xH7I35hAPcijuv7HRZgE8S/PuA8bGlzKx6O/RE+K/jtqdXeytF/0KPgGVRazWhTmYreN5jAnaRzueJ1miLJtV/uSdDSWcvjdxEOcEA0Rnoo7h3U0kwfwVcVd0DcUN6zZfMKOKoyiJBf1uleR3fomvimTKH0hb6kaimo7QwMhcmIVi/1tq+ku9DvXyPNozJ7b3yCTrOFd/PYLPXUruaaly0eSA1wf++8ObUeSgcpHnEmLiD2KmqNjguUcxhdSrrddC8Fueze10tjGXDfDxT+yP6DpFk
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04c98e74-6fe1-4bbc-f8b7-08ded5bf5f7e
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 09:18:25.1773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ofN8hQ/HA44ef4mj752lRUJqKXdambuaxzdelOoTfEYAsFrQEhdHwJ1uv2GHw1hTfavAnkLtePQXgRGPuJ1r2/+Aouu4z+GB1S/6VqYO50A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR04MB8057

On 6/25/26 11:14 PM, Boris Burkov wrote:
> On Thu, Jun 25, 2026 at 04:26:56PM +0200, Johannes Thumshirn wrote:
>> On 6/24/26 12:35 AM, Boris Burkov wrote:
>>> In preparation for preallocating extent_buffer data, factor eb
>>> initialization away from specifically allocating it. This allows us to
>>> allocate the eb, bfs, folios, etc. together in the main search_slot code
>>> paths, but still share initialization code with the dummy/test/clone
>>> allocation paths.
>>>
>>> Signed-off-by: Boris Burkov <boris@bur.io>
>>> ---
>>>    fs/btrfs/extent_io.c | 20 ++++++++++++--------
>>>    1 file changed, 12 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>>> index 0edd532174fa..fa4cc8bcd1af 100644
>>> --- a/fs/btrfs/extent_io.c
>>> +++ b/fs/btrfs/extent_io.c
>>> @@ -3054,12 +3054,9 @@ void btrfs_uninhibit_all_eb_writeback(struct btrfs_trans_handle *trans)
>>>    	xa_destroy(&trans->writeback_inhibited_ebs);
>>>    }
>>> -static struct extent_buffer *__alloc_extent_buffer(struct btrfs_fs_info *fs_info,
>>> -						   u64 start)
>>> +static void init_extent_buffer(struct btrfs_fs_info *fs_info,
>>> +			       struct extent_buffer *eb, u64 start)
>>>    {
>>> -	struct extent_buffer *eb = NULL;
>>> -
>>> -	eb = kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS|__GFP_NOFAIL);
>>>    	eb->start = start;
>>>    	eb->len = fs_info->nodesize;
>>>    	eb->fs_info = fs_info;
>>> @@ -3072,7 +3069,15 @@ static struct extent_buffer *__alloc_extent_buffer(struct btrfs_fs_info *fs_info
>>>    	refcount_set(&eb->refs, 1);
>>>    	ASSERT(eb->len <= BTRFS_MAX_METADATA_BLOCKSIZE);
>>> +}
>>> +
>>> +static struct extent_buffer *__alloc_extent_buffer(struct btrfs_fs_info *fs_info,
>>> +						   u64 start)
>>> +{
>>> +	struct extent_buffer *eb;
>>> +	eb = kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS | __GFP_NOFAIL);
>>> +	init_extent_buffer(fs_info, eb, start);
>>>    	return eb;
>>>    }
>>> @@ -3476,9 +3481,8 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
>>>    	if (eb)
>>>    		return eb;
>>> -	eb = __alloc_extent_buffer(fs_info, start);
>>> -	if (!eb)
>>> -		return ERR_PTR(-ENOMEM);
>>> +	eb = kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS | __GFP_NOFAIL);
>>> +	init_extent_buffer(fs_info, eb, start);
>>>    	/*
>>>    	 * The reloc trees are just snapshots, so we need them to appear to be
>> This looks wrong to me. Not the split out code, but how it is used in
>> alloc_extent_buffer(). Either you keep calling __alloc_extent_buffer() in
>> alloc_extent_buffer() OR don't call init_extent_buffer() in
>> __alloc_extent_buffer(). I see this is an intermediate step (and I haven't
>> looked at the rest of the series yet) but it looks wrong.
>>
> The idea is that you eventually (optionally) have the allocation happen
> elsewhere, so alloc_extent_buffer should not call __alloc_extent_buffer
> any more. That should be clearer in the second patch, I think.
>
> I left __alloc_extent_buffer for btrfs_clone_extent_buffer() and
> alloc_dummy_extent_buffer(). Would you prefer me to delete
> __alloc_extent_buffer and open code it in those two callers?


Yes looking at it again with the complete series applied it make more 
sense. Sorry for the noise.

