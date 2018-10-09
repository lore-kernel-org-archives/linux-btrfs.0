Return-Path: <SRS0=yGwK=MV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80D8CC64EB0
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 20:17:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35069214C5
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 20:17:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="PInXrE5/";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="NXnnwUNR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35069214C5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fb.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbeJJDfx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 23:35:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38204 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727486AbeJJDfw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Oct 2018 23:35:52 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w99KEQAT011893;
        Tue, 9 Oct 2018 13:17:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=LJXPBtNE8ALwS35l4p04ol5DYQvIjXoVgcjOEJXoFAI=;
 b=PInXrE5/WMp+NqfBiH0cDiqCD/lIPD/w5SbbFhgRN9Kv7JmMseExzpReurzU2VflZRim
 XVN7c+CdqsuoDLXTAuN/csZMM6ZtY0pr1SacXKWyEm8M3kvj1HS6loyQ4GmYQ7fMp1NI
 92goy/C0vD+0fJ0NfITrstFBtjqS1nafb/k= 
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2n10v08j3p-19
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 09 Oct 2018 13:17:03 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.14) with Microsoft SMTP Server (TLS)
 id 14.3.361.1; Tue, 9 Oct 2018 13:16:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LJXPBtNE8ALwS35l4p04ol5DYQvIjXoVgcjOEJXoFAI=;
 b=NXnnwUNR/RaAHkIqibYcE+pJlyHVBC1RupzxVF5jLjGWDAfpEO2ZTk+rCduu3bVT9Pf3mtM9aAaqqedGPvTnD3i3cn6y1vOdY+TH5s/xGjX1sFlLtpvGsEP3zXJK3SKIwWmZXBnuO1IK4WVb+u/2PmePlwFD9gaehOxvjOz/P58=
