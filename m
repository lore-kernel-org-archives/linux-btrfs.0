Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121491429D
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 03:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779681445; cv=fail; b=nTtE/mlsfmWjJBMpDDvrVyEGfPgTnf1O9A4q1SzE23oudpeBhxmdnd2iP6PCajVgKTeqCM6ieWRqjJPzDg1G/H277866GhwDj0YSmr4HutZJvdV63NLZVGdTFwwFc5GO97gF+dO/MIwSXkUTgQtomZSGLnQvUYeAAPqTnjMrINU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779681445; c=relaxed/simple;
	bh=/PqoK8YU91RdVeyqHdU6cWsC+0LQPInvG9yddYG3a6g=;
	h=Content-Type:Date:Message-Id:Subject:Cc:From:To:References:
	 In-Reply-To:MIME-Version; b=JA/4PojVpyPnG4F+aXuMtyjoxFRuf4Q8KZhm+nXZcL2uE2qJCGCuWTNEcVeVtNen2mI1ZiTzVvFPlt/IrgpcAEQKiO/6nUAaeOqvY5VEYXQZEzX69DY85O3LtzHtVd96dZxtyfz/qxvQnD6ayf12x6RQiYJMiha4afMrbIj28rY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=evTACMHJ; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ybIrwFIX; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="evTACMHJ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ybIrwFIX"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779681444; x=1811217444;
  h=content-transfer-encoding:date:message-id:subject:cc:
   from:to:references:in-reply-to:mime-version;
  bh=/PqoK8YU91RdVeyqHdU6cWsC+0LQPInvG9yddYG3a6g=;
  b=evTACMHJ/MdLS2fwCSbGbocOD4UF2KMLluoCnyqf2h1kz8BzfeyDiA+3
   LnlDW3YdZIGTFhkgb0z7wOFGOanb7K2F2pVJ/6GXcAZ+sgP5BBpUuMX8/
   bG6YPdDWiprUqfSMSwbV0mG93pK9AFajc/gwLPVoxjChp2bjn1Qkpgspa
   KNcnZ3+WwYEXnsoPaHAjZD1P8zycSxM6GyiCnyABx3iWSf0WOaGfFzrbq
   e0PbK0rxlqnQkJUApMikJ4s5pLZNV87bM1x+elax/mXArN71qeLaPjmBU
   ATaTFkj45ieYmAU10p1vosspp+t3ejxQCz19QcMuZrPbXvwQ45ut7/sYl
   g==;
X-CSE-ConnectionGUID: OdEqKoogQSqQkA0rMp+Qew==
X-CSE-MsgGUID: 5LC8EuW2R2yLgQwTfybtkg==
X-IronPort-AV: E=Sophos;i="6.24,167,1774281600"; 
   d="scan'208";a="146721805"
