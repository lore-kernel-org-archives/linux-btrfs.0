Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB422750FB;
	Mon, 13 Jul 2026 07:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783928670; cv=fail; b=r0pZnP8jNUF4+Y9MFQctKJNFU/0SISUZQAYeXg4yD67OvI74kJNdCdmk7wBpOgIOw6Ypn0NMhbNJxLdIT5G3M9SAueLXs2q7HvmOy7cST6k3dOWN+F093SgoVq8OgBhuDOriKga55f+N8DKWbCJ2U6Bc8gaNHDCH3u6YfJ8R4GI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783928670; c=relaxed/simple;
	bh=xgZXgnYWvRZupF6h1c9XCs26sE2BVhDOXvR9dFdiyOE=;
	h=Content-Type:Date:Message-Id:Subject:Cc:From:To:References:
	 In-Reply-To:MIME-Version; b=Qaz99PA7tJCgu9ixAHSqkMS+T3jZwpLPhDplV34y+3i9dapzzjAJ8l6ihxMqpVkgmd9loEONLBGNkjujjXhMSPSpiedj9lVAdHFhA1kf1vWzNPlFRtJlQNKWf9IZoJO7n9gt+0Yv5R9nLAfLqP7pZgMdwT1heypZga3ZRCZFHIA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=BWWC1p8/; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=fnb67v7N; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BWWC1p8/";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="fnb67v7N"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783928668; x=1815464668;
  h=content-transfer-encoding:date:message-id:subject:cc:
   from:to:references:in-reply-to:mime-version;
  bh=xgZXgnYWvRZupF6h1c9XCs26sE2BVhDOXvR9dFdiyOE=;
  b=BWWC1p8/kAwwfUvqD4/zRPLl/VXfhr8aOjM792bH0tiNAhbq3ICipxWe
   Iu2U0+NO7t3MSftLxvc5JqhrAChVgWnlbkXSqx7OoBpVrSKXA/EcP+2K5
   bq3Y+8psbUkl9um1Xvi+aZx8zii/saLdNjULxq5HttTJ7WJWHDcEYXiHG
   XYPP7a/YS2A6hqkG2tRz82M1vt0cnJgIIIzkq8+y7ygUtecteykxw/Oam
   J9BEzerJzxCmCbRxqKkILIasB4CQIdMvKVijjydqe1731gTB82NjfVY6G
   h6bM2qXQS+DEYWKFfrgWak4rnH7Fu4uv1xmLue1T5M3Rjn+/BTHB33UvW
   Q==;
X-CSE-ConnectionGUID: 5KntEJ4xSZmnDkRYLuZe/w==
X-CSE-MsgGUID: 6oF3I/pwRj+fBh64z7viJQ==
X-IronPort-AV: E=Sophos;i="6.25,154,1779120000"; 
   d="scan'208";a="150617344"
