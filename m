Return-Path: <SRS0=yGwK=MV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C845C64EAD
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 15:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3F8F213A2
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 15:11:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3F8F213A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=distech-controls.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbeJIW3Q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 18:29:16 -0400
Received: from mx0b-002ab301.pphosted.com ([148.163.154.99]:34096 "EHLO
        mx0b-002ab301.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726393AbeJIW3Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Oct 2018 18:29:16 -0400
X-Greylist: delayed 1386 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Oct 2018 18:29:15 EDT
Received: from pps.filterd (m0118795.ppops.net [127.0.0.1])
        by mx0b-002ab301.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w99EinfX015849
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Oct 2018 10:48:52 -0400
Received: from nam01-sn1-obe.outbound.protection.outlook.com (mail-sn1nam01lp0114.outbound.protection.outlook.com [207.46.163.114])
        by mx0b-002ab301.pphosted.com with ESMTP id 2n0g0h8qpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Oct 2018 10:48:52 -0400
Received: from BN6PR01MB2531.prod.exchangelabs.com (10.173.140.137) by
 BN6PR01MB2308.prod.exchangelabs.com (10.173.27.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.23; Tue, 9 Oct 2018 14:48:50 +0000
Received: from BN6PR01MB2531.prod.exchangelabs.com
 ([fe80::bcbd:a4b3:97bb:5938]) by BN6PR01MB2531.prod.exchangelabs.com
 ([fe80::bcbd:a4b3:97bb:5938%7]) with mapi id 15.20.1207.024; Tue, 9 Oct 2018
 14:48:50 +0000
From:   "Gervais, Francois" <FGervais@distech-controls.com>
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: CoW behavior when writing same content
Thread-Topic: CoW behavior when writing same content
Thread-Index: AdRf3YHSLPfE6AzkQyO9REl1pcuNUQ==
Date:   Tue, 9 Oct 2018 14:48:50 +0000
Message-ID: <BN6PR01MB2531060A61AD3B85A93DF82CF3E70@BN6PR01MB2531.prod.exchangelabs.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mib-plugin: true
x-originating-ip: [207.253.3.19]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BN6PR01MB2308;6:JNSGBzQT69qvNbB+sGZvlBPWnEf1s0XYOdrVbzWVpE4StPttsGCol3AdStYuw29lhM4QfQAip30YwkMcFNFeETV3nvQJBqfbCqHpVhhuFJlKSu22UG/ESs8EuJw1eSLZlxqAlRonX7p9ziH2ksk1VtZ5+vpQhYqUouAG9224DFwR5yYgyx6h6jVoOL3TqiHbs/HZYnl/5+sryzjtqCzAAm8fxfBYN/ix0y7btWvNtGezXWOygvo80GXxf5O7H6S/Bqgn4CsR4obLnKwHpmmLoIu3WjGlJ67k0dYZd5F/bVKtNjHdN1IelbU5KoDoiId3KwEFUD1iG9dPjh8XcA/OLK8Ql/harDG1bp+QclSdNEmsSbUuCHkPgp0XDta7OpFa4WIr3ESo1xXmgK3EtgqREkc7wQpL6/BD2YBsHCrvpuaC7WEAfaseljXXkx8EOPk4OXqHuV68ISqQ2yCTno+U3A==;5:1ZTa28PcXGN/0Q6psPk/EIPyptjgu3GNU+ztB+7lxwL0Ft0S71lfPClAwUnMVVZhLRCDWJSgsnhPNY8iPcGeFyRxqM5ePSdGk8CP93uDpJt5ad6taGtML1bHHbCyzFGN00kdSCecovRbPrHEKhBXIQjAQL/6pMb/Mm9jWYo7oQk=;7:pqWNy60+w8KGnInThUD4mIbS94rOZ0Ic5NaoDh0HNeCzlC9aE5xbxxT0eaxrNq7t9ZGCB/EK2ez/lAsGeVEbWKwQUHVfGC33BRmSdYK2sFmQV6qyMP3ARQivVY6AAtGlJvcBxOO7caeL3cBOFF2FNeQpYk5i002/pQ8gvLBEBq80aBrRN9uyVBzsYHibmmNWVg/nBYmi/FY/CjdrkzIdETnNMPzdEVmoTVz2RhbvswnhYdt2PuNrNkKj0XSXYxRL
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: 15c720dd-7ffe-431e-ff20-08d62df65383
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BN6PR01MB2308;
x-ms-traffictypediagnostic: BN6PR01MB2308:
x-microsoft-antispam-prvs: <BN6PR01MB230817F03D722AFE8C06E9BFF3E70@BN6PR01MB2308.prod.exchangelabs.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(3002001)(10201501046)(93006095)(93001095)(6055026)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123564045)(20161123558120)(20161123562045)(201708071742011)(7699051);SRVR:BN6PR01MB2308;BCL:0;PCL:0;RULEID:;SRVR:BN6PR01MB2308;
x-forefront-prvs: 08200063E9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(396003)(346002)(39860400002)(136003)(199004)(189003)(5250100002)(6916009)(66066001)(97736004)(102836004)(478600001)(81156014)(81166006)(53936002)(8676002)(186003)(55016002)(316002)(7736002)(26005)(80792005)(9686003)(68736007)(5640700003)(2351001)(2501003)(33656002)(71200400001)(14454004)(71190400001)(256004)(106356001)(5660300001)(305945005)(25786009)(2906002)(99286004)(74316002)(2900100001)(72206003)(7696005)(6116002)(6436002)(8936002)(86362001)(486006)(3846002)(6506007)(105586002)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR01MB2308;H:BN6PR01MB2531.prod.exchangelabs.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: distech-controls.com does not
 designate permitted sender hosts)
