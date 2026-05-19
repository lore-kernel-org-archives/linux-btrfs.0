Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C2E3C2781
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2026 08:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779179986; cv=fail; b=fNd/ix2Ih0R2NJrQ1sxvw6QlsJVNW8HU4wnrmIFs7Uk3ECMuwFZC8rs4qAqnPSm4Trppwvpiye6hj1IwuZHYIPUg80ox+zZIlfrJoawNo8nQvq4LHZ18vxWzZgqTXorGNlcHtEQElqPnvUITNrM1/0ILoegctpH5ia3kFdhqRkM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779179986; c=relaxed/simple;
	bh=Z6HnCSdgyoa4205CgrA1o1rErhtjhda8mml3JAN3gtg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DtzZZgyL5L2vm+LymlI8i+fLEul4Ts+Lo+52BFtt4lBkDScxJLuwY+j0FYR10wKP6Sb87h+zPKbxkXq4rBmipKBJtXZyF5DnRw+lQ1gGTmY0DITHcnaT8YaK0lLssa2+5fe/jicBB7wR9H0Hj3K50q+PZZS4oUum1ESucpIcYlA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=MeEpDdxp; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=lZvFrmVd; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="MeEpDdxp";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="lZvFrmVd"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779179985; x=1810715985;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z6HnCSdgyoa4205CgrA1o1rErhtjhda8mml3JAN3gtg=;
  b=MeEpDdxpHN9S5Y5WmVtaxvGPgcBsQmmeOD/MJtoANClsw1dsVbTGbtyb
   3VUYoFrDUJ9RsLOgLc2KA1oQLYVi7l3Gs57oE+O1WVhGWhXPZ9PzBYbED
   boOqOnvWEqfWcNx/NYvlDr8jHX056UBHAz/V4X4dYNCUybD5wNVuSh83z
   E3w40KrFYlwa297H+UU4auOiK0xi3R9uKN+aQdrygc5dlHqRZGAoR5DZd
   v/fdAdQkjzANRRvAqLpdzPgetZ7oqQtg62/md988eiHJgbl2ldY8zSxsH
   tuP2ySl8VynsjRf+Ya5ThmGr4PmQ7BtEC29PXK/6wpMtzx/HlAm3u3Y51
   Q==;
X-CSE-ConnectionGUID: dQgXDYjaQuKpZgT/5OuIog==
X-CSE-MsgGUID: QOc+M4VRRmC33xXiuR5QuQ==
X-IronPort-AV: E=Sophos;i="6.23,243,1770566400"; 
   d="scan'208";a="147248053"
Received: from mail-southcentralusazon11011054.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.54])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 May 2026 16:39:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DV+d+3i9yq3h+sDkQ2bG5XwqU4OcTHB2G09dWTwCCYhHhDeOTB3d9E3G9CShK4GdoQWhz9n+ohhGO435Iy9VFzuYuMgEu5FJpf+Lwp61FWvm6vLA8NnMk3cl8no14iNtFOdiERbcafCUeabfM/9LHC10YiWRFpOnPkgWbnoBWe0ulH7XZpQpSmcobOXXBGLBGJZKGqZt7nwL7pXplgX2vMGmRnE0vtNgt7Voy/brhc0IaCwI0l/fKgSwdLkr34WI14cBnfkBfSF+xaLDi8GOZl0sBd144H1mnXFVDqS74gIeR7QNIs/4Oz6OEVYkGuriBu371YTfb/efyDoZDmz8TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DsOZ/mgW3wf//D+NB1Iejla0wkgLT3quhOqfBQzZJAs=;
 b=vS8NDKXAv3T6MRSZNVcHnOwRo6duk6oZ/R0zAL8U0enV26zEoZAytte7+I6S8Oxd2twOqmESbrsZz+cAEKfBP4p+oKVqvlLw3hgJhv+jJdN6443dGnJURni3qTHO7cNbm2kF2u1y9lXaEGtDv9RAVZuiOSSme7jTA14KFKrZv0R6Uf0XbKV+A8DG3uZ1A3vpl9GN37lV6ph9AChdGOtY/sgXmBwDfXyXWhsUJpPkVuYfOyibluhaSp0pb2sMlCFGcY0l+sRrLp/D2EiTDVeRFvX5iORkbJllo510wyoJN5m5ffhYrGMj0GNtQPWFeBfP+gURYc1VEMt9ESEI3MIqEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DsOZ/mgW3wf//D+NB1Iejla0wkgLT3quhOqfBQzZJAs=;
 b=lZvFrmVdknCPWIIe8hmaRwkYpVMQVvTeyskZmA6ZDQfXazLoBJFu8r56mHqvNAEVGbcHnHmXtd+aMlpj10Cpm10g1josFmaHEy/wRxlACom0uPGU5ln0e8SrUp6DQNosCap/qaZsPfo/A9wE0h6s3kXDehbtUT0CtNyCpJijHFc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV2PR04MB9836.namprd04.prod.outlook.com (2603:10b6:408:349::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.22; Tue, 19 May
 2026 08:39:42 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%5]) with mapi id 15.21.0048.013; Tue, 19 May 2026
 08:39:42 +0000
