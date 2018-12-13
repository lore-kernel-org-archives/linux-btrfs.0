Return-Path: <SRS0=1olR=OW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,T_MIXED_ES,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C926DC6786C
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 02:12:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82A8420851
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 02:12:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="4fFnFOJ/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82A8420851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbeLMCMs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 21:12:48 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50502 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbeLMCMs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 21:12:48 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wBD23v6B083176;
        Thu, 13 Dec 2018 02:12:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=s25GGfROdLmLdqa3m06NXcFv0H4T1EUcU0SPUQ/FenI=;
 b=4fFnFOJ/cTJ9DwjI+fIS1ihCWwnROfFlF1czY3P2njgRqKJx6Xn8JCpeG1xhx6LyzIj6
 99tfOcEOyzD+ZmVjeoDGIklncOvoohsQbl4W5PBQvmjGRgIYv33k7m6wdJuOlyTkASA3
 slLTu4nwLfThDlf+qgXv5xnzK15bDkudz0+xE2AZzJxzN853P+YlD9V3FHevNFZLb5BN
 ZhtYpRhxtNxUBL8aS+gIx3Evbzax6xAVdWe5KNU5hyvXdQfxwJ+Jb0tX0D10dFKkOL0a
 8zOCHdVsxd/DQ8q9fACxADPbp6f13QPCmuzKiZDRzs8eO7evbt+9kvklZB8paljXZl0t PA== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2pb7tf1f5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Dec 2018 02:12:43 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wBD2Cc1P023232
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Dec 2018 02:12:38 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wBD2Cb2k029215;
        Thu, 13 Dec 2018 02:12:38 GMT
Received: from [172.20.10.2] (/157.49.247.44)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Dec 2018 18:12:37 -0800
Subject: Re: [PATCH v3 1/2] btrfs: scrub: fix circular locking dependency
 warning
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1543554924-17397-1-git-send-email-anand.jain@oracle.com>
 <1543554924-17397-2-git-send-email-anand.jain@oracle.com>
 <20181204111625.GK17773@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <afd5425c-5db3-b68f-3cf0-fdab4fa123c3@oracle.com>