Received: from mail-northcentralusazon11013008.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.8])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 May 2026 11:57:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FRtWzW1EtVhipE0O0HWWRMmVYVgtGxERmb37h5GosObeR11OhJPevQhtQgY+AEdo86+nEFtK7JDZe2BEkI++GkFvUuf76jho6Z3pK2FQ8Zwp/1/xE1YqRzJ174s+RNGeSrpOwzsYPEIyWbiVy6lOMxtjtRBAsMucmUS0DciDIYSdJjjepUmOd38bK0FQcX9RhnjGNTGmg7o3UVL+P/sxQ+oGAalUN7gNORoU8bP5Rsvr+mk7Whpg4Jrh+txRpxbh40flDCAuCL6NueUEtia8/dqqKP887FHBqKGuLYRDc/T3ZA0aUKiGgSw7tia8eRfDkZ+ovmQacGxOp2bJ69fwCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/PqoK8YU91RdVeyqHdU6cWsC+0LQPInvG9yddYG3a6g=;
 b=AXGfgQKvzpr43mmJpddQsdOLvYLJNfdsSq8vw7LZ9CC1EizFl5EXI0aWqm89TUulkqJKSaW0vHaj3Can6arV2cj7SWnLOsuEuDzV6tNsXqxmKxTQfU0fvYbuGV7lpwZhvcM1qRcM184KPyzbVfkqgM6GXh732T2XO3iP3XY01mNUoKYVQuz9ScVOA/PL3r72W/TyXyvEGmwcCIj9ft+/CgtTR0ECTo7KlP05E1Kc6D67IZ+QyduGxA9Ivf7vsIGbxs8B5baiAyluiUFFHw2qqp6R9aFTIQx+Eovdzri5EBTjX+Qjx44DygB9FZMKHEggyOLkRLXyVpcM+JWmqjgbgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/PqoK8YU91RdVeyqHdU6cWsC+0LQPInvG9yddYG3a6g=;
 b=ybIrwFIXH1kG0SW4RAmorfdzaOb7+7z/9SOgc1AiINElYNdIFe6jxOAC/mzyUsqWf8F3TUtQnXcZuE2R5xwdQI4FGk7t8SroJ6JzZ1kkR1yw7dxKq9kTBKHQrvECVUynrBMgBRaY7yKWuKc6V4SKhGB0/4ejYTB9nNa4LSyr8Xg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV3PR04MB9258.namprd04.prod.outlook.com (2603:10b6:408:26a::17)
 by BN0PR04MB8111.namprd04.prod.outlook.com (2603:10b6:408:15f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.20; Mon, 25 May
 2026 03:57:14 +0000
Received: from LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2]) by LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2%4]) with mapi id 15.21.0048.016; Mon, 25 May 2026
 03:57:13 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 25 May 2026 12:57:08 +0900
Message-Id: <DIRGEXOBEKU2.1UQWM8OTRGNQW@wdc.com>
Subject: Re: [PATCH v3 0/5] btrfs: zoned: fix deadlock and space reporting
 issues for zoned filesystems
Cc: "Filipe Manana" <fdmanana@suse.com>, "David Sterba" <dsterba@suse.com>,
 "Hans Holmberg" <Hans.Holmberg@wdc.com>, "Boris Burkov" <boris@bur.io>,
 "Damien Le Moal" <dlemoal@kernel.org>, "Naohiro Aota"
 <naohiro.aota@wdc.com>, "Christoph Hellwig" <hch@lst.de>
From: "Naohiro Aota" <Naohiro.Aota@wdc.com>
To: "Johannes Thumshirn" <johannes.thumshirn@wdc.com>,
 <linux-btrfs@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20260522090247.27445-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20260522090247.27445-1-johannes.thumshirn@wdc.com>
X-ClientProxiedBy: TYCP286CA0303.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:38b::11) To LV3PR04MB9258.namprd04.prod.outlook.com
 (2603:10b6:408:26a::17)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR04MB9258:EE_|BN0PR04MB8111:EE_