Message-ID: <eea8b24f-bc7f-4a38-aa42-0be9f59e835b@wdc.com>
Date: Tue, 19 May 2026 10:39:37 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] btrfs: zoned: reflow max_active vs active checking
To: Damien Le Moal <dlemoal@kernel.org>, linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>
References: <20260519071621.56490-1-johannes.thumshirn@wdc.com>
 <20260519071621.56490-3-johannes.thumshirn@wdc.com>
 <47dd7766-66ff-43e5-8894-f46bffff469f@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <47dd7766-66ff-43e5-8894-f46bffff469f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0244.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:af::13) To DS0PR04MB9439.namprd04.prod.outlook.com
 (2603:10b6:8:1fd::6)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV2PR04MB9836:EE_
X-MS-Office365-Filtering-Correlation-Id: 797b03c8-b2b3-4b84-8f49-08deb5822bb8
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|19092799006|4143699003|56012099003|18002099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	SFWuA+/uCWYshIrwvBQjbikAlfT5i4A9M3obK1rdXLy4g4uJ5BOewxlFTpBJ7Xw7ALLaRFPhrCzGVybe34Y1oqKPXHyHw6Wctem2j6q1v2rLk/ptGWECRtHeX1NA25ToI/XxR0rCwHQFe4bIbLdVGMwTmB6Apom3aBWZdJ0EfP5idP5SSsTXBgAoAGRYP/XWjYk6wyKrkyzOI7CWyqpUkCauDpHGUP76lcglfYa8xeKLvHrojonnImqyMLoAMFzf6QYrY3UdU3nUpWQRHubG2FVFRX87qgdWPZa97PbTLv/UnBYJcOimbCPLj2Y5nmCrtZxJLkJNxfNGaSBV5rFtIkZED+jXZrVb3vIG5RyDvtpJ5oE3YngYTQYEO+alqhnp0hUOpIYYrQ525jc1qGyMfmU2f8Hpmy6JCqoFlFeSgbrgwJSvy/12NoBWeK0k4HMKZlauXCmD3M7Qhm0Im9aNIhrLPMGPhm6cG9xEv3PsZJSiaucYb4GWzkxc+BQTzIHPt+ya7849MYEdC6xsT6r/dC62inxZiE5IjV3aitAJaMyXIke8qFlVLNTwSzzqjuUEtqWjp3+qorEqoUeXEJSvuHko2xwV1RwNPdQ7gqiKp16bA84nRt2BgCJH/gS2GS9Bb1drHqrwBH6732n2QUCdywXJGkRC31cmuIUbkOY9ByLy42arUwYSkxH6v95KIvjn
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(19092799006)(4143699003)(56012099003)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OFRyMEd0ekdORVpvSkdaWkprMUlzbThLbCtYS0R5Zm1LKzVrUkFzSHkvMTBI?=
 =?utf-8?B?MU9xNTU4NjFTK2JncFFScjJzSGZRLzNUM0J0dzJKRk5nZUY5SFNNVmlUOGVt?=
 =?utf-8?B?UnlyQTRJa0h5VFBmM3JSYkpZZEt3ak1oRTNRQXRmRWwwRnBLKzE2UkRFT2hm?=
 =?utf-8?B?b01vWGlMU2NwN2RSd1oySE85T3htQzlDcldvSkZGTW1NamlhSnRvUlBqYk9H?=
 =?utf-8?B?R3RockU4OUp3RHV5V2pHTjdnNEJ5d0RnQ29kbG94NGxDdEluaTJGeEdZNS9B?=
 =?utf-8?B?d0E1N0FxU1pnK3plR0E1eG5KaFNYY1V6cldxVUtlNVJYeGJBbXpJYnlWZk5y?=
 =?utf-8?B?cy9Od2FHN0oyWXUvbkhNSktHV0dySi9aaDNUMzNCMFRJS0g3YmRMdllKUTRi?=
 =?utf-8?B?cnVjNHIvUkYrTkhObGhVM3hER2NRODlZRU5Cb2hteGQwT3lNN3V3R2dlSVBz?=
 =?utf-8?B?L1lMRWZFaWg3TVdrV3dUU2Z1MWJqTzZKYzJSbmxKcmdnMHovcGNnWGVvZFF4?=
 =?utf-8?B?enZ5VU1CZkR3Q25KT3JuTFpvdnd5bkNtRG1qVzNyNjAwc3ZtQ3VlNEpIcmR0?=
 =?utf-8?B?cGQyUW5wMitqbTUvTWtZWHh5eXd4Y0VCSE00eCtDT3crSHk1UnNFcUp5RERY?=
 =?utf-8?B?c1BkVmNpcklCcWVyS2V2amNjR1hwbWdpWFZheDE2SUpmdjFpc0JtOHhHOXpT?=
 =?utf-8?B?L2J5MHJBRnhTUm5GcTVKYU9EdWJoRHJUMm1iL3ViNUpPdkRldmNsd3hvMVRq?=
 =?utf-8?B?REtPMzNiT3U0TnVzUVhhVnR0WEI5bGthYmN0MEhWSWlFRklmSFROSm5oVFFv?=
 =?utf-8?B?WUZwOExUa05oeHpNQjBwckExNTNiSlNqVTNoTVIzWjB5YW1sUk8vWGV0SFox?=
 =?utf-8?B?V0JuejBlM21wTFFkeFFtVlE2MEh0NXJwdUwybEV1akpEVDg5U2NYdTg2MThD?=
 =?utf-8?B?dHhXTXpxSk1NRk5WemRFR3ptdllnOVE1TURJWEIxOUt1ZWlFVW1jdVV6bzYw?=
 =?utf-8?B?ZVFKbnBRRFNvYVBrYjBhTExMYTVzd1VzdzZqMklsUk0rTm1hWUtkUVhNbUln?=
 =?utf-8?B?dEcxWVVjVk01NUhkcnBOYkNoZ2RmVFVwdTNRSm5UeFJaR25ESGRnTnFqUkVw?=
 =?utf-8?B?ZEpBcmhyM3VLcVhYMEViUHhTa0U5OXI0MFgzdEpwOHNHQnlYdy9kWmxnQXIw?=
 =?utf-8?B?T3NRVWtKQ2NvNEVqYlNCakVPbU84WlN5UmwxQ3dtS014SVFzVEhkMWRLS3BP?=
 =?utf-8?B?ZGZmR3NWMm43dXM4UzFhWEVlUkVtc0RtSG9QZmg3enErUWV5TWhnZXN6ODIv?=
 =?utf-8?B?M0VmNGgvS1JhNm9FOGcrZWd4cS82bjJJeGJkMkFPNGhtRzg1amlGQlZUUFZr?=
 =?utf-8?B?RFlaa0FhMEhDTmFxbDNsSUlSbnlGYUg4anFveGRYNlRoNnR6eGJPTDZuRWdH?=
 =?utf-8?B?MXlRMzRURmMrNUtwZm1PWktMYUdZc3BpTlhyTjd6K005OFhGaXlPVzJPWXRm?=
 =?utf-8?B?MnFtMG16azgvdEQ0MXd1aE1tNjVMNEdIYTNwTVJvUmFwT2tUT0s3OGpYR3Yv?=
 =?utf-8?B?ZFpXNXRKamRMb0hVenU3REoxN0F3RWF1MHBmYWd3ZGcwR3EvT2FpdWVOT2JY?=
 =?utf-8?B?aTZFSWZjOE5vSTRmSCtVMkFydVJHOWVKRENSeDdIM1JSWEpvTXhpdzFxWXRm?=
 =?utf-8?B?NWtHSmFPSUlFeGEyZ0E4bDE1eHkyRnl3WVhOMmRSeEZ1ZURaUk9kbFNPazlF?=
 =?utf-8?B?MHREa0kzdFFEdzZudmhoKzA0TGcvNzJrbnBUWXhRT3l4bzRHMC9OZnBkTG9P?=
 =?utf-8?B?Mmh2eEZURFJUMU5TMTdCU3hmRUo0UVZmZW95YWQ4ek5CZ0w2UkVLRFJ2QW1B?=
 =?utf-8?B?alRPU3NhUFEzdElSdU43ZlBSSkcwME5nSVZJTkNpNHZQZGs4WksxRlRkZjEz?=
 =?utf-8?B?R1EvVDRHUEFyN0VYR01XSjFMSUd3K1NuREdKK2NkYnNENGRkaGl0T2IwTnlW?=
 =?utf-8?B?SlRDcnJaWjhMSXZ4UklJTDgvR0xxVzZ0eWtLUjRhNGFFSG9sYk9wZXYvUndH?=
 =?utf-8?B?aXlBZ0M0QkZRa3pOZ1AvL0V1NkNrTWJKT0IrYWVXc2cvSys2K0NoZzJVcU9C?=
 =?utf-8?B?WEtsbmMvNUZFUllSQ09CKzh3TjVieUtVRjFsUU1UNG8yYUxrVUZiYlcvQzdL?=
 =?utf-8?B?QXdJYWhURDVoSHQxRDUrM2FMY0FIeHhaSnp6K2FmK0wrTkVEZUNENmdVNjdL?=
 =?utf-8?B?YXhtSFhSWnJDMW0zc0EzY3ViRkNqNlNIcWFBUjJzUUxYVWw0dkZ1QVlNenRw?=
 =?utf-8?B?OG4zSEw2cDFoQ083bTJTQ1A0V3huYUxJeXp0SXJkQkFrQVJHL2JZUmZ6Q01a?=
 =?utf-8?Q?PAQHyxEFHIxxBagk=3D?=
