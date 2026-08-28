Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775D93D9522;
	Fri, 28 Aug 2026 07:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787901648; cv=fail; b=frOnsjJUmMBHBnq9Y5ErBswPZdIu/SWkTOmjTrrd1ZBvIveNpSfv9GVPqJKZG8FhHwECwFH33tb5xpUVBrRlVH4ZsU09Pyw3sP9pL0rO3m/1cq1fxixSaIC2fday3mCR8mMLP0jEfiPsHQ5cIuhH5YKAvuRww+W6cWx6/JvIGic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787901648; c=relaxed/simple;
	bh=stW4xBero9w+CxDfHgL7AhDmzqco48rWnmptI6PJ5is=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NJlWY4i5xz7wr/+lXko/gbAhyr6u6AjLLeMtR1JlkC/IbLuK3lzb7t3IXJyQ4HPFZNraiqXfbDuc5VXUO9IDAiPvfoW00AHRVEhXsRFKCmrDK4C5qKED5nwTKhZy5PO0OrNH3DSBWQDMa438SKsIxHv5/bUFuF1JNIpVaSfYkps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=JG096mLg; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=d/sLmygx; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JG096mLg";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="d/sLmygx"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787901646; x=1819437646;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=stW4xBero9w+CxDfHgL7AhDmzqco48rWnmptI6PJ5is=;
  b=JG096mLg7YixMizOdhVQ5SB9QrrhdJKAWS0IHtG5UCM/22hl72Nqai19
   UKGD4sQoJ391n3ghjULzxH+/XSYqWDiWy/B3PZVhd++674zmP191C7CJc
   GdnVchw4ucxU2OzBKVKQy3lbsnyReApRyA+1jAymzTJeD44RKI09KMmnA
   BuWDiy1q2eot8+GScZSMIl99wrXFP835FhONKJBHDLBaCD8SOvUjsAvzR
   mV3HzzEgLKVk0+YTzYZbO+2/7lMO9/PzWi6oHI/4bjO86cIe2iX5/WP5i
   7fQyreHuEYbSmZs9VPNUMniO6825Hirp5CLlq3AzEH1q/I7hCHj5hQV5W
   g==;
X-CSE-ConnectionGUID: BF7Yc9JDSeqrav4ufx8a+g==
X-CSE-MsgGUID: T8kCvHiRS0S4GzNMpAkmRw==
X-IronPort-AV: E=Sophos;i="6.25,248,1779120000"; 
   d="scan'208";a="154221183"
Received: from mail-westus3azon11010012.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.12])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Aug 2026 15:20:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yuL98eGPcxHDd6E6JSfmjDV/8ddrMl2R/k2gFX7LkfV6Dg6Uil6oeN22Yy1Rd8G6ABE1Xj/wnCoblUWuYeuyNQ2iSk6Fd44ec1fyhvXSIGlBcGEadjs8058Eq71MY59u0Ig+DHdnluL0erbx0GGpwKGuktNipsTmPnwR6mWS9hBk3AwtvMKg+wyFIJQHdhbTO69dYSPMsCJiQAt4mpEGj/rnSI1YFm6GwBhpz2V/juCpcj2QSymyiMoiZ+OK4LlkcLmx3xwD2XfSIaTgheAeL3iGoqfEVB3zd0fXU7YZR8ESOikYLBwcGl7RQt+oH32SnUXsbtsjsLeNHzKxh6A8lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BmQT+O5qWTsvjZOelwi2FDQ9pOJ9cSc90/UtguDl9Bc=;
 b=JyPyWhvO55g5rpQQuZnLDhuBhp5ENeOIwhvOYLfk+AIgFY4QRYno8oq98lawiy96sTQCZy+0h+fohqmPSeFuaAX0xzYr9jcpHuy2OtQqb7YUIZsIbkk4NQSRodDRjlUKpUKiDCmiV5gAaef07hCAgkwy+jexjg04Pesjz1TiNZXx05zunCptA2FBOPS7z2emi5O3gCNHNME77puUKNHlIurwaM7lwmHnhawtIlKBK1SpZoJnZwv+680K+9Wq1r98sK9SKmim1uAJhAHtjt8Wpm/sVLR51XDt1lfG3dibcw032zOxwOBYzLntpwlq5xuNBHiFeMtpe6voLziNRgNT5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BmQT+O5qWTsvjZOelwi2FDQ9pOJ9cSc90/UtguDl9Bc=;
 b=d/sLmygxdYhlvXmnv9aCmiohe3q74r8EZ4uyQVU2EkscLdRTBnTnfk2gZP2OItoO9PqqnJTTe2sPeUccWFVrUdEt2jxu277+tT3pAEygQZUTLxwW2nKMD/GTMuMw1IaO/qgRcWIiZZNQCdUYP15WKjdpwRk+VETF0oBg39P1Yzo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB10296.namprd04.prod.outlook.com (2603:10b6:510:110::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.11; Fri, 28 Aug
 2026 07:20:38 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0360.008; Fri, 28 Aug 2026
 07:20:37 +0000
Message-ID: <c14a1467-c813-48b6-982e-b877f4e5d843@wdc.com>
Date: Fri, 28 Aug 2026 09:20:34 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] fstests: misc fixes for zoned btrfs
To: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
 linux-btrfs@vger.kernel.org