Received: from mail-southcentralusazon11011066.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.66])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Jul 2026 15:44:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mwwj0KICUL8gYGtednxKU3V93xbIRd8ajXqSRWV67RUtZ4Oe3ZGNHfCmCX8ODjbuWNEg6C3DlStO28XvkXAmmXbgO8oIuXbnAyiNmYAIuBj5WNzVcQDG5IgWSfkTF5wd0pqIMYreIktXlqpRoVdrJi0LEZ78hfbIVaifscWkmMRk9MftGEIHfHFUTqMrrXrNwMMvXu4a7abQ39SuGwG0mYCuepTEG28cBhAXWgtRQrk5C+Ch+GYxqreOxpJikywqvw/Ic+4ZOkm1vd6HeKyxEcvbDXWwi5T8qDbHN1TeqSBCjACaszgpWK1aLbWKYe66LB/Y8CJ+VvLjrbQgKWhVKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OSETCCuGfldJa6R1Lzqsv3SodT3Weh5x9G57lmRjLuE=;
 b=GvI9xoDZo4gCG25yVv/CjmF/z38fDcmEPJt1oay/kQG6mX5WY/AacSfMAfwGZoXRHm3ohKyIHhBCsB69F3xd+qU3QJVo5NH3IWrTxc0VVqjxIf2QvKPqoOsKSa0Slv7U1ImtCt2PFxxPz7sglwlUgl2Kjw1aR05Vbzm2nHdlGNvZFs3UlmBrSgvbJD99SQYlXDFzWgi0ZQT47ECkDEaLG0knVGwCiUbR8WImPThaO0N31SPMiv2sp6pmfa89m/o9+w/VqsxBzDDfXa3Wg0YxPuiZVdezqUD2iL5q8AuFGljWV74riGKdQvMWvfPxbdpthlKmPnZiomOIcfFm6WcBWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OSETCCuGfldJa6R1Lzqsv3SodT3Weh5x9G57lmRjLuE=;
 b=fnb67v7ND17aW7tXOvkVKz4z00zFZYbacXBFXxLGEGB0yGw9MAH6S9tcsRlfirC2OYkdC4GEIq7qtbZ12m4hEAr66Ka1Tuh/ifSUxQqKh2AzoiQYN7mlxCdDQP3Tmr/4LgRpfUfTVbAXrpWZMfmhiIQaTJ7qAn9C4KCxcdCMDw8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV3PR04MB9258.namprd04.prod.outlook.com (2603:10b6:408:26a::17)
 by DS0PR04MB9687.namprd04.prod.outlook.com (2603:10b6:8:1fa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.23; Mon, 13 Jul
 2026 07:44:25 +0000
Received: from LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2]) by LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2%4]) with mapi id 15.21.0181.016; Mon, 13 Jul 2026
 07:44:24 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 13 Jul 2026 16:44:20 +0900
Message-Id: <DJX9XKV9KB79.MPNAOA8Q6MQC@wdc.com>
Subject: Re: [PATCH] btrfs: zoned: reset meta_write_pointer on zone reset
Cc: "Naohiro Aota" <naohiro.aota@wdc.com>, <stable@vger.kernel.org>
From: "Naohiro Aota" <Naohiro.Aota@wdc.com>
To: "Johannes Thumshirn" <johannes.thumshirn@wdc.com>,
 <linux-btrfs@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20260703055445.117214-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20260703055445.117214-1-johannes.thumshirn@wdc.com>
X-ClientProxiedBy: TY4P286CA0078.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:36d::19) To LV3PR04MB9258.namprd04.prod.outlook.com
 (2603:10b6:408:26a::17)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR04MB9258:EE_|DS0PR04MB9687:EE_
