Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7110F33B951
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2026 15:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779205744; cv=fail; b=jYAShrbWbIoY10I0VMCl0TEZuh9W2s9lOAB8jFgIqXzR2Bq3nxafuAUlXcBsLyHMBC4kfQOAFnrQVrOXTYbOTXLdVrjByJFQzljfB+Arcj68JhPm7beQ16e2nYSdsDJ1WjH0ZIy5mNxSYwqwEpFpclgN4aomhoapU32lTBrUcQI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779205744; c=relaxed/simple;
	bh=8Ciaw2wdeQMxb/tTcVN/5IE82kxzUrehCEd7VS5AJOc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZOuuR+LQk99E4G7bP3zlgqAuqb4Hi+X0Rara1QOe8jSvsRG5tnb0SitEuJetPG4GysrScxXuIvtmfZWxBj/5lDcvXM3+rQCgcJOb4iQ4wiEb7xf5ym10fm7yP2XPF/KbpE4aBT9v2hColEx6Qv/OqYyvfwAQnrCPFsEgNwfPpeA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=GqLVQ3Qq; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=dC+r/JEs; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="GqLVQ3Qq";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="dC+r/JEs"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779205742; x=1810741742;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8Ciaw2wdeQMxb/tTcVN/5IE82kxzUrehCEd7VS5AJOc=;
  b=GqLVQ3Qqfn0BJlwcRmvQA3xYqDxq1cnSw/0VEIUjB786pTdt9Yx6/0r4
   hJfKZ4Vv9Ud613PB8V/+om7DnCGsjlZEjjMrPVW8SD9JawdIy87HLOllV
   mpWmU6P0vF1E2d8vw1iIdHeTtQkIRLP3UV7nDtzv65xP5UNI0H2BEZfzw
   nloIBzHZd9dGHaeW4yxDNIYAchA6nfHrqXvHIkW9bEZy92KTm60UlZg6J
   F2CMsSBaCRn6X3W+942zByHZQ3mRTWQ31p1yQx846kycoGiqGNW3FuJYV
   eZPJti0EA25V+Tn2Q94Jga9kDDQeQqBtxDlrbS5655U5/bQarhbQM72IT
   g==;
X-CSE-ConnectionGUID: cKKMRV2/Rh6uJK1b7JbVzA==
X-CSE-MsgGUID: I+A5ybszS6+JRfV8XD+xXg==
X-IronPort-AV: E=Sophos;i="6.23,243,1770566400"; 
   d="scan'208";a="147271217"
Received: from mail-eastus2azon11011031.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.31])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 May 2026 23:48:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=URo/QFtkYn7YVvIuEVUyf3zBkgPatVZqVndK+lwlLwjUrkk4HGV3PIxhOwO0A/AXQzWTehy4kg9bAVQbvc/g+lThtZ0jZ7opGQ6XMkqXCw/XHzLy4gbjqmkM4kdGCi1ejA/NjIotwmRkxyP1ZBYGWD26B2b/cZGccMKyPRN+IWoyzlBbzbJKyRcEJH/NhJYzwWzjY3wWY8BtAvqZ0o5MOxjvIzUyUnczTPK4pXW4+BP0URgoxr8FdJ01Z69EKERUG9WsLIg4rJ55qPySNLKWBKZtPclspMqn4M1fZBxfWgzko99s5QhQ/jwgMNl/+9lhvCB4K0VeOzzuYolFHzSPVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Ciaw2wdeQMxb/tTcVN/5IE82kxzUrehCEd7VS5AJOc=;
 b=FDKHdxQFve14qPaY9ROMrC+7QSNqKHZDUcTrPDjPiPrkOkZAeJRB+EWDYJBhV+U38jFyFEQRIBC/es7+hjB0sOV/OqnmEep6veWcKXCT8hB+6U0n21kDuYXaN9cYtN81c10DBnb7brt9J0zJLdCkr5fhRQeNvFLn+A9ssC9H+6gMWVohWqiL7bCclbdd35hPlBfWCHP43ZvXilzoCcWItecKM75VLECftu6ES7EYaSBqrZJbLUTmhGLZB+qpF+c9eVkCvmkqVAy845F81aYrDDlh3Tdvmt5oVVuLvESPhDpDT/7xaU7UNS9AlKAvEZ0W2/27pbcqQtm9vi1+g6K5fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Ciaw2wdeQMxb/tTcVN/5IE82kxzUrehCEd7VS5AJOc=;
 b=dC+r/JEsUHP+XEH9WJ6RkrmMAo/k9f/9ZyAKHQ4+ITpjsmwORTz+PoQ7DdXkHhC1ok+9Qv2uyqwKx+YOCAuU/MVmtfp5f2422HNqseNVE8n1nEyVSWWZJzchlTzHDoT/xpPZozt44QVu8AQUe1LEvmIuVoeJD2N65r2P30JByZo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CYYPR04MB9030.namprd04.prod.outlook.com (2603:10b6:930:bd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.21; Tue, 19 May
 2026 15:48:51 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%5]) with mapi id 15.21.0048.013; Tue, 19 May 2026
 15:48:50 +0000
