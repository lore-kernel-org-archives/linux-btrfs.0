Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DEB4C282CE
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 14:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0FB8218B0
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 14:43:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="On/5vxVT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731873AbfDXOnI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 10:43:08 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:38116 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731661AbfDXOnH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 10:43:07 -0400
Received: by mail-ua1-f67.google.com with SMTP id t15so6114224uao.5
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2019 07:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=chBe2xbsrwAL3ScU6iFG1DoAemcgo/p/LUEx0JY4KeY=;
        b=On/5vxVTR63yF6pMfTldnDnjodsBIrC0FzEPgt3cbHFREbM/XFZx8id0elf52DqkKu
         ZrDBs77UPZOFiQtnht/NDq28q51FED4rUoYKGN10FsGEGRnaLf0UEeHRjDmxxGOZTZeX
         qBpd+62amjO0cxdC9WrC4cQg7QsrCv80Vm0c+nDnn5YzpCeWVCiRFjCrnYhlFTNZ1VEW
         8gkZAZ8nD+Ux4l/UmXiSqSZ5067xZxRb8GtWDncahpMEAxSQkIAZYLTiiZo/vFICOiIn
         O7f7nnRDsZ65u3GSncefO5bC0iLeVwyZKKUYf5w9Mwa7HdGxmIVIWCKq++7f/MPYF0kE
         3Brg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=chBe2xbsrwAL3ScU6iFG1DoAemcgo/p/LUEx0JY4KeY=;
        b=F9zg5G7LZTIy/XUCmFLr4cjr45zOV/qr9jF0puiK/+LfD8FUP2A3YHsJpee+c5/EBG
         azMNY2JiF1fOw69Fp/XHzL35BzH1vBIJyCgiPeqGS24Ce+MBjxtYVhCQoGY3AdsyjhMy
         NGt1Dp6UbbTc3EJooHHOcJIFTq2tWhXjk28vKIg4B7UNhoWWEdqY83hh+4J+A8X5knJt
         zST6xXx3gD/9tAanDav+qLtqe/kFmyHxQSPGG+T3ZhFw1iqycZ6G+OjR+JbUm+1T1x9p
         2wE+WA2/PI/+hqRknbNVTRPlzhWcxPs31yHtp5uwcw7bmXZzToIlIxY/goyZ+iTDs82V
         3n0g==
X-Gm-Message-State: APjAAAUH4RyOcaokawL4LXP+TlU9fYdylXq8DHrb6t+6nXx4tiENA05x
        1H/pCZ2z3MFJdopQLFThY3G7gVEHmv9EigmoAM5hefB9
X-Google-Smtp-Source: APXvYqzo3pyFIfyTB8vSAEEoOH0ApEb2zS6GjOWx3xmT+Bb+RaOKAIKQ/KECNU2Uae95lm753O750yRghX2ggkyoh9A=
X-Received: by 2002:ab0:156b:: with SMTP id p40mr16115413uae.83.1556116986283;
 Wed, 24 Apr 2019 07:43:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190424143134.32699-1-wqu@suse.com>
In-Reply-To: <20190424143134.32699-1-wqu@suse.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Wed, 24 Apr 2019 15:42:55 +0100
Message-ID: <CAL3q7H5zK32tUr3sOd7VPoArdQz5OX81Q2cU9L6kTsSBCPcepA@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: ctree: Dump the leaf before BUG_ON()
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 24, 2019 at 3:33 PM Qu Wenruo <wqu@suse.com> wrote:
>
> We have a user reporting BUG_ON() triggered in
> btrfs_set_item_key_safe().
>
> Let's dump the leaf content before triggering BUG_ON() so that we can
> have some clue on what's going wrong.
> The output of tree locks should help us to debug such problem.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> changelog:
> v2:
> - Also dump the slot/disk_key/new_key.
> ---
>  fs/btrfs/ctree.c | 24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index f52eb952597b..61e6e2a23a8a 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -3185,11 +3185,31 @@ void btrfs_set_item_key_safe(struct btrfs_fs_info=
 *fs_info,
>         slot =3D path->slots[0];
>         if (slot > 0) {
>                 btrfs_item_key(eb, &disk_key, slot - 1);
> -               BUG_ON(comp_keys(&disk_key, new_key) >=3D 0);
> +               if (unlikely(comp_keys(&disk_key, new_key) >=3D 0)) {
> +                       btrfs_crit(fs_info,
> +               "on-disk slot %u key (%llu, %u, %llu) new key (%llu %u %l=
lu)",

On-disk?  Not necessarily, the leaf might have been changed multiple
times after the last time it was persisted to disk.
I would remove that.

Also remove the commas after each element of key, just like you do for
new key (which is the prevalent style we have).

> +                                  slot, btrfs_disk_key_objectid(&disk_ke=
y),
> +                                  btrfs_disk_key_type(&disk_key),
> +                                  btrfs_disk_key_offset(&disk_key),
> +                                  new_key->objectid, new_key->type,
> +                                  new_key->offset);
> +                       btrfs_print_leaf(eb);
> +                       BUG_ON(1);

Use BUG(); instead please, see
https://lore.kernel.org/linux-btrfs/20190325130256.1437810-1-arnd@arndb.de/

> +               }
>         }
>         if (slot < btrfs_header_nritems(eb) - 1) {
>                 btrfs_item_key(eb, &disk_key, slot + 1);
> -               BUG_ON(comp_keys(&disk_key, new_key) <=3D 0);
> +               if (unlikely(comp_keys(&disk_key, new_key) <=3D 0)) {
> +                       btrfs_crit(fs_info,
> +               "on-disk slot %u key (%llu, %u, %llu) new key (%llu %u %l=
lu)",

Same here.

> +                                  slot, btrfs_disk_key_objectid(&disk_ke=
y),
> +                                  btrfs_disk_key_type(&disk_key),
> +                                  btrfs_disk_key_offset(&disk_key),
> +                                  new_key->objectid, new_key->type,
> +                                  new_key->offset);
> +                       btrfs_print_leaf(eb);
> +                       BUG_ON(1);

Same here.

Other then that, it looks ok to me and you can add Reviewed-by:
fdmanana@suse.com

Thanks.

> +               }
>         }
>
>         btrfs_cpu_key_to_disk(&disk_key, new_key);
> --
> 2.21.0
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
