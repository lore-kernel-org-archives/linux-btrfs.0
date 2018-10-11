Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86085C677FF
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 18:03:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C22F2054F
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 18:03:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="YFnxeRaY";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="Km/glppB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C22F2054F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fb.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbeJLBcC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 21:32:02 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37972 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726093AbeJLBcC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 21:32:02 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w9BI3NeS028571;
        Thu, 11 Oct 2018 11:03:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=H2Nzr2+8s+4N5MqMU6xhW3U9GiRMAE0UapNxEBnhP94=;
 b=YFnxeRaYrAodwUP+msc5Rl636BbOyFO+y5S0ldquwRn8/nPjq/3eP5vS62nfXbyF5NR0
 fHk6BpgOYfEfse3w/mu58JfQxl/qebuAoXYo8w7fGfEf+2FuL5/MGdrNEye7VSVvC1e2
 pdEAOyi3dlok+TAbrfpBnZTtV49qj4BPUMk= 
Received: from maileast.thefacebook.com ([199.201.65.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2n2ay9g3au-10
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Thu, 11 Oct 2018 11:03:25 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.183.28)
 by o365-in.thefacebook.com (192.168.177.27) with Microsoft SMTP Server (TLS)
 id 14.3.361.1; Thu, 11 Oct 2018 14:02:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H2Nzr2+8s+4N5MqMU6xhW3U9GiRMAE0UapNxEBnhP94=;
 b=Km/glppBpxx4CKDs/6fbqjgzKI4GCF6Tt+4VQTJP9DYgSMiess5MYt9yFbn3x/cILWygygrlexSySE2VAZRiPXdBo2bODZ8jeDWF7qTe1nRkQuMYwqDqIvLqMn+uOKLoaFWpXXQvDrvi0UGR5FwRTcFG5QF2iXgFC8TagFMzoW4=
Received: from MW2PR1501MB1993.namprd15.prod.outlook.com (52.132.149.157) by
 MW2PR1501MB2155.namprd15.prod.outlook.com (52.132.150.151) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.27; Thu, 11 Oct 2018 18:02:54 +0000
Received: from MW2PR1501MB1993.namprd15.prod.outlook.com
 ([fe80::adf1:a7d1:c7cc:8dfa]) by MW2PR1501MB1993.namprd15.prod.outlook.com
 ([fe80::adf1:a7d1:c7cc:8dfa%4]) with mapi id 15.20.1207.029; Thu, 11 Oct 2018
 18:02:54 +0000
From:   Nick Terrell <terrelln@fb.com>
To:     Daniel Kiper <dkiper@net-space.pl>
CC:     David Sterba <dsterba@suse.cz>, Kernel Team <Kernel-team@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "grub-devel@gnu.org" <grub-devel@gnu.org>
Subject: Re: [PATCH v3 2/2] btrfs: Add zstd support to grub btrfs
Thread-Topic: [PATCH v3 2/2] btrfs: Add zstd support to grub btrfs
Thread-Index: AQHUYCcaYp/ax2K5Z0qr9RbFXDMFGKUaVtCAgAACIwA=
Date:   Thu, 11 Oct 2018 18:02:54 +0000
Message-ID: <1E67922D-C00A-4011-9088-9D24EBAD8E4E@fb.com>
References: <20181009232137.1941290-1-terrelln@fb.com>
 <20181009232137.1941290-3-terrelln@fb.com>
 <20181011175513.GF30679@router-fw-old.i.net-space.pl>
In-Reply-To: <20181011175513.GF30679@router-fw-old.i.net-space.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::4:4481]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MW2PR1501MB2155;20:sTJdj3jHEItZseFUVT0IAlLZ49pXgAon+GTLUPWLHNjqUM8lU0/bj1o0A2s2fLRNfjd6o+UsWMhrItUAjNqs6FA598PdsBk6rJWpmjCjO2vOxBqG553R/SepDRcRHJsbVXOyy7QStHZ6Gi16YYqemkNTwU5yQt8OlwxAAl50HOI=
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: 0f7b380a-a695-42d1-65b1-08d62fa3c47e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:MW2PR1501MB2155;
x-ms-traffictypediagnostic: MW2PR1501MB2155:
x-microsoft-antispam-prvs: <MW2PR1501MB2155D721BC155CD1E211AE97ABE10@MW2PR1501MB2155.namprd15.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(67672495146484);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(823302103)(3231355)(11241501184)(944501410)(52105095)(10201501046)(3002001)(93006095)(93001095)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123562045)(20161123560045)(20161123564045)(201708071742011)(7699051);SRVR:MW2PR1501MB2155;BCL:0;PCL:0;RULEID:;SRVR:MW2PR1501MB2155;
x-forefront-prvs: 08220FA8D6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(39860400002)(136003)(346002)(376002)(189003)(199004)(83716004)(229853002)(25786009)(54906003)(305945005)(82746002)(68736007)(6246003)(97736004)(99286004)(7736002)(33656002)(14454004)(446003)(2616005)(76176011)(5660300001)(71190400001)(486006)(478600001)(46003)(11346002)(71200400001)(4326008)(2900100001)(102836004)(6506007)(86362001)(6116002)(6512007)(8936002)(106356001)(81156014)(14444005)(256004)(6436002)(5250100002)(476003)(316002)(53546011)(81166006)(2906002)(6916009)(8676002)(53936002)(36756003)(6486002)(186003)(105586002)(17423001);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2155;H:MW2PR1501MB1993.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 5kSe/bLvv4Bwvrb1ylt7zmw9gRVUexU6uYthxH6mdEYZ8NP6Y9gJC8nhdWQGyCBp3Ku4KKqYnIXM6gvKVM901KT4ccEZlpnuQ/f//5W7bvCNMKq9jugdzIK6hMMZ7u/IO6OhmIy/+YsAP4CINUjTaSzJAaxMkV3vgXt10Z9DPvJB7i0Jql2J0fEBF7vqJBGvQYlhYdAsov7Xu1ew/debRQWMJF//9Xif6xvg70kc7yNBd0z3NUxZN/7SXY6SndHkbsL8wibQedhGctTn+7Utt22LjTnpyR/l5aiQ7ocfMrYhQHIVev3ozVzXf/m8GXadMbU2NsQI5roxWaXxcdwD7BrmzJrXjfPyMhfGEjzgWoE=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <581C672B59CD8249867B233E257543EC@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f7b380a-a695-42d1-65b1-08d62fa3c47e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2018 18:02:54.0885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2155
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-10-11_08:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



