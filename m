Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658AA2580D7;
	Thu, 30 Apr 2026 13:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777556237; cv=fail; b=rmrGmpafX1sqlIime4TnCI6QknwydcZecpe6BXyOlJ14Xn+AByHr52Zr+wYCyoZEnj0uALpPorcTU1ocSt6WBsPsNQU4lK1+RXKOLw21JuZFeWSZtzkaMyxWZGZ2XB+7OZg06ERzwuKSiwXfr4nr+XBBYpy/APZcig4G3htcBR0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777556237; c=relaxed/simple;
	bh=qrUb8GVFXjzLWDNOVgLR80WBG2nLRqKdGyc2YjNKR2o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Mx1DsiQnuW5b9wBpR83qm0uF7n8uUO7Mxv7+Gh7GZ7aAaOixyrNcZCDDNOJaOvppOnk/o2U+oH4upTgpKZ6zO4eiVYlPDlpzewxCBlHyVMGUSmEPLlEUmbUncp5u/37je8mZKZ4A2PTbuxw8nceWlkGTB6lBVAR789RRjagbwiU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=envs6MhY; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=wzurwHNW; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="envs6MhY";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="wzurwHNW"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1777556235; x=1809092235;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qrUb8GVFXjzLWDNOVgLR80WBG2nLRqKdGyc2YjNKR2o=;
  b=envs6MhYQf8LEjjAjN95wFoFcfGFVwv/9zw+tmzsabsAG4c1CfdO3W6d
   Lq0iK0ByiEnWxEwe2WI+S/wQwUcttnsQT5KIj732+Xb5NIUFEC0x3YA2m
   lkDKdNrELDSNKTIc88Iyff+zaCb82uhkSAbx6zhR5kBgbWxxvAom4YUOg
   qRl2yAo0z2LDtdEZIrfeK67xO6SueQ0uACDjoy4+nVJg3aZOy6oc8fkHF
   Uh+bUgUpkw4eA1M09awWqzxSDXlfULZqIDeLFwtxhl8uP6LCDzeYNzArP
   dhww4qyb/0NFzDQlF2kL5m7cZYo0sYtsd2OXV1a9yco1W5gSynAr6RGOs
   g==;
X-CSE-ConnectionGUID: Xar1EieGT9O/+QbAWDD87A==
X-CSE-MsgGUID: wouVX0PGQQu+qhIh3myMig==
X-IronPort-AV: E=Sophos;i="6.23,208,1770566400"; 
   d="scan'208";a="141844744"
Received: from mail-westusazon11012032.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([52.101.43.32])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 Apr 2026 21:37:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HRaZdmzHeRoVhfL3RveIincQfWdzz2Y02ZAN4lhb9VYmX8Tq7Ez0EMRI5RjHE1dlQAV563CLPhcgjpt94XDYMN1peXI7bRxkRxxnjmJXJ2WU7ZyG6lyV5IktGdXqYJ6MXqEvkBYTt52iI4MfNWQWn/wGj9haTLRMx+CJZ9T6q+/ykhqnfWYgirAMxievdg/hvuQK1MeEzXBmOr2N54oqOq0q/WbiK5QFrGOaooHLoCUdxH3UVE2oIuqBW85VIx+cM6rtFnl3goy/2no8/LhHwPpilY59jBOM1vFothTpXbIRZflVOsMK/l6cSylDwPxyexxFvQLLo3kNy+49xg5UAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qrUb8GVFXjzLWDNOVgLR80WBG2nLRqKdGyc2YjNKR2o=;
 b=FiwCSrAtHyvGSUeT/rRfc/vhB7DgFicIf0YT7EiCmFmgQ6VNKmcEhphJItHI9Sn3jEMK0VI377OUpNSxe6eRHnpLZB/uKULPP2hFU/myjSlQbp/4q7kdzzMy8aODQuZdI9nEPEGLPHNRumBVfgqF84EQJ2Czb3P+CV1RwLM6I2FefNZ9PQBSAtW1LnlDqNyq5JXVOi1k3jKyxvdpJSRIIKWVUcIisZ+nN+/OUk2XxN/oVpd5aRTw6EYo6ssCb4CW9MYWuyDFnuiorI+L8xmH2+bbIqhLfYeoG7RyJsKqPXTHHhyKmgeBVUpM2yug9CsNg6jo4Mz8pWv+kpbzGVflHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qrUb8GVFXjzLWDNOVgLR80WBG2nLRqKdGyc2YjNKR2o=;
 b=wzurwHNW4riZVvIMUAL25Pk89+vCYUwDnSO/CllM/aS/nuACoEVoygbFHodLQkDad5tEts5jyvUX4AWUQaNFEO3RCrzlXek50XtO5/AaeaJJHvBbKMDi2kMS17NXNYEW9Jcv3+ewi3JcAFe/5Rxmt1nTwNDcYi/GgW+f4Pq3q6s=
