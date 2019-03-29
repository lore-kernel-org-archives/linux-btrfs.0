Return-Path: <SRS0=qcGt=SA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E25C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 16:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE35D206DD
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 16:39:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=PERASOTECH.onmicrosoft.com header.i=@PERASOTECH.onmicrosoft.com header.b="SMCmu/Uk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729780AbfC2Qjz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 Mar 2019 12:39:55 -0400
Received: from mail-eopbgr800089.outbound.protection.outlook.com ([40.107.80.89]:6112
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729078AbfC2Qjz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Mar 2019 12:39:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=PERASOTECH.onmicrosoft.com; s=selector1-perasotech-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hWImdPzcrvamtnMFU9+Y+rtZP8GSCeI/ekDgXf9N4pE=;
 b=SMCmu/UktZZqFfA2TKC2PGdoDiL1iomVAVnsV1OoJFI8Ict/KXQZL+COD8o4cxm9gnzc+JaQyYJl2vLmo8WUlmaZPkBwjDC1oCk27kRdvHdHD2SYlSfaArLo2kEAAxQ1XO5ax5WcP7/GjUMkyfzlDTnATw5F7Js28G66VJrIpBw=
Received: from BN6PR08MB2948.namprd08.prod.outlook.com (10.175.190.15) by
 BN6PR08MB3442.namprd08.prod.outlook.com (10.161.156.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.17; Fri, 29 Mar 2019 16:39:48 +0000
Received: from BN6PR08MB2948.namprd08.prod.outlook.com
 ([fe80::a4a3:3c6:ecbd:2ff4]) by BN6PR08MB2948.namprd08.prod.outlook.com
 ([fe80::a4a3:3c6:ecbd:2ff4%4]) with mapi id 15.20.1730.019; Fri, 29 Mar 2019
 16:39:48 +0000
From:   William Muriithi <william@perasotech.com>
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Btrfs wiki is down
Thread-Topic: Btrfs wiki is down
Thread-Index: AQHU5k1bIc9ksCMAeEaZR7DCAK2M7A==
Date:   Fri, 29 Mar 2019 16:39:48 +0000
Message-ID: <BN6PR08MB29486FF5EDEA12AF46E25C7BCE5A0@BN6PR08MB2948.namprd08.prod.outlook.com>
Accept-Language: en-CA, en-US
Content-Language: en-CA
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=william@perasotech.com; 
x-originating-ip: [75.98.192.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 938cc8f5-f740-44cb-2028-08d6b465287f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:BN6PR08MB3442;
x-ms-traffictypediagnostic: BN6PR08MB3442:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BN6PR08MB3442627AF88CFAE1D08B5998CE5A0@BN6PR08MB3442.namprd08.prod.outlook.com>
x-forefront-prvs: 0991CAB7B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(396003)(39840400004)(366004)(346002)(189003)(199004)(6116002)(6916009)(478600001)(3846002)(6306002)(966005)(55016002)(347745004)(26005)(81166006)(5640700003)(97736004)(8676002)(81156014)(105586002)(16799955002)(9686003)(99286004)(7696005)(102836004)(476003)(2351001)(33656002)(4744005)(86362001)(6506007)(256004)(68736007)(8936002)(486006)(53936002)(316002)(66066001)(52536014)(2906002)(5660300002)(14454004)(74316002)(305945005)(2501003)(7736002)(6436002)(3480700005)(186003)(25786009)(106356001)(71190400001)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR08MB3442;H:BN6PR08MB2948.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: perasotech.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mHAN2ojFDm63EwZrz2DOOt9y33enK0lAGD25C7iKiX5Vk5oTPO0+jej1I/491YOF7pG2d1ZfEymP7GQ8/yC79wEv3+qEGwsxXTdAhzJ1qR3MgYte/qv9mQcREJ/h4lDDKvFfBeeMBRJpMZzb1DM7j33qb6jFddaECnJolsik84g804r8kuaFBklHxUnvosaElVtxeuctcvElKmqcmcIKX+PnKWjSYps1lG4IoF0WT1nKMJBN04+79fPIhKFkJ68b9hzff0ZoVtZxjmw+RwFEToyRwrsNL6W+BE29Muz9NUonX+IoiNK6HpwTHgqBAyD2H9XRm2pqQNkqtUN6iQXW5PT8eXYXDFXFEjLL6SZRFg6ubeqJtE2fwfIBCny7U1M6EVvUGIm+9wUiHtoriydNXE1i75nArm3oAqRALARK7yI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: perasotech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 938cc8f5-f740-44cb-2028-08d6b465287f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2019 16:39:48.1058
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: cb425bda-8510-4152-929e-4543dc6a3af0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR08MB3442
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

SGVsbG8sDQoNCk5vdCBzdXJlIEkgc2hvdWxkIGJlIHJhaXNpbmcgdGhpcyBoZXJlLCBidXQgSSBj
YW4ndCBmaW5kIGFub3RoZXIgcmVsaWFibGUgZW1haWwuICBJIHN1c3BlY3Qgc29tZW9uZSBoZXJl
IHdvdWxkIGJlIGFibGUgdG8gcmVhY2ggb3V0IHRvIHRob3NlIHJlc3BvbnNpYmxlIGZvciB0aGUg
d2lraS4NCg0KaHR0cHM6Ly9idHJmcy53aWtpLmtlcm5lbC5vcmcvaW5kZXgucGhwL1N0YXR1cw0K
DQpUaGlzIGxpbmsgaXMgYnJva2VuLiAgV2hlbiBJIGdvIHRoZXJlLCBJIHNlZSB0aGlzIGVycm9y
Lg0KDQo9PT09PT09PT09PT09PQ0KQSBkYXRhYmFzZSBxdWVyeSBzeW50YXggZXJyb3IgaGFzIG9j
Y3VycmVkLiBUaGlzIG1heSBpbmRpY2F0ZSBhIGJ1ZyBpbiB0aGUgc29mdHdhcmUuIFRoZSBsYXN0
IGF0dGVtcHRlZCBkYXRhYmFzZSBxdWVyeSB3YXM6DQooU1FMIHF1ZXJ5IGhpZGRlbikNCmZyb20g
d2l0aGluIGZ1bmN0aW9uICJUaXRsZTo6Z2V0Q2FzY2FkZVByb3RlY3Rpb25Tb3VyY2VzIi4gRGF0
YWJhc2UgcmV0dXJuZWQgZXJyb3IgIjEyNjc6IElsbGVnYWwgbWl4IG9mIGNvbGxhdGlvbnMgKGxh
dGluMV9iaW4sSU1QTElDSVQpIGFuZCAodXRmOF9nZW5lcmFsX2NpLENPRVJDSUJMRSkgZm9yIG9w
ZXJhdGlvbiAnPScgKHBkeC13bC1sYi1kYi53ZWIuY29kZWF1cm9yYS5vcmcpIi4NCj09PT09PT09
PT09PT0NCg0KQW55IGNoYW5jZSB0aGlzIGNhbiBiZSBjb252ZXllZCB0byBzb21lb25lIHdobyBj
YW4gaGVscCBwbGVhc2U/DQoNClJlZ2FyZHMsDQpXaWxsaWFtLA0K4oCL
