Return-Path: <SRS0=b0aI=NP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC7F5C32789
	for <linux-btrfs@archiver.kernel.org>; Sun,  4 Nov 2018 17:00:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 436322082E
	for <linux-btrfs@archiver.kernel.org>; Sun,  4 Nov 2018 17:00:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 436322082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cs.uni-bonn.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbeKECQD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 4 Nov 2018 21:16:03 -0500
Received: from smtp8.iai.uni-bonn.de ([131.220.63.194]:48456 "EHLO
        smtp8.iai.uni-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729019AbeKECQC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Nov 2018 21:16:02 -0500
X-IAI-Env-From: <ochmann@cs.uni-bonn.de> : [127.0.0.1]
Received: from smtp8.iai.uni-bonn.de (smtp8.iai.uni-bonn.de [127.0.0.1])
        by smtp8.iai.uni-bonn.de (Postfix) with ESMTP id 56BEDE095;
        Sun,  4 Nov 2018 18:00:17 +0100 (MET)
        (envelope-from ochmann@cs.uni-bonn.de)
        (envelope-to VARIOUS) (2)
X-IAI-Env-From: <ochmann@cs.uni-bonn.de> : [91.10.4.29]
Received: from [192.168.0.1] (p5B0A041D.dip0.t-ipconnect.de [91.10.4.29])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: ochmann@auth.iai.uni-bonn.de)
        by smtp8.iai.uni-bonn.de (Postfix) with ESMTPSA id 284D4E094;
        Sun,  4 Nov 2018 18:00:17 +0100 (MET)
        (envelope-from ochmann@cs.uni-bonn.de)
        (envelope-to VARIOUS) (2)
        (internal use: ta=1, tu=1, te=1, am=P, au=ochmann)
X-IAI-Auth: uoHwNgfr1RnVuWGWzDNfPabuCDkgMd2N5DqS6EiYI9HMkVoK7OXaGLSZLy/KvCenOkR6BNQFM0N25lFMwDpDeNhIxlJX4kqgeWsaCG4ZeG6jQ/SpSSbiTgAAAAAAAAAA@auth.iai.uni-bonn.de
Subject: Re: Filesystem mounts fine but hangs on access
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <f0e1900a-b242-06e0-b68f-0ddc146eca56@cs.uni-bonn.de>
 <7c69325a-7e95-7377-5a47-5c98eb941253@gmx.com>
Cc:     linux-btrfs@vger.kernel.org
From:   Sebastian Ochmann <ochmann@cs.uni-bonn.de>
Message-ID: <d493b9d8-2ed6-4dfa-d546-e9a09c5924a6@cs.uni-bonn.de>
Date:   Sun, 4 Nov 2018 18:00:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <7c69325a-7e95-7377-5a47-5c98eb941253@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Thank you very much for the quick reply.

On 04.11.18 14:37, Qu Wenruo wrote:
> 
> 
> On 2018/11/4 下午9:15, Sebastian Ochmann wrote:
>> Hello,
>>
>> I have a btrfs filesystem on a single encrypted (LUKS) 10 TB drive which
>> stopped working correctly. The drive is used as a backup drive with zstd
>> compression to which I regularly rsync and make daily snapshots. After I
>> routinely removed a bunch of snapshots (about 20), I noticed later that
>> the machine would hang when trying to unmount the filesystem. The
>> current state is that I'm able to mount the filesystem without errors
>> and I can view (ls) files in the root level, but trying to view contents
>> of directories contained therein hangs just like when trying to unmount
>> the filesystem. I have not yet tried to run check, repair, etc. Do you
>> have any advice what I should try next?
> 
> Could you please run "btrfs check" on the umounted fs?

I ran btrfs check on the unmounted fs and it reported no errors.

