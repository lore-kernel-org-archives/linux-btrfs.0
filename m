Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C7A8C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 19:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E823920879
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 19:33:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="H4Q5TKOG";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="WJSA6Pgz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E823920879
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fb.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbeLETdJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 14:33:09 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37986 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727257AbeLETdJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 14:33:09 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id wB5JWl1n001617;
        Wed, 5 Dec 2018 11:33:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=sydHZKgsYTcQdHT7Zog2SRzw0Nv3ZNZmc3BtOvvUmhg=;
 b=H4Q5TKOGsNCuG6E64siDOG18k65UNvZr4axnRMX88xhXW+5kpaYunO4oaZvEAYpxcn5S
 M75TFyzvBWRxKJTga+55Sb3rgkW+vHMxv8t5ADsGloQiDE6FmCjSg7TUvpg/skH+DhMs
 seFkXcZIAsoO0rcAzpppDV4FCVs7onv3Xso= 
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2p6jw8gfr9-18
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 05 Dec 2018 11:33:04 -0800
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1531.3; Wed, 5 Dec 2018 11:32:32 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1531.3
 via Frontend Transport; Wed, 5 Dec 2018 11:32:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sydHZKgsYTcQdHT7Zog2SRzw0Nv3ZNZmc3BtOvvUmhg=;
 b=WJSA6PgzRSKUWZMJ9Y6ESlzZivTxFxFCz+wTu96HbiNMmb0M27g577/jrp1GMYMtgaXyGHmarJPaBqgaWmMIx05QBx52NQwJv/rDcmpyPqmbDgYMXYwVFItvuIdINiCa7yiJ0BkQ9ZwLeHIyFPkaYkaToHSJxGxe9yrScgbWXH0=
Received: from DM5PR15MB1883.namprd15.prod.outlook.com (10.174.247.135) by
 DM5PR15MB1577.namprd15.prod.outlook.com (10.173.222.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.22; Wed, 5 Dec 2018 19:32:31 +0000
Received: from DM5PR15MB1883.namprd15.prod.outlook.com
 ([fe80::f8d4:7c44:756a:6205]) by DM5PR15MB1883.namprd15.prod.outlook.com
 ([fe80::f8d4:7c44:756a:6205%12]) with mapi id 15.20.1382.020; Wed, 5 Dec 2018
 19:32:31 +0000
From:   Chris Mason <clm@fb.com>
To:     Andrea Gelmini <andrea.gelmini@gelma.net>
CC:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Linux-next regression?
Thread-Topic: Linux-next regression?
Thread-Index: AQHUhZj7md68OP6+WEeStf1281SPv6Vi0X0AgADZkQCAAAFvAIABsKeAgAnZXwCAANF5AIAAj1UA
Date:   Wed, 5 Dec 2018 19:32:31 +0000
Message-ID: <6CC21012-713A-4B99-B968-6625556C9D1E@fb.com>
References: <20181126150137.GA16029@glet>
 <845890af-0659-fbfa-c445-d6f109bd5015@gmx.com> <20181127141144.GA23269@glet>
 <4f1bb6e7-434a-47d2-a75f-8aca702f5395@gmx.com> <20181128160523.GA5288@glet>
 <FEDBF117-C83C-4DEC-96D1-A549DBCF4950@fb.com> <20181205105928.GA29665@glet>
In-Reply-To: <20181205105928.GA29665@glet>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: MailMate (1.12.2r5568)
x-clientproxiedby: BN6PR16CA0026.namprd16.prod.outlook.com
 (2603:10b6:405:14::12) To DM5PR15MB1883.namprd15.prod.outlook.com
 (2603:10b6:4:4f::7)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c091:180::1:7d53]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM5PR15MB1577;20:yb6yFxg7J8oxdRtlLjoNXmeOHWGzarYSaExtkxiwslXbCSjyrlLzVlexDP+j9cd0SCpRLSbCKvy9NVwpa4P9jOUfb4WvbXWBujwFhmvRTNArZCl6VGSTpyw6dU5U3dnecLxz/TFfi2TgqHtha7n2FtvlXnTqr3tiylO/Mvvqkqs=
x-ms-office365-filtering-correlation-id: 8fd137b9-4278-4440-ee2f-08d65ae865bf
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:DM5PR15MB1577;
x-ms-traffictypediagnostic: DM5PR15MB1577:
x-microsoft-antispam-prvs: <DM5PR15MB15771FEB1F38F69918C6ACE9D3A80@DM5PR15MB1577.namprd15.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(3231455)(999002)(11241501185)(944501520)(52105112)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:DM5PR15MB1577;BCL:0;PCL:0;RULEID:;SRVR:DM5PR15MB1577;
x-forefront-prvs: 08770259B4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(376002)(396003)(136003)(346002)(39860400002)(366004)(199004)(189003)(51914003)(25786009)(2906002)(6436002)(305945005)(53936002)(6246003)(6506007)(6116002)(97736004)(6512007)(3480700005)(14454004)(33656002)(54906003)(7736002)(6306002)(8676002)(50226002)(6916009)(8936002)(81156014)(81166006)(93886005)(68736007)(5660300001)(82746002)(6486002)(316002)(86362001)(966005)(186003)(102836004)(229853002)(478600001)(53546011)(46003)(36756003)(11346002)(6346003)(76176011)(446003)(386003)(2616005)(476003)(486006)(52116002)(106356001)(256004)(71190400001)(105586002)(4326008)(99286004)(14444005)(71200400001)(83716004)(42262002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1577;H:DM5PR15MB1883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 7ZsGEVaiCvKAMBI541KbhQM0Mgjt1ynA8uwntFuuX5lXy/xQp3mfHnJSXebgjdFAeXjz3qWDBjMTnwsql+ISoPmlIoEXUeouxzGsYVzZ7asVDNDonqVdAh+OdxgKtf6MntbR136LAPxgxml7TWw8DGLsn554qIuxGXRRZUduICi+lPwqxSApMHi51SQOtRPOZf0IGISuJXv/O/5AI52EZIrdwM3HGAqWkfYpOw7Gr+pqJVz/ZTqdhX0nZtJ6OWt/EjmzGe8IsbfDgWXSwotWCkuv13ikSoSOynMm2HXabtS0/Ua3SbIssjCuaTrKqUE90mGVwffkZ8Dzgafb1EozhLv52BI+iKJWTwYS02B4WfE=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fd137b9-4278-4440-ee2f-08d65ae865bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2018 19:32:31.2118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1577
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-12-05_08:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 5 Dec 2018, at 5:59, Andrea Gelmini wrote:

> On Tue, Dec 04, 2018 at 10:29:49PM +0000, Chris Mason wrote:
>> I think (hope) this is:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D201685
>>
>> Which was just nailed down to a blkmq bug.  It triggers when you have
>> scsi devices using elevator=3Dnone over blkmq.
>
> Thanks a lot Chris. Really.
> Good news: I confirm I recompiled and used blkmq and no-op (at that=20
> time).
> Also, the massive write of btrfs defrag can explain the massive=20
> trigger of
> the bug, and next corruption.

Sorry this happened, but glad you were able to confirm that it explains=20
the trouble you hit.  Thanks for the report, I did end up using this as=20
a datapoint to convince myself the bugzilla above wasn't ext4 specific.

-chris