> On Oct 11, 2018, at 10:55 AM, Daniel Kiper <dkiper@net-space.pl> wrote:
>=20
> On Tue, Oct 09, 2018 at 04:21:37PM -0700, Nick Terrell wrote:
>> Adds zstd support to the btrfs module.
>>=20
>> Tested on Ubuntu-18.04 with a btrfs /boot partition with and without zst=
d
>> compression. A test case was also added to the test suite that fails bef=
ore
>> the patch, and passes after.
>>=20
>> Signed-off-by: Nick Terrell <terrelln@fb.com>
>> ---
>> v1 -> v2:
>> - Fix comments from Daniel Kiper.
>>=20
>> v2 -> v3:
>> - Use grub_error() to set grub_errno in grub_btrfs_zstd_decompress().
>> - Fix style and formatting comments.
>>=20
>> Makefile.util.def            |  10 +++-
>> grub-core/Makefile.core.def  |  10 +++-
>> grub-core/fs/btrfs.c         | 112 ++++++++++++++++++++++++++++++++++-
>> tests/btrfs_test.in          |   1 +
>> tests/util/grub-fs-tester.in |   2 +-
>> 5 files changed, 131 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/Makefile.util.def b/Makefile.util.def
>> index f9caccb97..27c5e9903 100644
>> --- a/Makefile.util.def
>> +++ b/Makefile.util.def
>> @@ -54,7 +54,7 @@ library =3D {
>> library =3D {
>>   name =3D libgrubmods.a;
>>   cflags =3D '-fno-builtin -Wno-undef';
>> -  cppflags =3D '-I$(top_srcdir)/grub-core/lib/minilzo -I$(srcdir)/grub-=
core/lib/xzembed -DMINILZO_HAVE_CONFIG_H';
>> +  cppflags =3D '-I$(srcdir)/grub-core/lib/minilzo -I$(srcdir)/grub-core=
/lib/xzembed -I$(srcdir)/grub-core/lib/zstd -DMINILZO_HAVE_CONFIG_H';
>>=20
>>   common_nodist =3D grub_script.tab.c;
>>   common_nodist =3D grub_script.yy.c;
>> @@ -164,6 +164,14 @@ library =3D {
>>   common =3D grub-core/lib/xzembed/xz_dec_bcj.c;
>>   common =3D grub-core/lib/xzembed/xz_dec_lzma2.c;
>>   common =3D grub-core/lib/xzembed/xz_dec_stream.c;
>> +  common =3D grub-core/lib/zstd/debug.c;
>> +  common =3D grub-core/lib/zstd/entropy_common.c;
>> +  common =3D grub-core/lib/zstd/error_private.c;
>> +  common =3D grub-core/lib/zstd/fse_decompress.c;
>> +  common =3D grub-core/lib/zstd/huf_decompress.c;
>> +  common =3D grub-core/lib/zstd/xxhash.c;
>> +  common =3D grub-core/lib/zstd/zstd_common.c;
>> +  common =3D grub-core/lib/zstd/zstd_decompress.c;
>> };
>>=20
>> program =3D {
>> diff --git a/grub-core/Makefile.core.def b/grub-core/Makefile.core.def
>> index 2c1d62cee..f818f58bc 100644
>> --- a/grub-core/Makefile.core.def
>> +++ b/grub-core/Makefile.core.def
>> @@ -1265,8 +1265,16 @@ module =3D {
>>   name =3D btrfs;
>>   common =3D fs/btrfs.c;
>>   common =3D lib/crc.c;
>> +  common =3D lib/zstd/debug.c;
>> +  common =3D lib/zstd/entropy_common.c;
>> +  common =3D lib/zstd/error_private.c;
>> +  common =3D lib/zstd/fse_decompress.c;
>> +  common =3D lib/zstd/huf_decompress.c;
>> +  common =3D lib/zstd/xxhash.c;
>> +  common =3D lib/zstd/zstd_common.c;
>> +  common =3D lib/zstd/zstd_decompress.c;
>>   cflags =3D '$(CFLAGS_POSIX) -Wno-undef';
>> -  cppflags =3D '-I$(srcdir)/lib/posix_wrap -I$(srcdir)/lib/minilzo -DMI=
NILZO_HAVE_CONFIG_H';
>> +  cppflags =3D '-I$(srcdir)/lib/posix_wrap -I$(srcdir)/lib/minilzo -I$(=
srcdir)/lib/zstd -DMINILZO_HAVE_CONFIG_H';
>> };
>=20
> Please do not embed zstd lib into btrfs module here.
> I would like to see zstd lib as separate module if possible.

Sure, I'm not exactly sure how the build system works. I haven't been able =
to
find any documentation, if there is some can you point me to it? I think th=
e zstd
module should look like:

module =3D {
  name =3D zstd;
  common =3D lib/zstd/debug.c;
  common =3D lib/zstd/entropy_common.c;
  common =3D lib/zstd/error_private.c;
  common =3D lib/zstd/fse_decompress.c;
  common =3D lib/zstd/huf_decompress.c;
  common =3D lib/zstd/xxhash.c;
  common =3D lib/zstd/zstd_common.c;
  common =3D lib/zstd/zstd_decompress.c;
  cflags =3D '$(CFLAGS_POSIX) -Wno-undef';
  cppflags =3D '-I$(srcdir)/lib/posix_wrap -I$(srcdir)/lib/zstd';
};

Then how do I add a dependency on it in btrfs?


>> +static grub_ssize_t
>> +grub_btrfs_zstd_decompress (char *ibuf, grub_size_t isize, grub_off_t o=
ff,
>> +			    char *obuf, grub_size_t osize)
>> +{
>> +	void *allocated =3D NULL;
>> +	char *otmpbuf =3D obuf;
>> +	grub_size_t otmpsize =3D osize;
>> +	ZSTD_DCtx *dctx =3D NULL;
>> +	grub_size_t zstd_ret;
>> +	grub_ssize_t ret =3D -1;
>> +
>> +	/*
>> +	 * Zstd will fail if it can't fit the entire output in the destination
>> +	 * buffer, so if osize isn't large enough, allocate a temporary buffer=
.
>> +	 */
>> +	if (otmpsize < ZSTD_BTRFS_MAX_INPUT) {
>> +		allocated =3D grub_malloc (ZSTD_BTRFS_MAX_INPUT);
>> +		if (!allocated) {
>=20
> Hmmm... Should not we say something here? Like grub_error() call below?
> It seems to me that failing silently is bad idea here.

grub_malloc() already calls grub_error with the message "Out of memory".

Thanks,
Nick

