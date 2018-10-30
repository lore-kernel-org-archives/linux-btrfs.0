Return-Path: <SRS0=iJ2R=NK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C194C6786F
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 11:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D66EF2081B
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 11:45:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lYX/98gl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D66EF2081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbeJ3Uiv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Oct 2018 16:38:51 -0400
Received: from mail-vk1-f193.google.com ([209.85.221.193]:46880 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727593AbeJ3Uiv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Oct 2018 16:38:51 -0400
Received: by mail-vk1-f193.google.com with SMTP id 185so2892715vkv.13
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2018 04:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=wi29nvdZV/0i+0sXp4BaNFe9Dxtyv/fpHskRXNc/aN4=;
        b=lYX/98glxUknW732bjEQjPofrU/uP3tPJQdcKGLUlnQ7pYBtgGBpuL2tcen5UjAuwJ
         4lIdDJhLEJzLaLhuW+XpH4WuXIIFz3jwJ+SYoB2Xnl/RbEI2sO+IeOvzyLLUZW5pSHB6
         +EBq06l5pR0SUi7E62faLXhqs4ZudfJEvNmHM3GgrEmDWzPC6Xh8IxnPjKh36OiCQv3v
         FnBPU7+YMdp+Z62muFXsjJ6l7RJx9yuXDSYJtoioVL+9T6yiPIuNAkC98f0mWOWgrjUh
         ZQaIz4u3ryd1unML/FI5YdYx+iU6+L3NHdpSZM8SFPbonbBKKnGOCnX8Lcv6ggVTgVO9
         lQBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=wi29nvdZV/0i+0sXp4BaNFe9Dxtyv/fpHskRXNc/aN4=;
        b=bBAcIidvR2Qmdx/V/yavu9/X5y6+Lq81aSHVFemicFT2W0DcwyF+uAyUKlbXsUtl3D
         3a7AGcPKkW3aRQVddM+IouFaAmgvSQm1A5rJOb2ZwYpxrpOY8oCBa4LqqPKZtrQNxIFW
         N4q/DfHqV1SNbsWtwRs//sBAQiIZuA5+ieh/A9ZjC4S/AgRI50LtKLfyBfd3oB3lMHXW
         u6wNVinyZchPCT2nMY/bh6cuiJv1N3wva30OCwMsaOvpzQmYWaleFYRo4xVRlDEL54eb
         qEJbx51SS4Ud13qMB7qt5B9LissxQxsZJDk/PZj8FgeNrliP7DYty8awTxPvjN5qO3Fz
         m38Q==
X-Gm-Message-State: AGRZ1gK7WQBzZOvD2mK6bZxe7bn/htINEhHUqUzBkAwfhl+uC6uG60oA
        MXJvPMW6gi6FQi+yQOVAmYpTb2/736tZLJj58Bw=
X-Google-Smtp-Source: AJdET5c6RS95lKJVHOChAUsn+FyNWY9E67CaBwayAMfGJGEN/P66XeG/NHU2hQ91qE3wYGG1bk5H2/rcQhAqXAXg3ws=
X-Received: by 2002:a1f:a543:: with SMTP id o64mr7668005vke.23.1540899942155;
 Tue, 30 Oct 2018 04:45:42 -0700 (PDT)
MIME-Version: 1.0
References: <1540893844-3480-1-git-send-email-robbieko@synology.com>
In-Reply-To: <1540893844-3480-1-git-send-email-robbieko@synology.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Tue, 30 Oct 2018 11:45:31 +0000
Message-ID: <CAL3q7H409STOkB0resJ2E4xtVJyh_qnNaUv+QzU3MV_rh6ER-Q@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix cur_offset in the error case for nocow
To:     Robbie Ko <robbieko@synology.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 30, 2018 at 10:05 AM robbieko <robbieko@synology.com> wrote:
>
> From: Robbie Ko <robbieko@synology.com>
>
> When the cow_file_range fail, the related resources are
> unlocked according to the range (start-end), so the unlock
> cannot be repeated in run_delalloc_nocow.
>
> In some cases (e.g. cur_offset <=3D end && cow_start!=3D -1),
> cur_offset is not updated correctly, so move the cur_offset
> update before cow_file_range.
>
> ------------[ cut here ]------------
> kernel BUG at mm/page-writeback.c:2663!
> Internal error: Oops - BUG: 0 [#1] SMP
> CPU: 3 PID: 31525 Comm: kworker/u8:7 Tainted: P O
> Hardware name: Realtek_RTD1296 (DT)
> Workqueue: writeback wb_workfn (flush-btrfs-1)
> task: ffffffc076db3380 ti: ffffffc02e9ac000 task.ti: ffffffc02e9ac000
> PC is at clear_page_dirty_for_io+0x1bc/0x1e8
> LR is at clear_page_dirty_for_io+0x14/0x1e8
> pc : [<ffffffc00033c91c>] lr : [<ffffffc00033c774>] pstate: 40000145
> sp : ffffffc02e9af4f0
> Process kworker/u8:7 (pid: 31525, stack limit =3D 0xffffffc02e9ac020)
> Call trace:
> [<ffffffc00033c91c>] clear_page_dirty_for_io+0x1bc/0x1e8
> [<ffffffbffc514674>] extent_clear_unlock_delalloc+0x1e4/0x210 [btrfs]
> [<ffffffbffc4fb168>] run_delalloc_nocow+0x3b8/0x948 [btrfs]
> [<ffffffbffc4fb948>] run_delalloc_range+0x250/0x3a8 [btrfs]
> [<ffffffbffc514c0c>] writepage_delalloc.isra.21+0xbc/0x1d8 [btrfs]
> [<ffffffbffc516048>] __extent_writepage+0xe8/0x248 [btrfs]
> [<ffffffbffc51630c>] extent_write_cache_pages.isra.17+0x164/0x378 [btrfs]
> [<ffffffbffc5185a8>] extent_writepages+0x48/0x68 [btrfs]
> [<ffffffbffc4f5828>] btrfs_writepages+0x20/0x30 [btrfs]
> [<ffffffc00033d758>] do_writepages+0x30/0x88
> [<ffffffc0003ba0f4>] __writeback_single_inode+0x34/0x198
> [<ffffffc0003ba6c4>] writeback_sb_inodes+0x184/0x3c0
> [<ffffffc0003ba96c>] __writeback_inodes_wb+0x6c/0xc0
> [<ffffffc0003bac20>] wb_writeback+0x1b8/0x1c0
> [<ffffffc0003bb0f0>] wb_workfn+0x150/0x250
> [<ffffffc0002b0014>] process_one_work+0x1dc/0x388
> [<ffffffc0002b02f0>] worker_thread+0x130/0x500
> [<ffffffc0002b6344>] kthread+0x10c/0x110
> [<ffffffc000284590>] ret_from_fork+0x10/0x40
> Code: d503201f a9025bb5 a90363b7 f90023b9 (d4210000)
> ---[ end trace 65fecee7c2296f25 ]---
>
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---
>  fs/btrfs/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 181c58b..b62299b 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1532,10 +1532,10 @@ static noinline int run_delalloc_nocow(struct ino=
de *inode,
>
>         if (cur_offset <=3D end && cow_start =3D=3D (u64)-1) {
>                 cow_start =3D cur_offset;
> -               cur_offset =3D end;
>         }

Also remove the { }

Other than that, it looks good to me and you can add:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

thanks

>
>         if (cow_start !=3D (u64)-1) {
> +               cur_offset =3D end;
>                 ret =3D cow_file_range(inode, locked_page, cow_start, end=
, end,
>                                      page_started, nr_written, 1, NULL);
>                 if (ret)
> --
> 1.9.1
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
