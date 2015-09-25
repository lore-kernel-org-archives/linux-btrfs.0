Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:34760 "EHLO
	mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834AbbIYMar (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 08:30:47 -0400
Received: by vkhf67 with SMTP id f67so55019861vkh.1
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2015 05:30:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1443106023-2158-1-git-send-email-jbacik@fb.com>
References: <1443106023-2158-1-git-send-email-jbacik@fb.com>
Date: Fri, 25 Sep 2015 14:30:46 +0200
Message-ID: <CAHji153OssW8n0ukTeiYk+2dgSmB0Wcfzy=b7P5fnh370929bg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: add a flags field to btrfs_transaction
From: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
To: Josef Bacik <jbacik@fb.com>
Cc: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Followup from my observation wrt. "Btrfs: change how we wait for
pending ordered extents" and balance sitting idle:

On Thu, Sep 24, 2015 at 4:47 PM, Josef Bacik <jbacik@fb.com> wrote:
> I want to set some per transaction flags, so instead of adding yet another int
> lets just convert the current two int indicators to flags and add a flags field
> for future use.  Thanks,

..snip..

> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index ff64689..3f5a781 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1399,7 +1399,7 @@ again:
>                 btrfs_error(root->fs_info, ret,
>                             "Failed to remove dev extent item");
>         } else {
> -               trans->transaction->have_free_bgs = 1;
> +               set_bit(BTRFS_TRANS_DIRTY_BG_RUN, &trans->transaction->flags);

Judging from the rest of the code transformation TRANS_DIRTY_BG_RUN
seems like the wrong bit to set here. A quick test with
set_bit(BTRFS_TRANS_HAVE_FREE_BGS) confirms that it fixes the balance
delays.

cheers
Holger