Message-ID: <42fef513-7db0-428e-8a07-642514cf0abb@wdc.com>
Date: Tue, 19 May 2026 17:48:46 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/28] btrfs: add trace events for fsync and inode logging
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org
References: <cover.1778776706.git.fdmanana@suse.com>
 <7244807c-dc19-4b24-bdf0-ea9853641c44@wdc.com>
 <CAL3q7H6kzbbbrN-C5_v2_rjeOVFS3=nW5gM2urXsRJKtHx7-_Q@mail.gmail.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <CAL3q7H6kzbbbrN-C5_v2_rjeOVFS3=nW5gM2urXsRJKtHx7-_Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0341.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ea::16) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CYYPR04MB9030:EE_
X-MS-Office365-Filtering-Correlation-Id: 217cdd85-8082-449e-8d19-08deb5be1ef8
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|366016|1800799024|376014|18002099003|22082099003|56012099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	j/1/EEN2kV5+98lEU9D/ZJ+nlI5KiHj7edjxh1TyCbTqWdhXodpZXRZl4uGYU4IByUWzH+MU1+I/0hhga+u2Od0UzB1hDMlBmcjGZz0tcTwUPRoMkB9J7a1zxmtfCEAro9NfYrzMdtTGwjde9G0/nJvqlBMZh7ZHxuUBlq6os/xCNxUwUmvDpUvK/gGJf7KNgEyYX5ckJ9eZDdl1RhESy15ob471ov1gsYjLARU0KRc4Ez32rQJvITdnpDOhlyYQzS+05H4SsCwMxGBpXz10RsmL1EBRLWGLADvWoZxowpZB+jSDbwcZvV4bNJ21H3F5c4tJc8d6inCupZAJ//kXQAiGdijqu2uFbcogtw9td6lpKXd1cBW7gvWPJ4NTZRt/XIYu137IFK+LjZFB+s/biPGNVUzIJd+yfbIvQFz7TLfUnOdcMp+f5EWPInEL8zK6a2aSJNslkIkiKZ5vM0AlkZTxxXr6SWSUz+UbOHj/pCAk7ItT3sl/g43kwrHDFS2FYncrK8MEG1TDSAYzPSRQV9bOGbbzBXYFv5AMe5vASHk9RrPEM4xFk6TyI4w3YXL1YYxqoRmQLzMTGvDRzUo0lR/YJPbx+12/JfwJLvC3AyZUfSaMZGlWRnmFa95h5RYyIt6KL8/Za7S88Zic4MOux8qWk7zDR2JCcsdljU4Gg/e/Aslt1js3FqvaP9wgGJqjDqlQTYMvcTiybVi4Z9LlyQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(1800799024)(376014)(18002099003)(22082099003)(56012099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b3Z3SlhiVWtIMEF5UHdDbjNjaEdreStLWnRGblJZM0hMNjE5QStYOUdXMkQ1?=
 =?utf-8?B?TmRMbFIzZWxLV0oyNzhXL2kvRUljR2VjdTBqYUU4MTA3NS8zMXRVVHRrMEhI?=
 =?utf-8?B?MFhMZmFSUXgrbzNNRUtnRWxNYzRZOHh5NkFabjFsSFJub1dCZWk3VVRoR0d1?=
 =?utf-8?B?MzZsSFJBUE5tQmkvOUxSTGFIS29tVmRaTmlzTjlxTXVWUWFjeVJWNG1hRUFj?=
 =?utf-8?B?R0NxYkJPeHozS3pXcG5kb1FSZjF5MXlYN3hYdEp3eGgwMFpMaDJZVGhla2pr?=
 =?utf-8?B?VnlKYlZWb0c3MzN6c2F4M1hwekdHVXZyS1c0TGUyOExMNk1OZHpHamF4VC9O?=
 =?utf-8?B?aWJBcnlaVm5QcVpiU0Qra29xRUhNR2VibUZoa291anFSUWhISGUrU2FoRUZm?=
 =?utf-8?B?UVREVHVEOHNSRE5LRm95U1lHRklmSXNBSklqbENiaXd0MmhqNVE5Y2FMVXkr?=
 =?utf-8?B?V2xSWWt0QStvdG9kNFlPaHI1WHJteG1SU21FVVB3dnVuakQzdEdhYkcyWjFR?=
 =?utf-8?B?UDdvdHpoYkk5bnh4eDJGblB4WFJOWG9VOTMyOFAzMEh0VGI3TDZNQ0F1anF6?=
 =?utf-8?B?MUtYWjFrY1VNeEdITmNEbHltMFZnTkd1QWlGRmtMKzJLUVMxd21HOENaVllP?=
 =?utf-8?B?UVJCVHRQUll6b3BlWHY3VC93M0gyVlQ4WFdybTdQaUd4T3ZCam1nRHV2N0cv?=
 =?utf-8?B?QlpYTklCbkFWakRxeklQR1B2cHplVTR3cTU5T1J3cktjaG9wWCtEWDJ6dHdt?=
 =?utf-8?B?UTNKL2xFVDhEVjIrb1FBRUJkNDQzbXZ2MzJaUGE4VGN2NVFXODdoQklpeG50?=
 =?utf-8?B?NXhBQVVFK3Qxem1zcWt5MEFLTmh6K1RNSDRtZTJwNHQ0b2IxYVFrRllXSVhV?=
 =?utf-8?B?Q2RkZFo4M3dJbDRDaE8wRGFLcGZBcFFHZkw0V1pJQ3B5cXRGckRNWDF6T25E?=
 =?utf-8?B?QWhNbFhZUCtRc3hXT3lTOW5tU0V4N21abUNOVmtiV0h6blhTTWw3SW14SkRz?=
 =?utf-8?B?ZGU1MEtuYkh1Y3J4WC8vTSs0V2dCOFpHa1RkaUNnM1VYZURHbjhVSXpkNmsz?=
 =?utf-8?B?c0g5UDlmUXk1WWUyNmd0TEkreGpxaERpamU2bTZMZXg0QjJpYnJReDNONGx3?=
 =?utf-8?B?OHY5czRYY0FJbFkrSkhRcVQzSVlTQ0tsYi9ZQmhERlNRYko4UUgzdkpvTEhG?=
 =?utf-8?B?VnNJNGlsK2s1Ny9LSXpnQnNjT3FBSEY5UkdlV3ZQOVNQT0owM1UxYzB2RkRy?=
 =?utf-8?B?OGhNbzBCbVBJa1FJQjRmazl6VFdyd3BNdlFESGhRMitieVllamJvK0xDNjBH?=
 =?utf-8?B?cDJkb2xMc1pvOEJQUTRxcHFKMVp1cGJYQ0l6a0QvekZGMU1wRDkrQnE3WUNG?=
 =?utf-8?B?b3dKL0tFNnFvb1NrUWdUZ21idmVycGhIUEZ5bzBRNzU2Vk5PNXIvY1hxTTRW?=
 =?utf-8?B?T20zMHJlUW4rNFNDUnZ0TTdRVkEzYWZrMGREaHhBWXFqS3lHWGFvVTVnYS81?=
 =?utf-8?B?VER1bUlmdWtPQ0U0cmtOcjkydnRxOTQ0WHcwaEVYM3htWGU5VlREWmFmdUJG?=
 =?utf-8?B?QXhjRFprYXZUd2ptK2RIeENuZ1A3K2l0dHJFRC9EbURBK3lPR2JtdllQK1Fp?=
 =?utf-8?B?RUp3SmRrM0ZUVW5XaXFoM1F1aW42eVN0THR2aWFQVHh3NkdYSmhQT0J0Qkxi?=
 =?utf-8?B?dFhFdzl6V3grTHI1NDlrU2UwOW95ZUtaRko0Nmt4VnpXM2J4Q0E1VzRuUW51?=
 =?utf-8?B?UE1Qb2E1RVAzcUhyWEtsWjVXcDdWSkNzY0FOTENaSzZ4cEpEWlFwWWhxVkEx?=
 =?utf-8?B?Z1dXdGpQY2ltRDNGbjdybjFuSWswQzlXeGpBNDc2T2d6T2gyQWFPRXJhZDcy?=
 =?utf-8?B?M0tnTXBwWUFoZmM0ZmFrTzFaVm85bzFhNDVMTS95Njk3N3JNcml1S3JGaFIz?=
 =?utf-8?B?QUJpcjgySkRJZmg1VnBWcG53QVFsUUtaSVNpU2d4T2hGeTZHK09QNHQyUTND?=
 =?utf-8?B?ZzhQWWtEbFpIMzFIU1ZUdmZXZCtUOVMzT3hUUVo1a05sbTVTTU9hY24xUGwv?=
 =?utf-8?B?ZXVDVzJHMnlKYXpvRlNpcE83Y3o1RVpvT3JSMm4wSlNvdXVWc1E4YUVWZ051?=
 =?utf-8?B?V2xFQml2Vnp5aWdQK0Yrekl1V2FwN3c0R0JhaUlSV1kzQjNMRXVFajRPTVlZ?=
 =?utf-8?B?LzlYcG44aHdkSnlTWlRmalBVbzBlTVo2L05pV3hkUVNBQWxGbjg3VTJaWXIz?=
 =?utf-8?B?ZDZsNmJ5alZyM2MwV0g5LzBtaDRGS0VsaklPcUpJb1lYTXVXV0Uzdy8rSWhw?=
 =?utf-8?B?TFQxQmQyTDl4cUVPQmExV0lzeHhuMVhOMTdXbDA2aC9hTU50ZUFsWEhMMFBI?=
 =?utf-8?Q?z0nBdQ+WOAyg+o9k=3D?=
