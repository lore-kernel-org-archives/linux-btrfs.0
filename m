Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693123C76AD;
	Thu, 18 Jun 2026 12:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781787379; cv=fail; b=ejiOVa+oNYIe1/P5WHVIGmbC23VSMfRNUQr31/8MyMoq2weniFJ8a0nTUOAiGynUaXrqgllJH2vWseALbqJB1yjilVY1sQJMHU+Hi2l8/DmElZIFEER13ZsfkVKSYhL5ZwUeZD+HuTWzr7wUrUBeOc8saEfUgW6hJb+DcJaefZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781787379; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZnKaNFm7ydiJ3j8dC3IT9uvPyenXLEDf3nShhfjm6+x5zJTxt8CBZjsR4YYVXrRdyAVTEDf41Y4YPHgPpwGqXDGqT2jU5mVkLHWZ8pZA62BBiSnyD3qDtmeU6nraKHUEE8Hg/bJmZS39Hjfze7noBIpl9ZVuhUwbzgmikZd97B4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=qAquONZS; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=SmWqDCda; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="qAquONZS";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="SmWqDCda"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781787379; x=1813323379;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=qAquONZS6FhkuOkbz+NDMjwP5Y9ulWZcwhflHEQIThxWs+EPU9FE63jr
   13OG+UZkVP1OTMMU7ubF0VQKDcr/k1bXndZL2DkteJ0wgSs1cmKdN3u1T
   tzsxlP8eCLWHyzWvzO3pn2NMJKO8+izTjI6KBflrkmRWxqYP1+Geaf3ET
   aj/6useN+tBN+DdA8RZo9n6ym0w8psQsrDTHwicu8dWmTg0O5BXzxy63a
   3q4JnLfDvCqvH7z6f0iM9WdGn1cxYw+BWNqPB670I0zerXtBhJSLz5NM3
   MmW2tqvJid7KKk/GouClU/F4em1w/kbb2Ps+MH9NYHTIuspzRjtC8Wug1
   A==;
X-CSE-ConnectionGUID: iyqUM4hyQ5SuBN8j/0S60w==
X-CSE-MsgGUID: Ib/BnQMTRaa407+U0BLJGw==
X-IronPort-AV: E=Sophos;i="6.24,211,1774281600"; 
   d="scan'208";a="149406320"
Received: from mail-westcentralusazon11013040.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.40])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Jun 2026 20:56:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tkmMnN59fxUP1bQB1tGZiXunMSJsMT0yS5p4nwiaSUJsvRdJBvYvlnibUEMW/Ha8MuLAQmVf90rgDj9lQpyBa4XKtH3q3KgNQuuw7z0XZa5KbZtbk/BOhGIjtAquYNoGcyYg/bp8350lzegxIYunES8dOsOKLNKWfGLg4O4XhyHB9HrXZF7X1x4pbI/bnjL0aF67v0v3jrbBVDiSLh6+5ykwfTlOmKd/AhcL7Rd+t5Fpa79RemYJEZDTTarENfNTRg1cZIpoP/YsPIMyy/DRE2oHwYRn7MVO6n16NqiNGejsAhYa1yBJukqFLI4/lpyJpuYNX0/mKS3FnH27pK/auQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=fksvtWoo7UqnbhWXrYwFlouyradjr/qq6+xRqhOCOjWmGWf4eNzvScKQ+cic4hatiX4CVO1lt7IZDVQbIAL02Q5ZonahWfTzhr/W9rV05F/lqJ+Mcgp+Qg2JvopJ3yK64Jw9ctYH+/oIhMCbRbXfJ054Qfc3NaEvE99B9EthW3WA8I8rHvJnaZCqEhRsB7cLu19ZLQ/v/i2GPjdsXTdBAZfv9gf9yRJFWXoaTjNh1W9FxJufg1QaBHhCQt2BrwQGM6pywyacGF62ds08awkSfvKYPBO7lIM9aPfmDie3G6a9fEm4S+7+SlEgFC6bGC+fO+9kS4h37Sz83pONe6yQDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=SmWqDCdagTKxYxQhNN1z4PsYOKZfohUnaYoLCkbSN02vX0EW7c97GpobA+UB8lidy/7t/2DxOUDJcFFy6CFwx8oiEECV0d2nvC/hUyfjbMNqoZ/Gj++zsnYS7jDgxwvcBQSd8HazJeeAc3u7dzzc8Cbf0dPVfq3E1hz6luxJCaw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH7PR04MB8683.namprd04.prod.outlook.com (2603:10b6:510:24e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Thu, 18 Jun
 2026 12:56:09 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0139.009; Thu, 18 Jun 2026
 12:56:09 +0000
Message-ID: <29a292eb-12ec-4932-b715-2ed32c85dc98@wdc.com>
Date: Thu, 18 Jun 2026 14:56:04 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] btrfs: deny freezing a device while it is being
 removed