Received: from LVXPR04MB9982.namprd04.prod.outlook.com (2603:10b6:408:37e::17)
 by LV8PR04MB9221.namprd04.prod.outlook.com (2603:10b6:408:25d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.20; Thu, 30 Apr
 2026 13:37:06 +0000
Received: from LVXPR04MB9982.namprd04.prod.outlook.com
 ([fe80::a7f:ee0e:59e0:428e]) by LVXPR04MB9982.namprd04.prod.outlook.com
 ([fe80::a7f:ee0e:59e0:428e%7]) with mapi id 15.20.9870.016; Thu, 30 Apr 2026
 13:37:06 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Zorro Lang
	<zlang@redhat.com>
CC: Naohiro Aota <Naohiro.Aota@wdc.com>, "fstests@vger.kernel.org"
	<fstests@vger.kernel.org>, "linux-btrfs@vger.kernel.org"
	<linux-btrfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Shinichiro
 Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v3] generic/793: limit number of overwrites
Thread-Topic: [PATCH v3] generic/793: limit number of overwrites
Thread-Index: AQHc2BlPFwa0YwxN6kuf5BZ8KADqpbX3nKuA
Date: Thu, 30 Apr 2026 13:37:06 +0000
Message-ID: <574315bc-3fde-4c04-a79f-da7401da1785@wdc.com>
References: <20260429204624.807220-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20260429204624.807220-1-johannes.thumshirn@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LVXPR04MB9982:EE_|LV8PR04MB9221:EE_
x-ms-office365-filtering-correlation-id: 265336ba-b488-4b85-057a-08dea6bd91ee
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|19092799006|376014|38070700021|22082099003|18002099003|56012099003;
x-microsoft-antispam-message-info:
 kKfbtPFhMSbpqgmJVkXrKFO0BTHMP/fs7LwRgZb3V1n4egSAnwKfMk5y4BC7m0X1ygA/Tp+x7+qwRH0LnCpbha711jAEG5CCTw+sPukqTWnlKN2MKD3QhkkTiOiDhRcfg3Yh5MoI85V129VoqF9bbuLWwN/DkUtGs24ITiu6ZhOVc4dz6m95+HKzyDNmHecIVUmivUqoP6HYan6aPiTmRCnGy66NV9UkQTgdPVX5S5NI2cb8FKAOsGtwwE5GAzsCatahZSLIZ6yFsCAbB8jZNHX6yoUZERZUhEvbfwdW3tAYIFYaWMmqUONY2HCgo+KxCRLd9O02v8jGSWyPA7WxW0wEyW+8YHEcNPXTbcg2RPfF219PCLs/5l1pwiodgAIqA0E/xyqSXV5S0lXd2xSO9LbBum0oCBFPMnaZh0MxbINVQtcLt2Oj7bV01vVuIYicCbUf16rG31iTBhDgYKVfr6DboCLyV1AGP+7PYG9MQXxNxYSj79lJZsPPpQlwPrJgTm+pfRMJyiOmfnOaByEQ/X5ZyCzAyIzFrNtyWmD9mfy3BJY7IrEoMYZ9vb1GuH8ajr+GHmP4RugMWWBVTTpeAB/QAIEp0z4tOP5mWSSwre5fwOcRbQG+YVvvkJr8KHmP73fmzAQmq478BintKC/IGTKhzbNRz7UpZ9WHrKA3whWQj/jvl5so5+CnHAWKNuCVX3YX+zDkDsgdkQU6IYk7c2rnWNgyfTvzZkOFgG6xcYKCMaH8K9M1ImAyq97vGFr/0XTQ2kkRmaIi+m6OriBi44uk4IbD2IiuikDdjjTYzuo=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LVXPR04MB9982.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(376014)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WC93SmhNZkRVSXAva3FjQm8vK1p6Z0tMSEtqUWFYT21iSm5pZmN2cCtCV2Rv?=
 =?utf-8?B?UEpGd0kwWXdqQTNSa3czMDNDYkZldWFkSjhHWGM3d01rUHcyV29OVDR5eUd6?=
 =?utf-8?B?MzhhY3pmaGx2RUxtb2hQeW5mQ0hHc3d6eUNCem9OSG5iQnU0eXhWMmN5UGRk?=
 =?utf-8?B?bUg3enl5aFcwbVhKZmovNGFQKzJiajgxUm9aOEpVMldXQk9MZTMwU2pMekRU?=
 =?utf-8?B?emNtUEp1MUU2Tnlaa3BjUTkvWkpMTENvaW9abC9Md0psWXJLK0Ric1ptcEsy?=
 =?utf-8?B?aW42THNlQlltZm9INURCYnhVb0tsV0J4SkUxOU1pOXljT3U5S0ljemhhUlRi?=
 =?utf-8?B?N3BPeERtNjMwY0ljaDdNeThDR0NHTWtGTUFSZVZEeUVCU1ZaaXZySGVHTFVO?=
 =?utf-8?B?bDVENlJHUmRqWEI5MGhTdDh2WW0vYWhRL1hEdnJna2hZSFVEZE92NXROZ2c3?=
 =?utf-8?B?QzFYS1BLNVFReFloUXV6c213VFMxQ09ZNlBqUWNyK09PY0NTaThaWVBjZUtV?=
 =?utf-8?B?WkVlbHFMTisyMGtGTFdNTW1WdUVVZ1FxWmNzZzN4c292a3hGbzVxRGpLTlNT?=
 =?utf-8?B?Q2h2V2hsbVJ3S1BTWUJhWGNQRkU3M0JkM1pYdlA3dEVDK0E4QWJvMnoxUVlN?=
 =?utf-8?B?cGZFc0dTcFAyc0U5dUkvaE1HcHlNY0RyMi9yM0Y1MXZYVnZ0MUJlQzl2b1lm?=
 =?utf-8?B?KzUvcURoNXB1aGdZME50SUNrSGd1R1JJRm52RjlCdnF6ZWVXLzU4M0dPRmk2?=
 =?utf-8?B?WGFldVdLUEVvMEM5NHNRcG5Td1NsZkd4WVpNYnNYdDVFVGt6UlJXbzRqVG4z?=
 =?utf-8?B?cW5aNWF0eEhYdjhvSnpkWEtkaEdNdy8rZVFTYXR3RTdINE1DM0Iyc2NvU1BT?=
 =?utf-8?B?bWJDcGtldWNOY2lqUUVlTUE2KzNVT1dHKzFmWU9VeFBJUFJpOUo4d3pSWGo4?=
 =?utf-8?B?SExmcE1VV2phYU5wb3JxNkFEQllPMlVhSk9GeHY5RkkxcmxqYkFpTjM0ZmV6?=
 =?utf-8?B?RjdpeVV3WWcrQVlUY09LaUJ5WEZkSE9HMmpiNStlNWhYMmV4bmNBUHNyenlW?=
 =?utf-8?B?UGQwMW5BN1JCMG5kRDhRZVlUMTRlWU43WU01RkFERmEwYm80RkRrWUxrQ1FU?=
 =?utf-8?B?UCtibU9tUEJvSzhVeGJOVFJWMTNFekF0WmNRVDhzV21lVHNaS21sUjdPTFFq?=
 =?utf-8?B?NE1ic05iTVhUVWx4VVlYbjVYYW5qVDIvWDVYR2pMb3FVMTBjWm5TTXhvNWtX?=
 =?utf-8?B?Z2NhbmZiSUhKTWZ1R0FyT2J0TFhtVlcwZTFmNjRzTllDdDc3eldzUGxGd0RQ?=
 =?utf-8?B?R2dYNUNnMDEvd3diMWxBdVpIWFRTdmR3SUNtQTNlY2pDeW9HcXBkTmw1cjFV?=
 =?utf-8?B?V3dKN2FoRkVweFZnRFliQ1J1RjI3M3dhU3kvbUVRd1lLUXUwVDlveFJXN253?=
 =?utf-8?B?c0d3Z01CSUtENCtVZ2k0Vys2WkdIZTFTSE84YnU2MzN5Y2loTXFzN0I2QXZz?=
 =?utf-8?B?Vm1ud3lYRzNWanFnb2ZZOStPcCt2Z3Zpdys2V0p5NGVFbWpmZzdSTlFkWUUr?=
 =?utf-8?B?ZFZrT09YYTdSdVZNbUJqTU0vTndLb0U2aGY0a0hnYlYvWGN3em00QTkxTm9h?=
 =?utf-8?B?aUQ2ejN0anhkN1RGemlHenlJVWQ4VlRjVmJBNFo4UWxUcStCZGMzZVZXTXhl?=
 =?utf-8?B?c0VhTDJVNzE0aTk3WktjelZJWUZGbTRQZ2NpUFhrV1Q4UmdzMWRXUjl3a3dx?=
 =?utf-8?B?Nk9WRlRxNFE1L2VqU25qY0lFdy9FR2FET3IrajFXRTgyTHd6WjJTZW1Ndi9D?=
 =?utf-8?B?dHp1K0tuTDNUS3VqQlA5SDhPN2xFVzJ6K09oL2hKWS9RT0VCYUNXVFFUMThW?=
 =?utf-8?B?dGZERW5nK1JnT2Q0dGpsczlwRGdFWUhxZkN1dW9TK0Z2amxIMnQ5WFNhcVhW?=
 =?utf-8?B?U2VpeWxucFRqZXdJL2hUejZIc2hrZ2FkKzJ3Z2N1Y0paVTVZN00rb1JGaFBQ?=
 =?utf-8?B?OWMwdE01UlpwZlFlc21naGJwRGRUQ2Y1NTRJSnIxRmFLZUVMcmhxUVhQcVFH?=
 =?utf-8?B?RTZPd1p0TFZVQkp6TlNUK0hKMVBmN0thODh2R3liNDVvZXEzYWlicVVOQ1k4?=
 =?utf-8?B?YUl1cVpUOFQ1RUtMTjE1R0JnMGNtajdLYnRiVWlSRmFOc1QwWVhqbWg4UzBa?=
 =?utf-8?B?d1lwWjVrdldzODAzUGtqVGd4R0JKTFJxaE9CeHRZMGtub05ERmJRM3YzNzAz?=
 =?utf-8?B?cHIyZWN6d3NXN1gwYmNXM1JKWmVlZHdvVFpEVkM2ZndZMnFDYVFoMDRnQUhy?=
 =?utf-8?B?YjAyUWdDU29mTktWUENUZ0luT05YSUUzbUc4RmNUN1RmMXk4ODdJUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <13163F992E75B541948C39CF942A3DB8@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	sDqrReKTDYM6gpvJKw/8cuUaUd78vfl1puRaf75v726Y2VM1Z3PxjRTqODDN63tW6XOsgPO1VT15ezMoieAAb0fc9qZx0rH0+P11BsBEG9sPptUStsL8TRJz33kAdbBQavRNE+mdTAl/jNwqfYBMsXQvGd65fZ8pet4UD+ZiX+G/xWsU7JOTokbZgRfJYDSyRiLLmHHNKWQvqQawam4+RWlLYKQ0kmcRw/v1j/e8wzydxPKgQ9mxqf8H6AwRQonykupRu2vmDI8IlXkekmP6Gm7SXfj3g44DkCMUsvmIky29l7mIXD/Y6w8i1E+o5ORPwrJlNQpjRs11wSnCm5Reqw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	L7TOFGG2LzxF24OQDaDk0sN4ScYZgtvQyXk3vJacM7VbXCODc7rduWaB9j8MZYapXsJw8pyTKL74RkNxNEemYrR/MAHvR/qKaHAMEfa3DHuZ9CGYfxpBlkOkqpKHtPW2GLgGp3DhlXd6gnPLvxhzTu3u07AjPC6pscge6KBDTIl4/rkb+jnVDSir74ZRU9iwCI1p38/Et/yvBf5CMl5SmF5sWYfTajjy282JVzhuNeuFn9B8yzjami7pc2ySxtOG1D3cJEX93OWJuBJPHt3KJZSd7OUtTWts1zzg6LHthnute0PPk5uj5iJogcvsK/2CPBNzjm2zImAjvrs8U8l4AqR/jKijuw3lexpUP53+40iRTtgWtQyM9icLxWpn3rtH4c0+WGuzc4IN1T+IbdkHKc+TS6NjrTyhkocajtMKkGp8jLPMDdupRW1x86qMUeTGD7Qi/noXdYnajrlxAibFKnpHqgI23Wfry4zHLohhO7FRME6Jb4pfFysRlF/Z0zoLGnyVsWyjocDJgc2L6htu6gyuJd427KluUHwxLYbWS+1jECamcCZiHCGxuT1ao6dsJUT+aKa5TWccB9pG/vW5uPt1sacMc7M7azf1RdBMEDHoXuedEJHWVIXtYo/D0/gy
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LVXPR04MB9982.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 265336ba-b488-4b85-057a-08dea6bd91ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2026 13:37:06.0248
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1pX58hE/jZ4iPrw3+CLxGwf0dwXpDRd7UcmelZpzw4AKZxWA+tI72A6UktViUbqhm373ZejyGwJ1b7uL4/Hfhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR04MB9221

