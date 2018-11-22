Return-Path: <SRS0=krA0=OB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC6DCC43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 12:47:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C571206B2
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 12:47:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C571206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436726AbeKVX0Q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 18:26:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:46536 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2436645AbeKVX0Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 18:26:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8A9CCAC4B;
        Thu, 22 Nov 2018 12:46:58 +0000 (UTC)
Subject: Re: btrfs-cleaner 100% busy on an idle filesystem with 4.19.3
To:     Tomasz Chmielewski <tch@virtall.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <ca2de2a36290496ccf41b6ed23c799d8@virtall.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <f9e07d50-be2e-36fb-8953-2419200522f0@suse.com>
Date:   Thu, 22 Nov 2018 14:46:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <ca2de2a36290496ccf41b6ed23c799d8@virtall.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 22.11.18 г. 14:31 ч., Tomasz Chmielewski wrote:
> Yet another system upgraded to 4.19 and showing strange issues.
> 
> btrfs-cleaner is showing as ~90-100% busy in iotop:
> 
>    TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN     IO>    COMMAND
>   1340 be/4 root        0.00 B/s    0.00 B/s  0.00 % 92.88 %
> [btrfs-cleaner]
> 
> 
> Note disk read, disk write are 0.00 B/s.
> 
> 
> iostat -mx 1 shows all disks are ~100% busy, yet there are 0 reads and 0
> writes to them:
> 
> Device            r/s     w/s     rMB/s     wMB/s   rrqm/s   wrqm/s 
> %rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
> sda              0.00    0.00      0.00      0.00     0.00     0.00  
> 0.00   0.00    0.00    0.00   0.91     0.00     0.00   0.00  90.80
> sdb              0.00    0.00      0.00      0.00     0.00     0.00  
> 0.00   0.00    0.00    0.00   1.00     0.00     0.00   0.00 100.00
> sdc              0.00    0.00      0.00      0.00     0.00     0.00  
> 0.00   0.00    0.00    0.00   1.00     0.00     0.00   0.00 100.00
> 
> 
> 
> btrfs-cleaner persists 100% busy after reboots. The system is generally
> not very responsive.
> 
> 
> 
> # echo w > /proc/sysrq-trigger
> 
> # dmesg -c
> [  931.585611] sysrq: SysRq : Show Blocked State
> [  931.585715]   task                        PC stack   pid father
> [  931.590168] btrfs-cleaner   D    0  1340      2 0x80000000
> [  931.590175] Call Trace:
> [  931.590190]  __schedule+0x29e/0x840
> [  931.590195]  schedule+0x2c/0x80
> [  931.590199]  schedule_timeout+0x258/0x360
> [  931.590204]  io_schedule_timeout+0x1e/0x50
> [  931.590208]  wait_for_completion_io+0xb7/0x140
> [  931.590214]  ? wake_up_q+0x80/0x80
> [  931.590219]  submit_bio_wait+0x61/0x90
> [  931.590225]  blkdev_issue_discard+0x7a/0xd0
> [  931.590266]  btrfs_issue_discard+0x123/0x160 [btrfs]
> [  931.590299]  btrfs_discard_extent+0xd8/0x160 [btrfs]
> [  931.590335]  btrfs_finish_extent_commit+0xe2/0x240 [btrfs]
> [  931.590382]  btrfs_commit_transaction+0x573/0x840 [btrfs]
> [  931.590415]  ? btrfs_block_rsv_check+0x25/0x70 [btrfs]
> [  931.590456]  __btrfs_end_transaction+0x2be/0x2d0 [btrfs]
> [  931.590493]  btrfs_end_transaction_throttle+0x13/0x20 [btrfs]
> [  931.590530]  btrfs_drop_snapshot+0x489/0x800 [btrfs]
> [  931.590567]  btrfs_clean_one_deleted_snapshot+0xbb/0xf0 [btrfs]
> [  931.590607]  cleaner_kthread+0x136/0x160 [btrfs]
> [  931.590612]  kthread+0x120/0x140
> [  931.590646]  ? btree_submit_bio_start+0x20/0x20 [btrfs]
> [  931.590658]  ? kthread_bind+0x40/0x40
> [  931.590661]  ret_from_fork+0x22/0x40
> 



It seems your filesystem is mounted with the DSICARD option meaning
every delete will result in discard this is highly suboptimal for ssd's.
Try remounting the fs without the discard option see if it helps.
Generally for discard you want to submit it in big batches (what fstrim
does) so that the ftl on the ssd could apply any optimisations it might
have up its sleeve.


Would you finally care to share the smart data + the model and make of
the ssd?

> 
> 
> 
> After rebooting to 4.19.3, I've started seeing read errors. There were
> no errors with a previous kernel (4.17.14); disks are healthy according
> to SMART; no errors reported when we read the whole surface with dd.
> 
> # grep -i btrfs.*corrected /var/log/syslog|wc -l
> 156
> 
> Things like:
> 
> Nov 22 12:17:43 lxd05 kernel: [  711.538836] BTRFS info (device sda2):
> read error corrected: ino 0 off 3739083145216 (dev /dev/sdc2 sector
> 101088384)
> Nov 22 12:17:43 lxd05 kernel: [  711.538905] BTRFS info (device sda2):
> read error corrected: ino 0 off 3739083149312 (dev /dev/sdc2 sector
> 101088392)
> Nov 22 12:17:43 lxd05 kernel: [  711.538958] BTRFS info (device sda2):
> read error corrected: ino 0 off 3739083153408 (dev /dev/sdc2 sector
> 101088400)
> Nov 22 12:17:43 lxd05 kernel: [  711.539006] BTRFS info (device sda2):
> read error corrected: ino 0 off 3739083157504 (dev /dev/sdc2 sector
> 101088408)
> 
> 
> Yet - 0 errors, according to stats, not sure if it's expected or not:

Since btrfs was able to fix the read failure on the fly it doesn't
record the error.  IMO you have problems with your storage below the
filesystem level.

> 
> # btrfs device stats /data/lxd
> [/dev/sda2].write_io_errs    0
> [/dev/sda2].read_io_errs     0
> [/dev/sda2].flush_io_errs    0
> [/dev/sda2].corruption_errs  0
> [/dev/sda2].generation_errs  0
> [/dev/sdb2].write_io_errs    0
> [/dev/sdb2].read_io_errs     0
> [/dev/sdb2].flush_io_errs    0
> [/dev/sdb2].corruption_errs  0
> [/dev/sdb2].generation_errs  0
> [/dev/sdc2].write_io_errs    0
> [/dev/sdc2].read_io_errs     0
> [/dev/sdc2].flush_io_errs    0
> [/dev/sdc2].corruption_errs  0
> [/dev/sdc2].generation_errs  0
> 
> 

<snip>