To: Christian Brauner <brauner@kernel.org>, Chris Mason <clm@fb.com>,
 Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>,
 Jan Kara <jack@suse.cz>
Cc: Naohiro Aota <naohiro.aota@wdc.com>, Josef Bacik <josef@toxicpanda.com>,
 linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260616-work-super-freeze_deny_upstream-v2-0-b3567c7f994b@kernel.org>
 <20260616-work-super-freeze_deny_upstream-v2-3-b3567c7f994b@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260616-work-super-freeze_deny_upstream-v2-3-b3567c7f994b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0244.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f5::13) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH7PR04MB8683:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f099f16-aa67-4ea3-2a93-08decd38f7ca
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|10070799003|1800799024|19092799006|56012099006|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	+Z+tx/Ei2Gz1XVEwo4uDmVFTbN8f9lQfnsM9VuwznUGtN3SgeNVYkbCRjyrhc4XRcZ/GKY+eRMLNTWefjUNnthH6Fjm35eLs4bjfcO1CeVN6LSDUyuvIn+HS93piPU+VJJ20I4tr6mBfttGP15OTgbacgZog65F3SFF3JF6FNdseqtYNBY8LpYwH/QRmasAJ9QDWgzSvgXRQFYG8790nRdtqX+2ZZ7Fu6h/3v0tE+LdoNilpJ4YCWx6XK/kx62jAPFtHPa/wq+J92sRu6WP57PQs5DKsHlsIxCYz/Z2yvF1BrMpGutnQwJlmxHcZ0PhfYe3B5QCmUCwmlgq/QeSd4Lj1y/TT1SGDB815x5dTU7F1SYTkXhCFrnF5gynog7OmGbXi8O8+XHTYDiyhsLHDagvyO0VBe1shnvPoYbl5sg8H6cp5MO9aDQUfAvCdQzTTXRMyJszypYkbD3lnO2O4swkR6E2Nj/1O7PqhvFMkNHbnwsStsc8ThmWzq5Gimw6FEfK3cYb/m5kWS8Ff2YJgAppgrHqoInH3nf3Sg+tCVhbt9MetnOSyXPHPfZu4ugdN+6vm6Vke9FEYqfj7zHnBxLh19WcU/RlM8pOeYZUA9IknF0vz9c8IW+sfyAC4Of/6R2BH/XGh56wjcT4JuzBqp3EpZEiHGOzWFfXXsZ4rI6KfDU2XiPlOYQ3cy7ZPR4Wo
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(10070799003)(1800799024)(19092799006)(56012099006)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dTNBdUJvOXR4OWFxVHJpRnJiRVI5ZjdrMmN5Yi96TC9BbkYrZXlZZHhDZmNj?=
 =?utf-8?B?dzVEYVhzS1ladWxDU1pZN3dKbm1WSGFzVDNFZUdodXRtNERQRDZrcVZ0V21G?=
 =?utf-8?B?SE5JVHYrRCtvMnpyeWkrQWMrejYyaTFUcTlhSGVDTzk2Y1kzanh5SGlxSjB2?=
 =?utf-8?B?N2l6cElKM0NRQkZQeEVDT2xIVDFTNHJnQzhNdk1OdmN6QThJcjZXdk5XWEVu?=
 =?utf-8?B?bkwwLzQvZHJ4V1RrczBla3ZUOU1xT2o2YXFLM0ZmMTJKZWpVa1lIdVBzMHBU?=
 =?utf-8?B?bEMzV3BKWFF0QjlrcXk0azA4bVFFR3hUMStrOEZyWnVTcTJKYXZmcnpMcm1i?=
 =?utf-8?B?RWlBU1J4cm94YUY3M3Y2OUNtd0ZvYnBHSGJ5SmhYU3ZieXl6MW9WWnBEc2lM?=
 =?utf-8?B?U3BKNkx1aGFFeEd1c0x1anRva0RuOE9HbXk5dm5yTzJOSW5zWHhCdlZXdXFS?=
 =?utf-8?B?dmxwK0dXdVUxY0xnV1ltbTBIRDhzaW9yZG1jNXFPTnNqUVJob2VNL1FJclNW?=
 =?utf-8?B?Ymg5dUhYZmNVU1JLdm83aXZGVDlJQ2dlSUVQcEdnMm5UVGRPSUx5bmx0emtO?=
 =?utf-8?B?OWFIL2ZXS1RyZFlZYTNiMHhmcUJsQmN5NU9RdmU0NzYyM3N6N1UrKzFCZEdB?=
 =?utf-8?B?V25nSVlPWFBySUdlRSs0ZkR2RWltWFZ4ZTBOd1lrdG5JYWZ4NERRQU16SjQx?=
 =?utf-8?B?bFRsS21IQVNLbkp0UlU3ZFdHRHY5Y1RmR1dReEZNUVpvcFFoZmVRNTlIZXg5?=
 =?utf-8?B?Rk53TXRkM2U5YmdUOXpuQ0RWODdseThGRC93bldkdDE5QWtWZytGT3ZzQUpF?=
 =?utf-8?B?NnhhUXMwU2ZkSnlMN0tiem9aV3U5aVR4aHppZnRiSkRjNWJlNGFhRVdpQmZa?=
 =?utf-8?B?cVBTMWZlK282OGUyV090dFU3TGp2bVRVTkc5dHIrVHVRL01mSHMwQnJla0xn?=
 =?utf-8?B?VG5JQUEwaFdvSFJySzVvOEFFSGVlSWNYMWptM1lMYndGVm84MzNLS3hXRTlC?=
 =?utf-8?B?b0hHNm14QkhDT2grSlpaS3phdVdnSWRIMURYTllGU0trVWtpWTMrbXkrOUJk?=
 =?utf-8?B?MTFMSzg0cDJ3Mk5iVit6U3FjME1yQmJCaW4xNEpzVFkvcnBDek1ZV0lQMFNW?=
 =?utf-8?B?bit6UUhDaWpBNmdVK1BOMFQyNnpBcno5dG0rMkJocEFJOU8yaldxcWRJc2Fo?=
 =?utf-8?B?VTNXeGRhNUtWVTNBL1o4NHpXTzlESVZwbGo1bzRkem8yZnRKY0hLQ0U0bE91?=
 =?utf-8?B?Q2w1RVovcWoveHA5aS95d0pZbG0waktObGY4cHJSUlc2T3V6VnlRMTd4TkFL?=
 =?utf-8?B?T3JITUsyR200SEg1bE84VldQRDdZSHlaYnp0NitzcDVoc0VObnJSZVlCWE1Y?=
 =?utf-8?B?dHpsU05kd1JsRGdYNlRuSFhMZWI2MUdLS1luYzVDQTl5ZG0xOTZacHN0Sysr?=
 =?utf-8?B?VmdGOExPbXFiSmNYTENVZ2hXZzlSVXQ0WGJuMmdmSElMeWFjT0JqRko4aCtH?=
 =?utf-8?B?RkppWEIvQVFKNHVacUlaTnVxbndhdWZrcUJScXN1UHd1R25MTVp1WnI0dVIz?=
 =?utf-8?B?VHZKL3doRlUvMDB6TkJJdytqL2lhbGJ6aHhwbFY2NjZrZE9OeHBXclcyQ3Vr?=
 =?utf-8?B?SVJrSmkza01oV3lJVW1CZlo1WW9JQU56RmYxSklUdW1WMm1WNFRqeWZlNU4r?=
 =?utf-8?B?eXFDYzB5S0EwS2ZxdC9YMHpvYkRBeDJCNmg4ck40dDBUZ2k3bnl6Ukt3VWMz?=
 =?utf-8?B?VkU2dW1KaUJCc1ZuUXltYlBVZ05UTnpQVStTOXYwNFFiOTN5d2h1dnFvSWZm?=
 =?utf-8?B?N3JrS3dZUURwbElpWnBOSkFjenNRTm9kQkVqeUR4NVlpRFFyaHRrYmhGT1NZ?=
 =?utf-8?B?Zmxvb0pOcTh4dUlxZWU3cVBuNTlTcTJvdmcvN3JrVXJhWjU1ZjYzdGVIWmpO?=
 =?utf-8?B?aFh2WW9RSlVVdnlNNUtEYU41M0s0Y0NMdDFOT01Ma0xaK21xVEV3UGoySXM1?=
 =?utf-8?B?QUs4SGloRUpnYU1XQVZwaWhlWEhSTng2c2lrSUgzU0EwWlNKQ3gvMGJDRnRo?=
 =?utf-8?B?LzZ1OU1FZlRyNnVTb3JGVVk3d21SbnVydlFld1lOYnRtcktUcUxIS3h5am9o?=
 =?utf-8?B?WVFGd1E0T1NnLzQrR0JFbWVMMHBnZ1JIUnEwZHRwWTRoTkFKbnlNUHJKcGZ5?=
 =?utf-8?B?ZlR5MTB2SzVLbHo0SWJGZlozNkhOeUVITSs2N2RkWjBVREdIYjJXYWRTb2Jm?=
 =?utf-8?B?TGNSakJCSXNJeUE1bTd3ZzhveGVwNzB0VzlHLzFNOXlRVDBEeTR4WTdnb2lq?=
 =?utf-8?B?OW82THFCY2IwNHRoUGRlZHd5SnI3M3puMlhtY3RYVUVIZjI1Uml1OFplQWJT?=
 =?utf-8?Q?CS4zmlWgjwklX7VOaZm318n6kCay52Bk3U0cdHhf0dS3W?=
