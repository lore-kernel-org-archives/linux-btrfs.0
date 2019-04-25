Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B502C282E3
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 09:35:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCF2A20685
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 09:35:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RoZXdlJ6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbfDYJfR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 05:35:17 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:39750 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfDYJfQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 05:35:16 -0400
Received: by mail-ua1-f68.google.com with SMTP id d5so7022377uan.6
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 02:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=uOqYFZTDywIg6+CRVKlw3cjgUsZwutRJJ2TlzWYPdfQ=;
        b=RoZXdlJ6G++nw7DeSJhdJegFfr0FAh2a1s3AOqOtlanandUN69qrlFs+zSZYN7jEu7
         vMTV7XZ5WKRiUytnQCp1kU6GLJEzjDn+Yu6pENUVnBJY/Xe2x0YvaLh5vPkQdb4FnQqh
         iHebwx3p75uTu1l57vO+Mq4vszBV+xitc70KH8S2TDo6ecRWeTqg3vB+i7DPLzUOr6kE
         B8VB3C6eVApo8ZO0LzEcfyaKhR9J9ltJUHwNewpI/YukVV2NuyHofr9V71T0MR5V7Rlf
         cud3rGwZFprGEBlbcmbTsL941E16k9n3Fj/bhKh+lGO+eWmULRPSZHL8HLLFaD9jn+KG
         pjOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=uOqYFZTDywIg6+CRVKlw3cjgUsZwutRJJ2TlzWYPdfQ=;
        b=XNH5z0YDb4n1M4/snB6UBn8djCA0ylR+dbkctdqghCscwW1qfIefP1EKeeiI0Axnwz
         LlOFMpNFAdM1P60dfuD5yHX43/BCvP+hibC5nhsZw+5YmLtr6FC8rhJuApPiegUCeFPD
         +pNFukEfKVrEH8fzbnKtFckoEbRQfHTj42VKm2IBZ2PljsF6F5d2UnNH72z9Ampiom77
         ugck/2AUlGGJ/9ytdnq0HvIpdmQZ7uZ66XAIlrT7ZWxDM2DI5KQ7bOxbZAPbmqnaWQE4
         dE+0KZLJqvH5+TASWSp6asxvIHQd0+yhRwQOZcYZZi/4SP2kLnk7YzNFJS45e+oPeuCP
         iXgw==
X-Gm-Message-State: APjAAAVVt2SOgJcEjXHpJWdCO1siq8DiWDLk40+uXpV0XKbbkXUGGTtR
        2gCcMXqvCkmcVUhDN5uEsotBu3H7mude/HDbrM2Avg==
X-Google-Smtp-Source: APXvYqxb9ek9/gaZlzTzd2JenogQvoz66TtOpeb1d2iyIWtHByBeUPevH7KkNhBoziCk45aXoA2+ETCiFzoTlP5/2k0=
X-Received: by 2002:ab0:156b:: with SMTP id p40mr18686568uae.83.1556184915087;
 Thu, 25 Apr 2019 02:35:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190425005553.3126-1-wqu@suse.com>
In-Reply-To: <20190425005553.3126-1-wqu@suse.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Thu, 25 Apr 2019 10:35:04 +0100
Message-ID: <CAL3q7H5AVw6UuwHHh7xwd3jMjG7-b9gwNgjtZaYDB+naLbc7Ag@mail.gmail.com>
Subject: Re: [PATCH v3] btrfs: ctree: Dump the leaf before BUG_ON()
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filip Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 25, 2019 at 8:52 AM Qu Wenruo <wqu@suse.com> wrote:
>
> We have a user reporting BUG_ON() triggered in
> btrfs_set_item_key_safe().
>
> Let's dump the leaf content before triggering BUG_ON() so that we can
> have some clue on what's going wrong.
> The output of tree locks should help us to debug such problem.
>
> Reviewed-by: Filip Manana <fdmanana@suse.com>

Filip -> Filipe

David can probably amend that at commit time.

> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog:
> v2:
> - Dump slot/old key/new key.
> v3:
> - Output message update, to avoid "on-disk" wording.
> - Use BUG() to replace BUG_ON(1) to make clang quite.
>
>  fs/btrfs/ctree.c | 24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 5116c2a1f0f9..5df76c17775a 100644
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
> +               "slot %u key (%llu %u %llu) new key (%llu %u %llu)",
> +                                  slot, btrfs_disk_key_objectid(&disk_ke=
y),
> +                                  btrfs_disk_key_type(&disk_key),
> +                                  btrfs_disk_key_offset(&disk_key),
> +                                  new_key->objectid, new_key->type,
> +                                  new_key->offset);
> +                       btrfs_print_leaf(eb);
> +                       BUG();
> +               }
>         }
>         if (slot < btrfs_header_nritems(eb) - 1) {
>                 btrfs_item_key(eb, &disk_key, slot + 1);
> -               BUG_ON(comp_keys(&disk_key, new_key) <=3D 0);
> +               if (unlikely(comp_keys(&disk_key, new_key) <=3D 0)) {
> +                       btrfs_crit(fs_info,
> +               "slot %u key (%llu %u %llu) new key (%llu %u %llu)",
> +                                  slot, btrfs_disk_key_objectid(&disk_ke=
y),
> +                                  btrfs_disk_key_type(&disk_key),
> +                                  btrfs_disk_key_offset(&disk_key),
> +                                  new_key->objectid, new_key->type,
> +                                  new_key->offset);
> +                       btrfs_print_leaf(eb);
> +                       BUG();
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
