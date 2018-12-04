Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46645C04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 22:30:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F08C520834
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 22:30:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="TbIr30UQ";
	dkim=temperror (0-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="IkvJB3iY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F08C520834
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fb.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbeLDWaj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 17:30:39 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43318 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725875AbeLDWai (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 17:30:38 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id wB4MSFjv031360;
        Tue, 4 Dec 2018 14:30:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=cjFBFQGMyYWQGxTKJ+Gj1mvVjnYEAH+XiNdIfjGGDcI=;
 b=TbIr30UQCdreu8I2Twnfkbw5V3OROYyzk+anih9eDNoq/XQe2OLily/yM+7KjMSW0SVy
 ynzK/4NnAH7CAGosS4rMrvHSancW4dEQniLTYCMw8+AZRFhZmIvnbLXES74NrvziUnVl
 m4lopMLnibe2kXjPnbrd6nAsrAUzq89bgVE= 
Received: from maileast.thefacebook.com ([199.201.65.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2p61f10973-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 04 Dec 2018 14:30:33 -0800
Received: from frc-hub02.TheFacebook.com (2620:10d:c021:18::172) by
 frc-hub02.TheFacebook.com (2620:10d:c021:18::172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1531.3; Tue, 4 Dec 2018 14:30:07 -0800
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (192.168.183.28)
 by o365-in.thefacebook.com (192.168.177.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1531.3
 via Frontend Transport; Tue, 4 Dec 2018 14:30:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cjFBFQGMyYWQGxTKJ+Gj1mvVjnYEAH+XiNdIfjGGDcI=;
 b=IkvJB3iYHilGScH6PvWm6E40MDjvgcZH2poEvRH2Cg+7sSpA99lPCFsEc/1OztVhBlwuxLEcocO+tPPe3HGK7cBOQXy5xQFo0D+6eB0AMNDiAr6FHjJWWu4eoSNeA1fp35yjPonGkpmCfEEHuymUeBvXVRA5GmhHCfHbqL0lCYo=
Received: from DM5PR15MB1883.namprd15.prod.outlook.com (10.174.247.135) by
 DM5PR15MB1562.namprd15.prod.outlook.com (10.173.222.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.21; Tue, 4 Dec 2018 22:29:49 +0000
Received: from DM5PR15MB1883.namprd15.prod.outlook.com
 ([fe80::f8d4:7c44:756a:6205]) by DM5PR15MB1883.namprd15.prod.outlook.com
 ([fe80::f8d4:7c44:756a:6205%12]) with mapi id 15.20.1382.020; Tue, 4 Dec 2018
 22:29:49 +0000
From:   Chris Mason <clm@fb.com>
To:     Andrea Gelmini <andrea.gelmini@gelma.net>
CC:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Linux-next regression?
Thread-Topic: Linux-next regression?
Thread-Index: AQHUhZj7md68OP6+WEeStf1281SPv6Vi0X0AgADZkQCAAAFvAIABsKeAgAnZXwA=
Date:   Tue, 4 Dec 2018 22:29:49 +0000
Message-ID: <FEDBF117-C83C-4DEC-96D1-A549DBCF4950@fb.com>
References: <20181126150137.GA16029@glet>
 <845890af-0659-fbfa-c445-d6f109bd5015@gmx.com> <20181127141144.GA23269@glet>
 <4f1bb6e7-434a-47d2-a75f-8aca702f5395@gmx.com> <20181128160523.GA5288@glet>
In-Reply-To: <20181128160523.GA5288@glet>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: MailMate (1.12.2r5568)
x-clientproxiedby: BN4PR12CA0012.namprd12.prod.outlook.com
 (2603:10b6:403:2::22) To DM5PR15MB1883.namprd15.prod.outlook.com
 (2603:10b6:4:4f::7)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c091:180::1:1cc6]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM5PR15MB1562;20:DyN/ExCzbQQxIO6fWcWFJOkt4RunbwSS8KJNVYCDt9THDUrLlfSf0QTafq7McR7eajLdFHtWh/8AB/Hdp1f/bf47Hp1hj2IrMoOOanDEl1ok6s/S0xQ1/L5a6WqFAKFIleyVnLO6M5l/XAyDI/Amg1VGdTF6WpYG2sQg+pS5q+0=
x-ms-office365-filtering-correlation-id: acbd2770-0ad9-41f9-b894-08d65a380042
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:DM5PR15MB1562;
x-ms-traffictypediagnostic: DM5PR15MB1562:
x-microsoft-antispam-prvs: <DM5PR15MB1562364934AEB266E99B660AD3AF0@DM5PR15MB1562.namprd15.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(3231455)(999002)(11241501185)(944501493)(52105112)(93006095)(93001095)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123564045)(20161123560045)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:DM5PR15MB1562;BCL:0;PCL:0;RULEID:;SRVR:DM5PR15MB1562;
x-forefront-prvs: 0876988AF0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(39860400002)(346002)(376002)(366004)(189003)(199004)(52314003)(2616005)(36756003)(54906003)(6916009)(14454004)(105586002)(5660300001)(82746002)(106356001)(4326008)(68736007)(11346002)(478600001)(476003)(71190400001)(83716004)(71200400001)(33656002)(486006)(6512007)(446003)(3480700005)(6306002)(53546011)(6116002)(6246003)(97736004)(99286004)(52116002)(8676002)(305945005)(966005)(6506007)(186003)(7736002)(53936002)(76176011)(256004)(25786009)(8936002)(229853002)(386003)(81166006)(50226002)(81156014)(46003)(6486002)(316002)(86362001)(6436002)(93886005)(2906002)(102836004)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1562;H:DM5PR15MB1883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: wfctaue7EUa7jNjnwpYENo/zKsP4YKcjGn2RqaCTjDCTQfkA76r0s5EJB86RUSkriaMogf2i6a3ATDeOARwl7Blpt1vZqrSEVXmSwThgmDr8lkzd2vPWiLxn+hwp8Gr3cyO2H1J9mBDUcfMhsVLdptvmz/NK3XkJZFaD8CcvD32UCDXFpdtCQJfF1SsysfDhfWScR5nS45jT+zeU+KseQrKojpoYW8zeSAADxOEN/8HbiIuks7Fqp1hgQg3UpwRkhNgQvZCeVtSfqn/kiGUqbve1s5loul6M6etvyAu7Wiiun5aChKbEQxEUwxHNF+mPiN3TBjIhUV47P7ZPkKnOqnUZxXCvMgdalruEvDqW/Rg=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: acbd2770-0ad9-41f9-b894-08d65a380042
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2018 22:29:49.2107
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1562
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-12-04_09:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 28 Nov 2018, at 11:05, Andrea Gelmini wrote:

> On Tue, Nov 27, 2018 at 10:16:52PM +0800, Qu Wenruo wrote:
>>
>> But it's less a concerning problem since it doesn't reach latest RC,=20
>> so
>> if you could reproduce it stably, I'd recommend to do a bisect.
>
> No problem to bisect, usually.
> But right now it's not possible for me, I explain further.
> Anyway, here the rest of the story.
>
> So, in the end I:
> a) booted with 4.20.0-rc4
> b) updated backup
> c) did the btrfs check --read-only
> d) seven steps, everything is perfect
> e) no complains on screen or in logs (never had)
> f) so, started to compile linux-next 20181128 (on another partition)
> e) without using (reading or writing) on /home, I started
> f) btrfs filesystem defrag -v -r -t 128M /home
> g) it worked without complain (in screen or logs)
> h) then, reboot with kernel tag 20181128
> i) and no way to mount:

I think (hope) this is:

https://bugzilla.kernel.org/show_bug.cgi?id=3D201685

Which was just nailed down to a blkmq bug.  It triggers when you have=20
scsi devices using elevator=3Dnone over blkmq.

-chris
