Return-Path: <SRS0=8r0n=QU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8774C282C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 16:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7991421904
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 16:02:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BMW3Ezpn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733059AbfBMQCz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Feb 2019 11:02:55 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41276 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729649AbfBMQCy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Feb 2019 11:02:54 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1DFmk2S079905;
        Wed, 13 Feb 2019 16:02:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=hcC40q8mPqF/l1yAfiDL6Y+efm0QpYThI35/eJFTmsQ=;
 b=BMW3EzpnX1Y3lW599GtOptz8iDvjLq75Vu0Nbf5JuTLFN/6uKuTvyZXI14ZEnNcvLq32
 0wW6sL11a2CZtdTB0iR9FaiTy9vrBU98Rwskmwt92uDrgHvHG3cEN1rY/eKYwYqmJDSV
 1xCF7nebvs3zdKwbpNpp4g7ugTxhTTkGJGP4+N6OE0PCHp3fUc4aRFz5aUJNpWe0leW4
 H6/iik1twQp7w1w3i5YhmYZhXoHuBnQ2o3Hhg13KLpdlxgL8qmzNVf7Ywww6I2ruX/uf
 WY1sbQOcn+4DlkBapMszsGILQuKF5LLdggt8v+JWGvTsTOB7KfSnOzo6GXiDngOfNMzi xQ== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2qhree2w8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Feb 2019 16:02:50 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1DG2n2o021719
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Feb 2019 16:02:49 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1DG2map006880;
        Wed, 13 Feb 2019 16:02:48 GMT