X-Exchange-RoutingPolicyChecked:
	X5E7vLgTmGKvL+tVlXFtlcpRcmm1P/svesrEAVzOl2J+Mlu+3k3hUPRx7Vs6ka3yUSgL8cLT8r3PLUUkiGmTEQxHsjymh+5t4BGm7KjA3CmrpZv7oCSc81W7cUI5XDw7x5eUOo2IQTynNYpOOxo2PFqQcF8823K6D/4tY7RZSRHBJItN8OvHpiIkX83uBCwNba9LFkP+0+IajS1iRBGKetbCB1Yo537GlhNJbtgujtmiJb4mkrkAfyqeKqcrJT7YDDqhf2WQh9TMKSSCcR68ZnTiBk9ngf8ZFpvVwX8SCnNv7zqvjNqUeMkQAmF2UN9oINHmKxKZeYcp2FrMk9HyRw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1f0QX9y+0mWOrZ4wDLFXsQYh6IF81V0AhBrJ2ZL8wVO312foXYJHfGo2TcexE7D4vKWt5jUA4YUb8hZQQVoVT8oGzLKmgFHG4zxRYO8gxq23cI0gPaa4oAMnYUdpaBzbO5D2QMKXUdfHH3aWta6cNsiTQCEIy2vIN5Ty+5P0GgyjLUIB4k1QMky136Knq5vaFSQNmxw23k4kHUFCA/nbVYKZ7ZjC42DCA3dH0IUIYP3hUpjPa4RON3uBG7pYH6U54+fM8mtZ4w6XYoFJrSwYHryazYwcAyzL6xN1FRRPgrZsNXxz+UuDR6iTUUnBt8vccK85JU4gx7m9epCNnZxKL+OQJP+BHh4lz+YoWubn7Y9G4RZLrlqdNtyv1U6s/UmGgVBEqlfBYSrv9hUtzihzCPVlW/1giXEoWBrSxxEypf+ufNHOaie15xfXRzmGecS9S+eM3o/vMc2RHJqIOiwMIx1DyZiQkSayY9mTISQKVDxXzLeOsvhfJATATGRw4A/M12glkurQYIywkCSWmLGZQaL6CaxLFjSV7ND4Lyld0RoDuVZ4g6dYuWsJx7Z5Zul06x/LTv2KgT9pgmsavCEVkDvWeVqvmSdgmprnaWk/2HmYFnDFuX4uVSaY+lX+UaCs
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 797b03c8-b2b3-4b84-8f49-08deb5822bb8
X-MS-Exchange-CrossTenant-AuthSource: DS0PR04MB9439.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2026 08:39:42.2744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dB8RWUD/jFV6Oz46tnQDmNLi1giODeOlqmavENK8Hzvi7zD5A4X7O9sLc/CVWR6gjUlnbYzn2159MIxE48Cv/M4YXkqjSIXpaAC97QaFQNU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR04MB9836

