Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52E0351C2A;
	Fri, 24 Apr 2026 10:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777028308; cv=fail; b=PH21HZAWUPVicgpqi5bpSeDcaIvI8pq+p/2FDaKLZYKEUsxD/xSMfnfhzXioZ3qz5ka5qNh1wv3GaL+XA2LSGcKcYhTUz4ipc6EYcIRspbKY9bYr7j9tQyCWYf4TVWJ6JvB/6wzWgh1vYW4ISfBRY+MpOi0IhdgxZxE14dPIyo4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777028308; c=relaxed/simple;
	bh=6TIIqq9Vd+yuIxg6LmyYXk2gQ1EPQUR1RIBtgQ5AOhE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YM1fvkIE3gAjih7ylnkaxKgWcUCWFW1O3cX7iwwl+oL4kPiz1wu1MdmSjSBPs0O6VNn54cHvG8lSObajuhbEtFa5WfVOhtpHCnUCH5X76yF6J2VGHTjduOKrw7RkzOjlc1ijSPNaKHb0ht7eIQgI6kuo0irfJPgQA2OC2/5XIw4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=nQwHEkHC; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=0Ol3sflv; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nQwHEkHC";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="0Ol3sflv"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1777028307; x=1808564307;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6TIIqq9Vd+yuIxg6LmyYXk2gQ1EPQUR1RIBtgQ5AOhE=;
  b=nQwHEkHCwnojGMWFmMazh9Czn7ZIOBI8Vewoff4YmDdyGOV80K4DLS9E
   MwEaz+94jW5XZfcF+fcMZLp7bHhrGoh3/VSXHWW4MlsVzwcGFTBTmnvYO
   QUCVj96ypMXONYSYKeBipadtO3d7bsZl0gAl/esx94HOlQKnrh1k2y5TN
   8CUQmE60OLfFwoJi5gCc0+PHEgsqRf5qAkahgcLl1yQ4fBtYsin+gzZkP
   hMBc6NO1EDvVRYNKSQ4Xv9DPGrPivSv3E4KBh9tADLEs/5vpu0jKXbJVT
   OZn2+vfrfyQVw82K6ODZc+49tFhMfb3+TvOJhwb85WL/5IPmGF/4dh5My
   w==;
X-CSE-ConnectionGUID: EfH/N6NAQOC5FoGeWmwOzQ==
X-CSE-MsgGUID: d2K9xicUSnm/dDjH+DOF3g==
X-IronPort-AV: E=Sophos;i="6.23,196,1770566400"; 
   d="scan'208";a="145614439"
Received: from mail-westus3azon11011059.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.59])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Apr 2026 18:58:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ffOjVnMZKCpw1Fz5chRfB5PuZIWmpvdw9wgJToIf9ik7ynYoIYGyNP34tldx97w3tyPOFp4IIOSJGIdlWG7dNNOGk92Izo+VWeNBJtM7kI0Quwm146LMLdLfpav+q/yR25K5vgK0AOEcKw3akONBro8DmVfV60Mpjkwtwbl0jbbBeTjVsWGJd0Em6Fqv12/UsYwhXpm2yE655lRmmCyVh8rzmWjcR6Fj8H4wWoibbxByRUGerlYoQ6JJq9zBMnisKfdLOe+Y02R5CnF2MkMe53vt9rFTeKKN+uk2aH+5i0nb0TRQ7Ia63752Kzaygaf6TBuWOxjkUUg3FdcU/GMCCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6TIIqq9Vd+yuIxg6LmyYXk2gQ1EPQUR1RIBtgQ5AOhE=;
 b=bRLTUOjro0OujDI5fxa0XX39PRZI0q2WrpWj9Ql9rnroegvZLRoyuAnApLjR3yYlEsfxjV4HUpZKRo/6m6sRJmdyu5t5mbRNg0GwswCELwZiM1egnWgHEMC3o2r9wiNlhinekVqnmUEdDUCTLCXzsbOLbFvjZHq0F5cXb3gghte6KXVduoV9yfUO/r01hChQrND4RrJhEwW6HN0TW80cJlm4VNXDlSBUSj1DJJk9OUgXTDbGvlmx56FGqIXS8Vg91zzAprQb1AScUXN0+mLbD1H8lmU/+pZatMpR/rUVnO09j0l/mpiL0Zi2LVkooH6fvpHmvjT7udqxuv8PQgLCjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6TIIqq9Vd+yuIxg6LmyYXk2gQ1EPQUR1RIBtgQ5AOhE=;
 b=0Ol3sflvfPNFuQ/lD/tyP4vj3mjuzLkGj7xou+r0rEi4rDLfdywjB1doGrN+RMv4a2bDaZddOJ6lfabFyFK8WydgRHz//CzPVWQ9CivZZE+L08L9ZPpNh642HMHtBuNGhmkDxaFFgOnOhGxE+4gF9/7YeUYUm+anPbsBgOMM1zQ=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by BL0PR04MB6578.namprd04.prod.outlook.com (2603:10b6:208:1cf::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.22; Fri, 24 Apr
 2026 10:58:18 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9846.021; Fri, 24 Apr 2026
 10:58:18 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Zorro Lang
	<zlang@redhat.com>
