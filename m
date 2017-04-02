Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from demfloro.ru ([188.166.123.212]:38580 "EHLO demfloro.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751460AbdDBOqq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 2 Apr 2017 10:46:46 -0400
Received: from [81.95.28.29] (helo=job)
        by demfloro.ru with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.88)
        (envelope-from <demfloro@demfloro.ru>)
        id 1cugmA-0002e6-UA
        for linux-btrfs@vger.kernel.org; Sun, 02 Apr 2017 14:46:43 +0000
Date: Sun, 2 Apr 2017 17:46:29 +0300
From: Dmitrii Tcvetkov <demfloro@demfloro.ru>
To: linux-btrfs@vger.kernel.org
Subject: Re: force btrfs to release underlying block device(s)
Message-ID: <20170402174629.309b2fb6@job>
In-Reply-To: <pan$1f835$afcb2bc1$54acc19$51819f9d@cox.net>
References: <20170401005819.46dd9442@crass-Ideapad-Z570>
        <pan$1f835$afcb2bc1$54acc19$51819f9d@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Tho another part of that patchset, the per-chunk availability check
> for degraded filesystems that allows writable mount of multi-device 
> filesystems with single chunks, etc, as long as all chunks are
> available, has seen renewed activity recently as the problem it
> addresses, formerly two-device raid1 filesystems going read-only
> after one degraded-writable mount, has become an increasingly
> frequently list-reported problem.  That smaller patchset has I
> believe now been review and is I believe now in btrfs-next, scheduled
> for merge in 4.12.

Unfortunately I couldn't find it not in btrfs-next nor linux-next
branches. The last version 3.1 of the patch was published[1] 08.03.2017. 

Qu Wenruo was going[2] to update the patch but that didn't happen yet.

[1] https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg62255.html
[2] https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg62302.html
