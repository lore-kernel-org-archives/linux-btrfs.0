Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D874C0044C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 13:31:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDD282081B
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 13:31:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="OCy+2uuN";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="WgXxVBZl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDD282081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fb.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbeKAWex (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Nov 2018 18:34:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41388 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727644AbeKAWex (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Nov 2018 18:34:53 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wA1DS7r8026492;
        Thu, 1 Nov 2018 06:31:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=C7WwzCMagNliNYTZxJRx2QxlJkEU0h6NTN090xUD9wc=;
 b=OCy+2uuNRtjkYFSn+ZjRmA5+j5eCvhsROKbh7gOHHo3HwQaCn7cfiHBRTWbZVmn4ZoOm
 HGd+L0jsfOef/w2zsoYU1reGNsm8k3wLxPEDjjRsyjHWPAe/it+CkRbeyrdrNwV15moY
 ekP5kxZtid+dxhWvXIoi6WWfiLPzI/ngW8Y= 
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2nfyqy8duc-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 01 Nov 2018 06:31:50 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1531.3; Thu, 1 Nov 2018 06:31:36 -0700
Received: from PRN-CHUB03.TheFacebook.com (2620:10d:c081:35::12) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_0, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1531.3
 via Frontend Transport; Thu, 1 Nov 2018 06:31:36 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.13) with Microsoft SMTP Server (TLS)
 id 14.3.361.1; Thu, 1 Nov 2018 06:31:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C7WwzCMagNliNYTZxJRx2QxlJkEU0h6NTN090xUD9wc=;
 b=WgXxVBZlaIoRe7+1lvEf4m1+AAnO3diN0qimJHFbIAGnkmXBl5jhmx1HaRClp249Qgro4LZ61kYNyucuCs3Uen9T/uj0CodPLvtM1EPGvEk4K5tN2WghzDHnzqq2Pi6or4b19OGINpOXP//PIBkJ75DqXkgLfpoBhuUyoGxmmoI=
Received: from DM5PR15MB1883.namprd15.prod.outlook.com (10.174.247.135) by
 DM5PR15MB1356.namprd15.prod.outlook.com (10.173.224.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.23; Thu, 1 Nov 2018 13:31:18 +0000
Received: from DM5PR15MB1883.namprd15.prod.outlook.com
 ([fe80::6023:3276:3d78:5943]) by DM5PR15MB1883.namprd15.prod.outlook.com
 ([fe80::6023:3276:3d78:5943%2]) with mapi id 15.20.1294.021; Thu, 1 Nov 2018
 13:31:18 +0000
From:   Chris Mason <clm@fb.com>
To:     David Sterba <dsterba@suse.cz>
CC:     Omar Sandoval <osandov@osandov.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "Nikolay Borisov" <nborisov@suse.com>
Subject: Re: [PATCH v2] Btrfs: fix missing delayed iputs on unmount
Thread-Topic: [PATCH v2] Btrfs: fix missing delayed iputs on unmount
Thread-Index: AQHUcTwZPa2h/8BmYk2L46nyuVb3XqU6tSwAgAA2r4A=
Date:   Thu, 1 Nov 2018 13:31:18 +0000
Message-ID: <2DCF4F92-0B05-420C-ADEB-3A7A69F6DB37@fb.com>
References: <5d98091d3e089b4f74cb61fb2ed691e1f4dd1d6b.1541005462.git.osandov@fb.com>
 <20181101101532.GL9136@twin.jikos.cz>
In-Reply-To: <20181101101532.GL9136@twin.jikos.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: MailMate (1.10r5443)
x-clientproxiedby: BN6PR03CA0071.namprd03.prod.outlook.com
 (2603:10b6:404:4c::33) To DM5PR15MB1883.namprd15.prod.outlook.com
 (2603:10b6:4:4f::7)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c091:180::1:ebf4]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM5PR15MB1356;20:mQmCPzJNHavFPuVjbSNA55f3tEXYidg9y42Pgeg34cLrx4rqISQ+2811FkR9KMCZnIO6WzCo1l3sew7MBoBg7ZXIdQ0ItB1IO7rEWXqZqoLitgDLFJiK1DphhA3rhS/vULjCSBhiES19LpfTkbstrOGvk0XunBHBjIsJbfYn7EA=
