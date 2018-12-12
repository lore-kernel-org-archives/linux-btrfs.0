Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,T_MIXED_ES autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71240C65BAF
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 14:47:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11F8E20870
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 14:47:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="DOv4LoYT";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="eE4C0P3o"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 11F8E20870
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fb.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbeLLOrv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 09:47:51 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34236 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726223AbeLLOrv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 09:47:51 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id wBCElLGm003896;
        Wed, 12 Dec 2018 06:47:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=7oTpT4GNwqcmJmvpuILZofRxmwxkqvtOXH2GZZje47Y=;
 b=DOv4LoYTDBL6DT5d0q3tns51uXoiyjap986IDa3a55sxQ5th2f2pV2zLc32CeJVmNTpP
 hr8JDJOfRgfiaFVfMscJvgXgrcVkpJQG4ebJMvjiEaPgBtyc9wbpzpcZYkwZePSjttle
 jDNc8Dxt+lPREjpfIc1U9fchUpSs3zSSAfU= 
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2pb326g841-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Dec 2018 06:47:37 -0800
Received: from prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1531.3; Wed, 12 Dec 2018 06:47:31 -0800
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1531.3; Wed, 12 Dec 2018 06:47:30 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1531.3
 via Frontend Transport; Wed, 12 Dec 2018 06:47:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7oTpT4GNwqcmJmvpuILZofRxmwxkqvtOXH2GZZje47Y=;
 b=eE4C0P3oNTyzlUqkCU8uOIenZ5+hUcxu7aByV0mpN6RwzCFpoy195BTMIWdqKcZs1xsGVYW/nSrz4aIo2XT15gStHZQF+0fNQfsM2uwQT0zuDSI0PgjTsbspqQsCF5B63pmXJZ9FYrxc/lJQ1jYq75YzKYaf3Ctsd/KIUm3CS0g=
Received: from DM5PR15MB1883.namprd15.prod.outlook.com (10.174.247.135) by
 DM5PR15MB1372.namprd15.prod.outlook.com (10.173.224.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1425.18; Wed, 12 Dec 2018 14:47:29 +0000
Received: from DM5PR15MB1883.namprd15.prod.outlook.com
 ([fe80::f8d4:7c44:756a:6205]) by DM5PR15MB1883.namprd15.prod.outlook.com
 ([fe80::f8d4:7c44:756a:6205%12]) with mapi id 15.20.1404.026; Wed, 12 Dec
 2018 14:47:29 +0000
From:   Chris Mason <clm@fb.com>
To:     Ethan Lien <ethanlien@synology.com>
CC:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2] btrfs: balance dirty metadata pages in
 btrfs_finish_ordered_io
Thread-Topic: [PATCH v2] btrfs: balance dirty metadata pages in
 btrfs_finish_ordered_io
Thread-Index: AQHT9keZ7Z3eAayDI0yo6F7kEUsUfaV8ZqAA
Date:   Wed, 12 Dec 2018 14:47:28 +0000
Message-ID: <D7645E04-6424-4BFA-90C6-D63245EB9435@fb.com>
References: <20180528054821.9092-1-ethanlien@synology.com>
In-Reply-To: <20180528054821.9092-1-ethanlien@synology.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: MailMate (1.12.2r5568)
x-clientproxiedby: BN6PR10CA0016.namprd10.prod.outlook.com
 (2603:10b6:405:1::26) To DM5PR15MB1883.namprd15.prod.outlook.com
 (2603:10b6:4:4f::7)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c091:180::1:d88e]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM5PR15MB1372;20:w6/oT6WRK1POy+HhmlWN+k/tGObfXt9R1er4+8b+Jhgj/xMCVqmJ6sRTbWvN5vYstqlqan4qRPFO7sgRnWV9+RPqSykSKpiTcs71X0rV8SxwaNHgTXAqxTanNAaxpiT34EWT8/GAa6vtBSmSmq9BQ+4QwKPE36CxcMuUfqGeqbg=