References: <20260819131606.1478488-1-johannes.thumshirn@wdc.com>
 <apBg3n-J7PP2nD0M@zlang-mailbox>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <apBg3n-J7PP2nD0M@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0116.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::18) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB10296:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c3cd703-55ff-4b8d-ae48-08df04d4dbb5
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|10070799003|23010399003|366016|19092799006|10067099003|56012099006|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	iAxeIG5rnJGG6h9VPMEtXKVe+hGrDji02b9eHEiYH2giNAJN0fWuDc7KwGX7jqaYD3ED7EzsVbFZp34Q6yVeMaEYlMBtIgYiqQtHWj00TMYNlXxOmh2wgdjF1hVes7eV6Rbv7BsHL3KBtAny1ONmHZGkEwJV0wD8nQR+UGKLqSF/BhvY4Y609wplPkoMUXD2WfSy5mWrFDv6nepZMIP2EjjsMhgB4D/KAiBBFmAu99zwSMIG+SjpVmtgxBrHBv0DxzEPlPdru/6eOA3E2WNF7qa03+Xp/LASjUIdkrXMu6wWqLurY9nA7V+EQrECB4DkvJzv0px7G+OqBG4RcK2hDWLe6XdYuyP4w+R8UOWVpOjIBON01DDbp4LX6PjNu64Lnor0rNKgVJfiuyRhtDQyjk7xJjw8j+YwMj6unuzTxOBu8OOxWy1qO2rrZL/mRFCvBNO4NNmlKd0RRgab52k3n+uzvAvBdwFHzA+PUgURv0Egalj3f4itcw5a1wFmApErQWEejVeQEXta9O9bxNzgNOsc2Bb6TCBaTlmbmiqGZGeLh/rSmy8McQw/QVu73vrpJ2ZPiaBuC/8Vech/iEuDAuEEfmEW07upBjrALznSkncI+DK9hSdtTl74VuTIWA0A2bSLPAg/GjdvRjtl6yA0ZfY0ul9khgICBL091nPO2js=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(23010399003)(366016)(19092799006)(10067099003)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eXE0SlcvWERQUmFpY2ZzYnpYMm1jdGtWcmMrVStWeXJvcWhtdlFBOTZSOXlJ?=
 =?utf-8?B?SXE1MzJPMjdnYU16TzJ4eG5LVnc3bGxoUy9ta1FHQWFaVDZsVE9MQWpVbzlo?=
 =?utf-8?B?MGg2bVJXVGR1V1UrY2UrV1c4YTI4emtjNHJDcXE4QzVNZXg1RjJUV0ZQWDBi?=
 =?utf-8?B?b0liQzNDS2VNRXFLbFhzaVdvY0MxOVVsUGp1dXg3d1BDcmV6eGd3amxoV3F2?=
 =?utf-8?B?QW9GcFhib2VuWmxaeWcwbUpPRUE5S3hIYkZpQ3ZwSi9rSlZoZ1ZKeFJsQlho?=
 =?utf-8?B?aWlYNW9Ya1d5VVFnUExLRmFMVU1wbXd2ZnpxQ2xKZzJkTVk0QWp6aXhsTDJJ?=
 =?utf-8?B?eXFxa1pNS1lWRE1ZOUcxb0pSTktxSitOL0xOV0R1T3E0OUlidnBxbHMzdm0y?=
 =?utf-8?B?UlhoNDBRSHd6UExkdEpWSC92RkEwci9VS2hqM1hMTTVJYng1K0grK1p4aFIv?=
 =?utf-8?B?U2ZUSzc1aEJaalhRUXNKRjlyK1BBVkZWM0UvWksrSDRORmlSZTdjWVVBR2Rz?=
 =?utf-8?B?ck50S09VNUhFT0grRVNzMWJLRnd1ZERWcFU4YlBQSFdHT1MyUTdOdEl1V0oz?=
 =?utf-8?B?RnRadHZjM0NjSVZMQkpPZ2hvQVlkeFN1QVNRTUtHaTQwdEppL1E5UnUwSGF0?=
 =?utf-8?B?S0dvRlZ5M2E0N3RVd1UydjVZVVV6bS82Ump4dHBlSVhQZkJySmxTcGk1dTBz?=
 =?utf-8?B?eGNLcU11clZIT0xqTktuRGh3aUVCUEJiTzVRcE5wWE5EdXdCWUIzckdaNFBD?=
 =?utf-8?B?M0Q4eStvdEZZNmxKV2pTMlFQVDlZQ01VSnZUYnBMLzVmZEp1ODZWSWRFYXEw?=
 =?utf-8?B?Q1NxMEJ1Rll4RVBiWklNSGx1VzM1bnFIUDlUOElabnY1eHJpRTd3aVBUL2dI?=
 =?utf-8?B?SHlocDVjcllTRy9TRXkyOHA3Y1ZZcTZLSXNYMTVTNWNQalJtUDI5bEFJWWlJ?=
 =?utf-8?B?NXlZZ2pJU2loei9QeitwdFpDK2R2UmgrN3NDMC9LQlVTa3Mwbm16QlNnSnlK?=
 =?utf-8?B?TlkyWVlFZHVtNUQvdTBqcjUzeUR3L21mZDJaUzF4aE1OVjJTbHNVWUJhWk90?=
 =?utf-8?B?YlZYYTRXVjBLYzF4Y1Q2QXozSHVwbmJ6N1VIUkZRcGtielZUVFZxS0ZiajNN?=
 =?utf-8?B?bkJKcCtSMDdXQmU3Q0JHVUlGSnNsVUNIYk5vK3laelB6OHVkYXdSemlncnZM?=
 =?utf-8?B?V2Nhb1g3c3ZyY1N4UHIyWGhyaEtGbHExTWJDREhzaW5vbDNuVS9yRXhCYmRB?=
 =?utf-8?B?R3M0aDRVRjZtQVZmYk5lNkUzekZNcnozRDZGTXhITVBPb2dFaThQOVBCWXlK?=
 =?utf-8?B?Mm1NNjljcm56QmEyQWZ2cmxGTUp2a3hJblVSMzR4eFhJMHRTd3JGYTgzQ2lj?=
 =?utf-8?B?MkZjVGtXSGJ2THUxLzlubUlyWENhaTNlRWJDZUJsUW9uRXBaMXNaWTIwZUs1?=
 =?utf-8?B?eWRTT3hucXd0WWNzZnI0VnVORGViVTVuU1dDNEcyR3pyWG53RExGQitGcFlH?=
 =?utf-8?B?NXQ1M2JOdjJaemV1ZExtZTVldU5vTk1NcG5ZOWtrSVNuTmVZSmt5UnlQQXZE?=
 =?utf-8?B?dUxWQUxaUnNCVVBVSXhubC9yY3RKZ3VOQmF3dlJSSXNTb1g1a255Q2EwN3Zz?=
 =?utf-8?B?UjdEdlNyY0RKNjFCcmtyUmQ2YlVNdjlsazQ3SUtCSjBWUmlJZFJMeWtDNkxQ?=
 =?utf-8?B?VjRrVVZ4N2hyaHFOdnZOY0tTYVdJS0VFZkFlZko0UmdrcC9aNmVnblN5d0VT?=
 =?utf-8?B?dG5QQ0F3WlkzTExGdktScTdPMVF5aFZxa1lGQjdaWU52RllHeVVHSjZkVkRL?=
 =?utf-8?B?VENrQnk4L2o0d2U0Nm04WTVFZDhZdGJCY0tFdXUyNDkrNWo5KzNENU9ncnR6?=
 =?utf-8?B?ZGkvaHlYcDJ2ZktlRGE0YUs1MFJDbzY0MFpadEpiZWY4V2hianpYdnNOVzhW?=
 =?utf-8?B?ekYwZndwVkpzdGhQRGdTVXArWDI1bm5CVkZOYzVULy81eUVxT0poN0xVZjBG?=
 =?utf-8?B?VHU4UG9wRDVudEJPc1E4MEJ2Ym14VXJLTWdZQ1VMODlMb0lvTjh6cTJXTlFz?=
 =?utf-8?B?aVNzK0tiQlRvczZwbzV3L3VzcjRMZ3MzRTRQMks4dXF1dkV3NDY4eTR6dDBB?=
 =?utf-8?B?bTcvS2NSd0dwMVFaR2dmd3ZNTjNmTDlzWnpmS2NBU0c4WWRqNEhTVTl2MjVR?=
 =?utf-8?B?Y2EwY1F5UXhoWWppUnhIbnVFSnNTZURzSDZIS25mVHVFYXUwbS8zTEo3bHBR?=
 =?utf-8?B?cTJOazBoSEZ6WHRQMyt2QWw4dUxDajFZK0ZKM1o2SFRmaXJWWWFuNXhZWGxv?=
 =?utf-8?B?N3c3TXBoditWbXlpRWxHOGEwZkJwZ0I2ZmxKNXBXalpCNUk1a1RLS3RDMEVo?=
 =?utf-8?Q?tqMdp2jDeJWUHEz4z08hDJeABNk58QokYJIMhYdeEMd55?=