X-MS-Office365-Filtering-Correlation-Id: 20a3a1f7-4bc6-4584-69bd-08dee0b28f17
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|23010399003|19092799006|366016|1800799024|376014|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	nKOFALDXYeef88L4mls2NsTzR8Ha4WdsHQhC949wAv/1JUm9/xWhzC2chFIVYme6IyfNr8JTljz4e8LTLleUYIBU+oPJDJQQK6rPIvRLr2bV9gBK1AyoXineFIVv3V3i4vwNh7DytxFxyvDucp4C42Uz6IduHUn23t8GRwJbnHRNSfCi4+SGjA0Quk8WmEUM8B+fTJy2uU8zH0un2pP3bGQccEK9bIW/zqF3eiDSUejndltNRQCc105VeINLzBqpVChLAFFN2kA2CTLEyGuQOmRznTPP2BomubDRq0GlVMMuF1HGLCClcdrxUWc8FLDxnkDWxU+Itif24kxeY/8X6RWxUC0nUdwTS1EOuc0Vthdhs5yW99RktflH/7XiZ+mP4BsEtcrBTF49th/LKGb8stClk0vYrJ5UdSJ/uTl+PfJ7KaDOUU/Jc7pWCUVJzU17cjS61BgGs+HqnqZFmMHbZLkUmPtUkoBtXyOEnm6NK99qNpWATBIWP+0i5GKcGZsf/46VIt3+hVH7zfVl2vmZAE4BvTa9qhMxHNT9xfm6rxetYkNhTzmlt3U5mJ8qTS882E5InHHAg6Mpz2NNXqV13/wgoOuTYmCmF04nH9kKeTQ7hEp+VjxW1moo/DqfzaFGqIkT4HpzVtzZgvkXeoEOacY46CZ4KXSYcgfA3c2uU00=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR04MB9258.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(23010399003)(19092799006)(366016)(1800799024)(376014)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OVZIMCtOenVxYmRpOUFIQ04wRmFRVG1LWks4bk5LaWpNV1JVb05IVGFZb1Va?=
 =?utf-8?B?dlNzQ1prV3VKc0tkNEFtL1hNdGlBdzJ0SjBZU1hlS2RYUUdDVkpHT1ZnQWlY?=
 =?utf-8?B?cFIxTEJxS2UwZXkrbWNMdFJVNHVyM0hxMk53R2lmZXFvVUI2eG9kMkpicW51?=
 =?utf-8?B?TkQxU2YvTHh3QllPNi9ONkFpL2F5czU2RWNRQ3AyUHExRzdsY2NkT1VzeXlF?=
 =?utf-8?B?SVI2UkZZSmtxekpsWGZrQnRjSlo3VVlUd05DOWltZytoSVZQR3JVRUtLNEE4?=
 =?utf-8?B?V2NKbnZocnNqQnAyYUsrUG9kLzBMdk5OR0hRSWxXMm5PbExoM05qekJqWjNv?=
 =?utf-8?B?c3BEc1V3ZjVoQkNpbWpHNHhQb2c1bnNwNE8yZ0VOYzFRTStrMjQxNXFWZFdk?=
 =?utf-8?B?ZU9ONEhVYlpHWlJvdWRoNjhSU3NnemROays4TEZ5cTQrVkdBWXdXRk5jTGRU?=
 =?utf-8?B?aldvb29tZ3VldjZzMm5IMW9DelpEbi9zTVNORllEUnUvRjNuTGRxYlE4Nkk1?=
 =?utf-8?B?cFV3T0NTdEI5TWFsdDY5TURtTWZ6TjZSeUptM05HWFVtN0FLbXZveGIxL05y?=
 =?utf-8?B?cUtQVnlCRlRiY0xycWllcm8yajhENHNoZHpXOU53UkExTnBWME92bVM0S2xT?=
 =?utf-8?B?WGlXcFF5dXZ1TmpVT3ltUm9keVJrUnpsVTlUZmY4a3crNE5KWkYxUlpnMHNw?=
 =?utf-8?B?MjdPbWJWMHVhNU0vRzltMU5CWTJlSG1EN3VLbldYQ2QrOUl2TTFHTWdGZUR3?=
 =?utf-8?B?dXFrSzlVTjhnVWlHN0YzMG9SZzhjNGZBTytXTHVmcG9iWW9ockt0OEZKM1Zj?=
 =?utf-8?B?NDNJNHhSYmNBbXYxRU4xZ1FNeTNpYXFTVEJGTi84ZXY5SXlwUWo0aE9OSTZJ?=
 =?utf-8?B?OUpCenhUWExsQ0xOWmdUSW41Qk1CNTB1V1U5d2xhaGFNZEFjd0lGWWpDM3kw?=
 =?utf-8?B?eHJucENjaUFsNDdZYjBjZXRtTC8wcjNuU3lEQW84dWh1cnNjWFFuTHZnZ3JM?=
 =?utf-8?B?UndBZWxGOEt1eDFtRGg1Q1EyeG5Mai9qUGN2OC9BZU9GT1p0cVVHYm1tL1ZX?=
 =?utf-8?B?WmQwamlPdTYzSHlhT0UvZG5MNVRZTUhleTlsQ0xkMWxpcEtvc2RNSlRZQXRB?=
 =?utf-8?B?YWVqRVJlbENzRDE0dDJ0V1FTb2xnbjNnTXNyanJzeTNFbnhpMTUycHlxemxJ?=
 =?utf-8?B?U1gvZTBxTDZ0ZU4rNkZyVlNETDlkMkQ5UEZpRUNqWU9jUGR4WkwzRG9BanIy?=
 =?utf-8?B?WHZlVkVucUNVdFVkazN4VzBMdFdtMURjRktydXY0d3BKZEdCN0drVnJ6MlVR?=
 =?utf-8?B?d3U1aDZIdEF4b250UWRhN3dDTmdVczd0aHRqUlB1VXV2bTFFTFROL3YyU0sv?=
 =?utf-8?B?bTZtT2RuQnNsRDYzZzFRYk5BRlFRUUJNcVU0eGFKVE1BYVNubld0blRhV0t3?=
 =?utf-8?B?cEdQeER1Rm90OVVUM1lSUkFsT3FSTTEvdVdQallDdFJwc2xCemNBUFpRTi9M?=
 =?utf-8?B?UElIakdUd3E3bnN3dGswNzJUdk1TL3BhT0FPWlhFNitzeW8vMDRpSzdMTWQv?=
 =?utf-8?B?eU53LzZ1cERZU25rWUV3RDVaR0g3UFltVjMvYzVMY0FDWm52Nk1UUEFhbjlh?=
 =?utf-8?B?dmpwR0NoR1ZDdHBJZVpvOUJuT2ZzaU5kRGhRek5jT0RyN1EyT3JmaTRVUHVC?=
 =?utf-8?B?T1Y3VUdOY1IzWGxjVENGVFZPYTlMMGp0c3FnQ2ZqRURSN0VpZzM2Y3hnNVp5?=
 =?utf-8?B?Yjd4MUJhRlc3SUJWempxNUVqa0twbDFETWU1QnhoMi92dFk0SmhNU01FN0hU?=
 =?utf-8?B?NER0b3RjUmQzcWFCOE03V2I1MDBvNFRkV1QybWNGVWtsY0lKSzdJaUEyTXJn?=
 =?utf-8?B?VU5aektLaDVOY2d2REVWR3oxV002K1J4cFhZNGZaUis0KzRBRzYyaWhlSkhZ?=
 =?utf-8?B?UEp3Mmc1aTNocUJENWpCYUkrVU1yMHU2L1VYc0Y2dm9RRkt2ZCtEVXVtWDJh?=
 =?utf-8?B?Vno1Vk5MblBkNytIeWRQSTZwdjFZS0tkbmtpRkF0b013R2hLUnhEZTFtTXpV?=
 =?utf-8?B?ZmtRZk9VaUM1T1NoNFhhZEpySnVkdXpuT3hqYXEyUzdqclpMc0hqdnFoSVYw?=
 =?utf-8?B?TEh5d1hkQmJwNVpRc253cGFlUW95ZWdiTFRKWGN5aWdnWFVHUGd1a0FkMi94?=
 =?utf-8?B?dzZORGhzWjNHd2xpZk8rNkd4NlNENnk2eWdPcVhIUDZrY1g3c3VpblJSWXJy?=
 =?utf-8?B?M0U4dnhxa2J5bzlLMkIzOUhtaHVEQ2psN1Q2a05GMHdwTDdCUGxLL0pzU0Yr?=
 =?utf-8?B?OWZLUUZ4NGVWMURsWWxZTzhGdVZtaWtTUHpRc2JOODZETnZyNjBTWEl3dVF0?=
 =?utf-8?Q?WK6/deGLbOHXJXngyIYB3v3eC5g2du7xMZoDUUC6EUNnG?=
