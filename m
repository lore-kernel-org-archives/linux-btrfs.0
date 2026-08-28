Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F32A3C2782
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2026 05:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787894820; cv=fail; b=cmz6XT6lvRJDOJVpjmoqFhEGctm1c73qB1yH8QkICP8rEqWeCYhbfNMq/BKs2EEBzNA+E6dKVrocnilP3JA/QRf4+QWXxponV6l4w7GNyUk834yn20EvrFyJEHighyupD/7gL8c6XbHQKPGPMYPDK9uoBKe/h+bytxSsQ7BVT9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787894820; c=relaxed/simple;
	bh=Gn8fAixDieR6czKGomL5kK/PA0sU8xSj8fSAJGLIVuM=;
	h=Content-Type:Date:Message-Id:Subject:Cc:From:To:References:
	 In-Reply-To:MIME-Version; b=ekc5VW0QC78gCDC6zoe+eH5ps7WitYZUZThiWqd65rjBCus49uKsmEpysZ6IGeZcEA4IFDA5hpz75ZRkd90QKVfphfDFHqBALKrlXj5S+znjwc7rFxDSj3K54fAX+qpvAYI6Rz+35dgBZJpl0sMACzhsLewg8IwhcmiYDr/iz9Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=QCDVDSHZ; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=l/J3931g; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QCDVDSHZ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="l/J3931g"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787894819; x=1819430819;
  h=content-transfer-encoding:date:message-id:subject:cc:
   from:to:references:in-reply-to:mime-version;
  bh=Gn8fAixDieR6czKGomL5kK/PA0sU8xSj8fSAJGLIVuM=;
  b=QCDVDSHZWk1hm1ThxLnoOUA3sNNZxiqAw1FtKqxoiYunrTMxoRh+yxjk
   AuV79zKWzBRYem8ds+bkyPujf9WGU0KiqwKfZ413qlpoWl4uDFWeykss8
   e5b5BSAdJ2ugzYxHCS4EoyDzvPGndM2J/gv4JxSBxhOoKDSt+EPB9ZHd1
   dTG5ccDQOwRa3+fQlI3OPScOF8Xo5NUr5Bx4TYOfRYbNU1yqujYrR9lpF
   LEoZiVKE9cmAg5csVqfK9zW0bvler0FMUjGa/Tuv9xdH7LBJ9rZo1subc
   DEJbOgMPYETmCXzPypqMpi6MhMgsOuqiUC2n7XQqySVqKeRxS9YIXEFE0
   w==;
X-CSE-ConnectionGUID: psVz6b+nTjKhSbyi97VdKQ==
X-CSE-MsgGUID: XIdnhrFnRCm5mjS8hRyyww==
X-IronPort-AV: E=Sophos;i="6.25,248,1779120000"; 
   d="scan'208";a="153481409"
