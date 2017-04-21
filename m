Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:36777 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034215AbdDUKfJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Apr 2017 06:35:09 -0400
Received: by mail-oi0-f50.google.com with SMTP id s131so2379843oia.3
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Apr 2017 03:35:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170421100943.GA2942@ircssh-2.c.rugged-nimbus-611.internal>
References: <20170421100943.GA2942@ircssh-2.c.rugged-nimbus-611.internal>
From: Sargun Dhillon <sargun@sargun.me>
Date: Fri, 21 Apr 2017 05:34:27 -0500
Message-ID: <CAMp4zn80RVL8jUyX7j+Y3Bq15SioWBDjCtQg1n_wa2UwaO2MiQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: allow processes with cap_sys_resource to exceed quota
To: BTRFS ML <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The log rotation code that I have requires creating the new file
before it calls FICLONERANGE. Since it tries to copy close to a
newline and not the filesystem block boundary, it means that some of
the clone isn't a lazy copy, and instead has to be cloned byte for
byte. At a minimum I need a mechanism in order to circumvent the
metadata quota.

Since we don't have the notion of "operator reserved space", I'm not
sure of another straightforward way to do this. The other idea I had
was to introduce the idea of an operator UID to btrfs_qgroup, and
introduce a rsv_operator_rfer, and rsv_operator_excl, but that seems
to be killing the mosquito with the cannon.

On Fri, Apr 21, 2017 at 5:09 AM, Sargun Dhillon <sargun@sargun.me> wrote:
> This patch allows processes with CAP_SYS_RESOURCE to exceed the qgroup
> limit. It's useful for administrative programs, such as log rotation,
> that may need to temporarily use more disk space in order to free up
> a greater amount of overall disk space without yielding more disk
> space to the rest of userland.
>
> Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> ---
>  fs/btrfs/qgroup.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index a59801d..b0af39c 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2349,6 +2349,9 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
>
>  static bool qgroup_check_limits(const struct btrfs_qgroup *qg, u64 num_bytes)
>  {
> +       if (capable(CAP_SYS_RESOURCE))
> +               return true;
> +
>         if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
>             qg->reserved + (s64)qg->rfer + num_bytes > qg->max_rfer)
>                 return false;
> --
> 2.9.3
>