T24gMjkvMDQvMjAyNiAyMjo0NiwgSm9oYW5uZXMgVGh1bXNoaXJuIHdyb3RlOg0KPiBUZXN0Y2Fz
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
Pg0KPiBSZXZpZXdlZC1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IFJldmll
d2VkLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gU2lnbmVkLW9mZi1ieTog
Sm9oYW5uZXMgVGh1bXNoaXJuIDxqb2hhbm5lcy50aHVtc2hpcm5Ad2RjLmNvbT4NCj4gLS0tDQo+
IA0KPiBDaGFuZ2VzIHRvIHYyOg0KPiAtIFJlLWFkZCAkQkxLWk9ORV9QUk9HDQo+IA0KPiAgdGVz
dHMvZ2VuZXJpYy83OTMgfCA5ICsrKysrKy0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0
aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS90ZXN0cy9nZW5lcmlj
Lzc5MyBiL3Rlc3RzL2dlbmVyaWMvNzkzDQo+IGluZGV4IGE1OWU4NDY5NDMwOS4uMGQzYjBiZmNh
YzVlIDEwMDc1NQ0KPiAtLS0gYS90ZXN0cy9nZW5lcmljLzc5Mw0KPiArKysgYi90ZXN0cy9nZW5l
cmljLzc5Mw0KPiBAQCAtMTEsNiArMTEsNyBAQA0KPiAgX2JlZ2luX2ZzdGVzdCBhdXRvIHF1aWNr
IHpvbmUNCj4gIA0KPiAgLiAuL2NvbW1vbi9maWx0ZXINCj4gKy4gLi9jb21tb24vem9uZWQNCj4g
IA0KPiAgX3JlcXVpcmVfc2NyYXRjaF9zaXplICQoKDE2ICogMTAyNCAqIDEwMjQpKQ0KPiAgDQo+
IEBAIC0zNCwxMiArMzUsMTQgQEAgX2ZpeGVkX2J5X2ZzX2NvbW1pdCBidHJmcyAyNThlNDZhNjM4
NWMgXA0KPiAgX2ZpeGVkX2J5X2ZzX2NvbW1pdCBidHJmcyBlMmE3ZmQyMjM3OGYgXA0KPiAgCSJi
dHJmczogem9uZWQ6IGFkZCB6b25lIHJlY2xhaW0gZmx1c2ggc3RhdGUgZm9yIERBVEEgc3BhY2Vf
aW5mbyINCj4gIA0KPiAtX3NjcmF0Y2hfbWtmc19zaXplZCAkKCgxNiAqIDEwMjQgKiAxMDI0ICog
MTAyNCkpICY+PiRzZXFyZXMuZnVsbA0KPiArZnNzaXplPSQoKDE2ICogMTAyNCAqIDEwMjQgKiAx
MDI0KSkNCj4gK19zY3JhdGNoX21rZnNfc2l6ZWQgJHtmc3NpemV9ICY+PiRzZXFyZXMuZnVsbA0K
PiAgX3NjcmF0Y2hfbW91bnQNCj4gIA0KPiAtIyBPdmVyd3JpdGUgdGhlIGRhdGEgIm51bWJlciBv
ZiBzZXEgem9uZXMiIHRpbWVzLCB0aGlzIGlzIGFyYml0cmFyaWx5IGNob3Nlbg0KPiArIyBPdmVy
d3JpdGUgdGhlIGRhdGEgIm51bWJlciBvZiB6b25lcyBpbiBmcyIgdGltZXMsIHRoaXMgaXMgYXJi
aXRyYXJpbHkgY2hvc2VuDQo+ICAjIGJ1dCB0cmlnZ2VycyB0aGUgb3JpZ2luYWwgYnVnIHJlbGlh
Ymx5DQo+IC1sb29wcz0kKCRCTEtaT05FX1BST0cgcmVwb3J0ICR6b25lZF9kZXYgfCBncmVwIC1j
ICJTRVFfV1JJVEVfUkVRVUlSRUQiKQ0KPiArenNpemU9JChfem9uZV9jYXBhY2l0eSAwICR6b25l
ZF9kZXYpDQo+ICtsb29wcz0kKCggZnNzaXplL3pzaXplKSkNCj4gIA0KPiAgZm9yICgoIGkgPSAw
OyBpIDwgJGxvb3BzOyBpKysgKSk7IGRvDQo+ICAJZGQgaWY9L2Rldi96ZXJvIG9mPSRTQ1JBVENI
X01OVC90ZXN0IGJzPTFNIGNvdW50PTEwMjQgc3RhdHVzPW5vbmUNCg0KTG9va3MgZ29vZCwNClJl
dmlld2VkLWJ5OiBIYW5zIEhvbG1iZXJnIDxoYW5zLmhvbG1iZXJnQHdkYy5jb20+DQoNCg==