Received: from mail-southcentralusazon11013069.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.69])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Aug 2026 13:26:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sZBj7KI+35y4r9IYM5ozjgVH552zIIUNiL7gKUEV/MkXtwDLbfkuD7p8GeWJEuZ9PhBN2JLPh71RDhM/zczjmQ91dFs33qkBezp2YOEjXodRCqznAFq+C0k4yJxGIC4B84Ag47+PVbZk9Hy/wlI2kb0pgBCNblohihyzNFmmzaq8ZpVwK5PJFnPVCE+Y6BDJPUohltBAu6ioWbI8z6FK4nMZrhB2Fb+ep12sjH5vWBfLvlpaJrTLXQwQOLDVGSO8BmnuZ7r/G0yans9MRWlV/NfEjx5gdVqaYBtnKPTKVeKJNiN9BT2DrNQVsX4f8+WDyXJLZlPjXVkhqGk8JhKYSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yR4/Y3ccse9z8A51kduEq1WbXKkY1reiKFuf3wAsXUA=;
 b=qrxgLvAgCBgslAB2yndIz/62fiPG8Ty2kzvlj/yt/XHYC4GBvmX/vqdMMnJ0f3Wiaj/+IfviYhgIBRJnoPZI/iX7q0gVu50RsP97J8uqQBS/8DQ3OsWFMzuGIChLXYhICKeMao1yPYrMN6S1SasUuCOrCTY07KKk5n/juWG2Y5inH3drCovdLJKqpNJ+oTsHS/TibWFm1pt1bLlBGZYwtmbSASGZFeRJ0XRbcQ60kC2xqwhRHXmIoTqMCvmxylF6IaSwEBGNN0baNqLl6mW5TBeB7zCpbHnmPZmdP9tI/AuoDgM+i5rTBSWjqPObwnl3YJ7iYd27UXB3oltESwvC5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yR4/Y3ccse9z8A51kduEq1WbXKkY1reiKFuf3wAsXUA=;
 b=l/J3931gbWPWiYJhcCMQ7wrthogn3Czg0pNsUjihCxpkKUNQmH6LXjlORWYIS8IduUNAsQsOLo2sEi/bzHfTAVuTO17OcPaKOWRJHQEDmY+lwOfHuTJ+3hWyey9/YbYAItBMjVWQZjk61ynpH3C5iCIwQpg8BBWukauzxZDnQ2M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV3PR04MB9258.namprd04.prod.outlook.com (2603:10b6:408:26a::17)
 by LV3PR04MB9152.namprd04.prod.outlook.com (2603:10b6:408:27a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Fri, 28 Aug
 2026 05:26:50 +0000
Received: from LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2]) by LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2%4]) with mapi id 15.21.0360.008; Fri, 28 Aug 2026
 05:26:49 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 28 Aug 2026 14:26:45 +0900
Message-Id: <DL0BTAQXFKLH.HG7IL0GTHTK0@wdc.com>
Subject: Re: [PATCH v3 1/4] btrfs: zoned: track only sequential zones as
 active
Cc: <johannes.thumshirn@wdc.com>, <naohiro.aota@wdc.com>
From: "Naohiro Aota" <Naohiro.Aota@wdc.com>
To: "Dongjiang Zhu" <zhudongjiang@fygo.io>, <linux-btrfs@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <cover.1787887776.git.zhudongjiang@fygo.io>
 <42a6a9e084182733b61a9d3dd66ad791aee71aaa.1787887776.git.zhudongjiang@fygo.io>
