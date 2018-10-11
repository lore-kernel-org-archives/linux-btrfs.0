Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEF2BC677FC
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 18:58:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A92F20658
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 18:58:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="DF2x71CG";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="Qb/YC2SR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A92F20658
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fb.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729794AbeJLC1T (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 22:27:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36602 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728239AbeJLC1T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 22:27:19 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w9BIuGFQ013358;
        Thu, 11 Oct 2018 11:58:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=X/vZh4R4Hp/6wcGTPaT3IR7GWvqubs4d5T0zXdweZUg=;
 b=DF2x71CGDunRxGIirQx/gKQFF5t5xYWaf+Nh1g+lQcDoTKAcm9MJUWM93JnZJsZGWYgH
 5EHPe6rYhzfXwGKvKOo0W6tHA6ecixXgOoYzAz0ETKFf8S3A5mzcmh3rVxrhZGbplvjE
 6lxVZQmBa1dUtr2Fh5lzQVipXZuLySjyPmU= 
Received: from maileast.thefacebook.com ([199.201.65.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2n2b1dg6qe-4
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Thu, 11 Oct 2018 11:58:32 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (192.168.183.28)
 by o365-in.thefacebook.com (192.168.177.24) with Microsoft SMTP Server (TLS)
 id 14.3.361.1; Thu, 11 Oct 2018 14:56:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X/vZh4R4Hp/6wcGTPaT3IR7GWvqubs4d5T0zXdweZUg=;
 b=Qb/YC2SRyEXL5yW3HKs0wdwyOy8MMV6+iK4bdi+TaQTGBZ8lAB4EKi2SnwjG9vLO1HE8My23pst7hNjLUed6WaTOPFsYD0GrQPZwXhwZLfOqpWPYLdsfUh1Hau7JLD8WeORjlvJrbpJJ9La33IHN8EZcaywYPGCatUAPSRlaSv0=
Received: from MW2PR1501MB1993.namprd15.prod.outlook.com (52.132.149.157) by
 MW2PR1501MB2059.namprd15.prod.outlook.com (52.132.150.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.23; Thu, 11 Oct 2018 18:56:36 +0000
Received: from MW2PR1501MB1993.namprd15.prod.outlook.com
 ([fe80::adf1:a7d1:c7cc:8dfa]) by MW2PR1501MB1993.namprd15.prod.outlook.com
 ([fe80::adf1:a7d1:c7cc:8dfa%4]) with mapi id 15.20.1207.029; Thu, 11 Oct 2018
 18:56:36 +0000
From:   Nick Terrell <terrelln@fb.com>
To:     Daniel Kiper <dkiper@net-space.pl>
CC:     David Sterba <dsterba@suse.cz>, Kernel Team <Kernel-team@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "grub-devel@gnu.org" <grub-devel@gnu.org>,
        "kreijack@inwind.it" <kreijack@inwind.it>,
        "kreijack@libero.it" <kreijack@libero.it>
Subject: Re: [PATCH v3 0/2] btrfs: Add zstd support to grub btrfs
Thread-Topic: [PATCH v3 0/2] btrfs: Add zstd support to grub btrfs
Thread-Index: AQHUYCbmzMVc8sxVUkKdf9zlD11dL6UaXF+AgAALlQA=
Date:   Thu, 11 Oct 2018 18:56:35 +0000
Message-ID: <0DEBFC3A-79C1-4B2D-86CF-80ECF7559F76@fb.com>
References: <20181009232137.1941290-1-terrelln@fb.com>
 <20181011181507.GG30679@router-fw-old.i.net-space.pl>
In-Reply-To: <20181011181507.GG30679@router-fw-old.i.net-space.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::4:4481]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MW2PR1501MB2059;20:12r5mK5Az1kO9aFkURNSMRN1Y4OXJTsDqyGRhyxW9qR2LZglL8cQGOvtfpAplge3JatvcfrGe+q40khNEqjPimP21JD9fTAWQpxY9A0EFG5jLmMB8SxugWuzkRUHvsHdmN2ROpJav3xfYe3e+KQfpiEnC0MizhBVBSYM0ozZtvw=
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: 6aed0336-8815-4d9e-3957-08d62fab44f5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:MW2PR1501MB2059;
x-ms-traffictypediagnostic: MW2PR1501MB2059:
x-microsoft-antispam-prvs: <MW2PR1501MB2059EF9779802AB38EB18DBDABE10@MW2PR1501MB2059.namprd15.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(81227570615382);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(823302103)(3002001)(3231355)(11241501184)(944501410)(52105095)(93006095)(93001095)(10201501046)(149066)(150057)(6041310)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123564045)(20161123562045)(201708071742011)(7699051);SRVR:MW2PR1501MB2059;BCL:0;PCL:0;RULEID:;SRVR:MW2PR1501MB2059;
x-forefront-prvs: 08220FA8D6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(136003)(396003)(346002)(376002)(199004)(53754006)(189003)(5250100002)(11346002)(7736002)(14454004)(82746002)(68736007)(305945005)(478600001)(8936002)(33656002)(4326008)(316002)(25786009)(81156014)(8676002)(81166006)(6246003)(36756003)(86362001)(5660300001)(2906002)(6916009)(97736004)(102836004)(105586002)(6486002)(229853002)(6512007)(53546011)(186003)(6506007)(2900100001)(46003)(99286004)(446003)(6116002)(53936002)(476003)(106356001)(2616005)(76176011)(83716004)(256004)(486006)(14444005)(6436002)(71190400001)(54906003)(71200400001)(17423001);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2059;H:MW2PR1501MB1993.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 0KxzfM3KeYa6vQ8C/AjGkEgOmztSx7CF+tuUMKTkEDJDY0a/v7u4DTEWwsmbj7P9GIz2fsEasMLX0fvvGT6bAIyCiQ2H7oE5d1+4LVRhuGg2DMdWpUCv2WQKZqVX/CvCWfjexWGmWtPShN7IlCWPCeWY8+B29gPZDEesjJJ/flC4iHak3dWYyNRPCKY7iwU2XX8POS8hjLsKniFKiDCYdpuQ2gzaqqgLYdEznCB76lGPsmQr6AgQIacM5V+TN6HfVsjxxVzX2A+DE/CoTw87ibMumSeVN48qmJlqT43nAYQc7pMPpjJpfz3oNC+o5reIhFMgaQNIsU6QCHzld53t/siezsrxr5e1ay3OjGkQucg=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F6819C85880362429A86EA25F5341A75@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aed0336-8815-4d9e-3957-08d62fab44f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2018 18:56:36.0627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2059
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-10-11_08:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



> On Oct 11, 2018, at 11:15 AM, Daniel Kiper <dkiper@net-space.pl> wrote:
>=20
> Hi Nick,
>=20
> CC-ing Goffredo.
>=20
> On Tue, Oct 09, 2018 at 04:21:35PM -0700, Nick Terrell wrote:
>> Hi all,
>>=20
>> This patch set imports the upstream zstd library, adds zstd support to t=
he
>> btrfs module, and adds a test case. I've also tested the patch set by st=
oring
>> my boot partition in btrfs with and without zstd compression and rebooti=
ng.
>>=20
>> The fist patch imports the files needed to support zstd decompression fr=
om
>> zstd-1.3.6 as-is. It is a very large patch. In case it doesn't make it,
>> I've included the commit hash and the script I used to download the file=
s.
>>=20
>> Upstream zstd commit hash: 4fa456d7f12f8b27bd3b2f5dfd4f46898cb31c24
>> Upstream zstd commit name: Merge pull request #1354 from facebook/dev
>=20
> In general I am happy with the patches. If everything is done what
> I have asked for then I will get them. However, there is one problem.
> Another big btrfs (RAID) patchset is lurking around for months. It is
> almost ready. Goffredo, I am looking at you... So, I would like to take
> RAID patchset first. If it is in the tree then I will ask you to rebase
> zstd patchset on top of RAID patchset and I will take it. Nick, are you
> OK with that?

That works for me, thanks!

> Daniel