Received: from [172.20.10.2] (/157.45.214.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Feb 2019 16:02:48 +0000
Subject: Re: [PATCH v4 1/3] btrfs: scrub: fix circular locking dependency
 warning
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1548830702-14676-1-git-send-email-anand.jain@oracle.com>
 <1548830702-14676-2-git-send-email-anand.jain@oracle.com>
 <20190212164522.GE2900@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <ce95f62f-dcf3-5364-3449-b4e23f28dd5f@oracle.com>
Date:   Thu, 14 Feb 2019 00:02:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190212164522.GE2900@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9165 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902130114
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2/13/19 12:45 AM, David Sterba wrote:
> On Wed, Jan 30, 2019 at 02:45:00PM +0800, Anand Jain wrote:
>> Circular locking dependency check reports warning[1], that's because
>> the btrfs_scrub_dev() calls the stack #0 below with, the
>> fs_info::scrub_lock held. The test case leading to this warning..
>>
>>    mkfs.btrfs -fq /dev/sdb && mount /dev/sdb /btrfs
>>    btrfs scrub start -B /btrfs
>>
>> In fact we have fs_info::scrub_workers_refcnt to tack if the init and
>> destroy of the scrub workers are needed. So once we have incremented
>> and decremented the fs_info::scrub_workers_refcnt value in the thread,
>> its ok to drop the scrub_lock, and then actually do the
>> btrfs_destroy_workqueue() part. So this patch drops the scrub_lock
>> before calling btrfs_destroy_workqueue().
>>
>> [1]
>> [   76.146826] ======================================================
>> [   76.147086] WARNING: possible circular locking dependency detected
>> [   76.147316] 4.20.0-rc3+ #41 Not tainted
>> [   76.147489] ------------------------------------------------------
>> [   76.147722] btrfs/4065 is trying to acquire lock:
>> [   76.147984] 0000000038593bc0 ((wq_completion)"%s-%s""btrfs",
>> name){+.+.}, at: flush_workqueue+0x70/0x4d0
>> [   76.148337]
>> but task is already holding lock:
>> [   76.148594] 0000000062392ab7 (&fs_info->scrub_lock){+.+.}, at:
>> btrfs_scrub_dev+0x316/0x5d0 [btrfs]
>> [   76.148909]
>> which lock already depends on the new lock.
>>
>> [   76.149191]
>> the existing dependency chain (in reverse order) is:
>> [   76.149446]
>> -> #3 (&fs_info->scrub_lock){+.+.}:
>> [   76.149707]        btrfs_scrub_dev+0x11f/0x5d0 [btrfs]
>> [   76.149924]        btrfs_ioctl+0x1ac3/0x2d80 [btrfs]
>> [   76.150216]        do_vfs_ioctl+0xa9/0x6d0
>> [   76.150468]        ksys_ioctl+0x60/0x90
>> [   76.150716]        __x64_sys_ioctl+0x16/0x20
>> [   76.150911]        do_syscall_64+0x50/0x180
>> [   76.151182]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> [   76.151469]
>> -> #2 (&fs_devs->device_list_mutex){+.+.}:
>> [   76.151851]        reada_start_machine_worker+0xca/0x3f0 [btrfs]
>> [   76.152195]        normal_work_helper+0xf0/0x4c0 [btrfs]
>> [   76.152489]        process_one_work+0x1f4/0x520
>> [   76.152751]        worker_thread+0x46/0x3d0
>> [   76.153715]        kthread+0xf8/0x130
>> [   76.153912]        ret_from_fork+0x3a/0x50
>> [   76.154178]
>> -> #1 ((work_completion)(&work->normal_work)){+.+.}:
>> [   76.154575]        worker_thread+0x46/0x3d0
>> [   76.154828]        kthread+0xf8/0x130
>> [   76.155108]        ret_from_fork+0x3a/0x50
>> [   76.155357]
>> -> #0 ((wq_completion)"%s-%s""btrfs", name){+.+.}:
>> [   76.155751]        flush_workqueue+0x9a/0x4d0
>> [   76.155911]        drain_workqueue+0xca/0x1a0
>> [   76.156182]        destroy_workqueue+0x17/0x230
>> [   76.156455]        btrfs_destroy_workqueue+0x5d/0x1c0 [btrfs]
>> [   76.156756]        scrub_workers_put+0x2e/0x60 [btrfs]
>> [   76.156931]        btrfs_scrub_dev+0x329/0x5d0 [btrfs]
>> [   76.157219]        btrfs_ioctl+0x1ac3/0x2d80 [btrfs]
>> [   76.157491]        do_vfs_ioctl+0xa9/0x6d0
>> [   76.157742]        ksys_ioctl+0x60/0x90
>> [   76.157910]        __x64_sys_ioctl+0x16/0x20
>> [   76.158177]        do_syscall_64+0x50/0x180
>> [   76.158429]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> [   76.158716]
>> other info that might help us debug this:
>>
>> [   76.158908] Chain exists of:
>>    (wq_completion)"%s-%s""btrfs", name --> &fs_devs->device_list_mutex
>> --> &fs_info->scrub_lock
>>
>> [   76.159629]  Possible unsafe locking scenario:
>>
>> [   76.160607]        CPU0                    CPU1
>> [   76.160934]        ----                    ----
>> [   76.161210]   lock(&fs_info->scrub_lock);
>> [   76.161458]
>> lock(&fs_devs->device_list_mutex);
>> [   76.161805]
>> lock(&fs_info->scrub_lock);
>> [   76.161909]   lock((wq_completion)"%s-%s""btrfs", name);
>> [   76.162201]
>>   *** DEADLOCK ***
> 
> Please next time make sure the log messages are copied without
> whitespace damage. In many cases it's easy to glue the lines together,
> but specially the above locking scenario needs to be exact as the
> indentaion matters.
> 
> I'll replace the whole report with the one in my logs as it does not
> have the device_list_mutex in the locking chain. This would be confusing
> as the problem with device_list_mutex was fixed already.

  ok. Thanks.

-Anand

>>
>> [   76.162627] 2 locks held by btrfs/4065:
>> [   76.162897]  #0: 00000000bef2775b (sb_writers#12){.+.+}, at:
>> mnt_want_write_file+0x24/0x50
>> [   76.163335]  #1: 0000000062392ab7 (&fs_info->scrub_lock){+.+.}, at:
>> btrfs_scrub_dev+0x316/0x5d0 [btrfs]
>> [   76.163796]
>> stack backtrace:
>> [   76.163911] CPU: 1 PID: 4065 Comm: btrfs Not tainted 4.20.0-rc3+ #41
>> [   76.164228] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
>> VirtualBox 12/01/2006
>> [   76.164646] Call Trace:
>> [   76.164872]  dump_stack+0x5e/0x8b
>> [   76.165128]  print_circular_bug.isra.37+0x1f1/0x1fe
>> [   76.165398]  __lock_acquire+0x14aa/0x1620
>> [   76.165652]  lock_acquire+0xb0/0x190
>> [   76.165910]  ? flush_workqueue+0x70/0x4d0
>> [   76.166175]  flush_workqueue+0x9a/0x4d0
>> [   76.166420]  ? flush_workqueue+0x70/0x4d0
>> [   76.166671]  ? drain_workqueue+0x52/0x1a0
>> [   76.166911]  drain_workqueue+0xca/0x1a0
>> [   76.167167]  destroy_workqueue+0x17/0x230
>> [   76.167428]  btrfs_destroy_workqueue+0x5d/0x1c0 [btrfs]
>> [   76.167720]  scrub_workers_put+0x2e/0x60 [btrfs]
>> [   76.168233]  btrfs_scrub_dev+0x329/0x5d0 [btrfs]
>> [   76.168504]  ? __sb_start_write+0x121/0x1b0
>> [   76.168759]  ? mnt_want_write_file+0x24/0x50
>> [   76.169654]  btrfs_ioctl+0x1ac3/0x2d80 [btrfs]
>> [   76.169934]  ? find_held_lock+0x2d/0x90
>> [   76.170204]  ? find_held_lock+0x2d/0x90
>> [   76.170450]  do_vfs_ioctl+0xa9/0x6d0
>> [   76.170690]  ? __fget+0x101/0x1f0
>> [   76.170910]  ? __fget+0x5/0x1f0
>> [   76.171157]  ksys_ioctl+0x60/0x90
>> [   76.171391]  __x64_sys_ioctl+0x16/0x20
>> [   76.171634]  do_syscall_64+0x50/0x180
>> [   76.171892]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> [   76.172186] RIP: 0033:0x7f61d422e567
>> [   76.172425] Code: 44 00 00 48 8b 05 29 09 2d 00 64 c7 00 26 00 00 00
>> 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f
>> 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d f9 08 2d 00 f7 d8 64 89 01 48
> 
> This like can be ommitted from the log unless we really want to decode
> the instructions.
> 
