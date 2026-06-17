Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57DD12CDBE
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2026 17:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781718353; cv=fail; b=HQKrslNnwnHbpduBpBo3rvLFuVlCBX3wsGWjcyeDDeyNJnJO25xvRiWuiZnwPQtftrfH11TvM5yLvSd/+P81GFFZ8UIHdo6Jzj/7U+ODJ7AySX0RFfHUqUtog6VoXPwJoKRoOe4dmN4LRCaz+hELuWUTo5EvseQ1t7WbQ5gjQ/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781718353; c=relaxed/simple;
	bh=denMutdgWgQi3G6yEXnuyOzGmBpNf7ilAudNuf35K9I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IxFoi6XczykjzB8NMTk34UNoGgpnQFfCqiOmIbaEwfHM2O5NSw9bwmjw8kJIog/deAHagnOd7pBjWAGBpn8bUt+tA6xp7E32Db7HiOnuXOrkvRtgrNAnvQG7RPt7Y9StECxqsKfyYyVedutseaZ6A1/+i7KrlSG1cBYaDdCh60c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=rPEEOJUt; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=mSITodJd; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rPEEOJUt";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="mSITodJd"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781718352; x=1813254352;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=denMutdgWgQi3G6yEXnuyOzGmBpNf7ilAudNuf35K9I=;
  b=rPEEOJUtrfrs03hp5g8qLnM9XRvoYT753Q53CXwLfhMaUaa79GgwFsT+
   y/cKNOq3QbEwbngpaxELeZoGvQpn5IAHpfC6R8BpUevcGfcljO3sUuA8j
   R3nwoIjIQWqGaSXXOU+TMk72cQN9xtPD/vYx3I6ck4X/QVVOyHil5y7+j
   1izTCsRnC/P2bqUdB60txAD1cSksHvxKIhZDOo2gtZEFd5Pzarsdp9/+Z
   MHFxufaMsxuN2bfwl0VRu4/9fpqhnnDVzVGP+TVb1JmUoeaJZ8FgJI4v+
   520YI7sbnueSOs/7KMlyyOZnge0qcW6KaGchZfObGktcHecbcrGXDb4I1
   A==;
X-CSE-ConnectionGUID: 5MZ6p2UnR3SKCVLGaOLI6Q==
X-CSE-MsgGUID: EirntgQVTs6HPQuF+8jcAw==
X-IronPort-AV: E=Sophos;i="6.24,210,1774281600"; 
   d="scan'208";a="149348471"
Received: from mail-westus3azon11011051.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.51])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Jun 2026 01:45:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sW6QVrYcDCLx96HM1UFT+k5fC6WKj+PHuEOtUNxeLkeSf/+5VEFBy33eKQiKf1cX+ouS3mt4ixaoylWwOrwTltS1QUT3PQIa4RqhWOkv4yonJNHAlrMhBC6WlJZdwYg5RuB628n+CujpuHqV+OxXKHP1hYLtBdJbAA9QIjVaPA2p3CnJ5BRhtzPaUqB2j+6u/PTY8pdyrLQC9sIsuqCcSekEnDmCLo5Ctsk0w5u2k/6gmnIoNSq1vuAV12BmWQlmD+Eqs8OQhgFi467niNYsAEWWR6r9b11FcQHGEVXkHEC6Ws5kGbGW1DhLnDE0v+PbTpI0ED+EHxJdFT0q3GAuzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QqaCeSuloisydejkHwG19FPrrsj0FmUR2aG8oFDkkJs=;
 b=kw9P6a4xvQtRRjIywl2ow4yrtoybMGhAzdHA1qiyno0PAhc+MfrRakwe2EFKHG0B58ScntPScFzKE5TeSvTDH4V9Jmrx+zLgyA9Q3JE4dvCr4VYCDKeSMSaAghkSLqlhH1FmnztUNPEYuL0BLzyY0en6jdRRrlWAhhO1xHutdxao5oYjQJvjoHmo3Mqi8IBtflvDiJDfNnqFeSIr+RVnMsoC5EFtAzcTvRs0JpwcBHLxPxao2Etm4mT+uRbntxDVIu/tDI7difuvFrtvTv+Ju3cxyiL1jLEPkbW1P7CFrIVNh2qoZfohUNueAfp9sttO+ZWavF9ezztKCt9vj1SK3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QqaCeSuloisydejkHwG19FPrrsj0FmUR2aG8oFDkkJs=;
 b=mSITodJdsUwQufk6VAMHQAwMEW2BI47LkPzWFB6/jeRmUh2/85xXuZpQrFVj9k/A5+jC0gqDc41Ah20UmA6Ly91QAIF60HcTz17SlWt6CeWAePdJxJFyAvM1KBWmOyitJoKofTylUNIkKuX9hg+zswYSYkQvuofRjR6tg18JquA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV3PR04MB9372.namprd04.prod.outlook.com (2603:10b6:408:289::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Wed, 17 Jun
 2026 17:45:47 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0139.009; Wed, 17 Jun 2026
 17:45:47 +0000
Message-ID: <63ca362f-1b43-43b8-ab70-d5f296f0d3e0@wdc.com>
Date: Wed, 17 Jun 2026 19:45:42 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix RAID stripe-tree lookup across leaf boundaries
To: sun k <sunk67188@gmail.com>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>,
 Qu Wenruo <wqu@suse.com>
References: <20260617120431.381916-1-johannes.thumshirn@wdc.com>
 <CAAuSuOrRF897omi1SFm+wUUs87hiHN3cz6NZm2L3J1-hRkcSDA@mail.gmail.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <CAAuSuOrRF897omi1SFm+wUUs87hiHN3cz6NZm2L3J1-hRkcSDA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0302.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f6::8) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV3PR04MB9372:EE_