In-Reply-To: <42a6a9e084182733b61a9d3dd66ad791aee71aaa.1787887776.git.zhudongjiang@fygo.io>
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
X-MS-TrafficTypeDiagnostic: LV3PR04MB9258:EE_|LV3PR04MB9152:EE_
X-MS-Office365-Filtering-Correlation-Id: fce08657-e0d8-498e-d90e-08df04c4f594
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|366016|10070799003|23010399003|1800799024|376014|10067099003|22082099003|18002099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	1N5d/Dy8renBsoH4kvOz4RnzmH8KNZQj0Csyy5OrVHJLK99cTm3T3UckQy8cViAapz/+o7PqFpVvQUGGK8fy79fYPWR1a/i1UJisnU+sGU83dWG+SLJolGhfIMdR6r514HI0CbU99YsBZ5awuwnlWMql1Km7erzLclUgNQg8x5/x7aPRp9Ph+IDqBPkzLpsgij83ubq8/ZKF/stj9UZb6AFVuhHCwxTbdk9DEolasQf6v+qpX9f9ZnZC94lJjoLdtwiQT1YdUs0nasMX1/7gciYH1VkhF/5iw1UYjOrsFlEOEu0SfauoBnK6yUitYJCdhKQsfrmkuDX4TZE0fadZ2dJj3mvKtE4mWTUEYThTUPQ8PR4ihwGsqg4mG63r+qhdW9C7md6J3tQToVxb8rpvBONfglPctn+rcAvtEJncFFqJGe1rEKJporbX4p5Mp7pfbElJKwKPVNMXrqGJriv226mnjl91V9jrKHAbsovLD4KoeGGt0PANAIL4ylxADlXsCk2gOf0pPdTDD8VH2/1r79VOU0edojRiz2ODf8f6xQHJDHJL5sN1hEisSraKPicRlBgkiesWNnM3dVttalE4E2wSGVmzhObJCl/B3mRJI1u/vFjxIGo3tQXGyjzsXCheRsk+d5J+ApqRofhey/8QlZd/GPZB8zfj2+dkPed5jDQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR04MB9258.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(10070799003)(23010399003)(1800799024)(376014)(10067099003)(22082099003)(18002099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aGk0R29Zei9xOEw0OUUvVXVqTVJYdi9uR0pRdVZaU2Q3Vkx0UmppN2NEWjND?=
 =?utf-8?B?eVBKVTRjWisxMUpIQndZSDBkVklJRXNUcHYxU3BqUTZTUmNORmR1YkVxTVF3?=
 =?utf-8?B?NUFIQnEza2ZiRGhFcUNIOUZ5NmlvRDhhbjM5eUhsclhsTko0aUJDSEF2YW5O?=
 =?utf-8?B?OHNHd20wMGx1aVZMaFhPZklNUWo2Nm9Ca1ZMS040OEN2MDRSeEwranVQVDJV?=
 =?utf-8?B?ZzIvVVRsZzB1UnYzdmpaZ0lxQmk5RVZrL1RvaEJycjRYcDVLVkdjYVdaekNI?=
 =?utf-8?B?M3FiSjE0bVVVR1FWUytMTW5BSlNRVTRRbEJySHMvMHYzMmVIR21reVl0Mkc3?=
 =?utf-8?B?VlBpSlJ2RTU0aEtXMlFITUhZYndBdTJRb2Y5elkrUExtVlNKZjR4TnJmU2VH?=
 =?utf-8?B?cU9OWjBVbDVScHNEd3dZeWdXcVRpZEMwNThrSU1JUWVrd3QrYXl0bCtjL2dB?=
 =?utf-8?B?dkVYWDJ6MUw5cEFYS0xReE1hOXhlTDFpdUtvRnBRR0VBeS9kUGNrYVJUdzRh?=
 =?utf-8?B?ZjYzWVFPOVNOVFpBNFF2ZThrVytVbzJrb1IzNVZHRmFhanpubEdIa2t5OGpw?=
 =?utf-8?B?eHZDWTJ2VXFJSjB4Q1YwQWZTZTV4SDQvWXc4U3dTeVJWQTYvQ01SU0JlZTRZ?=
 =?utf-8?B?QXBrd1dFUmZHeUJDKzJ3TWw3NVRmSTRISlBLcGF6TFh2NGdEM3gyNGNNWlQ5?=
 =?utf-8?B?d21EdGNJU1JpQ3JFcVhLaVBzTEhjaGFRWEM0MTRCc1JYTENDV3U4NDVLZzFC?=
 =?utf-8?B?T0RiRXdUREpqbERsbXhmc1NJbVJNYnV1QlVMb2hRemFPMHQwcDkrdys1NCtq?=
 =?utf-8?B?cC9KdTNFQjU4N0IvQlJFUkhITHlOenRpVVRVYmlXbU45Q1RVYWZZOXpXM1lY?=
 =?utf-8?B?MzVWUEVRUTlhRjVtSk5NWVBoM1ZLUjJIZ3ZQUC9yTWJqUUQ2Ti91MGhqR2ls?=
 =?utf-8?B?L01IV1h0RjBKMlJFUG9MUzlKTDAwM3g4N082clI5am5ud1AvdTJHS01GbjJm?=
 =?utf-8?B?a21lbHoraldTREtoS0p6TVRzZFN6dnV0UC9laitWWWFQZFB3VmwxSEVrY2F3?=
 =?utf-8?B?SmUxeTQwN2NXQzFoRlJyckRpQnNrdUlDRlNlSXA1VHFNVW9BU0xRcENrc3lw?=
 =?utf-8?B?ZjVITEFmVC9SNEFQUHl5b1d2VnFwemE3c2xWRlZvaTZ1MFNhbmNmdWtuc0FJ?=
 =?utf-8?B?aTRFeHpmejJRMm51TjBpdWo0THh0UmRsM1g2UjY0RWJ6WFljbnNPdnQzY3pa?=
 =?utf-8?B?b2VnRW1aOVBWaFpaT2F5dTB4WmtiWFFUWlhkN2xHWTdvVlppR2wvYzd6RnBz?=
 =?utf-8?B?TmJwQ2lWbEJhcmFRUHFhTmxOVTVCN0pvYjArUkx3dkNQREgxeGZpeGlvQzZ2?=
 =?utf-8?B?MU9vVFhia1NxZTlhYXllZ1lTcnR2cmRGYzE5T2kzYUZ5NndMcThHTDh5Mjh0?=
 =?utf-8?B?YUxLMDBDMWVLWlZlUmpJZzd3NUoxZzBPZGVPTGN6MlFiM0pPV0ZGSk9INXli?=
 =?utf-8?B?YTd5Zit4N2krd3VQb2NuS2wvcHV3K0Z6ZDlqSVFiMWlUbU9PckdpTzN3dTFL?=
 =?utf-8?B?Yi9RUy8rTmlTUFE3Z0g4RTFCa3A5SVNJUVEraUtxM29vYXlKNGNCRjZzV2to?=
 =?utf-8?B?S1A4c3dXSXdoVXg4TFo2bmw1YlEyRTU4L1pmTlRiWlZWN0Jqek5ZdjN1aWw5?=
 =?utf-8?B?c1A5Y0hZY3NXaEpDRFVxOEVsd2ovK01BaUJlSlk2cVRFelJHU21udVBLelR6?=
 =?utf-8?B?RHlNT2ltRm5EOWtkUElYWEg4R0VDdVJ3cWJ0N09NYmZjRnNpV29rQzJYM2tp?=
 =?utf-8?B?TmZJRXRIUENkQXlYNlNkNkNHVTFZWnBVYmgyLzZraCtjNWZmZk5oODhHNHJS?=
 =?utf-8?B?VTAwU2dsU21mT1FoRExJWWVSQWFyY2RCR1lCV0FKVE8waE1Lamo5NjNtMGZS?=
 =?utf-8?B?YSt6UmdoOHh4YXF5YUlyYWdCWUlRYktuNVRtTEpZcVRxVW9MNzYvRzZseXFo?=
 =?utf-8?B?MWZVTGUzWEQxUmtQMndyWExRUmllMzhhbUVLd245ajdDa0dOcG9ubUpuSU1k?=
 =?utf-8?B?NU44SUNWUnRVeGRoR1VVaVRsZU5Ra2w2NzRQWDVpRnZCMTFocjFKY2FlRk94?=
 =?utf-8?B?TW44OG90NXIvbTBZczRINmxKR2lxTHVsQVQ5dmRxZFlad2FZMHE3c2NrOThk?=
 =?utf-8?B?QnFlN2l3ZUFRNVNaMVBTcnU1ajFueVJ2YUtEMGJ5TzA0QWNvM0EzMHFBNlhN?=
 =?utf-8?B?M29lS1owa2x0TVlUSkVnSFd6dXVTTk41QUplbUROVFYvR05Obk1uZzBRMVB6?=
 =?utf-8?B?blEzbk10Tkx6a2Qwb0dXSEtlMk00SmtRc0RiZnJSRnNNNFhFL0s2cEdsSEJs?=
 =?utf-8?Q?AvqnOgx/Y374TJ7aiou1aPPs4V8escOgLG87EtRvQ+nnc?=
X-MS-Exchange-AntiSpam-MessageData-1: 5fyxrezJ8hSdBA==
X-Exchange-RoutingPolicyChecked:
	0XcS1sonMA0m6snnolCh6HYzl/BzmtQEOXuDnb9hnU/dPos+SG9aIivrujJnbA1jjThAGyDA2cZCk65XVO4nlOLk/FRmWCs9a2tRJuyW2xH6I9/eYKXJoTs6NvmBTf1twgLzHpoEsSV51XycVdGZIUq5cJzZguFM4TzRSMB9QUbQ5QXgyp3AnkAMgCuutBfGcrDNYF+JEsAOonD7uU5R95mm4zl3yqq9xCL0VbV5NaeAhqo6a9KUK9V9Mqf+MLCdL0QLfhJ2Ibah7P+ys2ZkVx6e/Ljfhhkuq+EZ313cwdTP/X3JymUp7ivyYL5kMHfErTRMbP5gZ3scBajzmUFZZA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZyVe+ZRHWDAdQtu1twqHgguhjeuirvNjQVE9T5d6fkttpPlSwKTur84ufiUUt+AVnowJYyOPMLWaGpq2itPorWW1e6K6N05mI8h5+4wDc1I4BSm66yF4WBzBW81fT9JwCfBLRycWcsgoFZxdXZTDUYRUEKeQAwE2hjz7aOErAsiSwen64U+KHmEemMO7ryhaDz8z20pjBWpjeya57OJXgx9Swiu7muqihqmifU7Ya5txSOyXNETk/DmqWQvWegiXRkuRmAGmJjcvI5eXVmfOIjbJ2vEzZWRmCbnEQsmlhkkd4hmRg/c5d/Uo41PcKJdDrsc7CZNiWwkh9RQzMAMLdDAsiJ3AyKAsKxifdpVR63IoAJSUvYGPZps/hFLQk0CfYv3FLe+Nre/QjIsC7xLhJDFvotSviWqbKm5icsJBVlwWf5RERTptr6Bm0BjPNDJmU41iN3rK7yj5x0vA7Rd0dQvlcOLwcj8Qa3RCI/1XAm3B3fSvio3Wxk994d5mf/Q0qVFL1CKROn7zDGRMOJPKSZbpDvRLWdsT2o9//3RPAwHsD9y7JtR850zbiU8X2UeKz9BSi6lmPXvzHQdzNuY+eTKMD8OxMsaA7dtzBJB/1V8rKKUE5ozCtffGcvMKyKum
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fce08657-e0d8-498e-d90e-08df04c4f594
X-MS-Exchange-CrossTenant-AuthSource: LV3PR04MB9258.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2026 05:26:49.0964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jd2q4/l+sGXLnodY48mPIrZ+s3U/WqQeJbLSa6fagxsb5Dq3nfVY1UK+YWaeTucq2j0Qpn0SutFY8xzyZ3IJdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9152

On Fri Aug 28, 2026 at 12:51 PM JST, Dongjiang Zhu wrote:
> The runtime activation and finish paths apply active-zone accounting to
> both conventional and sequential stripes.
>
> At mount, however, active_zones_left is rebuilt from device zone
> conditions.  Conventional zones report NOT_WP and are therefore not
> included.  Meanwhile, all-conventional block groups are marked active
> and added to zone_active_bgs, so mount recovery still decreases
> reserved_active_zones for their metadata and system stripes.
>
> The two counters can therefore diverge across a remount.
>
> Each unmatched reservation decrement lets data consume one more
> sequential active-zone slot.  Once the reservation becomes negative,
> data can exhaust all such slots.
>
> A later transition from a conventional metadata or system target to a
> sequential one can then fail, because finishing the conventional target
> does not release a sequential active-zone slot.
>
> If this happens during synchronous transaction writeback,
> btrfs_check_meta_write_pointer() returns -EAGAIN.  The transaction is
> then aborted and the filesystem is forced read-only.
>
> The reservation mismatch was reproduced by creating small files with
> large xattrs in batches, syncing them and remounting an HC620 filesystem
> using SINGLE profiles:
>
>   active_zones_left:     126
>   reserved_active_zones: 3 -> -8
>
> The active list contained one partially used conventional system block
> group, nine full conventional metadata block groups and one partially
> used conventional metadata block group.
>
> To keep both counters based on the same physical resource, use
> sequential stripes as the unit of active-zone tracking.  Accordingly, do
> not mark all-conventional block groups active, and update the active-zone
> bitmap and non-data reservation only for sequential stripes during
> activation, finish and mount recovery.
>
> Assisted-by: LLM
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Dongjiang Zhu <zhudongjiang@fygo.io>
> ---
>  fs/btrfs/zoned.c | 59 ++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 42 insertions(+), 17 deletions(-)

I'm sorry to miss this version, but the same comment applies on this
version too.

https://lore.kernel.org/linux-btrfs/DL0AVDP5O9C2.1VT2TYQXCL4B4@wdc.com/
