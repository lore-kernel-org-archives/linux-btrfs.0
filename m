Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33815 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753211AbcJKPtm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 11:49:42 -0400
Received: by mail-oi0-f65.google.com with SMTP id p136so1569018oic.1
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Oct 2016 08:49:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161011064742.17364-1-wangxg.fnst@cn.fujitsu.com>
References: <20161011064742.17364-1-wangxg.fnst@cn.fujitsu.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 11 Oct 2016 09:49:13 -0600
Message-ID: <CAJCQCtRQpDiHh4bnm5H0dVkCt+JNLYBu23O_Z6ddpo550e2ngw@mail.gmail.com>
Subject: Re: [RFC] btrfs: make max inline data can be equal to sectorsize
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 11, 2016 at 12:47 AM, Wang Xiaoguang
<wangxg.fnst@cn.fujitsu.com> wrote:
> If we use mount option "-o max_inline=sectorsize", say 4096, indeed
> even for a fresh fs, say nodesize is 16k, we can not make the first
> 4k data completely inline, I found this conditon causing this issue:
>   !compressed_size && (actual_end & (root->sectorsize - 1)) == 0
>
> If it retuns true, we'll not make data inline. For 4k sectorsize,
> 0~4094 dara range, we can make it inline, but 0~4095, it can not.
> I don't think this limition is useful, so here remove it which will
> make max inline data can be equal to sectorsize.
>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/inode.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index ea15520..c0db393 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -267,8 +267,6 @@ static noinline int cow_file_range_inline(struct btrfs_root *root,
>         if (start > 0 ||
>             actual_end > root->sectorsize ||
>             data_len > BTRFS_MAX_INLINE_DATA_SIZE(root) ||
> -           (!compressed_size &&
> -           (actual_end & (root->sectorsize - 1)) == 0) ||
>             end + 1 < isize ||
>             data_len > root->fs_info->max_inline) {
>                 return 1;
> --
> 2.9.0


Before making any further changes to inline data, does it make sense
to find the source of corruption Zygo has been experiencing? That's in
the "btrfs rare silent data corruption with kernel data leak" thread.


-- 
Chris Murphy