X-MS-Exchange-AntiSpam-MessageData-1: o2txISrx0PvjFw==
X-Exchange-RoutingPolicyChecked:
	YmmBra/XfU17YLd7jruKgXjwlk9nuojHbhDkVICGllP0GZJM4c12xxdAq6oAXT9CC0hXHDdmYYA1g67d5KPD5d/kPfyB8Umc+GgK1z9yiRS2EywdU2Z4oWF7FBL052kYn3W0Il1P6Lu8x5v78AzjBrsk6JEr+en7r0Y9E+7IN2aqusZZvWP/2xus3ko54VXXv30xskVFufO74unQmyiNsDaInkszxBfSREg/XXp5jSsV79wi4s7cfL0iq+768+tJMeF8TtVcBNLL35Ek5auojkwdpNRd70sNcxcZCqs80/HQkplqAWxTHmW3qoObZxKiHJuTazljC1uJuYhX/AfA2A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VwKeHV+9JJYj+sgTFnOW7puMpAMsPViTyAZBfKOSpOqh9oqCA56+XDJAo1Ev+m+95Cja/CnF5gmonSaI4bbA1up5Ioge/w8bu0IfzeisPEKxedwOv31sJpw0aEJPQYS+ejroR5VJowzSsunA11tLMWVZHOsuogTqcS2Ebn9i3f69BvRdtn75vXOlmUARbsGw+Px4mmk9oxs02eu5Y99TfOCZGHULiQTyb1D/Qkcobi0ICnD3DR169Az9vIKr3AOf1ASPfEZlX52AtmFQc7lPir86UnR6pLB9DmiiMcb7U1lB4AwXgi/YCNoWZZaRobR7wO/Axivbn3+5WKNlG+voCgbTIqiSDiswMdKp9XbXfv1YJmCiI9/iokqP+4T6oIM6ad1wC9a+fzqLzMbRcg5oGjumUHGqISkk0LyrxsfPMh+KS6c2GcBJAPQBE7YPqW1MLGkXd5hcK7/0gpMZSg6Zqs2r7rUDpQG/M/CGSYfaqHikx9ppYyKxWq98E52nFLA1usZR004aRrBQ2DkG3ujm/A8kHzI/NpTh/AzaOHq/ddwTvx9iwu5+gMJU2eCfxxWVr89uIXJfIPJOcpCd/yIuUxHOu3JHoRTCSqcyKEOOMtTJgQk7zmST7N3QO1v2l/CR
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20a3a1f7-4bc6-4584-69bd-08dee0b28f17
X-MS-Exchange-CrossTenant-AuthSource: LV3PR04MB9258.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2026 07:44:24.4745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xafqEdn38B7b3t5rK8bfTyIoclkK+IK2W8RITT05L8sou5zGUednMDMcGdnPO8z830fEFCyiBoN6mzchr+XjMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9687

