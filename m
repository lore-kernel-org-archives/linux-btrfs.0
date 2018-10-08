Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3950C6787A
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 23:51:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0269F213A2
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 23:51:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="UlIhUJDS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0269F213A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbeJIHFv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 03:05:51 -0400
Received: from mail-eopbgr50084.outbound.protection.outlook.com ([40.107.5.84]:15592
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725759AbeJIHFu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Oct 2018 03:05:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0uBndI6d83KKt5Febeeyj6UQcHuaDy9YlltlBq3nmo=;
 b=UlIhUJDSHW8FKikx0Y5fmtu2E/fZdYOuDVwZ5nIP07gpSoM/tjwfh69QWDAZb3x42Xx8qANCVHG0D9wgM2NHe8OjAlwp4dWlH8F6tVk5pprv8emt90DgDBM+2RnfK3X6wgmBsB8UZEwlSW3tN8Sw9scQHvPzj65kX0+2s4H1qVo=
Received: from AM0PR06MB3921.eurprd06.prod.outlook.com (52.133.57.29) by
 AM0PR06MB4627.eurprd06.prod.outlook.com (20.178.18.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.27; Mon, 8 Oct 2018 23:51:35 +0000
Received: from AM0PR06MB3921.eurprd06.prod.outlook.com
 ([fe80::5063:8a39:67e0:5e0a]) by AM0PR06MB3921.eurprd06.prod.outlook.com
 ([fe80::5063:8a39:67e0:5e0a%3]) with mapi id 15.20.1207.024; Mon, 8 Oct 2018
 23:51:35 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/6] Chunk allocator DUP fix and cleanups
Thread-Topic: [PATCH 0/6] Chunk allocator DUP fix and cleanups
Thread-Index: AQHUXCmOSBgrE/nJs0WTXuGELqo9PaUQSCoAgABVpoCABE5AgIAAkBAAgACPNIA=
Date:   Mon, 8 Oct 2018 23:51:35 +0000
Message-ID: <30de5b09-55a0-ecd8-0814-2aa932c0d8c4@mendix.com>
References: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
 <10a9b7c4-861d-c6f6-b17b-56fa7a5ba5b8@gmx.com>
 <a75d50c8-fb1a-8dc5-80c8-77acc7c4e4d0@mendix.com>
 <b6bb9348-1cb3-4870-4a6b-8758c1250290@gmx.com>
 <3f82acbe-5b66-1a00-880f-645883a581df@mendix.com>
In-Reply-To: <3f82acbe-5b66-1a00-880f-645883a581df@mendix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
x-originating-ip: [2001:980:4a41:fb::12]
x-clientproxiedby: AM0PR05CA0017.eurprd05.prod.outlook.com
 (2603:10a6:208:55::30) To AM0PR06MB3921.eurprd06.prod.outlook.com
 (2603:10a6:208:b2::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM0PR06MB4627;6:s9M42qEFNP/NsijESSF5YaNfuqB+wF0VkVtNbl+sfvrnv5H/tmJ033dlLEE+mFrNsbSzrHDRBMCYOu9Xh9wBFFiXJ4C0c5oUm19v5Wd2oKPh5E3MrJZKSy21Fzi4CbhxPgA+nr3+6i95Xq0rOCaxVkdfyWSRHt8xPH6eWsePCOiEcyAyFKLXml/azHR8B6HBIvVYGDTW+OnYHvebP2z9/r5mKpwf5zlDGvP9Wi9HeXSx3t4uESXvH0EoSPdWeGWjyrex8B9H26uhOq010U1TBgN9XMCYRtVuX6cbSrE0Vb+kMsgmIBu5mWA/4FKFUcFtbr2JhcSx0yqsovXYl7oJ0FOqzUYM5V6EQ6VnfqtQcFjHfUMdOEZD6RTU3KK/ReJjAi3rd9Qe/9Z3MgmDjmKSfhcxL+Fay3Bwx83Jwdiv9ixxbpLjSiGlUmRf0etI3uFcvWvSUx30suqe3wiFFeh1Pg==;5:SQDLiyGCsE08S2HtN5Ef1OFXSJlSylNisOXwtqN03Muto7kRniIZKFZX6/0UI26xRNn83BymBrQvVKd/M8Mh2TmQmcIyWxUeyLqmLWJ3eilYt/95wjJfl3H/MoA4NScEhGjWZbfpeKBd6JzrmdEljWzCYn+lxzPyeszvZ1vCzQc=;7:ujEGfv99vgq4AmzHtrLylw4g003a0jz+AdERsbQGmSs/QlZlLDcokrYd9NlczUyX9oF6K4xpXVBjBl/Uq29lbihdF5R5tEMqlIKJ1v9RFWtWtpEu+jAmtGhwFSqSaRw7mi6VPN/3vb/BOunfG0K3p8RTjUVwhiOntlL7x9GxUAIkmqgzC0JeyMbOQWY/vbWQq48p93+GT6a8gzXXVzPGvbvbZAkTKdDAw/aBV19LazbyQA7C0Es1StywdV5nngi7
x-ms-office365-filtering-correlation-id: 1c14f4b5-618e-485e-ab25-08d62d78fb18
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(49563074)(7193020);SRVR:AM0PR06MB4627;
x-ms-traffictypediagnostic: AM0PR06MB4627:
x-microsoft-antispam-prvs: <AM0PR06MB46277542222568E122139B38D4E60@AM0PR06MB4627.eurprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(102415395)(6040522)(2401047)(5005006)(8121501046)(3002001)(10201501046)(3231355)(944501410)(4983020)(4982022)(52105095)(93006095)(93001095)(149066)(150057)(6041310)(20161123560045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123558120)(201708071742011)(7699051)(76991055);SRVR:AM0PR06MB4627;BCL:0;PCL:0;RULEID:;SRVR:AM0PR06MB4627;
x-forefront-prvs: 081904387B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(376002)(136003)(366004)(346002)(396003)(189003)(199004)(2616005)(1720100001)(446003)(11346002)(93886005)(6506007)(386003)(476003)(53546011)(551934003)(102836004)(186003)(71200400001)(71190400001)(316002)(46003)(6486002)(6436002)(25786009)(229853002)(65826007)(5660300001)(53936002)(6512007)(6306002)(110136005)(2906002)(58126008)(305945005)(64126003)(68736007)(7736002)(81166006)(81156014)(8676002)(8936002)(97736004)(5250100002)(2501003)(6246003)(105586002)(6116002)(52116002)(106356001)(76176011)(31686004)(65956001)(65806001)(36756003)(99286004)(486006)(2900100001)(19627235002)(14454004)(4744004)(72206003)(99936001)(31696002)(86362001)(478600001)(966005)(575784001)(14444005)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR06MB4627;H:AM0PR06MB3921.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: opCwSEExsfRd/hnYlLxn4FSyg38rz6p2QE1cfn3HVgRGrvDIzt4HGV2v8Xh55IO4ZkzUk6FYLOUnZuUoHIzW0z4OtKEg0X7kMW6Ep3veF0uuM70hqyTaOF7GxjqCWZ7kNUSpxW9+KxfhdN/j28fttx3lqkbUP1Pr2qWM+gfltC6sZw9tvfnQ7ooe6H9OccvK6WKGpzYu5n3/Mb+X/jhLQ5J/fLPPMFAsWHydrZEOxjYZ9pNz9xQUZH7XXuuwJC9XjGwEFRqcQOIPzDvlBt5C8UdN5RsToiw31ceXNR0BQ+hzihie3fxiJO6Nbf17bTErs18Nueei5Y68zKAKXljtV+EDBVD+lKtsIna4UjiU2Mk=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="goh1VTdirJQpJ8sxzJrOpdXKNQc3xz8eo"
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c14f4b5-618e-485e-ab25-08d62d78fb18
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2018 23:51:35.6700
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR06MB4627
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

--goh1VTdirJQpJ8sxzJrOpdXKNQc3xz8eo
Content-Type: multipart/mixed; boundary="rok0cN4syZQ8VV3yqpMwqn0cf0pQCQqyp";
 protected-headers="v1"
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <30de5b09-55a0-ecd8-0814-2aa932c0d8c4@mendix.com>
Subject: Re: [PATCH 0/6] Chunk allocator DUP fix and cleanups
References: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
 <10a9b7c4-861d-c6f6-b17b-56fa7a5ba5b8@gmx.com>
 <a75d50c8-fb1a-8dc5-80c8-77acc7c4e4d0@mendix.com>
 <b6bb9348-1cb3-4870-4a6b-8758c1250290@gmx.com>
 <3f82acbe-5b66-1a00-880f-645883a581df@mendix.com>
In-Reply-To: <3f82acbe-5b66-1a00-880f-645883a581df@mendix.com>

--rok0cN4syZQ8VV3yqpMwqn0cf0pQCQqyp
Content-Type: text/plain; charset=utf-8
Content-Language: en_US
Content-Transfer-Encoding: quoted-printable

On 10/08/2018 03:19 PM, Hans van Kranenburg wrote:
> On 10/08/2018 08:43 AM, Qu Wenruo wrote:
>>
>>
>> On 2018/10/5 =E4=B8=8B=E5=8D=886:58, Hans van Kranenburg wrote:
>>> On 10/05/2018 09:51 AM, Qu Wenruo wrote:
>>>>
>>>>
>>>> On 2018/10/5 =E4=B8=8A=E5=8D=885:24, Hans van Kranenburg wrote:
>>>>> This patch set contains an additional fix for a newly exposed bug a=
fter
>>>>> the previous attempt to fix a chunk allocator bug for new DUP chunk=
s:
>>>>>
>>>>> https://lore.kernel.org/linux-btrfs/782f6000-30c0-0085-abd2-74ec582=
7c903@mendix.com/T/#m609ccb5d32998e8ba5cfa9901c1ab56a38a6f374
>>>>
>>>> For that bug, did you succeeded in reproducing the bug?
>>>
>>> Yes, open the above link and scroll to "Steps to reproduce".
>>
>> That's beyond device boundary one. Also reproduced here.
>> And hand-crafted a super small image as test case for btrfs-progs.
>>
>> But I'm a little curious about the dev extent overlapping case.
>> Have you got one?
>=20
> Ah ok, I see. No, I didn't do that yet.
>=20
> By using unmodified tooling, I think this can be done by a combination
> of a few resizings and using very specific balance to cause a fs of
> exactly 7880MiB again with a single 1578MiB gap inside...
>=20
> I'll try later today to see if I can come up with a recipe for this.

Ok, this is actually pretty simple to do:

---- >8 ----

-# mkdir bork
-# cd bork
-# dd if=3D/dev/zero of=3Dimage bs=3D1 count=3D0 seek=3D1024M
0+0 records in
0+0 records out
0 bytes copied, 0.000183343 s, 0.0 kB/s
-# mkfs.btrfs -d dup -m dup image
-# losetup -f image
-# mount -o space_cache=3Dv2 /dev/loop0 mountpoint
-# dd if=3D/dev/zero of=3Dmountpoint/flapsie bs=3D1M
dd: error writing 'mountpoint/flapsie': No space left on device
453+0 records in
452+0 records out
474185728 bytes (474 MB, 452 MiB) copied, 4.07663 s, 116 MB/s

---- >8 ----

-# ./show_usage.py /bork/mountpoint/
Target profile for SYSTEM (chunk tree): DUP
Target profile for METADATA: DUP
Target profile for DATA: DUP
Mixed groups: False

Virtual space usage by block group type:
|
| type                    total         used
| ----                    -----         ----
| Data                452.31MiB    452.22MiB
| System                8.00MiB     16.00KiB
| Metadata             51.19MiB    656.00KiB

Total raw filesystem size: 1.00GiB
Total raw allocated bytes: 1023.00MiB
Allocatable bytes remaining: 1.00MiB
Unallocatable raw bytes: 0.00B
Unallocatable bytes that can be reclaimed by balancing: 0.00B

Estimated virtual space left to use for metadata: 51.05MiB
Estimated virtual space left to use for data: 96.00KiB

Allocated raw disk bytes by chunk type. Parity is a reserved part of the
allocated bytes, limiting the amount that can be used for data or metadat=
a:
|
| flags               allocated         used       parity
| -----               ---------         ----       ------
| DATA|DUP            904.62MiB    904.44MiB        0.00B
| SYSTEM|DUP           16.00MiB     32.00KiB        0.00B
| METADATA|DUP        102.38MiB      1.28MiB        0.00B

Allocated bytes per device:
|
| devid      total size    allocated path
| -----      ----------    --------- ----
| 1             1.00GiB   1023.00MiB /dev/loop0

Allocated bytes per device, split up per chunk type. Parity bytes are aga=
in
part of the total amount of allocated bytes.
|
| Device ID: 1
| | flags               allocated       parity
| | -----               ---------       ------
| | DATA|DUP            904.62MiB        0.00B
| | SYSTEM|DUP           16.00MiB        0.00B
| | METADATA|DUP        102.38MiB        0.00B

Unallocatable raw bytes per device:
|
| devid    unallocatable
| -----    -------------
| 1               0.00B

---- >8 ----

Now we're gonna cause some neat 1578MiB to happen that we're going to
free up later to reproduce the failure:

-# dd if=3D/dev/zero of=3Dimage bs=3D1 count=3D0 seek=3D2602M
0+0 records in
0+0 records out
0 bytes copied, 0.000188621 s, 0.0 kB/s
-# losetup -c /dev/loop0
-# btrfs fi resize max mountpoint/
Resize 'mountpoint/' of 'max'
-# dd if=3D/dev/zero of=3Dmountpoint/1578MiB bs=3D1M
dd: error writing 'mountpoint/1578MiB': No space left on device
790+0 records in
789+0 records out
827326464 bytes (827 MB, 789 MiB) copied, 12.2452 s, 67.6 MB/s

---- >8 ----

-# python3
import btrfs
fs =3D btrfs.FileSystem('/bork/mountpoint/')
for d in fs.dev_extents():
  print("start {} end {} vaddr {}".format(d.paddr, d.paddr + d.length,
d.vaddr))

start 1048576 end 11534336 vaddr 547880960
start 11534336 end 22020096 vaddr 547880960
start 22020096 end 30408704 vaddr 22020096
start 30408704 end 38797312 vaddr 22020096
start 38797312 end 92471296 vaddr 30408704
start 92471296 end 146145280 vaddr 30408704
start 146145280 end 213254144 vaddr 84082688
start 213254144 end 280363008 vaddr 84082688
start 280363008 end 397803520 vaddr 151191552
start 397803520 end 515244032 vaddr 151191552
start 515244032 end 632684544 vaddr 268632064
start 632684544 end 750125056 vaddr 268632064
start 750125056 end 867565568 vaddr 386072576
start 867565568 end 985006080 vaddr 386072576
start 985006080 end 1029373952 vaddr 503513088
start 1029373952 end 1073741824 vaddr 503513088
start 1073741824 end 1358954496 vaddr 558366720
start 1358954496 end 1644167168 vaddr 558366720
start 1644167168 end 1929379840 vaddr 843579392
start 1929379840 end 2214592512 vaddr 843579392
start 2214592512 end 2471493632 vaddr 1128792064
start 2471493632 end 2728394752 vaddr 1128792064

The last three block groups were just added, using up the new space:

for vaddr in (558366720, 843579392, 1128792064):
  print(fs.block_group(vaddr))

block group vaddr 558366720 length 285212672 flags DATA|DUP used
285212672 used_pct 100
block group vaddr 843579392 length 285212672 flags DATA|DUP used
285212672 used_pct 100
block group vaddr 1128792064 length 256901120 flags DATA|DUP used
256901120 used_pct 100

By the way.. for the first and second time (to do the writeup) I did
this, extent allocation looks like paste linked below O_o... I have no
idea where the pattern with decreasing sizes the first time is coming
from, and no idea why the second time all the data is being stored in
144KiB extents...

http://paste.debian.net/plainh/537bdd95

---- >8 ----

Ok, now let's extend the disk to our famous number of 7880M

-# dd if=3D/dev/zero of=3Dimage bs=3D1 count=3D0 seek=3D7880M
0+0 records in
0+0 records out
0 bytes copied, 0.000185768 s, 0.0 kB/s
-# losetup -c /dev/loop0
-# btrfs fi resize max mountpoint/
Resize 'mountpoint/' of 'max'

-# ./show_usage.py /bork/mountpoint/
[...]
Total raw filesystem size: 7.70GiB
Total raw allocated bytes: 2.54GiB
Allocatable bytes remaining: 5.16GiB
[...]

-# dd if=3D/dev/zero of=3Dmountpoint/bakkiepleur bs=3D1M
dd: error writing 'mountpoint/bakkiepleur': No space left on device
2384+0 records in
2383+0 records out
2498756608 bytes (2.5 GB, 2.3 GiB) copied, 34.1946 s, 73.1 MB/s

-# ./show_usage.py /bork/mountpoint/
Target profile for SYSTEM (chunk tree): DUP
Target profile for METADATA: DUP
Target profile for DATA: DUP
Mixed groups: False

Virtual space usage by block group type:
|
| type                    total         used
| ----                    -----         ----
| Data                  3.54GiB      3.54GiB
| System                8.00MiB     16.00KiB
| Metadata            307.19MiB    102.05MiB

Total raw filesystem size: 7.70GiB
Total raw allocated bytes: 7.69GiB
Allocatable bytes remaining: 1.00MiB
Unallocatable raw bytes: 0.00B
Unallocatable bytes that can be reclaimed by balancing: 0.00B

Estimated virtual space left to use for metadata: 205.64MiB
Estimated virtual space left to use for data: 0.00B

Allocated raw disk bytes by chunk type. Parity is a reserved part of the
allocated bytes, limiting the amount that can be used for data or metadat=
a:
|
| flags               allocated         used       parity
| -----               ---------         ----       ------
| DATA|DUP              7.08GiB      7.08GiB        0.00B
| SYSTEM|DUP           16.00MiB     32.00KiB        0.00B
| METADATA|DUP        614.38MiB    204.09MiB        0.00B

Allocated bytes per device:
|
| devid      total size    allocated path
| -----      ----------    --------- ----
| 1             7.70GiB      7.69GiB /dev/loop0

Allocated bytes per device, split up per chunk type. Parity bytes are aga=
in
part of the total amount of allocated bytes.
|
| Device ID: 1
| | flags               allocated       parity
| | -----               ---------       ------
| | DATA|DUP              7.08GiB        0.00B
| | SYSTEM|DUP           16.00MiB        0.00B
| | METADATA|DUP        614.38MiB        0.00B

Unallocatable raw bytes per device:
|
| devid    unallocatable
| -----    -------------
| 1               0.00B

---- >8 ----

Now, generating the gap in the physical is as simple as dropping the
1578MiB file and triggering a transaction commit to clean up empty block
groups:

-# rm mountpoint/1578MiB
-# btrfs fi sync mountpoint/

for d in fs.dev_extents():
  print("start {} end {} vaddr {}".format(d.paddr, d.paddr + d.length,
d.vaddr))

start 1048576 end 11534336 vaddr 547880960
start 11534336 end 22020096 vaddr 547880960
start 22020096 end 30408704 vaddr 22020096
start 30408704 end 38797312 vaddr 22020096
start 38797312 end 92471296 vaddr 30408704
start 92471296 end 146145280 vaddr 30408704
start 146145280 end 213254144 vaddr 84082688
start 213254144 end 280363008 vaddr 84082688
start 280363008 end 397803520 vaddr 151191552
start 397803520 end 515244032 vaddr 151191552
start 515244032 end 632684544 vaddr 268632064
start 632684544 end 750125056 vaddr 268632064
start 750125056 end 867565568 vaddr 386072576
start 867565568 end 985006080 vaddr 386072576
start 985006080 end 1029373952 vaddr 503513088
start 1029373952 end 1073741824 vaddr 503513088

  [558366720, 843579392 and 1128792064 are gone]

start 2728394752 end 3567255552 vaddr 1385693184
start 3567255552 end 4406116352 vaddr 1385693184
start 4406116352 end 5244977152 vaddr 2224553984
start 5244977152 end 6083837952 vaddr 2224553984
start 6083837952 end 6352273408 vaddr 3063414784
start 6352273408 end 6620708864 vaddr 3063414784
start 6620708864 end 7441743872 vaddr 3331850240
start 7441743872 end 8262778880 vaddr 3331850240

-# ./show_usage.py /bork/mountpoint/
[...]
Allocatable bytes remaining: 1.54GiB
[...]

---- >8 ----

And then...

-# dd if=3D/dev/zero of=3Dmountpoint/omgwtfbbq bs=3D1M
dd: error writing 'mountpoint/omgwtfbbq': No space left on device
801+0 records in
800+0 records out
838860800 bytes (839 MB, 800 MiB) copied, 12.6689 s, 66.2 MB/s

We happily write 800MiB(!), destroying the first 22MiB of the device
extent at 2728394752...

for d in fs.dev_extents():
  print("start {} end {} vaddr {}".format(d.paddr, d.paddr + d.length,
d.vaddr))

[...]
start 1912602624 end 2751463424 vaddr 4152885248
start 2728394752 end 3567255552 vaddr 1385693184
[...]

import btrfs
fs =3D btrfs.FileSystem('/bork/mountpoint/')
paddr =3D 1912602624
tree =3D btrfs.ctree.DEV_TREE_OBJECTID
devid =3D 1
for header, data in btrfs.ioctl.search_v2(fs.fd, tree, key, key):
  btrfs.utils.pretty_print(btrfs.ctree.DevExtent(header, data))

<btrfs.ctree.DevExtent (1 DEV_EXTENT 1912602624)>
devid: 1 (key objectid)
paddr: 1912602624 (key offset)
length: 838860800
chunk_offset: 4152885248
uuid: 00000000-0000-0000-0000-000000000000
chunk_objectid: 256
chunk_tree: 3

Ouch!

-# ./show_usage.py /bork/mountpoint/

[...]
Total raw filesystem size: 7.70GiB
Total raw allocated bytes: 7.72GiB
Allocatable bytes remaining: 0.00B
Unallocatable raw bytes: -22020096.00B
[...]

---- >8 ----

And now more fun:

-# btrfs scrub status mountpoint/
scrub status for 1f7a998a-4ea3-4117-8b42-9d0e6f1d3b4c
	scrub started at Tue Oct  9 01:35:30 2018 and finished after 00:00:13
	total bytes scrubbed: 6.52GiB with 0 errors

But that's probably because it's all data from /dev/zero...

-# btrfs check /dev/loop0
Checking filesystem on /dev/loop0
UUID: 1f7a998a-4ea3-4117-8b42-9d0e6f1d3b4c
checking extents
Device extent[1, 2728394752, 838860800] existed.
Chunk[256, 228, 1385693184] stripe[1, 2728394752] dismatch dev extent[1,
1912602624, 838860800]
Dev extent's total-byte(7445938176) is not equal to
byte-used(8284798976) in dev[1, 216, 1]
ERROR: errors found in extent allocation tree or chunk allocation
checking free space tree
checking fs roots
checking only csum items (without verifying data)
checking root refs
found 3917824000 bytes used, error(s) found
total csum bytes: 3722464
total tree bytes: 106020864
total fs tree bytes: 48955392
total extent tree bytes: 48644096
btree space waste bytes: 1428937
file data blocks allocated: 3811803136
 referenced 3811803136

This one actually already detects that something is wrong.

--=20
Hans van Kranenburg


--rok0cN4syZQ8VV3yqpMwqn0cf0pQCQqyp--

--goh1VTdirJQpJ8sxzJrOpdXKNQc3xz8eo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEESWyddwNaG9637koYssHfcmNhX2wFAlu77YYACgkQssHfcmNh
X2zxkQ/+J/fSZGMvydnfspslQeXlz2WJnDY7rxPOFBmV/vxfTbo/JQNhgJPwqZpe
Bd4a8jkYz1h8Hdi6P6SLHsd0dz4/vjsQe44yFb/R2xYLeLyAwwzLeKeZtdsO9XZ9
MZYzVb3/H04UiRp4K6vE0lyIT1A8lTVZ8vGkA/GOCFoYypRQ4eqpTVSKIAj769As
J1+gJbCxGt9noTgaSTOWrrTOkcX+z64zs3QaHp2ZyR9kyLAC9p4caKz/HW3iTZ/Z
9iZ/m61Yvi6TVPYBX1glLjFG7zCDpUirN8PcLh4apCBFPrfOATQ1PcbpV5QZbS9G
Nla039YuSgY1tiH0quaYVdNfA4KIYC8Yzw3u9LaekfZfDdhFGy6/7SAbMxDtIEYK
P2TOt83yru2NzQPL+KgFBmoSCYNS9kioVlE/+oTIHbIKgdmZES/NaRZgd3Nkj9vW
yOTjAkWR68Y71moh3IF2tvv/y+rY8y5H6VQFhnQQTiJ6SOWnBmLeAQfE9t0yPlqj
jMn2YGvL0aZQKt9V0r21KJwN8CayJmbKQJuqzAbONfqIlpxyTdYItqPIrHw2zuZp
lBi6qeZ834u48HcpOAfu00cXFzT4F0sRG7oIfxl1Q5NXEiIdGE3cFVi6To5rDPgp
2d37M9mwH73/G8LiOmYDpavPjehHg9tHXkqCN38DznlMxBUTI6M=
=IE5E
-----END PGP SIGNATURE-----

--goh1VTdirJQpJ8sxzJrOpdXKNQc3xz8eo--
