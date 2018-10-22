Return-Path: <SRS0=ca24=NC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B771DC004D3
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 20:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 195E720652
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 20:02:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 195E720652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=distech-controls.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727701AbeJWEWF convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Oct 2018 00:22:05 -0400
Received: from mx0b-002ab301.pphosted.com ([148.163.154.99]:2178 "EHLO
        mx0b-002ab301.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725758AbeJWEWF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Oct 2018 00:22:05 -0400
Received: from pps.filterd (m0118797.ppops.net [127.0.0.1])
        by mx0b-002ab301.pphosted.com (8.16.0.23/8.16.0.23) with SMTP id w9MJsuaY012884
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2018 16:02:09 -0400
Received: from nam05-co1-obe.outbound.protection.outlook.com (mail-co1nam05lp0088.outbound.protection.outlook.com [216.32.181.88])
        by mx0b-002ab301.pphosted.com with ESMTP id 2n80ug29ns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2018 16:02:08 -0400
Received: from BN6PR01MB2531.prod.exchangelabs.com (10.173.140.137) by
 BN6PR01MB2418.prod.exchangelabs.com (10.173.139.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1250.30; Mon, 22 Oct 2018 20:02:06 +0000
Received: from BN6PR01MB2531.prod.exchangelabs.com
 ([fe80::18c5:efa8:4acb:7af4]) by BN6PR01MB2531.prod.exchangelabs.com
 ([fe80::18c5:efa8:4acb:7af4%3]) with mapi id 15.20.1250.028; Mon, 22 Oct 2018
 20:02:06 +0000
From:   "Gervais, Francois" <FGervais@distech-controls.com>
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Filesystem corruption?
Thread-Topic: Filesystem corruption?
Thread-Index: AdRqQScURx/j8YEDSfa9k77C1ex8Ww==
Date:   Mon, 22 Oct 2018 20:02:06 +0000
Message-ID: <BN6PR01MB2531B41C0F7A49D2DBF001C1F3F40@BN6PR01MB2531.prod.exchangelabs.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mib-plugin: true
x-originating-ip: [207.253.3.19]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BN6PR01MB2418;6:RRQ//Dt0l23KeKM4zxojjgbtV342OKq66tIRiGG8eDx1eRLmNFaBpYjnwm9GeNqvmTAKBTpMTEpNciZOnIFDIs/zwaHr+C5qtSSWcdYnz/vm8RlbvqaS06EcCPj/c/C+6B+ulzr/5NBlUxD0D8ROhjlGxmBIP+I2te3WAedXFdSiD5oC0miDJp4VpJjMmX5vt7ycQtYITP+8+ZASjZMbFJ9gNGTwmrmDJxhqMht0xbVlSQCuX+/MhuVdXoMMuJe1fqEKNt3LrXjkKYfdlhzz0tMUYqnyUcBNrglQoDDKxypeDTvbz30FxyzEpx43v/or2/Fg/28FLCL6zJFcmNHbV6qMJMgRMvS6w/+qMLlTVuqvrjPqimehJPz8C/MxkVBrYA1TRUcCTdMA5MwAnovTSdi5Kc0xE8cP2p83u73ImY1wnW/LTl7aO3mt7cQKA4+e7dZ/CvIy0CLEidXqDz5egQ==;5:AHMggsQQDpOpoP5yEtKap31ij/YnInJPMMmmg4lRd9xNMfbHVfslSReOAQIFdJBlpIi2nnJ6oqDv4mJd3f3uJIgO6q8c6rC9WjI3qcmqfcclilxR7AgT4YXbPcaxxWOTS2HYWOBM/fJC/VnJQcx1KYfuAR6e1TAPqi7C1DBM/Gk=;7:tppHd3kPcSRdHiTSefSATICCquDhvqQ7Grhareivs4ewTzMMeQLrsk2y0FlwQflUPxhOW48+vnmPHtQ2xeC2cqXOSDX4KW9QMXF7y3a5SrlgSzVEDvwM1vQj+YHBfMIE8wMvSA1rXVUHm4QWFQkvR0uZBSqocRzUIsv5Uww5/kQtibXtuWJKdDs+VTp2U/ji+IoLX/4Z3SlcXkUrGtHKLaYqVHBaHHC/fCVvquuP+RNFblv8IQQemCwnMLt3VayY
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: cfa59577-b39d-49de-cb60-08d638593e22
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BN6PR01MB2418;
x-ms-traffictypediagnostic: BN6PR01MB2418:
x-microsoft-antispam-prvs: <BN6PR01MB2418F3541CE4B1CE8D20DCD6F3F40@BN6PR01MB2418.prod.exchangelabs.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3231355)(944501410)(52105095)(3002001)(6055026)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BN6PR01MB2418;BCL:0;PCL:0;RULEID:;SRVR:BN6PR01MB2418;
x-forefront-prvs: 08331F819E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(189003)(199004)(68736007)(86362001)(5250100002)(5640700003)(2906002)(9686003)(256004)(97736004)(55016002)(6436002)(80792005)(2501003)(99286004)(33656002)(102836004)(26005)(7696005)(6506007)(66066001)(6916009)(8676002)(81166006)(8936002)(7116003)(81156014)(2900100001)(25786009)(14454004)(3480700004)(106356001)(72206003)(2351001)(74316002)(105586002)(3846002)(305945005)(6116002)(7736002)(53936002)(5660300001)(71200400001)(71190400001)(186003)(14444005)(478600001)(476003)(486006)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR01MB2418;H:BN6PR01MB2531.prod.exchangelabs.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: distech-controls.com does not
 designate permitted sender hosts)