CC: Naohiro Aota <Naohiro.Aota@wdc.com>, "fstests@vger.kernel.org"
	<fstests@vger.kernel.org>, "linux-btrfs@vger.kernel.org"
	<linux-btrfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Shinichiro
 Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH] generic/793: limit number of overwrites
Thread-Topic: [PATCH] generic/793: limit number of overwrites
Thread-Index: AQHc07LLtnyXscp7p0atD13bnhIS7bXuCxyA
Date: Fri, 24 Apr 2026 10:58:18 +0000
Message-ID: <c651be6c-c7ee-4da4-b744-5b335c014780@wdc.com>
References: <20260424062222.87298-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20260424062222.87298-1-johannes.thumshirn@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|BL0PR04MB6578:EE_
x-ms-office365-filtering-correlation-id: 9c2c90b6-f9f5-41ae-1376-08dea1f06468
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|19092799006|1800799024|38070700021|18002099003|22082099003|56012099003;
x-microsoft-antispam-message-info:
 xJLe7s+GahjS0ze7D/MfySNSEYysi81PnM2K4LzehcUPFf2UJ8UXigP+DHNMEsUnx/4pfMq+/ydJwXuHLeSqD6BtYROIpEW96i9dc2rth6OW9detvaWgKCyBjBcgIRNr35vZ9YS+o+7sMpG26Anlg5ktEaYmUKYp43UpPTBK2TmOQMglv4I90o2zkoHt+vz0lLiYk4Ap6bjnEpcp3p4PIkpfcxVDlgllACEi+ADuSm/YXCrjc5sYO67m9TqB5+wxJiS3eZ6mADLCyiClj/Aa0c72XOa3I0kn5GvAL/RIs0+jSRRw7d6b8SQf8cPFqP3iQ+6rRpEO82eFEUjgmcEPr0buVxi/ls1RLixItbkBcnEeb2tF3Fl3HOHFLhg9Co78CtaoyAPF69m6+K8l/dBUvtmiaPcVeVI3MwSGFW/GpgM7YxKSFmfMyfnbH0B09YvqhjAbG5m265yogwuDMxptjQxRbbZT9Fa70No1hCnPlzmNhZPa8qJM0x+xJHjMzT4CCYBbV5K7xGKuDi1lv95fTPCsxEuNhBei/JL/fG5g2Ghq0kNHRD/tudrA3t7wwQJqF906O5pBCuohELsPCqot0rTk9SQFE94ShNx51Xr5ozPwLISiBFYSq/Ot6BcFgyUEW6JFLDcj7DG69GAi3Ub1CO0Pk2rigUL0IaDt0Imevx8HP8X+BYxdLmZgUDER53dMtr+vngvYKqLt6BER2i5y6NV9qYxs7xs0EcHz/ttt6kC+Sqrr0HmdrtQzzLm/0wqEUPpW32HbFX06yLSPlUGNsg6yKNoEEo0xcOb6o0dHj8Y=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(19092799006)(1800799024)(38070700021)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SGwxRXh2N1grSHNra3FNWnlaNGs5SmJJY3VqTXhCTzRtN2JzclUxVTJhYWVM?=
 =?utf-8?B?L1BZaUdiWlZ4MFRlSXo3YXJkSmVsYWNWeGVTTnhRNVdUZ0YyZTdRVWFZL2da?=
 =?utf-8?B?UGxhK0pjc080TCtmUnllNldRZkVQL0c1ZXFoTGlTR05rRndCd3U4cEIwc0VP?=
 =?utf-8?B?dndFTm9Zc1hZTUdUVTYvMzlmSk0zUzBLd1J3azdIZnphOU15N0ZFcHl0RUZk?=
 =?utf-8?B?NWxKSWJTeWVxYzFhZytCVkQvNXVNL1QydGtQR3VtRmxhUCtVWGtvTXVXQlNJ?=
 =?utf-8?B?S2RzK3YreGErUHI2ZWJyT2U2YjlFaDlZSVlrajZjSFNBNzBiVER0VXdZVWt1?=
 =?utf-8?B?MWRTNUwwczU5dCswWUZyYm5ENnVyaXBqOEFxZFVveVgvUC96dWFTc3E0TlE5?=
 =?utf-8?B?dXU5MWRBQy9BL1pEUC9xNWNHcUo5ZnZOVGREdzZwWDJxYjErTmpQV09OcmhE?=
 =?utf-8?B?Wk1tMFRwbXNpTzJWWnZ4MHhvUXN4TFRhVlVNSjhhQlRjQ0FGYVNGc0xwZmhM?=
 =?utf-8?B?UE5YZk52OWxYZ3RNTThZYUViU3lQeGNHVGp6UVJMWVF2WnhCTFV4akNVNGxG?=
 =?utf-8?B?UE5qMytOaWI0cHk2TUlTSGFRenZWUXI1MkllbWkzOTF3bnA4UERLSk1LRkd2?=
 =?utf-8?B?T01oV2llK29naEdkTElLK0FmUkc3NWxGU0NwQ1lIWnRYQ3pBWE5JdEJsZEVL?=
 =?utf-8?B?TEZsWUJhK3hkOGRra1hnZlU2elFlSmlnN3B0L3kreHBYd2Qwd3pCdGx0c3RR?=
 =?utf-8?B?UDhkMXVOOTlPUk1xQTJGUlJoZVE2YUFKbG1sQTlWSXo2N0ZZR3pJdWxGdXRB?=
 =?utf-8?B?SFp4bHRjdWxHVUdLOG9LNEZza0JLb0VtK2xiaWg3L3lRcVI2STJKbHBISzNq?=
 =?utf-8?B?ZzlUSzlrYlJTdFRkUG1DR1krRi9rNWJvdllJZlRESmpid2VWb2VkYXlYMVMr?=
 =?utf-8?B?ZnFYc00rZ2JuOS9CRUFLeWd1U1M1blM3anpoMHhtRDZRWXVKdmJoeHVTWW9m?=
 =?utf-8?B?eVBXalBoQ1d6Z0c5ZnV1R2VESk9MakZxTWpMR2ZrdjVGTUJMRk9OQ1V3Wkkx?=
 =?utf-8?B?dEdvR2ZRendiMUNaNVpBMFpab2pGVGsvc3BxQXNlYzNEMUFaNlEvdTY1QytY?=
 =?utf-8?B?eEo5Mi9LVjR5VDhzaTBlTDhMUDFVU1lTV05QQ0VkUlhRNkRMbnEvRkFJWEJ0?=
 =?utf-8?B?c3Nnc3JBd1Q3TVBta0xUWEMvdE0xNTBIaWVkb29neEF1NytGbjhYRTlFWjZw?=
 =?utf-8?B?MHc0Y1JHN0V1NFNkZURBVFc5M2lJQ3J3RTZ3dk5sM3hjSjdYZVljczZpdW5V?=
 =?utf-8?B?T1ExbGh5c0VxUGJRMDJuRzFiMnVKS2d5dHV3clNtQWFINDkvV1BlbDg1MUtP?=
 =?utf-8?B?eTBUR0M5L1h0SWNycHpiS3VUUmR0dyt6NGhaRStPcHNjOStUQmJ4ajBidnN3?=
 =?utf-8?B?bGs3MmZMOFhudmh2czR1WFZIdnN1RmwvUXBpQ3I1L1liZ2EvZCtGUktNUy94?=
 =?utf-8?B?cGs4REhkWWhTN0VBeUhlQ2hOSk5ITlRjMVJsT2ZjSElIS3Mwa1JmMUJTM1JZ?=
 =?utf-8?B?MFprTWQ1NER1aXJYQVRRUEZ1aDlmOG9pTEVFUDF6TVRrUzJmdEU3Zm51L1Zv?=
 =?utf-8?B?UGRNdE1nODhSaFBPakFKYlo4SnkwRm5nQTFVVVcvUm95VW8yT3FUb3VqQWFx?=
 =?utf-8?B?c2h6eUdNdkIvcjBjL3RUanl4cGJENklwSDF2WElVSUNKc1BabGNPbVR4OHBZ?=
 =?utf-8?B?RUtFa0djRDBXWi8rUjFmQ1piYkcwRmFQTGl1dGhVSENhYkRMMEFGTnNmOXRC?=
 =?utf-8?B?ZjZwcHd0Uk81emFwNTJsMHF1R1hRQkRVQ0d0QVpCbk45MzlWZS85UFhjRGV1?=
 =?utf-8?B?cit6dzVPUVpESUxmWVgzb0pPTlR6NnIwZzZRQ2ZsczYzelovQWU4NStzV05I?=
 =?utf-8?B?aEN0Mi9aT21kWnA3MEZQWmtQSS9qeithK1NzbHJXOHJYM3NXb0dSTzNvVEtH?=
 =?utf-8?B?NFlzdnV1SnRzUUtOVTRmSk1wUTBGSkhBc2NoRWNRc2x2WExNU3NkTXF2eXIx?=
 =?utf-8?B?c2daMGNORzR6ZVVIMW5QMmlGZi9sazdTY3NvRFVMQVFhODIweXFBcVYrU1JM?=
 =?utf-8?B?emh0eU9kRlJXb29SNC9Vb1dDNUdQR29lYWJoWTc0Q1JDWXJXZkcvWkx6aFV1?=
 =?utf-8?B?blVjZDhBVmN1LzBzOG01WTdCRlZEeFZZSVJrbDFLcWJqdHNWUDU5enpDNmR4?=
 =?utf-8?B?bU1NUzE4TkNDeXVsQ1FoV0xiVVBzQ3JHRVpDY3VlSEJHbC90T3l3bTd2RSt1?=
 =?utf-8?B?ODdHVS9HTzB6YW5jQ1pGWWgvb3BRSzdad0dOQUZvM2s4UFNISXkzZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9A94713D3549214B91B95A2269ACBFCD@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	WZN6sAwQAqw09CsJ0/BASmg0LN/bH2mjd5KhpiycwV1RvsZxQRm3sLMmlJsxfST1ZtqcjqRZmAgzIfAwsi9sYJO7NLykDNB9uVgvcJ3rvDIt+LqYsGE3yCr5XQKX4y3IaDOfU7EpUFOcbmGxNEtNNYmcEiMOwDRpdsFTgKg1/szxSiS3V6eKuXr8KALFnhXrHGLIjGX/AwDzf1BXR81poRR9ISRhZ3d87PijhZ06TJofYLbPb1EHX05jrVLCbv6RFPvHMf/binRs9SK40Ftq9aSYmP+0YnuAUJ0s7Qi+7MzT2/PF45Q6BUWP2842AgMI+WbFDzzpc76uyOoQjmGbZg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	e6ZYc6KRN4KCPGBH66gSPM5KZKt6GEm204nockpNDMJpRF1f++svYjpqz2fpyKVS6R3O5LhZwUDyXvp3rTrVuW63kXryVok0jes1PJRU/jqV/8VG0ecxj+YUDxRFkLtlzIB9ZwQvkEycgcih2AKfe8VPb5JmtwYKavCm8id3UBxnxZMBDxANPfqFScH9bAIimsXgIwu0Ytxp1quMsUB7U6YzXM7btXq/7B6RP7Z7YZpTwGVLvJkS/b4vMM1bmREG/hxdDkT1Gf8uvJvHRtiSUme0GW7Wl/Lg12vKJ2qk900KnvWaUeBH++N/cxuTmk54SYM5znSkP/4ZvIllE1spixu8oH1xdRu64heEVPEVAwtWJdO+ydQDCGdaI+nFqWRpvmILeB5jyNMzu8xfs6yNmNIi1PCK6Beug/m6cuaTHFJ6nX6hmDCNWalwi10MrjdKgdNwuDV8PbhZWbAzSg+CmuIXW5ZZhmCeXnDRAGq5J05zHPyFqdDhwh9nsLL16fljacmn+DHTtnyB/JYeYLZEabUJG+ue4gYrYn8ywQ++ZTcjj3piBqVfp/b/zuwMzvD8WtNkjyVBkYpmCr6l0qZ/IkeYBxSO9oNCKBQMIaKJ8mKNc3jsZrMP5fzRV+xLohLO
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c2c90b6-f9f5-41ae-1376-08dea1f06468
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2026 10:58:18.1628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sIE2dtkquDByw3PSPzJ0pjEtXUBEwZpJb3D8TfCG0Q7ZuGgtMQoeV05bceo/8+MZdy4Hdl7dDjB1oZW36Pnzyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB6578