>>
>> A notable hardware change I did a few days before the problem is a
>> switch from an Intel Xeon platform to AMD Threadripper. However, I
>> haven't seen problems with the rest of the btrfs filesystems (in
>> particular, a RAID-1 consisting of three HDDs), which I also migrated to
>> the new platform, yet. I just want to mention it in case there are known
>> issues in that direction.
>>
>> Kernel 4.18.16 (Arch Linux)
>> btrfs-progs 4.17.1
>>
>> Kernel log after trying to "ls" a directory contained in the
>> filesystem's root directory:
>>
>> [   79.279349] BTRFS info (device dm-5): use zstd compression, level 0
>> [   79.279351] BTRFS info (device dm-5): disk space caching is enabled
>> [   79.279352] BTRFS info (device dm-5): has skinny extents
>> [  135.202344] kauditd_printk_skb: 2 callbacks suppressed
>> [  135.202347] audit: type=1130 audit(1541335770.667:45): pid=1 uid=0
>> auid=4294967295 ses=4294967295 msg='unit=polkit comm="systemd"
>> exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
>> [  135.364850] audit: type=1130 audit(1541335770.831:46): pid=1 uid=0
>> auid=4294967295 ses=4294967295 msg='unit=udisks2 comm="systemd"
>> exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
>> [  135.589255] audit: type=1130 audit(1541335771.054:47): pid=1 uid=0
>> auid=4294967295 ses=4294967295 msg='unit=rtkit-daemon comm="systemd"
>> exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
>> [  368.266653] INFO: task kworker/u256:1:728 blocked for more than 120
>> seconds.
>> [  368.266657]       Tainted: P           OE     4.18.16-arch1-1-ARCH #1
>> [  368.266658] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [  368.266660] kworker/u256:1  D    0   728      2 0x80000080
>> [  368.266680] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper
>> [btrfs]
>> [  368.266681] Call Trace:
>> [  368.266687]  ? __schedule+0x29b/0x8b0
>> [  368.266690]  ? preempt_count_add+0x68/0xa0
>> [  368.266692]  schedule+0x32/0x90
>> [  368.266707]  btrfs_tree_read_lock+0x7d/0x110 [btrfs]
>> [  368.266710]  ? wait_woken+0x80/0x80
>> [  368.266719]  btrfs_read_lock_root_node+0x2f/0x40 [btrfs]
>> [  368.266729]  btrfs_search_slot+0xf6/0xa00 [btrfs]
>> [  368.266732]  ? _raw_spin_unlock+0x16/0x30
>> [  368.266734]  ? inode_insert5+0x105/0x1a0
>> [  368.266746]  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
>> [  368.266749]  ? kmem_cache_alloc+0x179/0x1d0
>> [  368.266762]  btrfs_iget+0x113/0x690 [btrfs]
>> [  368.266764]  ? _raw_spin_unlock+0x16/0x30
>> [  368.266778]  __lookup_free_space_inode+0xd8/0x150 [btrfs]
>> [  368.266792]  lookup_free_space_inode+0x63/0xc0 [btrfs]
>> [  368.266806]  load_free_space_cache+0x6e/0x190 [btrfs]
>> [  368.266808]  ? kmem_cache_alloc_trace+0x181/0x1d0
>> [  368.266817]  ? cache_block_group+0x73/0x3e0 [btrfs]
>> [  368.266827]  cache_block_group+0x1c1/0x3e0 [btrfs]
> 
> This thread is trying to get tree root lock to create free space cache,
> while some one already has locked the tree root.
> 
>> [  368.266829]  ? wait_woken+0x80/0x80
>> [  368.266839]  find_free_extent+0x872/0x10e0 [btrfs]
>> [  368.266851]  btrfs_reserve_extent+0x9b/0x180 [btrfs]
>> [  368.266862]  btrfs_alloc_tree_block+0x1b3/0x4d0 [btrfs]
>> [  368.266872]  __btrfs_cow_block+0x11d/0x500 [btrfs]
>> [  368.266882]  btrfs_cow_block+0xdc/0x1a0 [btrfs]
>> [  368.266891]  btrfs_search_slot+0x282/0xa00 [btrfs]
>> [  368.266893]  ? _raw_spin_unlock+0x16/0x30
>> [  368.266903]  btrfs_insert_empty_items+0x67/0xc0 [btrfs]
>> [  368.266913]  __btrfs_run_delayed_refs+0x8ef/0x10a0 [btrfs]
>> [  368.266915]  ? preempt_count_add+0x68/0xa0
>> [  368.266926]  btrfs_run_delayed_refs+0x72/0x180 [btrfs]
>> [  368.266937]  delayed_ref_async_start+0x81/0x90 [btrfs]
>> [  368.266950]  normal_work_helper+0xbd/0x350 [btrfs]
>> [  368.266953]  process_one_work+0x1eb/0x3c0
>> [  368.266955]  worker_thread+0x2d/0x3d0
>> [  368.266956]  ? process_one_work+0x3c0/0x3c0
>> [  368.266958]  kthread+0x112/0x130
>> [  368.266960]  ? kthread_flush_work_fn+0x10/0x10
>> [  368.266961]  ret_from_fork+0x22/0x40
>> [  368.266978] INFO: task btrfs-cleaner:1196 blocked for more than 120
>> seconds.
> [snip, this trace doesn't look interesting at all]
>> [  368.267135] INFO: task btrfs-transacti:1197 blocked for more than 120
>> seconds.
>> [  368.267136]       Tainted: P           OE     4.18.16-arch1-1-ARCH #1
>> [  368.267137] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [  368.267138] btrfs-transacti D    0  1197      2 0x80000080
>> [  368.267139] Call Trace:
>> [  368.267141]  ? __schedule+0x29b/0x8b0
>> [  368.267142]  ? preempt_count_add+0x68/0xa0
>> [  368.267144]  schedule+0x32/0x90
>> [  368.267156]  btrfs_tree_lock+0x113/0x1f0 [btrfs]
>> [  368.267158]  ? wait_woken+0x80/0x80
>> [  368.267167]  btrfs_search_slot+0x7b4/0xa00 [btrfs]
>> [  368.267178]  btrfs_insert_empty_items+0x67/0xc0 [btrfs]
>> [  368.267188]  __btrfs_run_delayed_refs+0x8ef/0x10a0 [btrfs]
>> [  368.267190]  ? _raw_spin_unlock_irq+0x1d/0x30
>> [  368.267201]  btrfs_run_delayed_refs+0x72/0x180 [btrfs]
>> [  368.267212]  btrfs_commit_transaction+0x40/0x8a0 [btrfs]
> 
> And thread is running commit transaction.
> 
> This looks pretty like this bug which should be fixed by the following
> patch:
> 
> https://patchwork.kernel.org/patch/10654433/
> 
> If previous "btrfs check" shows no error, would you please try apply
> that patch and try again?

I tried applying the patch to the 4.18.16 kernel I was running and it 
didn't apply cleanly, so I thought maybe I'd update to 4.19.0 first 
(which is already in the Arch testing repos) and then try applying the 
patch to that.

However, as it turns out, the fs now works again just by using 4.19.0 
even though I think the patch is not even in 4.19 yet (?). I'm able to 
navigate the directories and unmounting also works fine. Even after 
downgrading to 4.18.16, the fs still works.

So, thanks again for the quick reply, and "sorry" for not being able to 
test this particular patch now, but I guess the problem has been resolved.

> Thanks,
> Qu
> 

Thanks,
Ochi
