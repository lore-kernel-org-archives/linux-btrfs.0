From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: fix sync subvol/snapshot creation
Date: Thu, 09 Dec 2010 21:11:29 -0500
Message-ID: <1291947062-sup-3515@think>
References: <1291941388-17050-1-git-send-email-sage@newdream.net> <4D018C4D.6060408@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: Sage Weil <sage@newdream.net>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D018C4D.6060408@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Li Zefan's message of 2010-12-09 21:11:25 -0500:
> Sage Weil wrote:
> > We were incorrectly taking the async path even for the sync ioctls by
> > passing in &transid unconditionally.
> > 
> 
> Ha, I fixed this accidentally in my patchset. :)

Thanks guys,

Unless either of you object, I'll take this and the snapshot ABI change
for the next rc.

-chris
