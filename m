Return-Path: <SRS0=A/rP=OI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0919C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 10:32:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CC022081C
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 10:32:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VuejVnR9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5CC022081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbeK2Vhj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Nov 2018 16:37:39 -0500
Received: from mail-ua1-f65.google.com ([209.85.222.65]:39385 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbeK2Vhj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Nov 2018 16:37:39 -0500
Received: by mail-ua1-f65.google.com with SMTP id k10so453389ual.6
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2018 02:32:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=yTwjypEoF5cJlwEzrHW1l1TjN/2m2F0hpqPk07zrjfs=;
        b=VuejVnR97Kq6BBLb9StwZSDqK7pA9CEEJJFKkpvjIn8KOMfSEN/hsLbJK6MCUxFAd1
         v1vlOxIYtJfNLJ0E71Gh4EuGS/9r5NSGExV2bXT9XpdpibNBFSqII15PQhqxQc/Zc2MS
         k/YZXQZORNVL7hX6F+Joivxl0O2z1zKCVZ4mPU4X+jkeYT15SABtso/wFZzoSQlAYH4w
         xhnS8raVjizOEnB65w5MWZ2HLrAt7SZXJIYijdKX7zIw/uYbJr6O2bjg/xqNnLXq5hAN
         II8nEqWCuj/bbEw76aA625XSk+1mdNW7QzuCkgxlhZ88YyHx5gqbXGPS2yAVv/Fn3Cy2
         EGCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=yTwjypEoF5cJlwEzrHW1l1TjN/2m2F0hpqPk07zrjfs=;
        b=je2KsEShrZgq2aw2x5L7vayff38oc0jx30+IEVpqIPmftQSG2gOn2xJs2ai6OzcKkw
         kmKWsroDng0BGzRpcg/XcHYcpmvNmHXST5XL47U0pn7NraK90iTkznKv3X8aySMtr/qn
         vDuCuRxnDgTaSaPxzHLZtVS7u3jUQfC3PuqbxuKAEREU+pBxfD/clnjtvMosCpf4fJrH
         Hi4PlnNB1OQC0ulSHz20c2AAqed+lhcCvRsFjgHusjnP4akJGTkBmktI13F/Ni9D4Ani
         Zvg9biF+pQYUOqjuJczUmTcxiWdSvr0hrnehAsZcGFRYml3L6I7b6ocmJfWBRhbOD/O9
         ptFg==
X-Gm-Message-State: AA+aEWYsBQuynGgvmOmm55brzlYhm/nc/UG9YRM64/QhgtfhcMIzrKcI
        /wKMbvdKn3ziQPdCcWeYflliyeI9w176iyDoS0A=
X-Google-Smtp-Source: AFSGD/W3JkpyuYf6gRGn/r9gVIu3vDYO1AdONZ10Y9QvZW7YKh/nHFT2Llv73zIrSg2G+ULRRpUfdgpWL9DSFlJ4B9A=
X-Received: by 2002:ab0:3259:: with SMTP id r25mr341719uan.108.1543487564686;
 Thu, 29 Nov 2018 02:32:44 -0800 (PST)
MIME-Version: 1.0
References: <20181129093132.25147-1-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20181129093132.25147-1-lufq.fnst@cn.fujitsu.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Thu, 29 Nov 2018 10:32:33 +0000
Message-ID: <CAL3q7H5jjpGqpndW1QWcLewOYpogp_n_qY7kKGBUQbTRdphK8A@mail.gmail.com>
Subject: Re: [PATCH] btrfs: skip file_extent generation check for
 free_space_inode in run_delalloc_nocow
To:     Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 29, 2018 at 9:32 AM Lu Fengqi <lufq.fnst@cn.fujitsu.com> wrote:
>
> The btrfs/001 with inode_cache mount option will encounter the following
> warning:

"The test case btrfs/001 ..."

>
> WARNING: CPU: 1 PID: 23700 at fs/btrfs/inode.c:956 cow_file_range.isra.19=
+0x32b/0x430 [btrfs]
> CPU: 1 PID: 23700 Comm: btrfs Kdump: loaded Tainted: G        W  O      4=
.20.0-rc4-custom+ #30
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
> RIP: 0010:cow_file_range.isra.19+0x32b/0x430 [btrfs]
> Call Trace:
>  ? free_extent_buffer+0x46/0x90 [btrfs]
>  run_delalloc_nocow+0x455/0x900 [btrfs]
>  btrfs_run_delalloc_range+0x1a7/0x360 [btrfs]
>  writepage_delalloc+0xf9/0x150 [btrfs]
>  __extent_writepage+0x125/0x3e0 [btrfs]
>  extent_write_cache_pages+0x1b6/0x3e0 [btrfs]
>  ? __wake_up_common_lock+0x63/0xc0
>  extent_writepages+0x50/0x80 [btrfs]
>  do_writepages+0x41/0xd0
>  ? __filemap_fdatawrite_range+0x9e/0xf0
>  __filemap_fdatawrite_range+0xbe/0xf0
>  btrfs_fdatawrite_range+0x1b/0x50 [btrfs]
>  __btrfs_write_out_cache+0x42c/0x480 [btrfs]
>  btrfs_write_out_ino_cache+0x84/0xd0 [btrfs]
>  btrfs_save_ino_cache+0x551/0x660 [btrfs]
>  commit_fs_roots+0xc5/0x190 [btrfs]
>  btrfs_commit_transaction+0x2bf/0x8d0 [btrfs]
>  btrfs_mksubvol+0x48d/0x4d0 [btrfs]
>  btrfs_ioctl_snap_create_transid+0x170/0x180 [btrfs]
>  btrfs_ioctl_snap_create_v2+0x124/0x180 [btrfs]
>  btrfs_ioctl+0x123f/0x3030 [btrfs]
>
> The file extent generation of the free space inode is equal to the last
> snapshot of the file root, so the inode will be passed to cow_file_rage.
> But the inode was created and its extents were preallocated in
> btrfs_save_ino_cache, there are no cow copies on disk.
>
> The preallocated extents don't present on disk, and the

The preallocated extent is not yet in the extent tree, and the ...
(singular, it's only used for each space cache)

> btrfs_cross_ref_exist will ignore the -ENOENT returned by
> check_committed_ref, so we can directly write the inode to the disk.
>
> Fixes: 78d4295b1eee ("btrfs: lift some btrfs_cross_ref_exist checks in no=
cow path")
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

The code changes look good to me.

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> ---
>  fs/btrfs/inode.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index d54bdef16d8d..9c5e9629eb6c 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1369,7 +1369,8 @@ static noinline int run_delalloc_nocow(struct inode=
 *inode,
>                          * Do the same check as in btrfs_cross_ref_exist =
but
>                          * without the unnecessary search.
>                          */
> -                       if (btrfs_file_extent_generation(leaf, fi) <=3D
> +                       if (!nolock &&
> +                           btrfs_file_extent_generation(leaf, fi) <=3D
>                             btrfs_root_last_snapshot(&root->root_item))
>                                 goto out_check;
>                         if (extent_type =3D=3D BTRFS_FILE_EXTENT_REG && !=
force)
> --
> 2.19.2
>
>
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
