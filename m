Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AED33F5BF3;
	Thu, 18 Jun 2026 12:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781786863; cv=fail; b=qDIO5XPhwIkJcpG4qylEzGHShYFrAighQpFRGesQlAMJjdq/qpys8BoG2b4aV6AYoR87+mDUVYyMhhw5jm4qC9BNJz8XXH0xBPXqqtXeigyNC0HI6Ga3hPH2ttpWXkt0dX+DuvcW0Do3ZgJuCGHq6p187dZCkPcZc1oZE4qd0ic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781786863; c=relaxed/simple;
	bh=uPnPSBeHPQ2OlGYMnlc8/srUIGCZfnDvtSR2n57yAOQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ARK7Eq2ChJO/G5TEacIX/6Wei8Ebt22/XVnNKIi5Qq9hT3Lomaj0V5lL9QYwIxtxd6UujvzjoL6jktgAEREbnAROOp9OdGsgAYJuBhMX2br12EPx8N1/jXfP4jGUsdvuiPyPcQah3xKGdWcBVgKbCioyQQ8OY/S7EDludQYWnTc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Mu/VfmiU; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=oa67HIrg; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Mu/VfmiU";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="oa67HIrg"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781786862; x=1813322862;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uPnPSBeHPQ2OlGYMnlc8/srUIGCZfnDvtSR2n57yAOQ=;
  b=Mu/VfmiUorZAzbR3sC2qRL7xrbzJ5nN6mDnOrI8v7AaVVXrCVtZcwAKS
   Ou2qf7ZEvB2jO+9Ugup3rKio2Ea2bU273HO445Pg7H2YWFJH6zDOL/SUL
   iGJRVlrVfxN52OGAWULHbGO/nLGfRBB0JokmFn5Ldq60UkUveJQeAO4GO
   7RkVRyD7HW5q2GtIzXfAc0sLlCWEffxGooJOT3lHBzcQRwe6ENnu/jzAN
   +eI0ETk04Sp3jxle287c5lLXyokUfaSX7dr0nrWxcWfPDLqdG2FePQadr
   J0y18uCfBkxKghyeY+lmbLwZdjPlwLYIMp9TPAqQg6VbULTtFgeQxYxbw
   g==;
X-CSE-ConnectionGUID: ir5voEZFSiS2V2mj+49TUA==
X-CSE-MsgGUID: 2/DJnHBUT/iGB5josSW6Ww==
X-IronPort-AV: E=Sophos;i="6.24,211,1774281600"; 
   d="scan'208";a="149061151"
Received: from mail-southcentralusazon11013015.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.15])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Jun 2026 20:47:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nZ5vIYrZXmcIo+hwgnHDNYG5qS6bPkdPW3/YEXbKeTocoAQAdCOQNqIQ1bP2auXya9/3EuX3QRyGxRglYK//shVZL0mS2wYyC2vRyIx+n+WR3bOYpfYNihJoQwVuK9K9mj9bA1z+0R2VaErJwuM10anHYW6ftAMr0cKJHDkOI6a5TqWVQLujXw4ShCxCsZrrMdqdau5q9EIOGRJ//wfM8DURejD+YrsLm/KU14o7/rLDztJEVnsDt+xiPSdMPR3vmIDsO/zJcTU9JfaydDUIiNQ3mkwA4qTVhtpXS62vvHWAUKB8oAuNft2CBUKzMnE6SCQcVqin2LuucQsXStMwGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uPnPSBeHPQ2OlGYMnlc8/srUIGCZfnDvtSR2n57yAOQ=;
 b=bQd/bFGMDWmtEeYELTuuaor7eLp4Cq5Jm4r0hVvHjl9QhkQn+n6uAuqd4CRi7Me1b3PNzGsq6QGLLiTtOcTP5PLtL95pvdnHdII8YySVWxCFMFUwLGsyMNJfCn/LZ8ncg5tgc8qGt6Wf8fojMT+bG85BavJ194veVyaruNoZGUtGftsFz5AVQSs3m/+KyDJle8R1dGVWTvpVb92Vqo6WwjBOPRdkaMOTbFsgMIgQc+NENQ3gShU6gxzDfMdvjke60JKzCTHTyG0/1QlnNP5QOB8L+hT8DCcibKP7rQyD2yHk4EadE7m0ZigUWDrfvP6aT+SKmeBTikTsUJqSrDqNBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uPnPSBeHPQ2OlGYMnlc8/srUIGCZfnDvtSR2n57yAOQ=;
 b=oa67HIrgEmzddmO+bAgPC0gIOuiDgu0UH6AGi2fEp6U39160mlYLVF/x/QpQQ8jHWO9D1v7CiyNMhx+aCqXoUfZ+q81IORB7mFyaatzqgE2uy25jQqvqbAMNvyeo/jag9SLfB0hNXDGJEseh01UB3Wj8oxdO9qOcTek4OmnC63g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DSVPR04MB993598.namprd04.prod.outlook.com (2603:10b6:8:422::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.13; Thu, 18 Jun
 2026 12:47:34 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0139.009; Thu, 18 Jun 2026
 12:47:34 +0000
Message-ID: <50b8951f-2d1f-4c24-9fa8-3fb2b479cd40@wdc.com>
Date: Thu, 18 Jun 2026 14:47:29 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] block: allow making a block device unfreezable
To: Christian Brauner <brauner@kernel.org>, Chris Mason <clm@fb.com>,
 Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>,
 Jan Kara <jack@suse.cz>