X-MS-Exchange-AntiSpam-MessageData-1: I7hwnXU3zcT3wA==
X-Exchange-RoutingPolicyChecked:
	P6Zk/9BJ7hU37kMbWNw2GJup0vpUB5zF912Xh46frsqyQNZpS/pGFpuEgx/lbnPt8XPKz02yAPUS24+5kdCxtZnak2cTAXOubenyR/ugy67v3ndgHWJ75b9mnm4Z8oImi1F+laKFGRHuAAYEjqMViuZvZUl5I0Rz0Y9JAtmQtE+0/3P9x3GMzX7Rap7rpUSCEYpfkRHL1sNYveNt2FmqmgqClBIwjuj1PD99jnPtwNe6lfcb8iZTdjcmtxclClnJlNVCkmFyUbL5ONkP1phXIhznSnQ5cmd0uAxkb+4k6WlMzCy3zxcwcwlCzDB27FbD9jcHh7SHjXV5XkoyFK0ChA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SjIHKYFosHXrxwaTlY7ItNgF0Xg66xaqqNL5FjOEdIIzE1k4mC48Z+GDy6ffTRpOupfGCbCdwXfvA4BGiE0oHLoseFiCV3o93xQ7gTIIvQdwA0aD/gXq9Qu/4TYT2Og60z1bAZgTDtszEkI8vW5W7E7EqSXtPJ7ccvwWCMOJjpH4qrw8ea8KTrRD7jZpM3AxzI652rpDQuUWt8jd/IeU1twHHZvGvRfSKc93wG59S0Fttg3vTNju11YeMd5KC7JPrycPz36/VmhfozpWHouEg5XGpqffgSLKB5IBdc0yFyBDmE8H/S7BDDHXOQEGwq2MnM79M2gwF+lzzAew//5Jei7Lx5QCC/5i8pfAcPXW1kvq/iwTxed5hUJ6N5zTaitpvDoKxO60fagNSd6kKke6Cpe6voYW1QziA0eEZtqJ9+9bueBxdiqnomwNJ94vW1iwzAMHpn7ljim1IWVcZRkTixI6ttKTgLC417DBt7WY1a2g5LyQKJNh6ZCF2CG+fH/KmrA4HdQuq3BvTCyAvvrAtrVoB46+R7zDUHOriB1hYyKoaJYEK59eQvOncYnoao1Fs9KalSn1iPHhbR+TQqGxxSkWe+M/7UrtDNeE7wcgPXW2pciPoh2PTtvBJpstA+Uy
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f099f16-aa67-4ea3-2a93-08decd38f7ca
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2026 12:56:09.3059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8I/4mMvJPtTIKf9QeYakzmsywcpKEKJVr67JtgIQlfvWRPeEP0bdjKFTxUqX4YKxAUI96P2nX+v1yqoSV9jy2tsrsi28dfUXMwSaQ3EkVzw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8683

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

