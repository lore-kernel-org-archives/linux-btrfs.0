Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11023135.outbound.protection.outlook.com [40.107.159.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0682FBDE0
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Apr 2026 06:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.135
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775196862; cv=fail; b=EACu3J+or3KWXa8BTuji3xJF/WSvxk87889/aFu5zSbuJA0xVSmuPavH6Bffe6qrvScixOWJPTVVajqNzNP0zY+FV3jy1zm0kMTAlb5t4cOVHIBa8CxNbRy0XSr0oIyDwudzFR4kzriz2PXRTpkCk8R3wbaWyJjb2ruwqYHnPEM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775196862; c=relaxed/simple;
	bh=tm/6C12sHTfXQV/ejLWxLFqLrXw0Z2536Z/9ciDaYJE=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Rbr7Mdn6Ch+UodU+bVVsafTei3RcFr5Yrdw9Z0toaDFX9NuKg5xOB9PPbcQcTLTp7ZCzsCeHYu+++3CVko1QY7iFX9qwqp6x7uQa0rHPCQadBRP5M3bIQKxV2UkQarmbI+2Y+fDmqquhD1jeorXXa8oV/B4tLY5qWomkf8o6DP8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cyber64.com; spf=pass smtp.mailfrom=cyber64.com; dkim=pass (2048-bit key) header.d=cyber64.com header.i=@cyber64.com header.b=MA3X05Tz; arc=fail smtp.client-ip=40.107.159.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cyber64.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyber64.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cyber64.com header.i=@cyber64.com header.b="MA3X05Tz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UI7ljJTbJhWyDTgaADNe2CESGhheDnSEhgf1tjdbg7Bycb25R5xIgpuLVgecqWVgoufl2oyHm7MfVaGvLIC8N0B9eH/X0T22ItGLKfV+IWkAE8q7z4YDqC0Zk6VKK1FboPbQQzODzUqnouCcgf9uFU6EpIDHC56o7tj/jAInH7uOXjgNWBs100ARnc65j2/LvOq0ZeQdshNtMYlqTvKlSw6v4nIqZoo2exejxeWOS8r37fuUWu8ReyNjidSeaLPnZwB1KI4QPx6CCNYYQqan6KAXI83xkDHZY5aNkS7RZJePfnPmDqAS2VkdVr4oj7c+JJsKbAs6+JxNzvbo4snwXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tm/6C12sHTfXQV/ejLWxLFqLrXw0Z2536Z/9ciDaYJE=;
 b=NGmLIAjhUBBohV4MZDFyZKzWeZ5iV0dOuGakEyLjb6AnHxtgtMb6Syit42UEnXIB3CmvZYClH7yd26onKf0y2iuQnY05bjEtas8m5VMH94tuL6MfNWm0DJJ92m3UdutXQPP+8WFQj9iJjoUIWTIQlY+E796zNnNqzUVabtav/jRFaaVePuBU2gq/buu/DpC5xqfTPwQzew6TaNBUpxgZ31ujuhFsUV05Jv0JmyjlMlLNIK3vQ1hJPEjC78bN3PQejgeKIyPEf0BzC3S64eTmywi4dx2839/B3ujcg/fO37nDHJLWIE/QsiUHGpPZsqEPaeOXkHwBvdYVr8SEQguwRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cyber64.com; dmarc=pass action=none header.from=cyber64.com;
 dkim=pass header.d=cyber64.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyber64.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tm/6C12sHTfXQV/ejLWxLFqLrXw0Z2536Z/9ciDaYJE=;
 b=MA3X05Tzi1brWYFHAHST4l0qG3uCAABCpfbaDT+779erUURDUBuawL9V8g05ueF80ZqWzZkbra+8bM4iarJWgRqh9JjB/3OH+cDU9A+mew/zeYWICORXHSTcfL1hEXqwua4Ym2y5dtnuzVSIKwl76p6qWpgE8LQEEz7m703n5UOKt5mN1kE2LYvQxYXxTz585OuH6ZMBCmDW2J6i8luk4qF9sp+sGueuFJ+wxMVpf7utXbCnR5bY8dmhOUzaYoC1JZjPjEUq8Mlg3PKWRekss1C1Kky2ursyIq7JMwTiBO4+kdFMNq1Ud7yVilaFnRJvrSWLpei4Gb1t6VYFEbEcpg==
Received: from AS2PR10MB7659.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:643::14)
 by AS1PR10MB5168.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:4aa::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Fri, 3 Apr
 2026 06:14:12 +0000
