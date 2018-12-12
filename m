Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F4F1C65BAF
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 17:56:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F19DC20839
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 17:56:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="E43rh/zd";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="EE67yDzS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F19DC20839
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fb.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbeLLR4F (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 12:56:05 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38852 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727880AbeLLR4E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 12:56:04 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id wBCHo6tk003772;
        Wed, 12 Dec 2018 09:55:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=4XjW0stMQkgeJVb9JLcZ6JjDELdKODVGhVM7h6bcCjw=;
 b=E43rh/zdOmWaazM25odJczgRiWcXdtTBqJjZ6lx+eeWKVlGq59zvv3lretGGdkCHJNly
 7wyg8remeyxGp6KLZoKRufGEoZQSAzmQiWDvX+cEVKXg2an+B3fsN8Q2pcQVHi/8yGI2
 pfszUXbKSkeBYWDDDTcfY/DyZbPxfJQzQ9c= 
Received: from maileast.thefacebook.com ([199.201.65.23])
        by m0001303.ppops.net with ESMTP id 2pb58b0ewr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Dec 2018 09:55:47 -0800
Received: from frc-hub01.TheFacebook.com (2620:10d:c021:18::171) by
 frc-hub01.TheFacebook.com (2620:10d:c021:18::171) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1531.3; Wed, 12 Dec 2018 09:55:45 -0800
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (192.168.183.28)
 by o365-in.thefacebook.com (192.168.177.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1531.3
 via Frontend Transport; Wed, 12 Dec 2018 09:55:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4XjW0stMQkgeJVb9JLcZ6JjDELdKODVGhVM7h6bcCjw=;
 b=EE67yDzSuf/UB2X9gAbyloTiW0ayKgQshLlKVlBBssoGlTyh6Kuqpe3ZhYpVW51k3zJ5uy3Yl3/EzbZQBO4nsNlElFkOunVvlAjqhiyZBU1x9qGUc47rfuK/ZAts2JH8Ytl1ZKxoISvdv+NAX1ANweL1ZHR+SyiY47jD8SyeAvw=
Received: from DM5PR15MB1883.namprd15.prod.outlook.com (10.174.247.135) by
 DM5PR15MB1689.namprd15.prod.outlook.com (10.175.112.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1404.20; Wed, 12 Dec 2018 17:55:43 +0000
Received: from DM5PR15MB1883.namprd15.prod.outlook.com
 ([fe80::f8d4:7c44:756a:6205]) by DM5PR15MB1883.namprd15.prod.outlook.com
 ([fe80::f8d4:7c44:756a:6205%12]) with mapi id 15.20.1404.026; Wed, 12 Dec
 2018 17:55:43 +0000
From:   Chris Mason <clm@fb.com>
To:     David Sterba <dsterba@suse.cz>
CC:     Martin Raiber <martin@urbackup.org>,
        Ethan Lien <ethanlien@synology.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs: balance dirty metadata pages in
 btrfs_finish_ordered_io
Thread-Topic: [PATCH v2] btrfs: balance dirty metadata pages in
 btrfs_finish_ordered_io
Thread-Index: AQHT9keZ7Z3eAayDI0yo6F7kEUsUfaV8Es4AgABdrQCAAAPMAIAAJvMA
Date:   Wed, 12 Dec 2018 17:55:43 +0000
Message-ID: <7F58631F-D0C7-4B22-91FA-DE5125A64D29@fb.com>
References: <20180528054821.9092-1-ethanlien@synology.com>
 <D7645E04-6424-4BFA-90C6-D63245EB9435@fb.com>
 <01020167a30347da-385e2eff-ed13-422a-b27f-c3d5933aaef2-000000@eu-west-1.amazonses.com>
 <20181212153616.GY23615@twin.jikos.cz>
In-Reply-To: <20181212153616.GY23615@twin.jikos.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: MailMate (1.12.2r5568)
x-clientproxiedby: BN6PR2201CA0034.namprd22.prod.outlook.com
 (2603:10b6:405:5e::47) To DM5PR15MB1883.namprd15.prod.outlook.com
 (2603:10b6:4:4f::7)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c091:180::1:e9ce]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM5PR15MB1689;20:0Ox40sfIYujgrr4aCP8EkqOxiAPlqygkYF3RJoez4MxljLX9WgvnE9FQnYJhY20lDL7hfaETDZQPaxhx9EOX/FAwrqj9KtVB7tdZH9caiBW8w4bo9lU9trHcabqdFOTuYLvI2pXbsNfqLXRZW6jeujnMSqhZYku9a6NuKCCohDQ=
x-ms-office365-filtering-correlation-id: 9f81692e-e282-4040-e133-08d6605b091b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM5PR15MB1689;
x-ms-traffictypediagnostic: DM5PR15MB1689:
x-microsoft-antispam-prvs: <DM5PR15MB168935CA033D9AA1734657A7D3A70@DM5PR15MB1689.namprd15.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(3230017)(999002)(11241501185)(6040522)(2401047)(8121501046)(5005006)(3231472)(944501520)(52105112)(3002001)(10201501046)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(20161123562045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:DM5PR15MB1689;BCL:0;PCL:0;RULEID:;SRVR:DM5PR15MB1689;
x-forefront-prvs: 0884AAA693
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(39860400002)(366004)(136003)(396003)(189003)(199004)(476003)(53936002)(53546011)(11346002)(2616005)(25786009)(8676002)(81156014)(52116002)(93886005)(486006)(81166006)(316002)(99286004)(8936002)(76176011)(6436002)(186003)(6246003)(446003)(4326008)(97736004)(229853002)(82746002)(86362001)(6512007)(46003)(305945005)(50226002)(7736002)(6506007)(256004)(5660300001)(71200400001)(83716004)(6916009)(36756003)(71190400001)(6486002)(14454004)(54906003)(33656002)(478600001)(105586002)(6116002)(106356001)(386003)(102836004)(2906002)(68736007)(14143004)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1689;H:DM5PR15MB1883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: eIb6ey3kvzzuVce5Yx4nzjATjFUHWOQwf1B9GzRKU3U4VMSwsB7IvmcK+RR5s3VXMmK07GXTX+5EMEnyoRvxM9amYNkMx7VWziOnJMHQPs0sUKDihRjmoG7UUfifh8MuUK/MkucUw30bCulMJC/9HHtPpULVkTbIlaoJOeqQh/6ug4Y0Ur9wGzGQBPvv27SrV5uN5b86E0pY0YwvUIBt4i8si2hHl09t2LRuajY9qdoMXkBtGrimghlpTzAf6qRwB5aS1o6mNERiMnF7h9Slr8sqtejwdyIsukprhEVTR3vudCZ5zFAuo4u0MlS8Nu/k
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f81692e-e282-4040-e133-08d6605b091b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2018 17:55:43.3708
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1689
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-12-12_04:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 12 Dec 2018, at 10:36, David Sterba wrote:

> On Wed, Dec 12, 2018 at 03:22:40PM +0000, Martin Raiber wrote:
>> On 12.12.2018 15:47 Chris Mason wrote:
>>> On 28 May 2018, at 1:48, Ethan Lien wrote:
>>>
>>> Eventually, we have every process in the system waiting on
>>> balance_dirty_pages(), and nobody is able to make progress on page
>>> writeback.
>>>
>> I had lockups with this patch as well. If you put e.g. a loop device=20
>> on
>> top of a btrfs file, loop sets PF_LESS_THROTTLE to avoid a feed back
>> loop causing delays. The task balancing dirty pages in
>> btrfs_finish_ordered_io doesn't have the flag and causes slow-downs.=20
>> In
>> my case it managed to cause a feedback loop where it queues other
>> btrfs_finish_ordered_io and gets stuck completely.
>
> This does not look like the artificial and hard to hit case that's in
> the original patch. I'm thinking about sending a revert to 4.20-rc6,=20
> the
> deadlock is IMO worse than OOM.

I haven't been able to trigger the OOM this morning.  Ethan, is this=20
something you can still hit on upstream kernels with the=20
balance_dirty_pages() removed?

-chris
