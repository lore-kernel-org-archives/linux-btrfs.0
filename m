Return-Path: <SRS0=BJi/=NR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5545DC32789
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 19:43:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E360920830
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 19:43:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="fKc8IShz";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="UizpHkr8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E360920830
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fb.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbeKGFKK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 7 Nov 2018 00:10:10 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49606 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725198AbeKGFKK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Nov 2018 00:10:10 -0500
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wA6JXghQ001699;
        Tue, 6 Nov 2018 11:43:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=6pc0uRcgwa5pXCl5Ws2crruBq6vc4rRqRXMl/zfY0gE=;
 b=fKc8IShzrS+5zF2+AIBnk5V22rndvKX1W6Q50Bsp89BkEG7RMhvgaZ+2MyzANj8RFRr0
 Egxyy3WlWDmghOmI1iojnZfttjcZl4a73bj8X+zM5Y+c9T7Rl6c888LyhseFo3vX0PyB
 NWB4fMWkVHSxMrj2YzrRLyfNIl6GA32RANk= 
Received: from maileast.thefacebook.com ([199.201.65.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2nkgyb02ns-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 06 Nov 2018 11:43:07 -0800
Received: from frc-hub05.TheFacebook.com (2620:10d:c021:18::175) by
 frc-hub05.TheFacebook.com (2620:10d:c021:18::175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1531.3; Tue, 6 Nov 2018 11:43:06 -0800
Received: from FRC-CHUB13.TheFacebook.com (2620:10d:c021:18::32) by
 frc-hub05.TheFacebook.com (2620:10d:c021:18::175) with Microsoft SMTP Server
 (version=TLS1_0, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1531.3
 via Frontend Transport; Tue, 6 Nov 2018 11:43:06 -0800
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (192.168.183.28)
 by o365-in.thefacebook.com (192.168.177.33) with Microsoft SMTP Server (TLS)
 id 14.3.361.1; Tue, 6 Nov 2018 14:43:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6pc0uRcgwa5pXCl5Ws2crruBq6vc4rRqRXMl/zfY0gE=;
 b=UizpHkr8sbxIW2sWuiJIh1O01CigWNTNH8bEOd+fq6RKM4UF6xWzu6dGK+cakd8atCqcfedmEV0OkEYB7jlztEX2h7tMyf9zgT4VuTw57c/CgGZ9LrqxXoizZBRsaSUjjAAlnrLp6xlsHsOP7UK1267jJVAT7Jq2Yg3cYaCmy/w=
Received: from MW2PR1501MB1993.namprd15.prod.outlook.com (52.132.149.157) by
 MW2PR1501MB2156.namprd15.prod.outlook.com (52.132.150.152) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.26; Tue, 6 Nov 2018 19:43:04 +0000
Received: from MW2PR1501MB1993.namprd15.prod.outlook.com
 ([fe80::c554:8f41:4255:796f]) by MW2PR1501MB1993.namprd15.prod.outlook.com
 ([fe80::c554:8f41:4255:796f%3]) with mapi id 15.20.1294.034; Tue, 6 Nov 2018
 19:43:04 +0000
From:   Nick Terrell <terrelln@fb.com>
To:     Daniel Kiper <dkiper@net-space.pl>
CC:     David Sterba <dsterba@suse.cz>, Kernel Team <Kernel-team@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "grub-devel@gnu.org" <grub-devel@gnu.org>
Subject: Re: [PATCH v4 1/2] Import upstream zstd-1.3.6
Thread-Topic: [PATCH v4 1/2] Import upstream zstd-1.3.6
Thread-Index: AQHUcUM8IHtgflvOb06YuNDNIYEQ16VC3QwAgABSXgA=
Date:   Tue, 6 Nov 2018 19:43:04 +0000
Message-ID: <AE8FECE1-5414-41B9-882C-B8AE98BA2912@fb.com>
References: <20181031175617.230241-1-terrelln@fb.com>
 <20181031175617.230241-2-terrelln@fb.com>
 <20181106144832.GA9907@router-fw-old.i.net-space.pl>
In-Reply-To: <20181106144832.GA9907@router-fw-old.i.net-space.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::4:3925]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MW2PR1501MB2156;20:PNQ9WvGRYoRz2UsgFFEKjW2Ze3cuomNsNZtCoZi3fChMPtgmpwb0RK6o3eTlGTySM2KODDpQjyRVPp3GI5n6ufmMx1sD4ZKI2SUSrjRL6j5+FUpcjOBff3qzXjvE9U80LUjaAoxzQhyEHPnkDNqCpeSoBDE0YFawKcSZIWmTU04=
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: 21d235c0-af38-48f6-95f1-08d644201177
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:MW2PR1501MB2156;
x-ms-traffictypediagnostic: MW2PR1501MB2156:
x-microsoft-antispam-prvs: <MW2PR1501MB2156DFD24A27652D335C45E5ABCB0@MW2PR1501MB2156.namprd15.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(81227570615382)(166708455590820)(67672495146484);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(823302103)(3002001)(93006095)(93001095)(3231382)(11241501184)(944501410)(52105095)(10201501046)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123564045)(20161123562045)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:MW2PR1501MB2156;BCL:0;PCL:0;RULEID:;SRVR:MW2PR1501MB2156;
x-forefront-prvs: 0848C1A6AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(366004)(136003)(376002)(346002)(189003)(199004)(51444003)(68736007)(14454004)(46003)(6436002)(71200400001)(83716004)(86362001)(71190400001)(14444005)(6116002)(97736004)(33656002)(106356001)(53936002)(105586002)(6486002)(25786009)(6306002)(966005)(6512007)(478600001)(102836004)(6246003)(5660300001)(54906003)(7736002)(76176011)(53546011)(36756003)(6506007)(316002)(186003)(256004)(6916009)(82746002)(486006)(229853002)(446003)(11346002)(2906002)(4326008)(81166006)(2616005)(81156014)(8676002)(305945005)(99286004)(8936002)(2900100001)(476003);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2156;H:MW2PR1501MB1993.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: IJvzaeLc7EpOK3V6nzrQo+6ElMnqAsmd6X2y5rgv3fx644tNjESSwFLIue1aCEB+1rEwktXldvJ3XLNee26490Wgk2lXmSAGtKt+n3R01BLX8g70ayat9ee66oHJaZoCQ5fobwRkDrhhPt+bTf5sTbGduTX6YP/2rg1MzyB5h/7MCNmShhUlZf3hB7qybPGwIFcpbpTx5PGoIGRbtJzp2gqENcHYdAaVsl3I4MvoUXCB7M5k0MVXS4Tc5vjVk8m9lHvJTaCJ7J+p+HZzWVbdJdK3bZqPfK2l6X+1heXZ/OnIetmqhzHcYN3JUsw92hWzYRPthehUaGC3gu05KCM7uBhcZbFfSKix7QTi93OpMhY=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <193F24AB3B6E6841835EAEF56696B83D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 21d235c0-af38-48f6-95f1-08d644201177
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2018 19:43:04.1015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2156
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-11-06_09:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



> On Nov 6, 2018, at 6:48 AM, Daniel Kiper <dkiper@net-space.pl> wrote:
>=20
> On Wed, Oct 31, 2018 at 10:56:16AM -0700, Nick Terrell wrote:
>> Import zstd-1.3.6 from upstream [1]. Only the files need for decompressi=
on
>> are imported. Additionally makes zstd a module by adding module.c which
>> contains the license, and updates Makefile.core.def.
>>=20
>> I used the latest zstd release, which includes patches [2] to build clea=
nly
>> in GRUB.
>>=20
>> Upstream zstd commit hash: 4fa456d7f12f8b27bd3b2f5dfd4f46898cb31c24
>> Upstream zstd commit name: Merge pull request #1354 from facebook/dev
>>=20
>> I've included the script used to import zstd-1.3.6 below.
>>=20
>> [1] https://github.com/facebook/zstd/releases/tag/v1.3.6
>> [2] https://github.com/facebook/zstd/pull/1344
>>=20
>> ```
>> #!/bin/sh -e
>>=20
>> curl -L -O https://github.com/facebook/zstd/releases/download/v1.3.6/zst=
d-1.3.6.tar.gz
>> curl -L -O https://github.com/facebook/zstd/releases/download/v1.3.6/zst=
d-1.3.6.tar.gz.sha256
>> sha256sum --check zstd-1.3.6.tar.gz.sha256
>> tar xzf zstd-1.3.6.tar.gz
>>=20
>> SRC_LIB=3D"zstd-1.3.6/lib"
>> DST_LIB=3D"grub-core/lib/zstd"
>> rm -rf $DST_LIB
>> mkdir -p $DST_LIB
>> cp $SRC_LIB/zstd.h $DST_LIB/
>> cp $SRC_LIB/common/*.[hc] $DST_LIB/
>> cp $SRC_LIB/decompress/*.[hc] $DST_LIB/
>> rm $DST_LIB/{pool.[hc],threading.[hc]}
>> rm -rf zstd-1.3.6*
>> echo SUCCESS!
>> ```
>>=20
>> Signed-off-by: Nick Terrell <terrelln@fb.com>
>=20
> I have a few concerns. First of all I can see that you include a lot of
> standard headers, e.g. stdlib.h, string.h, stddef.h, etc. Where do they
> come from? OS? If yes that is wrong. Additionally, I think that you
> should not use standard types, e.g. size_t, because this may not work if
> you cross compile. You have to use, e.g. grub_size_t. IMO the simplest
> solution would be definition and usage of relevant zstd_* types, e.g.
> zstd_size_t. Then e.g. zstd_size_t should be defined as grub_size_t.

I'm getting the standard headers from grub-core/lib/posix_wrap. I need
to add stddef.h. I'd like to keep using standard types, which are typedefed
to the grub_ equivalent in posix_wrap/sys/types.h.

I agree it would be nice if zstd put all of its dependencies into a configu=
ration
file that we could replace. I'll look into adding this in a future version.=
 However,
since we are using upstream zstd as-is right now, and posix_wrapper is alre=
ady
present, I think that the benefit of using upstream as-is outweighs the cos=
t of
using the posix_wrapper. Does that sound reasonable to you?

To test that I'm using the right headers, I looked that the .Po files gener=
ated,
and saw that stddef.h was using the system, but the rest were using the
posix_wrapper. Is that the right approach? Is there something else I should
be testing?

> [...]

Nick=