Cc: Naohiro Aota <naohiro.aota@wdc.com>, Josef Bacik <josef@toxicpanda.com>,
 linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260616-work-super-freeze_deny_upstream-v2-0-b3567c7f994b@kernel.org>
 <20260616-work-super-freeze_deny_upstream-v2-1-b3567c7f994b@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260616-work-super-freeze_deny_upstream-v2-1-b3567c7f994b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0197.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e5::7) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DSVPR04MB993598:EE_
X-MS-Office365-Filtering-Correlation-Id: 65f92f6e-9873-4aed-f786-08decd37c4d0
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|10070799003|23010399003|376014|1800799024|19092799006|22082099003|18002099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	trY61sNkTxXWogn/VUnh+/4jbview1cjtQgbBAAwSaDvdMeFTcTQL7HtSQOAic1iAObjHAsy7Ra/uuB2jIESool8aFyLFKeGIWbu0WFwwTcp/L8aj8WqdIfHoMUF1wpOmBRiNLTIpf4FbgEkm4cCeG1Ry6/UdUA7AHl4egDFYcyEqqP5Rt59D/0GjUzsqlxE3GIyDyaXo60xGE9U+4Lk5RFNUlNDq6tlSe3UkrajrZyxmtUfcf8rTcvXzwp3RAehLJjTMqS0aOyeGreQQrFEHHTeLztpLo3mBqMuxsUEIIq7rEXY6daGNaSXnus3FwnrNMCYrfOJ3R+aUaIwWTLvyhwlf+kYWcByrDc9hWf41y1pFAwIUb7zu9LMRY/msM3Ikg6oIRiW0E2ff0S7IgKbJl0ixL6pvKAicwZ/lFmt3WMbRuu4VhdxYO5nLpJA3VvB4FEnVLiouhddxxWXGOgu6/OTtmmD9fyciw4fI2M5KUYdumYgGTVBjvktA52mpK1LZoOI1jCvFV7+lpx9KXRWQ8XKL1DvrFIVd6YEVPXhBHrgrhiFioxJ0g+iYylGxhaJc5/N4st3HOXvewUGl10xzBheeWhQMQWsBhFscVyAZnjPZk4aBU4uFiXBYUnsx7iPGINzYBFySsUKYBOkQ7OaryhCaWzsNtt3daRaBOtXTj4s+Aut+kl9s4qURgfK7Jmr
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(23010399003)(376014)(1800799024)(19092799006)(22082099003)(18002099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eXUrSnM3YWJZZlNWK285Q01URDVGUFlMYmNIRkVrZUdtVk0rWVBUdGZKV3hY?=
 =?utf-8?B?a2VaNHdQSG9yQlQrd1YwNElxaEltbmIrZnpJK1BKR2JaZlJxOFRrNlYrK2ZS?=
 =?utf-8?B?SEtOMVlxOG5JUUtrd1BsR0p6b1hSU0x4a1QvSW0zajJJZXhGblJwcVRQOWMy?=
 =?utf-8?B?WGphV3dGNDJEL2lTWHlGZ2pIU0dqMGtmSHR5RUNGWDZJaDJMYlVkR2JHa3l3?=
 =?utf-8?B?RGY1d05RRlQ1NCtWQmVjclhpM2ZvcExkdks2NXpUdVFlMFR0RnpaUVA2T3Bi?=
 =?utf-8?B?TU9VbWQ5RjJRREdPS2xSYitpL3BwSDE2dU9RUE1ObDBhcGhEVzNyWWpmN0R5?=
 =?utf-8?B?aElQaFI4Z1c0Ti9YWTJnamtNb2hCTXFnbVVmWGc5SDBWRURmdlF3U0RoVXRz?=
 =?utf-8?B?MW5tMTl4WmZYK0N6Z0lnZmlTQWNiYTRaK1FhZy9ZNGYwTVV2aFVkakl0Z3Yy?=
 =?utf-8?B?OWVIaEJoelhJUFBlQUhBUm1pWjlXOFdkZThMVkQ2VDNLbjVWSzNjTXlZZ1Rj?=
 =?utf-8?B?VWtTMmdJbE05SmxHR0V2L21YVU03bTdsVDBvbk9PVGZ0WFdQeVdUeHhFOVNj?=
 =?utf-8?B?RHByZktVL2FwYTNQY2p6ZXZSQVg4ZjdRQmpXMkJMYmFXME4xT0h2Mm53NHJD?=
 =?utf-8?B?UkhibVQ5YUlWU25uMVRvYUJJbEFxRFJmYmc1TVc1OHMzb3FVOXZXUXQzdHVN?=
 =?utf-8?B?cVNLdHpISFM3K1Z0WUVibGpYTEhJY01SY0lBUTdBVkpPb1haazBqeE1NK29Q?=
 =?utf-8?B?OE93dmpocGJjUjNYSkx5elJkTW1kc1E2bWxKZ3VDVkowTWx1SnVZT3VWZDhq?=
 =?utf-8?B?Z2FZYnR6NW9Sa2VTR0NOcFpsdzF3U3pmcXVNVTd5Und4eEhBa1AxNTQ4RFd3?=
 =?utf-8?B?YU9BMHJvSXQ0ZFZsUFExK1VDME9weHU1RUFIRlYrTFl5aXp6YUNiTW5pVTNl?=
 =?utf-8?B?NUkwYnVoR3JOWEZKRFZnNzFqcWlRRStxVm1FaFFqa1NRTWNnaGRmZlVJbWFK?=
 =?utf-8?B?c3Q1YWJxN1JKOUI4Ukd5SkVFUFZPbGZDRVFWZnc2TGo0T1dteWQvM2NJLzVR?=
 =?utf-8?B?bEJuSDhrQStiTkZlOG5FVmNkMVIxZ0VLSHcrVE5uQTJnckNGVWpkaUJkNmw5?=
 =?utf-8?B?UERTbTNOb3lEd1gydGg4VFcvNTVBMjBNbGhlSkk4ZVl5NitVQ0JGbEN3d1E5?=
 =?utf-8?B?Y3B3MWdlNVNBbnVObjY5aXgxMml3M2xLZHUxYy8vWW1yQ0l2Y05ObmtFMUdm?=
 =?utf-8?B?Q00wdWozR1ZFbE1vWHFDcW5pVldYSzNGaDhlU2FodUJQU3BMUTRvZ1RFRXVT?=
 =?utf-8?B?NXNyY3p5QXd5Y21ja2dXUDU2NmVCcXN5NG9vcFJQRHhrSitRM2pMSjcwSnh2?=
 =?utf-8?B?aVQ1eGVEQWhJN01odTZWNCs4b0l3QXphOG8yOVorZ1lyMzZhZE1vYzF0UGRU?=
 =?utf-8?B?a0xoMk9TcENxWnlCQk9QVi9qUld4azdOcXBrZitHQ1hid2x2NGxNT0J3UENu?=
 =?utf-8?B?UEEwZFRTdThBMmZVcWY5MjNVTWFDL3lzT1pxcDEvOE1NZjF3bk1xbjlRRVc5?=
 =?utf-8?B?SFl2WTlha2VBaWg4ZnZyN05BUlZDMkdsQXMzejU3ZlpxWFhXK05WNm5vNDhw?=
 =?utf-8?B?Tktyeit4cFZjc2s4ZTBVaWF4UVhYK21ZU0daOEEyZG1rczcvY0RTbDNVS2hB?=
 =?utf-8?B?UkZqR2owWENMN1d4SmlpdnNsNTZXWHdwVmFuY0prOXFQRTdqNXUySStMdnBD?=
 =?utf-8?B?cWxwZHVaN1lKNkFybk1Jd21xNjJ3SlVoRkhIZTZaYm9NRlQ2bk01Uis0RU5V?=
 =?utf-8?B?RUJxeU1zNE5BTDZTS0NFUGNBbzVSQVN5R0N4TEJOUlViL21FdUJNSG1QVjJY?=
 =?utf-8?B?cXFjREdJT0lnUEpOYTlUeWFpYWNZbXJVWVRlSFBkVEIwTnE0emdESHN2anh6?=
 =?utf-8?B?MS93NXFUbHpMcGV4Znh3eTZweEZWVFlYd0RDK1dUeTVsaGZZd29RM2JUM3Ex?=
 =?utf-8?B?NC9QSFl0S2NBN3l6WXR3UU9VdytGRWJ3QXNHRXhHakowMW9XNGJDTHdkSVNi?=
 =?utf-8?B?ZDNsTlNaVzF2MjBERVltZEdGZ2M3VWdROHVVdHNQSVVvSmFEMmtleEhqS3Vk?=
 =?utf-8?B?bXM1OXFqZlFsdUpCeVM3R3JEb1hDLzU1TVZBYUZoU3BqTUdmYmJacW1BVUor?=
 =?utf-8?B?YmpoWVp2K1k2QTlEeFEyTGpmRWNMMjdDbHhtWkM4eWZxSmF4c3JlTzRzS0hl?=
 =?utf-8?B?QVl3Q1JjVVRGQTV0YkwrS241dkQ2cUdHNUxjcVVGM0xENDBON0Yrb01tQ1I4?=
 =?utf-8?B?eFhJZnRsQ0I1NUtzUEorRnRGemV2bGdmaXhLU1JLb3g5NVFPM1pNMHgydEZs?=
 =?utf-8?Q?+0oVFX8i8yR9WjNNgarIns2E2UM6ggqu90PVex5RNPi+W?=
X-MS-Exchange-AntiSpam-MessageData-1: /gE+NRGfEP3tEw==
X-Exchange-RoutingPolicyChecked:
	W1cWaTTBYLqPSOO8XwHcP0oQ0kO/3dzk1wGSrf441qi4woTV44CS8tiq6kpGjs5ipHflTtLsD6pbsxC64RpYWomUpTGvKWNWMqm6rI9cshaaSaAjaSotdgAYnbV1H7EmR9DdEmeCGDHnSiG/WMcAFsVteXWjuDOG1/U5GVnctUiKy+Q2pozP9ExkAVgkQYipVZVOij0bCiLIiZM5OnM0Z05vAxuBjGZKVVzBOX/rCacC3ZKHCl/BKosdQt2PpjNZXa7aAmMAiTXKEHIOTILkRuL6kJBdypi7Qz7mlUJKYp+zszYPB2tZcjoiIJzJxJL+MIV4pnmULQWRu2O2BDVHbg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ay/n6Y6zTVmeuK9d8em1mKwXqvWSoEWJooM0vkEd3w0sk5AJgBj/sQ50SxjuLHrUTYyumRvNbKkp0X0M221PoStPsE67iWleOreVrUfmNo9ECUqr5yp1JCXCR48AfCdqzfSxWopDDvFkLVkoxSDmsgsrlADoTzonV9ZmpyuVbuWqZbLVcHnXL1BcSvSP2EsEDlrpkZB/D8EEi3b64zrw2hMjE4I170ZcCvmii6wGTYhF66Br2YFJRxz1uK7gVLn4Q61116uDx943Z4ZeX4TVAw/Z7CS8yKUthXfQJ7qKtL+Ar96k9d4pASlhZ46TZ33pJ1Xjs6DkkLKTku1F8NQp13dAgH5VMSa37bn1w/Labq5x0kWTjPBBAGAAwBp6W+kfNbQDHuWSGSmhKMC+YCIl1ehkYv4TXsh2vb+NxtcsXRcB/z7AdAIFhO2Vo5yrIvj/ayxoqIqCe8enu/6rnZs4Z/XT4upMK00tT7yybgN1yWWjwo8xIXibBq4Dshy0CPcycMCagDtsKDfOCcscqIUTcVd6H2fOM6oXKiEVXKad3xS5Wkj9rfgx/jLc0PFnNp4i7vLfK471ZBUUX4DEzjAn2jPOKfGnFKVTNP3W344xuu88b1di5NQAXft3T0zrOpqx
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65f92f6e-9873-4aed-f786-08decd37c4d0
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2026 12:47:34.4630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MYZiHKyAMB82mxRDIORBHxBQ7fM9aA9mDEzfJJP0nDlySmfNbngbHdzAKmoG3uCnIzMVJFZNQaTRFqgX5g9FjgogpKsqSOcTZbM4/lZJ658=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR04MB993598

Looks good to me,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>