x-microsoft-antispam-message-info: 0nFU/6xXLIJMtYdYbG01+Rm4rZ6QCHRGbUSx2NZAM1k/8D/27gED9YP5kTFmK3iX996c4au2DX8611G6y6L73s4er0oij1IpjAu/ytJaBRIuzDAJWY4yzEv4te9QTYoQH3DCtbwvre9jdGvo3Fhysedpwdx1ho0+ZCLDZ1znSeSCDKQaRL2p0qMf87CXvRuo82d0URU0/J7o3KRB/6FaSiABh3A5jaymjHCQAlCWIvGmITURqJQIderHFMPROO7nx6txYusaU5dRFtHphMbQ8GpyR5DsTVjfIkSazZx+bKHcptlu9JNisQ1gR5xq/Os+5d9ISFy5WWmoeNhOPx8Vq6x92D+EZDhuoOLZixEWBkg=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: distech-controls.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfa59577-b39d-49de-cb60-08d638593e22
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2018 20:02:06.4747
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: caadbe96-024e-4f67-82ec-fb28ff53d16d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR01MB2418
X-Proofpoint-Processed: True
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=887 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1807170000
 definitions=main-1810220170
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

I think I lost power on my btrfs disk and it looks like it is now in an unfunctional state.

Any idea how I could debug that issue?

Here is what I have:

kernel 4.4.0-119-generic
btrfs-progs v4.4