X-MS-Office365-Filtering-Correlation-Id: 5851d0e2-882e-44ca-6832-08deba11b45f
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|19092799006|10070799003|376014|18002099003|22082099003|56012099003|6133799003|11063799006|3023799007;
X-Microsoft-Antispam-Message-Info:
	DUR2CtAeAxlhIjifGXFkvq8foCWcu3Jyq5oTNss5qyE8ZYPfEVlaNbkerFsa3VWHCg/UHiWrEMhktkmaHXBQWl4yN8HrX89ozoDocy5YWLAjnc5blcX+OrE/SBEBY7B0DjRrIT/vWaoRlmsvsKAQG/Z3u6plkIBSgF4Y3D0KqXKeE7FwATxiVv8PuY0tfEX4qICEcL3LAU02YR6EXsjXyORqowKpe+xTZgLKtrybav2UlItF3S0k57i10HwxIWwvxuKRcICqf7f5gWsgdBwKFI+onHZcxpvnyg4dHp5mKCSDK1ECRADXSmLd1ayyx9tqHEYLprTqmFP6Y8yYDKmMkS0HXciLZjrx0guRbwvGBBjuGBWZnHuH5HSM8M3okwbp3D7nInZStOHICDTW3XX0yGgAedbQlZTXVSPuWL/CoScUUi59aI3JuHOCHCc0zYTAb2YqWDWtJUVxxMLMT7VrcHuZw3/NzG0Zhqrr7CAf85svOY+bJ7GLePvZZU3dj7vTikf7VM3nel8HtYJ9A+ihYxHd/uUS9lLr5RljdrRKIY9co4Oq85sgqjZnAF0g3OTdqufXq1yxL7sK6cOdW13awvyjjhPByuYQ7RqiyjkIRuebrVUALKdrOM8IW6Zzu93KSpbg5/lFYhvU1Xfm3kzxedY3SiC2IHz/R7Aqa6qj/FKdChW1gYIaoh0LKVYtCyaZ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR04MB9258.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(10070799003)(376014)(18002099003)(22082099003)(56012099003)(6133799003)(11063799006)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wnl0QkpFR0krSEJ5TzZrR0xZdklGRXU5QWVBVGlTL1ptUjVqRnRmT1ZuRXZU?=
 =?utf-8?B?M2JrWHRaUElHcHNxWlBUNUhOT2ZXckF0MzRzVGhNV2xjTEY3VEtaREVHU0lW?=
 =?utf-8?B?ZS9WeWRYalR4UzF2d1NFN3BrYzRxNzlNSFUwNkpWb0RkS1h6L0JranV1OHVQ?=
 =?utf-8?B?eGdvZ1ZwdkZrQzhBWFB4K3ljMVllMERGRE8xTnU3NmxGOUsxREV3MnpadTNo?=
 =?utf-8?B?Q2tRbS9FMU94RUl6aEdvMzVPMmZ6L3JreDhRUWh5U3ByZGtBVXF3SkE0dTFU?=
 =?utf-8?B?ZmJ0eS9RWTFtZ1MvcWpWWU1UbExWc2lMVEEwTC94dnYyNXZ3aEZXTTM3VVVJ?=
 =?utf-8?B?NnF2UE1vQXNmUTFqSTQrQ2I4cWFsaFg1US9YbTNmTE84QVZadWlZSWRIT014?=
 =?utf-8?B?Y2FWK1Z6aytxL2RUR0JTTW1XNUdialBxNTFka3AwUzkzbWZ3aE03L3JGanA3?=
 =?utf-8?B?ZmYzSUJ5MVlnOW1FZ1hsa3hNYTFUY2VpU2FONEtGWjB5d2dKV3BlbUtORXBX?=
 =?utf-8?B?ZlMwcnQ1OWJCcm1YYzJhaXpJMFVZVWVRZFNsNWJPcy9YcFZvQTJXQ1huaTU4?=
 =?utf-8?B?dU1yUnJGamxIdU4rWWFhcURHN3Nid1BFSWNucDBlMkhFR09pNXRqbWNyZitr?=
 =?utf-8?B?elk0WFIvYzZCNXd4KzZGd3RaeUQ4Y3FLaEdXRDErdUMreUYwajVENGY0d1pI?=
 =?utf-8?B?LzlodFNSOVk2eUhRU25OQ0hHTUVWeW5kOERGS05SRnJaVk5reHN2L2s1QWNH?=
 =?utf-8?B?R25oSkplSTJ2KzBpcGh3NTk2ZDBCNVR3Q095QUtBN2t1enVjdHZCZG8yc2ZB?=
 =?utf-8?B?OWx3cndwbEVOaEFLYWx0dGV2aW8vVFFoaDk4dGlBUG5TeHBxa2YycXI3OEta?=
 =?utf-8?B?UXNFbUxMMXlxdWtnUGZTa1ErR3ZyeDFjamp3VDlTeXdYM2pWczR2NUxXTnNT?=
 =?utf-8?B?T2QreXpkV1RRYXM0SEtQcjNGbnJtRFpLSHl3Z05iL2VrMVY3Vm1jTGh0OE1V?=
 =?utf-8?B?bG1iQU05TlpqdW1PdUlua2cvSFVBTzg4TTlNNEtMYm1xNVlERUEyWXBKVW9G?=
 =?utf-8?B?NVNqRHFLWHlWRnBtM2QxRmh6MkE0bW9nTXBvaXZxbDZMSlZ5UDN2Qm1MVHBW?=
 =?utf-8?B?YVFNd1FKdEgxREpUTlpYMEhxdjRDVXV6NWxxKzhWYXNsL0Z2bHgrMmNLbzhJ?=
 =?utf-8?B?RDdjeEwxKzNwQnZWOEhEQXFrWDR1SFdGK0JCdElzSG9yNk1qb08xQm01QnJi?=
 =?utf-8?B?RGhjQXdlSldDLzhza29CTTVuSHAxOG1WaHcrQXd2WW1JNW5EWmhGZVZLcVFh?=
 =?utf-8?B?eFVRQ3N2K0xoVkF1SlRUd3RsUmszRkVDQVRJYU9CMHNDTVZVdk50WmVKQ2dq?=
 =?utf-8?B?ZFZISWR4OWdUQi9UL1NNUlA3ZEtnZ2krclgwOHVFY1BlWTVEUWFUZ2lmVlRZ?=
 =?utf-8?B?czcxd2dEMUZla1FnL05oTjFnNWZkTm5WOCtFU2N6TWM5Y0V6M01TZ09uL3dK?=
 =?utf-8?B?SEp5eXppc2Z2SndFSWVQSnpFOGxYT3cxY1JQLzlaN2xwWjJBQUY2N3Vtd1pC?=
 =?utf-8?B?Qjl5SG9neFFYKzlPS1RVb3Jha0x5WGUxejA3d0s2dFI3RjgwcWl3RmYza3BI?=
 =?utf-8?B?alNoYUsyQW1UNkkxc3hxTzg4YnVDTjUwVTQ4c1h0RFBKOXlWdVppUS9VT0NG?=
 =?utf-8?B?L1JabjhkcStjd1Jodi9GaHR5S0JtNnlOMXM4WHdoRElmNExPRVVDVVJiUkZp?=
 =?utf-8?B?NXBjRmVnbjVHT1pkUU9rTnBZQ0o2ZW9jaGJwUm52Qyt1aVdTVGVUWDNxZ29p?=
 =?utf-8?B?K2E5bFBHb0FMMnE5MFExY2NUTk9RaTEzT2EwNHMwdE5hUG5KTEc3cHc2K0RX?=
 =?utf-8?B?dGdLTU85NVVuTjlMRlFlZTN6WFNENWdDU1MvdGVjejM3N2RIalFPR3UzUmVs?=
 =?utf-8?B?RnZDZVY4ZjJkZHpQVTRPQ0pQbFpUcGpsOHdNTlpyOFo0bElrSG5Ha0pvY0Q5?=
 =?utf-8?B?ZGw4cFRqblZaNFAyZzhDc1lLUU5Pc1JKM01FejdlcUthTk9NRi9SZ3VyWTRY?=
 =?utf-8?B?WUptUzVqTkFLV1hLcjU1MzBYNS90ZklvQ2p2TDN4WlJiZWR4bldGMDN2V3Rh?=
 =?utf-8?B?ZElRQkRWN0I2dUYvWGNnWE93WUkyU29iV1RzSnI1SklJYjY1VTh1ZkxwWmZv?=
 =?utf-8?B?L3lhQWJGWVdHU3R5K0dXS2QxV2ZWY2wxMUJCcEV6Sk1XbVBSSGZDeFVxTWh6?=
 =?utf-8?B?Vk9Lc2lKWUIvTlcxdkRBVzMxNUZTQm1qc1Q5eHdXb3Izb2lxR1pvMWp6RDlB?=
 =?utf-8?B?N254VjcrNmdhYk1YTlJhQlNlQUdBTnE2TmFuK0pTMHhEUTdLMjZrTzR5b3pI?=
 =?utf-8?Q?stbUEeADVU+f6ZZoshkZlSuxsXf6HBuZ0LmkNd2JBei9+?=
