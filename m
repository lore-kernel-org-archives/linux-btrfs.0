Return-Path: <SRS0=krA0=OB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C11FC43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 13:07:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F0DB20684
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 13:07:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=virtall.com header.i=@virtall.com header.b="Fug67Px8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F0DB20684
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=virtall.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388557AbeKVXqq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 18:46:46 -0500
Received: from mail.virtall.com ([46.4.129.203]:56532 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730060AbeKVXqq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 18:46:46 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id 119E8369A72B;
        Thu, 22 Nov 2018 13:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtall.com;
        s=default; t=1542892047;
        bh=uK5BXQ5Dek8BWW7+8H91dOPCnKFUAoTtUWHpX1d4aYU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=Fug67Px8aLLgCPXAP6dueV52Ni69kc6CToJTMVfwHfbzInLmArZkAPpaESjrwNcSB
         1u2cm3gIW6YTmhwyzikwdZ8vqjXKEhQyJlA3pYS8GcnqX1+DUnDdZZxI8d4W2ufNku
         J/nzSr+rxr2LZN5MEwVMO7qnG4njTujzoOaKbsc/WDsdLBXHbjhFZLw4+DLEcnUF7w
         xah8kU+vMSUKdJ+Wq/73dZh1Ha6FpWxfwTRDEBPuLj82yK8lLf9IkJsEeewaE1KObF
         DwBct2fITs2sByj5MPfiaTV6+v8Im8Nu9pROmd5yPS6hKOMjzHngn8Z4I1cCzVdfC2
         yoFoRSYjo5GQA==
X-Fuglu-Suspect: d998dff7a8c64b029f4e448ba0342594
X-Fuglu-Spamstatus: NO
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA;
        Thu, 22 Nov 2018 13:07:26 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 22 Nov 2018 22:07:25 +0900
From:   Tomasz Chmielewski <tch@virtall.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-cleaner 100% busy on an idle filesystem with 4.19.3
In-Reply-To: <f9e07d50-be2e-36fb-8953-2419200522f0@suse.com>
References: <ca2de2a36290496ccf41b6ed23c799d8@virtall.com>
 <f9e07d50-be2e-36fb-8953-2419200522f0@suse.com>
Message-ID: <0df02574bdf0fb676cee7b5a3d1890e3@virtall.com>
X-Sender: tch@virtall.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2018-11-22 21:46, Nikolay Borisov wrote:

>> # echo w > /proc/sysrq-trigger
>> 
>> # dmesg -c
>> [  931.585611] sysrq: SysRq : Show Blocked State
>> [  931.585715]   task                        PC stack   pid father
>> [  931.590168] btrfs-cleaner   D    0  1340      2 0x80000000
>> [  931.590175] Call Trace:
>> [  931.590190]  __schedule+0x29e/0x840
>> [  931.590195]  schedule+0x2c/0x80
>> [  931.590199]  schedule_timeout+0x258/0x360
>> [  931.590204]  io_schedule_timeout+0x1e/0x50
>> [  931.590208]  wait_for_completion_io+0xb7/0x140
>> [  931.590214]  ? wake_up_q+0x80/0x80
>> [  931.590219]  submit_bio_wait+0x61/0x90
>> [  931.590225]  blkdev_issue_discard+0x7a/0xd0
>> [  931.590266]  btrfs_issue_discard+0x123/0x160 [btrfs]
>> [  931.590299]  btrfs_discard_extent+0xd8/0x160 [btrfs]
>> [  931.590335]  btrfs_finish_extent_commit+0xe2/0x240 [btrfs]
>> [  931.590382]  btrfs_commit_transaction+0x573/0x840 [btrfs]
>> [  931.590415]  ? btrfs_block_rsv_check+0x25/0x70 [btrfs]
>> [  931.590456]  __btrfs_end_transaction+0x2be/0x2d0 [btrfs]
>> [  931.590493]  btrfs_end_transaction_throttle+0x13/0x20 [btrfs]
>> [  931.590530]  btrfs_drop_snapshot+0x489/0x800 [btrfs]
>> [  931.590567]  btrfs_clean_one_deleted_snapshot+0xbb/0xf0 [btrfs]
>> [  931.590607]  cleaner_kthread+0x136/0x160 [btrfs]
>> [  931.590612]  kthread+0x120/0x140
>> [  931.590646]  ? btree_submit_bio_start+0x20/0x20 [btrfs]
>> [  931.590658]  ? kthread_bind+0x40/0x40
>> [  931.590661]  ret_from_fork+0x22/0x40
>> 
> 
> It seems your filesystem is mounted with the DSICARD option meaning
> every delete will result in discard this is highly suboptimal for 
> ssd's.
> Try remounting the fs without the discard option see if it helps.
> Generally for discard you want to submit it in big batches (what fstrim
> does) so that the ftl on the ssd could apply any optimisations it might
> have up its sleeve.

Spot on!

Removed "discard" from fstab and added "ssd", rebooted - no more 
btrfs-cleaner running.

Do you know if the issue you described ("discard this is highly 
suboptimal for ssd") affects other filesystems as well to a similar 
extent? I.e. if using ext4 on ssd?


> Would you finally care to share the smart data + the model and make of
> the ssd?

2x these:

Model Family:     Samsung based SSDs
Device Model:     SAMSUNG MZ7LM1T9HCJM-00005
Firmware Version: GXT1103Q
User Capacity:    1,920,383,410,176 bytes [1.92 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    Solid State Device

1x this:

Device Model:     Micron_5200_MTFDDAK1T9TDC
Firmware Version: D1MU004
User Capacity:    1,920,383,410,176 bytes [1.92 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    Solid State Device
Form Factor:      2.5 inches


But - seems the issue was unneeded discard option, so not pasting 
unnecessary SMART data, thanks for finding this out.


Tomasz Chmielewski