X-MS-Exchange-AntiSpam-MessageData-1: TOxrsV/Rr02NUmq5N3S0eZ8jgjp49z1BpN8=
X-Exchange-RoutingPolicyChecked:
	3euMwOqafXi1wSw68n0iD7KdN5bxRyIMe5yYxhc5iRbmr5DCz9sOxKeHbPtoGeq1f7BZEWdxeFFK/ziLI9fxykbS68F59tjhBMwlJx8IOKwL67WWKfQTCbOWiETlC96sCXEnt0nSUPxjD+XhSwy6cVtLtovvAbBt9RpYWIKZSUOIWmyoEbRqqVLh9H84JfKp+xZCcwkE75ShbBFOoKF8F7U/4FUXU4rc1MrF16hY+RO3VJyIbfJJxQG8RnGLE05WTkCyDW4e3IzsZVHJN38Ge9xZ3LNnDXM/gO7SLg1FkWHy4uaObIbN1RsxKZ60vrfCA4XR3XJ42TIEqggGHuupWg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CUMV0GK/ntWxB+YMJsBXBFLlnBFCBNQHk6tpTLc/TUOWnDbThJoNCGmqqSCNjc1YqANtVzcR9GdyfdhePGy+SbMApcLmZWnZ4/d5ankZxGkNume8q+hyl+W4o85qZW3vS0ZQaF7DtvgwWcYQEkzZ52DEmcwA2I4NoOT2MLJv1nPJa100Qwp0yMFFn3tn577mcWMXmVorHx+W7Pz6B4nENNc2Sn7QRrubIJo/UxzWp6XtAFKGbhM3RL+iZG/J7ty+TLglusg3MEoqATfyFafzIgG7y9CRM0AQFT8Z7EzQBCKSof4p8/+Nz0/WWn5zSehcOg90ECxdHi1VgwUH4HsCW/ALa3+B7Vjkect4N15qEily9zNUW9V5U0/yLNouT51Nm5Var5c7MycvRVK8YPN487kZ4JwN/lRqzVyYLrtNo5AwG0ik2mw2NHWLMqY9owfRuqQ7tYKmKtsr4Co3h1g7zKh+LgRnz988T09Imix9rsYXhz7gLZniFxDusIQlSkgFVNL7IxKaf0uip8/8tGrkSXW1Lyg7cT611rTX9jbDaN3Sr+2jINu/4qqaWsyzKuvtibUMyDfoahlULrkwy5BhYcioMKcUTIJCHx1Fha0EDu6IghQW/RsW5aZieDIuOyTi
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c3cd703-55ff-4b8d-ae48-08df04d4dbb5
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2026 07:20:37.7719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QtGMXOxaAmH/59HNnjfE6NfOk/SFxLK3KPRKsWf11LKImHSsT4dpRi9eM6VTLOTwgr5iAaXXheUygt4+CP18fzdOfzr/8uex4vFnaDz7eAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB10296

On 8/27/26 6:09 PM, Zorro Lang wrote:
> On Wed, Aug 19, 2026 at 03:16:00PM +0200, Johannes Thumshirn wrote:
>> Misc fixes for test failures (and a typo) when running fstests with
>> zoned btrfs.
>>
>> Changes to v1:
>> - use _require_xfs_io_command "fpunc"
>>
>> Johannes Thumshirn (5):
>>    common/btrfs: fix awk field separator in _check_temp_fsid
>>    btrfs/199: skip on zoned devices
>>    generic/746: skip on zoned btrfs
>>    btrfs/284: skip on zoned devices
>>    generic/781: fix copyright
> Hi Johannes,
>
> Except for [PATCH 3/5], which still has some open points to discuss, the other
> 4 patches have all been acked. Given that this is a misc fixes series, would
> you prefer that I merge the 4 accepted patches first, or wait to take the whole
> series together? Either way works for me.


Can you merge the other 4 and I'll try to get around and incorporate the 
feedback to 3/5 ASAP and send as a standalone patch?

Thanks,

Johannes

