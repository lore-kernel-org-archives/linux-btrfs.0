Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:34689 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbbFDNEk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jun 2015 09:04:40 -0400
Received: by igbhj9 with SMTP id hj9so14800196igb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jun 2015 06:04:39 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1433416690-19177-1-git-send-email-robbieko@synology.com>
References: <1433416690-19177-1-git-send-email-robbieko@synology.com>
Date: Thu, 4 Jun 2015 14:04:39 +0100
Message-ID: <CAL3q7H6=28M29Fssz1MNt4xxoWUQ_GggJUOWiNwMBqFE4o1O4g@mail.gmail.com>
Subject: Re: [PATCH 0/5] Btrfs incremental send fix serval case for rename and
 rm directory
From: Filipe David Manana <fdmanana@gmail.com>
To: Robbie Ko <robbieko@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 4, 2015 at 12:18 PM, Robbie Ko <robbieko@synology.com> wrote:
> Patch for fix btrfs send receive. These patches base on v4.1-rc6-49-g8a7deb3
> plus following patches.
> [PATCH] Btrfs: incremental send, don't delay directory renames unnecessarily
> [PATCH] Btrfs: incremental send, check if orphanized dir inode needs delayed rename
>
> Thanks.
>
> Robbie Ko (5):
>   Btrfs: incremental send, avoid circular waiting and descendant
>     overwrite ancestor need to update path
>   Btrfs: incremental send, avoid ancestor rename to descendant
>   Btrfs: incremental send, fix orphan_dir_info not completely cleared
>   Btrfs: incremental send, fix rmdir but dir have a unprocess item
>   Btrfs: incremental send, fix rmdir not send utimes
>
>  fs/btrfs/send.c | 163 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 149 insertions(+), 14 deletions(-)

Thanks for doing this, a quick look over all the patches and they seem
ok, just some minor comments later.

Would you be willing to submit test cases for xfstests that cover all
these cases?
We don't want to get regressions in the future, and this particular
part of send is complex and messy, being easy to break it for some use
cases without noticing it, and xfstests [1] is the test suite
developers (and some QA people) use to validate their changes and
verify they aren't introducing regressions.

[1] https://git.kernel.org/cgit/fs/xfs/xfstests-dev.git/log/ and
mailing list: fstests@vger.kernel.org

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
