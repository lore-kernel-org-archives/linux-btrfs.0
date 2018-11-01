Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9092EC0044C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 17:37:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BC782081B
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 17:37:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="W5yrBTqV";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="ISVaz2IV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2BC782081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fb.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbeKBClA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Nov 2018 22:41:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60432 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727617AbeKBClA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Nov 2018 22:41:00 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wA1HYudt018231;
        Thu, 1 Nov 2018 10:36:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=HZ8pTyJflHqpE/rLnkFSfXlDnng1tZe6EL9k7lplCuk=;
 b=W5yrBTqVY3hi/v5QpESApJftr5xpSzRQ9ipK84yEkzOwgxjnf3D7gnbeGnR6L56A+nqg
 d7mYqx8/7dm2pLd6oV83J/51JNwy5JIG1MP5AArhCUti7FgAvMXPZMRLFhHgQw+37bzf
 Zqm0i31qweQcic1V4H8zjCi4xh0dgJ4/ohg= 
Received: from maileast.thefacebook.com ([199.201.65.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ng45m0eyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 01 Nov 2018 10:36:56 -0700
Received: from frc-hub05.TheFacebook.com (2620:10d:c021:18::175) by
 frc-hub05.TheFacebook.com (2620:10d:c021:18::175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1531.3; Thu, 1 Nov 2018 10:36:54 -0700
Received: from FRC-CHUB01.TheFacebook.com (2620:10d:c021:18::10) by
 frc-hub05.TheFacebook.com (2620:10d:c021:18::175) with Microsoft SMTP Server
 (version=TLS1_0, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1531.3
 via Frontend Transport; Thu, 1 Nov 2018 10:36:54 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.183.28)
 by o365-in.thefacebook.com (192.168.177.21) with Microsoft SMTP Server (TLS)
 id 14.3.361.1; Thu, 1 Nov 2018 13:36:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZ8pTyJflHqpE/rLnkFSfXlDnng1tZe6EL9k7lplCuk=;
 b=ISVaz2IVrr2OzctKmLklDSh2eGZV3qftFJeo+a/hxUaOuoXltUPgbDwRDCzs84S9fhXYsfA0CGW8NddMELQ4E1GnGf8ePXlC0Cj4CL3oUes1h//5A8J5/7jDBxJOdh6pEli1QhwByWRBJyMCUd7kYR7QPUeCVpbY+5lXsTDc2fc=
Received: from DM5PR15MB1883.namprd15.prod.outlook.com (10.174.247.135) by
 DM5PR15MB1499.namprd15.prod.outlook.com (10.173.225.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.26; Thu, 1 Nov 2018 17:36:31 +0000
Received: from DM5PR15MB1883.namprd15.prod.outlook.com
 ([fe80::6023:3276:3d78:5943]) by DM5PR15MB1883.namprd15.prod.outlook.com
 ([fe80::6023:3276:3d78:5943%2]) with mapi id 15.20.1294.021; Thu, 1 Nov 2018
 17:36:31 +0000
From:   Chris Mason <clm@fb.com>
To:     Omar Sandoval <osandov@osandov.com>
CC:     "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "Nikolay Borisov" <nborisov@suse.com>
Subject: Re: [PATCH v2] Btrfs: fix missing delayed iputs on unmount
Thread-Topic: [PATCH v2] Btrfs: fix missing delayed iputs on unmount
Thread-Index: AQHUcTwZPa2h/8BmYk2L46nyuVb3XqU6tSwAgAA2r4CAABsuAIAAA+aAgAAAioCAAAGBAIAACLMAgAAasIA=
Date:   Thu, 1 Nov 2018 17:36:31 +0000
Message-ID: <2234C029-9082-45A3-AD76-AE326BDF5F5A@fb.com>
References: <5d98091d3e089b4f74cb61fb2ed691e1f4dd1d6b.1541005462.git.osandov@fb.com>
 <20181101101532.GL9136@twin.jikos.cz>
 <2DCF4F92-0B05-420C-ADEB-3A7A69F6DB37@fb.com>
 <20181101150831.GM9136@twin.jikos.cz> <20181101152229.GN9136@twin.jikos.cz>
 <20181101152425.GB18005@vader> <20181101152948.GP9136@twin.jikos.cz>
 <20181101160056.GD18005@vader>
In-Reply-To: <20181101160056.GD18005@vader>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: MailMate (1.10r5443)
x-clientproxiedby: BN6PR18CA0022.namprd18.prod.outlook.com
 (2603:10b6:404:121::32) To DM5PR15MB1883.namprd15.prod.outlook.com
 (2603:10b6:4:4f::7)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c091:180::1:a0cc]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM5PR15MB1499;20:rMXkA+jT604NAEvtEZVEUDwHlUkzBV7llRh3Nw3jOLUORP7Kq3DLTIbXPi6NvonqUwAdjTPlqfdq0qS/yUNWsjiyM4vA7JNTB8MK5mozoQ/WsWBFXAxvF5VtyeLsU3l5WCydBGILVuzQsw1ASRIp0cshDOSa9c1IpnHVTmjDPMo=
x-ms-office365-filtering-correlation-id: 6412dcaa-48d8-4c0d-e2a7-08d640208f32
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM5PR15MB1499;
x-ms-traffictypediagnostic: DM5PR15MB1499:
x-microsoft-antispam-prvs: <DM5PR15MB1499480AB3912262F966B28AD3CE0@DM5PR15MB1499.namprd15.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(823302103)(93006095)(93001095)(10201501046)(3002001)(3231382)(11241501184)(944501410)(52105095)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123562045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:DM5PR15MB1499;BCL:0;PCL:0;RULEID:;SRVR:DM5PR15MB1499;
x-forefront-prvs: 0843C17679
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(346002)(366004)(376002)(39860400002)(136003)(396003)(199004)(189003)(46003)(54906003)(446003)(11346002)(256004)(6246003)(316002)(33656002)(2900100001)(486006)(93886005)(476003)(2616005)(5660300001)(6486002)(102836004)(53546011)(97736004)(6116002)(6436002)(6506007)(386003)(4326008)(229853002)(81166006)(76176011)(186003)(52116002)(36756003)(5250100002)(99286004)(2906002)(106356001)(53936002)(25786009)(6512007)(50226002)(71190400001)(71200400001)(83716004)(68736007)(82746002)(8676002)(478600001)(81156014)(7736002)(14454004)(86362001)(305945005)(105586002)(6916009)(8936002)(42262002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1499;H:DM5PR15MB1883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: f1ir5LD5n9rxWHff02ypR8k+n/FKyEAatn2h9EoLu1h1osHt8ard2VsV23ykh0KXVQS8yw8LEyZLOeRNLjX9s4e4msc9OUZNvvuJc2BOChmt4BB3vJ3Y8jXIUzUj06SFzpjlyr4T3w+1dA0NwYgtL0ZuwkjoUmANuMp0Y/lOZWb5eAYMHeRvU46pMK89JWu/73pdVyVurbTARm0Oip6PGZ4sKjaSeG1Qu4NfmZFwIo6BHMifn11I6VM+ruod3fVfQgliMBEShynlIVSYDU5xAR8j44GjTtBRnbR17wBBXL8IoMFWLrrBz7tKedegsCFJ5/KxFS4KQc6UfKJTZ4/JWN2nrlxrMNDQjs1QJhrr5k4=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6412dcaa-48d8-4c0d-e2a7-08d640208f32
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2018 17:36:31.5179
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1499
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-11-01_12:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 1 Nov 2018, at 12:00, Omar Sandoval wrote:

> On Thu, Nov 01, 2018 at 04:29:48PM +0100, David Sterba wrote:
>>>
>>> How is that? kthread_stop() frees the task struct, so=20
>>> wake_up_process()
>>> would be a use-after-free.
>>
>> That was an assumption for the demonstration purposes, the wording=20
>> was
>> confusing sorry.
>
> Oh, well in that case, that's exactly what kthread_park() is ;) Stop=20
> the
> thread and make wake_up a noop, and then we don't need to add special
> cases everywhere else.

This is how Omar won me over to kthread_park().  I think Dave's=20
alternatives can be made correct, but Omar's way solves a whole class of=20
potential problems.  The park() makes the thread safely ignore future=20
work, and won't don't have to chase down weird bugs where people are=20
sending future work at the wrong time.

-chris