Date:   Thu, 13 Dec 2018 10:12:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181204111625.GK17773@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9105 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1812130017
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 12/04/2018 07:16 PM, David Sterba wrote:
> On Fri, Nov 30, 2018 at 01:15:23PM +0800, Anand Jain wrote:
>> @@ -3757,10 +3757,13 @@ static noinline_for_stack int scrub_workers_get(struct btrfs_fs_info *fs_info,
>>   
>>   static noinline_for_stack void scrub_workers_put(struct btrfs_fs_info *fs_info)
>>   {
>> +	lockdep_assert_held(&fs_info->scrub_lock);

[1]
>>   	if (--fs_info->scrub_workers_refcnt == 0) {
>> +		mutex_unlock(&fs_info->scrub_lock);
>>   		btrfs_destroy_workqueue(fs_info->scrub_workers);
>>   		btrfs_destroy_workqueue(fs_info->scrub_wr_completion_workers);
>>   		btrfs_destroy_workqueue(fs_info->scrub_parity_workers);
>> +		mutex_lock(&fs_info->scrub_lock);
>>   	}
>>   	WARN_ON(fs_info->scrub_workers_refcnt < 0);
>>   }
> 
> btrfs/011 lockdep warning is gone, but now there's a list corruption
> reported by btrfs/073. I'm testing the 2 patches on top of current
> master to avoid interference with misc-next patches.

  Sorry for the delay due to my vacation.
  Thanks for the report, btrfs/073 exposed this on your test setup,
  it didn't on mine.

  I think I know what is happening.. now as scrub_worker_refcnt is zero
  [1] (above) and scrub_lock is released, the scrub_workers_get() can
  create a new worker even before the btrfs_destroy_workqueue() is
  completed. I am trying to prove this theory with traps.

  scrub threads has week synchronization, and assumes btrfs-progs is the
  only process which can call scrub-ioctl, apparently its not true.
  To fix it needs a bit of complete revival which I was trying to avoid.
  Let me try if there is a better fix for this.

Thanks, Anand

> btrfs/073               [11:07:19]
> [ 3580.466293] run fstests btrfs/073at 2018-12-04 11:07:19
> [ 3580.610367] BTRFS info (device vda): disk space caching is enabled
> [ 3580.612809] BTRFS info (device vda): has skinny extents
> [ 3580.876639] BTRFS: device fsid d452261d-c956-4b54-aab9-8318c3c211fcdevid 1 transid 5 /dev/vdb
> [ 3580.880569] BTRFS: device fsid d452261d-c956-4b54-aab9-8318c3c211fcdevid 2 transid 5 /dev/vdc
> [ 3580.882947] BTRFS: device fsid d452261d-c956-4b54-aab9-8318c3c211fcdevid 3 transid 5 /dev/vdd
> [ 3580.885499] BTRFS: device fsid d452261d-c956-4b54-aab9-8318c3c211fcdevid 4 transid 5 /dev/vde
> [ 3580.887972] BTRFS: device fsid d452261d-c956-4b54-aab9-8318c3c211fcdevid 5 transid 5 /dev/vdf
> [ 3580.890394] BTRFS: device fsid d452261d-c956-4b54-aab9-8318c3c211fcdevid 6 transid 5 /dev/vdg
> [ 3580.893729] BTRFS: device fsid d452261d-c956-4b54-aab9-8318c3c211fcdevid 7 transid 5 /dev/vdh
> [ 3580.903180] BTRFS info (device vdb): disk space caching is enabled
> [ 3580.904538] BTRFS info (device vdb): has skinny extents
> [ 3580.905322] BTRFS info (device vdb): flagging fs with big metadatafeature
> [ 3580.908555] BTRFS info (device vdb): checking UUID tree
> [ 3580.951440] ------------[ cut here ]------------
> [ 3580.954122] list_add corruption. prev->next should be next(ffffa189faa9acc8), but was ffffa189faa9adc0. (prev=ffffa189faa9a480).
> [ 3580.960061] WARNING: CPU: 0 PID: 24578 at lib/list_debug.c:28__list_add_valid+0x4d/0x70
> [ 3580.962346] BTRFS info (device vdb): use no compression, level 0
> [ 3580.963694] Modules linked in: dm_flakey dm_mod btrfs libcrc32c xorzstd_decompress zstd_compress xxhash raid6_pq loop
> [ 3580.963702] CPU: 0 PID: 24578 Comm: btrfs Not tainted4.20.0-rc5-default+ #366
> [ 3580.963703] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),BIOS rel-1.11.2-0-gf9626cc-prebuilt.qemu-project.org 04/01/2014
> [ 3580.963706] RIP: 0010:__list_add_valid+0x4d/0x70
> [ 3580.963708] RSP: 0018:ffffb72d88817b90 EFLAGS: 00010286
> [ 3580.963709] RAX: 0000000000000000 RBX: ffffb72d88817c10 RCX:0000000000000000
> [ 3580.963710] RDX: 0000000000000002 RSI: 0000000000000001 RDI:ffffffff860c4c1d
> [ 3580.963710] RBP: ffffa189faa9acc8 R08: 0000000000000001 R09:0000000000000000
> [ 3580.963714] R10: 0000000000000000 R11: ffffffff882a0a2d R12:ffffa189faa9ac70
> [ 3580.966020] BTRFS info (device vdb): disk space caching is enabled
> [ 3580.967721] R13: ffffa189faa9a480 R14: ffffa189faa9ac70 R15:ffffa189faa9ac78
> [ 3580.967724] FS:  00007f04289d1700(0000) GS:ffffa189fd400000(0000)knlGS:0000000000000000
> [ 3580.967725] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 3580.967725] CR2: 00007f7b58b034ac CR3: 00000000699d9000 CR4:00000000000006f0
> [ 3580.967729] Call Trace:
> [ 3580.967736]  __mutex_add_waiter+0x34/0x70
> [ 3580.967743]  ? drain_workqueue+0x1e/0x180
> [ 3580.994465]  __mutex_lock+0x134/0x9d0
> [ 3580.995526]  ? __schedule+0x2eb/0xb20
> [ 3580.996584]  ? drain_workqueue+0x1e/0x180
> [ 3580.997727]  drain_workqueue+0x1e/0x180
> [ 3580.998793]  destroy_workqueue+0x17/0x240
> [ 3580.999879]  btrfs_destroy_workqueue+0x57/0x200 [btrfs]
> [ 3581.001148]  scrub_workers_put+0x6c/0x90 [btrfs]
> [ 3581.002257]  btrfs_scrub_dev+0x2f6/0x590 [btrfs]
> [ 3581.003370]  ? __sb_start_write+0x12c/0x1d0
> [ 3581.004450]  ? mnt_want_write_file+0x24/0x60
> [ 3581.005613]  btrfs_ioctl+0xfc7/0x2f00 [btrfs]
> [ 3581.006361]  ? get_task_io_context+0x2d/0x90
> [ 3581.007025]  ? do_vfs_ioctl+0xa2/0x6d0
> [ 3581.007699]  do_vfs_ioctl+0xa2/0x6d0
> [ 3581.008603]  ? __fget+0x109/0x1e0
> [ 3581.009413]  ksys_ioctl+0x3a/0x70
> [ 3581.010326]  __x64_sys_ioctl+0x16/0x20
> [ 3581.011234]  do_syscall_64+0x54/0x180
> [ 3581.012143]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [ 3581.013213] RIP: 0033:0x7f042bac9aa7
> [ 3581.014133] Code: 00 00 90 48 8b 05 f1 83 2c 00 64 c7 00 26 00 00 0048 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c1 83 2c 00 f7 d8 64 89 01 48
> [ 3581.018486] RSP: 002b:00007f04289d0d38 EFLAGS: 00000246 ORIG_RAX:0000000000000010
> [ 3581.019703] RAX: ffffffffffffffda RBX: 000055c05475de10 RCX:00007f042bac9aa7
> [ 3581.021465] RDX: 000055c05475de10 RSI: 00000000c400941b RDI:0000000000000003
> [ 3581.023120] RBP: 0000000000000000 R08: 00007f04289d1700 R09:0000000000000000
> [ 3581.024968] R10: 00007f04289d1700 R11: 0000000000000246 R12:00007ffd6b29a03e
> [ 3581.027977] R13: 00007ffd6b29a03f R14: 00007ffd6b29a040 R15:0000000000000000
> [ 3581.029767] irq event stamp: 0
> [ 3581.030631] hardirqs last  enabled at (0): [<0000000000000000>](null)
> [ 3581.032630] hardirqs last disabled at (0): [<ffffffff8605c23b>]copy_process.part.72+0x86b/0x1e20
> [ 3581.034970] softirqs last  enabled at (0): [<ffffffff8605c23b>]copy_process.part.72+0x86b/0x1e20
> [ 3581.037224] softirqs last disabled at (0): [<0000000000000000>](null)
> [ 3581.038955] ---[ end trace f0e217183915884a ]---
> 
