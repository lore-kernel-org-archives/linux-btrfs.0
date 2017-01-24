Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:35929 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750829AbdAXKW6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 05:22:58 -0500
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1485248507-6079-1-git-send-email-borntraeger@de.ibm.com>
References: <20161126134638.GA79987@clm-mbp.masoncoding.com> <1485248507-6079-1-git-send-email-borntraeger@de.ibm.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Tue, 24 Jan 2017 10:22:57 +0000
Message-ID: <CAL3q7H4Y08K4fgBe3k3r_P+YikN_z=3H1H+T6zMYJ+pAS99wzw@mail.gmail.com>
Subject: Re: [PATCH 0/1] btrfs lockdep annotation
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Chris Mason <clm@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 24, 2017 at 9:01 AM, Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
> Chris,
>
> since my bug report about this did not result in any fix and since

It was fixed and the fix landed in 4.10-rc4:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=781feef7e6befafd4d9787d1f7ada1f9ccd504e4

> this disables lockdep before the the code that I want to debug runs
> here is my attempt to fix it.
> Please double check if the subclass looks right. It seems to work
> for me but I do not know enough about btrfs to decide if this is
> right or not.
>
> Christian Borntraeger ():
>   btrfs: add lockdep annotation for btrfs_log_inode
>
>  fs/btrfs/tree-log.c    | 2 +-
>
> --
> 2.7.4
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
