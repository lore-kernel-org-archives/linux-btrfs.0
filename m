Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:36902 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbbFWPfl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jun 2015 11:35:41 -0400
Received: by igblr2 with SMTP id lr2so14482774igb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2015 08:35:40 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1435055991-10109-1-git-send-email-robbieko@synology.com>
References: <1435055991-10109-1-git-send-email-robbieko@synology.com>
Date: Tue, 23 Jun 2015 16:35:40 +0100
Message-ID: <CAL3q7H6RLd4bAQ+V01Ore8e-ehYJw_Wg2HOBAwQGhuUV40j+4w@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] Btrfs incremental send fix serval case for rename
 and rm directory
From: Filipe David Manana <fdmanana@gmail.com>
To: Robbie Ko <robbieko@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 23, 2015 at 11:39 AM, Robbie Ko <robbieko@synology.com> wrote:
> Patch for fix btrfs send receive. These patches base on v4.1
> plus following patches.
> [PATCH] Btrfs: incremental send, don't delay directory renames unnecessarily
> [PATCH] Btrfs: incremental send, check if orphanized dir inode needs delayed rename
>
> Thanks.
>
> Robbie Ko (7):
>   Revert "Btrfs: incremental send, remove dead code"
>   Btrfs: incremental send, avoid circular waiting and descendant
>     overwrite ancestor need to update path
>   Btrfs: incremental send, avoid ancestor rename to descendant
>   Btrfs: incremental send, fix orphan_dir_info leak
>   Btrfs: incremental send, fix rmdir but dir have a unprocess item
>   Btrfs: incremental send, don't send utimes for non-existing directory
>   Btrfs: incremental send, avoid the overhead of allocating an
>     orphan_dir_info object unnecessarily

Robbie,

Are you considering sending test cases for fstests for the patches 2
(all 3 examples in the commit message), 3 and 5?

Let me know if you want any assistance making those tests.
Thanks.

>
>  fs/btrfs/send.c | 179 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 165 insertions(+), 14 deletions(-)
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

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
