Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA6DC169C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 21:12:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43FF720881
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 21:12:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="RPL0/nwQ";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="RI726lk2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbfA2VMi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 16:12:38 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53118 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727488AbfA2VMi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 16:12:38 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x0TLBG9G025576;
        Tue, 29 Jan 2019 13:12:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=NvwcP7TdZSXzkC4gRHwV8X4W1fGq6IDrqTFjKRmkDTo=;
 b=RPL0/nwQNttb6kqnUhAzEpf+7Qh84s+0tNDPZWz6bJ39ENmjVFzPcvuG1s74mBprBcwa
 FlNk4ZJYfjrZ8D6o64N6y43xVE7SpxXYtAyta8HEYNquPMv+iHCB6nQx0v7NdLFseQGp
 UcZCGJKVHHJFvrZtssaN7ito+9VSCrt28Jc= 
Received: from maileast.thefacebook.com ([199.201.65.23])
        by m0089730.ppops.net with ESMTP id 2qavg00exp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Jan 2019 13:12:26 -0800
Received: from frc-hub02.TheFacebook.com (2620:10d:c021:18::172) by
 frc-hub03.TheFacebook.com (2620:10d:c021:18::173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1531.3; Tue, 29 Jan 2019 13:12:24 -0800
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (192.168.183.28)
 by o365-in.thefacebook.com (192.168.177.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1531.3
 via Frontend Transport; Tue, 29 Jan 2019 13:12:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NvwcP7TdZSXzkC4gRHwV8X4W1fGq6IDrqTFjKRmkDTo=;
 b=RI726lk2aR5nbln5f3MV6sUTxIwiAnfVjxyIs6Oi63X7dm01bMebtzRTuK9Sdm62x1N2HJq/qC4g88Ij7KUWD4zbekNg2AAh1qZSQ8NT5NnU8oy3btOJxjrnPbG+AN8Bsp4ezYRWRPZvKUz3ncN0/7DkkcdxlHSQgXhY/IasrmE=
Received: from MW2PR1501MB1993.namprd15.prod.outlook.com (52.132.149.157) by
 MW2SPR01MB0009.namprd15.prod.outlook.com (52.132.185.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.16; Tue, 29 Jan 2019 21:12:23 +0000
Received: from MW2PR1501MB1993.namprd15.prod.outlook.com
 ([fe80::65d7:840e:9b19:747d]) by MW2PR1501MB1993.namprd15.prod.outlook.com
 ([fe80::65d7:840e:9b19:747d%5]) with mapi id 15.20.1558.023; Tue, 29 Jan 2019
 21:12:23 +0000
From:   Nick Terrell <terrelln@fb.com>
To:     David Sterba <dsterba@suse.cz>
CC:     Dennis Zhou <dennis@kernel.org>, David Sterba <dsterba@suse.com>,
        "Josef Bacik" <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] btrfs: add zstd compression level support
Thread-Topic: [PATCH 00/11] btrfs: add zstd compression level support
Thread-Index: AQHUt0/0+Y4AP8N6sEuUaQngOd1KuaXGfq8AgABBVoA=
Date:   Tue, 29 Jan 2019 21:12:22 +0000
Message-ID: <0C87F2F4-43E6-482E-9A44-0151DE312AD7@fb.com>
References: <20190128212437.11597-1-dennis@kernel.org>
 <20190129171830.GP2900@twin.jikos.cz>
In-Reply-To: <20190129171830.GP2900@twin.jikos.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::5:e138]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MW2SPR01MB0009;20:DnZwvECOxM6GTdLuojvdUzT9DJFVogMd3jI/RT5s36epfLPsYZNssdCFWbjb+cAezFHGu59Lsfvo1VSFkIZ3eDMBa8jmy4zdd0ZVooLq4uyKnkoZB9sSWELGzCL2d6JHongyzoEVF3JELZ++X72KvAn98jjs+I2KTTc2SGL0PjE=
x-ms-office365-filtering-correlation-id: 06d2aa86-a2c6-46be-aa34-08d6862e764e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:MW2SPR01MB0009;
x-ms-traffictypediagnostic: MW2SPR01MB0009:
x-microsoft-antispam-prvs: <MW2SPR01MB0009BC22F10A202F72AA3F15AB970@MW2SPR01MB0009.namprd15.prod.outlook.com>
x-forefront-prvs: 093290AD39
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(136003)(396003)(39860400002)(366004)(199004)(189003)(53546011)(83716004)(6916009)(6506007)(71190400001)(71200400001)(76176011)(99286004)(2906002)(102836004)(97736004)(316002)(2616005)(476003)(6486002)(486006)(11346002)(229853002)(7736002)(305945005)(446003)(6436002)(81156014)(8676002)(81166006)(6512007)(8936002)(68736007)(14454004)(478600001)(36756003)(186003)(86362001)(106356001)(46003)(14444005)(54906003)(6116002)(53936002)(256004)(82746002)(4326008)(105586002)(25786009)(6246003)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2SPR01MB0009;H:MW2PR1501MB1993.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gdVrlHB2dSu3yU+cNMsfFayJZF9170nzI5AjB+lrxZN/yT31GikawnUlkZhzJlrkDNr3KdbOA+oVBWeagkpij8H6k+mq8JJNGApd7R/CAdpOcVZCy//uU/92pJABfqQvL81+dW+Hj6Bkvmh7YJONgUcP38lcBmhn1fkudtxVqqEVFMRDWKNBHsPmaPSCS2AI4ZDvPVGH8JTm0wSjOBDpFL1bNrnfUFYmBXIKfymztG3VdtxQ8nlpVryCsOTTuM1PJMCPhScnb0mvf5y5M6aEnMjBu8N7DgFaPwmXBdwGXHTUZIdqJUIzsgZWGu6SiHudyaU2tsBKwSU11VvLZl+VEeEuGKI/6lPWaQRZVLlHdcdSWuV0ZhSNcaZ7k7cXZltjWhC0Lg9mos1fwvn39LNhEVWS0gn/QSTYuHqpaa1YDyw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5B446B84C3BAAD4381071DFBF625C593@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 06d2aa86-a2c6-46be-aa34-08d6862e764e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2019 21:12:22.9247
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2SPR01MB0009
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-01-29_16:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



> On Jan 29, 2019, at 9:18 AM, David Sterba <dsterba@suse.cz> wrote:
>=20
> On Mon, Jan 28, 2019 at 04:24:26PM -0500, Dennis Zhou wrote:
>> As mentioned above, a requirement that differs zstd from zlib is that
>> higher levels of compression require more memory. To manage this, each
>> compression level has its own queue of workspaces. A global LRU is used
>> to help with reclaim. To guarantee forward progress, a max level
>> workspace is preallocated and hidden from the LRU.
>=20
> Here I'd like to bring up what was mentioned in previous iteration, the
> workspace sizes.
>=20
> Level   Compression Memory
> 1       0.8 MB
> 2       1.0 MB
> 3       1.3 MB
> 4       0.9 MB
> 5       1.4 MB
> 6       1.5 MB
> 7       1.4 MB
> 8       1.8 MB
> 9       1.8 MB
> 10      1.8 MB
> 11      1.8 MB
> 12      1.8 MB
> 13      2.3 MB
> 14      2.6 MB
> 15      2.6 MB
>=20
> and decompression needs memory of level 1. The sizes can be grouped
> together to say 3 sizes, I'm not sure that we'd really need 15 distinct
> workspaces. The reclaim mechanism helps, but I'd rather keep a smaller
> number of workspaces that covers average use.
>=20
> Default level is 3, that's 1.3 MiB, that also covers level 1, 2 and 4.
> For 5 to 12 it's 1.8 and the rest is 2.6 MiB.
>=20
>> btrfs filesystem 10 times and then read back after dropping the caches.
>> The btrfs filesystem was on an SSD.
>>=20
>> Level   Ratio   Compression (MB/s)  Decompression (MB/s)
>> 1       2.658        438.47                910.51
>> 2       2.744        364.86                886.55
>> 3       2.801        336.33                828.41
>> 4       2.858        286.71                886.55
>> 5       2.916        212.77                556.84
>> 6       2.363        119.82                990.85
>> 7       3.000        154.06                849.30
>> 8       3.011        159.54                875.03
>> 9       3.025        100.51                940.15
>> 10      3.033        118.97                616.26
>> 11      3.036         94.19                802.11
>> 12      3.037         73.45                931.49
>> 13      3.041         55.17                835.26
>> 14      3.087         44.70                716.78
>> 15      3.126         37.30                878.84
>=20
> From my casual user's perspective, I'd use the level 1 for speed, 7 for
> better ratio and 15 for the best compression. Anything else does not
> look good, though the results would vary based on the data set. I
> assume that the silesia corpus serves as a good approximation of the
> worst case average.
>
> The levels 7-14 strike particularly obvious pattern: same ratio but the
> speed gets worse with each level. Taking the default level into account,
> (my) recommended levels would be 1, 3, 7, 15.

Silesia is used because it is a standard corpus, and I'd call it about aver=
age,
but there is a lot of variance and extreme edge case data. The intermediate
strategies will change in effectiveness on different types of data. For exa=
mple,
the lower levels are generally more effective on text, and you want slightl=
y
higher levels for non-text data, because they can find shorter matches.

Upstream zstd also shifts around its levels, and the memory usage of each
level from time-to-time, and I am going to update zstd in the kernel in thi=
s
next year, since we are slowing down development. The shifts will be small
though.

It could make sense to map the levels into size classes, since that could
reduce memory spikes, at the cost of higher stead-state memory usage.
I'm not familiar with the machinery used in these patches, so I can't actua=
lly
say much. I would probably use levels 1, 3, 7 (after it is made monotonic),
12, and 15. You might skip 7, but leave 12.

> I went through the patches, looks mostly ok, I don't like the
> indirections but at the moment it's an implementation detail as I'd like
> to agree on the overall approach first.
>=20
> We might need a few revisions or cleanup rounds to converge to an
> efficient solution, the advantage here is that it's all in-memory and
> without compatibility concerns once the level support for zstd is in and
> works.
>=20
> For that reason, I'm not opposed to the current version of the patchset.
> Given the time in development schedule, it's really close to code
> freeze, but the functionality has a narrow scope so I'm tentatively
> counting with it for 5.1.