Received: from MW2PR1501MB1993.namprd15.prod.outlook.com (52.132.149.157) by
 MW2PR1501MB2058.namprd15.prod.outlook.com (52.132.150.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.28; Tue, 9 Oct 2018 20:16:10 +0000
Received: from MW2PR1501MB1993.namprd15.prod.outlook.com
 ([fe80::adf1:a7d1:c7cc:8dfa]) by MW2PR1501MB1993.namprd15.prod.outlook.com
 ([fe80::adf1:a7d1:c7cc:8dfa%4]) with mapi id 15.20.1207.024; Tue, 9 Oct 2018
 20:16:10 +0000
From:   Nick Terrell <terrelln@fb.com>
To:     Daniel Kiper <dkiper@net-space.pl>
CC:     David Sterba <dsterba@suse.cz>, Kernel Team <Kernel-team@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "grub-devel@gnu.org" <grub-devel@gnu.org>
Subject: Re: [PATCH v2 2/2] btrfs: Add zstd support to grub btrfs
Thread-Topic: [PATCH v2 2/2] btrfs: Add zstd support to grub btrfs
Thread-Index: AQHUX1vXIe3PMoyxiUa+gJfZ5EKSLqUXSAqAgAATEgA=
Date:   Tue, 9 Oct 2018 20:16:10 +0000
Message-ID: <80CD4D4C-ABA6-4F41-A6C2-6C043F019FFE@fb.com>
References: <20181008230621.2185884-1-terrelln@fb.com>
 <20181008230621.2185884-3-terrelln@fb.com>
 <20181009190753.GF11162@router-fw-old.i.net-space.pl>
In-Reply-To: <20181009190753.GF11162@router-fw-old.i.net-space.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::5:ec23]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MW2PR1501MB2058;20:eFboncxBxrX9j9R1NcsUuFTQfAr5Or8B2YSUvfEQwQWVgsWIDqYMdU8lv64Hv7M4N5271MNvc9Z4D9y6lT1uCLaPUpA1gHo3r8n35MG1QXNZZz1phC8d4BvqpABVc2tiyHQ4zhYTKEFku1oKvct/+bgO78GeIbrGXEvuSRTHp/I=
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: 76bc3e7e-5a2e-4bd4-0d61-08d62e240dbc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:MW2PR1501MB2058;
x-ms-traffictypediagnostic: MW2PR1501MB2058:
x-microsoft-antispam-prvs: <MW2PR1501MB20586A0D31BDD70084B1C66BABE70@MW2PR1501MB2058.namprd15.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(67672495146484);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(823302103)(3002001)(3231355)(11241501184)(944501410)(52105095)(93006095)(93001095)(10201501046)(149066)(150057)(6041310)(20161123564045)(20161123562045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(201708071742011)(7699051)(76991055);SRVR:MW2PR1501MB2058;BCL:0;PCL:0;RULEID:;SRVR:MW2PR1501MB2058;
x-forefront-prvs: 08200063E9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(366004)(346002)(376002)(396003)(57704003)(199004)(51914003)(189003)(305945005)(2906002)(83716004)(97736004)(86362001)(6916009)(6506007)(2900100001)(53546011)(6436002)(14454004)(106356001)(6486002)(105586002)(82746002)(53936002)(36756003)(6116002)(71200400001)(6512007)(71190400001)(5660300001)(76176011)(256004)(68736007)(478600001)(7736002)(99286004)(446003)(486006)(316002)(8676002)(2616005)(11346002)(476003)(6246003)(5250100002)(25786009)(81156014)(81166006)(8936002)(186003)(4326008)(229853002)(102836004)(54906003)(33656002)(46003)(17423001);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2058;H:MW2PR1501MB1993.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: oFy2dRW3Clz2gEYcVmB3LpQecrH2DXI8SnUx/+TxVzRgKCp4tijeQ+bHXtf7amp/aVpO84LQMC1DP/le1SRZW5pIF7ran/9WchioY+5/vrcKDBUzfHeUAT7iFS0GgDkIn8uPX4EBLJHr0fk7WenMVMZEEZDcB+hbr8/5YtwIwPlteyMHokFPeZrOqiNjSugudnQLfAFUf7aoYP3ttldXYnyt9lmqpkR/l4vwYBus20luzV08q1kOPjTK5EvymfgE0L5lh6FB1HzsYfHePB+wr2L5O95PncK75Rhg9pTNOe3OnO+Ezcjv2cMd8YosFiFazEIz/Pbn8mPeBo3y3bGOpFq9OM+VraQ3bA05h3yWlhg=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F3969A160D8AC542BAEFC02917AA2A7B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 76bc3e7e-5a2e-4bd4-0d61-08d62e240dbc
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2018 20:16:10.1020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2058
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-10-09_14:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> On Oct 9, 2018, at 12:07 PM, Daniel Kiper <dkiper@net-space.pl> wrote:
> On Mon, Oct 08, 2018 at 04:06:21PM -0700, Nick Terrell wrote:
>> Adds zstd support to the btrfs module. I'm not sure that my changes to t=
he
>> Makefiles are correct, please let me know if I need to do something
>> differently.
>>=20
>> Tested on Ubuntu-18.04 with a btrfs /boot partition with and without zst=
d
>> compression. A test case was also added to the test suite that fails bef=
ore
>> the patch, and passes after.
>>=20
>> Signed-off-by: Nick Terrell <terrelln@fb.com>
>> ---
>> v1 -> v2:
>> - Fix comments from Daniel Kiper
>>=20
>> Makefile.util.def            |  10 +++-
>> grub-core/Makefile.core.def  |  10 +++-
>> grub-core/fs/btrfs.c         | 105 ++++++++++++++++++++++++++++++++++-
>> grub-core/lib/zstd/up        |   1 -
>=20
> Please do not take this file into patch #1.

Oops, sorry about that.

>>=20
>>=20
>> +static void* grub_zstd_malloc (void* state, size_t size)
>> +{
>> +	(void)state;
>=20
> Do we need that?

Yeah, otherwise my compiler (gcc-7.3) gives an unused parameter error.

Thanks for the fast review! I'll have an updated version up later today.

Nick=
