Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:34777 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbbFBMjn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Jun 2015 08:39:43 -0400
Received: by ieczm2 with SMTP id zm2so131763418iec.1
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Jun 2015 05:39:42 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <278b7effa4d3646aa02f3dce7aa474c8cf044729.1433247110.git.zhaolei@cn.fujitsu.com>
References: <278b7effa4d3646aa02f3dce7aa474c8cf044729.1433247110.git.zhaolei@cn.fujitsu.com>
Date: Tue, 2 Jun 2015 13:39:42 +0100
Message-ID: <CAL3q7H6jw_McPc8cSv-RzbLs=+m1O2-tVVwceR_F4i78as66Bg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: Fix lockdep warning of wr_ctx->wr_lock in scrub_free_wr_ctx()
From: Filipe David Manana <fdmanana@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 2, 2015 at 1:12 PM, Zhaolei <zhaolei@cn.fujitsu.com> wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
>
> lockdep report following warning in test:
>  [25176.843958] =================================
>  [25176.844519] [ INFO: inconsistent lock state ]
>  [25176.845047] 4.1.0-rc3 #22 Tainted: G        W
>  [25176.845591] ---------------------------------
>  [25176.846153] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
>  [25176.846713] fsstress/26661 [HC0[0]:SC1[1]:HE1:SE0] takes:
>  [25176.847246]  (&wr_ctx->wr_lock){+.?...}, at: [<ffffffffa04cdc6d>] scrub_free_ctx+0x2d/0xf0 [btrfs]
>  [25176.847838] {SOFTIRQ-ON-W} state was registered at:
>  [25176.848396]   [<ffffffff810bf460>] __lock_acquire+0x6a0/0xe10
>  [25176.848955]   [<ffffffff810bfd1e>] lock_acquire+0xce/0x2c0
>  [25176.849491]   [<ffffffff816489af>] mutex_lock_nested+0x7f/0x410
>  [25176.850029]   [<ffffffffa04d04ff>] scrub_stripe+0x4df/0x1080 [btrfs]
>  [25176.850575]   [<ffffffffa04d11b1>] scrub_chunk.isra.19+0x111/0x130 [btrfs]
>  [25176.851110]   [<ffffffffa04d144c>] scrub_enumerate_chunks+0x27c/0x510 [btrfs]
>  [25176.851660]   [<ffffffffa04d3b87>] btrfs_scrub_dev+0x1c7/0x6c0 [btrfs]
>  [25176.852189]   [<ffffffffa04e918e>] btrfs_dev_replace_start+0x36e/0x450 [btrfs]
>  [25176.852771]   [<ffffffffa04a98e0>] btrfs_ioctl+0x1e10/0x2d20 [btrfs]
>  [25176.853315]   [<ffffffff8121c5b8>] do_vfs_ioctl+0x318/0x570
>  [25176.853868]   [<ffffffff8121c851>] SyS_ioctl+0x41/0x80
>  [25176.854406]   [<ffffffff8164da17>] system_call_fastpath+0x12/0x6f
>  [25176.854935] irq event stamp: 51506
>  [25176.855511] hardirqs last  enabled at (51506): [<ffffffff810d4ce5>] vprintk_emit+0x225/0x5e0
>  [25176.856059] hardirqs last disabled at (51505): [<ffffffff810d4b77>] vprintk_emit+0xb7/0x5e0
>  [25176.856642] softirqs last  enabled at (50886): [<ffffffff81067a23>] __do_softirq+0x363/0x640
>  [25176.857184] softirqs last disabled at (50949): [<ffffffff8106804d>] irq_exit+0x10d/0x120
>  [25176.857746]
>  other info that might help us debug this:
>  [25176.858845]  Possible unsafe locking scenario:
>  [25176.859981]        CPU0
>  [25176.860537]        ----
>  [25176.861059]   lock(&wr_ctx->wr_lock);
>  [25176.861705]   <Interrupt>
>  [25176.862272]     lock(&wr_ctx->wr_lock);
>  [25176.862881]
>   *** DEADLOCK ***
>
> Reason:
>  Above warning is caused by:
>  Interrupt
>  -> bio_endio()
>  -> ...
>  -> scrub_put_ctx()
>  -> scrub_free_ctx() *1
>  -> ...
>  -> mutex_lock(&wr_ctx->wr_lock);
>
>  scrub_put_ctx() is allowed to be called in end_bio interrupt, but
>  in code design, it will never call scrub_free_ctx(sctx) in interrupe
>  context(above *1), because btrfs_scrub_dev() get one additional
>  reference of sctx->refs, which makes scrub_free_ctx() only called
>  withine btrfs_scrub_dev().
>
>  Now the code runs out of our wish, because free sequence in
>  scrub_pending_bio_dec() have a gap.
>
>  Current code:
>  -----------------------------------+-----------------------------------
>  scrub_pending_bio_dec()            |  btrfs_scrub_dev
>  -----------------------------------+-----------------------------------
>  atomic_dec(&sctx->bios_in_flight); |
>  wake_up(&sctx->list_wait);         |
>                                     | scrub_put_ctx()
>                                     | -> atomic_dec_and_test(&sctx->refs)
>  scrub_put_ctx(sctx);               |
>  -> atomic_dec_and_test(&sctx->refs)|
>  -> scrub_free_ctx()                |
>  -----------------------------------+-----------------------------------
>
>  We expected:
>  -----------------------------------+-----------------------------------
>  scrub_pending_bio_dec()            |  btrfs_scrub_dev
>  -----------------------------------+-----------------------------------
>  atomic_dec(&sctx->bios_in_flight); |
>  wake_up(&sctx->list_wait);         |
>  scrub_put_ctx(sctx);               |
>  -> atomic_dec_and_test(&sctx->refs)|
>                                     | scrub_put_ctx()
>                                     | -> atomic_dec_and_test(&sctx->refs)
>                                     | -> scrub_free_ctx()
>  -----------------------------------+-----------------------------------
>
> Fix:
>  To fix above problem, we can move scrub_put_ctx() to line before
>  atomic_dec(&sctx->bios_in_flight) in scrub_pending_bio_dec(), to force
>  scrub_put_ctx() in btrfs_scrub_dev() run after scrub_put_ctx() in
>  scrub_pending_bio_dec().
>
> Reported-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  fs/btrfs/scrub.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index ab58115..1b4b27c 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -317,9 +317,9 @@ static void scrub_pending_bio_inc(struct scrub_ctx *sctx)
>
>  static void scrub_pending_bio_dec(struct scrub_ctx *sctx)
>  {
> +       scrub_put_ctx(sctx);
>         atomic_dec(&sctx->bios_in_flight);
>         wake_up(&sctx->list_wait);
> -       scrub_put_ctx(sctx);

Hi Zhao,

I find this confusing. A "put" should logically be done by a task when
it no longer needs/accesses the resource (sctx) anymore.

Plus, while you fix this apparently device replace specific issue, you
are re-introducing the issue fixed and described by:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=de554a4fa61d77df2704be5b6b47472b2dbd1875

(which got another fix on top:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=f55985f4dda5cfb6967c17e96237f3c859076eb3)

Can we get a fix that doesn't reintroduce the use-after-free issue for
the non device replace case?

thanks



>  }
>
>  static void __scrub_blocked_if_needed(struct btrfs_fs_info *fs_info)
> --
> 1.8.5.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