x-ms-office365-filtering-correlation-id: 4d317010-0e14-4ce6-7c6e-08d66040bc6f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM5PR15MB1372;
x-ms-traffictypediagnostic: DM5PR15MB1372:
x-microsoft-antispam-prvs: <DM5PR15MB1372C26C362F65E25B32288ED3A70@DM5PR15MB1372.namprd15.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(3230017)(999002)(11241501185)(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231472)(944501520)(52105112)(148016)(149066)(150057)(6041310)(20161123562045)(20161123564045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:DM5PR15MB1372;BCL:0;PCL:0;RULEID:;SRVR:DM5PR15MB1372;
x-forefront-prvs: 0884AAA693
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(136003)(346002)(376002)(396003)(199004)(189003)(86362001)(71200400001)(68736007)(71190400001)(83716004)(46003)(6436002)(52116002)(5660300001)(6916009)(106356001)(7736002)(105586002)(478600001)(8936002)(81156014)(14454004)(81166006)(2906002)(305945005)(14444005)(50226002)(82746002)(6512007)(6246003)(97736004)(4326008)(476003)(6116002)(229853002)(256004)(186003)(446003)(2616005)(8676002)(551934003)(6506007)(25786009)(486006)(33656002)(36756003)(102836004)(386003)(99286004)(6486002)(53936002)(316002)(11346002)(53546011)(54906003)(76176011)(14143004)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1372;H:DM5PR15MB1883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: aalHJy0BfrDCIqYAfFOzfmvkX1cov6lgsQGUIOeF2BUxBb1yDdcRnkvQgc+bKh/wxo6jkFiHoXrZus2MhSSu4QHnO6V7NRaNqKTjbbmR2vMve9v2MlBd3szh7zXogSmnQaUHy89GbrXyB9Qw+ZBb9vAGcK0f0E2pCNRn1yvLR64ZuXXUOYBRBtfhwAMUKuVC6CrkNZYydVm9wrKn23Wrw+miMrYMxKygqE4CQ87FF6YPgeGyudewqPU++oaR2jcE3wnl2DnZlECtn+Z9YS28pjlF01ueg+4vNHy0LyqL9H35pE/K7+Y+JzGMNsa/3x+i
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d317010-0e14-4ce6-7c6e-08d66040bc6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2018 14:47:29.0812
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1372
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-12-12_04:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 28 May 2018, at 1:48, Ethan Lien wrote:

It took me a while to trigger, but this actually deadlocks ;)  More=20
below.

> [Problem description and how we fix it]
> We should balance dirty metadata pages at the end of
> btrfs_finish_ordered_io, since a small, unmergeable random write can
> potentially produce dirty metadata which is multiple times larger than
> the data itself. For example, a small, unmergeable 4KiB write may
> produce:
>
>     16KiB dirty leaf (and possibly 16KiB dirty node) in subvolume tree
>     16KiB dirty leaf (and possibly 16KiB dirty node) in checksum tree
>     16KiB dirty leaf (and possibly 16KiB dirty node) in extent tree
>
> Although we do call balance dirty pages in write side, but in the
> buffered write path, most metadata are dirtied only after we reach the
> dirty background limit (which by far only counts dirty data pages) and
> wakeup the flusher thread. If there are many small, unmergeable random
> writes spread in a large btree, we'll find a burst of dirty pages
> exceeds the dirty_bytes limit after we wakeup the flusher thread -=20
> which
> is not what we expect. In our machine, it caused out-of-memory problem
> since a page cannot be dropped if it is marked dirty.
>
> Someone may worry about we may sleep in=20
> btrfs_btree_balance_dirty_nodelay,
> but since we do btrfs_finish_ordered_io in a separate worker, it will=20
> not
> stop the flusher consuming dirty pages. Also, we use different worker=20
> for
> metadata writeback endio, sleep in btrfs_finish_ordered_io help us=20
> throttle
> the size of dirty metadata pages.