x-microsoft-antispam-message-info: GGQgm2v/8ugsOljICdaCsI/8Azpbfl1jGMyI0v9Tmcd81AkQZ9P+Wl+JGvMD2JP5wgxEA4dKOKfs14p8ZNphSXBmAZA6LGQsjIMguMtsYO2n7SnetT8RAIWXxCAZTwqUsCPIE+vPqXG2Z8h0U4CVh1PXm93zaQkh2Rxz0Jp0YJDkrBnsCTOVvljv1vGMRegM53t+Djqzm4Z40eyucv//MlBsbFQw1cN8SSZaW8awyNYeYas+3q/xpRXRivUoP7oQfaz7++sisaQXR+3khyMif4dmZI1+T7tBa/QhZY/8z7ewADfY5+kmutT9Yzfs17Pb2oRXsAP0lxZrQnomSGZvd8glgRuIpPCvt4mFgCiqEV0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: distech-controls.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15c720dd-7ffe-431e-ff20-08d62df65383
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2018 14:48:50.3856
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: caadbe96-024e-4f67-82ec-fb28ff53d16d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR01MB2308
X-Proofpoint-Processed: True
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=757 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1807170000
 definitions=main-1810090145
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

SGksDQoNCklmIEkgaGF2ZSBhIHNuYXBzaG90IHdoZXJlIEkgb3ZlcndyaXRlIGEgYmlnIGZpbGUg
YnV0IHdoaWNoIG9ubHkgYQ0Kc21hbGwgcG9ydGlvbiBvZiBpdCBpcyBkaWZmZXJlbnQsIHdpbGwg
dGhlIHdob2xlIGZpbGUgYmUgcmV3cml0dGVuIGluDQp0aGUgc25hcHNob3Q/IE9yIG9ubHkgdGhl
IGRpZmZlcmVudCBwYXJ0IG9mIHRoZSBmaWxlPw0KDQpTb21ldGhpbmcgbGlrZToNCg0KJCBkZCBp
Zj0vZGV2L3VyYW5kb20gb2Y9L2JpZ19maWxlIGJzPTFNIGNvdW50PTEwMjQNCiQgY3AgL2JpZ19m
aWxlIHJvb3QvDQokIGJ0cmZzIHN1YiBzbmFwIHJvb3Qgc25hcHNob3QNCiQgY3AgL2JpZ19maWxl
IHNuYXBzaG90Lw0KDQpJbiB0aGlzIGNhc2UgaXMgcm9vdC9iaWdfZmlsZSBhbmQgc25hcHNob3Qv
YmlnX2ZpbGUgc3RpbGwgc2hhcmUgdGhlIHNhbWUgZGF0YT8NCg0KVGhhbmsgeW91DQo=