On Fri Jul 3, 2026 at 2:54 PM JST, Johannes Thumshirn wrote:
> btrfs_reset_unused_block_groups() resets a block group's zone and sets
> alloc_offset back to 0 so the space can be reused, but it leaves
> meta_write_pointer pointing at the previous end of the zone.
>
> Once the block group is reactivated and reused for metadata, newly
> allocated tree blocks live before that stale write pointer.
> btrfs_check_meta_write_pointer() then sees them behind the write pointer,
> so they can never be written out in sequential order: the dirty extent
> buffers are stranded and pin their btree_inode folios until unmount.
>
> Reset meta_write_pointer back to the start of the block group for
> metadata and system block groups.

Looks good to me,

Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>

>
> Fixes: 453a73c3069a ("btrfs: zoned: reclaim unused zone by zone resetting=
")
> Cc: stable@vger.kernel.org
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/zoned.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index ab7c3cc52599..765655473263 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -3218,6 +3218,17 @@ int btrfs_reset_unused_block_groups(struct btrfs_s=
pace_info *space_info, u64 num
>  		reclaimed =3D bg->alloc_offset;
>  		bg->zone_unusable =3D bg->length - bg->zone_capacity;
>  		bg->alloc_offset =3D 0;
> +		/*
> +		 * The zone was just reset to empty, so alloc_offset went back to
> +		 * the start of the zone. For metadata/system block groups the
> +		 * write pointer must follow it back to the start of the zone;
> +		 * otherwise it stays stale at the previous (finished) zone end,
> +		 * and metadata written into the reused zone would sit behind the
> +		 * write pointer, could never be written out in sequential order,
> +		 * and would be stranded (pinning its folio) until unmount.
> +		 */
> +		if (bg->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM=
))
> +			bg->meta_write_pointer =3D bg->start;
>  		/*
>  		 * This holds because we currently reset fully used then freed
>  		 * block group.