X-MS-Office365-Filtering-Correlation-Id: ba6faa6e-f288-4833-2dc4-08decc984359
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|376014|23010399003|10070799003|1800799024|366016|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 H8Sj93SUg4WjDKoVSX5MyE+vfX+fSBOGTVgeTsEZU6QvxVy6olR7iiW9L0bubz2PfeZ/cB9AYGejVRHcDQQbb8Lme+ehfkYK38PnaicUZi53OGxjptCFYDYhJcHxYChCBT+WCK6DAMUBC2B0mNFk8TLfEKDpFfhESsQ8GteHdu/+duke/VOsEad5rR66kNJRHKvShvsoHuAEbDk1Z1eB+XMIGperIu5xJDWL4xzKler6PEDywPl1ikEMzyG+B2hWrYARk6HPsPdD1QAJMgRbti41v4Ai4snJ/5Cs1S+VafbKUQiqbObhWANBvN2IY+PSQjoDRdlvt7E1k46IZN1nlrQuA0RxNpD34j6fqpyzdMiCRjQ8v0lOAlnQLGU09q9x1p5QppBMZA9eXS/Tegsya1hpyR3nyo1mgcs7T+cpW50k5xukCQOv1U5G+dBByKtcoa6gtHBg1AL+yyS8LN69AlBFfG4BCRaQna1YiZ3TLXvg4+VPCg7aJHHBAj5SOEoI4w8yt2LSHn2i2dZF0Wr1luE1dMxE6bW1prdFPyhHp+KGGz08Q9b1JaontVsCUHtE3I5602njU7HG7/U9KBUG8nqj/mEzhczBTTGAfgZv95P5tpI+XdRVN42dTgygSSFL9eJeSmijygLKo09mJC1UmRIzNFotod431SCntZX06WGHnU91oCrveAppPk960jnB
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(23010399003)(10070799003)(1800799024)(366016)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?U2xDWDVGRzlqUzVoOFhFb2MrZmFXNllRRmtkM21FNnh2MlFrVFdmL0hOZEsw?=
 =?utf-8?B?b0xwUE03WjIrWVZUcWx3QlVicXZHWWczSzFualdBdFhvd3dHSlVXd2tlMjcw?=
 =?utf-8?B?WUF4TjlIK2VlOW5na1NjQkE3THZUem5xQVVPYVEyMzg0TnA3T3dXVXMxWUtV?=
 =?utf-8?B?SmJPRStxS2psLzkyVVZmSmN0cEh1V3QyQ0ladFFrZ0IwK0lpb3ZraEFIN0JY?=
 =?utf-8?B?T2UwbnNObU1ldFZyT1JMN2FXa1IzdFZ5aFUvY21Tb25tbXFuWVZmdVBaUUdk?=
 =?utf-8?B?SmQ4dTNtZFVqN2RYTTlaL1h0WTcvNno1MGxkUlY3bUU2cXZpeEF5T0Z3WGY3?=
 =?utf-8?B?REJBUXVRQzRLN2RjaUV3cmdZQURCZXZmY0UyOU1nR2lmQmdKdTF2VEZOMlJT?=
 =?utf-8?B?cXNkdTR0ZWNMclVTejFNMnRLbjZqRXY5TjFYanJGMVg1UmkxcSsvUUpnVVZB?=
 =?utf-8?B?UE53M1d5d3YvYjJiZ09ndHBva1VlWCt3Y0dQWllJUW84MVdqVDJqQnBsTHg0?=
 =?utf-8?B?WDBCaUg5VjJHazhhejMxTHN4ZVFac2xwWkszZnZhSVk3TTU1NnVLamxLemxV?=
 =?utf-8?B?UXlNZTFpMkV5UGhETGszZnVia1JHNVNPN3hBNkk5aGtkQVEzWXVONFFFM1Ez?=
 =?utf-8?B?ZnU0M25KV3c0bENDVXJLRjJtZ0x6RFJGVkhIVXBYOWc4WjRWNTBWcUlLYTBo?=
 =?utf-8?B?VlpsSk13UDBWYWJxcTFrRC96RnU5QWpCN1dlUkpnNE9mZndEenI5N08xOVdK?=
 =?utf-8?B?NTlXcnVlK0k5UWVNRkhKdFhLUGlmRkp3UGh5cWcyNGU5VTZYR1gxdWxGd1I0?=
 =?utf-8?B?TmRFY2JTeTFYby91UVlyN3c2NXNHUGpSMG1CQ0dIV2xySUhlZ1JKWVdacXFO?=
 =?utf-8?B?MXdXQTFHZm5aR1FtN1dUQzhXZ1hTdkZjUzB2SElDbE5jTVBFaDFRMEl6dWh3?=
 =?utf-8?B?aDlzUnRWVWgyWExoWEFIZXVxdDVtaCt4eTZFTzlraklCcUtPSU85Yk92NlRm?=
 =?utf-8?B?THIzWmRNNWZVeXBmWUhRSnVDOUVWTEI1UTFyZjdtUGxHQ1hFRlFjb3NBSGR3?=
 =?utf-8?B?WktzVTdhQUM1ZGNFeFhHMnk4aVJKNGhPVmgweU5SQVZDaGlDYzFCT2pPTG12?=
 =?utf-8?B?ejZvd3lUZ1FTNnJTQ212ckxKMytJdlFXUWx2clpSQjJXa2NWUUVZaFlta2g5?=
 =?utf-8?B?MHc5T053eENFVG01czAwWHlhN2MyWVl3N1dwU0VMRURQZXM5WjRKRlRLc0RI?=
 =?utf-8?B?alcraXhIYjVwNmxxYmlxNkcvWDRjWnJyV2FEeStxR01RK25PbS8waFJ5ZEp1?=
 =?utf-8?B?Q2JScTBBTXpEczFBWmNqT09oL3JMWjBTSUFGWDJyMVV1bUNtRHMxTGNpV3B6?=
 =?utf-8?B?VkcwQVRPVEFGenFVOWxKS2xtZFFHWUZzRDlPbkNHZ2xZeGxRcFVMSzl3L0gz?=
 =?utf-8?B?cHNwMzRmaFVhQVhoOHRHd3FLKys0VUJBRnN5ZlBzcVVvdGZCWjNiSEtLVnZo?=
 =?utf-8?B?TUZqYkgvSVJ5Wk5kc0Q0dEl3QTlpWWpTRHlBMDEyTjc1SnpacVVQMDFMdjdE?=
 =?utf-8?B?c2pkZ3UrMVdMcWdUTm9HSGpmK2dIVysvNnR1YzkrWWdsM255elpRTkNWWGFN?=
 =?utf-8?B?UlMyNFFTVnNyRHYycnZIYVgyOTNWdVROTVlhdnVwdU94Yy95VithdHY5WldR?=
 =?utf-8?B?NUZQSnVXdUxJV0FsR0FHSjVDSHpwVWRkL3cyc0w2MWp1VlZKNkJGSVhTb3Q5?=
 =?utf-8?B?YmRIa0t5SGRyeER5VDZsQklBM010RzRCeVdERVBtQkhYVlNMNXNVcU4xbWZ5?=
 =?utf-8?B?Sy9qOWtFRXNBUG1PZkY3VVVnaUVua3dGRG9DUjFRKzVCajV0L1ZWMHRGbjRF?=
 =?utf-8?B?elQwN0VUb3o1V0p5UHEzN3RNbTkxdGRKNmtHdmhpWWRRLzFoemJWaUVyc0ZU?=
 =?utf-8?B?cmUrelhNcVVGVWt0ajZXYkxadERmek9nSkdFRFhJVVkwZEJaemc2MGRvL0Vm?=
 =?utf-8?B?aVduTkFvVWVQdkJZTngyNVRQeDJwb2ZWeDdnQ0l4cENkUU84SGljWlo2Y2ZB?=
 =?utf-8?B?ZDFWc1B2MlJVMzZjd3c1QnFjeDk1Q0J2cDlJbDcyZWtJOVB4aVlZb1JpT3Jm?=
 =?utf-8?B?bDdnMVA4ZkNuS0RsWXFvRVAzU2FaNS93ZFQvdk1DbkNFaEdPZVhxTkpFY0hz?=
 =?utf-8?B?M01rL3RWM1VoVVFFNUJROXhXRW8xdlJ5NUw4MUhBT1hKSHdOc2NNTVNFcFlw?=
 =?utf-8?B?MEZxU1M0UUxsYnphNENQbXZLcitndTl0V2p1MzlxdXBrTlNYdHpjYmR2UENE?=
 =?utf-8?B?RDFCOGRCSm90ak9IQk9RdzNERm1FWENraUNYUU1WaWg3ZW9XM01FMjczNW9U?=
 =?utf-8?Q?DSf8h8u31P5rJnhK4uGUnKoFzkw0GQFErn3LQ70reA2WR?=
