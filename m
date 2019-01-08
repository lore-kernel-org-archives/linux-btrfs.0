Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84267C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 11:51:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 518F0206B7
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 11:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546948285;
	bh=o+Pe7aylEIQgTn7+YP4GzLfnUqawTIiaENu6gEniO00=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Y0cC0GLbFDJAU5xmRoxYuZUUTnNoHVNh1ZahWz+dBqDLp436tJiA1eaPdXCWZsVdw
	 YQLyip/4n3aMy8mGutL1qT0WFPrI8SMXO87x0D71eSSTMAM2Xu/o5OQn4CP9gV7wvh
	 Qk/80ipR4vYwUT9nSH04Lxu9q+bUBUgS/gJX+zDI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbfAHLvY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 06:51:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:58576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbfAHLvX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 06:51:23 -0500
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B1102087F
        for <linux-btrfs@vger.kernel.org>; Tue,  8 Jan 2019 11:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1546948282;
        bh=o+Pe7aylEIQgTn7+YP4GzLfnUqawTIiaENu6gEniO00=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dILVNB0TQPwxp3o9e5dxVNb1+lV1Uc/Az1dVxp/iQzlN1ohfsz4i+RqPfR+fhN7YT
         rOdnnbEsR6453K6kRPogmqUZOGO7RAMHC3/VQ10CiYpL20X91CirUfH2F0Lfc4IlHu
         R3g+/HFvpfn+TpNTcBHVjMyDdNDDx/u8AFfTWTnY=
Received: by mail-vs1-f52.google.com with SMTP id x28so2233437vsh.12
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Jan 2019 03:51:22 -0800 (PST)
X-Gm-Message-State: AJcUukfgiEK5/8yNpnh5sYntmzMLT2c3LJjKD+1PITpsGfbrCwu8nNVP
        xsbRz5EiYBVwv3ORd7emqKUQM572cJVpmSoxsGc=
X-Google-Smtp-Source: ALg8bN4kgueXySRILuodhdC7gowPsDd9qHZJN+eWTOSHlFCu7SuLk6zxkIc6EE2k0iyhAZuUtU89M5B8Tn0Bq4qyOgk=
X-Received: by 2002:a67:3b1b:: with SMTP id i27mr584114vsa.14.1546948281446;
 Tue, 08 Jan 2019 03:51:21 -0800 (PST)
MIME-Version: 1.0
References: <20181213211725.14832-1-fdmanana@kernel.org>
In-Reply-To: <20181213211725.14832-1-fdmanana@kernel.org>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Tue, 8 Jan 2019 11:51:10 +0000
X-Gmail-Original-Message-ID: <CAL3q7H4YhQOe3Hq0nbZ15D_HMesQszGFD1FeV_At9oGG3yLE0A@mail.gmail.com>
Message-ID: <CAL3q7H4YhQOe3Hq0nbZ15D_HMesQszGFD1FeV_At9oGG3yLE0A@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: avoid deadlock with memory reclaim due to
 allocation of devices
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
Cc:     David Sterba <dsterba@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 13, 2018 at 9:18 PM <fdmanana@kernel.org> wrote:
>
> From: Filipe Manana <fdmanana@suse.com>
>
> Several places allocate a device while holding the device list mutex. This
> can result in a deadlock if reclaim happens because the device, and its
> flush bio, are allocated using GFP_KERNEL mode (by __alloc_device() which
> is used by btrfs_alloc_device()). A transaction commit, which reclaim can
> trigger, needs to lock the device list mutex in its critical section, done
> at btrfs_update_commit_device_size().
>
> Some of these places are device_list_add(), which ends up being called
> through the device scan ioctl, and btrfs_close_one_device(), which ends up
> being called through the device remove ioctl.
>
> Since all the places that add elements to the list of resized devices (the
> device grow and shrink functions) only lock the chunk mutex before adding
> a device to the list, drop the need to acquire the device list mutex from
> btrfs_update_commit_device_size(), which is the only other place that uses
> this list and it already locks the chunk mutex.
>
> Fixes: 78f2c9e6dbb14 ("btrfs: device add and remove: use GFP_KERNEL")
> Fixes: e0ae999414238 ("btrfs: preallocate device flush bio")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Ping.

> ---
>  fs/btrfs/volumes.c | 8 ++------
>  fs/btrfs/volumes.h | 1 +
>  2 files changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index c872adfc939e..74c4ed29e36e 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -176,7 +176,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>   * chunk_mutex
>   * -----------
>   * protects chunks, adding or removing during allocation, trim or when a new
> - * device is added/removed
> + * device is added/removed, and the list of resized devices at struct
> + * btrfs_fs_info::fs_devices::resized_devices
>   *
>   * cleaner_mutex
>   * -------------
> @@ -7298,10 +7299,6 @@ void btrfs_update_commit_device_size(struct btrfs_fs_info *fs_info)
>         struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
>         struct btrfs_device *curr, *next;
>
> -       if (list_empty(&fs_devices->resized_devices))
> -               return;
> -
> -       mutex_lock(&fs_devices->device_list_mutex);
>         mutex_lock(&fs_info->chunk_mutex);
>         list_for_each_entry_safe(curr, next, &fs_devices->resized_devices,
>                                  resized_list) {
> @@ -7309,7 +7306,6 @@ void btrfs_update_commit_device_size(struct btrfs_fs_info *fs_info)
>                 curr->commit_total_bytes = curr->disk_total_bytes;
>         }
>         mutex_unlock(&fs_info->chunk_mutex);
> -       mutex_unlock(&fs_devices->device_list_mutex);
>  }
>
>  /* Must be invoked during the transaction commit */
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index aefce895e994..362574b9c37a 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -229,6 +229,7 @@ struct btrfs_fs_devices {
>         struct mutex device_list_mutex;
>         struct list_head devices;
>
> +       /* protected by struct btrfs_fs_info::chunk_mutex */
>         struct list_head resized_devices;
>         /* devices not currently being allocated */
>         struct list_head alloc_list;
> --
> 2.11.0
>
