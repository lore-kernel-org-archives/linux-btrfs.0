Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A8ADC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 01:49:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3D992250E
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 01:49:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="QKJCHLxo";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="hk3cewX4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E3D992250E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fb.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730585AbeKMLpW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 06:45:22 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57084 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726111AbeKMLpW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 06:45:22 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wAD1nNBk023092;
        Mon, 12 Nov 2018 17:49:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=uO14Fj/aQedCSN5e9weRFTwxEsgqfmNuv+NxD49RoG0=;
 b=QKJCHLxovPI7Yxn2NZDoy+FRilanafhC5n63j6dj9ZbV2+WpuyTUlA9TtBcSx/Q+DbNB
 LI70qTlJyuhKqbKKUU+lKSTm/JczhaMiNR0/X6eb7dZToKYQ0XKeWsxjtf5M1g2Yce0/
 rF6S5bJBgKaez5p3S/PXiuVDR2rVr/9TB38= 
Received: from maileast.thefacebook.com ([199.201.65.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2nqkm009bd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 12 Nov 2018 17:49:29 -0800
Received: from frc-mbx03.TheFacebook.com (2620:10d:c0a1:f82::27) by
 frc-hub04.TheFacebook.com (2620:10d:c021:18::174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1531.3; Mon, 12 Nov 2018 17:49:28 -0800
Received: from frc-hub01.TheFacebook.com (2620:10d:c021:18::171) by
 frc-mbx03.TheFacebook.com (2620:10d:c0a1:f82::27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1531.3; Mon, 12 Nov 2018 17:49:28 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.183.28)
 by o365-in.thefacebook.com (192.168.177.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1531.3
 via Frontend Transport; Mon, 12 Nov 2018 17:49:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uO14Fj/aQedCSN5e9weRFTwxEsgqfmNuv+NxD49RoG0=;
 b=hk3cewX46sTZpCYF95K/u8MV5DUh0h9pkS0btye910ojy2SUe9eHmth+qxSqIW2Z7Sbmj+VP3zIPAeqIlxImPtV5d4PgEPasigPf9Tnekf/qzgY6Ayq+XVQ1/c1dHA2Fxdsg64VpRyouwxnyh0/9/92N/VCe/r+LWOrRxIejwr0=
Received: from MW2PR1501MB1993.namprd15.prod.outlook.com (52.132.149.157) by
 MW2PR1501MB2011.namprd15.prod.outlook.com (52.132.150.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.23; Tue, 13 Nov 2018 01:49:23 +0000
Received: from MW2PR1501MB1993.namprd15.prod.outlook.com
 ([fe80::c554:8f41:4255:796f]) by MW2PR1501MB1993.namprd15.prod.outlook.com
 ([fe80::c554:8f41:4255:796f%3]) with mapi id 15.20.1294.045; Tue, 13 Nov 2018
 01:49:23 +0000
From:   Nick Terrell <terrelln@fb.com>
To:     David Sterba <dsterba@suse.cz>
CC:     Kernel Team <Kernel-team@fb.com>, Omar Sandoval <osandov@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Jennifer Liu <jenniferliu620@fb.com>
Subject: Re: [PATCH v2] btrfs: add zstd compression level support
Thread-Topic: [PATCH v2] btrfs: add zstd compression level support
Thread-Index: AQHUcUU6RfVouuPlxU+dBPN4xpFtkKVM7ngAgAAVMAA=
Date:   Tue, 13 Nov 2018 01:49:23 +0000
Message-ID: <2E6AE257-ED1B-4C21-847C-AB6CB49B9244@fb.com>
References: <20181031181108.289340-1-terrelln@fb.com>
 <20181113003332.GV24115@twin.jikos.cz>
In-Reply-To: <20181113003332.GV24115@twin.jikos.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::6:e9d]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MW2PR1501MB2011;20:iqqXp9i4UbWP5VeZ53Rt6ExzJ52fg0k/jy9WjzWJzpq28EwM3C29y9pWjTCztIHkUMpYOR9M3nKWD09mL3G1TlL87n+sW71JZ6/6mVttrXBrvnaePcfTjky3KvHRQYrKBzflSlmSzZLxjwt6liqEhB9D0E21AwD5Z8fI/aVjpqM=
x-ms-exchange-antispam-srfa-diagnostics: SOS;SOR;
x-ms-office365-filtering-correlation-id: b0648ac8-c351-4235-52a1-08d6490a3cd0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390059)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:MW2PR1501MB2011;
x-ms-traffictypediagnostic: MW2PR1501MB2011:
x-microsoft-antispam-prvs: <MW2PR1501MB2011DF85C0BD99DC9950F1ABABC20@MW2PR1501MB2011.namprd15.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(10436049006162)(67672495146484);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(823302103)(93006095)(93001095)(10201501046)(3231382)(11241501184)(944501410)(4982022)(52105112)(3002001)(148016)(149066)(150057)(6041310)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123558120)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:MW2PR1501MB2011;BCL:0;PCL:0;RULEID:;SRVR:MW2PR1501MB2011;
x-forefront-prvs: 085551F5A8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(396003)(366004)(39860400002)(136003)(189003)(199004)(316002)(99286004)(14444005)(68736007)(256004)(2906002)(97736004)(81166006)(81156014)(966005)(102836004)(53546011)(8676002)(6506007)(6916009)(71200400001)(83716004)(71190400001)(4744004)(54906003)(106356001)(5660300001)(305945005)(7736002)(25786009)(8936002)(6306002)(229853002)(4326008)(6486002)(33656002)(6246003)(36756003)(46003)(446003)(6116002)(11346002)(2616005)(476003)(14454004)(6512007)(53946003)(82746002)(6436002)(53936002)(186003)(105586002)(478600001)(76176011)(486006)(575784001)(2900100001)(86362001)(579004);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2011;H:MW2PR1501MB1993.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 56Dc5KWlko61ae+urv4GXjYodqc3Fgs/ssO1AF53tjFmklfgKgAE/0DB1MSyFZPk2R9+I7UjQcAFVwm2+JDXJbHTG233B7O//3wcytC7gxfoYINlZ8/HxYHQOG90TcCx6rYArasrv5SdeZl5W6cHUpeptZKXvPLkPmAXLBT2JyHg6I9blESYQVSCzYhMv22eS8LC6PHPFYHaQbc6aZ7fNEadsY1Yy41Dx8eqhfLTvimTjBMtFR5+1jIWgbXm5BMMR93AYZy6hmgIlRSd3vrbHDyt0P16cRP/KWprAmln+bOCjjaVO4y143D/t3OxEuPKg8TrsIqmX9o2VouVlawN1xsW5cWx/61vi6UGjfZQRgo=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E9B8485E40B39342A36C60FA3C97C4A7@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b0648ac8-c351-4235-52a1-08d6490a3cd0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2018 01:49:23.6488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2011
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-11-12_16:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



> On Nov 12, 2018, at 4:33 PM, David Sterba <dsterba@suse.cz> wrote:
>=20
> On Wed, Oct 31, 2018 at 11:11:08AM -0700, Nick Terrell wrote:
>> From: Jennifer Liu <jenniferliu620@fb.com>
>>=20
>> Adds zstd compression level support to btrfs. Zstd requires
>> different amounts of memory for each level, so the design had
>> to be modified to allow set_level() to allocate memory. We
>> preallocate one workspace of the maximum size to guarantee
>> forward progress. This feature is expected to be useful for
>> read-mostly filesystems, or when creating images.
>>=20
>> Benchmarks run in qemu on Intel x86 with a single core.
>> The benchmark measures the time to copy the Silesia corpus [0] to
>> a btrfs filesystem 10 times, then read it back.
>>=20
>> The two important things to note are:
>> - The decompression speed and memory remains constant.
>>  The memory required to decompress is the same as level 1.
>> - The compression speed and ratio will vary based on the source.
>>=20
>> Level	Ratio	Compression	Decompression	Compression Memory
>> 1    	2.59 	153 MB/s   	112 MB/s     	0.8 MB
>> 2    	2.67 	136 MB/s   	113 MB/s     	1.0 MB
>> 3    	2.72 	106 MB/s   	115 MB/s     	1.3 MB
>> 4    	2.78 	86  MB/s   	109 MB/s     	0.9 MB
>> 5    	2.83 	69  MB/s   	109 MB/s     	1.4 MB
>> 6    	2.89 	53  MB/s   	110 MB/s     	1.5 MB
>> 7    	2.91 	40  MB/s   	112 MB/s     	1.4 MB
>> 8    	2.92 	34  MB/s   	110 MB/s     	1.8 MB
>> 9    	2.93 	27  MB/s   	109 MB/s     	1.8 MB
>> 10   	2.94 	22  MB/s   	109 MB/s     	1.8 MB
>> 11   	2.95 	17  MB/s   	114 MB/s     	1.8 MB
>> 12   	2.95 	13  MB/s   	113 MB/s     	1.8 MB
>> 13   	2.95 	10  MB/s   	111 MB/s     	2.3 MB
>> 14   	2.99 	7   MB/s   	110 MB/s     	2.6 MB
>> 15   	3.03 	6   MB/s   	110 MB/s     	2.6 MB
>>=20
>> [0] https://urldefense.proofpoint.com/v2/url?u=3Dhttp-3A__sun.aei.polsl.=
pl_-7Esdeor_index.php-3Fpage-3Dsilesia&d=3DDwIBAg&c=3D5VD0RTtNlTh3ycd41b3MU=
w&r=3DHQM5IQdWOB8WaMoii2dYTw&m=3D5LQRTUqZnx_a8dGSa5bGsd0Fm4ejQQOcH50wi7nRew=
Y&s=3DgFUm-SA3aeQI7PBe3zmxUuxk4AEEZegB0cRsbjWUToo&e=3D
>>=20
>> Signed-off-by: Jennifer Liu <jenniferliu620@fb.com>
>> Signed-off-by: Nick Terrell <terrelln@fb.com>
>> Reviewed-by: Omar Sandoval <osandov@fb.com>
>> ---
>> v1 -> v2:
>> - Don't reflow the unchanged line.
>>=20
>> fs/btrfs/compression.c | 169 +++++++++++++++++++++++++----------------
>> fs/btrfs/compression.h |  18 +++--
>> fs/btrfs/lzo.c         |   5 +-
>> fs/btrfs/super.c       |   7 +-
>> fs/btrfs/zlib.c        |  33 ++++----
>> fs/btrfs/zstd.c        |  74 +++++++++++++-----
>> 6 files changed, 202 insertions(+), 104 deletions(-)
>>=20
>> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
>> index 2955a4ea2fa8..b46652cb653e 100644
>> --- a/fs/btrfs/compression.c
>> +++ b/fs/btrfs/compression.c
>> @@ -822,9 +822,12 @@ void __init btrfs_init_compress(void)
>>=20
>> 		/*
>> 		 * Preallocate one workspace for each compression type so
>> -		 * we can guarantee forward progress in the worst case
>> +		 * we can guarantee forward progress in the worst case.
>> +		 * Provide the maximum compression level to guarantee large
>> +		 * enough workspace.
>> 		 */
>> -		workspace =3D btrfs_compress_op[i]->alloc_workspace();
>> +		workspace =3D btrfs_compress_op[i]->alloc_workspace(
>> +				btrfs_compress_op[i]->max_level);

We provide the max level here, so we have at least one workspace per
compression type that is large enough.

>> 		if (IS_ERR(workspace)) {
>> 			pr_warn("BTRFS: cannot preallocate compression workspace, will try la=
ter\n");
>> 		} else {
>> @@ -835,23 +838,78 @@ void __init btrfs_init_compress(void)
>> 	}
>> }
>>=20
>> +/*
>> + * put a workspace struct back on the list or free it if we have enough
>> + * idle ones sitting around
>> + */
>> +static void __free_workspace(int type, struct list_head *workspace,
>> +			     bool heuristic)
>> +{
>> +	int idx =3D type - 1;
>> +	struct list_head *idle_ws;
>> +	spinlock_t *ws_lock;
>> +	atomic_t *total_ws;
>> +	wait_queue_head_t *ws_wait;
>> +	int *free_ws;
>> +
>> +	if (heuristic) {
>> +		idle_ws	 =3D &btrfs_heuristic_ws.idle_ws;
>> +		ws_lock	 =3D &btrfs_heuristic_ws.ws_lock;
>> +		total_ws =3D &btrfs_heuristic_ws.total_ws;
>> +		ws_wait	 =3D &btrfs_heuristic_ws.ws_wait;
>> +		free_ws	 =3D &btrfs_heuristic_ws.free_ws;
>> +	} else {
>> +		idle_ws	 =3D &btrfs_comp_ws[idx].idle_ws;
>> +		ws_lock	 =3D &btrfs_comp_ws[idx].ws_lock;
>> +		total_ws =3D &btrfs_comp_ws[idx].total_ws;
>> +		ws_wait	 =3D &btrfs_comp_ws[idx].ws_wait;
>> +		free_ws	 =3D &btrfs_comp_ws[idx].free_ws;
>> +	}
>> +
>> +	spin_lock(ws_lock);
>> +	if (*free_ws <=3D num_online_cpus()) {
>> +		list_add(workspace, idle_ws);
>> +		(*free_ws)++;
>> +		spin_unlock(ws_lock);
>> +		goto wake;
>> +	}
>> +	spin_unlock(ws_lock);
>> +
>> +	if (heuristic)
>> +		free_heuristic_ws(workspace);
>> +	else
>> +		btrfs_compress_op[idx]->free_workspace(workspace);
>> +	atomic_dec(total_ws);
>> +wake:
>> +	cond_wake_up(ws_wait);
>> +}
>> +
>> +static void free_workspace(int type, struct list_head *ws)
>> +{
>> +	return __free_workspace(type, ws, false);
>> +}
>> +
>> /*
>>  * This finds an available workspace or allocates a new one.
>>  * If it's not possible to allocate a new one, waits until there's one.
>>  * Preallocation makes a forward progress guarantees and we do not retur=
n
>>  * errors.
>>  */
>> -static struct list_head *__find_workspace(int type, bool heuristic)
>> +static struct list_head *__find_workspace(unsigned int type_level,
>> +					  bool heuristic)
>> {
>> 	struct list_head *workspace;
>> 	int cpus =3D num_online_cpus();
>> +	int type =3D type_level & 0xF;
>> 	int idx =3D type - 1;
>> -	unsigned nofs_flag;
>> +	unsigned int level =3D (type_level & 0xF0) >> 4;
>> +	unsigned int nofs_flag;
>> 	struct list_head *idle_ws;
>> 	spinlock_t *ws_lock;
>> 	atomic_t *total_ws;
>> 	wait_queue_head_t *ws_wait;
>> 	int *free_ws;
>> +	int ret;
>>=20
>> 	if (heuristic) {
>> 		idle_ws	 =3D &btrfs_heuristic_ws.idle_ws;
>> @@ -874,8 +932,17 @@ static struct list_head *__find_workspace(int type,=
 bool heuristic)
>> 		list_del(workspace);
>> 		(*free_ws)--;
>> 		spin_unlock(ws_lock);
>> +		if (!heuristic) {
>> +			nofs_flag =3D memalloc_nofs_save();
>> +			ret =3D btrfs_compress_op[idx]->set_level(workspace,
>> +								level);
>> +			memalloc_nofs_restore(nofs_flag);
>> +			if (!ret) {
>> +				free_workspace(type, workspace);
>> +				goto again;
>> +			}
>> +		}
>> 		return workspace;
>> -
>> 	}
>> 	if (atomic_read(total_ws) > cpus) {
>> 		DEFINE_WAIT(wait);
>> @@ -899,7 +966,8 @@ static struct list_head *__find_workspace(int type, =
bool heuristic)
>> 	if (heuristic)
>> 		workspace =3D alloc_heuristic_ws();
>> 	else
>> -		workspace =3D btrfs_compress_op[idx]->alloc_workspace();
>> +		workspace =3D btrfs_compress_op[idx]->alloc_workspace(level);
>> +
>> 	memalloc_nofs_restore(nofs_flag);
>>=20
>> 	if (IS_ERR(workspace)) {
>> @@ -930,60 +998,22 @@ static struct list_head *__find_workspace(int type=
, bool heuristic)
>> 	return workspace;
>> }
>>=20
>> -static struct list_head *find_workspace(int type)
>> +static struct list_head *find_workspace(unsigned int type_level)
>> {
>> -	return __find_workspace(type, false);
>> +	return __find_workspace(type_level, false);
>> }
>>=20
>> -/*
>> - * put a workspace struct back on the list or free it if we have enough
>> - * idle ones sitting around
>> - */
>> -static void __free_workspace(int type, struct list_head *workspace,
>> -			     bool heuristic)
>> +static struct list_head *find_decompression_workspace(unsigned int type=
)
>> {
>> -	int idx =3D type - 1;
>> -	struct list_head *idle_ws;
>> -	spinlock_t *ws_lock;
>> -	atomic_t *total_ws;
>> -	wait_queue_head_t *ws_wait;
>> -	int *free_ws;
>> +	/*
>> +	 * Use the lowest level for decompression, since we don't need to
>> +	 * compress. This can help us save memory when using levels lower than
>> +	 * the default level.
>> +	 */
>> +	const unsigned int level =3D 1;
>> +	const unsigned int type_level =3D (level << 4) | (type & 0xF);
>>=20
>> -	if (heuristic) {
>> -		idle_ws	 =3D &btrfs_heuristic_ws.idle_ws;
>> -		ws_lock	 =3D &btrfs_heuristic_ws.ws_lock;
>> -		total_ws =3D &btrfs_heuristic_ws.total_ws;
>> -		ws_wait	 =3D &btrfs_heuristic_ws.ws_wait;
>> -		free_ws	 =3D &btrfs_heuristic_ws.free_ws;
>> -	} else {
>> -		idle_ws	 =3D &btrfs_comp_ws[idx].idle_ws;
>> -		ws_lock	 =3D &btrfs_comp_ws[idx].ws_lock;
>> -		total_ws =3D &btrfs_comp_ws[idx].total_ws;
>> -		ws_wait	 =3D &btrfs_comp_ws[idx].ws_wait;
>> -		free_ws	 =3D &btrfs_comp_ws[idx].free_ws;
>> -	}
>> -
>> -	spin_lock(ws_lock);
>> -	if (*free_ws <=3D num_online_cpus()) {
>> -		list_add(workspace, idle_ws);
>> -		(*free_ws)++;
>> -		spin_unlock(ws_lock);
>> -		goto wake;
>> -	}
>> -	spin_unlock(ws_lock);
>> -
>> -	if (heuristic)
>> -		free_heuristic_ws(workspace);
>> -	else
>> -		btrfs_compress_op[idx]->free_workspace(workspace);
>> -	atomic_dec(total_ws);
>> -wake:
>> -	cond_wake_up(ws_wait);
>> -}
>> -
>> -static void free_workspace(int type, struct list_head *ws)
>> -{
>> -	return __free_workspace(type, ws, false);
>> +	return find_workspace(type_level);
>> }
>>=20
>> /*
>> @@ -1044,9 +1074,7 @@ int btrfs_compress_pages(unsigned int type_level, =
struct address_space *mapping,
>> 	int ret;
>> 	int type =3D type_level & 0xF;
>>=20
>> -	workspace =3D find_workspace(type);
>> -
>> -	btrfs_compress_op[type - 1]->set_level(workspace, type_level);
>> +	workspace =3D find_workspace(type_level);
>> 	ret =3D btrfs_compress_op[type-1]->compress_pages(workspace, mapping,
>> 						      start, pages,
>> 						      out_pages,
>> @@ -1075,7 +1103,7 @@ static int btrfs_decompress_bio(struct compressed_=
bio *cb)
>> 	int ret;
>> 	int type =3D cb->compress_type;
>>=20
>> -	workspace =3D find_workspace(type);
>> +	workspace =3D find_decompression_workspace(type);
>> 	ret =3D btrfs_compress_op[type - 1]->decompress_bio(workspace, cb);
>> 	free_workspace(type, workspace);
>>=20
>> @@ -1093,7 +1121,7 @@ int btrfs_decompress(int type, unsigned char *data=
_in, struct page *dest_page,
>> 	struct list_head *workspace;
>> 	int ret;
>>=20
>> -	workspace =3D find_workspace(type);
>> +	workspace =3D find_decompression_workspace(type);
>>=20
>> 	ret =3D btrfs_compress_op[type-1]->decompress(workspace, data_in,
>> 						  dest_page, start_byte,
>> @@ -1591,12 +1619,23 @@ int btrfs_compress_heuristic(struct inode *inode=
, u64 start, u64 end)
>>=20
>> unsigned int btrfs_compress_str2level(const char *str)
>> {
>> -	if (strncmp(str, "zlib", 4) !=3D 0)
>> +	int ret;
>> +	int type;
>> +	unsigned int level;
>> +
>> +	if (strncmp(str, "zlib", 4) =3D=3D 0)
>> +		type =3D BTRFS_COMPRESS_ZLIB;
>> +	else if (strncmp(str, "zstd", 4) =3D=3D 0)
>> +		type =3D BTRFS_COMPRESS_ZSTD;
>> +	else
>> 		return 0;
>>=20
>> -	/* Accepted form: zlib:1 up to zlib:9 and nothing left after the numbe=
r */
>> -	if (str[4] =3D=3D ':' && '1' <=3D str[5] && str[5] <=3D '9' && str[6] =
=3D=3D 0)
>> -		return str[5] - '0';
>> +	if (str[4] =3D=3D ':') {
>> +		ret =3D kstrtouint(str + 5, 10, &level);
>> +		if (ret =3D=3D 0 && 0 < level &&
>> +		    level <=3D btrfs_compress_op[type-1]->max_level)
>> +			return level;
>> +	}
>>=20
>> -	return BTRFS_ZLIB_DEFAULT_LEVEL;
>> +	return btrfs_compress_op[type-1]->default_level;
>> }
>> diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
>> index ddda9b80bf20..a582a4483077 100644
>> --- a/fs/btrfs/compression.h
>> +++ b/fs/btrfs/compression.h
>> @@ -23,8 +23,6 @@
>> /* Maximum size of data before compression */
>> #define BTRFS_MAX_UNCOMPRESSED		(SZ_128K)
>>=20
>> -#define	BTRFS_ZLIB_DEFAULT_LEVEL		3
>> -
>> struct compressed_bio {
>> 	/* number of bios pending for this compressed extent */
>> 	refcount_t pending_bios;
>> @@ -87,7 +85,7 @@ blk_status_t btrfs_submit_compressed_write(struct inod=
e *inode, u64 start,
>> blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bi=
o *bio,
>> 				 int mirror_num, unsigned long bio_flags);
>>=20
>> -unsigned btrfs_compress_str2level(const char *str);
>> +unsigned int btrfs_compress_str2level(const char *str);
>>=20
>> enum btrfs_compression_type {
>> 	BTRFS_COMPRESS_NONE  =3D 0,
>> @@ -98,7 +96,7 @@ enum btrfs_compression_type {
>> };
>>=20
>> struct btrfs_compress_op {
>> -	struct list_head *(*alloc_workspace)(void);
>> +	struct list_head *(*alloc_workspace)(unsigned int level);
>>=20
>> 	void (*free_workspace)(struct list_head *workspace);
>>=20
>> @@ -119,7 +117,17 @@ struct btrfs_compress_op {
>> 			  unsigned long start_byte,
>> 			  size_t srclen, size_t destlen);
>>=20
>> -	void (*set_level)(struct list_head *ws, unsigned int type);
>> +	/*
>> +	 * Check if memory allocated in workspace is greater than
>> +	 * or equal to memory needed to compress with given level.
>> +	 * If not, try to reallocate memory for the compression level.
>> +	 * Returns true on success.
>> +	 */
>> +	bool (*set_level)(struct list_head *ws, unsigned int level);
>> +
>> +	unsigned int max_level;
>> +
>> +	unsigned int default_level;
>> };
>>=20
>> extern const struct btrfs_compress_op btrfs_zlib_compress;
>> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
>> index b6a4cc178bee..ed9f0da8ceda 100644
>> --- a/fs/btrfs/lzo.c
>> +++ b/fs/btrfs/lzo.c
>> @@ -71,7 +71,7 @@ static void lzo_free_workspace(struct list_head *ws)
>> 	kfree(workspace);
>> }
>>=20
>> -static struct list_head *lzo_alloc_workspace(void)
>> +static struct list_head *lzo_alloc_workspace(unsigned int level)
>> {
>> 	struct workspace *workspace;
>>=20
>> @@ -485,8 +485,9 @@ static int lzo_decompress(struct list_head *ws, unsi=
gned char *data_in,
>> 	return ret;
>> }
>>=20
>> -static void lzo_set_level(struct list_head *ws, unsigned int type)
>> +static bool lzo_set_level(struct list_head *ws, unsigned int level)
>> {
>> +	return true;
>> }
>>=20
>> const struct btrfs_compress_op btrfs_lzo_compress =3D {
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index b362b45dd757..77ebd69371f1 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -520,7 +520,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, =
char *options,
>> 				compress_type =3D "zlib";
>>=20
>> 				info->compress_type =3D BTRFS_COMPRESS_ZLIB;
>> -				info->compress_level =3D BTRFS_ZLIB_DEFAULT_LEVEL;
>> +				info->compress_level =3D
>> +					btrfs_zlib_compress.default_level;
>> 				/*
>> 				 * args[0] contains uninitialized data since
>> 				 * for these tokens we don't expect any
>> @@ -542,9 +543,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info,=
 char *options,
>> 				btrfs_clear_opt(info->mount_opt, NODATASUM);
>> 				btrfs_set_fs_incompat(info, COMPRESS_LZO);
>> 				no_compress =3D 0;
>> -			} else if (strcmp(args[0].from, "zstd") =3D=3D 0) {
>> +			} else if (strncmp(args[0].from, "zstd", 4) =3D=3D 0) {
>> 				compress_type =3D "zstd";
>> 				info->compress_type =3D BTRFS_COMPRESS_ZSTD;
>> +				info->compress_level =3D
>> +					btrfs_compress_str2level(args[0].from);
>> 				btrfs_set_opt(info->mount_opt, COMPRESS);
>> 				btrfs_clear_opt(info->mount_opt, NODATACOW);
>> 				btrfs_clear_opt(info->mount_opt, NODATASUM);
>> diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
>> index 970ff3e35bb3..4c30a99b80f6 100644
>> --- a/fs/btrfs/zlib.c
>> +++ b/fs/btrfs/zlib.c
>> @@ -20,6 +20,9 @@
>> #include <linux/refcount.h>
>> #include "compression.h"
>>=20
>> +#define BTRFS_ZLIB_DEFAULT_LEVEL 3
>> +#define BTRFS_ZLIB_MAX_LEVEL 9
>> +
>> struct workspace {
>> 	z_stream strm;
>> 	char *buf;
>> @@ -36,7 +39,19 @@ static void zlib_free_workspace(struct list_head *ws)
>> 	kfree(workspace);
>> }
>>=20
>> -static struct list_head *zlib_alloc_workspace(void)
>> +static bool zlib_set_level(struct list_head *ws, unsigned int level)
>> +{
>> +	struct workspace *workspace =3D list_entry(ws, struct workspace, list)=
;
>> +
>> +	if (level > BTRFS_ZLIB_MAX_LEVEL)
>> +		level =3D BTRFS_ZLIB_MAX_LEVEL;
>> +
>> +	workspace->level =3D level > 0 ? level : BTRFS_ZLIB_DEFAULT_LEVEL;
>> +
>> +	return true;
>> +}
>> +
>> +static struct list_head *zlib_alloc_workspace(unsigned int level)
>> {
>> 	struct workspace *workspace;
>> 	int workspacesize;
>> @@ -53,6 +68,7 @@ static struct list_head *zlib_alloc_workspace(void)
>> 		goto fail;
>>=20
>> 	INIT_LIST_HEAD(&workspace->list);
>> +	zlib_set_level(&workspace->list, level);
>>=20
>> 	return &workspace->list;
>> fail:
>> @@ -390,22 +406,13 @@ static int zlib_decompress(struct list_head *ws, u=
nsigned char *data_in,
>> 	return ret;
>> }
>>=20
>> -static void zlib_set_level(struct list_head *ws, unsigned int type)
>> -{
>> -	struct workspace *workspace =3D list_entry(ws, struct workspace, list)=
;
>> -	unsigned level =3D (type & 0xF0) >> 4;
>> -
>> -	if (level > 9)
>> -		level =3D 9;
>> -
>> -	workspace->level =3D level > 0 ? level : 3;
>> -}
>> -
>> const struct btrfs_compress_op btrfs_zlib_compress =3D {
>> 	.alloc_workspace	=3D zlib_alloc_workspace,
>> 	.free_workspace		=3D zlib_free_workspace,
>> 	.compress_pages		=3D zlib_compress_pages,
>> 	.decompress_bio		=3D zlib_decompress_bio,
>> 	.decompress		=3D zlib_decompress,
>> -	.set_level              =3D zlib_set_level,
>> +	.set_level		=3D zlib_set_level,
>> +	.max_level		=3D BTRFS_ZLIB_MAX_LEVEL,
>> +	.default_level		=3D BTRFS_ZLIB_DEFAULT_LEVEL,
>> };
>> diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
>> index af6ec59972f5..e5d7c2eae65c 100644
>> --- a/fs/btrfs/zstd.c
>> +++ b/fs/btrfs/zstd.c
>> @@ -19,12 +19,13 @@
>>=20
>> #define ZSTD_BTRFS_MAX_WINDOWLOG 17
>> #define ZSTD_BTRFS_MAX_INPUT (1 << ZSTD_BTRFS_MAX_WINDOWLOG)
>> -#define ZSTD_BTRFS_DEFAULT_LEVEL 3
>> +#define BTRFS_ZSTD_DEFAULT_LEVEL 3
>> +#define BTRFS_ZSTD_MAX_LEVEL 15
>>=20
>> -static ZSTD_parameters zstd_get_btrfs_parameters(size_t src_len)
>> +static ZSTD_parameters zstd_get_btrfs_parameters(size_t src_len,
>> +						 unsigned int level)
>> {
>> -	ZSTD_parameters params =3D ZSTD_getParams(ZSTD_BTRFS_DEFAULT_LEVEL,
>> -						src_len, 0);
>> +	ZSTD_parameters params =3D ZSTD_getParams(level, src_len, 0);
>>=20
>> 	if (params.cParams.windowLog > ZSTD_BTRFS_MAX_WINDOWLOG)
>> 		params.cParams.windowLog =3D ZSTD_BTRFS_MAX_WINDOWLOG;
>> @@ -37,10 +38,25 @@ struct workspace {
>> 	size_t size;
>> 	char *buf;
>> 	struct list_head list;
>> +	unsigned int level;
>> 	ZSTD_inBuffer in_buf;
>> 	ZSTD_outBuffer out_buf;
>> };
>>=20
>> +static bool zstd_reallocate_mem(struct workspace *workspace, int size)
>> +{
>> +	void *new_mem;
>> +
>> +	new_mem =3D kvmalloc(size, GFP_KERNEL);
>> +	if (new_mem) {
>> +		kvfree(workspace->mem);
>> +		workspace->mem =3D new_mem;
>> +		workspace->size =3D size;
>> +		return true;
>> +	}
>> +	return false;
>> +}
>> +
>> static void zstd_free_workspace(struct list_head *ws)
>> {
>> 	struct workspace *workspace =3D list_entry(ws, struct workspace, list);
>> @@ -50,10 +66,34 @@ static void zstd_free_workspace(struct list_head *ws=
)
>> 	kfree(workspace);
>> }
>>=20
>> -static struct list_head *zstd_alloc_workspace(void)
>> +static bool zstd_set_level(struct list_head *ws, unsigned int level)
>> +{
>> +	struct workspace *workspace =3D list_entry(ws, struct workspace, list)=
;
>> +	ZSTD_parameters params;
>> +	int size;
>> +
>> +	if (level > BTRFS_ZSTD_MAX_LEVEL)
>> +		level =3D BTRFS_ZSTD_MAX_LEVEL;
>> +
>> +	if (level =3D=3D 0)
>> +		level =3D BTRFS_ZSTD_DEFAULT_LEVEL;
>> +
>> +	params =3D ZSTD_getParams(level, ZSTD_BTRFS_MAX_INPUT, 0);
>> +	size =3D max_t(size_t,
>> +			ZSTD_CStreamWorkspaceBound(params.cParams),
>> +			ZSTD_DStreamWorkspaceBound(ZSTD_BTRFS_MAX_INPUT));
>> +	if (size > workspace->size) {
>> +		if (!zstd_reallocate_mem(workspace, size))
>=20
> This can allocate memory and this can appen on the writeout path, ie.
> one of the reasons for that might be that system needs more memory.
>=20
> By the table above, the size can be up to 2.6MiB, which is a lot in
> terms of kernel memory as there must be either contiguous unmapped
> memory, the virtual mappings must be created. Both are scarce resource
> or should be treated as such.
>
> Given that there's no logic that would try to minimize the usage for
> workspaces, this can allocate many workspaces of that size.
>=20
> Currently the workspace allocations have been moved to the early module
> loading phase so that they don't happen later and we don't have to
> allocate memory nor handle the failures. Your patch brings that back.

Before this patch, the compression module initialization preloads one
workspace per algorithm. We added the compression level as a parameter
to the allocation, and the initialization uses the maximum level, 15. This
guarantees forward progress, since each algorithm will have at least one
workspace that will work for every compression level.

The only new failure condition is when the compression level changes,
we have to reallocate the workspaces next time we use them. If we run
into memory pressure, we might free every workspace but one, reducing
throughput, but maintaining correctness. This is basically the same scenari=
o
as before, but now it can occur when writing after changing compression
levels, not just changing compression algorithm.

I'm not too worried about increased memory usage. We only preallocate
one of the maximum level (1 MB wasted if not used). Then we only up-size
the workspaces when needed. I don't expect that high compression levels
will be a common use case.

The one potential problem with this solution is if the user rarely mounts
with level 15 (say once a day), but commonly uses level 3. Then their
workspaces will be sized at 15 forever. However, this is the same
problem as if the user commonly uses no compression, but occasionally
uses zstd. The zstd contexts will stick around forever. Ideally we would
delete workspaces that go unused for a certain amount of time (leaving
the single preallocated workspace). I think this belongs in a separate patc=
h.
I'll plan on looking into it as a follow up.

> The solution I'm currently thinking about can make the levels work but
> would be limited in throughput as a trade-off for the memory
> consumption.
>=20
> - preallocate one workspace for level 15 per mounted filesystem, using
>  get_free_pages_exact or kvmalloc
>=20
> - preallocate workspaces for the default level, the number same as for
>  lzo/zlib
>=20
> - add logic to select the zstd:15 workspace last for other compressors,
>  ie. make it almost exclusive for zstd levels > default
>=20
> Further refinement could allocate the workspaces on-demand and free if
> not used. Allocation failures would still be handled gracefully at the
> cost of waiting for the remainig worspaces, at least one would be always
> available.

Nick=
