Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:35051 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932426AbcJMN7Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Oct 2016 09:59:25 -0400
Received: by mail-io0-f195.google.com with SMTP id p26so4965406ioo.2
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Oct 2016 06:58:02 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1476356653-22839-1-git-send-email-robbieko@synology.com>
References: <1476356653-22839-1-git-send-email-robbieko@synology.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Thu, 13 Oct 2016 12:49:05 +0100
Message-ID: <CAL3q7H5M0FWhS62C0ptQqkmkRGK7vP2QrT8q13eb+3B5zY_H6w@mail.gmail.com>
Subject: Re: [PATCH 0/4] Btrfs: add serval test case for incremental send
To: robbieko <robbieko@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 13, 2016 at 12:04 PM, robbieko <robbieko@synology.com> wrote:
> From: Robbie Ko <robbieko@synology.com>
>
> Patch for test btrfs incremental send.
>
> Robbie Ko (4):
>   btrfs: add test for an incremental send don't skip overwrite ref for
>     inode 256
>   btrfs: add test for an incremental send add gen for is_waiting_for_rm
>     when some corner case
>   btrfs: add test for an incremental send add gen check in
>     did_overwrite_ref
>   btrfs: add test for an incremental send add gen check in
>     will_overwrite_ref

These should go to fstests@vger.kernel.org with
linux-btrfs@vger.kernel.org in cc.

Those patch subjects and change logs are too implementation specific.
They should be understandable by non developers (like QA people for
e.g.), think about it.
Do you think such people know what is is_waiting_for_rm,
did_overwrite_ref, "gen", etc?

You should take a look at git history and see subjects and change logs.
Both should say what is being tested, not the problems with code
functions and how you solved them.

Also please, if you are copy-pasting tests, don't leave me as the
author there nor the SUSE copyright.

>
>  tests/btrfs/131     | 110 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/131.out |   2 +
>  tests/btrfs/132     | 116 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/132.out |   2 +
>  tests/btrfs/133     | 120 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/133.out |   2 +
>  tests/btrfs/134     | 121 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/134.out |   2 +
>  tests/btrfs/group   |   4 ++
>  9 files changed, 479 insertions(+)
>  create mode 100755 tests/btrfs/131
>  create mode 100644 tests/btrfs/131.out
>  create mode 100755 tests/btrfs/132
>  create mode 100644 tests/btrfs/132.out
>  create mode 100755 tests/btrfs/133
>  create mode 100644 tests/btrfs/133.out
>  create mode 100755 tests/btrfs/134
>  create mode 100644 tests/btrfs/134.out
>
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"People will forget what you said,
 people will forget what you did,
 but people will never forget how you made them feel."