Received: from AS2PR10MB7659.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::ddd1:c316:c6ae:9986]) by AS2PR10MB7659.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::ddd1:c316:c6ae:9986%6]) with mapi id 15.20.9769.020; Fri, 3 Apr 2026
 06:14:12 +0000
From: =?Windows-1252?Q?Kristijan_Ve=9Aligaj?= <kristijan.vesligaj@cyber64.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Asking for help regarding data recovery
Thread-Topic: Asking for help regarding data recovery
Thread-Index: AQHcwzEXpRObbf+awU+sKbRLdesVyQ==
Date: Fri, 3 Apr 2026 06:14:12 +0000
Message-ID: <82FA2B24-4A3E-4880-B91C-417D4ED9D0D1@cyber64.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cyber64.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS2PR10MB7659:EE_|AS1PR10MB5168:EE_
x-ms-office365-filtering-correlation-id: d8fe6c13-955a-4625-80b0-08de91483994
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|18002099003|56012099003;
x-microsoft-antispam-message-info:
 EvwLp7sTca66eLIElB2KNrvnHbCkHj4ADADSnQJfvj1FPwAwwmK4zT4odiGBRbijgMC1kqsVfo/dWoA/YMHU81KRDJubGhSk5yle5yhNgkYi3plU8FDUc52xJWM9L7aDnXhDPzOHU7ZPFcfashKPis+/usd2jd7JZrpUxnkzTKjALZl/9HFGFaBHfYm2oAcetwI7ebfpXLwCe0qRkRYtdVEWs2SucR0ZZCm1JoQOY9c+figKnZa2SIkqDsJYUXOaHdPi8S+XspMM2O+UhIEm/ZLhZTCYE/70UTZ/xo3j2znfRSMs6K+c6NPbR4Dsh0X99iWS2sXOzgMDIO0tNpdWsgheH77bbzvT9xjuu2GrnIoCsIrm13laCa/rsYd/xQvF4qn8orNWQE1gMhqiM8WK+H1xrbZSZrKOzCJcLKLncfpWco/pENLJtYWpx/ZBULH9RUnPS60aE/DOsv8Iw69SUKnoBEkswdj+lyM9qfaBpGBB0D+qJkps9UkcfMmhTIGYOPtfnyt81eBk9yPcyFnjo2SnQdYxQMnfakWTteLDJwgzvt/CmfCHyBBHGj2vfDm03RMbB5iGK+HlGCBlOeL9dHI7GTLYaLLkDAqPpc9PNQ8k6X6EaNhfDOGQxII3AIAvwCyt4rZroGhG1c4j7ACO0TSWrcrI2CDVM0EMYEjsjmxuIyHcYnrji6ujTQGrUuo2wG95U6KIOBxdhzDOE8OcpyJaPRmNeaLO06WvJ9piAT9TP9LGdTPijHq2FP8GffIKjHbm6398ihFEa7mCcZLIndJSG8iWb5FL5AUveL9ZcCE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS2PR10MB7659.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(18002099003)(56012099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?Windows-1252?Q?bdyWVb6fqmTrw90GccAKaYiDPZ2a7cBQhz0z/Ef4DAr2+fxaSR3bj1/h?=
 =?Windows-1252?Q?O5Rsnmf25dD69npMvcgLa1wp83nhhJeXHLadI1ZHFB+af6lGNLrzoKx7?=
 =?Windows-1252?Q?KN1BMDPBThaxGck+eVY4EzbirTLMhy/SSavER+oXw60lBon+AqJlRk6S?=
 =?Windows-1252?Q?gSsO2blk5cFKCy8mmT3xYt6ZguuGt0fdzCvWRVwM/smRpnXnc4kNgjz+?=
 =?Windows-1252?Q?2JcZDVvHkGfsnT4kaclltJDsarzDbdHfcKbabCL6FxQqFFRQlnSTaV3W?=
 =?Windows-1252?Q?52/L/rdSCgwqtT3uQxSGLHUHuq6m5zxdHHQkwFvFNrOhSaTUuKs2KtRZ?=
 =?Windows-1252?Q?QQ93gWwi9rShl05M1Gk41f/wBsRqnd8ShJf76Wvbkf/9I2fs62DV1wuf?=
 =?Windows-1252?Q?35wXKnXTmAlI4doyq/jpFhcGn3RUSmmNFLdBS8wjlJSCYmLnHvXUGZHO?=
 =?Windows-1252?Q?xW92ebSbhajdpofdj2ZhkbmHI/znkzopRE/+CdYEjTWrRt5uteWQocuL?=
 =?Windows-1252?Q?jplE5jSZlIj+4SnaXT3IhIDd14e/Aq8O+Uzoirvg8DltOpiK1U49y7Di?=
 =?Windows-1252?Q?Q9SnwhVHxnhzw/V/w9MjrDYM1dPbcUoypcVn0kurg7wCA0YxmN5G+QE4?=
 =?Windows-1252?Q?pKOI4BuYuEBkWNV16zo5RgYlaLuNJP/5PrZxE4p48CLKdkiu3pulWQKX?=
 =?Windows-1252?Q?UxSL4I8/HEuvDLyl8K6fRo2CxKTKICUJcGnV69kbi78H8CgzBwWQRPnR?=
 =?Windows-1252?Q?DiWzCWmlfyQo9iDKahJSio3v6Z0FnF1wYihJP8LKsy7yIwwpklpYUfxr?=
 =?Windows-1252?Q?6O13pSJOnRCoB+2X9rbda6Pw2ZZCDHx47uORIOONGROpgvpWCpjkqcmf?=
 =?Windows-1252?Q?qGgn9sXiMyjQXyCOUMOxOb3e90H4g6Wbgk+Q1rJX+6NncpJAVmFxH4Q1?=
 =?Windows-1252?Q?Stlc4zVjAzk8FSKWwLZ1e6aWO7Imq40/FeET69yzxR01nfPIKtPnFo35?=
 =?Windows-1252?Q?ny9wMx/w69usoa/Wro+AsHPZHU9QClpSvpTsHRCTV128oBRW4PlqANhW?=
 =?Windows-1252?Q?ABD6L4rDr5wngeCCwPA84I0jDbK6QXBuraw6N1HFbJkJIJxxfYphIEQD?=
 =?Windows-1252?Q?CVMPxJm1zor8pJ5Gvyw06+OHdvxkL0jqqI95H/fIv1efqhPhNYGonocK?=
 =?Windows-1252?Q?VbhCGFC/zG8a5jpsFPf1VVa1a7Vqbg2jXZ7ICDaifNjGa2WD4nzGfJDg?=
 =?Windows-1252?Q?GQ/F7ktHr+ZHK0fxpSkI9g2ENYsJ81C4gbEVWB86W0pKhI74+bc9I0Y9?=
 =?Windows-1252?Q?dQTyAAnyztwNKsUsBn1xfJtrZ+grNSbDwnKeQpW1U3zsKOp2THzZ6Xyk?=
 =?Windows-1252?Q?p10Gezf4T5x5s2vUpC+hap4V/r7V3yPTRVtJ5OAwMpOu+Qlkbm3i8+mx?=
 =?Windows-1252?Q?aLWbFeDK8O6sKIMGmikTzEICmG6ZT0Juilt047xYToSVd0EePEn/WpAn?=
 =?Windows-1252?Q?8Q29l9+jZgiBHzJUP3NiJj87kiN4T0uVKSNTWu6n1SIY88u9vsksCqi7?=
 =?Windows-1252?Q?lgwzBc9bSGsGwqRncqs240xgiZOdFn05i0DwUwRQJQppdXLXXaiYcwmr?=
 =?Windows-1252?Q?lTp2BxO31yYBF+87ua3tRbZ5GEFN/F5++KTMPr8vlLxlwEKT+vbgDjDh?=
 =?Windows-1252?Q?RqLojb2Y0zZHkz8DMhDP/Y/aRi2ouT12934lQH3tCwXZuEKY1Xw2GmID?=
 =?Windows-1252?Q?FoqrxVY7QjBlpnBic9QWPjU8oloM9vzWpm79rU03fcha0r5K6R+v2YwY?=
 =?Windows-1252?Q?lBAfm/OROx3tGQEorIGeNHgooZaP9oRT/1ejdKOi+bc6lzVyAROg4VYk?=
 =?Windows-1252?Q?mTo23H9DWGgcNxLPUkC2EeV9/oY5PjCimKI=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <F7BC2DC1B5BDB8488A23D3A83B55E01B@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: cyber64.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS2PR10MB7659.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: d8fe6c13-955a-4625-80b0-08de91483994
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2026 06:14:12.2607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6a85943c-df24-4bf2-b00c-809c034a3197
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7bLumD/a+GqWi41Z6sTV2vatBb5KwD2uvb9Igsr7gxZfojveFCVtn10QpUI+U6yZ4ZsfYn3GWk2SjUxeQLSZYp4TqkPfJQ/IGhUhj4ZcwFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR10MB5168

Hello!
Our company is using Proxmox Virtual Environment for internal tools & servi=
ces.
Today I accidentally restored our main VM containing various business-valua=
ble services and data to a snapshot that is ~4months old.

Summary
Our company is using Proxmox Virtual Environment as a hypervisor for VMs th=
at contain our internal tools & services.
Today I accidentally restored our main VM containing various business-valua=
ble services and data to a snapshot that is ~4months old.
It was a "fat finger error" - I was trigger-happy with the restore function=
ality and misclicked it with the wrong VM selected - the old VM instead of =
the newly-provisioned VM. It happened during 1on1 session while onboarding =
a new colleague and demonstrating how to provision the VMs.
The backups were temporarily disabled since we didn't yet set up any kind o=
f external network storage nor Proxmox Backup Server (PBS) instance, so the=
 reasoning is not to bother with scheduled backups, since the 3-2-1 rule wo=
uldn't be satisfied anyways (no off-site storage available).
Moreover, snapshots were only created on a manual discretionary basis befor=
e major intrusive actions on VMs.
Once we realized the mistake, we turned off the physical server relatively =
quickly and booted to LiveCD environment.

Setup
On few of our PVE nodes (that are, ofc, physical servers) we have the follo=
wing setup:
* 2 identical NVMe SSD disks (1TB each) per physical server
* partioned via GPT
* dedicated root partition per disk with FDE set up (using LUKS)
* Btrfs RAID1 set up that uses 2 mentioned LUKS devices
* Debian installed on top of the assembled Btrfs RAID1 filesystem
* PVE installed in accordance with their guide

Context
With this setup, it is possible to enable Btrfs storage type in Proxmox, wh=
ich relies on Btrfs-native features for creating instant VM snapshots, back=
ups etc.
What is interesting is that this way, behind the scenes, PVE relies on Btrf=
s subvolumes & subvolume snapshots to allow for an instant "zero-cost" snap=
shotting.
For example, if you create a VM, it stores its disk in a raw format, but wi=
th sparse attribute support enabled (e.g. think of "thin-provisioned" virtu=
al disk). This results in the following Btrfs subvolume to be created:
`/var/lib/vz/images/<vm-id>/vm-<id>-disk-<num>` 1
And conversely, its associated disk file:
`/var/lib/vz/images/<vm-id>/vm-<id>-disk-<num>/disk.raw`
Moreover, if you create a snapshot of a VM, it relies on the following subv=
olume(s) to be created:
`/var/lib/vz/images/<vm-id>/vm-<id>-disk-<num>@<snap>` 2
The disk file is then stored in the same fashion:
`/var/lib/vz/images/<vm-id>/vm-<id>-disk-<num>@<snap>`
To my understanding, what happens on a VM snapshot restore, in terms of und=
erlying Btrfs storage implementation logic, and relevant Btrfs subvolumes l=
ogic is that the former 1 is deleted and a new Btrfs subvolume (`R/W` Btrfs=
 subvolume snapshot to be precise) is created from the latter 2.

The Problem
Due to the implications and potential damages of the actions, it is very cr=
itical for us to restore the aforementioned VM's disk file and this assumes=
 locating the deleted Btrfs subvolume and recovering it.
However, the typical `btrfs restore` approach assumes naively locating all =
of the latest dangling / unreferenced root nodes that are not yet overwritt=
en via `btrfs-find-root`, figuring out their generation number, and hoping =
that the generation number of the state at which the deletion happened is s=
ame or newer than the oldest root node generation number available.
We have yet to confirm that this is the case, but at first it seems as if t=
he oldest available generation number is newer than the generation number o=
f the last presence of the critical Btrfs subvolume of interest.
What is important to note is that the machine in question was powered off b=
riefly ~25min after the incident and that the Btrfs filesystem in question =
has the default commit time of 30 seconds.
In the upcoming edit, we will post more details regarding the low-level app=
roach we are trying that involves assembling the child trees of Btrfs subvo=
lume by locating its own fs tree root, since the top-level / root tree root=
 might not its reference anymore.

But regardless of this, are there any go-to approaches for recovering the d=
eleted Btrfs subvolumes? Any tips? Are we heading in the right direction?
Any help is much appreciated!

BR,
Kristijan=
