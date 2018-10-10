Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E4EC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 20:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13BB02075B
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 20:29:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="euU09LN4";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="eiUguSU1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13BB02075B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fb.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbeJKDw4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 23:52:56 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52842 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727642AbeJKDw4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 23:52:56 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w9AKRoFO021048;
        Wed, 10 Oct 2018 13:28:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=T8MMLWZeWb37Bvct4dUbOpjtfksS0bQJ1ZosoUA3mfg=;
 b=euU09LN42VdH8g26jITK0bzbt+JkmEpH1AdX5CXXZEMAWln605HkAKjzqX9N/02Zxa1i
 39O1e6V7wk8ZJNLfCpxdXSF1CAtLVd4ieUOZ+SAYKeGcptGGm+a80Y4Wjgxb59kNpPwJ
 pVNDXrxXqkhI1hSAH5uNK75erZ8SeBGOPr0= 
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2n1ny50nnh-11
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 10 Oct 2018 13:28:47 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.21) with Microsoft SMTP Server (TLS)
 id 14.3.319.2; Wed, 10 Oct 2018 13:28:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T8MMLWZeWb37Bvct4dUbOpjtfksS0bQJ1ZosoUA3mfg=;
 b=eiUguSU1RM1zXTkgYY406aRIIVrxM5jJJ4HqhSDvK7Zbg3+kR9ITuzwPdkRllGtYvL649ZSY/Ze55P8e7x5dWmKlV5IxY98dpgMtphiK18py6DlUuROXRvz9H5rz0p3fjdyCGTyeucaSRqfhnVB8gwi7g4jqKoPH8rkKYK4idSc=
Received: from MW2PR1501MB1993.namprd15.prod.outlook.com (52.132.149.157) by
 MW2PR1501MB2091.namprd15.prod.outlook.com (52.132.150.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.21; Wed, 10 Oct 2018 20:28:27 +0000
Received: from MW2PR1501MB1993.namprd15.prod.outlook.com
 ([fe80::adf1:a7d1:c7cc:8dfa]) by MW2PR1501MB1993.namprd15.prod.outlook.com
 ([fe80::adf1:a7d1:c7cc:8dfa%4]) with mapi id 15.20.1207.024; Wed, 10 Oct 2018
 20:28:27 +0000
From:   Nick Terrell <terrelln@fb.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
CC:     "grub-devel@gnu.org" <grub-devel@gnu.org>,
        Daniel Kiper <dkiper@net-space.pl>,
        Kernel Team <Kernel-team@fb.com>,
        David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] btrfs: Add zstd support to grub btrfs
Thread-Topic: [PATCH v3 0/2] btrfs: Add zstd support to grub btrfs
Thread-Index: AQHUYCbmzMVc8sxVUkKdf9zlD11dL6UYFx8AgADYKoA=
Date:   Wed, 10 Oct 2018 20:28:27 +0000
Message-ID: <C0415AB7-FD1E-4026-8AEF-02B3F7FEABC5@fb.com>
References: <20181009232137.1941290-1-terrelln@fb.com>
 <c00853f9-bc05-fe91-4e58-bf77f3da8583@molgen.mpg.de>
In-Reply-To: <c00853f9-bc05-fe91-4e58-bf77f3da8583@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::4:6e96]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MW2PR1501MB2091;20:EC9AoCHeilVUDjblf45Zion2NQhm4B+XUQO8cz+aVpAZrzRsP2mVcmm7222wWrcuqI57ABowVtaqburvVHMc3dfyfp3Cnc+L0jaQ+Dosdk5YUerCCVU+5MSKTbK122/Ef0NiE/YINtMbhWfnpB79f5qVlvg36TMEBd4sP/FoSQE=
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: 25544e10-34e4-46e1-1ea6-08d62eeeef69
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:MW2PR1501MB2091;
x-ms-traffictypediagnostic: MW2PR1501MB2091:
x-microsoft-antispam-prvs: <MW2PR1501MB2091DF794CE4C2C0E948E272ABE00@MW2PR1501MB2091.namprd15.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(823302103)(3002001)(3231355)(11241501184)(944501410)(52105095)(10201501046)(93006095)(93001095)(149066)(150057)(6041310)(20161123560045)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051);SRVR:MW2PR1501MB2091;BCL:0;PCL:0;RULEID:;SRVR:MW2PR1501MB2091;
x-forefront-prvs: 08213D42D3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(346002)(376002)(366004)(136003)(199004)(189003)(14444005)(106356001)(105586002)(46003)(186003)(33656002)(6436002)(229853002)(68736007)(102836004)(6116002)(6246003)(54906003)(256004)(486006)(6512007)(476003)(2616005)(5660300001)(6916009)(5250100002)(53546011)(6506007)(83716004)(71200400001)(71190400001)(316002)(99286004)(446003)(11346002)(76176011)(6486002)(305945005)(7736002)(81156014)(25786009)(81166006)(82746002)(4326008)(53936002)(36756003)(86362001)(2906002)(8676002)(8936002)(97736004)(2900100001)(478600001)(14454004)(17423001);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2091;H:MW2PR1501MB1993.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: MZLDCyF9qqHbOWAFN0yMv7mOGYxz1XlyPUh7Suskrkaz3dMbnoKOANRrLLf1h6orXz9v4U01cB8FvINkxsMxZqbGCZ9vNJYUApGkMmtESeUQpyUW5y0rfBetFAmZZFOXGqydY47BKT2dkJYWFIjKAtdNYEc/OuLTzNDdjByUWaryZKRZd30G+wdVY3pyswbVUmyoJKnZ0kic5q8umR4z7l/r+0zPdYVk/pK8awC2TXBEsSP9n6TCENspichmpt0wm++/5j3f6n/tipbadhL3ITyjlSpGYrU5VTvdg3krgYPHf03XeizyxLk/lptn7aHBVVjjS0BFE2/FvK1riTTzf6WH/Cf2ebG7dGKxkYLZ3jo=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E82B65A43DF611448CFC0CBC095E6366@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 25544e10-34e4-46e1-1ea6-08d62eeeef69
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2018 20:28:27.1320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2091
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-10-10_12:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



> On Oct 10, 2018, at 12:34 AM, Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>=20
> Sorry for being ignorant, but you explain, why the library needs to be im=
ported and it is not enough to use that library as an external dependency?
>=20
> Importing the library means, it has to be maintained in the GRUB reposito=
ry, which will result in some maintenance burden.

I've imported zstd because thats the way the rest of the decompressors are =
imported.

We could potentially use libzstd as an external dependency, since its only =
dependency is libc
and GRUB provides the definitions of the libc functions that zstd needs to =
decompress
(memcpy, and memmove). Theres some other stuff in the library that requires=
 libc functionality
that GRUB doesn't provide, but that isn't used during decompression. We str=
ip those files
out in the import.

Let me know if you want me to switch to an external dependency.

Best,
Nick=
