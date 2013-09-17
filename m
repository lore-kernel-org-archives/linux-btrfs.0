Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:33327 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab3IQHWw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Sep 2013 03:22:52 -0400
Received: by mail-ie0-f173.google.com with SMTP id ar20so9635986iec.32
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Sep 2013 00:22:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1379343489-20066-1-git-send-email-ross.kirk@gmail.com>
References: <1379343489-20066-1-git-send-email-ross.kirk@gmail.com>
Date: Tue, 17 Sep 2013 01:22:52 -0600
Message-ID: <CAE5mzvjphCOj9OcGrd3WpQ36NxxMhOFArMVzu9kYJ6xQs3bc0w@mail.gmail.com>
Subject: Re: [PATCH] Drop unused parameter from btrfs_item_nr
From: cwillu <cwillu@cwillu.com>
To: Ross Kirk <ross.kirk@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 16, 2013 at 8:58 AM, Ross Kirk <ross.kirk@gmail.com> wrote:
> Unused parameter cleanup
>
> Ross Kirk (1):
>   btrfs: drop unused parameter from btrfs_item_nr
>
>  fs/btrfs/backref.c    |    2 +-
>  fs/btrfs/ctree.c      |   34 +++++++++++++++++-----------------
>  fs/btrfs/ctree.h      |   13 ++++++-------
>  fs/btrfs/dir-item.c   |    2 +-
>  fs/btrfs/inode-item.c |    2 +-
>  fs/btrfs/inode.c      |    4 ++--
>  fs/btrfs/print-tree.c |    2 +-
>  fs/btrfs/send.c       |    4 ++--
>  8 files changed, 31 insertions(+), 32 deletions(-)
>
> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Something appears to be missing...
