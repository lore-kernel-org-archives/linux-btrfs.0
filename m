Return-Path: <SRS0=ca24=NC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C20C004D3
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 19:50:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7648F2064C
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 19:50:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="VsJ8rlPK";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="JNJAA8KV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7648F2064C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fb.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbeJWEJz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Oct 2018 00:09:55 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36610 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726889AbeJWEJz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Oct 2018 00:09:55 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w9MJgph5004041;
        Mon, 22 Oct 2018 12:49:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=mzXYXIxErM4QXmq0S+4uUd3yxST3zsmreXS2pRr36Uw=;
 b=VsJ8rlPKTvMdF1WAs9coJ37W4470okvRsfhMB1w0yPlOrHKXZyYKqxTn02okiz4Nwe2S
 1ncui6xASNG9wOIFFrgVbdZBiHoOG4GKYiIyGA6lnTsklSIhVcgtxrds5UnHtxRfw3ud
 WQRKr93THWXYGhzvtrO6jTjKCq1qzklB4EY= 
Received: from maileast.thefacebook.com ([199.201.65.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2n9kamrgvc-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 22 Oct 2018 12:49:53 -0700
Received: from frc-hub02.TheFacebook.com (2620:10d:c021:18::172) by
 frc-hub02.TheFacebook.com (2620:10d:c021:18::172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1531.3; Mon, 22 Oct 2018 12:49:42 -0700
Received: from FRC-CHUB08.TheFacebook.com (2620:10d:c021:18::27) by
 frc-hub02.TheFacebook.com (2620:10d:c021:18::172) with Microsoft SMTP Server
 (version=TLS1_0, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1531.3
 via Frontend Transport; Mon, 22 Oct 2018 12:49:42 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.183.28)
 by o365-in.thefacebook.com (192.168.177.28) with Microsoft SMTP Server (TLS)
 id 14.3.361.1; Mon, 22 Oct 2018 15:49:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mzXYXIxErM4QXmq0S+4uUd3yxST3zsmreXS2pRr36Uw=;
 b=JNJAA8KV1qcXk+q7rRrb9Vb2LiXpiXZm/hF8LPtCUOcOcctddIIkWECficBtLJwFyYHQy00Dv4CHLNRprrLJW7WEkp99ZySvIMI2y5zDJOx4f+ihPWahe8qcu7nxlI0+DHZQUAHEYGBDXYhKxQVgw6EDSQZf/iUnXA8Te6QXK1k=
Received: from MW2PR1501MB1993.namprd15.prod.outlook.com (52.132.149.157) by
 MW2PR1501MB2010.namprd15.prod.outlook.com (52.132.150.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1250.30; Mon, 22 Oct 2018 19:49:40 +0000
Received: from MW2PR1501MB1993.namprd15.prod.outlook.com
 ([fe80::c554:8f41:4255:796f]) by MW2PR1501MB1993.namprd15.prod.outlook.com
 ([fe80::c554:8f41:4255:796f%3]) with mapi id 15.20.1228.035; Mon, 22 Oct 2018
 19:49:40 +0000
From:   Nick Terrell <terrelln@fb.com>
To:     Daniel Kiper <dkiper@net-space.pl>
CC:     Goffredo Baroncelli <kreijack@libero.it>,
        "grub-devel@gnu.org" <grub-devel@gnu.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V10] Add support for BTRFS raid5/6 to GRUB
Thread-Topic: [PATCH V10] Add support for BTRFS raid5/6 to GRUB
Thread-Index: AQHUZwvvbJJ9n5zCI0CDZBw0UCcub6UrH22AgACTN4A=
Date:   Mon, 22 Oct 2018 19:49:40 +0000
Message-ID: <2F6AF0F1-DD4A-4406-9319-431CB1783BF5@fb.com>
References: <20181018175541.9532-1-kreijack@libero.it>
 <20181022110245.GB12705@router-fw-old.i.net-space.pl>
In-Reply-To: <20181022110245.GB12705@router-fw-old.i.net-space.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::6:758e]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MW2PR1501MB2010;20:uWOaf7Nbuohj4CX30QlbpnszHUI16mcwjD43HqPAqqppLgbq6FbHscp0jbcAyLSK4AcrFZsOHSnGsYJQabvp+ppIoTAoXCD5m01VGflGNb9+uSf39tSS6N5zzUMjBkyfYcS+Xg22xd0nqWiuekLbW1LhUfujOSUgabMZDKOwlCE=
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: 90a0aa47-8dc1-4256-4942-08d63857819d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:MW2PR1501MB2010;
x-ms-traffictypediagnostic: MW2PR1501MB2010:
x-microsoft-antispam-prvs: <MW2PR1501MB20109D136B14E52C6BD94033ABF40@MW2PR1501MB2010.namprd15.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(163750095850);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(3002001)(3231355)(11241501184)(944501410)(52105095)(10201501046)(93006095)(93001095)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123562045)(20161123564045)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:MW2PR1501MB2010;BCL:0;PCL:0;RULEID:;SRVR:MW2PR1501MB2010;
x-forefront-prvs: 08331F819E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(39860400002)(366004)(396003)(136003)(53754006)(199004)(189003)(68736007)(33656002)(316002)(305945005)(8676002)(229853002)(14454004)(86362001)(6512007)(82746002)(97736004)(6116002)(6916009)(478600001)(71190400001)(71200400001)(83716004)(5250100002)(36756003)(5660300001)(6436002)(102836004)(446003)(105586002)(8936002)(106356001)(46003)(2616005)(6506007)(4326008)(2906002)(11346002)(53546011)(2900100001)(99286004)(486006)(476003)(6486002)(186003)(81156014)(7736002)(81166006)(256004)(6246003)(53936002)(54906003)(25786009)(76176011)(14444005);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2010;H:MW2PR1501MB1993.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: nrRlGyUpeVCSDQTf47cqu+fJ7skyBJWc7OLNw2aeKW7giT+sDckUKM0nFONTtuNKyH4rU0FmUAgXEe9z9sZ+xjlZGF0D0wPTlcpR7eSBo6FOQL4dWY81cPm5FUInXTssGSNzLsjc4InWXX+/hd1B8I/mvH2m366G4d7TALZQGgyfUCaDdsp0PhLNVWBE+DdovmM5/RPva5kKbYjMxs/x6fLorICHtJVghTxyFtobnWW8ae3jZ9UPeDS12ENhk4cFVbAhfkbwhvu3/k4GQlxyNJeDCNzNQ4wYPuePAe5KT5pjSxCAa1lI+rtpC6MOM4kAlGYZZUiYZAa2Z3jx5s7hM7g/ZJ34W/vz5V1y7D9h+W0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EF8C8EACAD781840B3828C61469322CC@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 90a0aa47-8dc1-4256-4942-08d63857819d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2018 19:49:40.5820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2010
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-10-22_11:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



> On Oct 22, 2018, at 4:02 AM, Daniel Kiper <dkiper@net-space.pl> wrote:
>=20
> On Thu, Oct 18, 2018 at 07:55:32PM +0200, Goffredo Baroncelli wrote:
>>=20
>> Hi All,
>>=20
>> the aim of this patches set is to provide support for a BTRFS raid5/6
>> filesystem in GRUB.
>>=20
>> The first patch, implements the basic support for raid5/6. I.e this work=
s when
>> all the disks are present.
>>=20
>> The next 5 patches, are preparatory ones.
>>=20
>> The 7th patch implements the raid5 recovery for btrfs (i.e. handling the
>> disappearing of 1 disk).
>> The 8th patch makes the code for handling the raid6 recovery more generi=
c.
>> The last one implements the raid6 recovery for btrfs (i.e. handling the
>> disappearing up to two disks).
>>=20
>> I tested the code in grub-emu, and it works both with all the disks,
>> and with some disks missing. I checked the crc32 calculated from grub an=
d
>> from linux and these matched. Finally I checked if the support for md ra=
id6
>> still works properly, and it does (with all drives and with up to 2 driv=
es
>> missing)
>>=20
>> Comments are welcome.
>=20
> In general whole patch series LGTM. +/- some nit picks including changes
> for patch #7. If you are OK with them and there are no objections then
> I will apply the patches in a week or so.

Awesome! I'll look for the update and send an rebased version of the zstd
patch set when it is out.

-Nick=