X-Exchange-RoutingPolicyChecked:
	SWyYC4Tt53gZN528UAcEYBK8AHFeYmFGkvKzo/rPEhMtsUvz82yQSqTflp5P0oNfFrbOSIvLejWAidGuHDnqSC2kYV1hWhN3UtHD7nTDY/LUCY4I2I6NR9kHqrLjjPV6jYY1HNCcI33dtGHzhLcVsI7n622nY/xBm83q5PjksVyjD2VHS+IOSNZ3b5Bn2rgtzcQUWBR1gRcvS6QLL2TKCBSCYraHlKW0IgeJYVEhO5wgPMoiRWbz3QyZK5MbEQxyb7FwDsPo+fxj6GiL46MqnCN3KnPqIgKSpmNthDLymKThN68m36Rf3ICrckBIns2fBTUcoor3MFwHv9vWO0xLNg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vPYzPVPIFttvoLXjAwHcDeOslOB7/0F1kPf79zGEe+WvwHpQH//71yZseIgAfrkJGAmMx+PnGqdd1NsZgtpPXtFxlzz/Wtfu7MRVfySaBgzoinVlHFny6o3ddujz6FAn92eIhmaiRYDjwKWDRJ8ogxuCEQ0M3+u77oQVIjndUOA2Qm7LCDGkoi6Ozl7MPK9kmnPibDAbHFPBpgDpOizfDitAyabUa+vJ/bX1rsFHzqwgVcwNGM1SJ86rjeD1U1SKC83Q5ZqKk91MjIDlL8GNJDu+3JmhbdnIHZ9bQyreIfV4zJC5yS80F1T4fnMYeO5oT8OMyUorIxx4eWeZPVkSp7jMBILX/kSWYAM/pIVXBOeR5qz55cmm18dEm9/7KJdeUVNjRfdH4CAuEU+zdYJhSjHkUmM+TykGTiV8nGxBSv1vMMO1X/lngKiWoiSMy+USPs+M6VZQd9lgSA1kt5HeqiAJGu0/QBKViqpN/rug/LA2nSGEj4P7QTh3kAF0ESZEP08w+U+rpuXppH5bNXHqO55rbBkDl4lgRFL0pMz4CNnbynsFUhlN3fliK4Xdg62xVEq55j03tQ5LMlrGnBTI35atRYz8i7j6z9CGismBic4XUFNAwj+IhiqsDTgoIs2/
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 217cdd85-8082-449e-8d19-08deb5be1ef8
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2026 15:48:50.4250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +6brp3ebqIbRBJYoVs5l5qj3yqv56+I6GtqVADSB4ejxrZso8IM5dajKwF0hxn5/b6ZQ5RBhTtCqqp6RUa3xJ692mlRc1YnBI053bs4DKg0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR04MB9030

On 5/19/26 12:13 PM, Filipe Manana wrote:
> On Tue, May 19, 2026 at 10:59 AM Johannes Thumshirn
> <johannes.thumshirn@wdc.com> wrote:
>> Are we considering tracepoints an ABI? I hope not, but if we do patch
>> 2/28 won't work.
> They are not:
>
> https://www.kernel.org/doc/html/v5.17/bpf/bpf_design_QA.html#q-are-tracepoints-part-of-the-stable-abi


I know that, but some subsystems do (I think VFS).