X-MS-Exchange-AntiSpam-MessageData-1: x7OEDZj6x3mKhg==
X-Exchange-RoutingPolicyChecked:
	Cg/uh8FM4qFtVR7H4LyVihtuLnYjADeWl0ng2XfPBgeHU7ZVW/ipWQ0+peXv5g/ykC2LGbthT0C1CUUPTfB1Z4+K/3DnuuCRTnrzTkc0xk+zJrGCdaDRgEIhTfLdK6+Dmci0Tu55wrLsFozDQxDMMzto7A+WNbkBXMQSOc1UBJ+sfrq9tn3+0kd37+snmj/6oXJ/MYBxy52eQq7r82/8bI7SX4onXMpOYPHxu1QeNlSLt6qF2hTOXKPspiLJXcsC4kCCwtq6MWqd5FjYNvuXYmsmOsTQxZTqohNCsifYOQqsfSHwT1r/chfvOesR37dDwE92tqlDGmkHjrehy/LUaQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2Xk7BjtiLcyluOpLZradjmaBxZT2+6lg8CL0+zDLLck6Oc9T5O1TWvfcPMQMGT4OwqDcL6fj3AJ9TPllwcU6zJ4gTZTx8+W56QtCQRyPStoDSOzY2/g/Od1ENaFaUAoRBNWxQGymukAQASlLlM0/d9i5PtVNMjufxtD0DJz9aXjF2qhefd0stjtAjYaNLWWJr9dyZwAWmxczndehSP6OXFZhwwT7lU7+bP48RNJKU9qp+GalK5Tf2Fqfv66vQmbB2BGuGu38zdWp97tIRzRqecXWAWR/d2/Vx5BV8/3TkNJaJ/Mbvt2M5Osb7CF/9Pn0I42WjDaNVirlQXN0GhfdyT97cLsjS9q0oT+Ibs5ngSR1jf7F7Gq6c7uXSS18Hb96coRQAIFWi5ohoZ49vm6TXW8DJv4Z/l5CiyHpJ0in8NvDaddT9Wg41jWfOvCgZ8kyIiB7N5n8FcbkbkQ9WjZLPnWkjUMXFHWbWQX5tVv7vpXu17U1jeQr8xFdF8uEnqbRI6sIuTrMYfGW8FmmuqcFncoMiS8uVmxJenmYIcjsRvYI1w/fh+y4cx+TBOuZ1815WNLS59IgiG9ZU93Qe5UF30gwZ6AfGrL/4o0kn3SpfU9e0vsefvDLXgvln4LZOW/A
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5851d0e2-882e-44ca-6832-08deba11b45f
X-MS-Exchange-CrossTenant-AuthSource: LV3PR04MB9258.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2026 03:57:13.7486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pZHqolYM5r2s1ybSt/L3LfmFZNa9wwlCk5uBWdCTnMVvZl6S0y/2zEvTOQB5vlAcLkFUuGiSeVSk1twA/369SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR04MB8111