On 5/19/26 10:37 AM, Damien Le Moal wrote:
> On 2026/05/19 9:16, Johannes Thumshirn wrote:
>> Reflow the checking of max_active_zones vs number of active zones, this
>> simplifies the code and gets rid of a goto.
>>
>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>> ---
>>   fs/btrfs/zoned.c | 32 +++++++++++++++++++-------------
>>   1 file changed, 19 insertions(+), 13 deletions(-)
>>
>> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
>> index b1d0e2414178..9653681a6954 100644
>> --- a/fs/btrfs/zoned.c
>> +++ b/fs/btrfs/zoned.c
>> @@ -528,22 +528,28 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
>>   	}
>>   
>>   	if (unlikely(nactive > zone_info->max_active_zones)) {
>> -		if (bdev_max_active_zones(bdev) == 0) {
>> -			zone_info->max_active_zones = 0;
>> -			goto validate;
>> +		if (bdev_max_active_zones(bdev) > 0) {
>> +			btrfs_err(device->fs_info,
>> +					"zoned: %u active zones on %s exceeds max_active_zones %u",
>> +					nactive, rcu_dereference(device->name),
>> +					zone_info->max_active_zones);
>> +			ret = -EIO;
>> +			goto out;
>>   		}
>> -		btrfs_err(device->fs_info,
>> -				"zoned: %u active zones on %s exceeds max_active_zones %u",
>> -				nactive, rcu_dereference(device->name),
>> -				zone_info->max_active_zones);
>> -		ret = -EIO;
>> -		goto out;
>> +
>> +		/*
>> +		 * This is for backwards compatibility with old filesystems that
>> +		 * have a lot of active zones because the device doesn't report
>> +		 * a maximum number of zones and we previously didn't care for
>> +		 * the limit,
>> +		 */
>> +		zone_info->max_active_zones = 0;
> Ah. OK. So you did this here... I really think that this should be in the
> previous patch.
I can merge them when applying.