T24gMjQvMDQvMjAyNiAwODoyMiwgSm9oYW5uZXMgVGh1bXNoaXJuIHdyb3RlOg0KPiBUZXN0Y2Fz
ZSBnZW5lcmljLzc5MyBvdmVyd3JpdGVzIGEgMUdCIGZpbGUgIm51bWJlciBvZiBzZXF1ZW50aWFs
IHpvbmVzIg0KPiB0aW1lcyBpbiBvcmRlciB0byB0cmlnZ2VyIGEgYnVnIGluIHpvbmVkIEJUUkZT
JyBnYXJiYWdlIGNvbGxlY3Rpb24uIEJ1dCBvbg0KPiBzY3JhdGNoIGRldmljZXMgd2l0aCBhIGh1
Z2UgbnVtYmVyIG9mIHNlcXVlbnRpYWwgem9uZXMgKGxpa2UgU01SIGRyaXZlcykNCj4gdGhpcyBj
YW4gY2F1c2UgdmVyeSBsb25nIHJ1bnRpbWVzLg0KPiANCj4gQXMgdGhlIHRlc3RjYXNlIGFsc28g
bGltaXRzIHRoZSBmaWxlc3lzdGVtIHNpemUgdG8gMTZHQiwgY29uc3RyYWludCB0aGUNCj4gbnVt
YmVyIG9mIG92ZXJ3cml0ZSBsb29wcyB0byB0aGUgbnVtYmVyIG9mIHNlcXVlbnRpYWwgem9uZXMg
aW4gdGhlDQo+IGZpbGVzeXN0ZW0uIFRoaXMgc3RpbGwgZ3VhcmFudGVlcyB0aGF0IHRoZSBmaWxl
IHdpbGwgYmUgb3ZlcndyaXR0ZW4gb2Z0ZW4NCj4gZW5vdWdoIHRvIHRyaWdnZXIgdGhlIGJ1ZyB3
aGlsZSBub3QgZXhwbG9kaW5nIHRoZSBvdmVyYWxsIHRlc3QgcnVudGltZS4NCj4gDQo+IFJlcG9y
dGVkLWJ5OiBTaGluJ2ljaGlybyBLYXdhc2FraSA8c2hpbmljaGlyby5rYXdhc2FraUB3ZGMuY29t
Pg0KPiBTaWduZWQtb2ZmLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRodW1zaGly
bkB3ZGMuY29tPg0KPiAtLS0NCj4gIHRlc3RzL2dlbmVyaWMvNzkzIHwgMTAgKysrKysrLS0tLQ0K
PiAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gDQo+
IGRpZmYgLS1naXQgYS90ZXN0cy9nZW5lcmljLzc5MyBiL3Rlc3RzL2dlbmVyaWMvNzkzDQo+IGlu
ZGV4IGE1OWU4NDY5NDMwOS4uNmQ0OGI5OTFiZWRmIDEwMDc1NQ0KPiAtLS0gYS90ZXN0cy9nZW5l
cmljLzc5Mw0KPiArKysgYi90ZXN0cy9nZW5lcmljLzc5Mw0KPiBAQCAtMjEsNyArMjEsNiBAQCBl
bHNlDQo+ICBmaQ0KPiAgDQo+ICBfcmVxdWlyZV96b25lZF9kZXZpY2UgIiR6b25lZF9kZXYiDQo+
IC1fcmVxdWlyZV9jb21tYW5kICIkQkxLWk9ORV9QUk9HIiBibGt6b25lDQo+ICANCj4gICMgVGhp
cyB0ZXN0IHJlcXVpcmVzIHNwZWNpZmljIGRhdGEgc3BhY2UgdXNhZ2UsIHNraXAgaWYgd2UgaGF2
ZSBjb21wcmVzc2lvbg0KPiAgIyBlbmFibGVkLg0KPiBAQCAtMzQsMTIgKzMzLDE1IEBAIF9maXhl
ZF9ieV9mc19jb21taXQgYnRyZnMgMjU4ZTQ2YTYzODVjIFwNCj4gIF9maXhlZF9ieV9mc19jb21t
aXQgYnRyZnMgZTJhN2ZkMjIzNzhmIFwNCj4gIAkiYnRyZnM6IHpvbmVkOiBhZGQgem9uZSByZWNs
YWltIGZsdXNoIHN0YXRlIGZvciBEQVRBIHNwYWNlX2luZm8iDQo+ICANCj4gLV9zY3JhdGNoX21r
ZnNfc2l6ZWQgJCgoMTYgKiAxMDI0ICogMTAyNCAqIDEwMjQpKSAmPj4kc2VxcmVzLmZ1bGwNCj4g
K2Zzc2l6ZT0kKCgxNiAqIDEwMjQgKiAxMDI0ICogMTAyNCkpDQo+ICtfc2NyYXRjaF9ta2ZzX3Np
emVkICR7ZnNzaXplfSAmPj4kc2VxcmVzLmZ1bGwNCj4gIF9zY3JhdGNoX21vdW50DQo+ICANCj4g
LSMgT3ZlcndyaXRlIHRoZSBkYXRhICJudW1iZXIgb2Ygc2VxIHpvbmVzIiB0aW1lcywgdGhpcyBp
cyBhcmJpdHJhcmlseSBjaG9zZW4NCj4gKyMgT3ZlcndyaXRlIHRoZSBkYXRhICJudW1iZXIgb2Yg
em9uZXMgaW4gZnMiIHRpbWVzLCB0aGlzIGlzIGFyYml0cmFyaWx5IGNob3Nlbg0KPiAgIyBidXQg
dHJpZ2dlcnMgdGhlIG9yaWdpbmFsIGJ1ZyByZWxpYWJseQ0KPiAtbG9vcHM9JCgkQkxLWk9ORV9Q
Uk9HIHJlcG9ydCAkem9uZWRfZGV2IHwgZ3JlcCAtYyAiU0VRX1dSSVRFX1JFUVVJUkVEIikNCj4g
K3FwPSIkKF9zeXNmc19xdWV1ZV9wYXRoICR7em9uZWRfZGV2fSkiDQo+ICt6c2l6ZT0kKCggJChj
YXQgJHtxcH0vY2h1bmtfc2VjdG9ycykgPDwgOSkpDQoNCldlIGhhdmUgYSBoZWxwZXIgZm9yIHRo
aXMsIF96b25lX2NhcGFjaXR5KCkgd2hpY2ggaXMgd2hhdCB5b3Ugd2FudCBoZXJlLCByaWdodD8N
Ck90aGVyd2lzZSB0aGUgcGF0Y2ggbG9va3MgZ29vZC4NCg0KPiArbG9vcHM9JCgoIGZzc2l6ZS96
c2l6ZSkpDQo+ICANCj4gIGZvciAoKCBpID0gMDsgaSA8ICRsb29wczsgaSsrICkpOyBkbw0KPiAg
CWRkIGlmPS9kZXYvemVybyBvZj0kU0NSQVRDSF9NTlQvdGVzdCBicz0xTSBjb3VudD0xMDI0IHN0
YXR1cz1ub25lDQoNCg==
