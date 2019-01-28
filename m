Return-Path: <SRS0=GbvB=QE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EE43C282C8
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 16:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE3DF20844
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 16:57:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388494AbfA1Q5r (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Jan 2019 11:57:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:33492 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388031AbfA1Q5q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Jan 2019 11:57:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AA4B1AE14;
        Mon, 28 Jan 2019 16:57:43 +0000 (UTC)
Subject: Re: [PATCH] btrfs: clean up pending block groups when transaction
 commit aborts
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
References: <20190128164550.17826-1-dsterba@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <dc40cb8e-e557-21cc-9e17-67849e7521c9@suse.com>
Date:   Mon, 28 Jan 2019 18:57:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190128164550.17826-1-dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 28.01.19 г. 18:45 ч., David Sterba wrote:
> The fstests generic/475 stresses transaction aborts and can reveal
> space accounting or use-after-free bugs regarding block goups.
> 
> In this case the pending block groups that remain linked to the
> structures after transaction commit aborts in the middle.
> 
> The corrupted slabs lead to failures in following tests, eg. generic/476
> 
>   [ 8172.752887] BUG: unable to handle kernel NULL pointer dereference at 0000000000000058
>   [ 8172.755799] #PF error: [normal kernel read fault]
>   [ 8172.757571] PGD 661ae067 P4D 661ae067 PUD 3db8e067 PMD 0
>   [ 8172.759000] Oops: 0000 [#1] PREEMPT SMP
>   [ 8172.760209] CPU: 0 PID: 39 Comm: kswapd0 Tainted: G        W         5.0.0-rc2-default #408
>   [ 8172.762495] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.2-0-gf9626cc-prebuilt.qemu-project.org 04/01/2014
>   [ 8172.765772] RIP: 0010:shrink_page_list+0x2f9/0xe90
>   [ 8172.770453] RSP: 0018:ffff967f00663b18 EFLAGS: 00010287
>   [ 8172.771184] RAX: 0000000000000000 RBX: ffff967f00663c20 RCX: 0000000000000000
>   [ 8172.772850] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8c0620ab20e0
>   [ 8172.774629] RBP: ffff967f00663dd8 R08: 0000000000000000 R09: 0000000000000000
>   [ 8172.776094] R10: ffff8c0620ab22f8 R11: ffff8c063f772688 R12: ffff967f00663b78
>   [ 8172.777533] R13: ffff8c063f625600 R14: ffff8c063f625608 R15: dead000000000200
>   [ 8172.778886] FS:  0000000000000000(0000) GS:ffff8c063d400000(0000) knlGS:0000000000000000
>   [ 8172.780545] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   [ 8172.781787] CR2: 0000000000000058 CR3: 000000004e962000 CR4: 00000000000006f0
>   [ 8172.783547] Call Trace:
>   [ 8172.784112]  shrink_inactive_list+0x194/0x410
>   [ 8172.784747]  shrink_node_memcg.constprop.85+0x3a5/0x6a0
>   [ 8172.785472]  shrink_node+0x62/0x1e0
>   [ 8172.786011]  balance_pgdat+0x216/0x460
>   [ 8172.786577]  kswapd+0xe3/0x4a0
>   [ 8172.787085]  ? finish_wait+0x80/0x80
>   [ 8172.787795]  ? balance_pgdat+0x460/0x460
>   [ 8172.788799]  kthread+0x116/0x130
>   [ 8172.789640]  ? kthread_create_on_node+0x60/0x60
>   [ 8172.790323]  ret_from_fork+0x24/0x30
>   [ 8172.794253] CR2: 0000000000000058
> 
> or accounting errors at umount time:
> 
>   [ 8159.537251] WARNING: CPU: 2 PID: 19031 at fs/btrfs/extent-tree.c:5987 btrfs_free_block_groups+0x3d5/0x410 [btrfs]
>   [ 8159.543325] CPU: 2 PID: 19031 Comm: umount Tainted: G        W         5.0.0-rc2-default #408
>   [ 8159.545472] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.2-0-gf9626cc-prebuilt.qemu-project.org 04/01/2014
>   [ 8159.548155] RIP: 0010:btrfs_free_block_groups+0x3d5/0x410 [btrfs]
>   [ 8159.554030] RSP: 0018:ffff967f079cbde8 EFLAGS: 00010206
>   [ 8159.555144] RAX: 0000000001000000 RBX: ffff8c06366cf800 RCX: 0000000000000000
>   [ 8159.556730] RDX: 0000000000000002 RSI: 0000000000000001 RDI: ffff8c06255ad800
>   [ 8159.558279] RBP: ffff8c0637ac0000 R08: 0000000000000001 R09: 0000000000000000
>   [ 8159.559797] R10: 0000000000000000 R11: 0000000000000001 R12: ffff8c0637ac0108
>   [ 8159.561296] R13: ffff8c0637ac0158 R14: 0000000000000000 R15: dead000000000100
>   [ 8159.562852] FS:  00007f7f693b9fc0(0000) GS:ffff8c063d800000(0000) knlGS:0000000000000000
>   [ 8159.564839] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   [ 8159.566160] CR2: 00007f7f68fab7b0 CR3: 000000000aec7000 CR4: 00000000000006e0
>   [ 8159.567898] Call Trace:
>   [ 8159.568597]  close_ctree+0x17f/0x350 [btrfs]
>   [ 8159.569628]  generic_shutdown_super+0x64/0x100
>   [ 8159.570808]  kill_anon_super+0x14/0x30
>   [ 8159.571857]  btrfs_kill_super+0x12/0xa0 [btrfs]
>   [ 8159.573063]  deactivate_locked_super+0x29/0x60
>   [ 8159.574234]  cleanup_mnt+0x3b/0x70
>   [ 8159.575176]  task_work_run+0x98/0xc0
>   [ 8159.576177]  exit_to_usermode_loop+0x83/0x90
>   [ 8159.577315]  do_syscall_64+0x15b/0x180
>   [ 8159.578339]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> This fix is based on 2 Josef's patches that used sideefects of
> btrfs_create_pending_block_groups, this fix introduces the helper that
> does what we need.
> 
> CC: stable@vger.kernel.org # 4.4+
> CC: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/transaction.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 127fa1535f58..1c23f227525c 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1895,6 +1895,20 @@ static inline int btrfs_start_delalloc_flush(struct btrfs_fs_info *fs_info)
>  	return 0;
>  }
>  
> +static void btrfs_cleanup_pending_block_groups(struct btrfs_trans_handle *trans)
> +{
> +       struct btrfs_fs_info *fs_info = trans->fs_info;
> +       struct btrfs_block_group_cache *block_group;
> +
> +       while (!list_empty(&trans->new_bgs)) {
> +               block_group = list_first_entry(&trans->new_bgs,
> +                                              struct btrfs_block_group_cache,
> +                                              bg_list);
> +               btrfs_delayed_refs_rsv_release(fs_info, 1);
> +               list_del_init(&block_group->bg_list);
> +       }
> +}

This is much cleaner and understandable, thanks.

nit:Can't we use list_for_each_entry_safe though and save the explicit
list_first_entry. IMO this is fine here since the transaction is aborted
hence no new pending bgs can be added to the ->new_bgs list. In any case:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> +
>  static inline void btrfs_wait_delalloc_flush(struct btrfs_fs_info *fs_info)
>  {
>  	if (btrfs_test_opt(fs_info, FLUSHONCOMMIT))
> @@ -2270,6 +2284,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>  	btrfs_scrub_continue(fs_info);
>  cleanup_transaction:
>  	btrfs_trans_release_metadata(trans);
> +	btrfs_cleanup_pending_block_groups(trans);
>  	btrfs_trans_release_chunk_metadata(trans);
>  	trans->block_rsv = NULL;
>  	btrfs_warn(fs_info, "Skipping commit of aborted transaction.");
> 