x-ms-office365-filtering-correlation-id: 2b712162-5f79-4e2c-ec5d-08d63ffe4dc9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM5PR15MB1356;
x-ms-traffictypediagnostic: DM5PR15MB1356:
x-microsoft-antispam-prvs: <DM5PR15MB135664AE11099F1BDF0350C6D3CE0@DM5PR15MB1356.namprd15.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(67672495146484);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(823302103)(93006095)(93001095)(10201501046)(3002001)(3231382)(11241501184)(944501410)(52105095)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:DM5PR15MB1356;BCL:0;PCL:0;RULEID:;SRVR:DM5PR15MB1356;
x-forefront-prvs: 0843C17679
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(39860400002)(136003)(346002)(366004)(199004)(189003)(316002)(36756003)(186003)(229853002)(25786009)(14454004)(478600001)(54906003)(256004)(14444005)(83716004)(71200400001)(71190400001)(6916009)(81156014)(5660300001)(4326008)(6486002)(8676002)(5250100002)(81166006)(86362001)(53936002)(6512007)(11346002)(446003)(6436002)(476003)(486006)(2616005)(8936002)(6116002)(76176011)(46003)(105586002)(2900100001)(82746002)(106356001)(305945005)(7736002)(6246003)(68736007)(33656002)(50226002)(2906002)(97736004)(6506007)(53546011)(99286004)(52116002)(102836004)(386003)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1356;H:DM5PR15MB1883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: ZSN+wyafFgqxA0krIv3RpRhM1ErYpq0v04eiuMz9us2QzWBtsGxvMzf4YWiemK+drFLWNBCSkRKqt7l2LajdgcCuIB94UGV+AK5Q/06oIWa1JFfdoa8/jXQYDFIS6ioOutbfzNK5rRUCuvhdAIj/doUxJjO6YgnRpVGSehBQe4tbA+yf7D3RusoT/J/dvdIfd08sD9tcFMIwurbtxenYc92zwJlTArGIxsQ0KnDwCi23OwjOizkeYUJXQwtVGPyQF4LUixjALwgV0RDQ32zOiM5ynvHXLjyP1GlNRMdif1/SbCLSI8tY5QuOR0qKmnMPVg23K6ryqW76ql2dxIZrQKbUGNs/YZqGzRNXYTmQePA=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b712162-5f79-4e2c-ec5d-08d63ffe4dc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2018 13:31:18.2048
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1356
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-11-01_09:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 1 Nov 2018, at 6:15, David Sterba wrote:

> On Wed, Oct 31, 2018 at 10:06:08AM -0700, Omar Sandoval wrote:
>> From: Omar Sandoval <osandov@fb.com>
>>
>> There's a race between close_ctree() and cleaner_kthread().
>> close_ctree() sets btrfs_fs_closing(), and the cleaner stops when it
>> sees it set, but this is racy; the cleaner might have already checked
>> the bit and could be cleaning stuff. In particular, if it deletes=20
>> unused
>> block groups, it will create delayed iputs for the free space cache
>> inodes. As of "btrfs: don't run delayed_iputs in commit", we're no
>> longer running delayed iputs after a commit. Therefore, if the=20
>> cleaner
>> creates more delayed iputs after delayed iputs are run in
>> btrfs_commit_super(), we will leak inodes on unmount and get a busy
>> inode crash from the VFS.
>>
>> Fix it by parking the cleaner
>
> Ouch, that's IMO wrong way to fix it. The bug is on a higher level,
> we're missing a commit or clean up data structures. Messing with state
> of a thread would be the last thing I'd try after proving that it's=20
> not
> possible to fix in the logic of btrfs itself.
>
> The shutdown sequence in close_tree is quite tricky and we've had bugs
> there. The interdependencies of thread and data structures and other
> subsystems cannot have loops that could not find an ordering that will
> not leak something.
>
> It's not a big problem if some step is done more than once, like
> committing or cleaning up some other structures if we know that
> it could create new.

The problem is the cleaner thread needs to be told to stop doing new=20
work, and we need to wait for the work it's already doing to be=20
finished.  We're getting "stop doing new work" already because the=20
cleaner thread checks to see if the FS is closing, but we don't have a=20
way today to wait for him to finish what he's already doing.

kthread_park() is basically the same as adding another mutex or=20
synchronization point.  I'm not sure how we could change close_tree() or=20
the final commit to pick this up more effectively?

-chris

