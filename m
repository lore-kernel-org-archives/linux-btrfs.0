Return-Path: <SRS0=qcGt=SA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98F1CC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 17:21:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 675D32183F
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 17:21:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=PERASOTECH.onmicrosoft.com header.i=@PERASOTECH.onmicrosoft.com header.b="EfaVFfwf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729725AbfC2RVN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 Mar 2019 13:21:13 -0400
Received: from mail-eopbgr740043.outbound.protection.outlook.com ([40.107.74.43]:43023
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729662AbfC2RVN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Mar 2019 13:21:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=PERASOTECH.onmicrosoft.com; s=selector1-perasotech-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+RC5GpyfnoImIH9xmpB+u0Zu2SBVoHHqgU3zioyHhy0=;
 b=EfaVFfwflrzOPDpaPVG60JwemhhHjgAOZvB/W/MexDEF1XNXe8JWb6Wi24Hx4EW3Z1+f5DBnYS8diOdIANy9dW0CE6dNNEc3+ZHXM7jN8ZfWs3Vra18imyw6vlqInD6Pqz3/rGdFXgPkUZ9ByD4uxx0eaa3qHDP60xHzalpN0OA=
Received: from BN6PR08MB2948.namprd08.prod.outlook.com (10.175.190.15) by
 BN6PR08MB2434.namprd08.prod.outlook.com (10.168.225.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.16; Fri, 29 Mar 2019 17:21:10 +0000
Received: from BN6PR08MB2948.namprd08.prod.outlook.com
 ([fe80::a4a3:3c6:ecbd:2ff4]) by BN6PR08MB2948.namprd08.prod.outlook.com
 ([fe80::a4a3:3c6:ecbd:2ff4%4]) with mapi id 15.20.1730.019; Fri, 29 Mar 2019
 17:21:10 +0000
From:   William Muriithi <william@perasotech.com>
To:     Hugo Mills <hugo@carfax.org.uk>
CC:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs wiki is down
Thread-Topic: Btrfs wiki is down
Thread-Index: AQHU5k1bIc9ksCMAeEaZR7DCAK2M7KYi0QCAgAAHE2A=
Date:   Fri, 29 Mar 2019 17:21:09 +0000
Message-ID: <BN6PR08MB29489DF5023B1E4E10D36091CE5A0@BN6PR08MB2948.namprd08.prod.outlook.com>
References: <BN6PR08MB29486FF5EDEA12AF46E25C7BCE5A0@BN6PR08MB2948.namprd08.prod.outlook.com>,<20190329164523.GJ27856@carfax.org.uk>
In-Reply-To: <20190329164523.GJ27856@carfax.org.uk>
Accept-Language: en-CA, en-US
Content-Language: en-CA
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=william@perasotech.com; 
x-originating-ip: [75.98.192.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 029c0cfa-a272-438b-4f37-08d6b46aefb9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600127)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BN6PR08MB2434;
x-ms-traffictypediagnostic: BN6PR08MB2434:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <BN6PR08MB24343F7A3BB9812D4383FA6DCE5A0@BN6PR08MB2434.namprd08.prod.outlook.com>
x-forefront-prvs: 0991CAB7B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39840400004)(396003)(376002)(366004)(346002)(199004)(189003)(76176011)(4744005)(55016002)(5660300002)(6916009)(25786009)(476003)(4326008)(446003)(86362001)(3846002)(6116002)(2906002)(33656002)(66066001)(11346002)(186003)(97736004)(26005)(102836004)(99286004)(6506007)(486006)(3480700005)(7696005)(71200400001)(71190400001)(966005)(14454004)(9686003)(6306002)(347745004)(478600001)(8676002)(68736007)(7736002)(229853002)(256004)(105586002)(16799955002)(74316002)(52536014)(305945005)(6436002)(6246003)(106356001)(81156014)(316002)(81166006)(53936002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR08MB2434;H:BN6PR08MB2948.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: perasotech.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CMU9u5aQXGruPsPRtnNrFjvxwLqn7cDrltIy0TIxq1C+SsqAxe/BxNxwQnKr6TLqTSx0xoi7+Sry85ss1AHb+CKsDKIEB9SSJmcanyMfqKoOzzm3BeqkZMQR5Fxteh9Rj+V762hHFRwg/0SYqS5CE+DEtXgj6mYRWplu/+S2Lvly1qhFyMXhxFalmPYKrDP3CHh/SqoKJBpuc7syyB+tCbeqJKpS+xR3kC53ApPkude+fOGjLWKYNGiIt9QrcvgZgmScFRmtrmya4tefMiO48TLjz8noUkcSjKL33C5/WLvCIDLRTifaRrHmCwzuHpiqnq3zcwUNn8mPt0VlCbU+/Co/169NY2W6r7cq8H70i1EkEo/Aw0SnkDxF2A+I/m8H/8ulb9X9ZBBjNz3GQdTV7xm9JzRktmSonOCGQQbEec4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: perasotech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 029c0cfa-a272-438b-4f37-08d6b46aefb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2019 17:21:09.9154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: cb425bda-8510-4152-929e-4543dc6a3af0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR08MB2434
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Hugo

>>
>> Not sure I should be raising this here, but I can't find another reliabl=
e email.  I suspect someone here would be able to reach out to those respon=
sible for the wiki.
>>
>> https://btrfs.wiki.kernel.org/index.php/Status
>
>   It's working for me. Maybe it was a transient while someone was
>fiddling with it, that's already been fixed?

Hmm, it is indeed up.  I had saved the link on a file and just realized it =
had some hidden text.  This is what I actually used initially.

https://btrfs.wiki.kernel.org/index.php/Status%E2%80%8B

I think it should fail with a 404 error instead of the current mysql connec=
tion issue error.

Regards,
William