In general, slowing down btrfs_finish_ordered_io isn't ideal because it=20
adds latency to places we need to finish quickly.  Also,=20
btrfs_finish_ordered_io is used by the free space cache.  Even though=20
this happens from its own workqueue, it means completing free space=20
cache writeback may end up waiting on balance_dirty_pages, something=20
like this stack trace:

12260 kworker/u96:16+btrfs-freespace-write D
[<0>] balance_dirty_pages+0x6e6/0x7ad
[<0>] balance_dirty_pages_ratelimited+0x6bb/0xa90
[<0>] btrfs_finish_ordered_io+0x3da/0x770
[<0>] normal_work_helper+0x1c5/0x5a0
[<0>] process_one_work+0x1ee/0x5a0
[<0>] worker_thread+0x46/0x3d0
[<0>] kthread+0xf5/0x130
[<0>] ret_from_fork+0x24/0x30
[<0>] 0xffffffffffffffff

Transaction commit will wait on the freespace cache:

838 btrfs-transacti D
[<0>] btrfs_start_ordered_extent+0x154/0x1e0
[<0>] btrfs_wait_ordered_range+0xbd/0x110
[<0>] __btrfs_wait_cache_io+0x49/0x1a0
[<0>] btrfs_write_dirty_block_groups+0x10b/0x3b0
[<0>] commit_cowonly_roots+0x215/0x2b0
[<0>] btrfs_commit_transaction+0x37e/0x910
[<0>] transaction_kthread+0x14d/0x180
[<0>] kthread+0xf5/0x130
[<0>] ret_from_fork+0x24/0x30
[<0>] 0xffffffffffffffff

And then writepages ends up waiting on transaction commit:

9520 kworker/u96:13+flush-btrfs-1 D
[<0>] wait_current_trans+0xac/0xe0
[<0>] start_transaction+0x21b/0x4b0
[<0>] cow_file_range_inline+0x10b/0x6b0
[<0>] cow_file_range.isra.69+0x329/0x4a0
[<0>] run_delalloc_range+0x105/0x3c0
[<0>] writepage_delalloc+0x119/0x180
[<0>] __extent_writepage+0x10c/0x390
[<0>] extent_write_cache_pages+0x26f/0x3d0
[<0>] extent_writepages+0x4f/0x80
[<0>] do_writepages+0x17/0x60
[<0>] __writeback_single_inode+0x59/0x690
[<0>] writeback_sb_inodes+0x291/0x4e0
[<0>] __writeback_inodes_wb+0x87/0xb0
[<0>] wb_writeback+0x3bb/0x500
[<0>] wb_workfn+0x40d/0x610
[<0>] process_one_work+0x1ee/0x5a0
[<0>] worker_thread+0x1e0/0x3d0
[<0>] kthread+0xf5/0x130
[<0>] ret_from_fork+0x24/0x30
[<0>] 0xffffffffffffffff

Eventually, we have every process in the system waiting on=20
balance_dirty_pages(), and nobody is able to make progress on page=20
writeback.

>
> [Reproduce steps]

[ ... ]

>
> V2:
> 	Replace btrfs_btree_balance_dirty with=20
> btrfs_btree_balance_dirty_nodelay.
> 	Add reproduce steps.
>
>  fs/btrfs/inode.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 8e604e7071f1..e54547df24ee 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3158,6 +3158,8 @@ static int btrfs_finish_ordered_io(struct=20
> btrfs_ordered_extent *ordered_extent)
>  	/* once for the tree */
>  	btrfs_put_ordered_extent(ordered_extent);
>
> +	btrfs_btree_balance_dirty_nodelay(fs_info);
> +
>  	return ret;
>  }


The original OOM you describe feels like an MM bug to me, but I'm going=20
to try the repro steps here.  Since the freespace cache has its own=20
workqueue, we could fix the deadlock just by wrapping the=20
balance_dirty_pages call in a check for the freespace inode.  But, I=20
think we'll get better performance by nudging the fix outside of=20
btrfs_finish_ordered_io.  I'll see if I can reproduce.

-chris
