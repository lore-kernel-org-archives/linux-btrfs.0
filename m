Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:60216 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbaJCPq2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Oct 2014 11:46:28 -0400
Received: by mail-ob0-f169.google.com with SMTP id m8so1071363obr.14
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Oct 2014 08:46:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1412348066-6284-1-git-send-email-jbacik@fb.com>
References: <1412348066-6284-1-git-send-email-jbacik@fb.com>
Date: Fri, 3 Oct 2014 10:46:27 -0500
Message-ID: <CAKcLGm-1Qy7uh6sFPQKD7r5qvc=NiK=KhieV+Zay-uT-Z3n23A@mail.gmail.com>
Subject: Re: [PATCH] Btrfs-progs: make fsck deal with bogus items
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 3, 2014 at 9:54 AM, Josef Bacik <jbacik@fb.com> wrote:
> We can deal with corrupt items by deleting them in a few cases.  Fsck can easily
> recover from a missing extent item or a dir index item.  So if we notice a item
> is completely bogus and it is of a key that we know we can repair then just
> delete it and carry on.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  cmds-check.c                             |  45 +++++++++++++++++++++++++++++++
>  tests/fsck-tests/005-bad-item-offset.img | Bin 0 -> 398336 bytes
>  2 files changed, 45 insertions(+)
>  create mode 100644 tests/fsck-tests/005-bad-item-offset.img
>

It looks like tests/fsck-tests/005-bad-item-offset.img was added
unintentionally to this patch.
