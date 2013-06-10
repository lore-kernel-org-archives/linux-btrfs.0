Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:54907 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab3FJIMt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 04:12:49 -0400
Message-ID: <51B58A7F.3060101@jan-o-sch.net>
Date: Mon, 10 Jun 2013 10:12:47 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>
Subject: Re: [PATCH 0/3] Btrfs: qgroup rescan fixes for next rc
References: <1369756044-17194-1-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1369756044-17194-1-git-send-email-list.btrfs@jan-o-sch.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

I know, Linus is turning grumpy again. I'd still feel better if we sent this
patch set for the very next rc now. Any particular objections?

-Jan

On Tue, May 28, 2013 at 17:47 (+0200), Jan Schmidt wrote:
> Here are three fixes for the new qgroup rescan feature. The first two
> are quite small, the third one is a little bigger. I thought about
> splitting that one up, but in the end I didn't find a good point to
> break that up. It achieves more than one goal, I agree, but its more or
> less a compact code change that need not be split artifically in my
> opinion.
> 
> Jan Schmidt (3):
>   Btrfs: fix memory patcher through fs_info->qgroup_ulist
>   Btrfs: avoid double free of fs_info->qgroup_ulist
>   Btrfs: fix qgroup rescan resume on mount
> 
>  fs/btrfs/ctree.h   |    2 +
>  fs/btrfs/disk-io.c |    2 +
>  fs/btrfs/qgroup.c  |  198 +++++++++++++++++++++++++++++++++-------------------
>  3 files changed, 131 insertions(+), 71 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
