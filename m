Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A4A9C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 02:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEE342086B
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 02:56:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="FjDMhZc9";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="DNBhtzk1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DEE342086B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fb.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbeK0NwU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 08:52:20 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36536 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728089AbeK0NwU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 08:52:20 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wAR2slOq024192;
        Mon, 26 Nov 2018 18:55:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=458kOmJfsgjYil4GISLVrqJseKjdHtEFBqiTcgS38eE=;
 b=FjDMhZc9xNm3cJy4hcxlUEKm8QzLlAha65tig+qtn7Eq+nwU+5cxHR6YsrCuYXIArptN
 ewBv/dZPAmqPhhjUJexOd5LT6oKc7kEutC5PQHPp7eDHsxxUGN+xYS4XJQISwWkokTsh
 ssYT9GpcG9F1cg5bEYeCnIlol911papUmNE= 
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2p0ug78aqv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 26 Nov 2018 18:55:41 -0800
Received: from prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1531.3; Mon, 26 Nov 2018 18:55:35 -0800
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1531.3; Mon, 26 Nov 2018 18:55:35 -0800
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1531.3
 via Frontend Transport; Mon, 26 Nov 2018 18:55:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=458kOmJfsgjYil4GISLVrqJseKjdHtEFBqiTcgS38eE=;
 b=DNBhtzk1/ICF6afBYELAAHYyTuGiAeU2I85ONA4sUXQH+YVALoWlTzQGIrtJRRcqMRGw6g3rDxOv3rp4IGewBn5QBB6gcxmgnUBS8y3ilJTEf3Tmc8ry3CIapRZ6r2RDo9oJzq6/Yt1ujczPRwrJq9oYXPUqjmm1NkU7SvWgjpE=
Received: from MW2PR1501MB1993.namprd15.prod.outlook.com (52.132.149.157) by
 MW2PR1501MB1994.namprd15.prod.outlook.com (52.132.149.158) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1361.14; Tue, 27 Nov 2018 02:55:34 +0000
Received: from MW2PR1501MB1993.namprd15.prod.outlook.com
 ([fe80::f8d1:59bf:c5a8:1e8]) by MW2PR1501MB1993.namprd15.prod.outlook.com
 ([fe80::f8d1:59bf:c5a8:1e8%5]) with mapi id 15.20.1361.019; Tue, 27 Nov 2018
 02:55:33 +0000
From:   Nick Terrell <terrelln@fb.com>
To:     Daniel Kiper <dkiper@net-space.pl>
CC:     David Sterba <dsterba@suse.cz>, Kernel Team <Kernel-team@fb.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        "grub-devel@gnu.org" <grub-devel@gnu.org>
Subject: Re: [PATCH v7 0/2] btrfs: Add zstd support to grub btrfs
Thread-Topic: [PATCH v7 0/2] btrfs: Add zstd support to grub btrfs
Thread-Index: AQHUgDzqdSqlN0uMt0KvDZNgh7aFGKVXjfsAgAtq3QA=
Date:   Tue, 27 Nov 2018 02:55:33 +0000
Message-ID: <4AA367FE-A601-4F1D-A37B-F85F86D31E94@fb.com>
References: <20181119192008.3496427-1-terrelln@fb.com>
 <20181119203412.rsd2wbx7nc7enpax@tomti.i.net-space.pl>
In-Reply-To: <20181119203412.rsd2wbx7nc7enpax@tomti.i.net-space.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::6:2024]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MW2PR1501MB1994;20:AFnk4PI0bytycODNbqCQnE9Ii5nG1NkcTBfJ04DnFoNP6mMkK2ecWQCWV3+dXuQUV49MopeyugxfiVeAK7BiqsCnjZiR+mjMI+UP9IVjGUDVnUvB2oRI7KkP+Of9a85YQDUzBooCn9Iq6L33prSJQPFgksOa/mFyw8wjSzKaszI=
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: 543cf897-c6ee-418f-06f8-08d65413ccfd
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:MW2PR1501MB1994;
x-ms-traffictypediagnostic: MW2PR1501MB1994:
x-microsoft-antispam-prvs: <MW2PR1501MB19942E84DFD38549A5FF5127ABD00@MW2PR1501MB1994.namprd15.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(823302103)(93006095)(93001095)(3231443)(11241501185)(944501410)(52105112)(10201501046)(3002001)(148016)(149066)(150057)(6041310)(20161123562045)(20161123564045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:MW2PR1501MB1994;BCL:0;PCL:0;RULEID:;SRVR:MW2PR1501MB1994;
x-forefront-prvs: 086943A159
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(346002)(39860400002)(136003)(366004)(189003)(199004)(53754006)(6512007)(76176011)(68736007)(53936002)(86362001)(53546011)(345774005)(6506007)(97736004)(102836004)(6116002)(105586002)(106356001)(2906002)(25786009)(316002)(478600001)(99286004)(54906003)(81166006)(6916009)(81156014)(8676002)(8936002)(229853002)(82746002)(36756003)(5660300001)(33656002)(256004)(83716004)(71190400001)(71200400001)(46003)(6436002)(6486002)(446003)(11346002)(2616005)(486006)(476003)(186003)(14454004)(7736002)(305945005)(4326008)(6246003)(17423001);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB1994;H:MW2PR1501MB1993.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: YyzZu5BhwjF5fd0iRPH/DkjZEkywJ4A5BDubdFjKfSUGriBYHVL+H4EJUBkTYvCOA60B9E5iHR58KRiTSJlHvn2m6KhKLbQK+s7UaiaEzVC7eWefgL3l++WPMzw3V1PVJJBLuzfnNhqkU+/EgwVIyayFY4C7aJv3rIqBYOaTEW7FeNQvNpWocQukqymUlrIGxw2Ho3JqCw018j+AX/q6VPg/GubnteuKETJ6ymIl5F7k92hRu/XAOa5pZy2B0yQZc29SDDDrCBMJ0/PAbnusViJW8WTP5J0t1x5KvmWfMGzHbtm++68o24lECdQUdWZu9esgXWj9068dJYRXHHkEvef475UufpRUCoplAxA9wOU=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <93C84E33CC0E224AB55B397A423C0FB8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 543cf897-c6ee-418f-06f8-08d65413ccfd
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2018 02:55:33.8269
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB1994
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-11-27_03:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



> On Nov 19, 2018, at 12:34 PM, Daniel Kiper <dkiper@net-space.pl> wrote:
>=20
> On Mon, Nov 19, 2018 at 11:20:06AM -0800, Nick Terrell wrote:
>> Hi all,
>>=20
>> This patch set imports the upstream zstd library, adds zstd support to t=
he
>> btrfs module, and adds a test case. I've also tested the patch set by st=
oring
>> my boot partition in btrfs with and without zstd compression and rebooti=
ng.
>=20
> LGTM. I will apply both patches in a week or so.
>=20
> Thank you for doing the work.
>=20
> Daniel


Thanks for taking the time to review and merge the patches, and for
maintaining GRUB!

Nick