X-MS-Exchange-AntiSpam-MessageData-1: pQOF5H3oFi1Lkw==
X-Exchange-RoutingPolicyChecked:
	DV07fheJnBUjWj7+NfwrcuO9nRM5NjnRK2PAqdRwDmPIIE/cynmYXqu1nCDq/vSA+5qRYW+MuQGFLrUQqm25kDoAPrApPKtz78BL55Gup6vBInxeczqDJ1fiv0dptjWFXR0kPXSetO+/zdKFJi986td0599pQV7hlgOAaBufSpPibjE87WO1HHGGfyGYI+C1FnLmYjk/51K/9UncFZ/OoDATBssV63EiWR8TBJjNaqFinn6+l83W2+nAF69sXCo+l4qq6AD2f+CPWC8nxW1VQKDbMOoR6I1JWzubkBT/3fHt6TMNl6Gnwu4n7g1V1NvTbFGW3CY9JbCMDuswOeJc7g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	taxX6UewfUPHoaHGy9sYJp+D1vdZVvuUoS8UzmGhXiXAz5k9C3/7FsTatMiJXFbD+BLT5UMYy7X9iULnl1WzJbCrxBYCko0YjUsbIAB1PEKl2wxJ09zFZAzqeDbCY3PPG8wzt0sr34JDSyxFmn39SNHm0TiuKmawr0pLx+XrjECS8C6sjx/ghUDV8UFKjojly7PftLLtInx96eROJ6v4VQjAlqnXlro0d/RYH0eEh/iVc8WWwjCATOdJw4+Lbox3PWKmAXgba0lTAm/WrYCDagtaiZOCyJYelcPVRHzpqliA2qIxEaCWg9RElm4G7k2NGFjTj2zSOOcR5HWXsQvgLkmwapKcVnm9wGXmeDvcsEGyw5beiystdNg1yEzj+Mah0HzjvGfinpcY8EyrXXeP9DF5+Lo59/1MPO+x+8l+vVP92+6Diu+d//Yx1Elv0L05XfYBS7I0pfpYd9L6NkcHCOTOXNK1tJvHtwHe0zUTnuxw7rJVctF5rN9cCG2ub4fh2Ay5DyjxeDSEtt4k5JQ44gvfI3xvi4fVLPdds2q6D4XXHoS4oSqPnjkaKVtN/6OwN+V06Fp9KaJncCV6ea/ytjGRVupCx8iA+1pOx65SyGi3sXa8N7DlqwnObzx881DL
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba6faa6e-f288-4833-2dc4-08decc984359
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2026 17:45:47.2513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 851CURG4zrSqFGwo74Zmro5Je4RPdyH8qEmTZC/R5sGdMUSddKWz5a/ygtR/96b3DNAw5RaeCMKveQ4Es4MS/sajCZR4IA3OqtkezPv8hjg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9372

On 6/17/26 2:24 PM, sun k wrote:
> No. It's not happens to be. IMO we'll never hit slot 0 as search_slot
> result when there's an item with smaller key than the search key exists
> in the tree. We'll always get to the previous leaf's last item instead.
> Current tree search logic ensures this, and IIRC many other codes rely
> on this.
>
> The only case that we hit slot 0 is that we are searching the smallest
> key in the tree, in which case it makes no sense to get the previous item.

You're actually right, my bad. The bug happens only with my WIP RAID5 
series because it adds a 2nd type in the tree. I thought it happens 
upstream as well and split my local patch into two.

Sorry  for that.