sudo btrfs check /dev/sdd
Checking filesystem on /dev/sdd
UUID: 9a14b7a1-672c-44da-b49a-1f6566db3e44
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
checking quota groups
Ignoring qgroup relation key 310
Ignoring qgroup relation key 311
Ignoring qgroup relation key 313
Ignoring qgroup relation key 321
Ignoring qgroup relation key 326
Ignoring qgroup relation key 346
Ignoring qgroup relation key 354
Ignoring qgroup relation key 355
Ignoring qgroup relation key 356
Ignoring qgroup relation key 367
Ignoring qgroup relation key 370
Ignoring qgroup relation key 371
Ignoring qgroup relation key 373
Ignoring qgroup relation key 71213169107796323
Ignoring qgroup relation key 71213169107796323
Ignoring qgroup relation key 71494644084506935
Ignoring qgroup relation key 71494644084506935
Ignoring qgroup relation key 71494644084506937
Ignoring qgroup relation key 71494644084506937
Ignoring qgroup relation key 71494644084506945
Ignoring qgroup relation key 71494644084506945
Ignoring qgroup relation key 71494644084506950
Ignoring qgroup relation key 71494644084506950
Ignoring qgroup relation key 71494644084506970
Ignoring qgroup relation key 71494644084506970
Ignoring qgroup relation key 71494644084506978
Ignoring qgroup relation key 71494644084506978
Ignoring qgroup relation key 71494644084506978
Ignoring qgroup relation key 71494644084506980
Ignoring qgroup relation key 71494644084506980
Ignoring qgroup relation key 71494644084506991
Ignoring qgroup relation key 71494644084506991
Ignoring qgroup relation key 71494644084506994
Ignoring qgroup relation key 71494644084506994
Ignoring qgroup relation key 71494644084506995
Ignoring qgroup relation key 71494644084506995
Ignoring qgroup relation key 71494644084506997
Ignoring qgroup relation key 71494644084506997
Ignoring qgroup relation key 71776119061217590
Ignoring qgroup relation key 71776119061217590
Ignoring qgroup relation key 71776119061217590
Ignoring qgroup relation key 71776119061217590
Ignoring qgroup relation key 71776119061217590
Ignoring qgroup relation key 71776119061217590
Ignoring qgroup relation key 71776119061217590
Ignoring qgroup relation key 71776119061217590
Ignoring qgroup relation key 71776119061217590
Ignoring qgroup relation key 71776119061217590
Ignoring qgroup relation key 71776119061217590
Ignoring qgroup relation key 71776119061217590
found 29301522460 bytes used err is 0
total csum bytes: 27525424
total tree bytes: 541573120
total fs tree bytes: 494223360
total extent tree bytes: 16908288
btree space waste bytes: 85047903
file data blocks allocated: 273892241408
 referenced 44667650048
extent buffer leak: start 29360128 len 16384
extent buffer leak: start 740524032 len 16384
extent buffer leak: start 446840832 len 16384
extent buffer leak: start 142819328 len 16384
extent buffer leak: start 143179776 len 16384
extent buffer leak: start 184107008 len 16384
extent buffer leak: start 190513152 len 16384
extent buffer leak: start 190939136 len 16384
extent buffer leak: start 239943680 len 16384
extent buffer leak: start 29392896 len 16384
extent buffer leak: start 295223296 len 16384
extent buffer leak: start 30556160 len 16384
extent buffer leak: start 29376512 len 16384
extent buffer leak: start 29409280 len 16384
extent buffer leak: start 29491200 len 16384
extent buffer leak: start 29556736 len 16384
extent buffer leak: start 29720576 len 16384
extent buffer leak: start 29884416 len 16384
extent buffer leak: start 30097408 len 16384
extent buffer leak: start 30179328 len 16384
extent buffer leak: start 30228480 len 16384
extent buffer leak: start 30277632 len 16384
extent buffer leak: start 30343168 len 16384
extent buffer leak: start 30392320 len 16384
extent buffer leak: start 30457856 len 16384
extent buffer leak: start 30507008 len 16384
extent buffer leak: start 30572544 len 16384
extent buffer leak: start 30621696 len 16384
extent buffer leak: start 30670848 len 16384
extent buffer leak: start 30720000 len 16384
extent buffer leak: start 30769152 len 16384
extent buffer leak: start 30801920 len 16384
extent buffer leak: start 30867456 len 16384
extent buffer leak: start 30916608 len 16384
extent buffer leak: start 102498304 len 16384
extent buffer leak: start 204488704 len 16384
extent buffer leak: start 237912064 len 16384
extent buffer leak: start 328499200 len 16384
extent buffer leak: start 684539904 len 16384
extent buffer leak: start 849362944 len 16384