On Fri May 22, 2026 at 6:02 PM JST, Johannes Thumshirn wrote:
> This series fixes premature ENOSPC errors and deadlock issues on zoned BT=
RFS
> filesystems when running xfstest generic/747, which tests garbage collect=
ion
> on zoned block devices using direct and buffered I/O.
>
> There where two issues revealed in the investigation:
>
> Async reclaim deadlock: On zoned filesystems, the flush state machine
> only executes RECLAIM_ZONES and RESET_ZONES in later flush states
> (FLUSH_DELALLOC and beyond). By the time these states are reached,
> ticket waiters can deadlock waiting for space that can only be freed by
> zone reset. The fix adds RECLAIM_ZONES and RESET_ZONES to the first
> async reclaim loop (FLUSH_ALLOC) specifically for zoned filesystems,
> ensuring zone reset happens early enough to free space for pending
> allocation tickets.
>
> Additionally, the series fixes a bug in data relocation block group selec=
tion
> where the first block group was incorrectly skipped, and adds a new flush
> state (BTRFS_RESERVE_FLUSH_DATA_RELOCATION) to use priority reclaim for
> zoned data relocation operations.
>
> Using this, generic/747 passes when lowering the fill_percent variable
> to 80% (from the 95%) that XFS uses. I'm still examining if this is due
> to XFS not having metadata on zoned or other statfs space estimation
> bugs or something else.

For the series,

Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
